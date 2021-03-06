Feature: client aware context
    In order to write steps using the API
    As a step definitions developer
    I need get the API client in my feature context

    Background:
        Given a file named "features/bootstrap/FeatureContext.php" with:
        """
        <?php

        use Behat\WebApiExtension\Context\ApiClientContextInterface;
        use PHPUnit\Framework\Assert;
        use Psr\Http\Client\ClientInterface;

        class FeatureContext implements ApiClientContextInterface
        {
            public function setBaseUri(string $baseUri): ApiClientContextInterface
            {
                $this->baseUri = $baseUri;

                return $this;
            }

            public function setClient(ClientInterface $client): ApiClientContextInterface
            {
                $this->client = $client;

                return $this;
            }

            /**
             * @Then /^the base_uri should be set$/
             */
            public function theBaseUriShouldBeSet() {
                Assert::assertInternalType('string', $this->baseUri);
            }

            /**
             * @Then /^the client should be set$/
             */
            public function theClientShouldBeSet() {
                Assert::assertInstanceOf(ClientInterface::class, $this->client);
            }
        }
        """

    Scenario: Context parameters
        Given a file named "behat.yml" with:
        """
        default:
            extensions:
                Behat\WebApiExtension: ~
        """
        And a file named "features/client.feature" with:
        """
        Feature: Api client
            In order to call the API
            As feature runner
            I need to be able to access the client

            Scenario: client is set
                Then the client should be set
        """
        When I run "behat -f progress features/client.feature"
        Then it should pass with:
        """
        .

        1 scenario (1 passed)
        1 step (1 passed)
        """
