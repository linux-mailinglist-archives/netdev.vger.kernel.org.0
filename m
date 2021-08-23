Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED453F4A5B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhHWMJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:09:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10076 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbhHWMJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 08:09:34 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210823120850euoutp02ce15d255becbd397b3f87b2ae32b4802~d7jAizxvr3055830558euoutp02N
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 12:08:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210823120850euoutp02ce15d255becbd397b3f87b2ae32b4802~d7jAizxvr3055830558euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1629720530;
        bh=pJfmX1Sm9JXU9J42wTwyNLfJJPgLGvYFX3GU9wt5Dg4=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=YFkmRmS1y4ZnPWFLpVnJsy72C5lCQBJzLGfNeJVkol6iR6SE6fkp19G6G4o6l4mGs
         NYu2zMAL2UXATNdoAIXGXa6X7eGYAcTagPEIdjBViseouQupbWMfD5kemx2Ul+CsIf
         0pWz0lyorb6vRJUJMhoeiCQ1zrPWxvCzhb+zaeCM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210823120850eucas1p2b3a337e39360696e08827ad1ad02d47e~d7jATp0G62022220222eucas1p29;
        Mon, 23 Aug 2021 12:08:50 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 77.54.56448.2DF83216; Mon, 23
        Aug 2021 13:08:50 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210823120849eucas1p11d3919886444358472be3edd1c662755~d7i-vN8cw1232312323eucas1p1e;
        Mon, 23 Aug 2021 12:08:49 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210823120849eusmtrp1d7348b4da291ef7d77a1f7f7850283be~d7i-uU-SB1534715347eusmtrp1y;
        Mon, 23 Aug 2021 12:08:49 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-ae-61238fd21db6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 76.75.20981.1DF83216; Mon, 23
        Aug 2021 13:08:49 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210823120849eusmtip17606a090bec84df892e21773f339aa9d~d7i-Dy6TU2428124281eusmtip1C;
        Mon, 23 Aug 2021 12:08:49 +0000 (GMT)
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for
 "phy-handle" property
To:     Saravana Kannan <saravanak@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
Date:   Mon, 23 Aug 2021 14:08:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818021717.3268255-1-saravanak@google.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7djP87qX+pUTDY5eELI4f/cQs8X8I+dY
        LWa++c9msWO7iMWC2dwWl3fNYbM41BdtcWyBmEXr3iPsFl2H/rI5cHls272N1eP9jVZ2j52z
        7rJ7LNhU6rFpVSebx+Yl9R47d3xm8vi8SS6AI4rLJiU1J7MstUjfLoEr48PM96wFswQq/mw5
        ydjAuJW3i5GTQ0LAROLpqmb2LkYuDiGBFYwSey5NZYZwvjBKrFi9lAnC+cwoce5qIwtMy7+2
        /awQieVAVVsvsEA4Hxkllr3Zyw5SJSwQKXF23142EFtEoFTi2e3DjCBFzAL3GCVm/dvKCpJg
        EzCU6HrbBVbEK2AnsX3SKjCbRUBV4uqCl8wgtqhAssTEJ5NYIWoEJU7OfAJ2BqeAjURj8x2w
        OLOAvMT2t3OYIWxxiVtP5oPdLSHQzCmx/PQdoAYOIMdF4mqLNMQLwhKvjm9hh7BlJE5P7mGB
        qmeUeHhuLTuE08MocblpBiNElbXEnXO/2EAGMQtoSqzfpQ8RdpT43f6YFWI+n8SNt4IQN/BJ
        TNo2nRkizCvR0SYEUa0mMev4Ori1By9cYp7AqDQLyWezkHwzC8k3sxD2LmBkWcUonlpanJue
        Wmycl1quV5yYW1yal66XnJ+7iRGYtk7/O/51B+OKVx/1DjEycTAeYpTgYFYS4f3LpJwoxJuS
        WFmVWpQfX1Sak1p8iFGag0VJnHfX1jXxQgLpiSWp2ampBalFMFkmDk6pBqbAzLPzT1lNfnRj
        yl8+60OrD2u94Sg+5+xy8ch/zvNy8xWeqARnXl59qmVDgpaI6OXCl/9sWlm/3/WVmLb02sGW
        583XcqUNhW6u0+yu6H33ptnO09fhX2HtlCsfbD9c2Hywb2qbpYx076nkc8fDj39Y2WLXlP9p
        cUjQRIbtlbeUlsgxFShntAasYX2ZVysxf52zNneD/6ejfUwP0nZpal570jWrvF/V+u3rL+/n
        b2ZZ9HbWphp/qcY7vRt2P/bXn3G6Z0LlZvu1p9k3G93Y18JzfMbuQusr31UfqxycsPZ90Euu
        bfI3yqS0Ko4uO/Di6pVPQg/M5fs9M7Z9V9bv9Z50c3HFrU+fN9xWiv9d/5tJSomlOCPRUIu5
        qDgRAOIrzXvKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xu7oX+5UTDdbf17Y4f/cQs8X8I+dY
        LWa++c9msWO7iMWC2dwWl3fNYbM41BdtcWyBmEXr3iPsFl2H/rI5cHls272N1eP9jVZ2j52z
        7rJ7LNhU6rFpVSebx+Yl9R47d3xm8vi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jE
        Us/Q2DzWyshUSd/OJiU1J7MstUjfLkEv48PM96wFswQq/mw5ydjAuJW3i5GTQ0LAROJf235W
        EFtIYCmjxNMV/BBxGYmT0xpYIWxhiT/Xuti6GLmAat4zSizb1skEkhAWiJT4/uwkI4gtIlAq
        sePAT3aQImaBe4wSp25cYoKYai0xf8ZuFhCbTcBQoustyCRODl4BO4ntk1aB2SwCqhJXF7xk
        BrFFBZIlPpxeygpRIyhxcuYTsF5OARuJxuY7YHFmATOJeZsfMkPY8hLb386BssUlbj2ZzzSB
        UWgWkvZZSFpmIWmZhaRlASPLKkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMAo3Xbs55YdjCtf
        fdQ7xMjEwXiIUYKDWUmE9y+TcqIQb0piZVVqUX58UWlOavEhRlOgfyYyS4km5wPTRF5JvKGZ
        gamhiZmlgamlmbGSOK/JkTXxQgLpiSWp2ampBalFMH1MHJxSDUzxd96FSHzwOnXlOk8nz7Fr
        pnmzwh7M9p18dkmThjfn/oq+83ziz0TLZu44mZN7d57B1etx652KmN4+/LzqwH5rrhk7Dh7d
        sOPK283m+dalsk/yAr/NvFtzueNmaO0Ml5I0xmlJFbMPrU2zEfetqd5V4Z7/znJ5uSJDWf1H
        LWu1LTXCPz49P+LOanXjAqNtRtNXVfMNT72cXtZOiF91aOGlug+b7+0TN/4xz+LNqv2+5q9S
        ed/POZ4SqqLg8PCp9pW/SpInnr3cWj4p5emBci6OTW/MGGYnPm1OfXtCOvvbjdYLT36Zvn1x
        TsRzzf8JbX73fxlHa+xZnHe4ddUaB33TWufptiZG7x9Lz3F6ueXlfyWW4oxEQy3mouJEALpD
        UjtbAwAA
