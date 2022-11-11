chsh -s /bin/zsh
clear
cd ~/
ls
mkdir -p data/beetroot/experiments
aws s3 cp s3://qm-beetroot-dataset-extern/2d_bbox/batch_2 data/beetroot/experiments/ --recursive
open data/beetroot/experiments/
aws s3 cp s3://qm-beetroot-dataset-extern/2d_bbox/sample_data data/beetroot/experiments/ --recursive
aws s3 cp s3://qm-beetroot-dataset-extern/2d_bbox/sample_data data/beetroot/experiments/ --recursive
aws s3 cp s3://qm-beetroot-dataset-extern/2d_bbox/ data/beetroot/experiments/ --recursive
pip --help
clear
clear
clear
which go
env
env | grep GO
cd repos/qm/goliat/
go install github.com/rakyll/gotest@v0.0.6
go install github.com/rakyll/gotest@v0.0.6
go install github.com/joho/godotenv/cmd/godotenv@v1.3.0
make build
ls
cd goliat/
ls
make build
docker --version
docker --version
docker run hello-world
clear
tmux
env
vim .zshenv 
vim .zshenv 
cd repos/qm/goliat/goliat
cd repos/qm/goliat
clear
echo $SHELL
clear
vim ~/.tmux.conf 
vim ~/.zshenv
clear
pwd
cd ..
ls
ls
clear
git checkout -b at/fn-pipeline
clear
ls
git status
mkdir /data/false_negatives_pl
mkdir ~/data/false_negatives_pl
aws s3 cp s3://qm-pipeline-builder ~/data/false_negatives_pl --recursive`
aws s3 cp s3://qm-pipeline-builder ~/data/false_negatives_pl --recursive
clear
ls
cat my.db
clear
cd ~/data/false_negatives_pl/
ls
vim 
vim 
vim 
docker stats
docker run --name redis-local -p 6379:6379 -d redis
./server
cd repos/qm/goliat/goliat
./server
cp .test_env .env
./server
clear
cd ..
ls
ls -a
cp .env_example .env
docker-compose up
docker-compose stop
clear
docker stop 91c
docker-compose up
vim docker-compose.yml 
