Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A74820705D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390071AbgFXJt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:49:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33170 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389848AbgFXJtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:49:24 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624094923euoutp019517b3ebaf7c2cefc4e94e6450efd512~bce6nnOGl2557825578euoutp01d;
        Wed, 24 Jun 2020 09:49:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624094923euoutp019517b3ebaf7c2cefc4e94e6450efd512~bce6nnOGl2557825578euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592992163;
        bh=Hu4Qdif3UbMEKdxlBS9vbnOGmQWb8dRrpdrfFL2pmaQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=HCv9cG0sZk3QpjU7BIPvsW4VhnEV/o3hbHYvKwjX90H9utnLc+GTgmOCAQZ4dRPKs
         GlmecvxWR8Ok65hqkwvX3686BXXTcz5wMNqvaVSrKFRyU7/+qwviNAQEIDNne/d9n1
         Kj9/ViPz6CcgP+1WBSkDqrS8hzMtOgEEHtgiKY+o=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624094922eucas1p23cb64e3529eacfecf6c95072f6f4fb9d~bce6ZrHPq2662826628eucas1p2F;
        Wed, 24 Jun 2020 09:49:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 30.A8.06318.2A123FE5; Wed, 24
        Jun 2020 10:49:22 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200624094922eucas1p126f9a79810d912cf6f561c5f52153b43~bce55G-2n1796317963eucas1p1n;
        Wed, 24 Jun 2020 09:49:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624094922eusmtrp14c2ce8276db0a40816209b5b494300ba~bce53sfaG3055130551eusmtrp1C;
        Wed, 24 Jun 2020 09:49:22 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-0c-5ef321a2f7ed
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FB.92.06017.2A123FE5; Wed, 24
        Jun 2020 10:49:22 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624094920eusmtip1a75817b4fcfe10a797e8912ad5285b16~bce4N31Sj1488214882eusmtip1R;
        Wed, 24 Jun 2020 09:49:20 +0000 (GMT)
Subject: Re: [PATCH v4 06/11] thermal: Add mode helpers
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <c7a02885-cdb0-2951-0dd3-67684edfe980@samsung.com>
Date:   Wed, 24 Jun 2020 11:49:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-7-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta0xTZxjH955bC1vJocD6eiFmnS6DbKJj2Z4MR9Ttw8m+bPu0ZVNcN07Q
        DKppgc3NZXQRxYKIoKKVSWVqLxLAFiggQwNLq3QUkMC8FFMubq3jILa7YUZZ2wMZ3/7v8//9
        83+eD6+UlB+TrJbuURfyGrUqX8nEU+3Oec/LDc+FcjZVf58GlhthCv72zBNwaeo+BdWnF0m4
        opsg4FwoFeoGD1KgP78JStvHaZgYfRcOhU5TsDj5e+R1/S24o7tKQJ2/GCbNBgnYPRU0WE92
        UtBgOc9A54TAgKnnGALb1BgN+icWEkJHf0LQFpglIOiLFM2YvRI4Yj+OoK/NSEDf4R4anMZn
        wXWqkobaubMIhoZ2wOVuPwk/u2/RMD1RycCCw0aBv1UB7quF8GPpMAl220kSxowhCky+LsnW
        l7hzjV9zDzrqaG6k8ijBdYxfQFyr5Q7BmYMZXKdhXMLZzencD90BgrNZjzCcd6yb4WY9nsj8
        wrfc45lpCfdrbR/BVc0JzHv4o/gtuXz+nmJek5H9Sfzua8I1ep9j7ZdzDidZggIKPYqTYvZV
        3D9yhtCjeKmcNSP8qE1PRQ05+wfCwwPbRSOEcFnwOrOcuN3w3RJkQvhi6WYREhB21RglUSOJ
        fR17B5tRVCezmXi+XZBEIZLVy7DwW08MYtg38PHD1hgkY7NxeXlTTFPsBlx1pSKmU9gPcdDX
        R4tMIr55ZjrWHMe+iR03KmMMySrw3el6QtTrsEOoI6NlmP0rDt9raV5a+21cMTJJizoJP3S1
        SkS9FrtrKigx0ITwQpl/Ke1A2FQTXkpnYa/nSURLIxVpuLkrQxxvw/f9I1R0jNkEfFtIFJdI
        wNXttaQ4luGyQ3KRfgG3XGphlmv1nRayCikNK04zrDjHsOIcw/+9RkRZkYIv0hbk8dpMNf/F
        Rq2qQFukztv42d4CG4p8E3fY9WcH6vn3017ESpHyGVmL73GOnFYVa/cX9CIsJZXJsu0D7hy5
        LFe1/ytes3eXpiif1/aiNVJKqZBlNgR2ytk8VSH/Oc/v4zXLLiGNW12CTk0ZG9M44SnunecT
        xoitTwctHa6uVTtm/nGpFuzUrRPeAafOevnAL+n9WeuTTb6c11IWDjRuuBg4UUuG5x/Vb3n/
        m4zyej8Z+kCjS0hdTFo1kHtPoZtVv7gmMWtn6q7Rrv6SpKYhuZykDw6nkNkfr3uIBl+5ue2B
        864iPFpast6gpLS7VZvTSY1W9R+SnOtPIgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxbZRTHee5bL2izuwL2kaDOqlmyzAuFYQ97IURNvPplJrqEKDIbdgPL
        KF1uX+LU6CCyubJVWLK3jjGozNEOxRVGywpM26XM1XUvZjgWutANB4SVAP2AzDEsrSZ8+51z
        /r+cnOSwpMLOZLE7q42iVK2tUjFpVPDpYPh1+8uxstzbV1PBceUpBfOhBQJ+eHCPgsPHl0g4
        XxMhoDn2AjRd/4YCS2su1PWEaYjc3gr7YscpWLo/Fa9+eQuGa7wENE2Y4X67TQZdoYM0OI/0
        UmB3tDLQG4kycHbgOwSuB0M0WB47SIgduozgwuQ0AXOj8UWP2kdkcKCrEYH/QgsB/v0DNARa
        noPBo1Yajs2cRHDjRimc65sg4ffgLRrGIlYGFt0uCia6lRD0GqG/7iYJXa4jJAy1xCg4O3pR
        VrxeaO74QvjL00QLf1gPEYIn3IaEbscwIbTP5Qi9trBM6GpfJ3zfN0kILucBRhgZ6mOE6VAo
        3m/7Wph9NCYTHh7zE0LDTJR5H3/Eb5b0JqO4plJvMG5RfayGPF5dCHzehkJena/5ZGNegSqn
        aPMOsWqnWZRyij7lKy9FL9G73dmfzbgD5F40qbSgVBZzG/Adey1lQWmsgjuD8Iy/hrEgNj7I
        xoOd5mQmHT8ZsjDJzBTCrjP/EMuDdE6DR653omXO4PLxQk9UthwiOascex92yJJGHYEX568m
        DIbbiBv3OxOGnCvC9fU/JZjiXsMN5w8mOJMrwX6P7b/MavzbiTFqmVO5Ldh9xZrok9xa/KT5
        FplkJb47dppI8kvYHW0iG5DCtkK3rVBsKxTbCqUFUU6UIZoMugqdIY83aHUGU3UFX67XuVD8
        P3sCC90eZJn+wIc4Fqmelf88OlumoLVmwx6dD2GWVGXI37wWLFPId2j3fC5K+u2SqUo0+FBB
        /LhGMiuzXB//9mrjdnWBWgOFak2+Jv8NUCnl33K/liq4Cq1R3CWKu0Xpf49gU7P2Iurx1jnz
        +Km0Dmf92lV/B9xfeSdKo762xWGPlLLmw9WnHZsqwp0m0fZj8cBsoPBu9NUTrcqleyVvL52y
        /1kbKX/XmC6xmyZz1aHy7G13qF187VRJpvAKk7LqvUruxcOOnmAsUhBdf+3c4DvbnukvPjqe
        fjFl/qbJN97/PH/Z6t33pYoyVGrV60jJoP0XiTnSerUDAAA=
