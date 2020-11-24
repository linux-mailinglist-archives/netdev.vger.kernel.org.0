Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FD22C29B1
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389099AbgKXOa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:30:28 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45322 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388856AbgKXOa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:30:26 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201124143012euoutp02023c4026e0e3db5f6b20a34e0ebb7f58~KeAyRI5Zi1512315123euoutp02i;
        Tue, 24 Nov 2020 14:30:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201124143012euoutp02023c4026e0e3db5f6b20a34e0ebb7f58~KeAyRI5Zi1512315123euoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606228212;
        bh=MFrMbI1rTLy+znrLbraiNi/eB7zLJ2EZB/1abpHAgnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7g8J3nmHe0gUqcO8MjeaMxGUBPoON0om8/Ohsv2FwybXvKuPV+MkKFP0nPM8oIHw
         F09I7mUoGp1x3juj103q+w6MkLDBKyb8P+cHsTCcPkO1jWuvYnXmELxe8TEXwynP6m
         xmsZAzwkUbhnWG649t7xRv0q4tBtvy0/3U++RBuY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201124143012eucas1p1c853cee302f51305077f6250e0cb7a76~KeAx4xgOT2700127001eucas1p1D;
        Tue, 24 Nov 2020 14:30:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 18.0E.44805.3F81DBF5; Tue, 24
        Nov 2020 14:30:11 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201124143011eucas1p182d53a872283904341ed4038d457d817~KeAxODL-y2693126931eucas1p1E;
        Tue, 24 Nov 2020 14:30:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201124143011eusmtrp23afa4305320a0a730958d87c766267cc~KeAxNJHJL2167521675eusmtrp27;
        Tue, 24 Nov 2020 14:30:11 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-8c-5fbd18f36195
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id EB.96.21957.3F81DBF5; Tue, 24
        Nov 2020 14:30:11 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201124143011eusmtip12e6f9dbc616d59211a9c6473bc9f06c3~KeAw5dbwv0236502365eusmtip1e;
        Tue, 24 Nov 2020 14:30:10 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolni?= =?utf-8?Q?erkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Tue, 24 Nov 2020 15:29:50 +0100
In-Reply-To: <20201124121742.GA35334@kozik-lap> (Krzysztof Kozlowski's
        message of "Tue, 24 Nov 2020 13:17:42 +0100")
