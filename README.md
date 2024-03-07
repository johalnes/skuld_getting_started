# Reinsurance Calculation Project

## Overview
This project is dedicated to calculating Reinsurance recoverable and reinsurance premium based on gross claims and premiums within our company. 

It employs DBT (Data Build Tool) for orchestrating the main dataflow, GitHub Actions for continuous integration and deployment tasks such as building and deploying MkDocs sites for documentation, and a Python library encapsulating the core calculations. The project is structured to ensure reusability and consistency across company-wide analytics tasks.

## Architecture
- **DBT**: Manages data transformations and builds data models necessary for reinsurance calculations within our data warehouse. This ensures good development practices, easy to test and live documentation which makes the overall flow understandable.
- **MkDocs**: Provides a framework for building project documentation, ensuring that project insights and methodologies are accessible and well-documented.
- **Python Library**: Encapsulates the logic for reinsurance calculations, designed for easy integration and reuse across various company projects.
- **GitHub Actions**: Automates workflows for testing, building, and deploying documentation changes. Makes it safe for all to make changes and suggestion, with output that points out consequenes of the changes that are done.
- **Anaconda**: Manages Python environments and dependencies to ensure consistency across development and production environments.

## Getting Started

### Prerequisites
- Anaconda installed on your machine.
- Access to the company's data warehouse.
- Access to the company's GitHub repository for this project.

### Installation
1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourcompany/reinsurance-calculation-project.git
    ```
2. **Create and activate a Conda environment**:
    Navigate to the project directory and create a Conda environment using the `environment.yml` file:
    ```bash
    conda env create -f environment.yml
    conda activate reinsurance_calc
    ```
3. **Configure DBT**:
    Set up DBT with your data warehouse credentials following the [DBT documentation](https://docs.getdbt.com/dbt-cli/configure-your-profile).

### Running the Project
1. **DBT Operations**:
    Execute DBT commands to run transformations and generate data models:
    ```bash
    dbt run
    ```
2. **Python Calculations**:
    Utilize the Python library to conduct specific reinsurance calculations:
    ```python
    from reinsurance_calculations import calculate_reinsurance
    calculate_reinsurance()
    ```

## Documentation
Documentation is built using MkDocs and automatically deployed via GitHub Actions to our documentation site. Access the documentation at [https://yourcompany.github.io/reinsurance-calculation-project/](https://yourcompany.github.io/reinsurance-calculation-project/).

To build and serve the documentation locally:
```bash
mkdocs serve
```

## Development Workflow and Contributions
### Contributing
We welcome contributions from all team members. Here are the steps and guidelines for contributing to the project:

1. **Fork and Clone**: Fork the repository and clone it to your local machine.
2. **Create a Feature Branch**: Work on new features or fixes in a separate branch created from the `main` branch.
3. **Small, Understandable Changes**: Keep your changes small and self-contained to make code reviews easier and more effective.

### GitHub Actions Workflow
Our CI/CD pipeline, powered by GitHub Actions, automates several crucial steps:

- **Development Documentation Site**: On every pull request (PR), GitHub Actions automatically creates a temporary development documentation site using MkDocs. This allows reviewers to see changes in documentation in a live environment.
  
- **PR Environment**: GitHub Actions also sets up a PR-specific environment for testing the changes in isolation, ensuring they do not affect the main or production environments.

- **Linting and DBT Tests**: Before a PR can be merged into the `main` branch, it must pass automated linting checks and DBT tests. This ensures that all contributions adhere to our coding standards and that data models are correctly defined and functional.

### Review Process
- **Mandatory Review**: At least one review from a designated reviewer is required for every PR. This ensures that all code is examined and approved by someone other than the author, maintaining code quality and consistency.
  
- **Review Guidelines**: Reviewers will focus on the code's functionality, readability, and integration with existing code. Feedback will be provided through GitHub's PR review feature, and steps are defined in the Pull Request temaplates.

### Merging to Main
- **Passing Checks**: Only PRs that pass all automated checks (linting, DBT tests) and have received at least one approval review can be merged into the `main` branch.
  
- **Final Checks**: The author of the PR should perform a final check to ensure that their changes are ready for production before merging.
