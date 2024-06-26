defmodule GatherWeb.GuestsLive do
  use GatherWeb, :live_view

  alias Gather.Guests
  alias GatherWeb.Components

  def render(assigns) do
    ~H"""
    <div class="max-w-screen-lg mx-auto mt-24">
      <div class="flex flex-col sm:flex-row items-center justify-between">
        <div>
          <h1 class="sm:text-left mb-8 sm:mb-0 font-bold text-3xl text-gray-50">Guests</h1>
          <p><%= @guest_count %> guests</p>
        </div>

        <div class="flex items-center space-x-2">
          <.simple_form
            class="hidden sm:block"
            for={@form}
            id="download_csv_form"
            action={~p"/download?_action=download&type=csv"}
          >
            <button class="text-sm inline-flex items-center gap-x-1 hover:bg-gray-900 p-1 rounded">
              <.icon name="file-download" /> csv
            </button>
          </.simple_form>

          <.simple_form
            class="hidden sm:block"
            for={@form}
            id="download_doc_form"
            action={~p"/download?_action=download&type=doc"}
          >
            <button class="text-sm inline-flex items-center gap-x-1 hover:bg-gray-900 p-1 rounded">
              <.icon name="file-download" /> doc
            </button>
          </.simple_form>

          <.form
            for={@form}
            id="search_form"
            class="relative flex-grow flex items-stretch focus-within:z-10"
            phx-submit="search"
          >
            <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3 mt-0.5">
              <.icon name="search" />
            </div>
            <.input
              type="text"
              name="search"
              id="search"
              value={@search}
              placeholder="Search by name..."
              autocomplete="off"
              has_icon
            />
          </.form>

          <a
            href="/guests/new"
            class="block rounded-md bg-gather-500 px-3 py-2 text-center font-medium text-white hover:bg-gather-600"
          >
            Add guest
          </a>
        </div>
      </div>
      <div class="mt-8 flow-root">
        <div class="overflow-x-auto rounded-lg shadow ring-1 ring-black ring-opacity-5">
          <table class="min-w-full bg-gray-900 rounded-lg divide-y divide-gather-900">
            <thead class="bg-gray-900/50">
              <tr>
                <th
                  scope="col"
                  class="py-3.5 px-2 text-left text-sm font-semibold text-gray-100 sm:pl-4 whitespace-nowrap"
                >
                  Name
                </th>
                <th
                  scope="col"
                  class="px-2 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Address
                </th>
                <th
                  scope="col"
                  class="px-2 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Guest Amount
                </th>
                <th
                  scope="col"
                  class="px-2 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Save the Date
                </th>
                <th
                  scope="col"
                  class="px-2 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  RSVP
                </th>
                <th
                  scope="col"
                  class="px-2 py-3.5 text-left text-sm font-semibold text-gray-100 whitespace-nowrap"
                >
                  Invite
                </th>
                <th scope="col" class="relative py-3.5 px-2 sm:pr-4">
                  <span class="sr-only">Edit</span>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gather-900 bg-gray-800/50">
              <tr :for={guest <- @guests}>
                <td class="p-2 text-sm font-medium text-gray-100 sm:pl-4" style="min-width: 175px;">
                  <%= guest.name %>
                </td>
                <td class="whitespace-nowrap p-2 text-sm">
                  <span class="block">
                    <%= guest.address_line_1 %><%= if guest.address_line_2,
                      do: ", " <> guest.address_line_2 %>
                  </span>
                  <%= guest.city %>, <%= guest.state %>
                  <%= guest.zip %>
                </td>
                <td class="whitespace-nowrap p-2 text-sm text-right">
                  <%= guest.guest_amount %>
                </td>
                <td class="whitespace-nowrap p-2 text-sm">
                  <%= if guest.save_the_date_sent do %>
                    <Components.badge label="Yes" color="green" />
                  <% else %>
                    <Components.badge label="No" color="red" />
                  <% end %>
                </td>
                <td class="whitespace-nowrap p-2 text-sm">
                  <%= if guest.rsvp_sent do %>
                    <Components.badge label="Yes" color="green" />
                  <% else %>
                    <Components.badge label="No" color="red" />
                  <% end %>
                </td>
                <td class="whitespace-nowrap p-2 text-sm">
                  <%= if guest.invite_sent do %>
                    <Components.badge label="Yes" color="green" />
                  <% else %>
                    <Components.badge label="No" color="red" />
                  <% end %>
                </td>
                <td class="relative whitespace-nowrap p-2 text-right text-sm font-medium sm:pr-4">
                  <Components.delete_guest_modal guest_id={guest.id} guest_name={guest.name} />

                  <a
                    href={"/guests/#{guest.id}"}
                    class="p-1.5 rounded text-blue-800 hover:bg-gray-900/80 inline-flex items-center justify-center"
                  >
                    <.icon name="edit" />
                  </a>

                  <button
                    phx-click={show_modal("delete_guest_modal_#{guest.id}")}
                    class="p-1.5 rounded text-rose-800 hover:bg-gray-900/80 inline-flex items-center justify-center"
                  >
                    <.icon name="trash" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    form = to_form(%{"name" => "name"})

    socket =
      assign(socket,
        guests: Guests.list_guests(user_id),
        guest_count: Guests.get_guest_amount(user_id),
        search: "",
        form: form
      )

    {:ok, socket}
  end

  def handle_event("search", %{"search" => search}, socket) do
    user_id = socket.assigns.current_user.id

    socket =
      assign(
        socket,
        search: search,
        guests: Guests.search_by_name(search, user_id)
      )

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Guests.delete_guest(id) do
      {:ok, guest} ->
        updated_guests =
          Enum.filter(socket.assigns.guests, fn guest -> guest.id != String.to_integer(id) end)

        socket = assign(socket, :guests, updated_guests)
        socket = put_flash(socket, :success, "#{guest.name} has been deleted")
        {:noreply, socket}

      {:error, _message} ->
        socket = put_flash(socket, :error, "Failed to delete guest")
        {:noreply, socket}
    end
  end
end
