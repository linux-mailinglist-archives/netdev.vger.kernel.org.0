Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304141A9815
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408360AbgDOJMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:12:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45302 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408344AbgDOJMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:12:10 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200415091205euoutp010893159ca2c8b4605b20032a268975bf~F80XsQSPs0469404694euoutp01S
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 09:12:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200415091205euoutp010893159ca2c8b4605b20032a268975bf~F80XsQSPs0469404694euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586941925;
        bh=ihC2jkfz1d7lvDLRTfZk+C5FM292xjkHp1pNgRwCkcY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=esKjF/iFoYWKAgEHe7Agp4FuHbibu7GBVaPX7atm5N1bacwBbegvAqr5OhAXoPWQG
         ozxqkohTHab4LJX9cntPUxaHeDtExHqEWU2su5KXIFcOQv46C+vEalSGI2/FOBOZLl
         Gl3gXIr2OxQ8//uhU9wDoBEQj7MqdY/U359JG7Tk=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200415091204eucas1p101f6b173912d41a0557c373fb423fc9e~F80XR6yBY0356803568eucas1p1R;
        Wed, 15 Apr 2020 09:12:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id B4.96.61286.4EFC69E5; Wed, 15
        Apr 2020 10:12:04 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200415091204eucas1p1983548c2db52d8d0c2a5367034ec80dd~F80W6gWnA0526905269eucas1p1y;
        Wed, 15 Apr 2020 09:12:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200415091204eusmtrp266a5b0be9173f136d2c886655562da92~F80W5dOuM1005510055eusmtrp2J;
        Wed, 15 Apr 2020 09:12:04 +0000 (GMT)
X-AuditID: cbfec7f2-ef1ff7000001ef66-ac-5e96cfe488aa
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 35.26.07950.4EFC69E5; Wed, 15
        Apr 2020 10:12:04 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200415091203eusmtip2d83bf0ed2ff415a4aa3b9e24afb549e3~F80VuLINp1653416534eusmtip2o;
        Wed, 15 Apr 2020 09:12:03 +0000 (GMT)