Message-ID: <dleftj8saqj09t.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djPc7qfJfbGGxxYZW1x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjisklJzcksSy3St0vgymh73s5SMFGh4vH7z+wNjH3SXYycHBICJhIvL19m
        72Lk4hASWMEo8fLSCjYI5wujxIStJ5ggnM+MEr++NrLAtOx78Q4qsZxR4tm3o6wQznNGiZMb
        dwM5HBxsAnoSa9dGgDSICGhKXP/7HayGWeAMi8TvDQvBJgkLhElM+rWWFcRmEVCVWHH4MFic
        U6BM4tubl2wgNq+AuUTLtuPsILaogKXElhf32SHighInZz4Bq2cWyJWYef4NI8gCCYFznBK3
        XxyBOtVFomXfTSYIW1ji1fEt7BC2jMT/nfOZQA6VEKiXmDzJDKK3h1Fi25wfUL3WEnfO/WKD
        sB0l5k//zQpRzydx460gxF4+iUnbpjNDhHklOtqEIKpVJNb174GaIiXR+2oFI4TtIXF/634W
        SFg1MUp8vb+IdQKjwiwk78xC8s4soLHMwLBbv0sfIqwtsWzha2YI21Zi3br3LAsYWVcxiqeW
        FuempxYb5aWW6xUn5haX5qXrJefnbmIEpsTT/45/2cG4/NVHvUOMTByMhxhVgJofbVh9gVGK
        JS8/L1VJhNddeG+8EG9KYmVValF+fFFpTmrxIUZpDhYlcd6kLWvihQTSE0tSs1NTC1KLYLJM
        HJxSDUxrzSN8u3k/xU7w21PSqvrnmayCD5fi9HC1O+WsN85prnhrvEO5cHnawp+3diyduuyK
        tPeNimu6XAHTfDa+1jS/Z1rzvShX1e3e/+9x/somy1yerVjHUN29+Ww34yaJ735pjfqpcnsi
        7pQXF7QtP3tpykdLpkLO6rAbkYdmXuW3/W/2P2PDcUfnoIe8/1zdj3hEhl7wEnC03lH3MDXX
        5c+LHI2y4+quGyrDflcrWS8SXfZI+Ij0K8as/yd5dr5R1045y+wjPq3Wi3FWF9uR+Q4vJCdx
        M8gdmKuobZFuaFkeM//YgtqAU+zXNQp3Lftp8LUmb3LCl8XP7q9TLe+5MI37TcXXKWvvzJCp
        evz29gclluKMREMt5qLiRADuRCPmBAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xu7qfJfbGG5zcxmlx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy2h73s5SMFGh4vH7z+wNjH3SXYycHBICJhL7Xrxj6mLk4hASWMooMfvgWfYuRg6g
        hJTEyrnpEDXCEn+udbFB1DxllJh7cyUbSA2bgJ7E2rURIDUiApoS1/9+ZwWpYRY4zyIx8fAZ
        ZpCEsECIxIbGdkYQWwiovn3STXYQm0VAVWLF4cMsIHM4Bcok5n3mAAnzCphLtGw7DlYiKmAp
        seXFfXaIuKDEyZlPWEBsZoFsia+rnzNPYBSYhSQ1C0lqFtBUZqCT1u/ShwhrSyxb+JoZwraV
        WLfuPcsCRtZVjCKppcW56bnFhnrFibnFpXnpesn5uZsYgbG87djPzTsY5736qHeIkYmD8RCj
        ClDnow2rLzBKseTl56UqifC6C++NF+JNSaysSi3Kjy8qzUktPsRoCvTZRGYp0eR8YJLJK4k3
        NDMwNTQxszQwtTQzVhLn3Tp3TbyQQHpiSWp2ampBahFMHxMHp1QDU4+g/ZHT7NZMT0wC95Qt
        ezEnL2y1zOffWZknu6P+hMrq6culedwTqXuqbTxPwfjMo9czC9XixCMTM6vWin+ROj+pVtUm
        YuWD36KvdbONT8qUdIeonWfOTNU/sCVizkaN4pj6ZYKrX656w/Ru/oITb2Z8eNfG6N78nT2i
        Y/Oz9ftcTPiN2XdJM/Te7lpgcHefcdC1IvF5Fz5dfVDKmHH35MGLFidl9mwPL90UHyXs+fy4
        zTXuqg3BLk9lvd0ntSiXnW+MmKF9JPbn+p371tVLxj1+ylwt+jfsWK5lduaui3pG3c9t6y6X
        nHqnUHF9z4+ER2te1xy4frNddW7ywgNyQnVHy7T32+/v57rj+HZ1gBJLcUaioRZzUXEiAF7W
        ZYh6AwAA
X-CMS-MailID: 20201124143011eucas1p182d53a872283904341ed4038d457d817
X-Msg-Generator: CA
X-RootMTR: 20201124143011eucas1p182d53a872283904341ed4038d457d817
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201124143011eucas1p182d53a872283904341ed4038d457d817
References: <20201124121742.GA35334@kozik-lap>
        <CGME20201124143011eucas1p182d53a872283904341ed4038d457d817@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-11-24 wto 13:17>, when Krzysztof Kozlowski wrote:
