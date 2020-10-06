Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5892848B5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgJFIhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:37:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47635 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgJFIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:37:36 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201006083750euoutp0156bb0a38c7048b066e8ceefa99fe55f5~7WmJJcB9F1715117151euoutp01B;
        Tue,  6 Oct 2020 08:37:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201006083750euoutp0156bb0a38c7048b066e8ceefa99fe55f5~7WmJJcB9F1715117151euoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601973470;
        bh=TdvBo++lhM54zLH1A/JrQp3BZQVVNjq7JuuhRMXlT9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uO0Ngoe87nDx/YBi454j3tBG1IjBK3deLoufSlUN6IadxmGR1caWa3Jnl+exnV6OY
         G9BXe0yO9ACG9DIpRk8/P5f4VAMIHyT+kKlls5Pp4q14oWRlYcCwJ3PIqUi+nphOnu
         2dSbIGDiRJpHPMtKsmQ6BxatEa5s2eaCjdbhl7pM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201006083750eucas1p2464a3247610bac05f98ff689fe698260~7WmI3xM6v1792317923eucas1p23;
        Tue,  6 Oct 2020 08:37:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 41.35.06318.EDC2C7F5; Tue,  6
        Oct 2020 09:37:50 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201006083749eucas1p160a3bed4cdb67cc8e05ca4a57d8907ca~7WmIbzr_v1178011780eucas1p1x;
        Tue,  6 Oct 2020 08:37:49 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201006083749eusmtrp13d2caf5f65551a21acfc9988bff525ca~7WmIbBHvu2257422574eusmtrp1B;
        Tue,  6 Oct 2020 08:37:49 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-13-5f7c2cde5da3
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 39.86.06314.DDC2C7F5; Tue,  6
        Oct 2020 09:37:49 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201006083749eusmtip159a049b94167cbb073a26456cfccab04~7WmIQPs2y2825428254eusmtip1P;
        Tue,  6 Oct 2020 08:37:49 +0000 (GMT)
From:   Lukasz Stelmach <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewi?= =?utf-8?Q?cz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 0/4] AX88796C SPI Ethernet Adapter
Date:   Tue, 06 Oct 2020 10:37:34 +0200
In-Reply-To: <20201002194544.GH3996795@lunn.ch> (Andrew Lunn's message of
        "Fri, 2 Oct 2020 21:45:44 +0200")
