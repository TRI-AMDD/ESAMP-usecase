Filename                    Description
--------------------------  ---------------------------------------------------

This work is a collaborative effort between California Institute of Technology, Toyota Research Institute, and Modelyst LLC.

Authors: Dan Guevarra, Michael J. Statt, Brian A. Rohr, John M. Gregoire, and Santosh K. Suram


File Descriptions:
conda_env.yml               - conda environment yaml for running query_and_modeling.ipynb
eche_foms_query.sql         - retrieves sample info and eche analysis foms
eche_pets_query.sql         - retrieves eche & pets sample-processes
myquaternaryutility.py      - utility functions for quaternary comp space plots
myternaryutility.py         - utility functions for ternary comp space plots
quaternary_faces_shells.py  - ternary shells plot class (Fig 5b,c,d)
query_and_modeling.ipynb    - query execution, modeling, and plotting notebook


Tested on conda 23.3.1
https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh


Environment setup and notebook usage
-------------------------------------
> conda env create -f conda_env.yml
> conda activate esamp
> jupyter lab
