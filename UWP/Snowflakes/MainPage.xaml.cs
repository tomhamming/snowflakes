using System;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Media.Animation;
using Windows.UI.Xaml.Media.Imaging;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace Snowflakes
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage
    {
        private readonly Random _random = new Random();
        private int _animationId = 0;

        public MainPage()
        {
            InitializeComponent();
            Loaded += MainPage_Loaded;
        }

        private void MainPage_Loaded(object sender, Windows.UI.Xaml.RoutedEventArgs e)
        {
            AnimateImage(() =>
            {
                var w = _random.Next(20, 60);
                return new Image
                {
                    Width = w,
                    Height = w,
                    Source = new BitmapImage(new Uri("ms-appx:///Assets/flake.png"))
                };
            }, 0.03, 0.12);

            AnimateImage(() =>
            {
                var w = 100;
                return new Image
                {
                    Width = w,
                    Height = w,
                    Source = new BitmapImage(new Uri("ms-appx:///Assets/minion-christmas-joy-14193448014kgn8.png"))
                };
            }, 1, 3);
        }

        private async void AnimateImage(Func<FrameworkElement> image, double minTime, double maxTime) //, Func<double> imgWidth
        {
            await Task.Yield();
            var minWidth = 300;
            var maxWidth = 2560;

            var width = ActualWidth;
            var percentage = (width - minWidth) / (maxWidth - minWidth);
            var myTime = maxTime - percentage * (maxTime - minTime);

            while (true)
            {
                var imageElement = image();
                double w = imageElement.Width;

                var animation = new Storyboard();
                var duration = new Duration(TimeSpan.FromMilliseconds(1000 * (16 + _random.Next() % 9)));

                var resname = $"animation{_animationId++ % 1000000}";
                Resources.Add(resname, animation);


                var transGroup = new TransformGroup();
                imageElement.RenderTransform = transGroup;

                var rotateTransform = new RotateTransform();
                transGroup.Children.Add(rotateTransform);
                animation.Children.Add(AnimateDouble(rotateTransform, nameof(RotateTransform.Angle), 0, _random.Next(-270, 270), duration));

                if (_random.Next() % 2 == 0)
                {
                    transGroup.Children.Add(new ScaleTransform { ScaleX = -1, ScaleY = 1 });
                }

                var moveTransform = new TranslateTransform
                {
                    X = _random.Next((int)(-w / 2), (int)(ActualWidth + w / 2))
                };
                transGroup.Children.Add(moveTransform);
                animation.Children.Add(AnimateDouble(moveTransform, "Y", -w, ActualHeight+w, duration));



                RootCanvas.Children.Add(imageElement);
                animation.Begin();

                EventHandler<object> completion = null;
                completion = (o, e) =>
                {
                    animation.Completed -= completion;
                    Resources.Remove(resname);
                    RootCanvas.Children.Remove(imageElement);
                };
                animation.Completed += completion;

                await Task.Delay((int)(myTime * 1000));
            }

            // ReSharper disable once FunctionNeverReturns
        }

        private DoubleAnimation AnimateDouble(DependencyObject target, string property, double? fromValue, double? toValue, Duration duration)
        {
            var animation = new DoubleAnimation
            {
                From = fromValue,
                To = toValue,
                Duration = duration,
            };

            Storyboard.SetTarget(animation, target);
            Storyboard.SetTargetProperty(animation, property);

            return animation;
        }
    }
}
