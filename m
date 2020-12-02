Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5FE2CC77B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgLBUI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:08:29 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54015 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387621AbgLBUI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:08:28 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201202200733euoutp011cbf8b5d60a9279fa6d249170b237383~M-xnctH3Q1427914279euoutp01K;
        Wed,  2 Dec 2020 20:07:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201202200733euoutp011cbf8b5d60a9279fa6d249170b237383~M-xnctH3Q1427914279euoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606939653;
        bh=nX1/s9F4j0opypv7MLT+Sr3+JETZciJL/oqqq3Yqqxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+YdXyyTUz8KPN5IAsgsIENqV7HhcqXlfAYvQ2zQrtRjpo7GNxfg4cBiEt8f2dzyU
         PxjpZLmCXin8TJR5f3+utLjNtK41szXlqv+VbfI70UXFqAateJxFtb9BBiJXWvsmDn
         AtToMVjXd1Vnrq+uDkCX5V0JXFL6F89jGjt+bKKU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201202200728eucas1p1676c086b1d900ebb9eee9506c9b5d92b~M-xilRsLK1724917249eucas1p1i;
        Wed,  2 Dec 2020 20:07:28 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 53.F6.45488.004F7CF5; Wed,  2
        Dec 2020 20:07:28 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201202200727eucas1p18311ed19904e8a0c7b8c28cde87f155b~M-xiG0E3P2979929799eucas1p1n;
        Wed,  2 Dec 2020 20:07:27 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201202200727eusmtrp2ac27b6bb7c81afe0e7dd81e663911d7f~M-xiGAnuu2900929009eusmtrp2_;
        Wed,  2 Dec 2020 20:07:27 +0000 (GMT)
X-AuditID: cbfec7f5-c5fff7000000b1b0-c7-5fc7f40041f0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 37.9C.21957.FF3F7CF5; Wed,  2
        Dec 2020 20:07:27 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202200727eusmtip2a27d2352fcd1a034d76327ce441c0f26~M-xh1xuRB0034800348eusmtip2r;
        Wed,  2 Dec 2020 20:07:27 +0000 (GMT)
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
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Wed, 02 Dec 2020 21:07:11 +0100
In-Reply-To: <20201202091852.69a02069@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 2 Dec 2020 09:18:52 -0800")
Message-ID: <dleftjsg8oc6q8.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbVRjGPfejvVRbzzqEk24RRzCxmhY2YdzhXLaEwJUlygwyBBWb7QqL
        UEgL+yAuG646RCgIEtta0sm3sJbZQkOpKHQFMpbRIhO2CI4BBgYsBLolSEIn5bK4/57zvL/3
        M4fCxcukhDqlLGBVSkVOOE9A2Af+9cieezSYGaUzCGnPpAunf9G1k7TRoyFok3uYpOuWdSQ9
        9nCCpCtmFnHa47nGp712LUlbZ8ZIerTbyKN1nt8w2lXTA2ize5JPD1wJob/qcfMPQ2Z0bARn
        On6+izEOwySfsbZ+w2NsDRcYR5cPY7QdrYDxWV9OptIFB0+yOadOs6rIQ58Ksi977+D5FtHZ
        SuMSuAg2ni8FQRSC0WjFu8QvBQJKDFsA8msdgHs8AujG7138ACWGPoBG7iU8zehZGyY4qBkg
        a4Mb46A5gO5OiUoBRfGgHJnNaQE7GEYgjU2/xeNwhEDt3/qIQGAnTEVV62YywBPwVTR0fVeA
        CYI1AJmGekGAEcJYZHa68IB+CR5AHfP3+Jy/A93Qz27VwWEu0nuWtqZG8I8gZCkrxrlJ41FD
        2wyf0zvRwmDHtt6NnjhMWKAxghdQddV+LrcMILtxjeCYt9DE8DqP00dQf6VjmxehOw93cH1F
        qMr+A87ZQlTytZijI5Cl4tftKhJUvtACOM2gNfvG/3cr0cySleAVwzPrGJ5Zx7BZFodS1N4d
        ydlvoKafFnFOv40slmXiCiBbQShbqM7NYtVvKtkzcrUiV12ozJKfyMu1gs1/eNM/+LgLtCys
        yF0Ao4ALRGwmT19r8wIJocxTsuHBQsLvzhQLTyrOFbGqvExVYQ6rdoFdFBEeKuzuvJophlmK
        AvZzls1nVU+jGBUkuYh95JV9TNZGFhx8p276smy8bn+n4Pat7158YYxwfpH6lz3U666K9h++
        9P7R8RPSL28tmhS6xxlRvfV1jbFt523vmtrde9MylsIU2vQfGzZqeufmMDJfxzbKju+JTkrP
        CbHbkqupB3Hzs5ZzenHiob6UlcHqVkdCnDOufPWAP+WYMz6q7L3TA3/HXC2Knijvq5l33l+u
        5eU9SUr5UPrPkaL+EGPFWdCZJjNlVzrXRX8KNM0J17XZGtWDjGmfNGX3eKpt31T9sU+ap47G
        1MqZxKGB28FNhVbRqsSdv+ezsH3mpsaYkvqk+PsfFE/0Hb85Gnb+THFiv8ab7HxNqo+9lFz7
        /Wo4oc5W7H0dV6kV/wEdMbJxAgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xe7r/Px+PN5jQoWtx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2qx6fE1VovLu+awWcw4v4/J
        4tDUvYwWa4/cZbc4tkDMonXvEXYHAY/L1y4ye2xZeZPJY+esu+wem1Z1snlsXlLvsXPHZyaP
        vi2rGD0+b5IL4IjSsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
        Sy3St0vQy2i/cIO5YB1fxYQ5bxgbGP9ydzFyckgImEjs/XGOpYuRi0NIYCmjRNOnz4xdjBxA
        CSmJlXPTIWqEJf5c62KDqHnKKNFycy0bSA2bgJ7E2rURIDUiAioSLZtngs1hFrjCIrHqYwsr
        SEJYIERiQ2M7I4gtJBAssXpeD1gvi4CqxKnD0iD1nAJTGSXmnzoAVsMrYC6xdvchZhBbVMBS
        YsuL++wQcUGJkzOfsIDYzALZEl9XP2eewCgwC0lqFpLULKAVzAKaEut36UOEtSWWLXzNDGHb
        Sqxb955lASPrKkaR1NLi3PTcYkO94sTc4tK8dL3k/NxNjMBo3nbs5+YdjPNefdQ7xMjEwXiI
        UQWo89GG1RcYpVjy8vNSlUR4Wf4diRfiTUmsrEotyo8vKs1JLT7EaAr02kRmKdHkfGCaySuJ
        NzQzMDU0MbM0MLU0M1YS5906d028kEB6YklqdmpqQWoRTB8TB6dUAxPzCo33y6NjX087ZtLa
        9GDNnrd3939YfbPKsfbCcdeAt3uv3bz2665qpNAj5jqhJ30ZDz2i95ZwMR2/KGGtEjLbjzlc
        aTrT8uogn+VyntOPcS76tcm22krAIvvI1j4HsQex92qk/Zx5rt424fdRDstzcbny7UrHocRW
        bpum14Lqh3bNOjI5Wbnl788zfoW7k19c3V4vumu++YP893merhmSD1ziYnV8dS7M5D9+0zGw
        4tn3gLnBuvdCrgU07Ji1dKlD+hwf1621ylXtAmphF/9JzfltX+TLckxcLc/rhlf9SreJCu33
        alcea/l4w7ByWdFZrS+f1c7tL5x5wKtcpElW49EbW/tJsy7mMVaa7VBiKc5INNRiLipOBADe
        rt/RewMAAA==
