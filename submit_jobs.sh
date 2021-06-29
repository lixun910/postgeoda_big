#aws batch submit-job --job-name nets-4m-8m --job-queue queue-large-ebs --job-definition arn:aws:batch:us-east-2:921974715484:job-definition/job-large-ebs:1 --container-overrides '{"environment" : [{"name" : "RUN_START", "value" : "4000001"}, {"name" : "RUN_END", "value" : "8000000"}]}'

start=1
inc=4000000
n=58861745
jobs=$(($n/$inc))
end=$(($start+$inc-1))


for ((x=0; x<$jobs; ++x)); do
	end=$(($start+$inc-1))
	echo $x, $start, $end
	aws batch submit-job \
		--job-name nets-$start-$end \
		--job-queue queue-large-ebs \
		--job-definition arn:aws:batch:us-east-2:921974715484:job-definition/job-large-ebs:1 \
		--container-overrides '{"environment" : [{"name" : "RUN_START", "value" : "${start}"}, {"name" : "RUN_END", "value" : "${end}"}]}'
	start=$(($end+1))
done

if [[ $end -lt $n ]]
then
	end=$n
	echo $x, $start, $end
	aws batch submit-job \
		--job-name nets-$start-$end \
		--job-queue queue-large-ebs \
		--job-definition arn:aws:batch:us-east-2:921974715484:job-definition/job-large-ebs:1 \
		--container-overrides '{"environment" : [{"name" : "RUN_START", "value" : "${start}"}, {"name" : "RUN_END", "value" : "${end}"}]}'
fi
