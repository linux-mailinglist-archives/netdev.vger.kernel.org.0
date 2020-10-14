Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A309A28E93B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgJNXiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:38:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37184 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730418AbgJNXiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 19:38:07 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201014233755euoutp01c48df94a0929244804b5d56e52f7d3e0~_ACTRpr2-1967919679euoutp01r;
        Wed, 14 Oct 2020 23:37:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201014233755euoutp01c48df94a0929244804b5d56e52f7d3e0~_ACTRpr2-1967919679euoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1602718675;
        bh=yjula7OfEd/uB0RdF9ta8z1msioiis5pg69uBSunAEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RidZvdVbc+UyqpjA9EUFhcnsKbHJPGkOklux38JmvS4AsLVLYMYOk0JweWwo/6hKK
         6d14kbzWJAesKt6pw2VWjW4HuO0pt2YTfR1lO6z+aHQgXNPhJaj2O+FaMBNHApYOpW
         zhd+DwsAuW3aSBiGsdueFzhOYjtisXtPEn7Q7Ryk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201014233750eucas1p26fd94b72dade73713380cb98cad3e049~_ACOKNH8u2579825798eucas1p2j;
        Wed, 14 Oct 2020 23:37:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id EF.61.06318.DCB878F5; Thu, 15
        Oct 2020 00:37:49 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201014233749eucas1p239bd9b81aca3ddaa1d589ffeed930a08~_ACNPXmIV2469124691eucas1p2s;
        Wed, 14 Oct 2020 23:37:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201014233749eusmtrp234f07b92de96146f5d0f5110c7a73cb1~_ACNOuGzB3097330973eusmtrp2g;
        Wed, 14 Oct 2020 23:37:49 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-73-5f878bcdafa1
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 8D.6B.06017.CCB878F5; Thu, 15
        Oct 2020 00:37:48 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201014233748eusmtip2cb9f04d90b568a5c688c4816ec03f919~_ACNEgK973170831708eusmtip2O;
        Wed, 14 Oct 2020 23:37:48 +0000 (GMT)
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
Date:   Thu, 15 Oct 2020 01:37:37 +0200
In-Reply-To: <20201014220434.GR1551@shell.armlinux.org.uk> (Russell King's
        message of "Wed, 14 Oct 2020 23:04:34 +0100")
