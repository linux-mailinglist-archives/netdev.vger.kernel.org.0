Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E7029F5DB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgJ2UHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:07:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36161 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ2UHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:07:21 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201029200709euoutp014fdc5f215d799a6a598eb5850daa5344~Cj1jyXyMa2772627726euoutp01f;
        Thu, 29 Oct 2020 20:07:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201029200709euoutp014fdc5f215d799a6a598eb5850daa5344~Cj1jyXyMa2772627726euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604002029;
        bh=YuwLhAIFw/2V3cH63KEC8GpC0kRBCETejdjnWHvaNbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqoXbywluP7mPxNkcFqMYNzvflMgD1SdEjrxq76mkcmtKZPon1mR+TLVktYO5V63c
         lK/zj8ySjxRjrxctG2Abca1qRDdVtkC4ppRaktuFuo19e3idux8fLWWFJVVbSWmLpQ
         2A5igdNQ/8UqN6gdK2fnZVmQFoPWPbdHui8GvWgw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201029200708eucas1p216c9faabaac5ca74c134b948f6ac974c~Cj1jBw_mj0694306943eucas1p26;
        Thu, 29 Oct 2020 20:07:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id AF.B5.06318.CE02B9F5; Thu, 29
        Oct 2020 20:07:08 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201029200708eucas1p1f00cdaf2c217056427dcd08f9d0d8bc9~Cj1irTHzI1525415254eucas1p1K;
        Thu, 29 Oct 2020 20:07:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201029200708eusmtrp23d745a85010d803ecc9e1bf98848da9c~Cj1iqgaMV1271312713eusmtrp2n;
        Thu, 29 Oct 2020 20:07:08 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-d1-5f9b20ece31b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F7.11.06314.CE02B9F5; Thu, 29
        Oct 2020 20:07:08 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201029200708eusmtip16a3a16dbc2e04b09113e25742b1325e5~Cj1ihDX9F0198001980eusmtip1Q;
        Thu, 29 Oct 2020 20:07:08 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
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
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?utf-8?Q?Bart=C5=82omiej?= =?utf-8?Q?_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Thu, 29 Oct 2020 21:06:57 +0100
In-Reply-To: <41ffa67f-54af-4a21-fedc-d9008be00e89@pengutronix.de> (Marc
        Kleine-Budde's message of "Thu, 29 Oct 2020 18:06:42 +0100")
Message-ID: <dleftjpn50vlsu.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0hTYRjm2zln57iaHJfly4qypYKKlzLq62YmQod+9asiKp15MMlN2dSy
        fliZWmJqdtGmoWmUGrqcY2roiCWuXDovIIsaYUaZaZpWaBdr80zo3/Nenud9no+PIWQFYjmT
        os7gNWplqkIsIU09C/awSf/K+Mj53CBsd1oI3FKhp3CV/TKJq7v7KVw7XUHhkak3FC4Z+0xg
        u/0xjQdMxRQ2jI1QePhJlRhX2M0ibLnVhXBTt5PG+tqbJO6pWYPzurrpGB9ueGSQ4IwNr0Rc
        h85Jc4bGq2Ku9X4O19E+J+JK/kRyxcZGxM0Z1h/0OirZncSnpmTxmojoBMmpRkMDlV658uxs
        +Sx5AfVICpEXA+xWsF1vExciCSNj6xE4ul+QQvENwZBtjBKKOQSzr4bEy5Rfiy1IGDxEsJB7
        08P/iGC6V0cUIoYRs+HQ1HTETfBlQ+D117YlMsF+IyGvIcGNV7EnYG50nHZjkg2E3z/aabeO
        F1uAoPVLL+EeSNnt4HhtXSKvZneAcfwtLfR94MWd96QgqoI79sklR8C2M9A31okEq3EwM2ET
        CXgVTFiNtIDXwd+OapHbKLA5cKNsm8AtQmCqmieFnV3wpv+nJ/I+GC/I8+x7g2PKR7jrDWWm
        ckJoS+FKvkzYDoDmkk6PihyuTdR73HAwq9d5XvSWK2PdPboU+ev+i6P7L47OJUuwwaB/EiG0
        Q+HBvc+EgPdAc/M0WYOoRuTHZ2pVybw2Ss2fCdcqVdpMdXL4yTSVAbm+pG3R+r0dmX8nWhDL
        IMVKacyGyngZpczSZqssKMCl9O7xowEkJ9Vpal7hK43ts52QSZOU2ed4TVq8JjOV11rQWoZU
        +Emjaj8dl7HJygz+NM+n85rlqYjxkl9AoYMHfu25DFW5zBY5U5sXWHB9zdOyQ0XGheQ/85fK
        o0OOOoqj91uDXrYVxe4t+j6scppLP1rL6s7n9FfWHQ7221sa4Lw4Exd4dRTbPujDKNvBwylZ
        225nPH+maM1fseuvg44mj203UWeDgnck+i7Wvzcnju+8K8rSZVY33O3K37hJQWpPKTeHEBqt
        8h8VP5aAmgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t/xu7pvFGbHG7TP4Lc4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslusXzSFxeLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6/xp49G1ZxejxeZNcAGeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWR
        qZK+nU1Kak5mWWqRvl2CXsaqTStZC2bzVHya/omlgfEYVxcjJ4eEgInE738bGbsYuTiEBJYy
        Sly7OYeti5EDKCElsXJuOkSNsMSfa11sILaQwFNGiRMLlUBK2AT0JNaujQAJiwhoSdz+uJ0N
        ZAyzwHcWiQsnL7GAJIQFYiTuzF/NClIvJOAo0TudHyTMIqAq8efbDnaQek6BdkaJze9OMYMk
        eAXMJW7cPg62S1TAUmLLi/vsEHFBiZMzn4DNZBbIlvi6+jnzBEaBWUhSs5CkZgGtYxbQlFi/
        Sx8irC2xbOFrZgjbVmLduvcsCxhZVzGKpJYW56bnFhvqFSfmFpfmpesl5+duYgRG97ZjPzfv
        YLy0MfgQowAHoxIPr4P87Hgh1sSy4srcQ4wqQGMebVh9gVGKJS8/L1VJhNfp7Ok4Id6UxMqq
        1KL8+KLSnNTiQ4ymQI9OZJYSTc4HJqS8knhDU0NzC0tDc2NzYzMLJXHeDoGDMUIC6Yklqdmp
        qQWpRTB9TBycUg2MCcw5rBMf37dm2r0ypfqWKJ+K7Z6Wx/apXHcdS9o0DrYvc3sVXX48P3Sy
        3KuzW7boL+zQZEswdXjgyZnlqfzd7+kr3SvLTp2+pMcuq7dnm4i42ZNOtYnOLar3Hl1gvthx
        JEe2YDfn2l7/eRF+U7mr9yy5zHex1uia5t13rS3rS/i8MpyY1LYosRRnJBpqMRcVJwIA79tf
        qRADAAA=
X-CMS-MailID: 20201029200708eucas1p1f00cdaf2c217056427dcd08f9d0d8bc9
X-Msg-Generator: CA
X-RootMTR: 20201029200708eucas1p1f00cdaf2c217056427dcd08f9d0d8bc9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201029200708eucas1p1f00cdaf2c217056427dcd08f9d0d8bc9
References: <41ffa67f-54af-4a21-fedc-d9008be00e89@pengutronix.de>
        <CGME20201029200708eucas1p1f00cdaf2c217056427dcd08f9d0d8bc9@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-29 czw 18:06>, when Marc Kleine-Budde wrote:
> On 10/28/20 10:40 PM, =C5=81ukasz Stelmach wrote:
>> Add bindings for AX88796C SPI Ethernet Adapter.
>>=20
>> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
>> ---
>>  .../bindings/net/asix,ax88796c.yaml           | 69 +++++++++++++++++++
>>  1 file changed, 69 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.=
yaml
>>=20
>> diff --git
>> a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
>> b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
>> new file mode 100644
>> index 000000000000..05093c1ec509

[...]

>> +  - interrupts
>> +  - interrupt-parrent
>                    ^^
>
> typo?

Indeed, removing this but thanks anyway.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+bIOEACgkQsK4enJil
gBBYNgf/R/+BlHWdeKNjGdUGq9u9ScuX49zOkp4bP9gI70YuAry4sNcAPqnuFzx7
/oiUp7xecHvU7z+KWfuU15oi5y0waMBjEmpYMTpuN070bv5s5EpEMH/zpp3Bo5zF
6UjZZFbCfsxGclkstiRrHw42e5Kw5i+Z3fp/i67cMit1pgr0bplQ+HQi+uuC5lCE
SCBMqYF7oJTb9ZM9382+vgJ5b+DwWm3DIiahPHg0JhI3U1UOwRlh/q/f/WoZ5MQA
zavEyLZSgGnexzp6zTIC4J4bLOArWs+Ckzy9lneEG2f509bbgrTRyWuXcVc0Xpc2
Wyp/HMbG1PRoVAfUQNrv28E6GMae7w==
=egla
-----END PGP SIGNATURE-----
--=-=-=--
