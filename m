Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6ED295C59
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896260AbgJVKBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:01:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40363 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896238AbgJVKBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:01:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201022100134euoutp025be691abde8c6062155d9a70b3f11a3a~ASD0upesq0814608146euoutp02Y;
        Thu, 22 Oct 2020 10:01:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201022100134euoutp025be691abde8c6062155d9a70b3f11a3a~ASD0upesq0814608146euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603360895;
        bh=YU1Fv/ttpEpVPZU+XlwguPCLHB55EOv3PdTxNJ0j1/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGViQhYppwuf0e36nOvToOgb0MHOWDkHDaPqTiw7/LObW7QBjRSciSfO8gRYDE7Zr
         HsYAcSHVyJGH3CxyBZu7zhNpACD4O77aeR3GixNnUHpBx08hSwvfaJuKVOeeYiSyML
         1m5f/O04soUCLRVFQKgPw9OV7excKVJHvLgoFCSY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201022100134eucas1p133bcc1bdb7f80ad94a1a5b9208ad8b2b~ASD0TOYA71643516435eucas1p1r;
        Thu, 22 Oct 2020 10:01:34 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A6.B4.05997.E78519F5; Thu, 22
        Oct 2020 11:01:34 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201022100133eucas1p132ef97a9ac767bd357f50034c47d6d1a~ASDzv7eeb2303823038eucas1p1H;
        Thu, 22 Oct 2020 10:01:33 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201022100133eusmtrp116fa2defb18d1eff8c31c4f48b5578e9~ASDzu3t9-2212222122eusmtrp1r;
        Thu, 22 Oct 2020 10:01:33 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-48-5f91587e4396
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 40.78.06017.D78519F5; Thu, 22
        Oct 2020 11:01:33 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201022100133eusmtip2717fc66de10490e36b86b7891c78e5a6~ASDzifFn71262512625eusmtip2h;
        Thu, 22 Oct 2020 10:01:33 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v3 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Thu, 22 Oct 2020 12:01:23 +0200
