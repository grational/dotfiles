#!/usr/bin/env python
"""parse a csv address-book export from thunderbird and create mutt-aliases for each contact"""

import csv
import collections
import argparse
import re

# Contact = collections.namedtuple("Contact", ["first", "last", "display", "email"])
class Contact:
    def __init__(self,f,l,d,e):
        self.first = f
        self.last = l
        self.display = d
        self.email = e

    def __str__(self):
        return "first -> {}\nlast -> {}\ndisplay -> {}\nemail -> {}".format(self.first,self.last,self.display,self.email)


def line_to_contact(line):
    """return: Contact based on csv line"""
    # 0:First Name, 1:Last Name, 2:Display Name, 4: Primary Email
    return Contact(line[0], line[1], line[2], line[4])


def normalized(string):
    """remove whitespaces from a string and make it lowercase"""
    return re.sub(r"\W","",string).lower()


def create_alias(*strings):
    """create a normalized alias without whitespaces"""
    alias = ""
    for string in strings:
        ns = normalized(string)
        if (not alias) and ns:
            alias = ns
        elif alias and ns:
            alias = "{}-{}".format(alias, ns)
    return alias


def contact_to_alias(contact):
    """return: a mutt-contact alias statement for contact"""
    if contact.first and contact.last:
        alias = create_alias(contact.first, contact.last)
    elif contact.display:
        alias = create_alias(*(contact.display.split()))
    else:
        alias = contact.email.split('@')[0]
    return "alias {} {} {} <{}>".format(alias, contact.first, contact.last, contact.email)


def csv_to_contacts(path):
    """convert csv file to list of Contact objects"""
    with open(path, "r") as f_open:
        reader = csv.reader(f_open)
        reader.next() #read header line
        return [line_to_contact(line) for line in reader]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-address_book", help="Local path to input csv-formatted address book.", required=True)
    parser.add_argument("-alias_path", help="Local path to output file for mutt-aliases.", required=True)
    args = parser.parse_args()

    address_book_path = args.address_book
    alias_path = args.alias_path
    contacts = csv_to_contacts(address_book_path)
    print("Parsed", len(contacts), "contacts from", address_book_path)
    aliases = [contact_to_alias(contact) for contact in contacts]
    with open(alias_path, "w") as f_out:
        output_lines = "\n".join(aliases)
        f_out.write(output_lines)


if __name__ == "__main__":
    main()
