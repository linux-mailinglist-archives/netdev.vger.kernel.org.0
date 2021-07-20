Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977DA3CFB4B
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbhGTNNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:13:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55146 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239226AbhGTNKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:10:45 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210720135032euoutp01a385d7d1801433af631e7eb3b63641ad~ThAGPpodm1137411374euoutp01Z;
        Tue, 20 Jul 2021 13:50:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210720135032euoutp01a385d7d1801433af631e7eb3b63641ad~ThAGPpodm1137411374euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626789032;
        bh=xNFvXq4JCnO3U/+kGcl3QyUQHNjjPfejoXyNvpzJrDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUkhNM2NYIULG647hoklSvGPWCvZ1ZOQUGTZkU47E4dKl9XDtJD5lCXa+X/g+ky8U
         3pYJ3C2ybyvTNRa0+wcLT0wNgymlRFI8PfEmP+pYGQ7rCsMRDrmCiiX6qxc2Zew75B
         Ze4dFm+iS2jnw6w3UwzlLE3gt2gBcmEd/8CzjHAw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210720135032eucas1p198b52f59e50b6ac61ae73a09b0cb0adb~ThAF3oere1915719157eucas1p1J;
        Tue, 20 Jul 2021 13:50:32 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 40.3E.42068.8A4D6F06; Tue, 20
        Jul 2021 14:50:32 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210720135031eucas1p1f83f554ff6e98ff719505e0d0cce7aaa~ThAFXjFvl1915719157eucas1p1I;
        Tue, 20 Jul 2021 13:50:31 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210720135031eusmtrp146cf46d62b4b92731c12daef14072780~ThAFWp_UA0964109641eusmtrp1H;
        Tue, 20 Jul 2021 13:50:31 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-60-60f6d4a88953
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 1D.A0.31287.7A4D6F06; Tue, 20
        Jul 2021 14:50:31 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210720135031eusmtip1a41c46d4a5d4c531329a6702edead0fd~ThAFI3d921409814098eusmtip1F;
        Tue, 20 Jul 2021 13:50:31 +0000 (GMT)
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
Subject: Re: [PATCH net-next v14 3/3] net: ax88796c: ASIX AX88796C SPI
 Ethernet Adapter Driver
Date:   Tue, 20 Jul 2021 15:50:21 +0200
In-Reply-To: <20210720123646.2991df22@cakuba> (Jakub Kicinski's message of
        "Tue, 20 Jul 2021 12:36:46 +0200")
Message-ID: <dleftjlf61nlgi.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7djP87orrnxLMHi2i93i/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Vi0+NrrBaXd81hs5hxfh+T
        xaGpexkt1h65y25xbIGYReveI+wOAh6Xr11k9tiy8iaTx85Zd9k9Nq3qZPPYvKTeY+eOz0we
        fVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlTHx7xLGgi08FVsW7WRsYPzO1cXIySEhYCLxr/0O
        YxcjF4eQwApGiZNf2tghnC+MEvPuT2WCcD4zShy88pcRpuXWuVssEInljBI9D1ugqp4zSrxc
        3wHkcHCwCehJrF0bAdIgIqAi0bJ5JlgDs8BFFon13Z9ZQGqEBRIkFq7yAqlhEVCVeNPdzA5i
        cwrkS7ScecgCYvMKmEt0bNvPBGKLClhKbHlxnx0iLihxcuYTsBpmgVyJmeffgP0gIXCOU+L5
        oV/sEJe6SGzfc5gVwhaWeHV8C1RcRuL05B6wGyQE6iUmTzKD6O1hlNg25wcLRI21xJ1zv9gg
        bEeJpl1dUPV8EjfeCkLs5ZOYtG06M0SYV6KjTQiiWkViXf8eqClSEr2vVjBClHhILO4ThYRU
        A6NEx/QOlgmMCrOQfDMLyTezgFqYBTQl1u/ShwhrSyxb+JoZwraVWLfuPcsCRtZVjOKppcW5
        6anFRnmp5XrFibnFpXnpesn5uZsYgenw9L/jX3YwLn/1Ue8QIxMH4yFGFaDmRxtWX2CUYsnL
        z0tVEuFVKfqaIMSbklhZlVqUH19UmpNafIhRmoNFSZw3acuaeCGB9MSS1OzU1ILUIpgsEwen
        VANTAq/XYY5zvLvV34k8fejROa01ReFky3vH+heKf++s35FxLGxFxs9bu0zyZR4eXvHbed/T
        qRO77G83Tj/i+2S9a1F/2a9wrguv503ZsYWjId4+cdLkt7Z7DU5Fr3q+odFzt0DXi9md/4LC
        fj8/ZvmNweTGCcui7+/M4h0uTNMXL+Tjk9Vp/j89OEU4XJtZVm2H0mS5XZqzDJc9Ov3z3mHe
        xXmyAj+i3uy/3L4gsUsk+tmT0zudRA6zbXX0l7EqF5y57RSPSm36ZfOzlf2MLuEsri2POWZ8
        VMzvsJA2OaAutNXLxUadI4SN595XpxMb3M+/uPR6U/m1D7/CK9YLcxTKxb/7897cyWGy5SX7
        vvnblFiKMxINtZiLihMBda0KywIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xu7rLr3xLMFjSqGxx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy5j4dwljwRaeii2LdjI2MH7n6mLk5JAQMJG4de4WSxcjF4eQwFJGiRWLHrJ1MXIA
        JaQkVs5Nh6gRlvhzrYsNouYpo8SlazOZQGrYBPQk1q6NAKkREVCRaNk8E2wOs8AVFolVH1tY
        QWqEBeIkbp7nAKkREtCRWNb1gB3EZhFQlXjT3QxmcwrkS7ScecgCYvMKmEt0bNvPBGKLClhK
        bHlxnx0iLihxcuYTsBpmgWyJr6ufM09gFJiFJDULSWoW0GZmAU2J9bv0IcLaEssWvmaGsG0l
        1q17z7KAkXUVo0hqaXFuem6xoV5xYm5xaV66XnJ+7iZGYCxvO/Zz8w7Gea8+6h1iZOJgPMSo
        AtT5aMPqC4xSLHn5ealKIrwqRV8ThHhTEiurUovy44tKc1KLDzGaAr02kVlKNDkfmGTySuIN
        zQxMDU3MLA1MLc2MlcR5t85dEy8kkJ5YkpqdmlqQWgTTx8TBKdXAJPpxrtsds5TPeiJhfefn
        iQZHWhncLlvYerdJ2PSJAFtP6yQeS+ZA/XKnU7f2LXGt6/5w3OXjvTUl238LTmTfyObEe+GT
        v8DaPfly/GtlhI2vnvuycVll+awjiwtPusZf2aTc0Pz3l6SK+ttF1m4ejwI8PvJvURL3cA9S
        22nVfif3zFyLfDZ2o9Xfjj3KuRvReYNz3cSmhXLiVmW768JY0g9Ou7U9W+uV779ziik+P18u
        dWjf9ZAx7b9e20kn7ssaj/1mm4ZW71u/e/fCa1tXrCiZFJOyNCr7Bc/P8s6Ge5ErGLbs/K+u
        NfOj+CX3jdONF6zYzWRz/7r2Z93u4LDHG189bYy/pW/H+sfbcDZTkRJLcUaioRZzUXEiAGRi
        YDF6AwAA
