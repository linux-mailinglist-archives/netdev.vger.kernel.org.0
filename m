Return-Path: <netdev+bounces-5917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 061E1713559
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14ADF281767
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E45134A9;
	Sat, 27 May 2023 15:08:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E6134A5
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:08:20 +0000 (UTC)
Received: from sequoia-grove.ad.secure-endpoints.com (sequoia-grove.ad.secure-endpoints.com [IPv6:2001:470:1f07:f77:70f5:c082:a96a:5685])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4326CEA
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed;
	d=auristor.com; s=MDaemon; r=y; t=1685200098; x=1685804898;
	i=jaltman@auristor.com; q=dns/txt; h=Message-ID:Date:
	MIME-Version:User-Agent:From:Subject:To:Cc:References:
	Content-Language:Organization:In-Reply-To:Content-Type; bh=+vI3b
	zalYhKXw28rKlCaLq7EHUeIlgldBrhHvSq7J90=; b=YwgGB3eTWHEmUOecSb5YT
	pV23BzgcZHJGy+MjPD8YOIWNXX9g30As5SjkR5QMy4PZRtys4bi88qJ30UYCg6WD
	ZmYMEXWr3S/z2n/FZc4SsiVFuWlw3wbYjk6fb2LxsdpMyvL6Cbt/wo47xIPY50vp
	HATflXObPVFcFcAtzYo7jc=
X-MDAV-Result: clean
X-MDAV-Processed: sequoia-grove.ad.secure-endpoints.com, Sat, 27 May 2023 11:08:18 -0400
Received: from [IPV6:2603:7000:73c:9c99:401:2567:fdc3:c2b4] by auristor.com (IPv6:2001:470:1f07:f77:28d9:68fb:855d:c2a5) (MDaemon PRO v23.0.2c) 
	with ESMTPSA id md5001003473523.msg; Sat, 27 May 2023 11:08:17 -0400
X-Spam-Processed: sequoia-grove.ad.secure-endpoints.com, Sat, 27 May 2023 11:08:17 -0400
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 2603:7000:73c:9c99:401:2567:fdc3:c2b4
X-MDHelo: [IPV6:2603:7000:73c:9c99:401:2567:fdc3:c2b4]
X-MDArrival-Date: Sat, 27 May 2023 11:08:17 -0400
X-MDOrigin-Country: US, NA
X-Authenticated-Sender: jaltman@auristor.com
X-Return-Path: prvs=1511ba3f43=jaltman@auristor.com
X-Envelope-From: jaltman@auristor.com
X-MDaemon-Deliver-To: netdev@vger.kernel.org
Message-ID: <f1d7630f-f6e2-5748-9b75-579babed0953@auristor.com>
Date: Sat, 27 May 2023 11:08:10 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
From: Jeffrey E Altman <jaltman@auristor.com>
Subject: Re: [PATCH net] rxrpc: Truncate UTS_RELEASE for rxrpc version
To: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc: Kenny Ho <Kenny.Ho@amd.com>, Marc Dionne <marc.dionne@auristor.com>,
 Andrew Lunn <andrew@lunn.ch>, David Laight <David.Laight@ACULAB.COM>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
References: <654974.1685100894@warthog.procyon.org.uk>
Content-Language: en-US
Organization: AuriStor, Inc.
In-Reply-To: <654974.1685100894@warthog.procyon.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030001030300050008010007"
X-MDCFSigsAdded: auristor.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a cryptographically signed message in MIME format.