> On Tue, Nov 24, 2020 at 01:03:30PM +0100, =C5=81ukasz Stelmach wrote:
>> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> supports SPI connection.
>>=20
>> The driver has been ported from the vendor kernel for ARTIK5[2]
>> boards. Several changes were made to adapt it to the current kernel
>> which include:
>>=20
>> + updated DT configuration,
>> + clock configuration moved to DT,
>> + new timer, ethtool and gpio APIs,
>> + dev_* instead of pr_* and custom printk() wrappers,
>> + removed awkward vendor power managemtn.
>> + introduced ethtool tunable to control SPI compression
>>=20
>> [1]
>> https://protect2.fireeye.com/v1/url?k=3D400e2614-1f951ecd-400fad5b-0cc47=
a3356b2-10d6caf77ede1dd5&q=3D1&e=3D8ef355b1-1777-4137-878d-2b11d6ef0003&u=
=3Dhttps%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PItemI=
D%3D104%3B65%3B86%26PLine%3D65
>> [2]
>> https://protect2.fireeye.com/v1/url?k=3D519692a9-0e0daa70-519719e6-0cc47=
a3356b2-b5daaace05887741&q=3D1&e=3D8ef355b1-1777-4137-878d-2b11d6ef0003&u=
=3Dhttps%3A%2F%2Fgit.tizen.org%2Fcgit%2Fprofile%2Fcommon%2Fplatform%2Fkerne=
l%2Flinux-3.10-artik%2F
>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  MAINTAINERS                                |    6 +
>>  drivers/net/ethernet/Kconfig               |    1 +
>>  drivers/net/ethernet/Makefile              |    1 +
>>  drivers/net/ethernet/asix/Kconfig          |   35 +
>>  drivers/net/ethernet/asix/Makefile         |    6 +
>>  drivers/net/ethernet/asix/ax88796c_ioctl.c |  221 ++++
>>  drivers/net/ethernet/asix/ax88796c_ioctl.h |   26 +
>>  drivers/net/ethernet/asix/ax88796c_main.c  | 1132 ++++++++++++++++++++
>>  drivers/net/ethernet/asix/ax88796c_main.h  |  561 ++++++++++
>>  drivers/net/ethernet/asix/ax88796c_spi.c   |  112 ++
>>  drivers/net/ethernet/asix/ax88796c_spi.h   |   69 ++
>>  include/uapi/linux/ethtool.h               |    1 +
>>  net/ethtool/common.c                       |    1 +
>>  13 files changed, 2172 insertions(+)
>>  create mode 100644 drivers/net/ethernet/asix/Kconfig
>>  create mode 100644 drivers/net/ethernet/asix/Makefile
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
>>  create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
>>=20
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 14b8ec0bb58b..930dc859d4f7 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2812,6 +2812,12 @@ S:	Maintained
>>  F:	Documentation/hwmon/asc7621.rst
>>  F:	drivers/hwmon/asc7621.c
>>=20=20
>> +ASIX AX88796C SPI ETHERNET ADAPTER
>> +M:	=C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> +S:	Maintained
>> +F:	Documentation/devicetree/bindings/net/asix,ax99706c-spi.yaml
>
> Wrong file name.

Fixed. Thanks.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+9GN4ACgkQsK4enJil
gBAGFgf/ak6IDh+/N0xhkzX51vmK3op/V+9xfXS6DG1baHq9lrnatqAbogHBxmxU
XAR6NXrabPEstRxxlSwqBzblZnkm7hNGfutE2smAqPAiJJ7CgvGrB6/++zH8NTgy
2pY7hnVyfRyoY/vThI58gf0uwmo6cxmkwxoFXiLK1Iu3X4xHc/gUCLWJaLwHvVKO
8vCdZXyCnQhBHrNzLpkPzv23iXgP3jYca5JlYlXbcz1jbPImx2fthzYc7EVhiNR5
gKQ+femXLMvxi/FQQUDbDkB68CWjiMeIKE7iqUyPtnApb4+sJipMHokzeZnImy3H
ZgN218Toukd+O8h0ZJmMSRUdzz2RQw==
=/N8t
-----END PGP SIGNATURE-----
--=-=-=--
