<h1 align=center> Scraping Siops/Datasus</h1>
<h2 align=center> Script para raspagem do Demonstrativo da despesa com saúde </h2>

---

Uma série temporal é uma sequência de realizações (observações) de uma variável ao longo do tempo[1]. Dito de outra forma, é uma sequência de pontos (dados numéricos) em ordem sucessiva, geralmente ocorrendo em intervalos uniformes. Portanto, uma série temporal é uma sequência de números coletados em intervalos regulares durante um período de tempo.

---

## Pre requisitos 

Antes de iniciar, verifique se você atende os seguintes requisitos:

### 1. Necessita da instalação das seguintes ferramentas 
- [Julia 1.7+](https://julialang.org)
- [Python 3.9+](https://www.python.org/downloads/) 

### 2. Instalando os pacotes necessários para o julia
#### 2.1 Instalando o julia no arch linux

```shell
$ sudo pacman -Syyu julia 
```

### 2.2 Instalando os pacotes no julia 
```julia
using Pkg
Pkg.add("MessyTimeSeries")           
Pkg.add("XLSX")                      
Pkg.add("DataFrames")
Pkg.add("Plots")
Pkg.add("HypothesisTests")
Pkg.add("StatsBase")
Pkg.add("PyCall")
```

### 3. Instalando os pacotes no python 
```shell 
pip install statsmodels
```

### 4. Executando o codigo 
```shell
julia Timeseries.jl
```

## Contato 

:bust_in_silhouette: Luiz Alexandre Moreira Barros 

:mailbox_with_mail:	 luizalexandremoreira21@outlook.com

:octocat: https://github.com/LuizAlexandre21

:notebook_with_decorative_cover: http://lattes.cnpq.br/9458204748985902
