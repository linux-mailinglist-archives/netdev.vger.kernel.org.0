Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6CE2070AA
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390186AbgFXKEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:04:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50906 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388197AbgFXKED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:04:03 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200624100400euoutp02efbe212c7625fa3ef224ba67113842b0~bcrru94J01739917399euoutp02R;
        Wed, 24 Jun 2020 10:04:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200624100400euoutp02efbe212c7625fa3ef224ba67113842b0~bcrru94J01739917399euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592993040;
        bh=x28XJaNHZxQVxcL4Wn22oniw71HYXJqZZv5azmGoJ4A=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=teC/SM1Y+qD1vNYF0muvXLdnRHpdAK9DAUV/GVK0ia3IDPlq8mj79sSZxadQOcd64
         TJCSvbVNDdZhRHNoyD11b2j78+cUhlWFaQ+bJyyrjqhQ04+QsVueVzauVDvTfc1C9/
         Iq/qKww6ncHNUckrUqWNskFFxYEsIpbF9ZQzen3M=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624100400eucas1p2e63a6f9bc7d6205da7a1d0b7ccde6a65~bcrrm9sH22810428104eucas1p2-;
        Wed, 24 Jun 2020 10:04:00 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 60.3B.06318.01523FE5; Wed, 24
        Jun 2020 11:04:00 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200624100359eucas1p11fce999e6ec162a0c4c6d75105da9bb5~bcrrG497K0287202872eucas1p10;
        Wed, 24 Jun 2020 10:03:59 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624100359eusmtrp173bf6b58c385e61c243d2417fa07f42e~bcrrFiSjw0807908079eusmtrp1k;
        Wed, 24 Jun 2020 10:03:59 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-75-5ef32510fa9b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 77.16.06314.F0523FE5; Wed, 24
        Jun 2020 11:03:59 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200624100357eusmtip232055ede9ee675a927c2cd423f11fa3a~bcrpYFrUl3158931589eusmtip2W;
        Wed, 24 Jun 2020 10:03:57 +0000 (GMT)
