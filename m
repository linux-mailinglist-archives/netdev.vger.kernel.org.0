Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BDB1CD27D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEKHVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 03:21:55 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57880 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgEKHVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 03:21:55 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200511072153euoutp01441b129c10730bcc985a3baf45d30e5d~N6FlPqiOI0516305163euoutp01z
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 07:21:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200511072153euoutp01441b129c10730bcc985a3baf45d30e5d~N6FlPqiOI0516305163euoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589181713;
        bh=jQRxiTgD4oOfOKqSBy9Ct17nVvYdxO/psoLyZ57ucyw=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=UhZPMmT/wO0VL9zPQTSK4UVRthzUQ9Kb6bQtBaUpKzOWtLseVTyq2k1sIxgZJsj27
         Qy5WBSmiZiF0BlU6hi/t2yTMY7gfbaNwrk8GLOOim6U8e8B0juLnkF1k7mRL4zP3De
         QFhmw/yREW55syDFBUQYZfu8E8wpGLyhu+8QQM10=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200511072153eucas1p170a81c937518e91b4647fbe31fed997a~N6FkoEmeT1948519485eucas1p1A;
        Mon, 11 May 2020 07:21:53 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 59.AB.60698.11DF8BE5; Mon, 11
        May 2020 08:21:53 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200511072152eucas1p1c4f79bc7f9c15ac02a53dea588dd81f2~N6FkLVRxB0395203952eucas1p1E;
        Mon, 11 May 2020 07:21:52 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511072152eusmtrp277847a9e6cb84e3fa579d878a385edcf~N6FkKhgDT0543805438eusmtrp2U;
        Mon, 11 May 2020 07:21:52 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-2e-5eb8fd11a6f7
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D9.2C.08375.01DF8BE5; Mon, 11
        May 2020 08:21:52 +0100 (BST)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511072151eusmtip2fa15b1726e2446d57ae835d8dcebd949~N6FjcpNOe0762807628eusmtip2W;
        Mon, 11 May 2020 07:21:51 +0000 (GMT)