Message-ID: <dleftj8sc8751a.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTURzHObt323W5OC7LH8tes3ekmVk3s5f6x4WohIIiKlt505HbYjct
        /SMlSpepWWKPJa2EUic+EpuuptHIWYpNMSMzsSKotOyxIp2P8nYn+N/nfM/n/H7ndzgUoegU
        KymN7gRr0KmTVBIZaXUOu1a2XciKW/XKGUG7eh0Efe9alZgucp0l6eJv18R0uzVPTHc+KJLQ
        jsIGRFc86ZXSzluztvgwnS87CKa2rFvE2Ey9UqbGcl7C2OrdIiav1oIYd83cWOk+WWQ8m6RJ
        YQ0hmw7JEivPvRUdL11+ytJ4icxA9QuykQ8FeA18t1yRZiMZpcClCMo9PRJh8QuBpylTzFsK
        7EbQ1L138sTPMxleqQSBue6GV/qIwD2kzUYUJcHBUFGxl0d/HAHtOUt5ncAuETjfGSW8PgPv
        gR+5YwTPJF4E5ke3Sd73wWngLpHxsRyvA9NvD8nzTLweaj/1SYXcD55d//A/J7AWrru+IL4+
        4PdS+GUbEwn3jIGswbekwDOgv7lWKnAg/LWZRXwvwOlQcHmtcDYHgbVoyOtvgDfPPRKBt0L+
        UzsS/Onw6quf0Hc6XLZeJYRYDsZMhWAvhMqLdm8VJeT2lyKBGXhs/kAIr5aL4E5zK5mP5pum
        jGOaMo5poiyBl0HVgxAhXgF3bw8QAm+Eyspv5C0ktqAANpnTJrBcmI49GcyptVyyLiH4iF5b
        gya+V+t48+961Dh62IEwhVS+8tKhzDiFWJ3CpWodaOFEpffV5e1ISer0OlblL49qaz2okMer
        U9NYgz7OkJzEcg40myJVAfKw4s8HFDhBfYI9xrLHWcPkrojyUWYgpiVvZ+Gc8hWtg0H+m9ty
        b9YYX4/Up9U5Y06u3nXatju64Xu0+b61Z95F34f2LlNLZN+OF5DfH9rhihnZ4WQ045heUIZG
        3/lOK4ni6PSq8PjOoy2a7Wnbhwer11UHxRZqwu8vthdELsnoCldaUgYCQ36cStjG6f8Uh22p
        6wjbb1SRXKI6dDlh4NT/AP2i+/NmAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t/xe7pnutvjDRqn2licv3uI2WLjjPWs
        FnPOt7BYLHo/g9XiwrY+VovLu+awWRyaupfRYu2Ru+wWxxaIOXB6XL52kdljy8qbTB47Z91l
        99i0qpPNY+eOz0wefVtWMXp83iQXwB6lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqlnaGwe
        a2VkqqRvZ5OSmpNZllqkb5egl7Gu9QFTwQqtilX7JrI0MO5Q7GLk5JAQMJH41NTA1sXIxSEk
        sJRR4t+qm8xdjBxACSmJlXPTIWqEJf5c64KqecoosePNNRaQGjYBPYm1ayNATBEBK4kLPRog
        JcwCF5kk2u6+ZQWJCwuEStxapgYyRkjAUuLM04XsIDaLgKrE/P0LwaZwClRJfF7OBRLmFTCX
        mPX1FwuILQpUvuXFfXaIuKDEyZlPwOLMAtkSX1c/Z57AKDALSWoWktQsoKnMApoS63fpQ4S1
        JZYtfM0MYdtKrFv3nmUBI+sqRpHU0uLc9NxiI73ixNzi0rx0veT83E2MwMjbduznlh2MXe+C
        DzEKcDAq8fAy/G6LF2JNLCuuzD3EqAI05tGG1RcYpVjy8vNSlUR4nc6ejhPiTUmsrEotyo8v
        Ks1JLT7EaAr05kRmKdHkfGCyyCuJNzQ1NLewNDQ3Njc2s1AS5+0QOBgjJJCeWJKanZpakFoE
        08fEwSnVwKjjx7OyI1etKNa5ZpZXp+P8W7cWn73Ull+5XTBxZ3OfyKU3pkn8rEZZ901ym/3d
        hOpiUq1Ut/U083qp3yyrq3v/Pkyy4dNyl83JwdH94uZF/8/388+8Ji+mr9K8bbmRdvovQ4Vu
        M6YN3232FTF8VFq+6NjUoFgOvTi2336RppLM2o6reEWVWIozEg21mIuKEwETwyrH3gIAAA==
X-CMS-MailID: 20201014233749eucas1p239bd9b81aca3ddaa1d589ffeed930a08
X-Msg-Generator: CA
X-RootMTR: 20201014233749eucas1p239bd9b81aca3ddaa1d589ffeed930a08
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201014233749eucas1p239bd9b81aca3ddaa1d589ffeed930a08
References: <20201014220434.GR1551@shell.armlinux.org.uk>
        <CGME20201014233749eucas1p239bd9b81aca3ddaa1d589ffeed930a08@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-14 =C5=9Bro 23:04>, when Russell King - ARM Linux admin wro=
