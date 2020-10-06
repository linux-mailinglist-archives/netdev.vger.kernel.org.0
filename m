Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED80284A1D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 12:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgJFKGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 06:06:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58759 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJFKGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 06:06:00 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201006100557euoutp017799a9f09821bc6f09d4accb2aabeaf5~7XzEn44UE2991329913euoutp017;
        Tue,  6 Oct 2020 10:05:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201006100557euoutp017799a9f09821bc6f09d4accb2aabeaf5~7XzEn44UE2991329913euoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601978757;
        bh=5JUiMXdtyYDow+LKrwQF5SXJmKEWJKERlqlIFrloBl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+vdm0yYLX9HE7KWc2PAzTDxuAxSXBMGWl6UssMx+qlZcDTJO/9o3PboDbaPF3IbQ
         zCQm/xpwnRuzFcI7QZ+rozDO91za71rx/6Vk7EAj7CD8p5zRanN7dKssRn23Vg11uT
         rW68gPahWJLa6380lqs5n0URTKeJlmfD+jYjfASA=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201006100556eucas1p2eb2b320d7976769704adbacb85e06d87~7XzEWFxXI2186021860eucas1p2V;
        Tue,  6 Oct 2020 10:05:56 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 84.57.05997.4814C7F5; Tue,  6
        Oct 2020 11:05:56 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201006100556eucas1p2b69f76968a7a5901b5e9c66338c388d4~7XzD9tEv02292322923eucas1p2Z;
        Tue,  6 Oct 2020 10:05:56 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201006100556eusmtrp1b45fa85b293a58a3d3039a398796abb7~7XzD8rhp_0933209332eusmtrp1q;
        Tue,  6 Oct 2020 10:05:56 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-c5-5f7c4184f046
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7F.23.06017.4814C7F5; Tue,  6
        Oct 2020 11:05:56 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201006100556eusmtip199f7c32641bfc8aabe10e0d5451de7e4~7XzDzo0LK1557715577eusmtip18;
        Tue,  6 Oct 2020 10:05:56 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc\@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewi?= =?utf-8?Q?cz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos: Add Ethernet to Artik 5 board
