from locust import HttpLocust, TaskSet, task

class UserBehavior(TaskSet):
    def on_start(self):
        self.login()

    def on_stop(self):
        self.logout()

    def login(self):
        pass

    def logout(self):
        pass

    @task(1)
    def get(self):
        self.client.get("/")


class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 100
    max_wait = 200
