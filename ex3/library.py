# -*- coding: utf-8 -*-


'''
The following comprises of code for library management system using
object oriented programming. This is a part of the excercises given
under UIT2312 - Programming and Design Patterns.

It will return the minimum cost as well as the path connecting each
city and check water availability based on the demand.

I have followed good coding practices.

Created date : 12th September 2023
Last modified : 12th September 2023

Author : <pranaav2210205@ssn.edu.in>
Register number : 3122 22 5002 093

'''


class LibraryItems:

    '''
    This class acts as the base class for the different library
    items such as books,cd,dvd and magazine. It provides a function
    which displays all the details of a given item.

    Methods:
    
        __init__ : The constructor.
        display : Function used to display the item details.
    
    '''

    def __init__(self,dispitems):

        self.dispitems = dispitems
    
    def display(self):

        print()
        for i in self.dispitems:
            if isinstance(i, Author):
                i.display()
                continue
            print(i)


class Book(LibraryItems):

    '''
    This class is used to store details of a book and display the
    book details using the function inherited from LibraryItems.

    Methods:
        __init__ : The constructor.
        display : Function used to display the book details.
    
    '''

    def __init__(self,ISBN,DDS,subject,title,author):

        self.ISBN = ISBN
        self.DDS = DDS
        self.subject = subject
        self.title = title
        self.author = author
        self.dispitems = [ISBN,DDS,subject,title,author]
        super().__init__(self.dispitems)

    def display(self):

        print("The book details are :")
        super().display()


class Magazine(LibraryItems):

    '''
    This class is used to store details of a Magazine and display the
    magazine details using the function inherited from LibraryItems.

    Methods:
        __init__ : The constructor.
        display : Function used to display the magazine details.
    
    '''

    def __init__(self,UPC,title,volume,issue_num):

        self.UPC = UPC
        self.title = title
        self.volume = volume
        self.issue_num = issue_num
        self.dispitems = [UPC,title,volume,issue_num]
        super().__init__(self.dispitems)

    def display(self):

        print("The magazine details are :")
        super().display()


class DVD(LibraryItems):

    '''
    This class is used to store details of a DVD and display the
    DVD details using the function inherited from LibraryItems.

    Methods:
        __init__ : The constructor.
        display : Function used to display the DVD details.
    
    '''

    def __init__(self,UPC):
        
        self.UPC = UPC
        self.dispitems = [UPC]
        super().__init__(self.dispitems)

    def display(self):

        print("The DVD details are :")
        super().display()


class CD(LibraryItems):

    '''
    This class is used to store details of a CD and display the
    CD details using the function inherited from LibraryItems.

    Methods:
        __init__ : The constructor.
        display : Function used to display the CD details.
    
    '''

    def __init__(self,UPC,author):
        
        self.UPC = UPC
        self.author = author
        self.dispitems = [UPC,author]
        super().__init__(self.dispitems)

    def display(self):

        print("The CD details are :")
        super().display()


class Author:

    '''
    This class is used to store details of authors and the author
    information can be displayed using the class display function.

    Methods:
        __init__ : The constructor.
        display : Function used to display the author details.
    
    '''

    def __init__(self,fname,lname):

        self.fname = fname
        self.lname = lname

    def display(self):
        
        print(self.fname + ' ' + self.lname)


class Contributer:

    '''
    This class is used to store details of contributor and the contributer
    information can be displayed using the class display function along
    with being able to see the total number of books donated.

    Methods:
        __init__ : The constructor.
        display : Function used to display the contributer details.
        find_total : Function which displays the total number of
                     books contributed.
    
    '''

    def __init__(self,fname,lname,books):
        
        self.fname = fname
        self.lname = lname
        self.books = books
        self.dispitems = [fname,lname,books]

    def display(self):

        print(f"Contributer name is : {self.fname} {self.lname}")
        print("Books donated along with quantities are:")
        for i in self.books:
            print(f"Book is : {i[0]} \nQuantity is : {i[1]}\n")

    def find_total(self):

        s = 0
        for i in self.books:
            s += i[1]
        
        return s


