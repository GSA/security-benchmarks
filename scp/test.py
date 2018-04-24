import generate
import os
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
            actual = generate.is_approved({'Approval Status': status})
            err = "'{}' should have resulted in is_approved()=={}".format(status, expected)
            self.assertEqual(actual, expected, err)

    def test_csv_to_policy(self):
        path = os.path.join(os.path.dirname(__file__), 'test.csv')
        policy = generate.csv_to_policy(path)
        self.assertDictEqual({
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "rds:*"
                    ],
                    "Resource": [
                        "*"
                    ]
                }
            ]
        }, policy)


if __name__ == '__main__':
    unittest.main()
