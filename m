Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD0290C5D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 21:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436565AbgJPThz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 15:37:55 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48487 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436556AbgJPThz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 15:37:55 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201016193743euoutp0107c4bbc9860fa4f6497e3c9eee48d491~_kDJnuiuw2186621866euoutp01X;
        Fri, 16 Oct 2020 19:37:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201016193743euoutp0107c4bbc9860fa4f6497e3c9eee48d491~_kDJnuiuw2186621866euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602877063;
        bh=fAaURGxFxrxf5vT3aXwuCB6B61xvc3SkZQaHP8Bxw2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6XkpzyD37jVkF+ueKbbfEvrMfGqDMJEt2z7q8ZS4y/5O2QMaWgUhOV2t7Uvd6GYl
         wFTWOfXzGXmAIBbjtoYjL6m8YsBDHCUea6rAg3zFsSfiG6RBVne9XeVoXea/jKwiCi
         PJWpseKUb3klATWf4Q+fO1Wvd3dvPCZ9NSFPKDls=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201016193738eucas1p2287eb7f7921312b483df787ba1458f0b~_kDEmgLjf3236532365eucas1p2d;
        Fri, 16 Oct 2020 19:37:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id F4.D1.06318.186F98F5; Fri, 16
        Oct 2020 20:37:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201016193736eucas1p1eb94190e16b194f473ade8c49ca34275~_kDDg7Amv1985019850eucas1p1Y;
        Fri, 16 Oct 2020 19:37:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201016193736eusmtrp2c14f92c698e38174eb337adfc0966d01~_kDDgTWdg0550405504eusmtrp2Q;
        Fri, 16 Oct 2020 19:37:36 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-d6-5f89f681d2e1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id E0.87.06314.086F98F5; Fri, 16
        Oct 2020 20:37:36 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201016193736eusmtip15ddc2e6638e98b652554b93c369ed722~_kDDSqUIB0611506115eusmtip1W;
        Fri, 16 Oct 2020 19:37:36 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkie?= =?utf-8?Q?wicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] net: phy: Prevent reporting advertised modes when
 autoneg is off
Date:   Fri, 16 Oct 2020 21:37:22 +0200
In-Reply-To: <20201016180935.GG139700@lunn.ch> (Andrew Lunn's message of
        "Fri, 16 Oct 2020 20:09:35 +0200")
Message-ID: <dleftjzh4m3qtp.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRju2zlnO1vOjjPzxSJk6Q8VL2HUiSzKJEZRhGCUUbby4G2btqll
        /cjSIsVLqJE3yntmOVPmnHafpZipqWVlukQMzTQRL5WJ5vEz6N/zPt/zPC/Py0cTsi7KgQ7T
        RHNajVIlF0pIY9Pvdvcrs0lBXmPJBNvRbybY6uwqis3vSCTZoolsin1rTKPY7oZ8IWu++QSx
        lS/7RWxTwbrdYkV3TyehMNz7JFDU5/aLFDUVSUJFvWlKoEgzVCDFVM3Gw6JAiU8wpwqL5bSe
        u05JQlvrPgiiLNLzo+XVZDz6uToZiWlgtkBeZoowGUloGVOO4NliCYmHaQS3EuYEeJhC8N5S
        hJIRvWz5URaM+bsISlI7VhzDCAay0pdFQsYDKiuP8ivWMo6Q1TJP8RqCGRbAr4EsgtfYMoEw
        M+/La0jGGUay2iieFjNqqM3w5mkpsw0s+eOIx3bMdjCMfBFh3gZacoZIHhNL8pyOMcTHAzMu
        ghxjL8LV/KDuq4XC2BZGmw0ijDfAYv0dAe5yCTIztmJvCgJj/i8Sa3ZAX/ucEGv2QF6fI4bW
        8HHcBq+1hgzjLQLTUrh+TYaNTqBPf7wS4gCpo+UrR1OAfnLlTpcR9HROEDeQY+5/ZXL/K5O7
        ZCEYF6hq8MS0G5QVficw3gl6/QRZgKgKZM/F6NQhnM5bw53z0CnVuhhNiMeZSHUNWvpdrQvN
        Myb0dP60GTE0kltJ6dKkIBmljNXFqc3IaSlp8OH9t8iB1ERqOPlaqW9b60mZNFgZd4HTRgZp
        Y1SczozW06TcXupd9O2EjAlRRnMRHBfFaf+9CmixQzxaNZXNJVb6q+THXM8W1kb8DPAhwEoQ
        /+bIeCmx7/VEqWl41lV+/EWxirx46LPJL/P57ZBNWq+6A/sHH4zGL9woWSxqcp5ufHWwc7ac
        7Z3rt9vrMtYo6XLvnYle49nl3xbT3Ta5MTHcJ+BR2R9/9XRgsSHVjXmXMFSXEm60ybgqHpCT
        ulDlZldCq1P+BfKV0GZlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7oN3zrjDbpvm1qcv3uI2WLjjPWs
        FnPOt7BYLHo/g9XiwrY+VovLu+awWRyaupfRYu2Ru+wWxxaIOXB6XL52kdljy8qbTB47Z91l
        99i0qpPNY+eOz0wefVtWMXp83iQXwB6lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwe
        a2VkqqRvZ5OSmpNZllqkb5egl3F6+3Wmgnu8Fa9WbGRpYPzO3cXIwSEhYCLxbllKFyMXh5DA
        UkaJ0wcPskLEpSRWzk3vYuQEMoUl/lzrYoOoecoosfPkeiaQGjYBPYm1ayNAakQEFCSmnPzD
        ClLDLPCCSWL9nj52kISwQITEpzdb2EBsIQFdiT+z+1lBbBYBVYkXU86C2ZwCuRLb224zgti8
        AuYS9+a8BbNFBSwltry4zw4RF5Q4OfMJC4jNLJAt8XX1c+YJjAKzkKRmIUnNAjqPWUBTYv0u
        fYiwtsSyha+ZIWxbiXXr3rMsYGRdxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERh924793LyD
        8dLG4EOMAhyMSjy8GxZ1xguxJpYVV+YeYlQBGvNow+oLjFIsefl5qUoivE5nT8cJ8aYkVlal
        FuXHF5XmpBYfYjQF+nMis5Rocj4wYeSVxBuaGppbWBqaG5sbm1koifN2CByMERJITyxJzU5N
        LUgtgulj4uCUamBULTDSOn3jxZ2OrJNesfujbjcn5Xw1cJd8aPfW+MFs/aWXhM0m3C23PBSh
        97hR39Nb9fAyh0Wm9gXXd3Z12mstXtI+b7eWgrb51mURF1q95jV8DZ349XFo8tTFawSEPN5o
        Ps7Kvr9hTndTKl+rohdT6YIt5eHGDvtO5MZ36cZ+8rqjEKjvoqDEUpyRaKjFXFScCADqHMrz
        4AIAAA==