In-Reply-To: <633bbf18-1aec-4b2a-7967-898cde1930aa@samsung.com> (Marek
        Szyprowski's message of "Thu, 22 Oct 2020 09:15:50 +0200")
Message-ID: <dleftjzh4ezij0.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTURzHO7v3btfR6jin/VqiMQxSSXtI3Z6kGFxIoghEDbNlF125KZvL
        B5Q9dFQutZmoY6iJmVk+srnSMm1JYpYzFFNRelhU2gu0yNRKdw3673t+v8/3+/udw6EJ6Qwl
        p1WaZE6rUSYohGLS9niqe83JiEsxa5/XyRnHiJ1gbhXVUYzFkUkype3dFFP+tYhi+j8PU0zu
        6DjBOBz1IqbHlkMxDaP9FNPbbBEyRY4HAsZe0IKYmvYREfO4zIPJamkX7cRsb/9zgrVeHxSw
        TeYREdtQfV7I3q7IYJvuTgjYHGs1YicavPbSUeJtR7gE1XFOG7jjkDi+c3qKSGqHVFtb2inU
        5H4BudCAg6DnfC9xAYlpKa5C8P1pCeIPkwjut3aQ85QUTyAoqdT/c8xOzwp46BqCn8aaBcd7
        BD8qz851aFqIA6CmJmLeIMOBkG3oczIEvkPC4BOzM9UNh0NzcQsxr0m8CgYM35x7uOCzCCzd
        X5yQBG8C44tywbx2x5vB+uGliK+7QmfxWydDYDUUOz45JwC+SkOpaci5BeBQuJyZzK/tBmMd
        VhGvPaEr30jySAbkmzbyViMCm+UnyTNbYbj7l5DXwVD2xybi+SUw8NmVH7sETLZCgi9L4JxB
        ytM+UJt7fyFFDhfHqhCvWbjX+HDhrUwIXhusgjy00vzfbcz/3cY8F0tgX6hrDuTL/lB5ZZzg
        9Xaorf1KliGqGi3j9Dp1HKdbr+FSAnRKtU6viQuITVQ3oLl/2PW7Y/Iuap45bEeYRorFkm9h
        eTFSSnlcl6a2I5+5pDf1N3qQnNQkajiFTBLyrOugVHJEmZbOaRNjtPoETmdHK2hSsUyyofxj
        tBTHKZO5YxyXxGn/dQW0i/wU8q7llgb5rsBDsptcrNdE6XhxaKssN/JkeWrfoxAUlVa4qGBf
        xrC1/uMhyeSDMO8SVUrF7jBDtD9q06vGxauP5s+oOrYEh8hls9aNo95+axo3x54+8MojuH66
        bUwQG7mt8wSEx0eEJe16JwlYnn7Gc7Yx2/3ElNG0v3VPV1Yom6cgdfHKdX6EVqf8C723AH+P
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t/xe7q1ERPjDTatNLQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSW
        pRbp2yXoZZz8/ZO54IhExbYDlQ2MO0W7GDk5JARMJP7+/svUxcjFISSwlFHi3ucVjF2MHEAJ
        KYmVc9MhaoQl/lzrYoOoecoosfTbNGaQGjYBPYm1ayNAakQE9CW6264wgtQwC+xikdj0cQE7
        SEJYIETiTNtGVhBbSMBO4viUGSwgNouAqsSNtg/MIA2cAs2MEnPOvQNL8AqYS/RcX8QEYosK
        WEpseXGfHSIuKHFy5hOwGmaBbImvq58zT2AUmIUkNQtJahbQfcwCmhLrd+lDhLUlli18zQxh
        20qsW/eeZQEj6ypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzAaN527OeWHYxd74IPMQpwMCrx
        8H7wmRAvxJpYVlyZe4hRBWjMow2rLzBKseTl56UqifA6nT0dJ8SbklhZlVqUH19UmpNafIjR
        FOjRicxSosn5wASUVxJvaGpobmFpaG5sbmxmoSTO2yFwMEZIID2xJDU7NbUgtQimj4mDU6qB
        cf5Ff6OUgpdGh3NWRmvUb16myVJqu0RrDrMQg9FGsY3fC9un+6Sl3t2SvJA7XEF1gv8mAXGe
        KU9djih7FGS3tHhKJt6YmWAQyZPSufOZ3c1XVl844i6/eWc8V/7DpYC+veuNl4p/+TJjx8E9
        b2zjS1bLavGwKU3MPvPdpjBi3/zXtWkz5uZNVmIpzkg01GIuKk4EAHc7BjoIAwAA
X-CMS-MailID: 20201022100133eucas1p132ef97a9ac767bd357f50034c47d6d1a
X-Msg-Generator: CA
X-RootMTR: 20201022100133eucas1p132ef97a9ac767bd357f50034c47d6d1a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201022100133eucas1p132ef97a9ac767bd357f50034c47d6d1a
References: <633bbf18-1aec-4b2a-7967-898cde1930aa@samsung.com>
        <CGME20201022100133eucas1p132ef97a9ac767bd357f50034c47d6d1a@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-22 czw 09:15>, when Marek Szyprowski wrote:
> On 21.10.2020 23:49, =C5=81ukasz Stelmach wrote:
>> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
>> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
>> supports SPI connection.
>>
>> The driver has been ported from the vendor kernel for ARTIK5[2]
>> boards. Several changes were made to adapt it to the current kernel
>> which include:
>>
>> + updated DT configuration,
>> + clock configuration moved to DT,
>> + new timer, ethtool and gpio APIs,
>> + dev_* instead of pr_* and custom printk() wrappers,
>> + removed awkward vendor power managemtn.
>>
>> [1] https://www.asix.com.tw/products.php?op=3DpItemdetail&PItemID=3D104;=
65;86&PLine=3D65
>> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10=
-artik/
>>
>> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
>> chips are not compatible. Hence, two separate drivers are required.
>>
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>
> co=C5=9B zaszala=C5=82e=C5=9B, jak dobry korea=C5=84ski kod - push bez ko=
mpilacji ;)
>
> drivers/net/ethernet/asix/ax88796c_main.c:758:13: error: static=20
> declaration of =E2=80=98ax88796c_set_csums=E2=80=99 follows non-static de=
claration
>  =C2=A0static void ax88796c_set_csums(struct ax88796c_device *ax_local)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 ^
> In file included from drivers/net/ethernet/asix/ax88796c_main.c:12:0:
> drivers/net/ethernet/asix/ax88796c_ioctl.h:24:6: note: previous=20
> declaration of =E2=80=98ax88796c_set_csums=E2=80=99 was here
>  =C2=A0void ax88796c_set_csums(struct ax88796c_device *ax_local);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^
> scripts/Makefile.build:283: recipe for target=20
> 'drivers/net/ethernet/asix/ax88796c_main.o' failed
> make[4]: *** [drivers/net/ethernet/asix/ax88796c_main.o] Error 1
> scripts/Makefile.build:500: recipe for target=20
> 'drivers/net/ethernet/asix' failed
> make[3]: *** [drivers/net/ethernet/asix] Error 2
> scripts/Makefile.build:500: recipe for target 'drivers/net/ethernet' fail=
ed
> make[2]: *** [drivers/net/ethernet] Error 2
> scripts/Makefile.build:500: recipe for target 'drivers/net' failed
> make[1]: *** [drivers/net] Error 2


Fixed. Thanks.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+RWHMACgkQsK4enJil
gBCTOAf8DDhl24aKJ6K/V2rIeZIbp78TQD8mv/HjBV8moWhi9TfOYwif3micRUfp
qdKzM4+yIP6B5edSQtu6+/ErHkwXQpDzy7ik2qp28WF2F0HLofn7SyfJGR8JaGEv
/fizTdjtNV7/zmWlyjZuTuHkhADGdiKJ+NLrfFLMmVWKdzttQDGkzBTs5khK2R9O
5yXISyU68eIb3dcANLKlKpjRI31ICQq0IjsHwsaWt9VWxFJ0tDGM4BONc5hcNPsS
aZR+hpm2ytGN8VYYcRd6MlV7WI5hm7X2rE43Hgzh/uwAbM8zrqY62bowtq2TZKM7
mdjObq3VWQK+ZzA0uqmSkX0pW7bLWQ==
=OwYK
-----END PGP SIGNATURE-----
--=-=-=--
