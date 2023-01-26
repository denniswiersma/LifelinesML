# LifelinesML
R shiny application made for the Honours Lab "From stupid data to intelligent Solutions" at Hanze University of Applied Sciences. Course taken in academic year of 22/23.

A running version of this project can be found at [lifelinesml.denniswiersma.com](https://lifelinesml.denniswiersma.com/)

## Usage

### Getting the code
#### Clone repository
To clone the code found in this repository make sure you have installed [git](https://git-scm.com/), open up your favorite terminal, navigate to your desired folder and run the command below:
```Bash
git clone https://github.com/denniswiersma/LifelinesML
```

#### Zip file
In case you'd like a simple ZIP file containing the project's files you first navigate to this project's [GitHub page](https://github.com/denniswiersma/LifelinesML).
Find the green button labeled `Code`, click it, and click `Download ZIP`.

### Dataset
The dataset used for this project was acquired from the Lifelines research group and can be found [here](https://www.lifelines.nl/researcher/data-and-biobank/education).
This application uses the `complete` dataset called `Participants_Aggregated_Age` in `CSV` format.
A file called `Participants_Aggregated_Age.csv` containing the relevant data should therefore be placed in the project's root folder for the application to work.

### R packages
The application relies upon the following R packages:
- shiny
- shinythemes
- shinyjs
- ggplot2
- corrplot

You should install them before running the application by running the following command in your R console:
```R
install.packages(c("shiny", "shinythemes", "shinyjs", "ggplot2", "corrplot"))
```

### Running the app
#### Rstudio
Once the dataset is in place, running the application through Rstudio is rather easy. Simply open the project in Rstudio, open the App.R file, and click the `Run App` button.

#### Terminal
Running the application through your terminal of choice is possible as well. Simply navigate to the project root and run the following command:   
```Bash
 R -e "shiny::runApp('LifelinesML')"
 ```

#### Docker container
To build a Docker image of this application make sure you have a fully working installation of [Docker](https://www.docker.com/get-started/).
Then open up your favourite terminal, navigate to this project's root folder, and run the following command:
```Bash
docker build -t lifelines_ml ../LifelinesML
```
Once the building project finishes, you may run a container using:
```Bash
docker run --name=lifelines_ml --rm -p 3838:3838 lifelines_ml
```
You may now use the application in your favourite browser at `http://localhost:3838/`