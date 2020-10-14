Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A210B28E265
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgJNOkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 10:40:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32816 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgJNOkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 10:40:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201014144027euoutp02949845842d84b2148dd4cd034e5c7fa7~94tBm1pwj1110411104euoutp02D;
        Wed, 14 Oct 2020 14:40:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201014144027euoutp02949845842d84b2148dd4cd034e5c7fa7~94tBm1pwj1110411104euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602686427;
        bh=xXGntr2qVkBqUvG2KXB9TzCwei0VgYRz0UVI7B025ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iirU3Te31ZvCQ8vhN8FQks3TfZfrbiwj2xg8+1BGCfE9hvTlckD+cW2ERMIhhQoAN
         GOUIbKhNeesWnXAwTwnEGNGF2CUBwFt250M1rTADfCy4vKsYs8nrVs/R825ns3Phl0
         lRj1ECbl5F/Nus21LS0O8GrJvGpkuV2UazMIevjw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201014144019eucas1p19bca149eba2ac3f90afb1235baa63a87~94s6YEhZU1097910979eucas1p1c;
        Wed, 14 Oct 2020 14:40:19 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 1E.D4.06318.3DD078F5; Wed, 14
        Oct 2020 15:40:19 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201014144018eucas1p101424a57f5bf63eabb3dc24177551dff~94s53KCuq0882108821eucas1p1n;
        Wed, 14 Oct 2020 14:40:18 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201014144018eusmtrp15af2a28f7b908e295db972d6c8d83bfb~94s52e-6G2861828618eusmtrp1b;
        Wed, 14 Oct 2020 14:40:18 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-49-5f870dd32932
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id B2.10.06017.2DD078F5; Wed, 14
        Oct 2020 15:40:18 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201014144018eusmtip22d083ad949475b4f1035a65ab999a107~94s5s1MIX2509525095eusmtip2g;
        Wed, 14 Oct 2020 14:40:18 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] net: phy: Prevent reporting advertised modes when
 autoneg is off
Date:   Wed, 14 Oct 2020 16:39:47 +0200
In-Reply-To: <20201014133211.GQ1551@shell.armlinux.org.uk> (Russell King's
        message of "Wed, 14 Oct 2020 14:32:11 +0100")
Message-ID: <dleftjpn5k7txo.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djP87qXedvjDaZeEbI4f/cQs8XGGetZ
        Leacb2GxWPR+BqvFhW19rBaXd81hszg0dS+jxdojd9ktji0Qc+D0uHztIrPHlpU3mTx2zrrL
        7rFpVSebx84dn5k8+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PR0n9sBZ9lKj69mMvawPhU
        oouRk0NCwESie/Ne1i5GLg4hgRWMEnf/LmGGcL4wSux5+JodpEpI4DOjxNQPlTAdV44sgipa
        ziixbu9GqPbnjBIbzyxi7GLk4GAT0JNYuzYCxBQRsJK40KMBUsIscJ5J4tjDDjaQQcIC4RIf
        e/8yg9gsAqoSp+6+AbM5BaokZn+5zAhi8wqYS5w8sxesXlTAUmLLi/vsEHFBiZMzn7CA2MwC
        uRIzz79hBFkgIfCWXaLt8FsWkMUSAi4SzY3KEEcLS7w6voUdwpaROD25B6qkXmLyJDOI1h5G
        iW1zfrBA1FhL3Dn3iw3CdpSY3naPGaKeT+LGW0GItXwSk7ZNhwrzSnS0CUFUq0is698DNUVK
        ovfVCkYI20Pi5LtZLJCQ6mWU+Pv/PdsERoVZSL6ZheSbWUBjmQU0Jdbv0ocIa0ssW/iaGcK2
        lVi37j3LAkbWVYziqaXFuempxcZ5qeV6xYm5xaV56XrJ+bmbGIHp6/S/4193MO77k3SIUYCD
        UYmHd8WPtngh1sSy4srcQ4wqQJMebVh9gVGKJS8/L1VJhNfp7Ok4Id6UxMqq1KL8+KLSnNTi
        Q4zSHCxK4rzGi17GCgmkJ5akZqemFqQWwWSZODilGhhD+ZccP+aavOiGza2YW0dzn52X4Tyy
        p+mSdUWhmvYvg8vfm3XOOFTUZ0fu1n17OnlptnNNb6M6T1ZgdI2XTaTJ4iifmbuyNRIOxmfs
        bZRWZO7jbEj8Pvuw/o0WpvmvuvZ3OdefOdgzwf9Sx4zKx1u9m9iV+qLTls00U917SylpUomd
        sGWfkBJLcUaioRZzUXEiAMmpc+pnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xe7qXeNvjDXob9CzO3z3EbLFxxnpW
        iznnW1gsFr2fwWpxYVsfq8XlXXPYLA5N3ctosfbIXXaLYwvEHDg9Ll+7yOyxZeVNJo+ds+6y
        e2xa1cnmsXPHZyaPvi2rGD0+b5ILYI/SsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaP
        tTIyVdK3s0lJzcksSy3St0vQy1i09B9bwWeZik8v5rI2MD6V6GLk5JAQMJG4cmQRcxcjF4eQ
        wFJGiZdzJjN1MXIAJaQkVs5Nh6gRlvhzrYsNouYpo8TFhU/ZQWrYBPQk1q6NADFFBKwkLvRo
        gJQwC1xkkmi7+5YVJC4sECpxa5kayBghAUuJx49PMYHYLAKqEqfuvmEGsTkFqiRmf7nMCGLz
        CphLnDyzlw3EFgWq3/LiPjtEXFDi5MwnLCA2s0C2xNfVz5knMArMQpKahSQ1C2gzs4CmxPpd
        +hBhbYllC18zQ9i2EuvWvWdZwMi6ilEktbQ4Nz232EivODG3uDQvXS85P3cTIzD2th37uWUH
        Y9e74EOMAhyMSjy8DL/b4oVYE8uKK3MPMaoAjXm0YfUFRimWvPy8VCURXqezp+OEeFMSK6tS
        i/Lji0pzUosPMZoC/TmRWUo0OR+YLvJK4g1NDc0tLA3Njc2NzSyUxHk7BA7GCAmkJ5akZqem
        FqQWwfQxcXBKNTAe+yZ1UEn7yn+pNXL78s5vjGpcsTVtrcapnrsHFF9FPCjf/Ii91nvGpue7
        hV6n/z33zuBY98Vi82mLj6gE/qlPm3GEVaOgVWHVET+Jfom+iW43VyZ2zD/weX7pqY53Z1/n
        Xe/vbJl7/2zZTCODW7/+6K5Zp7WIuZV9U3S7+Ec5yaP2nMdZJ2bvUWIpzkg01GIuKk4EAN/w
        vf7fAgAA