X-CMS-MailID: 20210823120849eucas1p11d3919886444358472be3edd1c662755
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210823120849eucas1p11d3919886444358472be3edd1c662755
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210823120849eucas1p11d3919886444358472be3edd1c662755
References: <20210818021717.3268255-1-saravanak@google.com>
        <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 18.08.2021 04:17, Saravana Kannan wrote:
> Allows tracking dependencies between Ethernet PHYs and their consumers.
>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Saravana Kannan <saravanak@google.com>

This patch landed recently in linux-next as commit cf4b94c8530d ("of: 
property: fw_devlink: Add support for "phy-handle" property"). It breaks 
ethernet operation on my Amlogic-based ARM64 boards: Odroid C4 
(arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts) and N2 
(meson-g12b-odroid-n2.dts) as well as Khadas VIM3/VIM3l 
(meson-g12b-a311d-khadas-vim3.dts and meson-sm1-khadas-vim3l.dts).

In case of OdroidC4 I see the following entries in the 
/sys/kernel/debug/devices_deferred:

ff64c000.mdio-multiplexer
ff3f0000.ethernet

Let me know if there is anything I can check to help debugging this issue.

> ---
> v1 -> v2:
> - Fixed patch to address my misunderstanding of how PHYs get
>    initialized.
>
>   drivers/of/property.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/of/property.c b/drivers/of/property.c
> index 931340329414..0c0dc2e369c0 100644
> --- a/drivers/of/property.c
> +++ b/drivers/of/property.c
> @@ -1291,6 +1291,7 @@ DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
>   DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
>   DEFINE_SIMPLE_PROP(leds, "leds", NULL)
>   DEFINE_SIMPLE_PROP(backlight, "backlight", NULL)
> +DEFINE_SIMPLE_PROP(phy_handle, "phy-handle", NULL)
>   DEFINE_SUFFIX_PROP(regulators, "-supply", NULL)
>   DEFINE_SUFFIX_PROP(gpio, "-gpio", "#gpio-cells")
>   
> @@ -1379,6 +1380,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
>   	{ .parse_prop = parse_resets, },
>   	{ .parse_prop = parse_leds, },
>   	{ .parse_prop = parse_backlight, },
> +	{ .parse_prop = parse_phy_handle, },
>   	{ .parse_prop = parse_gpio_compat, },
>   	{ .parse_prop = parse_interrupts, },
>   	{ .parse_prop = parse_regulators, },

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

