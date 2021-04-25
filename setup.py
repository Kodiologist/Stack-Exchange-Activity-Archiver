import setuptools, ast

with open('README.rst', 'r') as o:
    long_description = o.read()

with open('stack_archiver/_version.py', 'r') as o:
    version = ast.literal_eval(ast.parse(o.read()).body[0].value)

setuptools.setup(
    name = 'stack_archiver',
    version = version,
    author = 'Kodi B. Arfer',
    description = 'Archive your activity on Stack Exchange sites',
    long_description = long_description,
    long_description_content_type = 'text/x-rst',
    project_urls = {
        "Source Code": 'https://github.com/Kodiologist/Stack-Exchange-Activity-Archiver'},
    python_requires = '>=3.8',
    dependency_links = [
        'http://github.com/hylang/hy/tarball/e35b84bce7befdf5caf347110111481e19956877#egg=hy-ge35b84bc'],
    packages = setuptools.find_packages(),
    package_data = {
        'stack_archiver': ['*.hy', '__pycache__/*'],
    },
    classifiers = [
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
        'Operating System :: OS Independent'])
