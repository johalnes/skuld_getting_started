# Getting Started

This project is a getting started guide for using best practices and DBT in the context of risk analytics. It follows the tasks and text from the [Risk Analytics Docs](https://risk-analytics-docs.azurewebsites.net/reinsurance/) (Skuld employes only).

## Why Data Science is Like Building Software

Imagine data science not just as digging through numbers or dealing with statistics, but as crafting a special kind of software. Much like developing an app or a website, data science involves several steps—outlining your goals, gathering your data, analyzing it, and then sharing those insights. Interestingly, the methodologies and best practices used in software development are incredibly beneficial for data scientists too.

In both arenas, the aim is to create work that's understandable, usable, and capable of being enhanced by others. This involves writing clean code, tracking modifications, and ensuring everything functions as expected, every time.

## The Significance of Standardization in a Company

In the dynamic world of data and software development, having set standards within a company is not just beneficial—it's essential. These standards serve as a common language, ensuring consistency, efficiency, and quality across teams and projects. They streamline processes, reduce errors, and facilitate smoother onboarding for new team members. Moreover, standards in data modeling, naming conventions, and code formatting lead to more maintainable and scalable projects.

Adhering to these agreed-upon practices not only enables teams to work more collaboratively and innovatively but also brings a multitude of additional benefits "for free". These benefits will hopefully become clear through the following tasks.

## Usage

This project is self contained. Just press Code and start a codespace! When the codespace is ready and environment is installed, just type the following to run DBT:
```bash
cd transform
dbt build
dbt docs generate
```
and write `dbt docs serve` to see the project site.

## Shoutout to

- Winni's [Octocatalog] (https://github.com/gwenwindflower/octocatalog/tree/main) for structure and best practices
- John S Bogaardt [Chainladder](https://github.com/casact/chainladder-python) for data