Date:   Tue, 06 Oct 2020 12:05:39 +0200
In-Reply-To: <CAJKOXPfQHzFb8uUzu2_X=7Jvk9P-z-jahi6csggpZvGsEhNm6Q@mail.gmail.com>
        (Krzysztof Kozlowski's message of "Sat, 3 Oct 2020 12:13:54 +0200")
Message-ID: <dleftj362rekjw.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHeXfO2Y7S7HVaPlmUjPxQmSuTOmWFXT4ciEK6gBSmKw9e2qZs
        WVmR1zTDG5qla5WaVBpq6ZiXnMUSrcTNWmiFEmWUaTbC7pi006vQt//zPP/f/32fl5elFD8Y
        fzZBd1TQ69QapdSTtnT/sq/M3nI6etX3llDOMWyjuLvljQxncmTT3LUuO8MNTAwxXNHIOMU5
        HHdkXL+lkOGaRgYYztluknLljk4JZyuzIq6+a1jGdVfO585au2Thc3nnwFOKN9e+lPBtxmEZ
        31SXJ+Wba9L4ttZJCV9orkP8ZNPiCHa/58ZYQZNwTNCrNsd4xtuMpbLkgvknMsoypOlo2vs8
        8mABh8KF2l+S88iTVeBbCF4Vf6dJ8RXBN7uLIcUkAtfrImoWyR19Q5HBTQSNuRMz/AcEL7Ks
        bp5lpTgY6usjRcAXL4PBPz/+JVHYRUP/oBOJHh+8Ax48wqKkcSA8z9wtWjzwJQQZv4cYkZXj
        dVB8zyQR9Ty8Hsyjr2Wk7w2PK97RoqawFiocn5AIA65i4d3FRokYCng7nMsKIJf2gbEes4zo
        RdBbmk8TSxqUlqwlaD4Ci+knTTxhMGT/LSV6Cwz35cz4veDFhDc51gtKLJco0pbDuRwFcS+F
        hqKOmRR/KBi7hYjmIbd5BJGXqkHgvNpGF6MA43/bGP/bxuiOpdwv19iuIu0VcKNqnCJ6EzQ0
        uOhKxNQhPyHFoI0TDCE64XiwQa01pOjigg8naZuQ+wv2Tvd8bUXtU4dsCLNIOUce4HsqWsGo
        jxlStTa01J309s7tfuRP65J0gtJXvrWv96BCHqtOPSnok6L1KRrBYEMLWVrpJ19T/TFKgePU
        R4UjgpAs6GenEtbDPx2FhezrSOxc0iPAgs682hzYYA9NTKir1gTtTfw89kXxsKx0qqRZbekc
        3XnfftF7unpqQeZI5ZVn5k1p3JKQt0w4FXYgylYwtDZ8f3dMWMueSDYQIjZvU6U/Uc0Zw9uv
        Z7reWzM1uwayrKrioJYzfpfLjjQ4kxVXsu/aA3JNeS5WSRvi1auXU3qD+i96/M6VigMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t/xu7otjjXxBvu/SFmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2ts7rBb9j18zW5w/v4Hd4sK2PlaLTY+vsVpc3jWHzWLG+X1MFoem7mW0
        WHvkLrvFsQViFq17j7A78HtcvnaR2WPLyptMHjtn3WX32LSqk81j85J6j507PjN59G1Zxejx
        eZNcAEeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2C
        XsahWZPZC3rFKhqnNrI1MP4T7GLk5JAQMJFof/GQuYuRi0NIYCmjxPLmHaxdjBxACSmJlXPT
        IWqEJf5c62KDqHnKKLFm3RNmkBo2AT2JtWsjQGpEBDQlrv/9zgpSwyzwkUXi+/OX7CA1wgLe
        EgdOCIDUCAkESDy+/p4NJMwioCpxpSkIpJxTYDqjROOvO6wgNbwC5hITds9hArFFBSwltry4
        zw4RF5Q4OfMJC4jNLJAt8XX1c+YJjAKzkKRmIUnNAlrBDHTS+l36EGFtiWULXzND2LYS69a9
        Z1nAyLqKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMIK3Hfu5ZQdj17vgQ4wCHIxKPLwKItXx
        QqyJZcWVuYcYVYDGPNqw+gKjFEtefl6qkgiv09nTcUK8KYmVValF+fFFpTmpxYcYTYH+nMgs
        JZqcD0w6eSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGAUXtfDM
        vPDhWExMeV/x7i0hxn1Gwo/iZk54lPJrs/YJ5U3uCWdPzfx5b46e2EftuH+na5eeV3r9PHdS
        UfdWJ82yzvwuHqdJH75/0HlqcW2xgY7WGZMtn361mfIvYDR0lhUvfqUt8Dn+znxfh9r+Bsep
        GicXfdp43eVNTojYzEn8fo/OTWhoOKnEUpyRaKjFXFScCACLEgJMAgMAAA==
X-CMS-MailID: 20201006100556eucas1p2b69f76968a7a5901b5e9c66338c388d4
X-Msg-Generator: CA
X-RootMTR: 20201006100556eucas1p2b69f76968a7a5901b5e9c66338c388d4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201006100556eucas1p2b69f76968a7a5901b5e9c66338c388d4
References: <CAJKOXPfQHzFb8uUzu2_X=7Jvk9P-z-jahi6csggpZvGsEhNm6Q@mail.gmail.com>
        <CGME20201006100556eucas1p2b69f76968a7a5901b5e9c66338c388d4@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-03 sob 12:13>, when Krzysztof Kozlowski wrote:
> On Fri, 2 Oct 2020 at 21:22, =C5=81ukasz Stelmach <l.stelmach@samsung.com=
> wrote:
>>
>> Add node for ax88796c ethernet chip.
>>
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 ++++++++++++++++++++
>>  1 file changed, 21 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/boo=
t/dts/exynos3250-artik5-eval.dts
>> index 20446a846a98..7f115c348a2a 100644
>> --- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
>> +++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
>> @@ -37,3 +37,24 @@ &mshc_2 {
>>  &serial_2 {
>>         status =3D "okay";
>>  };
>> +
>> +&spi_0 {
>> +       status =3D "okay";
>> +       cs-gpios =3D <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
>> +
>> +       assigned-clocks        =3D <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV_M=
PLL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SPI0=
_PRE>, <&cmu CLK_SCLK_SPI0>;
>
> No spaces before or after '=3D'.
>

You mean " =3D ", don't you?

>> + assigned-clock-parents =3D <&cmu CLK_FOUT_MPLL>, <&cmu
>> CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu
>> CLK_DIV_SPI0>, <&cmu CLK_DIV_SPI0_PRE>;
>
> This line is still too long. Please wrap it at 80. Checkpatch should
> complain about it... so it seems you did not run it. Please fix all
> checkpatch issues.

My idea was too keep assigned-clocks and assigned-clock-parrent lines
aligned, so it is clearly visible which parrent applies to which
clock. Is it inappropriate?

>> +
>> +       ax88796c@0 {
>> +               compatible =3D "asix,ax88796c";
>> +               local-mac-address =3D [00 00 00 00 00 00]; /* Filled in =
by a boot-loader */
>> +               interrupt-parent =3D <&gpx2>;
>> +               interrupts =3D <0 IRQ_TYPE_LEVEL_LOW>;
>> +               spi-max-frequency =3D <40000000>;
>> +               reg =3D <0x0>;
>
> Put reg after compatible.

Done.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl98QXMACgkQsK4enJil
gBCpCgf/R6al+tgJMpuq2oB4aL37iQz9ge4mMpYBZUXCrvE8t8iQEkqErdvIXrm2
g8fi2NzXvN9oSvbPxEyFhD02iKvq1jarrvlbXt5M3tAhDn6+brC8ih/fzaucwtOv
8VW5w+fC50CD/M8rHguR+bccITef+PTBjgoHBnF5dTG6V+7pbS9inmKMf1HjnQuq
xGbZGZjYoHJrZewcqKtFQ8GHZsPwlgZtHTept4RT67qW5HpHyg80WthtjvFPOL7G
0RyDhxn3qhtQsHFfEDvQ+lyBtYhN2MPC91Gc2e1JeX2gFA2IEgib+z8SdJlv8vZg
FABAbdlANeKXhr5OrYTARVl4D6029A==
=eFCo
-----END PGP SIGNATURE-----
--=-=-=--
