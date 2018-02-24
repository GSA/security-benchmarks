from generate import *
import unittest


class TestSCPGenerator(unittest.TestCase):
    def test_is_approved(self):
        tests = {
            'Approved': True,
            'approved': True,
            'nope': False
        }
        for status, expected in tests.items():
            actual = is_approved({'Approval Status': status})
            self.assertEqual(actual, expected, "{} should have resulted in is_approved()=={}".format(status, expected))


if __name__ == '__main__':
    unittest.main()