X-CMS-MailID: 20210720135031eucas1p1f83f554ff6e98ff719505e0d0cce7aaa
X-Msg-Generator: CA
X-RootMTR: 20210720135031eucas1p1f83f554ff6e98ff719505e0d0cce7aaa
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210720135031eucas1p1f83f554ff6e98ff719505e0d0cce7aaa
References: <20210720123646.2991df22@cakuba>
        <CGME20210720135031eucas1p1f83f554ff6e98ff719505e0d0cce7aaa@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2021-07-20 wto 12:36>, when Jakub Kicinski wrote:
> On Mon, 19 Jul 2021 21:28:52 +0200, =C5=81ukasz Stelmach wrote:
>> +	ax_local->stats =3D
>> +		devm_netdev_alloc_pcpu_stats(&spi->dev,
>> +					     struct ax88796c_pcpu_stats);
>> +	if (!ax_local->stats)
>> +		return -ENOMEM;
>> +	u64_stats_init(&ax_local->stats->syncp);
>
> ../drivers/net/ethernet/asix/ax88796c_main.c:971:33: warning: incorrect t=
ype in argument 1 (different address spaces)
> ../drivers/net/ethernet/asix/ax88796c_main.c:971:33:    expected struct u=
64_stats_sync *syncp
> ../drivers/net/ethernet/asix/ax88796c_main.c:971:33:    got struct u64_st=
ats_sync [noderef] __percpu *
>

Fixed, thanks.

Apparently separate u64_stats_init() is not necessary as
netdev_alloc_pcpu_stats() invokes it for_each_possible_cpu.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAmD21J0ACgkQsK4enJil
gBC7cQf/fcyMOIEa244/esDfTKJn946iQj+W6YkPBBEMabKff4AkOkwJfBMnxAiE
U/LbwQ+rRXWibT2RmdPEyNQg1YcsYg2r/u26VYicVOaoq36WfxF1T6jtCunLKH4B
YSo5OV67xHKd0i209cPq6hhnDu97BGEoyMRMF+6jnq8ESKjekme72/qamLzWcjeT
QK+ETuodqMzRIMLNYuNtR7V1ha+y4jrcT66W9ltk+Yi5v6FkFijQUAAps9PlF7w+
RDo/m9zeCAwAFRmjz2LpPi+/z5Jx8I0/F63emYVsQfsSlKyYSaa85sF5M1YGP6fI
ucwyG3eRwziVeqyizAMBeFsJuA+1iQ==
=vCVS
-----END PGP SIGNATURE-----
--=-=-=--
