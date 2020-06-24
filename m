Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B953A207050
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389913AbgFXJrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:47:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60743 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388034AbgFXJrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:47:37 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624094733euoutp01cbdaf7612cee4c64fe035288cfab067a~bcdUk8y7M2488924889euoutp016;
        Wed, 24 Jun 2020 09:47:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624094733euoutp01cbdaf7612cee4c64fe035288cfab067a~bcdUk8y7M2488924889euoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592992053;
        bh=SCi7OgOkP1sEZIkvzZyavbs2OS6rUbE9bLl+zIWp8zQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=hN76ke70ir6av/A7W+IvJ9L60oRsO0lEWutX1TW+qAmKvHsqT5t7lU0EaJFDH7HO+
         pnVWn2HGZnfMyPkZfv8PySezfPyrIAbwoIFDLP6OCw/uIG9KBxz1AtC9c+fdgSBqiu
         T+qdTSuWq6ScLJzitDca5R40ai/MMELz9q66U/ag=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200624094733eucas1p1c5962950749e550eb169bd85107203f6~bcdUb9RRB2174121741eucas1p1D;
        Wed, 24 Jun 2020 09:47:33 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id F6.58.06318.53123FE5; Wed, 24
        Jun 2020 10:47:33 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624094732eucas1p29a041fd7d8ca2009faba1fd1703481fc~bcdT80Aaq1752517525eucas1p28;
        Wed, 24 Jun 2020 09:47:32 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200624094732eusmtrp2ca3c5519f58e523daffa186985e0a66a~bcdT7eQX42287322873eusmtrp2k;
        Wed, 24 Jun 2020 09:47:32 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-b3-5ef3213591ac
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 5A.42.06017.43123FE5; Wed, 24
        Jun 2020 10:47:32 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624094731eusmtip1883883a79820cbf734b3ff66899240c5~bcdSUoG121237212372eusmtip19;
        Wed, 24 Jun 2020 09:47:31 +0000 (GMT)
