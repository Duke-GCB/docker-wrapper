from distutils.core import setup

setup(
    name='docker-wrapper',
    version='1.0.0',
    packages=['docker-wrapper'],
    scripts=['bin/docker-wrapper.sh'],
    url='https://github.com/Duke-GCB/docker-wrapper',
    license='MIT',
    author='dcl9',
    author_email='dan.leehr@duke.edu',
    description='Checks filesystem access before mounting docker volumes'
)
