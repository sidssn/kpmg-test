from .value_finder import value_finder
import unittest

class TestValueFinder(unittest.TestCase):
    def test_success_case_one(self):
        actual_value = value_finder('a/b/c', {'a':{'b':{'c':'d'}}})
        self.assertEqual('d', actual_value)

    def test_success_case_two(self):
        actual_value = value_finder('x/y/z', {'x':{'y':{'z':'a'}}})
        self.assertEqual('a', actual_value)

    def test_failure_case(self):
        actual_value = value_finder('x/y/a', {'x':{'y':{'z':'a'}}})
        self.assertEqual('value not found for key sequence', actual_value)

if __name__ == "__main__":
    unittest.main()