--------------ms030001030300050008010007
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/26/2023 7:34 AM, David Howells wrote:
> UTS_RELEASE has a maximum length of 64 which can cause rxrpc_version to
> exceed the 65 byte message limit.
>
> Per the rx spec[1]: "If a server receives a packet with a type value 
> of 13,
> and the client-initiated flag set, it should respond with a 65-byte 
> payload
> containing a string that identifies the version of AFS software it is
> running."
>
> The current implementation causes a compile error when WERROR is turned on
> and/or UTS_RELEASE exceeds the length of 49 (making the version string 
> more
> than 64 characters).
>
> Fix this by generating the string during module initialisation and 
> limiting
> the UTS_RELEASE segment of the string does not exceed 49 chars. We need to
> make sure that the 64 bytes includes "linux-" at the front and " AF_RXRPC"
> at the back as this may be used in pattern matching.
>
> Fixes: 44ba06987c0b ("RxRPC: Handle VERSION Rx protocol packets")
> Reported-by: Kenny Ho <Kenny.Ho@amd.com>
> Link: https://lore.kernel.org/r/20230523223944.691076-1-Kenny.Ho@amd.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Kenny Ho <Kenny.Ho@amd.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: Andrew Lunn <andrew@lunn.ch>
> cc: David Laight <David.Laight@ACULAB.COM>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: linux-afs@lists.infradead.org
> cc: netdev@vger.kernel.org
> Link: https://web.mit.edu/kolya/afs/rx/rx-spec [1]
> ---
> net/rxrpc/af_rxrpc.c | 1 +
> net/rxrpc/ar-internal.h | 1 +
> net/rxrpc/local_event.c | 11 ++++++++++-
> 3 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
> index 31f738d65f1c..da0b3b5157d5 100644
> --- a/net/rxrpc/af_rxrpc.c
> +++ b/net/rxrpc/af_rxrpc.c
> @@ -980,6 +980,7 @@ static int __init af_rxrpc_init(void)
> BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > sizeof_field(struct 
> sk_buff, cb));
> ret = -ENOMEM;
> + rxrpc_gen_version_string();
> rxrpc_call_jar = kmem_cache_create(
> "rxrpc_call_jar", sizeof(struct rxrpc_call), 0,
> SLAB_HWCACHE_ALIGN, NULL);
> diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
> index 5d44dc08f66d..e8e14c6f904d 100644
> --- a/net/rxrpc/ar-internal.h
> +++ b/net/rxrpc/ar-internal.h
> @@ -1068,6 +1068,7 @@ int rxrpc_get_server_data_key(struct 
> rxrpc_connection *, const void *, time64_t,
> /*
> * local_event.c
> */
> +void rxrpc_gen_version_string(void);
> void rxrpc_send_version_request(struct rxrpc_local *local,
> struct rxrpc_host_header *hdr,
> struct sk_buff *skb);
> diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
> index 5e69ea6b233d..993c69f97488 100644
> --- a/net/rxrpc/local_event.c
> +++ b/net/rxrpc/local_event.c
> @@ -16,7 +16,16 @@
> #include <generated/utsrelease.h>
> #include "ar-internal.h"
> -static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " 
> AF_RXRPC";
> +static char rxrpc_version_string[65]; // "linux-" UTS_RELEASE " 
> AF_RXRPC";
> +
> +/*
> + * Generate the VERSION packet string.
> + */
> +void rxrpc_gen_version_string(void)
> +{
> + snprintf(rxrpc_version_string, sizeof(rxrpc_version_string),
> + "linux-%.49s AF_RXRPC", UTS_RELEASE);
> +}
> /*
> * Reply to a version request
>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>





--------------ms030001030300050008010007
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DHEwggXSMIIEuqADAgECAhBAAYJpmi/rPn/F0fJyDlzMMA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEz
MB4XDTIyMDgwNDE2MDQ0OFoXDTI1MTAzMTE2MDM0OFowcDEvMC0GCgmSJomT8ixkAQETH0Ew
MTQxMEQwMDAwMDE4MjY5OUEyRkQyMDAwMjMzQ0QxGTAXBgNVBAMTEEplZmZyZXkgRSBBbHRt
YW4xFTATBgNVBAoTDEF1cmlTdG9yIEluYzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCkC7PKBBZnQqDKPtZPMLAy77zo2DPvwtGnd1hNjPvbXrpGxUb3
xHZRtv179LHKAOcsY2jIctzieMxf82OMyhpBziMPsFAG/ukihBMFj3/xEeZVso3K27pSAyyN
fO/wJ0rX7G+ges22Dd7goZul8rPaTJBIxbZDuaykJMGpNq4PQ8VPcnYZx+6b+nJwJJoJ46kI
EEfNh3UKvB/vM0qtxS690iAdgmQIhTl+qfXq4IxWB6b+3NeQxgR6KLU4P7v88/tvJTpxIKkg
9xj89ruzeThyRFd2DSe3vfdnq9+g4qJSHRXyTft6W3Lkp7UWTM4kMqOcc4VSRdufVKBQNXjG
IcnhAgMBAAGjggKcMIICmDAOBgNVHQ8BAf8EBAMCBPAwgYQGCCsGAQUFBwEBBHgwdjAwBggr
BgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVudHJ1c3QuY29tMEIGCCsGAQUF
BzAChjZodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NlcnRzL3RydXN0aWRjYWEx
My5wN2MwHwYDVR0jBBgwFoAULbfeG1l+KpguzeHUG+PFEBJe6RQwCQYDVR0TBAIwADCCASsG
A1UdIASCASIwggEeMIIBGgYLYIZIAYb5LwAGAgEwggEJMEoGCCsGAQUFBwIBFj5odHRwczov
L3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRt
bDCBugYIKwYBBQUHAgIwga0MgapUaGlzIFRydXN0SUQgQ2VydGlmaWNhdGUgaGFzIGJlZW4g
aXNzdWVkIGluIGFjY29yZGFuY2Ugd2l0aCBJZGVuVHJ1c3QncyBUcnVzdElEIENlcnRpZmlj
YXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRp
ZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBFBgNVHR8EPjA8MDqgOKA2hjRodHRwOi8v
dmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC90cnVzdGlkY2FhMTMuY3JsMB8GA1UdEQQY
MBaBFGphbHRtYW5AYXVyaXN0b3IuY29tMB0GA1UdDgQWBBQB+nzqgljLocLTsiUn2yWqEc2s
gjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAJwV
eycprp8Ox1npiTyfwc5QaVaqtoe8Dcg2JXZc0h4DmYGW2rRLHp8YL43snEV93rPJVk6B2v4c
WLeQfaMrnyNeEuvHx/2CT44cdLtaEk5zyqo3GYJYlLcRVz6EcSGHv1qPXgDT0xB/25etwGYq
utYF4Chkxu4KzIpq90eDMw5ajkexw+8ARQz4N5+d6NRbmMCovd7wTGi8th/BZvz8hgKUiUJo
Qle4wDxrdXdnIhCP7g87InXKefWgZBF4VX21t2+hkc04qrhIJlHrocPG9mRSnnk2WpsY0MXt
a8ivbVKtfpY7uSNDZSKTDi1izEFH5oeQdYRkgIGb319a7FjslV8wggaXMIIEf6ADAgECAhBA
AXA7OrqBjMk8rp4OuNQSMA0GCSqGSIb3DQEBCwUAMEoxCzAJBgNVBAYTAlVTMRIwEAYDVQQK
EwlJZGVuVHJ1c3QxJzAlBgNVBAMTHklkZW5UcnVzdCBDb21tZXJjaWFsIFJvb3QgQ0EgMTAe
Fw0yMDAyMTIyMTA3NDlaFw0zMDAyMTIyMTA3NDlaMDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQK
EwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEzMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAu6sUO01SDD99PM+QdZkNxKxJNt0NgQE+Zt6ixaNP0JKSjTd+SG5L
wqxBWjnOgI/3dlwgtSNeN77AgSs+rA4bK4GJ75cUZZANUXRKw/et8pf9Qn6iqgB63OdHxBN/
15KbM3HR+PyiHXQoUVIevCKW8nnlWnnZabT1FejOhRRKVUg5HACGOTfnCOONrlxlg+m1Vjgn
o1uNqNuLM/jkD1z6phNZ/G9IfZGI0ppHX5AA/bViWceX248VmefNhSR14ADZJtlAAWOi2un0
3bqrBPHA9nDyXxI8rgWLfUP5rDy8jx2hEItg95+ORF5wfkGUq787HBjspE86CcaduLka/Bk2
VwIDAQABo4IChzCCAoMwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwgYkG
CCsGAQUFBwEBBH0wezAwBggrBgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVu
dHJ1c3QuY29tMEcGCCsGAQUFBzAChjtodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29t
L3Jvb3RzL2NvbW1lcmNpYWxyb290Y2ExLnA3YzAfBgNVHSMEGDAWgBTtRBnA0/AGi+6ke75C
5yZUyI42djCCASQGA1UdIASCARswggEXMIIBEwYEVR0gADCCAQkwSgYIKwYBBQUHAgEWPmh0
dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20vY2VydGlmaWNhdGVzL3BvbGljeS90cy9pbmRl
eC5odG1sMIG6BggrBgEFBQcCAjCBrQyBqlRoaXMgVHJ1c3RJRCBDZXJ0aWZpY2F0ZSBoYXMg
YmVlbiBpc3N1ZWQgaW4gYWNjb3JkYW5jZSB3aXRoIElkZW5UcnVzdCdzIFRydXN0SUQgQ2Vy
dGlmaWNhdGUgUG9saWN5IGZvdW5kIGF0IGh0dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20v
Y2VydGlmaWNhdGVzL3BvbGljeS90cy9pbmRleC5odG1sMEoGA1UdHwRDMEEwP6A9oDuGOWh0
dHA6Ly92YWxpZGF0aW9uLmlkZW50cnVzdC5jb20vY3JsL2NvbW1lcmNpYWxyb290Y2ExLmNy
bDAdBgNVHQ4EFgQULbfeG1l+KpguzeHUG+PFEBJe6RQwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4ICAQB/7BKcygLX6Nl4a03cDHt7TLdPxCzFvDF2
bkVYCFTRX47UfeomF1gBPFDee3H/IPlLRmuTPoNt0qjdpfQzmDWN95jUXLdLPRToNxyaoB5s
0hOhcV6H08u3FHACBif55i0DTDzVSaBv0AZ9h1XeuGx4Fih1Vm3Xxz24GBqqVudvPRLyMJ7u
6hvBqTIKJ53uCs3dyQLZT9DXnp+kJv8y7ZSAY+QVrI/dysT8avtn8d7k7azNBkfnbRq+0e88
QoBnel6u+fpwbd5NLRHywXeH+phbzULCa+bLPRMqJaW2lbhvSWrMHRDy3/d8HvgnLCBFK2s4
Spns4YCN4xVcbqlGWzgolHCKUH39vpcsDo1ymZFrJ8QR6ihIn8FmJ5oKwAnnd/G6ADXFC9bu
db9+532phSAXOZrrecIQn+vtP366PC+aClAPsIIDJDsotS5z4X2JUFsNIuEgXGqhiKE7SuZb
rFG9sdcLprSlJN7TsRDc0W2b9nqwD+rj/5MN0C+eKwha+8ydv0+qzTyxPP90KRgaegGowC4d
UsZyTk2n4Z3MuAHX5nAZL/Vh/SyDj/ajorV44yqZBzQ3ChKhXbfUSwe2xMmygA2Z5DRwMRJn
p/BscizYdNk2WXJMTnH+wVLN8sLEwEtQR4eTLoFmQvrK2AMBS9kW5sBkMzINt/ZbbcZ3F+eA
MDGCAxQwggMQAgEBME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUG
A1UEAxMOVHJ1c3RJRCBDQSBBMTMCEEABgmmaL+s+f8XR8nIOXMwwDQYJYIZIAWUDBAIBBQCg
ggGXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDUyNzE1
MDgxMFowLwYJKoZIhvcNAQkEMSIEIGbsQJUdUhwpgw/Jn6gMy9RNWVyC/ar1CDFNphLmj2MU
MF0GCSsGAQQBgjcQBDFQME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEX
MBUGA1UEAxMOVHJ1c3RJRCBDQSBBMTMCEEABgmmaL+s+f8XR8nIOXMwwXwYLKoZIhvcNAQkQ
AgsxUKBOMDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRy
dXN0SUQgQ0EgQTEzAhBAAYJpmi/rPn/F0fJyDlzMMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAc9XE
SKytfDPUBt6envzloCqaZBX4jzSPSV0AKcR9PkCsMAgflBWvxgnsqD1uOqR2iWJTeu5fqu6O
AhhHQJ0UaBoMGVlSrS2LmNQ9vEJ9hlb4EqPKxaIi54ZoM6Cj06ftfAGtZ9CRYCwxMLeZE3PT
rbLUfiIIFqcdh09XNDcH8cqsG0LwBhTuj9Fcw3qdhYge9DQ44yTZSi1EdoOhz3vLlP8z9SAX
nR6Plve836KH33RIuRKf16Q5YQNZ45syLakQM+jsARwWDVu1BjabcUEwYYNqNRej+ZANpPrf
M1KeSBfKp5w6WcSCAAtLVSO9OqvSSfcGF/tYdPUpIg1cxNJTQgAAAAAAAA==
--------------ms030001030300050008010007--