Subject: Re: [RFC 1/8] thermal: int3400_thermal: Statically initialize
 .get_mode()/.set_mode() ops
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <7cbddc1c-0049-6b50-7bca-204bd9df2c30@samsung.com>
Date:   Wed, 15 Apr 2020 11:12:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407174926.23971-2-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sa0wUVxj1zp2dHdCl18XK57PtVms0kUcweqVibNqYadJGf9ikYqXdygRM
        WdjsCIiPiA9QtlpBi8KGWmypPKQCCwXWgq6oPKLu+kQQfGzc6KIssYsVIQJlHEj5d77znXPP
        d5LLY62dm8lvTtgimhL08TrOn61pGnAudjuPRYdWOpfQkpZhlvY7Bhh66vEDlh7JHcH0RN8c
        mu/cx1LzyVDqurOGZvTlstRl/5R27P6bofmeZFrlOKiipTk2ltpcXo4WnTuMqPVxm4qaB0sw
        7Tt0CdGmgun0+vVv6Ol6D6ZXr9xUUbfrJ44O1VpZ6qkOog3pNzCtsubgVbOFuvuFSKgu6WCE
        Yl+IYLPcVwtVxYuE3+u7GcFamskJXW31nNDrcIzyhbuEf3rcauHJ8YuMkPXCywmVvXWMcHgo
        VHh9q0e1NjDKf0WMGL85WTSFrPzOP85dUKcyZmu29j5MR2kob7IZ+fFAloC7+TkyI39eS4oR
        NFV0cMrwEkHnHw2sMvQhON/Szo5bzH8NqWWsJUUI3lRqFJEXwUhZFjYjng8kMeA6w8uaaSQc
        Bmq8almDySs1NN7uxvKCIxGQvb8UyVhDVsK1P4dVMmbJfMjOtDMyfpd8Db5HF1WKZiq05rnf
        HuFHIuFY3oO372ASBPfcvzIKfg9qvflYDgPyox9YujLUytWfQZe3jVNwIDxrrh7jZ8OITTbL
        hjMIhg54xty1CIqODo85PoYuxyAnV8NkIZSfDVHoT+DlhT2MTAMJgHbvVOWIADhScxwrtAYO
        ZGgV9UdQcaqCG48120pwFtJZJlSzTKhjmVDH8n9uAWJLUZCYJBliRSksQUwJlvQGKSkhNnhT
        osGKRv/1leFmXx369+b3jYjwSDdF01KWE61V6ZOlVEMjAh7rpmnKDaOUJkafuk00JX5rSooX
        pUY0i2d1QZrw37o3akmsfov4gygaRdP4luH9ZqahDw8FzIh4//O4ve3rEyN9X6zVp2HjpA05
        upbC/Pj6gubw1obdL1KiitAH6xY401s9P3c+DIxKcc/r3zkwh4+OsT+Zsn3hqq+MbHTn4NKn
        5ZEbJkdow27ZI3zmu8FPpS8hd8Xqdw6eGPkldfGa/svLlvekXDWW1c5I3fHmZOfc9c5rmev2
        6VgpTh+2CJsk/X+BrTzB0wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe885m0drcJqab2IlgwiDpnOaj2aj24fzISr0S+SlpjuotEvt
        TKk+lGVWjspLaDqsVlnp7ELTbJaKWszCWmokJGatRtnFdRHL5aU2LfDbj+f5/x544E+T4l5B
        KJ2jNXB6rVItEQZQ3dNdQ6tczyrSo47Yw6Du0TQFvxweAq6+G6KgrPIPCedHl0D1s6MUGC9G
        gfPFVjg2WkmBs30jvDx8n4Dq4TxocJwUgKW8mYJm54gQrrUVI7C+6xeA8XcdCaOnHiKwmxdB
        T08q1LcMk/Cku08ALudpIUzdtVIw3BgCrYW9JDRYy8l1YaztVQ1iG+teEmztj0i22fTKj22o
        XclebvlIsFZLkZAd7G8Rsm6HwzuvOcR+/+LyY9+ffUCwJd9GhOxtt41gi6ei2PHnXwTbAndI
        E/W6XAMXnq3jDWslKTKIlsriQRodEy+VyePSEqJjJZGKRBWnzsnj9JGKXdJsl9km2FMq2ud+
        XYjyUdV8I/KnMRODjXem/IwogBYzVxA+9b4LGRHtXYThrlt5s5lAPNlvFM5mPiPsKjhD+TKB
        jAo7b9K+TBAjx56mkZk7JDPuh8cGaknfQszo8M+v15CPhUwCLj1umWERo8BPb0wLfEwxy3Fp
        UTvh42BmO35gM/3LLMSPq1yUj/2ZtbiiamjmJsmswJPn+/5xCB5wXSBmeRm+O1JNliCxaY5u
        mqOY5iimOYoZURYUxOXymiwNHy3llRo+V5slzdRprMhbpya7p9GGjO7kTsTQSLJA9Oh6ebpY
        oMzj92s6EaZJSZDolsY7EqmU+w9wet1Ofa6a4ztRrPe5UjI0OFPnLafWsFMWK4uDeFmcPE6+
        GiQhohNMR6qYyVIauN0ct4fT//cI2j80H/WkTzhWz9tQNhm7iqxfs6wg7ZImKaJgX/BY5edD
        5vlb1h8QJSnf5ttVSwY7anJibkjaeovC88PV6gDnaEnh0Yw/Hd+SVJuTP0UVbmr6cC9zwDMl
        3t634U1EiqU2CD+8MyCf6F/MlZ2DZo8ieW/3waXFE4rsjNbB5/b1mVp3RdrN0xKKz1bKVpJ6
        XvkXsOWk2GQDAAA=
X-CMS-MailID: 20200415091204eucas1p1983548c2db52d8d0c2a5367034ec80dd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200415091204eucas1p1983548c2db52d8d0c2a5367034ec80dd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200415091204eucas1p1983548c2db52d8d0c2a5367034ec80dd
References: <20200407174926.23971-1-andrzej.p@collabora.com>
        <20200407174926.23971-2-andrzej.p@collabora.com>
        <CGME20200415091204eucas1p1983548c2db52d8d0c2a5367034ec80dd@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/20 7:49 PM, Andrzej Pietrasiewicz wrote:
> int3400_thermal_ops is used inside int3400_thermal_probe() only after
> the assignments, which can just as well be made statically at struct's
> initizer.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index efae0c02d898..634b943e9e3d 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -271,6 +271,8 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>  	.get_temp = int3400_thermal_get_temp,
> +	.get_mode = int3400_thermal_get_mode,
> +	.set_mode = int3400_thermal_set_mode,
>  };
>  
>  static struct thermal_zone_params int3400_thermal_params = {
> @@ -309,9 +311,6 @@ static int int3400_thermal_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, priv);
>  
> -	int3400_thermal_ops.get_mode = int3400_thermal_get_mode;
> -	int3400_thermal_ops.set_mode = int3400_thermal_set_mode;
> -
>  	priv->thermal = thermal_zone_device_register("INT3400 Thermal", 0, 0,
>  						priv, &int3400_thermal_ops,
>  						&int3400_thermal_params, 0, 0);
> 
