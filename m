Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99914583C
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 15:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAVOyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 09:54:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39301 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVOyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 09:54:06 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200122145402epoutp033d45c8f479aaf36fbb1626bc9364fe53~sPS9Zn5bn1879418794epoutp03x
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 14:54:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200122145402epoutp033d45c8f479aaf36fbb1626bc9364fe53~sPS9Zn5bn1879418794epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1579704842;
        bh=4itLcJd9TovgkIJA4En20KBiCbGG4bMhv7WMq/yt9qs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=U4RQaPc5GK99iRyuoOoQ86PvMPg6xZONm++S2v9H3QDPcr2RXbd/Q62zgzehQXVKv
         75c40NYvV743+KMyPhHjyUb/GMCMl/g/FmWUcfUsAjC2No9A2q3tCSL2XGxCwFtfe0
         FpVa3SyEHQr2Gw1x4KtsmxiCFRzokrFopo9RJN54=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200122145402epcas5p4502ef8824947d257531b08ebb14484e1~sPS8506Za1067910679epcas5p4v;
        Wed, 22 Jan 2020 14:54:02 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.FC.19629.A02682E5; Wed, 22 Jan 2020 23:54:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200122145401epcas5p28907c5b3800ca5410955a856bcd82c8e~sPS72sQu91038710387epcas5p2m;
        Wed, 22 Jan 2020 14:54:01 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200122145401epsmtrp22cfbc217f006f370bdfa6a2d304687c8~sPS710jVu1347513475epsmtrp2V;
        Wed, 22 Jan 2020 14:54:01 +0000 (GMT)