X-CMS-MailID: 20201014144018eucas1p101424a57f5bf63eabb3dc24177551dff
X-Msg-Generator: CA
X-RootMTR: 20201014144018eucas1p101424a57f5bf63eabb3dc24177551dff
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201014144018eucas1p101424a57f5bf63eabb3dc24177551dff
References: <20201014133211.GQ1551@shell.armlinux.org.uk>
        <CGME20201014144018eucas1p101424a57f5bf63eabb3dc24177551dff@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-14 =C5=9Bro 14:32>, when Russell King - ARM Linux admin wro=
te:
> On Wed, Oct 14, 2020 at 02:56:50PM +0200, =C5=81ukasz Stelmach wrote:
>> Do not report advertised link modes when autonegotiation is turned
>> off. mii_ethtool_get_link_ksettings() exhibits the same behaviour.
>
> Please explain why this is a desirable change.
>

To make the behavior uniform accross different drivers. For example
ethtool shows different reports on different hardware depending on
whether the driver uses phylib or mii. I don't insist on accepting my
patch. I merely propos it as a means of the unification. Maybe it is
mii.c that should be changed.

> Referring to some other piece of code isn't a particularly good reason
> especially when that piece of code is likely derived from fairly old
> code (presumably mii_ethtool_get_link_ksettings()'s behaviour is
> designed to be compatible with mii_ethtool_gset()).

Well according to git phy_ethtool_ksettings_get() was first (2011-04-15,
phy_ethtool_get_link_ksettings() soon after) while
mii_ethtool_get_link_ksettings() is half a year younger. Indeed, maybe I
should patch mii_ethtool_get_link_ksettings() instead.

> In any case, the mii.c code does fill in the advertising mask even
> when autoneg is disabled, because, rightly or wrongly, the advertising
> mask contains more than just the link modes, it includes the
> interface(s) as well. Your change means phylib no longer reports the
> interface modes which is at odds with the mii.c code.

I am afraid you are wrong. There is a rather big if()[1], which
depending on AN beeing enabled fills more or less information. Yes this
if() looks like it has been yanked from mii_ethtool_gset(). When
advertising is converted and copied to cmd->link_modes.advertising at
the end of mii_ethtool_get_link_ksettings() it is 0[2] if autonegotiation
is disabled.

[1] https://elixir.bootlin.com/linux/v5.9/source/drivers/net/mii.c#L174
[2] https://elixir.bootlin.com/linux/v5.9/source/drivers/net/mii.c#L215

>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  drivers/net/phy/phy.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
>> index 35525a671400..3cadf224fdb2 100644
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -315,7 +315,8 @@ void phy_ethtool_ksettings_get(struct phy_device *ph=
ydev,
>>  			       struct ethtool_link_ksettings *cmd)
>>  {
>>  	linkmode_copy(cmd->link_modes.supported, phydev->supported);
>> -	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
>> +	if (phydev->autoneg)
>> +		linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
>>  	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
>>=20=20
>>  	cmd->base.speed =3D phydev->speed;
>> --=20
>> 2.26.2
>>=20
>>=20

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+HDbMACgkQsK4enJil
gBC+kwf/S1+IP4/xJFbipU7gjfwxqzS94YKAK7IjiRz644HPMkNfycl/NXaoJX6k
/QGimtdXZ0LqaFNXQgaoaMRmVmQ7aqu79P4TS0WrcoUg1M8Y/aKde97BpSdnN69f
C3rXI0eQx5jjjNXOl0JMI5b5Zwy7rdn9bOXsGJ36oAM/l7gplyYm3yEktA7TmX6K
30AosNiELqP7GDMd54e+Il3dcsDPTrCohGWTFO/8bjP4qClOi9AhO+qlZWuRvnD0
yNZ18ZK/iyFcMzmeLm+Kpga5r6elNH+b6Y8YaGIcM/RZvO5p9o1ciVytm4ueJRNK
nre/OpxQD8BbeuTWe3nqmp/6EAsvaA==
=mHMW
-----END PGP SIGNATURE-----
--=-=-=--