Subject: Re: [PATCH v4 05/11] thermal: remove get_mode() operation of
 drivers
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
Message-ID: <e63bdfa3-6a5a-d639-8c89-77d58a5893b9@samsung.com>
Date:   Wed, 24 Jun 2020 11:47:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-6-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTdRy+7/trL7uGL9Pa9zQ119kPJWZh1+eKOEvvfPOP7C9Pu6JWvqEX
        Q24voFaXaMiPXfwyCZgLGe5gG56t8XOISwGhbjYJk8sYHujKEQ5kIw1KaOyFi/+e5/k+n8/z
        ef74sqSyVLaS3Z+eKejTtWlqRk619Ex7n3txXThlU6COBdsPsxQ88E4TUHf7JgUnKudI+O7o
        CAHV4dVguppLgcG8CY63DNEwcn0n5IUrKZi7NRZhF7fCjaPnCTAFsuGW1SiDRu+XNNjLXRTU
        2swMuEaCDNS7SxA4bw/QYJixkRAu6kbQPDpOQGg4EnTX6pNBYWMZgq7mGgK68t009NQ8Br1f
        F9NQce8Ugr6+d6ChI0DCFU8/Df6RYgYetjopCDSpwHM+Ey4c/5mERmc5CQM1YQrqh9tlW+L5
        6rOf8r+3mWj+WnERwbcNWRDfZLtB8NaQhncZh2R8o3UDf6ZjlOCd9kKG9w10MPy41xvRLUf4
        ybt+Gf9HRRfBl94LMm/ht+VJe4W0/dmCXpP8vnyfxWyUZQzqDh1rN5M5qHWPAcWwmNuM5065
        SQOSs0rOivCVtjxCIlMI/1JWJ5NIGOH7fVXU4si1nNCCqx7hm7mWhfkgwtXGQWLetZzbibun
        bNGJFVwinm4JRleRnEGBg3fcsvkHhnsZl+Xb0TxWcMm4qKo/iiluPW5w5EcXPcrtxqHhLlry
        xOEfq/zRpTHcq7jEWhbFJKfCv/lPExJei1uDJlI69X4M/r70CQlvw2dzPQv6cvxnb5NMwo/j
        OdfpaB3MnUP4YUGAlEgrwvVfzTKS6xXs885EMBtJeBZ/266R5NdwYOwYmpcxF4t/DcZJN8Ti
        Ey0VpCQrcEGeUnI/hR11DmYx1uCykaVIbVzSzLikjXFJG+P/uTWIsiOVkCXqUgUxMV04mCBq
        dWJWemrChwd0ThT5J57Z3r/akPvfDzoRxyL1IwrH8GSKktZmi4d1nQizpHqF4vWfPClKxV7t
        4U8E/YH39FlpgtiJVrGUWqVIrB19V8mlajOFjwUhQ9AvvhJszMoclHxhj9WRFHIvu/5Z4YR9
        5o7vpZO7JpIL+BdqrzpOmmLjDm2/uFFcZdrWT/x9jh4zlVxe/WD755uXdRjHdyRcyrr8T0b8
        eLNli2rim2eaU85Y1u8YEJSa7kGvptr/UeyR8hL5xjee9uSgBt+aHjHpUnzlVv1ajwWtO9jy
        pNn0xeSaN6fUlLhP+/wGUi9q/wPGpU0BIwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUwTdxjH97u7XotZ563W8RvZMu3cpqiF8mIfDJLFLfHiYjTzH90cWOVS
        jC01vUKmZhksIvOUak2ccLIOFGcpZmJb3hGVOphWGcNJwgYLBdSqlFWabHZRWEu3hP8+z/N8
        P3nyJI+MVJylk2R7Ci2cuVBnUNELKN9M78jqjKXh3NTDXclQ/9MMBX/3RQj4fvwPCk5WzpJw
        udRPgD38JlT/fIgCoTYVyppHJOC/txkOhyspmB17Eq2ufQBDpR0EVAeKYcwhSsHdd0wCzlNt
        FJytr6WhzR+k4ULXcQSu8UEJCP/UkxCuuIGg6dEUAdOj0UWTjmEpHHHbEHibagjwlndJoKfm
        Nej9xiqB06EzCPr7d0BDZ4CE274BCUz4rTS8aHFREPAkgq/DAlfKfiHB7TpFwmBNmIILo+3S
        91ex9osH2fut1RL2rrWCYFtH6hDrqR8iWMd0CtsmjkhZtyOZPdf5iGBdziM0OzzYSbNTfX3R
        ft2X7NPJCSn74LSXYE+EgvQW/Ik622wqsnBLCky8ZZ3qUw2kqTVZoE7LyFJr0rWfrU3LVKXk
        ZOdzhj3FnDklZ6e6oK5WlO773fj5V+21ZAlq2S6gBBlmMvDdkmlCQAtkCuY8wp2e2Wghiw7e
        wL2XiuOZRfj5oEDHM08Q7oicpGKDRcwmHLD7yBgrmXQcaQ5KYyGSscpxx4OL0rhRRuDeH36d
        M2hmLbaVO1GM5UwOrqgamGOKeQc3NJYTMV7MbMPeVvG/zKv4ZtXEnJvArMPHHbY5Jpn38HP7
        ABnnRPzbxHdEnN/CLcFq8gRSiPN0cZ4izlPEeUoNopxIyRXxRr2RT1PzOiNfVKhX7zYZXSj6
        n809EU8rEqa2diNGhlQvyxtHn+YqJLpifr+xG2EZqVLK19/x5Srk+br9BzizKc9cZOD4bpQZ
        Pc5GJi3ebYp+e6ElT5Op0UKWRpuuTV8DqkT518z1HQpGr7NwezluH2f+3yNkCUklaOBZqfX8
        UeF1vC3Uvjzf9i7mN05m31u5ZOGtqknN1aEDhsph90PnuRXCtY/XjF1W27S+0CsLQ49v3jp6
        JxiZSd0ivtBvHd/1Z+DbdqFp+dIzek9jg/I+nZD69hfLPvRuWm8oO9iTVyEoG57Rf5UWbOw6
        xNz+6MZD7Lf3vxT+8bHu2AYVxRfoNMmkmdf9C1CE4GG1AwAA
X-CMS-MailID: 20200624094732eucas1p29a041fd7d8ca2009faba1fd1703481fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192201eucas1p2ce18c3d5db59b142751b26e24a146e0b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192201eucas1p2ce18c3d5db59b142751b26e24a146e0b
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192201eucas1p2ce18c3d5db59b142751b26e24a146e0b@eucas1p2.samsung.com>
        <20200528192051.28034-6-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> get_mode() is now redundant, as the state is stored in struct
