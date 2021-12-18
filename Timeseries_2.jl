# Pacotes 
# Instalando pacotes
#using Pkg
#Pkg.add("MessyTimeSeries")           
#Pkg.add("XLSX")                      
#Pkg.add("DataFrames")
#Pkg.add("Plots")
#Pkg.add("HypothesisTests")
#Pkg.add("StatsBase")
#Pkg.add("PyCall")


# Importando os pacotes 
using XLSX                          # Importação de arquivos Excel
using MessyTimeSeries               # Series Temporais
using DataFrames                    # Manipulação de tabelas 
using Plots                         # Criando graficos 
using Statistics                    # Funções estatisticas 
using HypothesisTests               # Conjunto de testes de hipoteses
using StatsBase                     # Correlogramas
using PyCall                        # Importando o ambiente python 

# Importando os dados 
dados = DataFrame(XLSX.readtable("dados_trabalho_empirico_1.xlsx","Planilha1")...)

# Criando a serie temporal 
serie = convert(Array{Float64,1},dados[!,"378237"])

# Criando um array com a media 
media = fill(mean(serie),length(serie))

# Criando uma sequencia de valores para sazonalidade
sazonalidade_tri = [1:4:length(serie);]
sazonalidade_qua = [1:3:length(serie);]
sazonalidade_sem = [1:6:length(serie);]
sazonalidade_anu = [1:12:length(serie);]

# 1 - Criando grafico da serie temporal 
# 1.1 - Sazonalidade - quadrimestral
quadrimestral=plot(serie,line=(0.5, 3),label = "Serie Temporal")
plot!(media,line=(0.5,3),label = "Media da Serie")
plot!(sazonalidade_qua,seriestype="vline", label = "Sazonaliade")
savefig(quadrimestral,"sazonalidade_quadrimestral.png")

# 1.2 - Sazonalidade - trimestral
trimestral=plot(serie,line=(0.5, 3),label = "Serie Temporal")
plot!(media,line=(0.5,3),label = "Media da Serie")
plot!(sazonalidade_tri,seriestype="vline", label = "Sazonalidade")
savefig(trimestral,"sazonalidade_trimestral.png")

# 1.3 - Sazonalidade - Semestral
Semestral=plot(serie,line=(0.5, 3),label = "Serie Temporal")
plot!(media,line=(0.5,3),label = "Media da Serie")
plot!(sazonalidade_sem,seriestype="vline",label = "Sazonalidade")
savefig(Semestral,"sazonalidade_semestral.png")

# 1.4 - Sazonlaidade - Anual 
anual=plot(serie,line=(0.5, 3),label = "Serie Temporal")
plot!(media,line=(0.5,3),label = "Media da Serie")
plot!(sazonalidade_anu,seriestype="vline",label = "Sazonalidade")
savefig(anual,"sazonalidade_anual.png")


# 2 - Teste  ADF 
# 2-1 None 
teste_none = ADFTest(serie,:none,1)

# 2-2 Constant 
teste_constant = ADFTest(serie,:constant,1)

# 2-3 Trend 
teste_trend = ADFTest(serie,:trend,1)

# 2-4 Squared_trend 
teste = ADFTest(serie,:squared_trend,1)


# 3 Correlograma 
trash_up = fill(0.25,32)
trash_down = fill(-0.25,32)

# 3-1 FAC 
cor_1=bar(autocor(serie,[1:1:32;]),label="Autocorrelação")
plot!(trash_up,label="Trasholder Up")
plot!(trash_down,label="Trasholder Down")
savefig(cor_1,"autocorrelação.png")

# 3-2 FACP
cor_2=bar(pacf(serie,[0:1:29;];method=:regression),label="Autocorrelação Parcial")
plot!(trash_up,label="Trasholder Up")
plot!(trash_down,label="Trasholder Down")
savefig(cor_2,"autocorrelação_parcial.png")


# 4 Estimando arima 
# 4-1 Importando a Função arima do python 
arima = pyimport("statsmodels.tsa.arima.model")

# 4-2 Selecionando o melhor modelo 
d_candidates = [0,1,2]
q_candidates = [0]
modelo = []
results_aic = []
results_bic = []
results_rmse = []
for q in q_candidates
    for d in d_candidates
        model = arima.ARIMA(serie,order=(q,1,d)).fit() 
        append!(modelo,q*100 + 0*10 + d)
        append!(results_aic,model.aic)
        append!(results_bic,model.bic)
        append!(results_rmse,sqrt(model.mse))
    end
end 

selection = Dict("Resultados"=>modelo,"Aic"=>results_aic,"Bic"=>results_bic,"Rmse"=>results_rmse)

# 4-3 Estimando o melhor modelo 
# 4-3-1 Aic
best_model_aic = arima.ARIMA(serie,order=(2,0,2)).fit()
best_model_aic.summary()

# 4-3-2 Bic 
best_model_bic = arima.ARIMA(serie,order=(1,0,1)).fit()
best_model_bic.summary()

# 5 Rmse 
best_model_rmse= arima.ARIMA(serie,order=(5,0,2)).fit()
best_model_rmse.summary()

# 6- Correlograma dos residuos
resid_2 = []
for i in best_model_bic.resid
    append!(resid_2,i^2)
end

resid_2 = convert(Array{Float64,1},resid_2)
# 6-1 FAC 
acor_1=bar(autocor(resid_2,[1:1:29;]),label="Autocorrelação")
plot!(trash_up,label="Trasholder Up")
plot!(trash_down,label="Trasholder Down")
savefig(acor_1,"autocorrelação dos residuos.png")

# 6-2 FACP
acor_2=bar(pacf(resid_2,[1:1:29;];method=:regression),label="Autocorrelação Parcial")
plot!(trash_up,label="Trasholder Up")
plot!(trash_down,label="Trasholder Down")
savefig(acor_2,"autocorrelação parcial dos residuos.png")

