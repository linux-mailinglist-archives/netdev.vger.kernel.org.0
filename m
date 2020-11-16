Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33DC2B4974
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbgKPPeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:34:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43641 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731246AbgKPPeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 10:34:05 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201116153352euoutp0106ff13bdf5872be8ff29064d70ad696f~IBuFsw4023046530465euoutp01R;
        Mon, 16 Nov 2020 15:33:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201116153352euoutp0106ff13bdf5872be8ff29064d70ad696f~IBuFsw4023046530465euoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605540832;
        bh=m0k3+eSeLWCICP7BKzTsnQn/EWujqoJBtu4lSVOfN8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=soOhkd5Y6XHFF0mnea07GZJ0Szmn6s/u3rT36/wz2qqd1rHNPcXiqU0hZXmHgk4Zh
         52zYGxBo84p3QX+kdfog8T+FDo5v8rOuc0mkY3sLE2RKPUb6uVaP/15rHnUz5ryFWP
         omrtg1WGJzxHZp0bjeiSSPa0If4/qUaT62liXqo8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201116153345eucas1p1b31f07006957cb0f86adb0c41f04ade4~IBt-nCXMB1965819658eucas1p1l;
        Mon, 16 Nov 2020 15:33:45 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 15.56.44805.9DB92BF5; Mon, 16
        Nov 2020 15:33:45 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201116153345eucas1p24790148b7fd52a7ae1c055cc7b832bd7~IBt_-CmIs0103401034eucas1p2R;
        Mon, 16 Nov 2020 15:33:45 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201116153345eusmtrp2a5daf8e25632a5659e74528c8ae531f3~IBt_4Lx-a0350903509eusmtrp2h;
        Mon, 16 Nov 2020 15:33:45 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-af-5fb29bd9916f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 0E.13.21957.8DB92BF5; Mon, 16
        Nov 2020 15:33:44 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201116153344eusmtip19d566479076bdfe45b280444e9471cc2~IBt_qam3Y0581905819eusmtip18;
        Mon, 16 Nov 2020 15:33:44 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolni?= =?utf-8?Q?erkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v6 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Mon, 16 Nov 2020 16:33:26 +0100
