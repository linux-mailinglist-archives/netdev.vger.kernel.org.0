Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422B02DD0BB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgLQLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:48:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34747 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgLQLsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:48:07 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201217114715euoutp01b8af0f5ba9c655fe524d643739baa037~RfoErtutE3211532115euoutp01Y;
        Thu, 17 Dec 2020 11:47:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201217114715euoutp01b8af0f5ba9c655fe524d643739baa037~RfoErtutE3211532115euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608205635;
        bh=trJOAepXGanvNKefJRa2+HtY+zVmecGVFzNIzvd+O+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwLdBNei59wCDjHgMXByE6cZ+v7OR6zhDE2jXUBf4U0iUefTnyL8Jk9ehTT6+76v1
         m8Wta7f/uRblradBUlADqP3iZBEC2Wpc+F6weeu/T1U67ve8FGBAWSfT3yY2MwjSrC
         xjs44jbUnTN2u/6xWbe+DxfysDMzIgCpOteou1L8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201217114714eucas1p1681028a9479b452fae53212c9d46efa7~RfoEaGjIY1384413844eucas1p1B;
        Thu, 17 Dec 2020 11:47:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 2B.6C.45488.2454BDF5; Thu, 17
        Dec 2020 11:47:14 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201217114714eucas1p1aea2208877de2a39feb692fe795e6d3e~RfoDoyE7p1847818478eucas1p13;
        Thu, 17 Dec 2020 11:47:14 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201217114714eusmtrp25943cb44adae917f8a727d152c81cec3~RfoDnxpUn0596705967eusmtrp2e;
        Thu, 17 Dec 2020 11:47:14 +0000 (GMT)
X-AuditID: cbfec7f5-c5fff7000000b1b0-69-5fdb4542063a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 89.66.21957.1454BDF5; Thu, 17
        Dec 2020 11:47:13 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201217114713eusmtip2b6d1124127606b6041c060df5d66c6de~RfoDWNZ_e2736627366eusmtip2O;
        Thu, 17 Dec 2020 11:47:13 +0000 (GMT)
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
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Thu, 17 Dec 2020 12:46:57 +0100
In-Reply-To: <20201216081300.3477c3fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 16 Dec 2020 08:13:00 -0800")
Message-ID: <dleftjv9d07iz2.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIKsWRmVeSWpSXmKPExsWy7djPc7pOrrfjDW7+VrU4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcERx2aSk5mSWpRbp2yVwZexc1cVe0Clc8erABcYGxk6BLkZODgkBE4nVXX2s
        XYxcHEICKxglthxvgXK+MEq82jSfDcL5zCjRcHoHE0zL5RvzoKqWM0qsev+TBcJ5zihx4sEv
        IIeDg01AT2Lt2giQBhEBFYmWzTPBapgFLrJIrO/+zAKSEBYIk5i8chPYVBYBVYkjP9eAFXEK
        TGOUODtxBRvIIF4Bc4k708VAakQFLCW2vLjPDmLzCghKnJz5BGwOs0CuxMzzbxhBeiUErnFK
        rL/UwwJxqovEkr1boc4Wlnh1fAs7hC0j8X/nfCaQ+RIC9RKTJ5lB9PYwSmyb8wOq11rizrlf
        bBC2o8TnvtlsEPV8EjfeCkLs5ZOYtG06M0SYV6KjTQiiWkViXf8eqClSEr2vVjBC2B4Sjx79
        YYMH3IS7r5kmMCrMQvLOLCTvzAIayyygKbF+lz5EWFti2cLXzBC2rcS6de9ZFjCyrmIUTy0t
        zk1PLTbOSy3XK07MLS7NS9dLzs/dxAhMiaf/Hf+6g3HFq496hxiZOBgPMaoANT/asPoCoxRL
        Xn5eqpIIb8KBm/FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeXdtXRMvJJCeWJKanZpakFoEk2Xi
        4JRqYIpqS+4K4PP7/O1R4S03E5FND16HhvTU3NMVrVqQEswp9zRp19TV/ubvZqen6K98vuyi
        +Ny/ZkI8M44xmPxu7VsW9K1Q+fCdMOmn934JK+WoLqyYKXH822uempdXduxckGLiP9dGze/c
        4XbtB2VOJraPD/3ZbyZ64YR6sWSYvBwv27J9Mx8FFife6jp80/zi2qM7H3u5qqloTniUd91p
        7qqti75/8lC7y3nfOHjtY9VSs1OvT5XFunRvZjB9G/fWSDX5PP+0VZ5L1ntW6Ny3ua+5MGLf
        pvkCC16+r1RzWZkgLrTs9HcjnRmmZgeYxacb1Lr0c09cz57ka3r25prdpTH9bvFh69/vSZ7y
        ZdJ3KTclluKMREMt5qLiRAApLlPyBAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xe7qOrrfjDRZ8M7M4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7XY9Pgaq8XlXXPYLGac38dk
        cWjqXkaLtUfuslscWyBm0br3CLuDgMflaxeZPbasvMnksXPWXXaPTas62Tw2L6n32LnjM5NH
        35ZVjB6fN8kFcETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSW
        pRbp2yXoZexc1cVe0Clc8erABcYGxk6BLkZODgkBE4nLN+axdjFycQgJLGWU+NXTztbFyAGU
        kJJYOTcdokZY4s+1LjaImqeMEo9uX2ACqWET0JNYuzYCpEZEQEWiZfNMFpAaZoErLBKrPraw
        giSEBUIkmn9/YASxhQSCJbb9WcoOYrMIqEoc+bkGrIFTYBqjxNmJK8AW8wqYS9yZLgZSIypg
        KbHlxX2wel4BQYmTM5+wgNjMAtkSX1c/Z57AKDALSWoWktQsoEnMApoS63fpQ4S1JZYtfM0M
        YdtKrFv3nmUBI+sqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2MwGjeduzn5h2M81591DvEyMTB
        eIhRBajz0YbVFxilWPLy81KVRHgTDtyMF+JNSaysSi3Kjy8qzUktPsRoCvTaRGYp0eR8YJrJ
        K4k3NDMwNTQxszQwtTQzVhLn3Tp3TbyQQHpiSWp2ampBahFMHxMHp1QD0wzx8uxvtzfcPhZj
        dHnqlz8Z80VXBz0POFs1b+3t3rXWbjc+f18854ZpAH/p04sZvYpH0g75Wj3J+1ads94uOdn8
        nMx1vsfOX65Yd1scWVC9kNsndmaYefbHGUs3LKraVnfB56zoNO8Sz3vT3K9wfWXNuqY+M//D
        lKkTbjD/njNdO5cva326iFWjvuKkzZVTJhr6PHBwqd/Olhqp/1tU20Bk+fR9b1nymuuEru0+
        +MUlJSlJLqb9luRT9jOPnq14HX+uqDLOifnmL+G7ci9eNu42V2JRu39j8cECvQpuVpGziz9r
        BXs7TpbTmm1R/dCom9llsbPZnQv3DPiPVE/drHTz9KlpiQbHIljWufnsfqPEUpyRaKjFXFSc
        CAAhe7uiewMAAA==
