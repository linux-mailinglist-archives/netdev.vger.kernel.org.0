Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041D9307F47
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhA1UME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:12:04 -0500
Received: from antares.kleine-koenig.org ([94.130.110.236]:45986 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhA1UJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:09:35 -0500
X-Greylist: delayed 80298 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2021 15:09:34 EST
Received: from antares.kleine-koenig.org (localhost [127.0.0.1])
        by antares.kleine-koenig.org (Postfix) with ESMTP id 2969DAE1E57;
        Thu, 28 Jan 2021 21:08:43 +0100 (CET)
Received: from antares.kleine-koenig.org ([94.130.110.236])
        by antares.kleine-koenig.org (antares.kleine-koenig.org [94.130.110.236]) (amavisd-new, port 10024)
        with ESMTP id NYAo-JJQbWWS; Thu, 28 Jan 2021 21:08:40 +0100 (CET)
Received: from taurus.defre.kleine-koenig.org (unknown [IPv6:2a02:8071:b5ad:20fc:2b29:ca75:841e:b14c])
        by antares.kleine-koenig.org (Postfix) with ESMTPSA;
        Thu, 28 Jan 2021 21:08:40 +0100 (CET)
Subject: Re: [PATCH] vio: make remove callback return void
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Haren Myneni <haren@us.ibm.com>,
        =?UTF-8?Q?Breno_Leit=c3=a3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Steven Royer <seroyer@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20210127215010.99954-1-uwe@kleine-koenig.org>
 <20210128190750.GA490196@us.ibm.com>
From:   =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>
Message-ID: <f3655d10-26ba-5f9f-761e-2f48d13d0b11@kleine-koenig.org>
Date:   Thu, 28 Jan 2021 21:08:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128190750.GA490196@us.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0WS2s8Dj7oAQDuvcAexs4Jz4r6U02PT15"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0WS2s8Dj7oAQDuvcAexs4Jz4r6U02PT15
Content-Type: multipart/mixed; boundary="C8P4GGVXo3CFpsOyigcYdiPTK9L9mB3i8";
 protected-headers="v1"
From: =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>
To: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>,
 Jens Axboe <axboe@kernel.dk>, Matt Mackall <mpm@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Peter Huewe <peterhuewe@gmx.de>,
 Jarkko Sakkinen <jarkko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Haren Myneni <haren@us.ibm.com>, =?UTF-8?Q?Breno_Leit=c3=a3o?=
 <leitao@debian.org>, Nayna Jain <nayna@linux.ibm.com>,
 Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
 Steven Royer <seroyer@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Cristobal Forno <cforno12@linux.ibm.com>, Jakub Kicinski <kuba@kernel.org>,
 Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Michael Cyr <mikecyr@linux.ibm.com>, Jiri Slaby <jirislaby@kernel.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
 netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Message-ID: <f3655d10-26ba-5f9f-761e-2f48d13d0b11@kleine-koenig.org>
Subject: Re: [PATCH] vio: make remove callback return void
References: <20210127215010.99954-1-uwe@kleine-koenig.org>
 <20210128190750.GA490196@us.ibm.com>
In-Reply-To: <20210128190750.GA490196@us.ibm.com>

--C8P4GGVXo3CFpsOyigcYdiPTK9L9mB3i8
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello Sukadev,

On 1/28/21 8:07 PM, Sukadev Bhattiprolu wrote:
> Slightly off-topic, should ndo_stop() also return a void? Its return va=
lue
> seems to be mostly ignored and [...]

I don't know enough about the network stack to tell. Probably it's a=20
good idea to start a separate thread for this and address this to the=20
netdev list only.

Best regards
Uwe



--C8P4GGVXo3CFpsOyigcYdiPTK9L9mB3i8--

--0WS2s8Dj7oAQDuvcAexs4Jz4r6U02PT15
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmATGcQACgkQwfwUeK3K
7AljPggAhaj+JnoGN++1YO/4Nz81FEvRKFR9Eky+A4TCDGs8NvV1eVbhztqchotk
bm71ZlCLS23+/m5xoA/4bjOHPxc0ETs8V37z86n9Tcf/QTiwI1eN4UYU0l7cPqGO
cxuT/eLxm7WQ/kKwlJucUUHREWVCXH5NNTw4/zH9r+qc3MVQ++uUrKjtF94cnkGa
iOO8nW+fhP+e8bVENm+gcTwONaL45UG+qABpFj9mXiWMrA7L0kSEyqG4wUMgeKb3
YUtPKsAuS8xpUhT5C/zEQJ6qWI3rXkGCPEMUMcpWk+ut4McB9mE+TP6XWC36nfFy
uq8ofa7nTpO48ZQIj/PU3d+UIzp2eQ==
=XsiK
-----END PGP SIGNATURE-----

--0WS2s8Dj7oAQDuvcAexs4Jz4r6U02PT15--
