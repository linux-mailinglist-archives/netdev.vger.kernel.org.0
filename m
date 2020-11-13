Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C682B1EAA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgKMP3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:29:51 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36998 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKMP3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:29:50 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201113152938euoutp0197468d7fa35fff619d9ea8863f08a402~HGuiybTAe1498014980euoutp01X
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 15:29:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201113152938euoutp0197468d7fa35fff619d9ea8863f08a402~HGuiybTAe1498014980euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605281378;
        bh=eXpFxQiDPbPJzGcl99AjzmWcz7lTSBvAvdVyGn0Rj1U=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=VPxMojcexDFhRQ7ZYtGMYr3o6bO0LX1DtgqGvcuFEAGCtPV6HeOiAcKIFsD/CLOFD
         /vNI5XHCLpTxsVrLQqYilXBVf93bu34uThTH6FNtA0zK0rViprxxMY260jpJC94QTg
         pEdQ7I2mRsbdIsErDSHcSRCNY+0KUFa0NZDsfUfY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201113152938eucas1p1b570c141f19acdecb63bfe129c6adb63~HGuin2vpJ2614326143eucas1p1_;
        Fri, 13 Nov 2020 15:29:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id A3.F5.44805.266AEAF5; Fri, 13
        Nov 2020 15:29:38 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201113152938eucas1p2c8500d9d3d0c892c7c2a2d56b32fedc0~HGuiIvQBl1201512015eucas1p2c;
        Fri, 13 Nov 2020 15:29:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201113152938eusmtrp1fa3d047e86f51e4669042f00c951ff79~HGuiCRAn41760917609eusmtrp1E;
        Fri, 13 Nov 2020 15:29:38 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-8c-5faea662d954
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 59.46.16282.166AEAF5; Fri, 13
        Nov 2020 15:29:38 +0000 (GMT)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201113152937eusmtip2cf56823ab93846d53b49d0f325c5b72d~HGuhhrN3C2784427844eusmtip2D;
        Fri, 13 Nov 2020 15:29:37 +0000 (GMT)
Subject: Re: [PATCH net-next v2 RESEND] net/usb/r8153_ecm: support ECM mode
 for RTL8153
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        oliver@neukum.org, linux-usb@vger.kernel.org,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
Date:   Fri, 13 Nov 2020 16:29:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-392-Taiwan-albertk@realtek.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsWy7djPc7pJy9bFG/zvVrfYOGM9q8W0gz2M
        FufPb2C3uLxrDpvFjPP7mCwWLWtltji2QMziS+8sVovvlz8xOXB6bFrVyebx+ssDJo/Hbzez
        e/RtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG4a5e9oJzfBW3dj9gamD8zN3FyMkhIWAisa3h
        FmMXIxeHkMAKRombVxZAOV8YJQ4tu8gE4XxmlOie/p8VpmVO82yoxHJGiRPTZ7BAOO8ZJWbf
        WcAEUiUsECkx81EPI4gtImAnMf3lBbC5zAINTBLTZ7xkAUmwCRhKdL3tYgOxeYGKTvz9BtbM
        IqAq8aVxHVhcVCBJYvuW7awQNYISJ2c+Aerl4OAEqj9+rg4kzCwgL7H97RxmCFtc4taT+WDX
        SQi84ZA4uGoBO8TZLhKN+5+yQdjCEq+Ob4GKy0icntzDAtHQzCjx8Nxadginh1HictMMRogq
        a4k7536xgWxmFtCUWL9LHyLsKPH4zwRGkLCEAJ/EjbeCEEfwSUzaNp0ZIswr0dEmBFGtJjHr
        +Dq4tQcvXGKewKg0C8lns5C8MwvJO7MQ9i5gZFnFKJ5aWpybnlpslJdarlecmFtcmpeul5yf
        u4kRmJhO/zv+ZQfj8lcf9Q4xMnEwHmKU4GBWEuFVdlgTL8SbklhZlVqUH19UmpNafIhRmoNF
        SZw3aQtQSiA9sSQ1OzW1ILUIJsvEwSnVwCRvLLREeH9N+duF2pfXLVqooR3abxhxrnT30WyF
        E51vefXffbW+pcmZ8k922YOWye7hRllB3vHNayyeVycvMYgrkRe295WacjpjW7Tdomju5Uae
        GXmfbB+qHFvfc/9pfPCj5JW86rcEP6lJy15qX7lte0yRu9a7OolkmVexOtm8mzTS5kwxTF5p
        +W71er8Sng83Ohb3REaE/7zgoJ34Lif175aeQyFcoY9lpnwO67WIOvlx6taEz7Ht2X0hpzVs
        rN6odJfpXHt5i/V0xZVPz5tbvdumTXKa+zvEs+RY7SVDxeBtWgvdv0gYXJ+jWmuw8N7ftt4C
        tg874v2bbwhVPKuT/L3m/YE756btSvlxVomlOCPRUIu5qDgRAAAzPem7AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t/xe7pJy9bFG1zbwmixccZ6VotpB3sY
        Lc6f38BucXnXHDaLGef3MVksWtbKbHFsgZjFl95ZrBbfL39icuD02LSqk83j9ZcHTB6P325m
        9+jbsorR4/MmuQDWKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSc
        zLLUIn27BL2Mw1297AXn+Cpu7X7A1MD4mbuLkZNDQsBEYk7zbKYuRi4OIYGljBLrrj9mh0jI
        SJyc1sAKYQtL/LnWxQZR9JZR4lzLVLAiYYFIiZmPehhBbBEBO4npLy8wghQxCzQxSXzve8UC
        khASKJQ49GU+M4jNJmAo0fUWZBInBy9Qw4m/35hAbBYBVYkvjevA4qICSRIzj59lh6gRlDg5
        8wnQHA4OTqD64+fqQMLMAmYS8zY/ZIaw5SW2v50DZYtL3Hoyn2kCo9AsJN2zkLTMQtIyC0nL
        AkaWVYwiqaXFuem5xUZ6xYm5xaV56XrJ+bmbGIFxuO3Yzy07GFe++qh3iJGJg/EQowQHs5II
        r7LDmngh3pTEyqrUovz4otKc1OJDjKZA70xklhJNzgcmgrySeEMzA1NDEzNLA1NLM2MlcV6T
        I0BNAumJJanZqakFqUUwfUwcnFINTBsu6hYI3Fyzd6nXsWn+Dwvqd4q+E1iu+C+pfItg3o1P
        +07vZYsVKbxtqjpv08yCRqUPps3euauluN07b3Vc5U+YmRWfrN0s97jB0v2X4bYHV+/6pbXP
        Pab8aVvqVv7IcGfmN/J7ji92EdOWWfR/2fXYRql73m43DaMfTGWV1fIwFF6+YTp7eYyId1f7
        iWt7nl8RPRW815VFZ9Ox+IeParK2uT3ojjuwZmdMbvP8Yxs7uC2z0++vTa+MvMuqejbP7/DW
        NU9V3KxM+Cpt/78pWiq398jFgsZdzIYLub2qvE8+EG7ZrSFxjTX2qrDk3zesUw8+7pjzq6n5
        XtK+9N0Hv2+4wnF6xQax6DM2dp9O1yixFGckGmoxFxUnAgBm23OcTAMAAA==