Subject: Re: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     nsaenzjulienne@suse.de, wahrenst@gmx.net,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <350c88a9-eeaf-7859-d425-0ee4ca355ed3@samsung.com>
Date:   Mon, 11 May 2020 09:21:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508223216.6611-1-f.fainelli@gmail.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRiGe8852zlOZ8e58sGsYFCQ5BcGHjG0UPKEBPUrCDRXHvzIrzY1
        LQj7QNxSTMNmU9MmoQ7McjqnYuIMVy2n6Y/UTBFNVFIJNZaU5nay/Hffz3vdPPcDL4VLPgu8
        qeT0LE6RLk+VCUWEsf/noJ/Hb1NcYMVTkqkavE8wG8tvSKa6sgwxDS91Amaks0rIlOqbhEx/
        7X7GqK0XMksTGoJ5XN1NMoaWcpyxvFXhp9xY7dSAkG1tHMPY0gE/tkP7hWTrWnqErKHBl122
        2Uh2TtOHsQbrLXa15dB50SXRyQQuNTmHUwSEx4uS7NMrgkyVa+6kbpjMR5uUGrlQQJ+A8ZIP
        mBqJKAndgMA8Xy3gzRqC9TsqxJtVBGNdfYKdyIPFyr+RegRtH8sI3qwg6F/twRyUJx0Nkx31
        zoSUjgTNJz3pgHB6DYNVY4HzQUgHgXpJLXRoMR0OBUUqwqEJ+gg0lkw5mX10LFjrDIhnPODd
        k1kn40KHgm7O5GRw+jC0L1XhvPaC8dkaZz2g10koHTdifO8oKJwoJHjtCYuWVpLXPrDVsRO4
        h2Da1kTypgjByN0KxFNhMGHb2K5Kba84Bs2dAfz4NJhn5jHHGGh3GF3y4Eu4Q5lRg/NjMRQW
        SHj6KGgtL/6t7R0axh8imXbXadpd52h3naP9v7cWEXrkxWUr0xI5ZXA6d8NfKU9TZqcn+l/N
        SGtB21/OumlZN6HXv66YEU0hmZvYftAUJxHIc5R5aWYEFC6TitnJ7ZE4QZ53k1NkXFZkp3JK
        MzpAETIvcbBuIVZCJ8qzuGscl8kpdl4xysU7H41EU++lgRcubsR8Tc3pcnOvbGseKg+QpIRl
        XsdTtkJKnuUeLo9Qxz8a7dDYjluxSJ19it6jemW/XcOZrd+7i/XTPqXSH9WturDes3ULUeJk
        S2jK4Le2jdxzRlf/mYrFRB0VHWz0LW58Ltc3cHtjfEKohXaf6ZmK7jPLfd0R2TJCmSQP8sUV
        Svkf4DNxam4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t/xe7oCf3fEGby8oWgx53wLi8Wvd0fY
        LebOnsRosWLDIlaLy7vmsFlMXLWWzeLYAjGLbbOWs1m8vTOdxWLa3L3sFps3TWW2OH6ik9mB
        x2PW/bNsHltW3mTymHhW12PnrLvsHos37Wfz2LxCy+PduXPsHs+mH2by2Hy62uPzJrkArig9
        m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jB8P37MW
        dHJX3Ft0ib2B8R9HFyMnh4SAiUT3q9lMXYxcHEICSxkl7myfyQ6RkJE4Oa2BFcIWlvhzrYsN
        ougto8Th/4/AioQF3CXu7VwOViQi4Cwx/foqdpAiZoFvTBInZvcxQ3T0MErMfrmDGaSKTcBQ
        oustyChODl4BO4m2nk4WEJtFQFViZf99sEmiArESq6+1MkLUCEqcnPkErIZTwFJi0bMdYDXM
        AmYS8zY/ZIaw5SW2v50DZYtL3Hoyn2kCo9AsJO2zkLTMQtIyC0nLAkaWVYwiqaXFuem5xYZ6
        xYm5xaV56XrJ+bmbGIFRve3Yz807GC9tDD7EKMDBqMTDG6CwI06INbGsuDL3EKMEB7OSCK/H
        PaAQb0piZVVqUX58UWlOavEhRlOg5yYyS4km5wMTTl5JvKGpobmFpaG5sbmxmYWSOG+HwMEY
        IYH0xJLU7NTUgtQimD4mDk6pBsbeN8q3fJ8sCe8yiN7Io2kSV9BZ8qhN8FWlp5jTyc+zdX6V
        d15Jm7c+Rn+umltqffmOaJlmj/OT7D6cfXjL3j9Yyq5ZZ4636NQ+Vg+Vdf6viyL1WgunSuif
        zpkrsvhv6eKPP3TvihU1FLgdVtOYGTDxzan7Aj26DyqqTm+aPyPA6Vr+uvy8OUosxRmJhlrM
        RcWJAF3vnFAAAwAA
X-CMS-MailID: 20200511072152eucas1p1c4f79bc7f9c15ac02a53dea588dd81f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01
References: <CGME20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01@eucas1p2.samsung.com>
        <20200508223216.6611-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 09.05.2020 00:32, Florian Fainelli wrote:
> The GENET controller on the Raspberry Pi 4 (2711) is typically
> interfaced with an external Broadcom PHY via a RGMII electrical
> interface. To make sure that delays are properly configured at the PHY
> side, ensure that we get a chance to have the dedicated Broadcom PHY
> driver (CONFIG_BROADCOM_PHY) enabled for this to happen.
>
> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> David,
>
> I would like Marek to indicate whether he is okay or not with this
> change. Thanks!

It is better. It fixes the default values for ARM 32bit 
bcm2835_defconfig and ARM 64bit defconfig, so you can add:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

There is still an issue there. In case of ARM 64bit, when Genet driver 
is configured as a module, BROADCOM_PHY is also set to module. When I 
changed Genet to be built-in, BROADCOM_PHY stayed selected as module. 
This case doesn't work, as Genet driver is loaded much earlier than the 
rootfs/initrd/etc is available, thus broadcom phy driver is not loaded 
at all. It looks that some kind of deferred probe is missing there.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

