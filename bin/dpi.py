#!/usr/local/bin/python

import os

def _getenv(variable: str, default: str) -> str:
    """Get an environment variable.
    Parameters
    ----------
    variable : str
        The environment variable.
    default : str
        A default value that will be returned if the environment
        variable is unset or empty.
    Returns
    -------
    str
        The value of the environment variable, or the default value.
    """
    return os.environ.get(variable) or default
XDG_CONFIG_HOME = _getenv('XDG_CONFIG_HOME',
                          os.path.expandvars(os.path.join('$HOME', '.config')))


print ("Hello: " + XDG_CONFIG_HOME)