X-CMS-MailID: 20201217114714eucas1p1aea2208877de2a39feb692fe795e6d3e
X-Msg-Generator: CA
X-RootMTR: 20201217114714eucas1p1aea2208877de2a39feb692fe795e6d3e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201217114714eucas1p1aea2208877de2a39feb692fe795e6d3e
References: <20201216081300.3477c3fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201217114714eucas1p1aea2208877de2a39feb692fe795e6d3e@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-12-16 =C5=9Bro 08:13>, when Jakub Kicinski wrote:
> On Wed, 16 Dec 2020 13:21:52 +0100 Lukasz Stelmach wrote:
>> So, the only thing that's left is pskb_expand_head(). I need to wrap my
>> head around it. Can you tell me how a cloned skb is different and why
>> there may be separate branch for it?
>
> I think this driver needs to prepend and append some info to the packet
> data, right? Cloned skb is sharing the data with another skb, the
> metadata is separate but the packet data is shared, so you can't modify
> the data, you need to do a copy of the data. pskb_expand_head() should
> take care of cloned skbs so you can just call it upfront and it will
> make sure the skb is the right geometry for you.
>
> BTW you should set netdev->needed_headroom and netdev->needed_tailroom

Done.

> to the correct values so the stack pre-allocates the needed spaces,
> when it can.

Yes, I fonud these. However, I am not sure setting needed_tailroom has
any effect. In many places where alloc_skb() is called needed_headrom
and hard_header_len are refered to via the LL_RESERVED_SPACE macro. But
the macro does not refer to needed_tailroom. Once (f5184d267c1a ("net:
Allow netdevices to specify needed head/tailroom") there was
LL_ALLOCATED_SPACE macro, but but it was removed in 56c978f1da1f ("net:
Remove LL_ALLOCATED_SPACE"). And now only some protocols refer to
needet_tailroom.

BTW. What is hard_header_len for? Is it the length of the link layer
header? Considering "my" hardware requires some headers with each
packet, I find hard_headr_len name a bit confusing.

I will be sending v9 in a minute or two.

Kind regards,
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl/bRTEACgkQsK4enJil
gBCKTQf/bsz47oVX7wAepdGon36uxB7NkjfrkRusEjb5lQgwK1sezRF2A0q/1Svo
+9bnGfqOzvMDAOyNYRSZJONI/BGNNsChKJxNtp61iBdpF0rIT2N7suvjZ4NelcYo
WJktIR67b45L604jCZobIt4Tptm8PrOObjRhWvdQ6S/hEmHgX/AIobqslahu0aqS
jgWHjZiBzVKwXDXczDc+7sgc2qZjRVJ9cAMMgxf/FnAbFf/osoNRwZpt2+S9YQh7
cI+4yNxZXgpL+k4TG8gbllzmUBJ4ItFEYDrKdDCeLWdDf4XQzsuVj54W4FQhrxSy
orymFQ8juldvNDaFj9FPjblBMIsK8A==
=6we+
-----END PGP SIGNATURE-----
--=-=-=--