Message-ID: <dleftj7ds3eomp.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTURiAObv37l616XVavZmEDPuuVVR2ywyzftyCyPpTmGkrLyq5qZuf
        fZCWRYnOUKO2BmqUX6nlmktNrYYosnQLdaWoRSqVFhWWZYS0eRL695z3PO/X4TCE9Cflx8Sr
        UgS1SpEgE7uT5o6ZnvUj685Fb3yXI+VswxaCq7/1gOIMthySK2nvoTjH5yGKKxidJDib7SHN
        2c1aijOOOiiut9kg5m7Z2kSc5UYr4mrbh2muo3QRd7m1nQ714nsdLwneVDUg4pv0wzRvrL4m
        5h/dvcA3NU6JeK2pGvFTxmXhTIT7zhghIT5NUG/YdcI97rnjGZU04JbxpnkIZaEmJhe5McBu
        ge7fWjIXuTNSthJBSdGgCB++I6jvnqHwYQrBkLWBnE/RD9pFLpayFQjGysKw9B7B17sNRC5i
        GDErh9raoy7Hlw2A4q4/c4UItoaEyZnauWQfdju8yOkRu5hkl0O9vgm52I1VQv+lmrlmEnYb
        PJnW0i5e6PRNH97QOO4NXbqxOYdw+jrbJ+RqAKyOgT7DTeQaAti9MF3vhYf2gYlOE43ZH6xF
        eSRWLkBRYRBOzUNgNvz6t2QwDPX8FmPeDXlPZ8XY94TXn71xW08oNN8kcFgCV69IsR0IdQUt
        /6r4Qf5EJcLMw9vSnzR+qosI+spr6OsoQP/fNvr/ttE7yxLsanjQvAGH10J52SSBOQTq6r6Q
        pYiqRouFVI0yVtBsVgnpco1CqUlVxcpPJSqNyPkFrbOdPxpR25+TFsQySLZAkrHobLSUUqRp
        MpUWFOis9O7hfTvyI1WJKkHmKwnrtkZJJTGKzDOCOjFanZogaCxoKUPKFks23/l4XMrGKlKE
        04KQJKjnb0WMm18WqvYPLf/0YyrNw3/JN+tB3e2YEtKesL/ofJI5+NC69HRdb6RMKFsZV9HW
        PJ59QxmYlV2Rv+qAMplN7veJLng1FvEsoy7Tvuqxx9b4kJHxY1WFe4qvvvRenbQv/OLAvV0j
        Pl7hIy07Qi6ZglZEXtF+n+bzDx+R98mjErv7r5EoQjHrkJGaOMWmNYRao/gL+ElwzooDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t/xu7p3dWriDW6/NrQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFtbd3WC36H79mtjh/fgO7xYVtfawWmx5fY7W4vGsOm8WM8/uYLA5N3cto
        sfbIXXaLYwvELFr3HmF34Pe4fO0is8eWlTeZPHbOusvusWlVJ5vH5iX1Hjt3fGby6NuyitHj
        8ya5AI4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
        vYyD1w6wFtzkrLi/6w5jA+NOji5GTg4JAROJWbcuMHUxcnEICSxllPixope5i5EDKCElsXJu
        OkSNsMSfa11sEDVPGSX27N3EBFLDJqAnsXZtBEiNiICCxJSTf1hBbGaB9SwSqydxgtjCApYS
        Z1rOsYHYQkDlby6+YASxWQRUJTbO2glmcwrkSlxtXsMCYvMKmEvs/tbHDmKLAvVueXGfHSIu
        KHFy5hMWiPnZEl9XP2eewCgwC0lqFpLULKDrmAU0Jdbv0ocIa0ssW/iaGcK2lVi37j3LAkbW
        VYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIERvO3Yz807GC9tDD7EKMDBqMTDqyBSHS/EmlhW
        XJl7iFEFaMyjDasvMEqx5OXnpSqJ8DqdPR0nxJuSWFmVWpQfX1Sak1p8iNEU6M+JzFKiyfnA
        pJNXEm9oamhuYWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoGRqfVSfKnpOc6Q
        tTPXlic0m7xmPl/7QZS/5WexWk8ES87shr8tDFxe9cUdG1XD/rnyP/HVzUj0m31g8q4n9SGp
        i1Kv3M+OOD1jufz06zekxOxXxEzI7ln676Vfa0nQtqAiKbfjhn0b/8lWXV8foHxqDk9ylJr7
        /p6S8q8/6hw/yG8pZ3vfuFyJpTgj0VCLuag4EQAFr0HdAgMAAA==
X-CMS-MailID: 20201006083749eucas1p160a3bed4cdb67cc8e05ca4a57d8907ca
X-Msg-Generator: CA
X-RootMTR: 20201006083749eucas1p160a3bed4cdb67cc8e05ca4a57d8907ca
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201006083749eucas1p160a3bed4cdb67cc8e05ca4a57d8907ca
References: <20201002194544.GH3996795@lunn.ch>
        <CGME20201006083749eucas1p160a3bed4cdb67cc8e05ca4a57d8907ca@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-02 pi=C4=85 21:45>, when Andrew Lunn wrote:
> On Fri, Oct 02, 2020 at 09:22:06PM +0200, =C5=81ukasz Stelmach wrote:
>> This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
>> found on ARTIK5 evaluation board. The driver has been ported from a
>> v3.10.9 vendor kernel for ARTIK5 board.
>
> Hi =C5=81ukasz
>
> Please include a brief list of changes since the previous version.
>

It can be found at the bottom of the message.

=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl98LM4ACgkQsK4enJil
gBDBGwf7BniLxZulD4q6SgaXv9GawdRNFVpHg9TEqudOoo75bI7Xlr0nd8pn0xJz
G3MF6+Kj5Z0aeAifXP0vk1GF898GGkyGnE8mefuQNLkvrAYNpDPsrBd+JXU0WIR7
O+8VYUhdrqp4ip2153dXHtda15kplCubyGgCvDpEO8G+FOhOiHZZQMfPMD1si9F5
IY9BVyRiACFwEbaEh7D+cyueZSINMMAy613VeavrMVlfsVAAfMbL+qlYQF5JPkld
EtDg3OMHNYLUZs/6pXcNI1JFObqPbODGjHQTruuW2GGoy3fE5uZ27I26YxvXKOfg
teDYJXQbyVv7gRNBPtbSUYHylUlkLA==
=z8rr
-----END PGP SIGNATURE-----
--=-=-=--
