Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63E4284CD0
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgJFODE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:03:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51314 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFODE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 10:03:04 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201006140301euoutp01ba739fba87f1b3ab59b4787299d71a94~7bCD_BJ1O1286512865euoutp01T;
        Tue,  6 Oct 2020 14:03:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201006140301euoutp01ba739fba87f1b3ab59b4787299d71a94~7bCD_BJ1O1286512865euoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601992981;
        bh=2fXpsF1rnt0T9ZecD8Wl1i7SBk3at4YUnrDDC7ekruM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c1afw/ZDA9nlL4bZcQ8YpdgmSmOgDa9BXkg2JZYLX9zdDIpInp/fJo1Im/ZZiph2u
         JisruMWgsOnml8Q1GY8SSnHCSdHE4eYPYBFtvKc+WgcsiwMBhIjV34elf8PCrz3QzD
         KRScMs46B9/lm6+dKqx33y9YdIXGvQimJEZGHvCg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201006140301eucas1p150163e9b98022582457cd0d094cffd7d~7bCDnky2n2233422334eucas1p1l;
        Tue,  6 Oct 2020 14:03:01 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 8D.95.06456.4197C7F5; Tue,  6
        Oct 2020 15:03:01 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201006140300eucas1p2006a96630d4a825500e5fc72016cf9d7~7bCDP4JN42306523065eucas1p2h;
        Tue,  6 Oct 2020 14:03:00 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201006140300eusmtrp25a886d39b0d94e655a55db7f163799dc~7bCDPIL9u0797807978eusmtrp2F;
        Tue,  6 Oct 2020 14:03:00 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-d0-5f7c79143720
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 2B.BB.06314.4197C7F5; Tue,  6
        Oct 2020 15:03:00 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201006140300eusmtip1fbd4bc9715bfd7a7bbf32a0404cbe001~7bCDFb3Ab2518625186eusmtip1I;
        Tue,  6 Oct 2020 14:03:00 +0000 (GMT)
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
Date:   Tue, 06 Oct 2020 16:02:50 +0200
In-Reply-To: <CAJKOXPePumx3-v7Odp8Fv65gzXFZw+EkZCaX-YE-CYrrmyr-8g@mail.gmail.com>
        (Krzysztof Kozlowski's message of "Tue, 6 Oct 2020 12:17:02 +0200")
Message-ID: <dleftjtuv7cv05.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm2zlnO1utPme2F7tQq36ktIpupytdlA4ElQVRQdmqk0pu2o5W
        mpFhRVlpGeq0lRZ5ydTWGkNFqy1ZReSxLLuQRGlZmhhe0Oxim5+B/57nfZ/n+d735WMpTR8T
        yEaZ4gSzyRCtk6top+enNCsgISl8Tp2ek5rcFHfHcpvhrNIJmsurrWO4xo73DJfe3E5xkmRT
        cPXONIazNzcyXEOVVc5ZpHsyzp1Zg7iy2iYF58kfz52sqVWsHMs3ND6neMfNtzK+MrdJwdtL
        zsj5uzeO8ZUV3TI+zVGC+G775I3sdtWyvUJ01EHBPHvFLlXkpdTjVGy79nCW5zKTjH77pyIl
        C3g+nLa2KVKRitXgYgTJWaUUIT0IXFfzGUK6EbT1fZb/t+SVtgxbihCkDUiIkFYEqbUXvSqW
        lWM9lJVt9RnG4Znw+k/fUBKFO2mof92AfBp/vA4ePMY+DY1nQEeBa0ijxNkIfv8qpH0NNV4E
        1i6bzIcD8GJwfP2gIHU/eJLTMqShsBFypO9DQwC+woL0coAio4ZAtushQ7A/tD1yKAieCIOV
        eTLfEICPwaWMhcR7DoHT2k8TzVJ4XzcgJ5pV8ColiMAx8KbDjzw7BjKc2RQpq+H0KQ0xTofy
        9OrhkEA431aMCObhZPP34VPdQNDpGaAvoCm5I7bJHbFNrjeW8p7udtVsUg6GwmvtFMHLoby8
        k85HTAnSCvGiMUIQ55qEQ3rRYBTjTRH6PTFGO/J+wad/H3VVoN4Xu90Is0g3Wr31QFK4hjEc
        FBOMbjTdm/TJdqseBdKmGJOgG6de/ezpTo16ryEhUTDHhJvjowXRjSawtE6rnnf92w4NjjDE
        CfsFIVYw/+/KWGVgMio9U7P4eHBPUfSO0JDYaVGjVIml1szekPEeaU111L7BqdqLYXWWuNBW
        5QRP34az/UG2/XdmvhNLEpo+zkt5/jM9Kca+pOBsRWSoMsyyPiziQJHL6ehfHbBp++YnW1ZM
        Wpn1Awa3ub4s+OH4dv+vlFeGp2j3HZHZ1h7VpXzNOFpdZNbraDHSMDeIMouGf5nD7PyKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t/xu7oilTXxBmtPqVicv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2ts7rBb9j18zW5w/v4Hd4sK2PlaLTY+vsVpc3jWHzWLG+X1MFoem7mW0
        WHvkLrvFsQViFq17j7A78HtcvnaR2WPLyptMHjtn3WX32LSqk81j85J6j507PjN59G1Zxejx
        eZNcAEeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2C
        XsbkrkbmgtfiFdOOzWZtYPwj3MXIySEhYCIxf80T9i5GLg4hgaWMEpOPLGXtYuQASkhJrJyb
        DlEjLPHnWhcbRM1TRonr8+4wgdSwCehJrF0bAVIjIqApcf3vd1aQGmaBjywS35+/ZAepERbw
        ljhwQgCkRkggQOLn5z0sIDaLgKrE26UHweo5BaYzSvz5vQwswStgLjHn0wYmEFtUwFJiy4v7
        7BBxQYmTM5+A1TALZEt8Xf2ceQKjwCwkqVlIUrOAVjMD3bR+lz5EWFti2cLXzBC2rcS6de9Z
        FjCyrmIUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM4W3Hfm7ewXhpY/AhRgEORiUe3ojCmngh
        1sSy4srcQ4wqQGMebVh9gVGKJS8/L1VJhNfp7Ok4Id6UxMqq1KL8+KLSnNTiQ4ymQI9OZJYS
        Tc4Hpp28knhDU0NzC0tDc2NzYzMLJXHeDoGDMUIC6YklqdmpqQWpRTB9TBycUg2MkjKfyl0v
        c+aH3ArqyLq38U3H9FUPO0OMlisfME8y5WLq6+Lo37ZMacvB2JZ+j2t9rK7anR8Dnh3z7Isx
        +MKXbbP8uOS0lb7uBt3vdI6+XPhm4s7dle0HquoO7l4bsJDp8u7mk13KPwTbI3at+L1twp6j
        c5VvMjq2eqVmPv0rz3ul4Aajc6yMEktxRqKhFnNRcSIAX5u3twMDAAA=
X-CMS-MailID: 20201006140300eucas1p2006a96630d4a825500e5fc72016cf9d7
X-Msg-Generator: CA
X-RootMTR: 20201006140300eucas1p2006a96630d4a825500e5fc72016cf9d7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201006140300eucas1p2006a96630d4a825500e5fc72016cf9d7
References: <CAJKOXPePumx3-v7Odp8Fv65gzXFZw+EkZCaX-YE-CYrrmyr-8g@mail.gmail.com>
        <CGME20201006140300eucas1p2006a96630d4a825500e5fc72016cf9d7@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-06 wto 12:17>, when Krzysztof Kozlowski wrote:
> On Tue, 6 Oct 2020 at 12:06, Lukasz Stelmach <l.stelmach@samsung.com> wro=
te:
>> It was <2020-10-03 sob 12:13>, when Krzysztof Kozlowski wrote:
>>> On Fri, 2 Oct 2020 at 21:22, =C5=81ukasz Stelmach <l.stelmach@samsung.c=
om> wrote:
>>>>
>>>> Add node for ax88796c ethernet chip.
>>>>
>>>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>>>> ---
>>>>  arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 ++++++++++++++++++++
>>>>  1 file changed, 21 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/b=
oot/dts/exynos3250-artik5-eval.dts
>>>> index 20446a846a98..7f115c348a2a 100644
>>>> --- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
>>>> +++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
>>>> @@ -37,3 +37,24 @@ &mshc_2 {
>>>>  &serial_2 {
>>>>         status =3D "okay";
>>>>  };
>>>> +
>>>> +&spi_0 {
>>>> +       status =3D "okay";
>>>> +       cs-gpios =3D <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
>>>> +
>>>> +       assigned-clocks        =3D <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV=
_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SP=
I0_PRE>, <&cmu CLK_SCLK_SPI0>;
>>>
>>> No spaces before or after '=3D'.
>>>
>>
>> You mean " =3D ", don't you?
>
> Ah, of course.
>
>>>> + assigned-clock-parents =3D <&cmu CLK_FOUT_MPLL>, <&cmu
>>>> CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu
>>>> CLK_DIV_SPI0>, <&cmu CLK_DIV_SPI0_PRE>;
>>>
>>> This line is still too long. Please wrap it at 80. Checkpatch should
>>> complain about it... so it seems you did not run it. Please fix all
>>> checkpatch issues.
>>
>> My idea was too keep assigned-clocks and assigned-clock-parrent lines
>> aligned, so it is clearly visible which parrent applies to which
>> clock. Is it inappropriate?
>
> The line gets too long and in the existing DTSes we wrapped item by
> item. Solution could be to add comments, e.g.:
> assigned-clock-parents =3D <&cmu CLK_FOUT_MPLL>,
>            <&cmu CLK_DIV_MPLL_PRE>, /* for: CLK_DIV_MPLL_PRE */
>            <&cmu CLK_MOUT_SPI0>, /* for: CLK_MOUT_SPI0 */
>
> but I am not sure if dtc allows such comments.

make dbts works fine. Changed.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl98eQoACgkQsK4enJil
gBAsBwf/U8NIpwChaCfintrqxRC3u5i0ZFL3sWI2ocaJUVGpS+VyTnlW6S/qNyDo
uo3PMKYo6bQHxuWow2u9ygzAKXrgngZiBNfKMg27O3pRpHcEJF78zaBCg0MWTWbp
uJyD6fJ38lPWyjvFkpQCMrGHYbgc0ProHZVgW+vB0MoYyaq9BjRtJYd/+C0FpoMf
SHyzU3qbvV6X3DAD00+wVNk39P2/WYH+oDwgtoOJZ8+hkIvJtsKPmvIxo70X8CPB
sS1F8IW+8qrix0TLgrjn5GPwfUr7MF9EhTfvErOvMihOmxLq4gAfbskyxVK0xsh+
U/u4PkP5q0zcH4rIOTvN9MHizW9tFg==
=3Dax
-----END PGP SIGNATURE-----
--=-=-=--
