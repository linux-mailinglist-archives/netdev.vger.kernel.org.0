Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FC22927BA
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgJSM4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:56:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42609 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgJSM4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:56:44 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201019125625euoutp02490b262ea32d40fffdbac40e7b98f621~-ZgoXRrpu1067510675euoutp02l;
        Mon, 19 Oct 2020 12:56:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201019125625euoutp02490b262ea32d40fffdbac40e7b98f621~-ZgoXRrpu1067510675euoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603112185;
        bh=xkkIZ2WKEiH+6i0SWyl/zj0g0D0FTIE+CVpB65/1Mv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VtroWjz0j1P7JofRFEUABSYImiHJ8wfiT3a0EcHg4PKB4P0doBNsXiYMPoiCQgS/E
         tM2P8DjFdr6C6+Ba77zc279NCqgHLa/rlufHDHO2FiWRWhWQGFf/wcwQ5xnGZudLY9
         bUKiKvI9Z8heymD0GOFfNlEpt9uzqQqvVNtLaLo4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201019125625eucas1p25a7f40c1713455325383145cf85e4849~-Zgn5LHrz2903729037eucas1p2W;
        Mon, 19 Oct 2020 12:56:25 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id AB.C5.05997.9FC8D8F5; Mon, 19
        Oct 2020 13:56:25 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201019125624eucas1p257a76c307adfb27202332658f93c9aba~-ZgngUZtl2167321673eucas1p2e;
        Mon, 19 Oct 2020 12:56:24 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201019125624eusmtrp185ca0dfae00e1b1d7a608c6d0f362274~-ZgnfRe8P0725207252eusmtrp1D;
        Mon, 19 Oct 2020 12:56:24 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-7a-5f8d8cf956fc
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 83.DD.06017.8FC8D8F5; Mon, 19
        Oct 2020 13:56:24 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201019125624eusmtip25102e04d6e00204d3e7ae194d80c5323~-ZgnS60Wg0413204132eusmtip2E;
        Mon, 19 Oct 2020 12:56:24 +0000 (GMT)
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
Subject: Re: [PATCH v2 2/4] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Date:   Mon, 19 Oct 2020 14:56:08 +0200
In-Reply-To: <20201002203641.GI3996795@lunn.ch> (Andrew Lunn's message of
        "Fri, 2 Oct 2020 22:36:41 +0200")
Message-ID: <dleftjh7qq4bo7.fsf%l.stelmach@samsung.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-="; micalg="pgp-sha256";
        protocol="application/pgp-signature"
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvZ2lA6F4qdsRBUnVGDdwd4z78jAGo8aoQRPFUSeI0pZ0LIqJ
        AY0oqyCgApKgBBTRAmKDhaDRigISGVwCLlRBSZBWRSwuJW7UqYlv3znn/89ycxlC7aL8mUjd
        fsGg46M0tDdZdd/VPN2VmhY+I77Hj5VsVoK9llNOsfnSMZItqGum2NYP7RSb/tZBsJJUoWRb
        qk5SbOXbVop9UpNPsznSLQVrPX0TsaY6m5K9f34km3CzTrlsKPek9RHBmS8/V3DVeTYlV1ma
        RHPXi+K4aotTwZ00lyLOWRm4ntnqvWi3EBUZIxhCluzw3pNx9QYdnel7sNzagOJRuk8y8mIA
        z4GGlAuKZOTNqHEJglu3n3qCfgSvT5lpOXAieNrjpP5Z2mzfkFy4hODTkXceVTcCqaVTmYwY
        hsbBYDKFuQ3DcRBkN/6g3BoCXyXB4TIp3IVheDM8OvGMcDOJJ0KCpYN2sxfWwjmpCLlZhefD
        e9vnvzwCLwDzu9dKOe8HjbldpJuJQX2u9P7vRoBzGSh+9cWz6iro60ykZR4G9nqzUuax0JSV
        SroXBRwHWZnzZG8qgqr876SsWQjtzQMe73IoKC6kZb0vPPvgJ8/1hcyqs4ScVkHicbWsngBl
        6bWeLv6QZi9BMnNwpyvd81ZHEaT1mokMFJT33zl5/52TN9iWwJOhvCZETk+FixcchMyLoays
        lzyPqFI0SjCK2ghBnKUTDgSLvFY06iKCd+m1lWjwEzb9qu+3oJofO60IM0jjo+rQp4arKT5G
        jNVa0YTBTm8qrrQgf1Kn1wma4aoVD5u2q1W7+dhDgkEfbjBGCaIVjWFIzSjV7MKebWocwe8X
        9glCtGD4V1UwXv7xaK/RZHfOV3fm6PsHOiz2IuP4DQOavpd4+oLfjrlZgbrHrtJ7LwjH4cnf
        tgfWn96YIq4JNZ6qHaBv20VLwbjchoVtd1cXPGgsyf65LsA4mozBv+ktSWuXZpyZlL2pKKBt
        2kf2V/CZhMcO6WVXuH3IXp4P7T5+LG7aFbp1ZdjX/trNGlLcw8+cQhhE/g/BXg6QjAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t/xe7o/enrjDV4fMLU4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFtbd3WC36H79mtjh/fgO7xYVtfawWmx5fY7W4vGsOm8WM8/uYLA5N3cto
        sfbIXXaLYwvELFr3HmF34Pe4fO0is8eWlTeZPHbOusvusWlVJ5vH5iX1Hjt3fGby6NuyitHj
        8ya5AI4oPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsE
        vYwJa7azFUziq1h/6ARjA2M/TxcjJ4eEgInE9bvfGbsYuTiEBJYySrQcusHSxcgBlJCSWDk3
        HaJGWOLPtS42iJqnjBLf/lxhA6lhE9CTWLs2AqRGREBBYsrJP6wgNrPAehaJ1ZM4QWxhgRCJ
        hX2nmEBsIaDyR0vaWEBsFgFVidYdD9hAbE6BXInZ55cwgti8AuYSb+5+ArNFBSwltry4zw4R
        F5Q4OfMJC8T8bImvq58zT2AUmIUkNQtJahbQdcwCmhLrd+lDhLUlli18zQxh20qsW/eeZQEj
        6ypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzACN527OeWHYxd74IPMQpwMCrx8D7I74kXYk0s
        K67MPcSoAjTm0YbVFxilWPLy81KVRHidzp6OE+JNSaysSi3Kjy8qzUktPsRoCvTnRGYp0eR8
        YNLJK4k3NDU0t7A0NDc2NzazUBLn7RA4GCMkkJ5YkpqdmlqQWgTTx8TBKdXAaBtqeCf9/dGb
        p9yXLfaKEPu+8mpvd1Nl7qvMq8+3Me/2TL1/ZNPvqfO0Tqv3zXBdr5S5YrJdtFd/9evnsWv0
        Dh+49n+9Ud1OFbmERoHHbz7e7GWT4GFxz2vg0RZd5ef+suxstfEpYwW3HYG/D3Aqfc5osjXs
        vV9Xusg5buGGP7yxj5iPNE9apcRSnJFoqMVcVJwIANDLPDcCAwAA