In-Reply-To: <20201113123508.3920de4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 13 Nov 2020 12:35:08 -0800")
Message-ID: <dleftjblfxl3jt.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHKsWRmVeSWpSXmKPExsWy7djP87o3Z2+KN9jyTt/i/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Vi0+NrrBaXd81hs5hxfh+T
        xaGpexkt1h65y25xbIGYReveI+wOAh6Xr11k9tiy8iaTx85Zd9k9Nq3qZPPYvKTeY+eOz0we
        fVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlbF1vULBVvmK1b3fWRoYm6W7GDk5JARMJFom3mYB
        sYUEVjBKrD0Y0MXIBWR/YZRouzabDcL5zCgx9f5uVpiOrve/GCESyxklJnydxArhPGeUeDnr
        O5DDwcEmoCexdm0ESIOIgIpEy+aZLCA1zAIXWSTWd39mAakRFgiT+DmtGKSGRUBVYsf+ZrAz
        OAWmMUrMPZAMYvMKmEucmfEIbLGogKXElhf32SHighInZz4Bq2cWyJWYef4N2EESAqc4JXp2
        PGWEuNRF4t6FNVBXC0u8Or6FHcKWkfi/cz4TyA0SAvUSkyeZQfT2MEpsm/ODBaLGWuLOuV9s
        ELajxOklu9gg6vkkbrwVhNjLJzFp23RmiDCvREebEES1isS6/j1QU6Qkel+tgLrGQ+Lj5p1s
        8HD7vOQqywRGhVlI3pmF5J1ZQGOZBTQl1u/ShwhrSyxb+JoZwraVWLfuPcsCRtZVjOKppcW5
        6anFRnmp5XrFibnFpXnpesn5uZsYgcnw9L/jX3YwLn/1Ue8QIxMH4yFGFaDmRxtWX2CUYsnL
        z0tVEuF1MdkYL8SbklhZlVqUH19UmpNafIhRmoNFSZw3acuaeCGB9MSS1OzU1ILUIpgsEwen
        VANT59evKToJ7Q+lPm5at/z4bDkFxkZdld0mgpaH1ESvfl9Z48mwgSnM8O8CiZDpB2bP2m1t
        /KzoRmzI4VMO6noPTL5O9DEsstkYtViEe9e9zTPtX37coPi18VDpHK3rr3tmp7RGp+c94lx+
        ZUpd48HXZt8qj9b+fSrT8mvlFl5l9sUzUx0bFx3cktzbV6poZvdPzatM1+QGw7f+7q8MgSoy
        0ml/vu462TNZ39bz+pa1q2P4FMr6Q/t3dPX6ik6dwxXek114zda6rNaz9UD0nvWpGf2Zxkl3
        Wmrenv+8TDL53Iu54Q5C6X1i8154TFZL/86VbtviwzPxYMHZnQ+bPd4/PPxe8PksExl3pzm1
        /CuUWIozEg21mIuKEwG27oGeAQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xu7o3Z2+KN2iUtzh/9xCzxcYZ61kt
        5pxvYbGYf+Qcq8Wi9zNYLa69vcNq0f/4NbPF+fMb2C0ubOtjtdj0+BqrxeVdc9gsZpzfx2Rx
        aOpeRou1R+6yWxxbIGbRuvcIu4OAx+VrF5k9tqy8yeSxc9Zddo9NqzrZPDYvqffYueMzk0ff
        llWMHp83yQVwROnZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJal
        FunbJehlbF2vULBVvmJ173eWBsZm6S5GTg4JAROJrve/GLsYuTiEBJYySnTMOc7axcgBlJCS
        WDk3HaJGWOLPtS42iJqnjBL3X34Aq2ET0JNYuzYCpEZEQEWiZfNMFpAaZoErLBKrPrawgiSE
        BUIk2ladYwGxhQSCJTbu28cOYrMIqErs2N8MFucUmMYoMfdAMojNK2AucWbGI7BeUQFLiS0v
        7rNDxAUlTs58AlbPLJAt8XX1c+YJjAKzkKRmIUnNAjqPWUBTYv0ufYiwtsSyha+ZIWxbiXXr
        3rMsYGRdxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERjJ24793LyDcd6rj3qHGJk4GA8xqgB1
        Ptqw+gKjFEtefl6qkgivi8nGeCHelMTKqtSi/Pii0pzU4kOMpkCvTWSWEk3OB6aYvJJ4QzMD
        U0MTM0sDU0szYyVx3q1z18QLCaQnlqRmp6YWpBbB9DFxcEo1MHne0Pg2Y3ufysUu4WT35D9C
        Tifm5jos/dZedC6/nmvSkRsXmwukfKK5Y24IejMl5P97J9Gzoll2b9jqiVP8/uu3CqZd1J1h
        7ZthPYlRZpeItjB3DPdWpusPYriNb/+36bwtHs7zqbZhjZt88j3jFrGNm8wi2PXSdsXMTRW9
        /Wim/e7cf4u2HuCftF55VWHZyeuidarvtS8dd4t+5z7x7kfmuvIJuU0nTt5Y9j+GrfuLyOcP
        ChOmfuSVOTd5ixL/55YQ+1WzYlJf56htDk1tZ3KewrFI1EOfqZT5TFx+XOROPXE7R7frDmZq
        +74sCvq0okvBv+3sfUdh2bLNl14ufZ3r8vnh4R2h1mW+PxboKrEUZyQaajEXFScCAGDV5r55
        AwAA