X-CMS-MailID: 20200624094922eucas1p126f9a79810d912cf6f561c5f52153b43
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192210eucas1p10ac60083d5c2eb6f21b9bcab651b01e5
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192210eucas1p10ac60083d5c2eb6f21b9bcab651b01e5
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192210eucas1p10ac60083d5c2eb6f21b9bcab651b01e5@eucas1p1.samsung.com>
        <20200528192051.28034-7-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Prepare for making the drivers not access tzd's private members.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/thermal/thermal_core.c | 53 ++++++++++++++++++++++++++++++++++
>  include/linux/thermal.h        | 13 +++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 14d3b1b94c4f..f2a5c5ee3455 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -459,6 +459,59 @@ static void thermal_zone_device_reset(struct thermal_zone_device *tz)
>  	thermal_zone_device_init(tz);
>  }
>  
> +int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
> +				 enum thermal_device_mode mode)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&tz->lock);
> +
> +	/* do nothing if mode isn't changing */
> +	if (mode == tz->mode) {
> +		mutex_unlock(&tz->lock);
> +
> +		return ret;
> +	}
> +
> +	if (tz->ops->set_mode)
> +		ret = tz->ops->set_mode(tz, mode);
> +
> +	if (!ret)
> +		tz->mode = mode;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
> +
> +	return ret;
> +}
> +
> +int thermal_zone_device_enable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_ENABLED);
> +}
> +EXPORT_SYMBOL(thermal_zone_device_enable);
> +
> +int thermal_zone_device_disable(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
> +}
> +EXPORT_SYMBOL(thermal_zone_device_disable);
> +
> +int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
> +{
> +	enum thermal_device_mode mode;
> +
> +	mutex_lock(&tz->lock);
> +
> +	mode = tz->mode;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	return mode == THERMAL_DEVICE_ENABLED;
> +}
> +EXPORT_SYMBOL(thermal_zone_device_is_enabled);
> +
>  void thermal_zone_device_update(struct thermal_zone_device *tz,
>  				enum thermal_notify_event event)
>  {
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index a808f6fa2777..df013c39ba9b 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -416,6 +416,9 @@ int thermal_zone_get_offset(struct thermal_zone_device *tz);
>  
>  void thermal_cdev_update(struct thermal_cooling_device *);
>  void thermal_notify_framework(struct thermal_zone_device *, int);
> +int thermal_zone_device_enable(struct thermal_zone_device *tz);
> +int thermal_zone_device_disable(struct thermal_zone_device *tz);
> +int thermal_zone_device_is_enabled(struct thermal_zone_device *tz);
>  #else
>  static inline struct thermal_zone_device *thermal_zone_device_register(
>  	const char *type, int trips, int mask, void *devdata,
> @@ -463,6 +466,16 @@ static inline void thermal_cdev_update(struct thermal_cooling_device *cdev)
>  static inline void thermal_notify_framework(struct thermal_zone_device *tz,
>  	int trip)
>  { }
> +
> +static inline int thermal_zone_device_enable(struct thermal_zone_device *tz)
> +{ return -ENODEV; }
> +
> +static inline int thermal_zone_device_disable(struct thermal_zone_device *tz)
> +{ return -ENODEV; }
> +
> +static inline int
> +thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
> +{ return -ENODEV; }
>  #endif /* CONFIG_THERMAL */
>  
>  #endif /* __THERMAL_H__ */
> 