X-AuditID: b6c32a4b-345ff70000014cad-2f-5e28620acae9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        60.A8.10238.902682E5; Wed, 22 Jan 2020 23:54:01 +0900 (KST)
Received: from sriramdash03 (unknown [107.111.85.29]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200122145358epsmtip174221b741edcd5e2af6c3e4345ad2752~sPS5vIs6s2722127221epsmtip1L;
        Wed, 22 Jan 2020 14:53:58 +0000 (GMT)
From:   "Sriram Dash" <sriram.dash@samsung.com>
To:     "'Faiz Abbas'" <faiz_abbas@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
Cc:     <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <dmurphy@ti.com>, <nm@ti.com>,
        <t-kristo@ti.com>
In-Reply-To: <20200122080310.24653-3-faiz_abbas@ti.com>
Subject: RE: [PATCH 2/3] can: m_can: m_can_platform: Add support for
 enabling transceiver through the STB line
Date:   Wed, 22 Jan 2020 20:23:57 +0530
Message-ID: <002101d5d133$c8352100$589f6300$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL34jRp8ckpa4Ru5doAY/bQkCNITwHmOWfLAkdTAPClkTT7kA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7bCmui5Xkkacwet3/Bbvl/UwWsw538Ji
        Mf/IOVaL7tNbWC2+LG1mttj0+BqrxarvU5ktLu+aw2ax9PpFJov1i6awWBxbIGbx5sdZJovW
        vUfYLZY87QBK3tvJ6sDvsWbeGkaPLStvMnl8vHSb0WPTqk42j81L6j36/xp4HL+xncnj8ya5
        AI4oLpuU1JzMstQifbsErozmi43sBe/5Kt7vOc/cwNjF08XIySEhYCLxpvMYK4gtJLCbUaLv
        uEYXIxeQ/YlR4v7EKewQzjdGiQ97ZzLCdCxY+p0FIrGXUaJpzX0o5xWjxMMTd8BmsQnoSpy9
        0cQGkhAROMko8ejaSVYQh1ngMNCSjuVgVZwC5hJHf59kArGFBQok3n25wg5iswioSpz79Bxo
        HwcHr4ClxKIuGZAwr4CgxMmZT1hAbGYBeYntb+cwQ5ykIPHz6TKwkSICThL9p3ewQdSISxz9
        2cMMsldC4Bi7xMfnn9ggGlwkenshLpUQEJZ4dXwLO4QtJfH53V6ommyJy33PoRaUSMx4tZAF
        wraXOHBlDgvIbcwCmhLrd+lD7OKT6P39hAkkLCHAK9HRJgRRrSrx6vZmqOnSEgfWnmaCsD0k
        XvxawDyBUXEWks9mIflsFpIPZiEsW8DIsopRMrWgODc9tdi0wDgvtVyvODG3uDQvXS85P3cT
        IzjhaXnvYNx0zucQowAHoxIPr4OlRpwQa2JZcWXuIUYJDmYlEd4FTapxQrwpiZVVqUX58UWl
        OanFhxilOViUxHknsV6NERJITyxJzU5NLUgtgskycXBKNTC6Lf9kvLTv9UYliV8O3j3SNxr1
        eop/CHy8bP3o0IPI37/Cghk+bNFLCH732cK6KurW38Rtpntabyy++71GsVRIs/Cv0vIz6of5
        Jmocz/0xcVvphj0TrvIVqoYphcx3mdu0V0iSp8oz8O+PvS/d75+Zdk306woNjosTnv1VXDj5
        27EER81iDbn3SizFGYmGWsxFxYkAnY/IZXQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWy7bCSnC5nkkacQccVVov3y3oYLeacb2Gx
        mH/kHKtF9+ktrBZfljYzW2x6fI3VYtX3qcwWl3fNYbNYev0ik8X6RVNYLI4tELN48+Msk0Xr
        3iPsFkuedgAl7+1kdeD3WDNvDaPHlpU3mTw+XrrN6LFpVSebx+Yl9R79fw08jt/YzuTxeZNc
        AEcUl01Kak5mWWqRvl0CV0bzxUb2gvd8Fe/3nGduYOzi6WLk5JAQMJFYsPQ7SxcjF4eQwG5G
        iQ9v17F3MXIAJaQlft7VhagRllj57zk7iC0k8IJR4s5SVRCbTUBX4uyNJjaQXhGBs4wSG24s
        YgdxmAXOM0pMm/qLEWLqZkaJ3V9XMYG0cAqYSxz9fRLMFhbIk9i+qocVxGYRUJU49+k5I8hm
        XgFLiUVdMiBhXgFBiZMzn7CAhJkF9CTaNjKChJkF5CW2v53DDHGcgsTPp8vApogIOEn0n97B
        BlEjLnH0Zw/zBEbhWUgmzUKYNAvJpFlIOhYwsqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dL
        zs/dxAiOWS3NHYyXl8QfYhTgYFTi4XWw1IgTYk0sK67MPcQowcGsJMK7oEk1Tog3JbGyKrUo
        P76oNCe1+BCjNAeLkjjv07xjkUIC6YklqdmpqQWpRTBZJg5OqQbGSfO0Px0N+dYZ4L7+2OSb
        S56JTxDd9fk2j/kihvlGPkJHj7ruD0/YuFxg3cb62dbz1BY+Vb9vbP+y7Uj8jMq0Lx2vlEqN
        zKs+GGx0vMT669AeGV2pU5mx7i+1d2gXC824kbHiKUfNo+DiW5zOsw9MFF3h84Hp7IRll2ZL
        VT7eGP5nV7ldxpKcHUosxRmJhlrMRcWJAMWcZMnVAgAA
X-CMS-MailID: 20200122145401epcas5p28907c5b3800ca5410955a856bcd82c8e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200122080213epcas5p46e361ac6fa299521c1bab3ab20862b46
References: <20200122080310.24653-1-faiz_abbas@ti.com>
        <CGME20200122080213epcas5p46e361ac6fa299521c1bab3ab20862b46@epcas5p4.samsung.com>
        <20200122080310.24653-3-faiz_abbas@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-can-owner@vger.kernel.org <linux-can-owner@vger.kernel.org> On
> Behalf Of Faiz Abbas
> Subject: [PATCH 2/3] can: m_can: m_can_platform: Add support for enabling
> transceiver through the STB line
> 
> CAN transceivers on some boards have an STB (standby) line which can be
> toggled to enable/disable the transceiver. Add support for enabling the
> transceiver using a GPIO connected to the STB line.
> 

Looks good to me. 
Other than Dan's concern on stb  as standby,
Acked-by: Sriram Dash <sriram.dash@samsung.com>

> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> ---
>  drivers/net/can/m_can/m_can_platform.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/can/m_can/m_can_platform.c
> b/drivers/net/can/m_can/m_can_platform.c
> index 38ea5e600fb8..b4e1423bd5d8 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -6,6 +6,7 @@
>  // Copyright (C) 2018-19 Texas Instruments Incorporated -
http://www.ti.com/
> 
>  #include <linux/platform_device.h>
> +#include <linux/gpio/consumer.h>
> 
>  #include "m_can.h"
> 
> @@ -57,6 +58,7 @@ static int m_can_plat_probe(struct platform_device
*pdev)
> {
>  	struct m_can_classdev *mcan_class;
>  	struct m_can_plat_priv *priv;
> +	struct gpio_desc *stb;
>  	struct resource *res;
>  	void __iomem *addr;
>  	void __iomem *mram_addr;
> @@ -111,6 +113,16 @@ static int m_can_plat_probe(struct platform_device
> *pdev)
> 
>  	m_can_init_ram(mcan_class);
> 
> +	stb = devm_gpiod_get_optional(&pdev->dev, "stb", GPIOD_OUT_HIGH);
> +	if (IS_ERR(stb)) {
> +		ret = PTR_ERR(stb);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(&pdev->dev,
> +				"gpio request failed, ret %d\n", ret);
> +
> +		goto failed_ret;
> +	}
> +
>  	ret = m_can_class_register(mcan_class);
> 
>  failed_ret:
> --
> 2.19.2