X-CMS-MailID: 20201116153345eucas1p24790148b7fd52a7ae1c055cc7b832bd7
X-Msg-Generator: CA
X-RootMTR: 20201116153345eucas1p24790148b7fd52a7ae1c055cc7b832bd7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201116153345eucas1p24790148b7fd52a7ae1c055cc7b832bd7
References: <20201113123508.3920de4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201116153345eucas1p24790148b7fd52a7ae1c055cc7b832bd7@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-11-13 pi=C4=85 12:35>, when Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 12:51:04 +0100 =C5=81ukasz Stelmach wrote:
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
>> https://protect2.fireeye.com/v1/url?k=3D96d0e769-c94bde24-96d16c26-0cc47=
aa8f5ba-09ef5c65a6139da8&q=3D1&e=3D472aea40-d885-45aa-bc04-66e70be69a4c&u=
=3Dhttps%3A%2F%2Fwww.asix.com.tw%2Fproducts.php%3Fop%3DpItemdetail%26PItemI=
D%3D104%3B65%3B86%26PLine%3D65
>> [2]
>> https://protect2.fireeye.com/v1/url?k=3D3834941b-67afad56-38351f54-0cc47=
aa8f5ba-067355624cc12466&q=3D1&e=3D472aea40-d885-45aa-bc04-66e70be69a4c&u=
=3Dhttps%3A%2F%2Fgit.tizen.org%2Fcgit%2Fprofile%2Fcommon%2Fplatform%2Fkerne=
l%2Flinux-3.10-artik%2F
>>=20
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>
> Please make sure the new code builds cleanly with W=3D1 C=3D1
>
> ../drivers/net/ethernet/asix/ax88796c_ioctl.c:221:19: warning: initialize=
d field overwritten [-Woverride-init]
>   221 |  .get_msglevel  =3D ax88796c_ethtool_getmsglevel,
>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/asix/ax88796c_ioctl.c:221:19: note: (near initial=
ization for =E2=80=98ax88796c_ethtool_ops.get_msglevel=E2=80=99)
> ../drivers/net/ethernet/asix/ax88796c_ioctl.c:222:19: warning: initialize=
d field overwritten [-Woverride-init]
>   222 |  .set_msglevel  =3D ax88796c_ethtool_setmsglevel,
>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/asix/ax88796c_ioctl.c:222:19: note: (near initial=
ization for =E2=80=98ax88796c_ethtool_ops.set_msglevel=E2=80=99)
> In file included from ../drivers/net/ethernet/asix/ax88796c_main.h:15,
>                  from ../drivers/net/ethernet/asix/ax88796c_ioctl.c:16:
> ../drivers/net/ethernet/asix/ax88796c_spi.h:25:17: warning: =E2=80=98tx_c=
md_buf=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>    25 | static const u8 tx_cmd_buf[4] =3D {AX_SPICMD_WRITE_TXQ, 0xFF, 0xF=
F, 0xFF};
>       |                 ^~~~~~~~~~

I fixed the problems reported by W=3D1, but I am afraid I can't do
anything about C=3D1. sparse is is reporting

[...]
./include/linux/atomic-fallback.h:266:16: error: Expected ; at end ofdeclar=
ation
./include/linux/atomic-fallback.h:266:16: error: got ret
./include/linux/atomic-fallback.h:267:1: error: Expected ; at the end of ty=
pe declaration
./include/linux/atomic-fallback.h:267:1: error: too many errors
Segmentation fault

in the headers and gets killed.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+ym8YACgkQsK4enJil
gBCPRQf7Bxu8ESSLzfLd1U4jXdzFD7HFLwqvUqDnK3tVI6nN0Xtd00jqLdRjpcei
Qxr3dIH0moYdE7vgVdWof0p38D0aVE/tWZXT+l4IsifEq3cSbW66sEvBiq8S9ZsE
Tsbru/aoOv1eV4BOinfcMdudpjkoXbJNbS55QwIimk9YOSQrNudl121WxdgfHCIt
TRlSUfS2G7pbJJkGdz+UMkjfym6X2dGebvaV4WOrJ5WY/oheYBXG6trMHmiR9GGw
jl56jGOjryUJQiyPFaWEjkJxTBS5qSz5LrgPWK/YM80bcQorzaIEEbtEtiQDC5Cw
WzgNGCjjyiTPgSh+cp9Df4IGFWEVkQ==
=2T1s
-----END PGP SIGNATURE-----
--=-=-=--
