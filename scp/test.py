from generate import *
import unittest


class TestSCPGenerator(unittest.TestCase):
    def test_is_approved(self):
        self.assertTrue(is_approved({'Approval Status': 'Approved'}))
        self.assertTrue(is_approved({'Approval Status': 'approved'}))
        self.assertFalse(is_approved({'Approval Status': 'nope'}))


if __name__ == '__main__':
    unittest.main()
