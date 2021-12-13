Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615244721C6
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 08:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhLMHcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 02:32:31 -0500
Received: from smtp-4.b-tu.de ([141.43.208.14]:33950 "EHLO smtp-4.b-tu.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhLMHca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 02:32:30 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2021 02:32:30 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp-4.b-tu.de (Postfix) with ESMTP id 4JCCk01RSRzGsZXR;
        Mon, 13 Dec 2021 08:26:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=b-tu.de; h=
        content-transfer-encoding:mime-version:content-type:content-type
        :user-agent:subject:subject:from:from:message-id:date:date
        :received:received:received:received; s=smtp; t=1639380390; x=
        1640244391; bh=zGK22caUpi/1LJKMcO+QhkCjcH3SDuJlbwOin5rU1FY=; b=U
        +OlDJni5cbsHL/zrX7NhERMrBuljcvHeaubdsa1Xd3Dbr4F9a0pQDkErOVTv6rB6
        3m9w28/TAQQ8RZcOICkZ/Fnj8Wim4rnGhGVOdugyLrRzbwUnZ8PMJmXXIOiIMkE6
        Nic9b41u8NOO43XtD2m6WfuLMvVBvlu6KM3Ny6SJuQ=
X-Virus-Scanned: by AMaViS (at smtp-4.b-tu.de)
Received: from smtp-4.b-tu.de ([127.0.0.1])
        by localhost (smtp-4.b-tu.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jIsZeRKj0Jm3; Mon, 13 Dec 2021 08:26:30 +0100 (CET)
Received: from webmail.b-tu.de (webmail.b-tu.de [141.43.208.17])
        by smtp-4.b-tu.de (Postfix) with ESMTPS id 4JCCjy4LtqzGsZXK;
        Mon, 13 Dec 2021 08:26:30 +0100 (CET)
Received: from Webmail.b-tu.De (localhost [127.0.0.1])
        (Authenticated sender: werneand)
        by webmail.b-tu.de (Postfix) with ESMTPA id 53DDE1A4A;
        Mon, 13 Dec 2021 08:26:30 +0100 (CET)
Received: from [212.185.67.148] (212.185.67.148 [212.185.67.148]) by
 www.b-tu.de (Horde Framework) with HTTPS; Mon, 13 Dec 2021 08:26:30 +0100
Date:   Mon, 13 Dec 2021 08:26:30 +0100
Message-ID: <20211213082630.Horde.ZNGY1CvfyMcmXElbyNHgwGJ@webmail.b-tu.de>
From:   =?utf-8?b?QW5kcsOp?= Werner <Andre.Werner@b-tu.de>
To:     netdev@vger.kernel.org
Cc:     andre.werner@systec-electronic.com
Subject: Help: Using DSA capabilities with Microchip KSZ8 Ethernet switch
 and i.MX8plus does not work
User-Agent: Horde Application Framework 5
Content-Type: multipart/mixed; boundary="=_X-53FFg_PdnpQbJ0g9hQSoU"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This message is in MIME format.

--=_X-53FFg_PdnpQbJ0g9hQSoU
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Dear community,

trying to connect a custom board with i.MX8plus SOM to a Microchip  
KSZ8795 Ethernet switch still fails. Searching on the Internet did not  
provide a solution anywhere. I was trying different suggestions and  
follow the steps provided in the DSA documentation. The switch is  
working at the SOM if it is not configured with the ksz8795 driver and  
DSA capabilities. Thus, electrical connections on the custom board  
seem working.

The switch uses tail tagging in the driver, so maybe the connection of  
the i.MX8 FEC driver and its internet acceleration features drop  
frames with length and CRC errors. I tried to disable all that  
RACC-features in the driver and I proved the configuration using  
devmem. It looks reasonable but I still did not see any receiving  
frames or see frames send to the host. Moreover, using VLAN from the  
manual of the DSA documentation still shows tail tagging switched on  
if reading the switch's configuration registers. I was wondering about  
that since I thought that this is not necessary when using VLAN  
capabilities.

Did anyone use an Ethernet switch e.g. Microchip KSZ8 family, with  
similar problems, and get it working?

Thx in advance.

André Werner
SYS TEC electronic AG

--=_X-53FFg_PdnpQbJ0g9hQSoU
Content-Type: application/pgp-keys
Content-Description: PGP Public Key

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.22 (GNU/Linux)

mI0EX5/e0wEEAKhvN7nLqNpIrTL6k0d8yuhXahKc/1+lkUIxU6nAUGmVB3ONxUyn
MuaBGJMWmSfDXQKoJFIm+09XdQAq9INtAleiFrcXWwMHLzvnBjTB8wF/tHTaU8EU
CVDs7ZU+uNlnb9bLu9h0fIpW+7wIzlDYDPOci0VS/CFVPhbRqls7a51bABEBAAG0
NHdlcm5lYW5kIChUaW1lIFRha2VzIFVzIEFsbC4pIDxBbmRyZS5XZXJuZXJAYi10
dS5kZT6IuQQTAQIAIwUCX5/e0wIbLwYLCQgHAwIGFQgKCQsCBRYCAwEAAh4BAheA
AAoJEN/s1QVADNUWof8EAISJiRgrfPaLTFpPHJpYrWz5Ea2CiHH2VkZv01WY9HCw
6aYaDcBNOXf1bgvBO3RW4d4SRdE7fb6r6LvO1i5jB1v1JSCgUYZCv3aLX4tqvO8a
inXXrpypbpqzefODrL/HirLu6LEuj6twwAdOPXKCU+yFQjWgUv5AA301QXmzIVFl
uI0EX5/e0wEEAMCP4iXYB28hGFu2sLXraDKf75g2VqSnqy6kjX4kje3elq4fbscf
fPywdgMtFBj3L1AvTw/QoRrKQGQtC9QSoReqv9Iqo8tJPagL+AX7q6AX/7sAJ9bn
yByZ6Xw6cg52+yy4SmxXI4ki1aQuUuZvM8w3z79zkWk6JUlObe9od9uVABEBAAGJ
AT0EGAECAAkFAl+f3tMCGy4AqAkQ3+zVBUAM1RadIAQZAQIABgUCX5/e0wAKCRDv
leJKNd5FhfeqA/wOzcD+rpCaEXREcxBWC5rIO1ANhX9TqHuh83Y9+Lpea4kavm6h
MMxXw/o6WSIdDIDlawa8gFN3eMOh+NEIVkD3j2sDJqnill40UMqSUmZQyK80X+aE
WjuTfnxX30ZS3T7cSpf8PSj8ur4iF4UuJ7AV64T11wu88twsTkG6r75gYHC4A/9+
E6eAM6+LgyhBQsodlF24r1jkWtF8MufFgxgeWrFVAXV6GSVh0bBolQXbYh3IRnU+
lgO5YEiZ5Z3kvlGwClb8ieY29mHJ4rJz0ULVUrfV+/l2sggGMjf8y3bh/fVSl+8s
d0A1F5CxhvfpQlHjuzXA8QvxhewqvkmeRr5qmtmFxQ==
=W0cT
-----END PGP PUBLIC KEY BLOCK-----
--=_X-53FFg_PdnpQbJ0g9hQSoU--