Subject: Re: [PATCH v4 11/11] thermal: Rename set_mode() to change_mode()
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
Message-ID: <8b6b90f6-aedc-57fe-8c39-908611b84374@samsung.com>
Date:   Wed, 24 Jun 2020 12:03:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-12-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0yTZxjd+13bzuJncfaN7JI0gQQjoOm2PHGLwbnEb8kuLkuWZXFsHX4D
        M6jaAs7tB5ippR2XonPF2mlRRi8ujrVIQVnj6CZuHVVEKy5Ui8DWMmqQThfIhNF+mPHvnPOc
        53Le5JWQCjO7WrJDWyHotJoyFSOjOi/OXM7jspNF6xo9MnBdmqPgn9AMAW2jtyg41DxPwvf7
        Rgg4nnwKbJf3U2BqWQcHOiM0jFx/Aw4mmymYv/PXAruwGW7uO0+ALVYFd5xWFryhOhrcR7op
        OOlqYaB7JMGAw9+IwDMapsE06yIhWf8TgrPxuwRMRxcWTTqHWTB6mxAEztoJCBj8NFy0r4K+
        rxposEwdQ3DlyjY43RMj4bfgVRrGRhoYeOjzUBDrUELwfAX8cGCABK/nCAlhe5ICR/QcW7iW
        P/7tZ/x4l43mBxvqCb4r0or4DtdNgndOF/Dd1gjLe51r+FM9cYL3uI0MPxzuYfi7odCC3lrN
        35scY/k/LAGCN08lmK34XdmL24WyHVWCrmDjB7LScb8B7brw/CcPbkdQDbq01oSkEsw9iwPG
        ftqEZBIF50T4hN3MiuRvhKPuFkokSYTbBgKMCUnSLUFLjqg7EI4N+EiRJBC+b7EQqbmZ3Cv4
        +pfXyBReyanxTGciPZbkTHKc+NPPpgoMtwE3GdwoheXcRuwaupXGFJeNZz8/mh70BPcOno4G
        aNGzAv9ydIxKYemCf2qyP+0nOSX+fewEIeJnsC9hS1+EuQdSfCNsY8WkL+O4t44UcSae6OtY
        1J/EwcN1lNhwBuGHtbHFbh/CjsNzjOh6AQ+HZtMPQHK5+LtzBaK8Cbv9baT4Lhl4KLFCPCID
        H+q0LMpyXHtQIbpzcHtbO/NoranbRZqRyrokmnVJHOuSONb/99oR5UZKoVJfXiLo1VphT75e
        U66v1JbkF+8s96CFfxKc67vfhfz/ftiLOAlSLZO3R+8VKWhNlX5veS/CElK1Uv5Sf7BIId+u
        2fupoNv5vq6yTND3oiwJpVLK1Sfj7ym4Ek2F8LEg7BJ0j6qERLq6Bh1TWiN5o69mNTVv0sSW
        523z8jPF3xRG5t+ce22wd5mMsLQ2Lt+fZZwqLH46/hbFC/kTrRtszlUZQ1HyRgZrXp99e/Dx
        4Pjmhpxq9bXHTk1s+ahGt6fa8XNt7pYvwi01b+9OnJFL6yt2v46MpbnV40lfpu25nquGX7WG
        +dPqH+Vf61SUvlSzfg2p02v+A1Y3U3YjBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxiG856vFmbnWQV5Q9jmDlEy4woHRB6Iss9kx18aTeYyKtrACThp
        S3oKmy5mkKmMRhjdxtDaYGEiLTNjtIowPuZAxa3YCROiTr60KERKWps4a5yshS3h3/Xc73Xn
        yZs8clJpY+Ll+3RG0aDTFHFMNOV+PjD+xsq1wdyUU7McOK4+p+BvT4iAM/fGKfj6+AIJbeVT
        BNQHXwbrH4cpMDWkwJH2MRqmRrbB0eBxChbuPgxPF9+FW+VdBFhnSuGu3SIDl+cYDS21nRQ0
        OhoY6JzyMdDc+xUC571RGkxPHSQEqy4hOD87T8CjyfCiOfsdGVS6zAj6z9sI6K/opeGKbTUM
        fFdNQ53/JILr19XwQ/cMCYPuYRq8U9UM/HPBScHMuThwdxmh58gQCS5nLQmjtiAFzZM/y97a
        INSf/UyY7rDSwp/VVYTQMXYaCecctwjB/ihZ6LSMyQSXfb3wffcsIThbKhnhzmg3I8x7POH8
        9OdCYM4rE+7X9RNCjd/HbMcfqTYb9CVGcU2hXjJu4XJ4SFXxmaBK3Zip4tMydmelpnPJ2Zvz
        xaJ9paIhOXuvqnC6twIVX9z06eOJMVSGrm4wIbkcsxuxu26dCUXJlWwTwk/61EtxAh5oLY3E
        mF2Fn42aGBOKDisPEZ5rqmQiD6vYrXjk2xtkhGPYNBxq98kiEslWK3DX/bOypcZRAlvt5UTE
        YtgsbK5oQRFWsNnYcXN8kSl2LX76xYlFJ5b9EPd3WP5zXsK/nfBSEY4K+/65a4s5ySbhZ/XD
        5BLH4dveU8QSv4ov+KxkDVJaltUtyyqWZRXLsooNUS0oRiyRtAVaiVdJGq1UoitQ5em1ThS+
        zvYrIVcHGm7b2YdYOeJWKH6aDOQqaU2pdEDbh7Cc5GIU71xz5yoV+ZoDB0WDfo+hpEiU+lB6
        +HNmMj42Tx++dZ1xD5/OZ0Amn5GWkbYJuDjFl+yvaiVboDGK+0WxWDT83yPkUfFl6GTTGr8l
        +pPWB4GD6ssTk4+PzTde8vx+KIk7PH3TH5uQ0pb0Sk40k39opc9L0VXfNCX63xysUbdGvXh5
        d1XOil0J0ztf32JL/PEMl/dxrXnI/MLWhbId2RNSqCfwZCRpiC/2F5g+cO1vCL3d7H7vr9f2
        Zr2f2Ng+2FNc9oD9RRcMrJ7gKKlQw68nDZLmX5ggZXazAwAA
X-CMS-MailID: 20200624100359eucas1p11fce999e6ec162a0c4c6d75105da9bb5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192221eucas1p27b0efc3d6f2804c48ca5158bdb4130d6
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192221eucas1p27b0efc3d6f2804c48ca5158bdb4130d6
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192221eucas1p27b0efc3d6f2804c48ca5158bdb4130d6@eucas1p2.samsung.com>
        <20200528192051.28034-12-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> set_mode() is only called when tzd's mode is about to change. Actual
