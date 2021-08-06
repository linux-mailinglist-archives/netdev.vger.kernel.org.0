Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B673B3E2BF3
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhHFNwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 09:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbhHFNw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 09:52:28 -0400
X-Greylist: delayed 393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Aug 2021 06:52:12 PDT
Received: from sequoia-grove.ad.secure-endpoints.com (sequoia-grove.secure-endpoints.com [IPv6:2001:470:1f07:f77:70f5:c082:a96a:5685])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27C3C0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 06:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed;
        d=auristor.com; s=MDaemon; r=y; t=1628257535; x=1628862335;
        i=jaltman@auristor.com; q=dns/txt; h=Subject:To:Cc:References:
        From:Organization:Message-ID:Date:User-Agent:MIME-Version:
        In-Reply-To:Content-Type; bh=Ipqlg5FNHRE6F2mXyLEwDcZq7XGHIQ6UjWl
        EyQJ64LY=; b=OBKX5M3dQjsjRjOyM49tsIT7I/XgxPH10JnPQWlJmziqUsFqd4l
        spcHyJezXHlCSBixnEs76YrkQsuHtr8uml0Mk7cYebKn6WRULHsqHCycrFl08L9p
        flX8VhweMOBOb087okVsumMhGXO15DzrRGU8FFN9lo16xWaNf7YtVCmU=
X-MDAV-Result: clean
X-MDAV-Processed: sequoia-grove.ad.secure-endpoints.com, Fri, 06 Aug 2021 09:45:35 -0400
Received: from [IPv6:2603:7000:73d:4f22:b4f9:ec5e:37c5:56c6] by auristor.com (IPv6:2001:470:1f07:f77:28d9:68fb:855d:c2a5) (MDaemon PRO v21.0.3) 
        with ESMTPSA id md5001002973412.msg; Fri, 06 Aug 2021 09:45:35 -0400
X-Spam-Processed: sequoia-grove.ad.secure-endpoints.com, Fri, 06 Aug 2021 09:45:35 -0400
        (not processed: message from trusted or authenticated source)
X-MDRemoteIP: 2603:7000:73d:4f22:b4f9:ec5e:37c5:56c6
X-MDHelo: [IPv6:2603:7000:73d:4f22:b4f9:ec5e:37c5:56c6]
X-MDArrival-Date: Fri, 06 Aug 2021 09:45:35 -0400
X-MDOrigin-Country: United States, North America
X-Authenticated-Sender: jaltman@auristor.com
X-Return-Path: prvs=18525c743d=jaltman@auristor.com
X-Envelope-From: jaltman@auristor.com
X-MDaemon-Deliver-To: netdev@vger.kernel.org
Subject: Re: [RFC][PATCH] rxrpc: Support reception of extended-SACK ACK packet
To:     "David Howells (dhowells@redhat.com)" <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>
Cc:     Benjamin Kaduk <kaduk@mit.edu>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1290708.1628244534@warthog.procyon.org.uk>
From:   Jeffrey E Altman <jaltman@auristor.com>
Organization: AuriStor, Inc.
Message-ID: <5700e27c-2d82-4a7a-8275-740140b3b279@auristor.com>
Date:   Fri, 6 Aug 2021 09:45:25 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1290708.1628244534@warthog.procyon.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050607090806000609030409"
X-MDCFSigsAdded: auristor.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050607090806000609030409
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

David,

Thanks for working on this.

For the benefit of other readers.=C2=A0=C2=A0 The RxRPC protocol is not
standardized by the IETF
or any other standards organization.=C2=A0=C2=A0 The best description of =
the
protocol is present in
the OpenAFS source repository (doc/txt/rx-spec.txt).=C2=A0=C2=A0=C2=A0=C2=
=A0 Proposed
updates to this
specification are available in OpenAFS Gerrit

=C2=A0 doc: rx-spec Update for accuracy with current Rx implementations
=C2=A0 https://gerrit.openafs.org/#/c/14692