X-CMS-MailID: 20201202200727eucas1p18311ed19904e8a0c7b8c28cde87f155b
X-Msg-Generator: CA
X-RootMTR: 20201202200727eucas1p18311ed19904e8a0c7b8c28cde87f155b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201202200727eucas1p18311ed19904e8a0c7b8c28cde87f155b
References: <20201202091852.69a02069@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CGME20201202200727eucas1p18311ed19904e8a0c7b8c28cde87f155b@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-12-02 =C5=9Bro 09:18>, when Jakub Kicinski wrote:
> On Wed, 02 Dec 2020 11:46:28 +0100 Lukasz Stelmach wrote:
>> >> +	status =3D netif_rx(skb);=20=20
>> >
>> > If I'm reading things right this is in process context, so netif_rx_ni=
()
>> >=20=20
>>=20
>> Is it? The stack looks as follows
>>=20
>>     ax88796c_skb_return()
>>     ax88796c_rx_fixup()
>>     ax88796c_receive()
>>     ax88796c_process_isr()
>>     ax88796c_work()
>>=20
>> and ax88796c_work() is a scheduled in the system_wq.
>
> Are you asking if work queue gets run in process context? It does.
>

Thanks. Changed.

>> >> +	if (status !=3D NET_RX_SUCCESS)
>> >> +		netif_info(ax_local, rx_err, ndev,
>> >> +			   "netif_rx status %d\n", status);=20=20
>> >
>> > Again, it's inadvisable to put per packet prints without any rate
>> > limiting in the data path.=20=20
>>=20
>> Even if limmited by the msglvl flag, which is off by default?
>
> I'd err on the side of caution, but up to you.
>

It isn't very common, but a few drivers do this.

Thank you.
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/H8+8ACgkQsK4enJil
gBAukAgAkQTRQG/TV08hxbnOYPNIUZApxZjUBbwMUF6alZVmWZFrc85AxK9+d6xs
gUPMlb86ylXmRX25dZ2dDCEoUgFOk+GrjLQbLyZTWl3dIIGiDvYJhf09P7qHuPD5
xbScoNohZrPAHxPlvciWexsAZLyboSunzdwiKGWGxpsWLrqz/Pb/x4DIUadv9QGA
siJUkTD0ZVKmO0kXjwBFVlqd1UDUpabwpafIgIr0SNMZT4shawKb8hFUtf3zPyZm
T5de0kdg01XISwJdq9ZnwaN3F4j4Pp2cQGfjPo4rRaztzOm+WytpdudbigmgbhpI
7PS3/QBVB46BH18tTQbHGLdAfBj0Kg==
=8UEH
-----END PGP SIGNATURE-----
--=-=-=--
