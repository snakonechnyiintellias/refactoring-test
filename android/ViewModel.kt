import android.app.Activity
import android.os.Bundle
import android.os.PersistableBundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.lifecycle.ViewModel
import androidx.lifecycle.coroutineScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.cricut.image_upload.ui.R
import kotlinx.coroutines.launch

/**
 * BookListViewModel.kt
 * @author John Doe
 * Created on 12.12.2022
 * Copyright © 2022 Intellias. All rights reserved.
 */

data class Book(
    var name: String,
    var description: String,
    var genre: String,
    var pageNumber: Int,
    var rating: Float,
)

class BookListViewModel : ViewModel() {

    private var _books = mutableListOf<Book>()
    val books: List<Book>
        get() = _books

    suspend fun loadBooks() = kotlin.runCatching {
        _books = BookLoader.loadBooks()
    }
}

class BooksActivity : Activity() {

    private val viewModel by viewModels<BookListViewModel>

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        setContentView(R.layout.fragment_books)
    }

    override fun onResume() {
        super.onResume()
        lifecycle.coroutineScope.launch {
            val books = viewModel.loadBooks()
            displayBooks(books)
            showNotification(books)
        }
    }

    private fun displayBooks(books: List<Book>) {
        val mRecyclerView = findViewById<RecyclerView>(R.id.recycler_view)
        mRecyclerView.setLayoutManager(LinearLayoutManager(this))
        mRecyclerView.setAdapter(object : RecyclerView.Adapter<BookViewHolder>() {

            override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) : BookViewHolder {
                val v = LayoutInflater.from(parent.getContext()).inflate(
                    android.R.layout.simple_list_item_1,
                    parent,
                    false)
                val vh = BookViewHolder(v)
                return vh
            }

            override fun onBindViewHolder(vh: BookViewHolder, position: Int) {
                vh.name.setText(books[position].name)
                vh.description.setText(createDescription(books[position]))

            }

            override fun getItemCount(): Int {
                return books.size
            }
        })
    }

    fun createDescription(book: Book) : String {
        return "Description: ${book.description}, Genre: ${book.genre}, Rating: ${book.rating}"
    }

    class BookViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val name = view.findViewById<TextView>(R.id.title)
        val description = view.findViewById<TextView>(R.id.description)
    }

    private fun showNotification(books: List<Books>) {
        var builder = NotificationCompat.Builder(this, "CHANNEL_ID")
            .setSmallIcon(R.drawable.notification_icon)
            .setContentTitle("App notification")
            .setContentText("Loaded books...")
            .setStyle(NotificationCompat.BigTextStyle()
                .bigText("Loaded ${books.size} books..."))
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
        with(NotificationManagerCompat.from(this)) {
            // notificationId is a unique int for each notification that you must define
            notify(notificationId, builder.build())
        }
    }
}

object BookLoader {

    suspend fun loadBooks(): MutableList<Book> {
        return RetrofitBuilder.apiService.getBooks()
    }
}

interface ApiService {
    @GET("api/users")
    suspend fun getBooks(): List<Book>
}

object RetrofitBuilder {

    private const val BASE_URL = "https://5e510330f2c0d300147c034c.mockapi.io/"

    private fun getRetrofit(): Retrofit {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build() //Doesn't require the adapter
    }

    val apiService: ApiService = getRetrofit().create(ApiService::class.java)
}