class Catalog:

    '''
    This class is used to find any required book, CD, Magazine or DVD
    using any of their given parameters.
    
    '''

    def __init__(self,items):
        
        self.items = items

    def find(self):

        option = int(input("1.Enter 1 if you want to search a Book.\n2.Enter 2 if you want to search a CD.\n3.Enter 3 if you want to search a Magazine.\n4.Enter 4 if you want to search a DVD.\n"))

        if option == 1:

            self.findbook()
                    
        if option == 2:

            self.findCD()

        if option == 3:

            self.findMag()

        if option == 4:

            self.findDVD()

    def findbook(self):

        choice = int(input("Enter how you want to search :\n1. Enter 1 to search via ISBN.\n2. Enter 2 to search via certain subject.\n3. Enter 3 to search via title.\n4. Enter 4 to search via author last name.\n"))
            
        val = input("Enter value : ")
        found = False

        for i in self.items:

            if isinstance(i, Book):

                if choice == 1:

                    if i.ISBN == val:
                        
                        found = True
                        i.display()
                        print()
                    
                elif choice == 2:

                    if i.subject == val:

                        found = True
                        i.display()
                        print()

                elif choice == 3:

                    if i.title == val:

                        found = True
                        i.display()
                        print()
                    
                elif choice == 4:

                    if i.author.lname == val:

                        found = True
                        i.display()
                        print()


        if not found:

            print("Book does not exist.\n")

    def findCD(self):

        choice = int(input("1. Enter 1 if you want to search via UPC.\n2. Enter 2 if you want to search via author last name.\n"))

        val = input("Enter value : ")
        found = False

        for i in self.items:

            if isinstance(i,CD):

                if choice == 1:

                    if i.UPC == val:

                        found = True
                        i.display()
                        print()

                if choice == 2:

                    if i.author.lname == val:

                        found = True
                        i.display()
                        print()

        if not found:

            print("CD does not exist.\n")

    def findDVD(self):

        val = input("Enter UPC : ")
        found = False

        for i in self.items:

            if isinstance(i,DVD):

                if i.UPC == val:

                    found = True
                    i.display()
                    print()

        if not found:

            print("DVD does not exist.\n")

    def findMag(self):

        choice = int(input("1. Enter 1 to search via UPC.\n2. Enter 2 to search via Title.\n3. Enter 3 to search via volume.\n4. Enter 4 to search via issue number.\n"))

        val = input("Enter value : ")
        found = False

        for i in self.items:

            if isinstance(i,Magazine):

                if choice == 1:

                    if i.UPC == val:
                        
                        found = True
                        i.display()
                        print()
                    
                elif choice == 2:

                    if i.title == val:

                        found = True
                        i.display()
                        print()

                elif choice == 3:

                    if i.volume == val:

                        found = True
                        i.display()
                        print()
                    
                elif choice == 4:

                    if i.issue_num == val:

                        found = True
                        i.display()
                        print()


        if not found:

            print("Magazine does not exist.\n")


#driver code
if __name__ == '__main__':
    #The code provided here will not be executed when imported

    #writing down authors
    auth1 = Author('JK','Rowling')
    auth2 = Author('Arthur','Kingsley')

    #writing down books
    book1 = Book('a100','b2','fiction','Harry Potter',auth1)
    book2 = Book('a101','c2','History','Trojan Horse',auth2)

    #writing down cd
    cd1 = CD('ca100',auth1)
    cd2 = CD('ca101',auth2)

    #writing down magazines
    mag1 = Magazine('ma100','The Moon','vol1','y155')
    mag2 = Magazine('ma101','The Sun','vol2','z100')
    dvd1 = DVD('da100')
    dvd2 = DVD('da101')

    #creating a catalog using given data
    catalog = Catalog([book1,book2,cd1,cd2,mag1,mag2,dvd1,dvd2])
    
    #finding book
    catalog.findbook()
    print()

    #finding cd
    catalog.findCD()
    print()

    #finding magazine
    catalog.findMag()
    print()

    #finding dvd
    catalog.findDVD()
    print()

    #finding anything using common function
    catalog.find()
    print()
