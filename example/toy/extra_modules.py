import glog as log
from src.modules import Module

class Sample(Module):

    def __init__(self, module_id, name, rabbitmq_host, pipeline_conf, module_conf, **kwargs):
        super().__init__(module_id, name, rabbitmq_host, pipeline_conf, module_conf, **kwargs)

    def process(self, job, data):

        log.debug(job)
        result = [x + ' processed by ' + self.name + ', params ' + str(job.params) for x in data['string_list']]
        data['string_list'] = result
        log.debug(data)

        return data
