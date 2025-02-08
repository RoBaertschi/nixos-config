#!/usr/bin/env python3
import re
from typing import List, cast, Annotated, Optional

import dbus
import typer
from rich import box, print, table

regex = r"^org\.mpris\.MediaPlayer2\.([a-zA-Z|\_][\w|\d|\_]*)(?:\.([a-zA-Z|\_][\w|\d|\_]*))?$"


app = typer.Typer()


class Application:
    name: str
    instances: List[str]
    # If the application has instances, then fill this array
    proxies: List[dbus.proxies.ProxyObject] | None = None
    # else set this
    proxy: dbus.proxies.ProxyObject | None = None

    def __init__(self, name: str, instance: str | None):
        self.instances = []
        self.name = name
        if instance:
            self.instances.append(instance)

    def __str__(self):
        return str(self.name) + " " + str(self.instances)


def get_objects():
    for application in applications:
        bus_name = "org.mpris.MediaPlayer2." + application.name
        object_path = "/org/mpris/MediaPlayer2"
        if len(application.instances) > 0:
            application.proxies = []
            for instance in application.instances:
                new_bus = bus_name + "." + instance
                application.proxies.append(
                    session_bus.get_object(new_bus, object_path))
        else:
            application.proxy = session_bus.get_object(bus_name, object_path)


session_bus = dbus.SessionBus()
services: dbus.Array = session_bus.list_names()
mpris_services: list[dbus.String] = []
applications: List[Application] = cast(list[Application], [])


for service in services:
    service: dbus.String = cast(dbus.String, service)
    if service.find("mpris") != -1:
        mpris_services.append(service)

        match = re.match(regex, service)

        found = False
        for appli in applications:
            if appli.name == match.group(1):
                found = True
                appli.instances.append(match.group(2))
        if not found:
            applications.append(Application(match.group(1), match.group(2)))


@app.command()
def list():
    """
    Lists all currently running applications.
    """

    new_table = table.Table(
        title="Running MPRIS applications",
        title_style=table.Style(color="green"),
        style=table.Style(
            color="green",
        ),
        box=box.ROUNDED,
    )
    new_table.add_column("Application Name")
    new_table.add_column("Instances")

    for application in applications:
        new_table.add_row(application.name, str(application.instances))

    print(new_table)


def call(proxy: dbus.proxies.ProxyObject, method: str):
    try:
        player = dbus.Interface(
            proxy, dbus_interface="org.mpris.MediaPlayer2.Player")
        player.get_dbus_method(method)()
    except dbus.exceptions.DBusException as e:
        print("[red]Error while trying to execute method " + method +
              " with exception " + str(e) + ". Ignoring because firefox can cause some weird issues")


def call_app_method(app: Application, method: str):
    if app.proxies is not None:
        for proxy in app.proxies:
            call(proxy, method)
    else:
        call(app.proxy, method)


def command(
    bus: str | None, all: bool, single_success: str, all_success: str, command: str
):
    get_objects()
    if all:
        for application in applications:
            call_app_method(application, command)
        print("[green]" + all_success)

    elif bus is None:
        print("[red]Error: --app is required when --all is false")
        return 1
    else:
        found = False
        app: Application | None = None
        for application in applications:
            if application.name == bus:
                found = True
                app = application
                break
        if not found:
            print("[red]Error: could not find application '" + bus + "'")
            return 1
        call_app_method(app, command)
        print("[green]" + single_success)


@app.command()
def playpause(
    all: Annotated[bool, typer.Option()] = False,
    bus: Annotated[Optional[str], typer.Argument()] | None = None,
):
    """
    Play/Pause a track.
    """
    command(
        bus,
        all,
        "Successfully Paused/Resumed",
        "Play/Pause on all applications",
        "PlayPause",
    )


@app.command()
def next(
    all: Annotated[bool, typer.Option()] = False,
    bus: Annotated[Optional[str], typer.Argument()] | None = None,
):
    """
    Move onto the next Track.
    """
    command(
        bus,
        all,
        "Successfully moved onto next Track",
        "Skipped Tracks for all applications.",
        "Next",
    )


@app.command()
def previous(
    all: Annotated[bool, typer.Option()] = False,
    bus: Annotated[Optional[str], typer.Argument()] | None = None,
):
    """
    Previous Track.
    """
    command(
        bus,
        all,
        "Successfully moved to previous Track",
        "Moved to previous Track for all applications.",
        "Previous",
    )


if __name__ == "__main__":
    app()
