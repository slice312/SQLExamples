USE BookLibrary;
GO


exec dbo.GetBook N'Приключение Буратино', N'Маяцкий Егор';
exec dbo.GetBook N'Приключение Буратино', N'Лукьянов Семен';
exec dbo.GetBook N'Гарри Поттер', N'Рахимов Алик';

exec dbo.ReturnBook N'Приключение Буратино', N'Маяцкий Егор';
exec dbo.ReturnBook  N'Приключение Буратино', N'Лукьянов Семен';
exec dbo.ReturnBook N'Гарри Поттер', N'Рахимов Алик';

exec dbo.BooksByAuthor 'Лев', 'Толстой';
exec dbo.BooksByAuthor 'Андерсен', 'Христиан';

exec dbo.ClearOldHistory;

exec dbo.ShowPromisers;