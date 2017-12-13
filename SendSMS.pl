#!/opt/ActivePerl-5.24/bin/perl
#use warnings;
#use strict;

##########Author: Elizabeth Nguli############
use Net::SMPP;
use strict;
use LWP::UserAgent;
use XML::Simple;
my $facil = 0x00010003;
my ($msisdn,$soapmessage,$message,@dest_addrs);

@dest_addrs =('xxxxxxxxxxx');
$message=$ARGV[0];

#print "$ARGV[0]\n";

foreach $msisdn (@dest_addrs)
        {
                chomp($msisdn);


                &sendSMS($msisdn,$message);
        }


sub sendSMS
{
        my ($msisdn, $message) = @_;


        my $soapmessage = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <ns0:webTransmitter xmlns:ns0="http://www.safaricomoss.net/webTransmitte
r/schemas" xmlns:ns1="http://www.safaricomoss.net/webTransmitter/schemas" xmlns:
ns2="http://www.safaricomoss.net/webTransmitter/schemas" xmlns:ns3="http://www.s
afaricomoss.net/webTransmitter/schemas" xmlns:ns4="http://www.safaricomoss.net/w
ebTransmitter/schemas" xmlns:ns5="http://www.safaricomoss.net/webTransmitter/sch
emas">
            <ns1:systemID>XXX</ns1:systemID>
            <ns2:method>submitSM</ns2:method>
            <ns3:originatingMSISDN>XXX</ns3:originatingMSISDN>
            <ns4:destinationMSISDN>'.$msisdn.'</ns4:destinationMSISDN>
            <ns5:textMessage>'.$message.'</ns5:textMessage>
        </ns0:webTransmitter>
    </soap:Body>
        </soap:Envelope>';

        print "Sending Message to $msisdn ...\n";
        #print "sent message:".$soapmessage."\n";

        my $userAgent = LWP::UserAgent->new();
        my $request = HTTP::Request->new(POST => 'http://localhost:8080/WebTransmitter/WebTransmitter?wsdl');
        $request->header(SOAPAction => '');
        $request->content($soapmessage);
        $request->content_type("text/xml; charset=utf-8");

        my $response = $userAgent->request($request);

        if($response->code == 200)
        {
                my $data = $response->content();
                my $content = $response->as_string();
                my $xs = new XML::Simple();
                my $ref = $xs->XMLin($data);
                #print $content."\n";
                print "OK\n";
        }
}