te:
> On Wed, Oct 14, 2020 at 04:39:47PM +0200, Lukasz Stelmach wrote:
>> It was <2020-10-14 =C5=9Bro 14:32>, when Russell King - ARM Linux admin =
wrote:
>> > In any case, the mii.c code does fill in the advertising mask even
>> > when autoneg is disabled, because, rightly or wrongly, the advertising
>> > mask contains more than just the link modes, it includes the
>> > interface(s) as well. Your change means phylib no longer reports the
>> > interface modes which is at odds with the mii.c code.
>>=20
>> I am afraid you are wrong. There is a rather big if()[1], which
>> depending on AN beeing enabled fills more or less information. Yes this
>> if() looks like it has been yanked from mii_ethtool_gset(). When
>> advertising is converted and copied to cmd->link_modes.advertising at
>> the end of mii_ethtool_get_link_ksettings() it is 0[2] if autonegotiation
>> is disabled.
>>=20
>> [1]
>> https://protect2.fireeye.com/v1/url?k=3Dd1d33944-8c07852c-d1d2b20b-0cc47=
a3356b2-cede44db8a43e7c3&q=3D1&e=3Dd1dea895-d1df-46b9-8413-ac329b0bbfa7&u=
=3Dhttps%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.9%2Fsource%2Fdrivers%2Fnet=
%2Fmii.c%23L174
>> [2]
>> https://protect2.fireeye.com/v1/url?k=3Dc840e942-9594552a-c841620d-0cc47=
a3356b2-510c0749446ea7df&q=3D1&e=3Dd1dea895-d1df-46b9-8413-ac329b0bbfa7&u=
=3Dhttps%3A%2F%2Felixir.bootlin.com%2Flinux%2Fv5.9%2Fsource%2Fdrivers%2Fnet=
%2Fmii.c%23L215
>
> I'm very sorry, but I have to disagree.  I'll quote the code here:
>
>         advertising =3D ADVERTISED_TP | ADVERTISED_MII;
>
> 	// This is your big if()
>         if (bmcr & BMCR_ANENABLE) {
> 		advertising |=3D ADVERTISED_Autoneg;
> 		...
> 	} else {
> 		...
> 	}
>
> 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
> 	                                        advertising);
>
> So, when AN is disabled, we still end up with TP and MII in the
> advertised link modes. I call TP and MII "interface modes" above
> to separate them from the "link modes" that describe the speed and
> duplex etc.

Yes.

> Note that only lp_advertising is zeroed in the "else" clause of
> the above "if" statement - advertising remains as-is with TP and MII
> set.

Yes.

> Your patch, on the other hand, merely avoids setting anything in
> cmd->link_modes.advertising, which means we do not end up with the
> "interface modes".
>
> I hope that this helps you see my point.

Yes.

Thanks.

tl;dr: v2 is coming.

Let's take a look at what ethtool prints. With AN enabled

=2D-8<---------------cut here---------------start------------->8---
Settings for enx00249b14f06e:
        Supported ports: [ TP MII ]
        Supported link modes:   10baseT/Half 10baseT/Full=20
                                100baseT/Half 100baseT/Full=20
                                1000baseT/Half 1000baseT/Full=20
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full=20
                                100baseT/Half 100baseT/Full=20
                                1000baseT/Full=20
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes

[...]

        Link detected: yes
=2D-8<---------------cut here---------------end--------------->8---

with AN disabled

=2D-8<---------------cut here---------------start------------->8---
Settings for enx00249b14f06e:
        Supported ports: [ TP MII ]
        Supported link modes:   10baseT/Half 10baseT/Full=20
                                100baseT/Half 100baseT/Full=20
                                1000baseT/Half 1000baseT/Full=20
        Supported pause frame use: No
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  Not reported
        Advertised pause frame use: No
        Advertised auto-negotiation: No

[...]

        Link detected: yes
=2D-8<---------------cut here---------------end--------------->8---

The driver is ax88179_178a which calls mii_ethtool_get_link_ksettings()

The first line that differs is "Advertised link modes". Apparently[1]
ethtool does not consider ADVERTISED_TP and ADVERTISED_MII as
interesting modes. Indeed I should add an else clause to clear
cmd->link_modes.advertising (and lp_advertising) and set only
ETHTOOL_LINK_MODE_TP_BIT and ETHTOOL_LINK_MODE_MII_BIT.


[1] https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/tree/ethtool=
.c?h=3Dv5.8#n656
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+Hi8EACgkQsK4enJil
gBDeCgf/bw8HiDrt4YimUVEQSKuWqldHTtHuZWvB7Jo2ao/DRC619p9uF6nudVIb
/TeG+5xt5EqD9+U95LwcWxIq668CQd+ZnYQiq01R9Yrqlw+awafB52mzEUvPntff
tdJTbrTtwgDfdcJd1RCNmPPl6om3ohgImVGltOX7nnE2ubdbZewrU4ZrUeoJrujX
084Jew5vvrMkAmx8YuU/z6kZ+u8j8XKggsDGvnDvTw7jYXTACSSipz4UoZPpRKcG
RLoAVgupK/KwmfO2caYK9Z5wVHs4584NKiB6NbUgSpQQHKZvXQ0ZMVzly50em89h
MvHfQAvFTqSwQ2EyqXssmzeOYAj87w==
=YBhi
-----END PGP SIGNATURE-----
--=-=-=--
