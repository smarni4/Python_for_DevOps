"""
Python Extract Transform and Load Example
"""
import pandas
# Required packages

import requests
import pandas as pd
from sqlalchemy import create_engine

web_url = "http://universities.hipolabs.com/search?country=United+States"
state_name = 'New York'

class etl:
    def __init__(self, url: str):
        self.url = url

    def extract(self) -> dict:
        """
        This function extracts universities from the provided web_url
        """
        data = requests.get(url=self.url).json()
        return data

    def transformation(self, data: dict, state=state_name) -> pd.DataFrame:
        """
        Transforms the dataset into desired structure and apply filters

        :param data: Data extracted from the web_url
        :param state: Name of the state you want to look for universities'
        :return: List of universities in the given state.
        """

        df = pd.DataFrame(data)
        # univ_count = len(data)
        df = df[df['state-province'] == state]
        # df = df[["name", "alpha_two_code", "state-province"]]
        # print(df["domains"])
        df['domains'] = [','.join(map(str, domain)) for domain in df['domains']]
        # print(df["domains"])
        df['web_pages'] = [','.join(map(str, domain)) for domain in df['web_pages']]
        df = df.reset_index(drop=True)
        return df[['domains', 'country', 'web_pages', 'name']]

    def load(self, df: pandas.DataFrame) -> None:
        """
        Loads data into a sqlite database
        :param df: Dataframe you want to load
        :return: None
        """
        disk_engine = create_engine('sqlite:///my_lite_store.db')
        df.to_sql(f'{state_name}_univ', disk_engine, if_exists='replace')


ex1 = etl(web_url)
# print(ex1.extract())
data = ex1.extract()
print(ex1.transformation(data, "New York"))
ex1.load(ex1.transformation(data, state_name))
