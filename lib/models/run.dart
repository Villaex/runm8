

class Run{
  final double distance;
  final Duration duration;

  Run(this.distance, this.duration);

  double _getAverageSpeed(){
    return this.distance/ (this.duration.inSeconds) * 3.6;
  }
}