=C2=A0
=C2=A0 doc: rx-spec Document the Extended SACK Table protocol extension
=C2=A0 https://gerrit.openafs.org/#/c/14693


On 8/6/2021 6:08 AM, David Howells (dhowells@redhat.com) wrote:
> The RxRPC ACK packet supports selective ACK of up to 255 DATA packets. =
 It
> contains a variable length array with one octet allocated for each DATA=

> packet to be ACK'd.  Each octet is either 0 or 1 depending on whether i=
t is
> a negative or positive ACK.  7 bits in each octet are effectively unuse=
d
> and, further, there are three reserved octets following the ACK array t=
hat
> are all set to 0.

The proposed EXTENDED_SACK ACK packet format assigns usage for all three
of the
unused octets.=C2=A0 The first is used to extend the SACK table from 255
octets to 256 octets.
This octet will be zero unless it is actively being used to represent a
positive
acknowledgement of a DATA packet.

The second unused octet is designated as the <Trailer Count> field.=C2=A0=
=C2=A0=C2=A0
The three
unused octets are the result of a math error in the mid-90s when IBM
extended
the ACK packet format with a series of 32-bit fields.=C2=A0=C2=A0=C2=A0 O=
ver time
additional fields
were added but there has never been a clear method for the ACK packet
receiver
to determine how many fields were sent.=C2=A0=C2=A0 The EXTENDED_SACK pro=
posal
addresses
this oversight with the <Trailer Count> field which should be set to the
number of
32-bit trailer fields.=C2=A0=C2=A0 At present this value is 4, not 0.=C2=A0=
=C2=A0 This field
will permit
additional trailers to be defined in the future.

The third unused octet is designated as the <Extra SACK Count> field.=C2=A0=
=C2=A0
This field
designates how many additional variable length SACK tables are present
following
the designated number of trailer fields.=C2=A0=C2=A0=C2=A0 Each additiona=
l SACK table
can represent
up to 2048 additional DATA packets.

>
> To extend the ACK window up to 2048 ACKs, it is proposed[1]:
>
>  (1) that the ACKs for DATA packets first+0...first+254 in the Rx windo=
w
>      are in bit 0 of the octets in the array, ie. acks[0...254], pretty=

>      much as now; and
>
>  (2) that if the ACK count is >=3D256, the first reserved byte after th=
e ACK
>      table is annexed to the ACK table as acks[255] and contains the AC=
K
>      for packet first+255 in bit 0; and
>
>  (3) that if the ACK count is >256, horizontal striping be employed suc=
h
>      that the ACK for packet first+256 in the window is then in bit 1 o=
f
>      acks[0], first+257 is in bit 1 of acks[1], up to first+511 being i=
n
>      bit 1 of the borrowed reserved byte (ie. acks[255]).
>
>      first+512 is then in bit 2 of acks[0], going all the way up to
>      first+2048 being in bit 7 of acks[255].

I think this should say "first + 2047 in bit 7 of acks[255]."

> If extended SACK is employed in an ACK packet, it should have EXTENDED-=
SACK
> (0x08) set in the RxRPC packet header.

The EXTENDED_SACK format proposal also addresses a historical deficiency
in the
specification and usage of the <previousPacket> field.=C2=A0=C2=A0
https://gerrit.openafs.org/#/c/14692
adds version specific details to rx-spec.txt but in summary, the
<previousPacket> field
is unreliable at present and cannot be used in any meaningful way.=C2=A0=C2=
=A0
Various Rx
implementations (including OpenAFS) attempt to use it to filter
out-of-sequence
ACK packets but this is unreliable because the value sent by many Rx
peers can move
backwards, or represent a sequence number that was out of range, or even
not be a
sequence number at all.=C2=A0=C2=A0 When the EXTENDED_SACK flag is set th=
e
<previousPacket>
field is defined to be the largest DATA packet sequence number accepted
by the
sender of the ACK packet.=C2=A0=C2=A0=C2=A0 As such the <previousPacket> =
field can
reliably be
used for two purposes:

=C2=A0 1. <previousPacket> can be used to detect out-of-sequence ACK pack=
ets

=C2=A0 2. <previousPacket> - <firstPacket> + 1 represents the maximum num=
ber
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 of SACK table bits that contain valid ackn=
owledgements.=C2=A0=C2=A0
Regardless of
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 how many SACK tables are present in the AC=
K packet.

> Alter rxrpc_input_ack() to sanity check the ACK count.
>
> Alter rxrpc_input_ack() to limit the number of bytes it extracts from t=
he
> packet for the ack array to 256.
>
> Alter rxrpc_input_soft_acks() to handle an extended SACK table.

EXTENDED_SACK is still a proposal awaiting review.=C2=A0=C2=A0

What has been agreed upon at this point in time is that the acks[] array
be interpreted
as bit fields.=C2=A0=C2=A0 I suggest that the first patch to rxrpc implem=
ent the
equivalent change
to OpenAFS

=C2=A0 rx: compare RX_ACK_TYPE_ACK as a bit-field
=C2=A0 https://gerrit.openafs.org/#/c/14465/4

I also suggest that rxrpc be updated if necessary to always set
<previousPacket> as
described by the EXTENDED_SACK proposal regardless of whether or not the
EXTENDED_SACK proposal is implemented.=C2=A0=C2=A0 Existing OpenAFS Rx pe=
ers expect
that behavior when receiving ACK packets even though they do not the fiel=
d
according to those expectations.

Thanks again for taking the time to review and implement the proposal.

Jeffrey Altman