X-CMS-MailID: 20201113152938eucas1p2c8500d9d3d0c892c7c2a2d56b32fedc0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201113152938eucas1p2c8500d9d3d0c892c7c2a2d56b32fedc0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201113152938eucas1p2c8500d9d3d0c892c7c2a2d56b32fedc0
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
        <1394712342-15778-392-Taiwan-albertk@realtek.com>
        <CGME20201113152938eucas1p2c8500d9d3d0c892c7c2a2d56b32fedc0@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hayes,

On 04.11.2020 03:19, Hayes Wang wrote:
> Support ECM mode based on cdc_ether with relative mii functions,
> when CONFIG_USB_RTL8152 is not set, or the device is not supported
> by r8152 driver.
>
> Both r8152 and r8153_ecm would check the return value of
> rtl8152_get_version() in porbe(). If rtl8152_get_version()
> return none zero value, the r8152 is used for the device
> with vendor mode. Otherwise, the r8153_ecm is used for the
> device with ECM mode.
>
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

This patch landed recently in linux-next and breaks ethernet operation 
on Samsung Exynos5422 Odroid XU4/HC1 boards when kernel is compiled from 
arm/configs/multi_v7_defconfig. The main problem is that the hardware is 
bound to r8153_ecm driver, not to the r8152. Manually switching the 
drivers by "echo 4-1:2.0 >/sys/bus/usb/drivers/r8153_ecm/unbind && echo 
4-1:2.0 >/sys/bus/usb/drivers/r8152/bind" fixes ethernet operation.

This is because in multi_v7_defconfig r8153_ecm driver is built-in (as 
it is tied to CONFIG_USB_NET_CDCETHER), while the r8152 driver is 
compiled as module and loaded when r8153_ecm has already bound.

I think that r8153_ecm driver should have a separate Kconfig symbol, 
which matches the r8152 driver (either both are built-in or both as 
modules), otherwise those 2 drivers cannot properly detect their cases.

> ---
>   drivers/net/usb/Makefile    |   2 +-
>   drivers/net/usb/r8152.c     |  30 +------
>   drivers/net/usb/r8153_ecm.c | 162 ++++++++++++++++++++++++++++++++++++
>   include/linux/usb/r8152.h   |  37 ++++++++
>   4 files changed, 204 insertions(+), 27 deletions(-)
>   create mode 100644 drivers/net/usb/r8153_ecm.c
>   create mode 100644 include/linux/usb/r8152.h
>
> > ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