X-CMS-MailID: 20201016193736eucas1p1eb94190e16b194f473ade8c49ca34275
X-Msg-Generator: CA
X-RootMTR: 20201016193736eucas1p1eb94190e16b194f473ade8c49ca34275
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201016193736eucas1p1eb94190e16b194f473ade8c49ca34275
References: <20201016180935.GG139700@lunn.ch>
        <CGME20201016193736eucas1p1eb94190e16b194f473ade8c49ca34275@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-16 pi=C4=85 20:09>, when Andrew Lunn wrote:
> On Thu, Oct 15, 2020 at 10:44:35AM +0200, =C5=81ukasz Stelmach wrote:
>> Do not report advertised link modes (local and remote) when
>> autonegotiation is turned off. mii_ethtool_get_link_ksettings() exhibits
>> the same behaviour and this patch aims at unifying the behavior of both
>> functions.
>
> Does ethtool allow you to configure advertised modes with autoneg off?
> If it can, it would be useful to see what is being configured, before
> it is actually turned on.
>
> ethtool -s eth42 autoneg off advertise 0xf
>
> does not give an error on an interface i have.

Yes, this is a good point. Do you think I should change the if()[1] in=20
mii_ethtool_get_link_ksettings() instead? I really think these two
function should report the same.

[1] https://elixir.bootlin.com/linux/v5.9/source/drivers/net/mii.c#L174
[2] https://elixir.bootlin.com/linux/v5.9/source/drivers/net/mii.c#L145

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+J9nIACgkQsK4enJil
gBA9Rwf/XFHX++6DgwEAyPDwfrsq28MTgViffjtzEIJp4EQRo9DrPF+vwu0neyHL
G4pB7KhjIe8f4IbKiwNvnjgVbL1ukmaalb5tTqjYHVUHh4nnpqOdMJ7eMUI73tDy
C74fpWifs3z8gxp7l6gBklpDGRzj9V4mwsRFrDarzyKjKhxnVpjCkKsWrxBnivTk
lEGkPeB2r/0+7aeR74djxfu67OnTsnQcBYmmFZhq3TkR4gK7oGVCbR4WIWtPYcol
DxNxluNLRPGHwp8v0y34wZU+AvsTbK0x82Mc6cve4MhdD1lCCWqGSFhd9NTFl/lo
HnWngZjxSn35rC4VkHOzIdap0IDzjw==
=/DVz
-----END PGP SIGNATURE-----
--=-=-=--