--------------ms050607090806000609030409
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DGswggXSMIIEuqADAgECAhBAAW0B1qVVQ32wvx2EXYU6MA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEy
MB4XDTE5MDkwNTE0MzE0N1oXDTIyMTEwMTE0MzE0N1owcDEvMC0GCgmSJomT8ixkAQETH0Ew
MTQxMEMwMDAwMDE2RDAxRDZBNTQwMDAwMDQ0NDcxGTAXBgNVBAMTEEplZmZyZXkgRSBBbHRt
YW4xFTATBgNVBAoTDEF1cmlTdG9yIEluYzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCY1TC9QeWnUgEoJ81FcAVnhGn/AWuzvkYRUG5/ZyXDdaM212e8
ybCklgSmZweqNdrfaaHXk9vwjpvpD4YWgb07nJ1QBwlvRV/VPAaDdneIygJJWBCzaMVLttKO
0VimH/I/HUwFBQT2mrktucCEf2qogdi2P+p5nuhnhIUiyZ71Fo43gF6cuXIMV/1rBNIJDuwM
Q3H8zi6GL0p4mZFZDDKtbYq2l8+MNxFvMrYcLaJqejQNQRBuZVfv0Fq9pOGwNLAk19baIw3U
xdwx+bGpTtS63Py1/57MQ0W/ZXE/Ocnt1qoDLpJeZIuEBKgMcn5/iN9+Ro5zAuOBEKg34wBS
8QCTAgMBAAGjggKcMIICmDAOBgNVHQ8BAf8EBAMCBPAwgYQGCCsGAQUFBwEBBHgwdjAwBggr
BgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVudHJ1c3QuY29tMEIGCCsGAQUF
BzAChjZodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NlcnRzL3RydXN0aWRjYWEx
Mi5wN2MwHwYDVR0jBBgwFoAUpHPa72k1inXMoBl7CDL4a4nkQuwwCQYDVR0TBAIwADCCASsG
A1UdIASCASIwggEeMIIBGgYLYIZIAYb5LwAGAgEwggEJMEoGCCsGAQUFBwIBFj5odHRwczov
L3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRt
bDCBugYIKwYBBQUHAgIwga0MgapUaGlzIFRydXN0SUQgQ2VydGlmaWNhdGUgaGFzIGJlZW4g
aXNzdWVkIGluIGFjY29yZGFuY2Ugd2l0aCBJZGVuVHJ1c3QncyBUcnVzdElEIENlcnRpZmlj
YXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRp
ZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBFBgNVHR8EPjA8MDqgOKA2hjRodHRwOi8v
dmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC90cnVzdGlkY2FhMTIuY3JsMB8GA1UdEQQY
MBaBFGphbHRtYW5AYXVyaXN0b3IuY29tMB0GA1UdDgQWBBR7pHsvL4H5GdzNToI9e5BuzV19
bzAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAFlm
JYk4Ff1v/n0foZkv661W4LCRtroBaVykOXetrDDOQNK2N6JdTa146uIZVgBeU+S/0DLvJBKY
tkUHQ9ovjXJTsuCBmhIIw3YlHoFxbku0wHEpXMdFUHV3tUodFJJKF3MbC8j7dOMkag59/Mdz
Sjszdvit0av9nTxWs/tRKKtSQQlxtH34TouIke2UgP/Nn901QLOrJYJmtjzVz8DW3IYVxfci
SBHhbhJTdley5cuEzphELo5NR4gFjBNlxH7G57Hno9+EWILpx302FJMwTgodIBJbXLbPMHou
xQbOL2anOTUMKO8oH0QdQHCtC7hpgoQa7UJYJxDBI+PRaQ/HObkwggaRMIIEeaADAgECAhEA
+d5Wf8lNDHdw+WAbUtoVOzANBgkqhkiG9w0BAQsFADBKMQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MScwJQYDVQQDEx5JZGVuVHJ1c3QgQ29tbWVyY2lhbCBSb290IENBIDEw
HhcNMTUwMjE4MjIyNTE5WhcNMjMwMjE4MjIyNTE5WjA6MQswCQYDVQQGEwJVUzESMBAGA1UE
ChMJSWRlblRydXN0MRcwFQYDVQQDEw5UcnVzdElEIENBIEExMjCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBANGRTTzPCic0kq5L6ZrUJWt5LE/n6tbPXPhGt2Egv7plJMoEpvVJ
JDqGqDYymaAsd8Hn9ZMAuKUEFdlx5PgCkfu7jL5zgiMNnAFVD9PyrsuF+poqmlxhlQ06sFY2
hbhQkVVQ00KCNgUzKcBUIvjv04w+fhNPkwGW5M7Ae5K5OGFGwOoRck9GG6MUVKvTNkBw2/vN
MOd29VGVTtR0tjH5PS5yDXss48Yl1P4hDStO2L4wTsW2P37QGD27//XGN8K6amWB6F2XOgff
/PmlQjQOORT95PmLkwwvma5nj0AS0CVp8kv0K2RHV7GonllKpFDMT0CkxMQKwoj+tWEWJTiD
KSsCAwEAAaOCAoAwggJ8MIGJBggrBgEFBQcBAQR9MHswMAYIKwYBBQUHMAGGJGh0dHA6Ly9j
b21tZXJjaWFsLm9jc3AuaWRlbnRydXN0LmNvbTBHBggrBgEFBQcwAoY7aHR0cDovL3ZhbGlk
YXRpb24uaWRlbnRydXN0LmNvbS9yb290cy9jb21tZXJjaWFscm9vdGNhMS5wN2MwHwYDVR0j
BBgwFoAU7UQZwNPwBovupHu+QucmVMiONnYwDwYDVR0TAQH/BAUwAwEB/zCCASAGA1UdIASC
ARcwggETMIIBDwYEVR0gADCCAQUwggEBBggrBgEFBQcCAjCB9DBFFj5odHRwczovL3NlY3Vy
ZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDADAgEB
GoGqVGhpcyBUcnVzdElEIENlcnRpZmljYXRlIGhhcyBiZWVuIGlzc3VlZCBpbiBhY2NvcmRh
bmNlIHdpdGggSWRlblRydXN0J3MgVHJ1c3RJRCBDZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQg
YXQgaHR0cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L3Rz
L2luZGV4Lmh0bWwwSgYDVR0fBEMwQTA/oD2gO4Y5aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRy
dXN0LmNvbS9jcmwvY29tbWVyY2lhbHJvb3RjYTEuY3JsMB0GA1UdJQQWMBQGCCsGAQUFBwMC
BggrBgEFBQcDBDAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0OBBYEFKRz2u9pNYp1zKAZewgy+GuJ
5ELsMA0GCSqGSIb3DQEBCwUAA4ICAQAN4YKu0vv062MZfg+xMSNUXYKvHwvZIk+6H1pUmivy
DI4I6A3wWzxlr83ZJm0oGIF6PBsbgKJ/fhyyIzb+vAYFJmyI8I/0mGlc+nIQNuV2XY8cypPo
VJKgpnzp/7cECXkX8R4NyPtEn8KecbNdGBdEaG4a7AkZ3ujlJofZqYdHxN29tZPdDlZ8fR36
/mAFeCEq0wOtOOc0Eyhs29+9MIZYjyxaPoTS+l8xLcuYX3RWlirRyH6RPfeAi5kySOEhG1qu
NHe06QIwpigjyFT6v/vRqoIBr7WpDOSt1VzXPVbSj1PcWBgkwyGKHlQUOuSbHbHcjOD8w8wH
SDbL+L2he8hNN54doy1e1wJHKmnfb0uBAeISoxRbJnMMWvgAlH5FVrQWlgajeH/6NbYbBSRx
ALuEOqEQepmJM6qz4oD2sxdq4GMN5adAdYEswkY/o0bRKyFXTD3mdqeRXce0jYQbWm7oapqS
ZBccFvUgYOrB78tB6c1bxIgaQKRShtWR1zMM0JfqUfD9u8Fg7G5SVO0IG/GcxkSvZeRjhYcb
TfqF2eAgprpyzLWmdr0mou3bv1Sq4OuBhmTQCnqxAXr4yVTRYHkp5lCvRgeJAme1OTVpVPth
/O7HJ7VuEP9GOr6kCXCXmjB4P3UJ2oU0NqfoQdcSSSt9hliALnExTEjii20B2nSDojGCAxQw
ggMQAgEBME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UEAxMO
VHJ1c3RJRCBDQSBBMTICEEABbQHWpVVDfbC/HYRdhTowDQYJYIZIAWUDBAIBBQCgggGXMBgG
CSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgwNjEzNDUyNVow
LwYJKoZIhvcNAQkEMSIEIJEH8jCqbxdro6+pvTOlR3dnImQ1a2A/0BECs8CAk5m0MF0GCSsG
AQQBgjcQBDFQME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUGA1UE
AxMOVHJ1c3RJRCBDQSBBMTICEEABbQHWpVVDfbC/HYRdhTowXwYLKoZIhvcNAQkQAgsxUKBO
MDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQg
Q0EgQTEyAhBAAW0B1qVVQ32wvx2EXYU6MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAkXx8esBSKMCg
BEs3hpJlvR+hK9py2cRqMIOC/X6L3dcSYV3hvgKD6WqQH7pT/5UxEng36tl+pphhPRldBNR8
0MbvdcdDiJxm243gej95R4t1uhRpEhfco8+clUs9VuozB5B44fQAVNUVmpUoIZApJZAsAMti
1t61fVC2EN1FbDNl286trdRGH+35dwfR1MNte9hiwxFdkCmuIKeg8mggD8HttOKZGq2s0ZOE
W2x1hsW5OYdlzK672+zxFj/Mqej2K+ekUeG8ZI84fRLIN0F5K5EACHRhT53+FbRvPKo3hl58
VEjaGUwKKNxzaQnQ4sCaFN8g4swefCTj8FpSCUUdygAAAAAAAA==
--------------ms050607090806000609030409--

