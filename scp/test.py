from generate import *
import unittest


class TestSCPGenerator(unittest.TestCase):
    def test_is_approved(self):
        tests = {
            'Approved': True,
            'approved': True,
            'it has been approved': True,
            'was approved': True,
            'nope': False,
            'not approved': False,
            'not been approved': False,
            'not yet approved': False,
            "isn't approved": False
        }
        for status, expected in tests.items():
            actual = is_approved({'Approval Status': status})
            err = "'{}' should have resulted in is_approved()=={}".format(status, expected)
            self.assertEqual(actual, expected, err)


if __name__ == '__main__':
    unittest.main()