X-CMS-MailID: 20201019125624eucas1p257a76c307adfb27202332658f93c9aba
X-Msg-Generator: CA
X-RootMTR: 20201019125624eucas1p257a76c307adfb27202332658f93c9aba
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201019125624eucas1p257a76c307adfb27202332658f93c9aba
References: <20201002203641.GI3996795@lunn.ch>
        <CGME20201019125624eucas1p257a76c307adfb27202332658f93c9aba@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

It was <2020-10-02 pi=C4=85 22:36>, when Andrew Lunn wrote:
>> +static int
>> +ax88796c_open(struct net_device *ndev)
>> +{
>> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
>> +	int ret;
>> +	unsigned long irq_flag =3D IRQF_SHARED;
>> +
>> +	mutex_lock(&ax_local->spi_lock);
>> +
>> +	ret =3D ax88796c_soft_reset(ax_local);
>> +	if (ret < 0)
>> +		return -ENODEV;
>> +
>> +	ret =3D request_irq(ndev->irq, ax88796c_interrupt,
>> +			  irq_flag, ndev->name, ndev);
>
> Maybe look at using request_threaded_irq(). You can then remove your
> work queue, and do the work in the thread_fn.

I looked and I looked and I didn't see how I could reasonably manage
asynchronous start_xmit calls, the work queue also supports at the
moment. Asynchronous start_xmit is important because data are
transmitted via SPI which isn't very fast and it seems better not to
block userspace processes that are sending data. Having both irq and
xmit in the same place doesn't seem bad.

Do you have any recommendations?
=2D-=20
=C5=81ukasz Stelmach
Samsung R&D Institute Poland
Samsung Electronics

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXpuyqjq9kGEVr9UQsK4enJilgBAFAl+NjOgACgkQsK4enJil
gBBA0Qf+PVxyvqzj06gcyrR2PbXJ5rEPz3vOQjLa5BUTQ/GQlHKWnkp5bJ9OHD6F
tQnzghbGzCkThRGwCaNwrHW7l8eAAu1Fx7640l/IOM/cKJycS1u4VlRCXtxx1QCI
6UrlfKCJko3jAXT4eG181iG0mNgtIBW4q5cr4R/MM6DiiIZE4h3M8ZqA2lx2rQLh
ydt5GEn/PsliruCmVe/P3eJBOzf6dgV+k85C9rKUZvXHroDtIByxVGbsHQn8MG8G
CniTgsSuRxi6dFHmrmgLlmEVsFLCWymI0wFNrHGE2pdOpYxbFqyatGoDLcB0W7fD
tpcskJ3f9cjx0Jt4uGGneGYJfvRUsQ==
=Mq/e
-----END PGP SIGNATURE-----
--=-=-=--
