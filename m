Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B661251E4C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHYRas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:30:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35799 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgHYRap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:30:45 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200825173042euoutp01b22f71c75912f610aaa2156d811e4dd1~ukxaUpnqm0388603886euoutp01q;
        Tue, 25 Aug 2020 17:30:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200825173042euoutp01b22f71c75912f610aaa2156d811e4dd1~ukxaUpnqm0388603886euoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1598376643;
        bh=Or1n5f6SHwpOxVUTrFHuHSd/HyZF4iEYUXF9P0VhbM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RnNJeHlwNU7up5bg1RfQikPu+5ZlkbkfYMK6CxACYdQaABMFiut+g+jnlQCb5Yp4N
         pQWLZk9xa6O06BDFvd+L7VD05+bDQsYabw5kjA7a8enfYETJoxVXP4SXTER+I50BSt
         1c7WnDXikLcMjWc3mdGCwFs8vH+eFNjXfD9MxlwM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200825173042eucas1p159e65d2cb712fc319f13efd31bc34d0f~ukxZz4pWT1804618046eucas1p1L;
        Tue, 25 Aug 2020 17:30:42 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id CA.EA.06318.2CA454F5; Tue, 25
        Aug 2020 18:30:42 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200825173041eucas1p29cb450a15648e0ecb1e896fcbe0f9126~ukxZY-0Xv3134031340eucas1p2b;
        Tue, 25 Aug 2020 17:30:41 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200825173041eusmtrp211b91333bc6d6369e113270ae238bb22~ukxZYP9Gg0935109351eusmtrp2f;
        Tue, 25 Aug 2020 17:30:41 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-d5-5f454ac2ade6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id A1.42.06314.1CA454F5; Tue, 25
        Aug 2020 18:30:41 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200825173041eusmtip133253e5150703d96e8aa03660c56898c~ukxZMxiVr3027430274eusmtip1K;
        Tue, 25 Aug 2020 17:30:41 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Date:   Tue, 25 Aug 2020 19:30:30 +0200