> thermal_zone_device.
> 
> Consequently the "mode" attribute in sysfs can always be visible, because
> it is always possible to get the mode from struct tzd.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

The side-effect of splitting the v3 is that some devices will be
marked in sysfs as disabled (however they are in reality enabled)
after applying this patch (it gets fixed by patch #08).

I think that we can live with that so:

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/acpi/thermal.c                        |  9 ------
>  .../ethernet/mellanox/mlxsw/core_thermal.c    | 19 ------------
>  drivers/platform/x86/acerhdf.c                | 12 --------
>  drivers/thermal/da9062-thermal.c              |  8 -----
>  drivers/thermal/imx_thermal.c                 |  9 ------
>  .../intel/int340x_thermal/int3400_thermal.c   |  9 ------
>  .../thermal/intel/intel_quark_dts_thermal.c   |  8 -----
>  drivers/thermal/thermal_core.c                |  7 +----
>  drivers/thermal/thermal_of.c                  |  9 ------
>  drivers/thermal/thermal_sysfs.c               | 30 ++-----------------
>  include/linux/thermal.h                       |  2 --
>  11 files changed, 3 insertions(+), 119 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 4ba273f49d87..592be97c4456 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -525,14 +525,6 @@ static int thermal_get_temp(struct thermal_zone_device *thermal, int *temp)
>  	return 0;
>  }
>  
> -static int thermal_get_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode *mode)
> -{
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  static int thermal_set_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode mode)
>  {
> @@ -847,7 +839,6 @@ static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
>  	.bind = acpi_thermal_bind_cooling_device,
>  	.unbind	= acpi_thermal_unbind_cooling_device,
>  	.get_temp = thermal_get_temp,
> -	.get_mode = thermal_get_mode,
>  	.set_mode = thermal_set_mode,
>  	.get_trip_type = thermal_get_trip_type,
>  	.get_trip_temp = thermal_get_trip_temp,
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index aa082e8a0b13..6e26678ac312 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -275,14 +275,6 @@ static int mlxsw_thermal_unbind(struct thermal_zone_device *tzdev,
>  	return 0;
>  }
>  
> -static int mlxsw_thermal_get_mode(struct thermal_zone_device *tzdev,
> -				  enum thermal_device_mode *mode)
> -{
> -	*mode = tzdev->mode;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>  				  enum thermal_device_mode mode)
>  {
> @@ -403,7 +395,6 @@ static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_ops = {
>  	.bind = mlxsw_thermal_bind,
>  	.unbind = mlxsw_thermal_unbind,
> -	.get_mode = mlxsw_thermal_get_mode,
>  	.set_mode = mlxsw_thermal_set_mode,
>  	.get_temp = mlxsw_thermal_get_temp,
>  	.get_trip_type	= mlxsw_thermal_get_trip_type,
> @@ -462,14 +453,6 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
>  	return err;
>  }
>  
> -static int mlxsw_thermal_module_mode_get(struct thermal_zone_device *tzdev,
> -					 enum thermal_device_mode *mode)
> -{
> -	*mode = tzdev->mode;
> -
> -	return 0;
> -}
> -
>  static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>  					 enum thermal_device_mode mode)
>  {
> @@ -591,7 +574,6 @@ mlxsw_thermal_module_trip_hyst_set(struct thermal_zone_device *tzdev, int trip,
>  static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.get_mode	= mlxsw_thermal_module_mode_get,
>  	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_module_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
> @@ -630,7 +612,6 @@ static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
>  static struct thermal_zone_device_ops mlxsw_thermal_gearbox_ops = {
>  	.bind		= mlxsw_thermal_module_bind,
>  	.unbind		= mlxsw_thermal_module_unbind,
> -	.get_mode	= mlxsw_thermal_module_mode_get,
>  	.set_mode	= mlxsw_thermal_module_mode_set,
>  	.get_temp	= mlxsw_thermal_gearbox_temp_get,
>  	.get_trip_type	= mlxsw_thermal_module_trip_type_get,
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 97b288485837..32c5fe16b7f7 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -413,17 +413,6 @@ static inline void acerhdf_enable_kernelmode(void)
>  	pr_notice("kernel mode fan control ON\n");
>  }
>  
> -static int acerhdf_get_mode(struct thermal_zone_device *thermal,
> -			    enum thermal_device_mode *mode)
> -{
> -	if (verbose)
> -		pr_notice("kernel mode fan control %d\n", kernelmode);
> -
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  /*
>   * set operation mode;
>   * enabled: the thermal layer of the kernel takes care about
> @@ -490,7 +479,6 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>  	.bind = acerhdf_bind,
>  	.unbind = acerhdf_unbind,
>  	.get_temp = acerhdf_get_ec_temp,
> -	.get_mode = acerhdf_get_mode,
>  	.set_mode = acerhdf_set_mode,
>  	.get_trip_type = acerhdf_get_trip_type,
>  	.get_trip_hyst = acerhdf_get_trip_hyst,
> diff --git a/drivers/thermal/da9062-thermal.c b/drivers/thermal/da9062-thermal.c
> index a14c7981c7c7..a7ac8afb063e 100644
> --- a/drivers/thermal/da9062-thermal.c
> +++ b/drivers/thermal/da9062-thermal.c
> @@ -120,13 +120,6 @@ static irqreturn_t da9062_thermal_irq_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static int da9062_thermal_get_mode(struct thermal_zone_device *z,
> -				   enum thermal_device_mode *mode)
> -{
> -	*mode = z->mode;
> -	return 0;
> -}
> -
>  static int da9062_thermal_get_trip_type(struct thermal_zone_device *z,
>  					int trip,
>  					enum thermal_trip_type *type)
> @@ -179,7 +172,6 @@ static int da9062_thermal_get_temp(struct thermal_zone_device *z,
>  
>  static struct thermal_zone_device_ops da9062_thermal_ops = {
>  	.get_temp	= da9062_thermal_get_temp,
> -	.get_mode	= da9062_thermal_get_mode,
>  	.get_trip_type	= da9062_thermal_get_trip_type,
>  	.get_trip_temp	= da9062_thermal_get_trip_temp,
>  };
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 9a1114d721b6..2c7ee5da608a 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -330,14 +330,6 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	return 0;
>  }
>  
> -static int imx_get_mode(struct thermal_zone_device *tz,
> -			enum thermal_device_mode *mode)
> -{
> -	*mode = tz->mode;
> -
> -	return 0;
> -}
> -
>  static int imx_set_mode(struct thermal_zone_device *tz,
>  			enum thermal_device_mode mode)
>  {
> @@ -464,7 +456,6 @@ static struct thermal_zone_device_ops imx_tz_ops = {
>  	.bind = imx_bind,
>  	.unbind = imx_unbind,
>  	.get_temp = imx_get_temp,
> -	.get_mode = imx_get_mode,
>  	.set_mode = imx_set_mode,
>  	.get_trip_type = imx_get_trip_type,
>  	.get_trip_temp = imx_get_trip_temp,
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index f65b2fc09198..9a622aaf29dd 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -377,14 +377,6 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int int3400_thermal_get_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode *mode)
> -{
> -	*mode = thermal->mode;
> -
> -	return 0;
> -}
> -
>  static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  				enum thermal_device_mode mode)
>  {
> @@ -412,7 +404,6 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>  	.get_temp = int3400_thermal_get_temp,
> -	.get_mode = int3400_thermal_get_mode,
>  	.set_mode = int3400_thermal_set_mode,
>  };
>  
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index d77cb3df5ade..c4879b4bfbf1 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -308,13 +308,6 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>  	return 0;
>  }
>  
> -static int sys_get_mode(struct thermal_zone_device *tzd,
> -				enum thermal_device_mode *mode)
> -{
> -	*mode = tzd->mode;
> -	return 0;
> -}
> -
>  static int sys_set_mode(struct thermal_zone_device *tzd,
>  				enum thermal_device_mode mode)
>  {
> @@ -336,7 +329,6 @@ static struct thermal_zone_device_ops tzone_ops = {
>  	.get_trip_type = sys_get_trip_type,
>  	.set_trip_temp = sys_set_trip_temp,
>  	.get_crit_temp = sys_get_crit_temp,
> -	.get_mode = sys_get_mode,
>  	.set_mode = sys_set_mode,
>  };
>  
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index b71196eaf90e..14d3b1b94c4f 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1456,7 +1456,6 @@ static int thermal_pm_notify(struct notifier_block *nb,
>  			     unsigned long mode, void *_unused)
>  {
>  	struct thermal_zone_device *tz;
> -	enum thermal_device_mode tz_mode;
>  
>  	switch (mode) {
>  	case PM_HIBERNATION_PREPARE:
> @@ -1469,11 +1468,7 @@ static int thermal_pm_notify(struct notifier_block *nb,
>  	case PM_POST_SUSPEND:
>  		atomic_set(&in_suspend, 0);
>  		list_for_each_entry(tz, &thermal_tz_list, node) {
> -			tz_mode = THERMAL_DEVICE_ENABLED;
> -			if (tz->ops->get_mode)
> -				tz->ops->get_mode(tz, &tz_mode);
> -
> -			if (tz_mode == THERMAL_DEVICE_DISABLED)
> +			if (tz->mode == THERMAL_DEVICE_DISABLED)
>  				continue;
>  
>  			thermal_zone_device_init(tz);
> diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
> index c495b1e48ef2..ba65d48a48cb 100644
> --- a/drivers/thermal/thermal_of.c
> +++ b/drivers/thermal/thermal_of.c
> @@ -267,14 +267,6 @@ static int of_thermal_unbind(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int of_thermal_get_mode(struct thermal_zone_device *tz,
> -			       enum thermal_device_mode *mode)
> -{
> -	*mode = tz->mode;
> -
> -	return 0;
> -}
> -
>  static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  			       enum thermal_device_mode mode)
>  {
> @@ -389,7 +381,6 @@ static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>  }
>  
>  static struct thermal_zone_device_ops of_thermal_ops = {
> -	.get_mode = of_thermal_get_mode,
>  	.set_mode = of_thermal_set_mode,
>  
>  	.get_trip_type = of_thermal_get_trip_type,
> diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
> index aa99edb4dff7..096370977068 100644
> --- a/drivers/thermal/thermal_sysfs.c
> +++ b/drivers/thermal/thermal_sysfs.c
> @@ -49,18 +49,9 @@ static ssize_t
>  mode_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
>  	struct thermal_zone_device *tz = to_thermal_zone(dev);
> -	enum thermal_device_mode mode;
> -	int result;
> -
> -	if (!tz->ops->get_mode)
> -		return -EPERM;
>  
> -	result = tz->ops->get_mode(tz, &mode);
> -	if (result)
> -		return result;
> -
> -	return sprintf(buf, "%s\n", mode == THERMAL_DEVICE_ENABLED ? "enabled"
> -		       : "disabled");
> +	return sprintf(buf, "%s\n", tz->mode == THERMAL_DEVICE_ENABLED ?
> +		       "enabled" : "disabled");
>  }
>  
>  static ssize_t
> @@ -428,30 +419,13 @@ static struct attribute_group thermal_zone_attribute_group = {
>  	.attrs = thermal_zone_dev_attrs,
>  };
>  
> -/* We expose mode only if .get_mode is present */
>  static struct attribute *thermal_zone_mode_attrs[] = {
>  	&dev_attr_mode.attr,
>  	NULL,
>  };
>  
> -static umode_t thermal_zone_mode_is_visible(struct kobject *kobj,
> -					    struct attribute *attr,
> -					    int attrno)
> -{
> -	struct device *dev = container_of(kobj, struct device, kobj);
> -	struct thermal_zone_device *tz;
> -
> -	tz = container_of(dev, struct thermal_zone_device, device);
> -
> -	if (tz->ops->get_mode)
> -		return attr->mode;
> -
> -	return 0;
> -}
> -
>  static struct attribute_group thermal_zone_mode_attribute_group = {
>  	.attrs = thermal_zone_mode_attrs,
> -	.is_visible = thermal_zone_mode_is_visible,
>  };
>  
>  /* We expose passive only if passive trips are present */
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 5f91d7f04512..a808f6fa2777 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -76,8 +76,6 @@ struct thermal_zone_device_ops {
>  		       struct thermal_cooling_device *);
>  	int (*get_temp) (struct thermal_zone_device *, int *);
>  	int (*set_trips) (struct thermal_zone_device *, int, int);
> -	int (*get_mode) (struct thermal_zone_device *,
> -			 enum thermal_device_mode *);
>  	int (*set_mode) (struct thermal_zone_device *,
>  		enum thermal_device_mode);
>  	int (*get_trip_type) (struct thermal_zone_device *, int,
> 