> setting is performed in thermal_core, in thermal_zone_device_set_mode().
> The meaning of set_mode() callback is actually to notify the driver about
> the mode being changed and giving the driver a chance to oppose such
> change.
> 
> To better reflect the purpose of the method rename it to change_mode()
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/platform/x86/acerhdf.c                          | 6 +++---
>  drivers/thermal/imx_thermal.c                           | 8 ++++----
>  drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 6 +++---
>  drivers/thermal/intel/intel_quark_dts_thermal.c         | 6 +++---
>  drivers/thermal/thermal_core.c                          | 4 ++--
>  include/linux/thermal.h                                 | 2 +-
>  6 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index d33a70af0869..63b562e06d5c 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -413,8 +413,8 @@ static inline void acerhdf_enable_kernelmode(void)
>   *          the temperature and the fan.
>   * disabled: the BIOS takes control of the fan.
>   */
> -static int acerhdf_set_mode(struct thermal_zone_device *thermal,
> -			    enum thermal_device_mode mode)
> +static int acerhdf_change_mode(struct thermal_zone_device *thermal,
> +			       enum thermal_device_mode mode)
>  {
>  	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
>  		acerhdf_revert_to_bios_mode();
> @@ -473,7 +473,7 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>  	.bind = acerhdf_bind,
>  	.unbind = acerhdf_unbind,
>  	.get_temp = acerhdf_get_ec_temp,
> -	.set_mode = acerhdf_set_mode,
> +	.change_mode = acerhdf_change_mode,
>  	.get_trip_type = acerhdf_get_trip_type,
>  	.get_trip_hyst = acerhdf_get_trip_hyst,
>  	.get_trip_temp = acerhdf_get_trip_temp,
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index a02398118d88..9700ae39feb7 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -330,8 +330,8 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	return 0;
>  }
>  
> -static int imx_set_mode(struct thermal_zone_device *tz,
> -			enum thermal_device_mode mode)
> +static int imx_change_mode(struct thermal_zone_device *tz,
> +			   enum thermal_device_mode mode)
>  {
>  	struct imx_thermal_data *data = tz->devdata;
>  	struct regmap *map = data->tempmon;
> @@ -447,7 +447,7 @@ static struct thermal_zone_device_ops imx_tz_ops = {
>  	.bind = imx_bind,
>  	.unbind = imx_unbind,
>  	.get_temp = imx_get_temp,
> -	.set_mode = imx_set_mode,
> +	.change_mode = imx_change_mode,
>  	.get_trip_type = imx_get_trip_type,
>  	.get_trip_temp = imx_get_trip_temp,
>  	.get_crit_temp = imx_get_crit_temp,
> @@ -860,7 +860,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
>  	 * Need to disable thermal sensor, otherwise, when thermal core
>  	 * try to get temperature before thermal sensor resume, a wrong
>  	 * temperature will be read as the thermal sensor is powered
> -	 * down. This is done in set_mode() operation called from
> +	 * down. This is done in change_mode() operation called from
>  	 * thermal_zone_device_disable()
>  	 */
>  	ret = thermal_zone_device_disable(data->tz);
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index 9af862ab9f65..58870d215471 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -377,8 +377,8 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>  	return 0;
>  }
>  
> -static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
> -				enum thermal_device_mode mode)
> +static int int3400_thermal_change_mode(struct thermal_zone_device *thermal,
> +				       enum thermal_device_mode mode)
>  {
>  	struct int3400_thermal_priv *priv = thermal->devdata;
>  	int result = 0;
> @@ -399,7 +399,7 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>  
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>  	.get_temp = int3400_thermal_get_temp,
> -	.set_mode = int3400_thermal_set_mode,
> +	.change_mode = int3400_thermal_change_mode,
>  };
>  
>  static struct thermal_zone_params int3400_thermal_params = {
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index e29c3e330b17..3eafc6b0e6c3 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -298,8 +298,8 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>  	return 0;
>  }
>  
> -static int sys_set_mode(struct thermal_zone_device *tzd,
> -				enum thermal_device_mode mode)
> +static int sys_change_mode(struct thermal_zone_device *tzd,
> +			   enum thermal_device_mode mode)
>  {
>  	int ret;
>  
> @@ -319,7 +319,7 @@ static struct thermal_zone_device_ops tzone_ops = {
>  	.get_trip_type = sys_get_trip_type,
>  	.set_trip_temp = sys_set_trip_temp,
>  	.get_crit_temp = sys_get_crit_temp,
> -	.set_mode = sys_set_mode,
> +	.change_mode = sys_change_mode,
>  };
>  
>  static void free_soc_dts(struct soc_sensor_entry *aux_entry)
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index e9c0b990e4a9..c00edae7839e 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -482,8 +482,8 @@ int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
>  		return ret;
>  	}
>  
> -	if (tz->ops->set_mode)
> -		ret = tz->ops->set_mode(tz, mode);
> +	if (tz->ops->change_mode)
> +		ret = tz->ops->change_mode(tz, mode);
>  
>  	if (!ret)
>  		tz->mode = mode;
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index df013c39ba9b..b9efaa780d88 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -76,7 +76,7 @@ struct thermal_zone_device_ops {
>  		       struct thermal_cooling_device *);
>  	int (*get_temp) (struct thermal_zone_device *, int *);
>  	int (*set_trips) (struct thermal_zone_device *, int, int);
> -	int (*set_mode) (struct thermal_zone_device *,
> +	int (*change_mode) (struct thermal_zone_device *,
>  		enum thermal_device_mode);
>  	int (*get_trip_type) (struct thermal_zone_device *, int,
>  		enum thermal_trip_type *);
> 