In-Reply-To: <6062dc73-99bc-cde0-26a1-5c40ea1447bd@infradead.org> (Randy
        Dunlap's message of "Tue, 25 Aug 2020 10:19:51 -0700")
Message-ID: <dleftjr1ruvdjd.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTut/t0NPm5NA8WEetBGllR5O2hZBTcJEqSIIy0lReL3JTd1IzA
        ZWXlGy2cQ8jSSo2pLRn2UGNNezeHKfkIMaWHZpGPSo3M653gf9855zvf950fP5ZQD1F+7An9
        KcGg18ZpaCVpax53rrGH7Ype11vgw90zVVNcsfMCyV13vKW43L5BgnM6axiuxZZDcda+dopr
        fVhMcyZng4KzX6tHnMXxgeGaSxZyQ92FJHex3sFs9+Rb210EX1vRoeDvlwfw1sorNH+/LJXP
        qa1E/Ih1STgTqdwWI8SdSBIMa0OOKI8XuX7TCW2ep+t7XiIjqpifgTxYwBvB8ctCZyAlq8bl
        CCZdRkYuRhGYSseRXIwgSGt+Ts6u2HIG3St3ELRmGhVy8RnB6+470xOWpXEgWCwHpQVvvAom
        372jJA6B7QS4Rv8Q0mABjoDSttczmMQroDcrfcbbA59D0FLxk5CEVDgIOl3LJI4P3gy1X3oY
        CauwF7wo6p9JRGAdFDm/ITldNgtt50UZ74TeW5KxhBfAwLNaRsaLYerBdYUkDzgVCvI3SbaA
        sxDYiv+4r9wK3W8naBmHQlP+OCPzPeH9kJds6wn5tkJCbqvgcrpaZi+HqtzHbhU/yB4odyfj
        4UnXJfdTXUVwt2CYykNLzXOuMc+5xjwtS2B/qH64Vm6vhts3BgkZB0NV1Q+yBFGVyFdIFHWx
        grhBLyQHilqdmKiPDTwWr7Oi6Y/36t+zsTrU8PeoHWEWaearSuhd0WpKmySm6Oxo+bTSx5q7
        LciP1MfrBY23asebV1FqVYw25YxgiI82JMYJoh0tYkmNr2rDza+H1ThWe0o4KQgJgmF2qmA9
        /Iwodmdk16NBpisv0jSlirBnbllJ+J/hzAcOGxoChvfNo1NyO0LG2DBzWlSM98mmHJ/2vWXd
        fU8qrpaOB3YeeGoutq5P/d5kCU7OuGYkTeFZoROp2oIefqXDf+hQ3Z73E2cj8oLG8PNQY3i/
        b4qyJBeVdnzq+tb4IYLu2L2/cWDLdw0pHteuDyAMovY/WMBmIIADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t/xu7oHvVzjDfZtN7XYOGM9q8Wc8y0s
        FvOPnGO16H/8mtni/PkN7BYXtvWxWmx6fI3V4vKuOWwWM87vY7I4NHUvo8XaI3fZLY4tELN4
        e2c6i0Xr3iPsDnwel69dZPbYsvImk8fmFVoem1Z1snlsXlLv0bdlFaPH501yAexRejZF+aUl
        qQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehkzL35nK7jKV7H3
        /inGBsaVPF2MnBwSAiYS2/pes3UxcnEICSxllHi+/TZ7FyMHUEJKYuXcdIgaYYk/17qgap4y
        Smw4MJsVpIZNQE9i7doIkBoRAQ2J31eusILYzALbmCW61meD2MICgRIP5p1iB7GFBBwk/rde
        YgOxWQRUJR72tLGDzOQUaGSUuLDyIzPITF4Bc4lbF5VBakQFLCW2vLgP1ssrIChxcuYTFoj5
        2RJfVz9nnsAoMAtJahaS1CygScwCmhLrd+lDhLUlli18zQxh20qsW/eeZQEj6ypGkdTS4tz0
        3GJDveLE3OLSvHS95PzcTYzAWN127OfmHYyXNgYfYhTgYFTi4V3A5hovxJpYVlyZe4hRBWjM
        ow2rLzBKseTl56UqifA6nT0dJ8SbklhZlVqUH19UmpNafIjRFOjPicxSosn5wPSSVxJvaGpo
        bmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qB0Wm+3mvxs3WaLqIbrketDQy8
        07x9ok/Nu8OKL8r8Y2UOVtk9zHbKOaBzYMOTtB0Mn5zOptw+377P/pzyvQctPyftP/VUYKZ/
        pJ/TxGqpOpUDKlW3vhQ5zdB81POj9W9q9dwfT506vhbYfFI5NWftw1POW3XCmLo/TVlU1LBy
        v09wUYt+5KQAZyWW4oxEQy3mouJEALC6yGr3AgAA
X-CMS-MailID: 20200825173041eucas1p29cb450a15648e0ecb1e896fcbe0f9126
X-Msg-Generator: CA
X-RootMTR: 20200825173041eucas1p29cb450a15648e0ecb1e896fcbe0f9126
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200825173041eucas1p29cb450a15648e0ecb1e896fcbe0f9126
References: <6062dc73-99bc-cde0-26a1-5c40ea1447bd@infradead.org>
        <CGME20200825173041eucas1p29cb450a15648e0ecb1e896fcbe0f9126@eucas1p2.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-08-25 wto 10:19>, when Randy Dunlap wrote:
> On 8/25/20 10:03 AM, =C5=81ukasz Stelmach wrote:
>> diff --git a/drivers/net/ethernet/asix/Kconfig b/drivers/net/ethernet/as=
ix/Kconfig
>> new file mode 100644
>> index 000000000000..4b127a4a659a
>> --- /dev/null
>> +++ b/drivers/net/ethernet/asix/Kconfig
>> @@ -0,0 +1,20 @@
>> +#
>> +# Asix network device configuration
>> +#
>> +
>> +config NET_VENDOR_ASIX
>> +	bool "Asix devices"
>
> Most vendor entries also have:
> 	default y
> so that they will be displayed in the config menu.

OK.

>> +	depends on SPI
>> +	help
>> +	  If you have a network (Ethernet) interface based on a chip from ASIX=
, say Y
>> +
>> +if NET_VENDOR_ASIX
>> +
>> +config SPI_AX88796C
>> +	tristate "Asix AX88796C-SPI support"
>> +	depends on SPI
>
> That line is redundant (but not harmful).

Why? Is it because NET_VENDOR_ASIX depends on SPI? Probably it
shouldn't. Thanks for spotting.

>> +	depends on GPIOLIB
>> +	help
>> +	  Say Y here if you intend to attach a Asix AX88796C as SPI mode
>> +
>> +endif # NET_VENDOR_ASIX

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl9FSrYACgkQsK4enJil
gBAUJAgAoiKqrS1LhZjmIMWJTRRqqtE0F8elsK7QHkVHD5bkYgd/Kr2zmm/wArKS
3wBPj6qCVUBR2rUQR5DvW+rgSxxGu16IxotAQtlN9ljAIR5MxiqjZWdhq0pUuAJq
+3gXhJgjbBK+Wp8uwoVXuwCYvBakcY2g3zoz2cT6GeDc8Tp3yr51yb8tidUNqtyG
rbx55gRcr0MXhT/OU3wkUQnozFKC3pv+sBuwZ75dKzLe2UwJZ1J737Ywm/kLPF0n
5suIPoghPWG/pyLzbw5RfE1AOhEho70XrEuwBG0eh7U8FMAD7zrmhldMjdGSeXDy
FqFEfsirb4xsQs+tktyVKFt9OAIpqA==
=W6/v
-----END PGP SIGNATURE-----
--=-=-=--
