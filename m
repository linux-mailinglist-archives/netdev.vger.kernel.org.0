Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB120D11C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgF2Sil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbgF2SiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:38:01 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA0AC02A542
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:49:02 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id z47so5267138uad.5
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/czzbe3TtUcJIflJ99q2lIskXBgVNXfpcq83W982SW4=;
        b=WeSAP/a5lZp6nQMEdDIM8axmsEfnvdtP2chd3VGBSckQwa2U21YukiLtyPPobyXRuz
         qYvGnoJy2SUKgfnYrOr3jRhoupwpMs3QX+xGwrqTeAtGDEL8iTdjC6PN+tFU5iplVnnH
         3ucRfvHL7WjJ+gtGhev0U+/hV5HrD3ymzqRKeQrv4+5ImAO6zhR9vLGZVRJQqMfrVxZw
         uToRn6fmJ1MVQd0H0L4UGrVpsm529MFKG1jOf/g8cOtAWlx/5fXAYzhwDiBp5fWyHkNG
         fKlGAU5e05jHLGweiiNV7g/5A5MRWrfBh7NP6PF2Tq8mI41CfWsoaTZ3omYxPZGLOXHS
         jCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/czzbe3TtUcJIflJ99q2lIskXBgVNXfpcq83W982SW4=;
        b=GkewiVKAsjCaxecxg0m0F4Ctmngqd2UuKq9Zpw946nfHOaWve8sobFcu/WcqNgjeR3
         OyOSRBU5ZctRzOYWM/yjNLvyBsIdGsmFiEiBc3xWrXeWU2HyAY57XRtwsBEVJNpwiMtD
         8fZ1ME5Ho7n5ArGN61k0dWWHLWh6pTEObKZmMISqlgdICmM9aMEd+GvgxJCHzOHxzcWI
         BD3uMnN9xNBM8j2A2ErqtUBjAZPnQhZ3yohpm25LWPaH7QWmxJ7p7oxUFMtoBFEFCUoc
         Z5r5v7LJRQY9BLg+u+d/x5zZZbsUHm/dGo/8gQWmbV1lzEVr+KchkPgfj2oLL8+9fJSZ
         sIqw==
X-Gm-Message-State: AOAM532d2KL6+z0HypeULaxvhm33LxPdtqGAoMRmG1cGHjuSEK3UjceO
        JH+Iu3Fyy8Dn4R95l28TOBiY/4N1D8D53Xsx9KW3EQ==
X-Google-Smtp-Source: ABdhPJykO05gG5Bb+nA0Vnr/X3v2J1XSrulYz3voXHdt/RxIAbgJ9ID8IoL5WSwYX4Qy51z7VQCupXXNmThb4Z9Upd0=
X-Received: by 2002:ab0:232:: with SMTP id 47mr10473617uas.48.1593434941649;
 Mon, 29 Jun 2020 05:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200629122925.21729-1-andrzej.p@collabora.com> <20200629122925.21729-12-andrzej.p@collabora.com>
In-Reply-To: <20200629122925.21729-12-andrzej.p@collabora.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Mon, 29 Jun 2020 18:18:50 +0530
Message-ID: <CAHLCerONdxx=x_ykO=JjpM5AB08ZX3ukhKVWgPARcS5V7q80Gw@mail.gmail.com>
Subject: Re: [PATCH v7 11/11] thermal: Rename set_mode() to change_mode()
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     Linux PM list <linux-pm@vger.kernel.org>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        lakml <linux-arm-kernel@lists.infradead.org>,
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
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kernel@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 6:00 PM Andrzej Pietrasiewicz
<andrzej.p@collabora.com> wrote:
>
> set_mode() is only called when tzd's mode is about to change. Actual
> setting is performed in thermal_core, in thermal_zone_device_set_mode().
> The meaning of set_mode() callback is actually to notify the driver about
> the mode being changed and giving the driver a chance to oppose such
> change.
>
> To better reflect the purpose of the method rename it to change_mode()
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> [for acerhdf]
> Acked-by: Peter Kaestle <peter@piie.net>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

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
> index 76323855c80c..f816a8a13039 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -413,8 +413,8 @@ static inline void acerhdf_enable_kernelmode(void)
>   *          the temperature and the fan.
>   * disabled: the BIOS takes control of the fan.
>   */
> -static int acerhdf_set_mode(struct thermal_zone_device *thermal,
> -                           enum thermal_device_mode mode)
> +static int acerhdf_change_mode(struct thermal_zone_device *thermal,
> +                              enum thermal_device_mode mode)
>  {
>         if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
>                 acerhdf_revert_to_bios_mode();
> @@ -473,7 +473,7 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
>         .bind = acerhdf_bind,
>         .unbind = acerhdf_unbind,
>         .get_temp = acerhdf_get_ec_temp,
> -       .set_mode = acerhdf_set_mode,
> +       .change_mode = acerhdf_change_mode,
>         .get_trip_type = acerhdf_get_trip_type,
>         .get_trip_hyst = acerhdf_get_trip_hyst,
>         .get_trip_temp = acerhdf_get_trip_temp,
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index a02398118d88..9700ae39feb7 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -330,8 +330,8 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>         return 0;
>  }
>
> -static int imx_set_mode(struct thermal_zone_device *tz,
> -                       enum thermal_device_mode mode)
> +static int imx_change_mode(struct thermal_zone_device *tz,
> +                          enum thermal_device_mode mode)
>  {
>         struct imx_thermal_data *data = tz->devdata;
>         struct regmap *map = data->tempmon;
> @@ -447,7 +447,7 @@ static struct thermal_zone_device_ops imx_tz_ops = {
>         .bind = imx_bind,
>         .unbind = imx_unbind,
>         .get_temp = imx_get_temp,
> -       .set_mode = imx_set_mode,
> +       .change_mode = imx_change_mode,
>         .get_trip_type = imx_get_trip_type,
>         .get_trip_temp = imx_get_trip_temp,
>         .get_crit_temp = imx_get_crit_temp,
> @@ -860,7 +860,7 @@ static int __maybe_unused imx_thermal_suspend(struct device *dev)
>          * Need to disable thermal sensor, otherwise, when thermal core
>          * try to get temperature before thermal sensor resume, a wrong
>          * temperature will be read as the thermal sensor is powered
> -        * down. This is done in set_mode() operation called from
> +        * down. This is done in change_mode() operation called from
>          * thermal_zone_device_disable()
>          */
>         ret = thermal_zone_device_disable(data->tz);
> diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> index ce49d3b100d5..d3732f624913 100644
> --- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> +++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
> @@ -377,8 +377,8 @@ static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,
>         return 0;
>  }
>
> -static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
> -                               enum thermal_device_mode mode)
> +static int int3400_thermal_change_mode(struct thermal_zone_device *thermal,
> +                                      enum thermal_device_mode mode)
>  {
>         struct int3400_thermal_priv *priv = thermal->devdata;
>         int result = 0;
> @@ -399,7 +399,7 @@ static int int3400_thermal_set_mode(struct thermal_zone_device *thermal,
>
>  static struct thermal_zone_device_ops int3400_thermal_ops = {
>         .get_temp = int3400_thermal_get_temp,
> -       .set_mode = int3400_thermal_set_mode,
> +       .change_mode = int3400_thermal_change_mode,
>  };
>
>  static struct thermal_zone_params int3400_thermal_params = {
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index e29c3e330b17..3eafc6b0e6c3 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -298,8 +298,8 @@ static int sys_get_curr_temp(struct thermal_zone_device *tzd,
>         return 0;
>  }
>
> -static int sys_set_mode(struct thermal_zone_device *tzd,
> -                               enum thermal_device_mode mode)
> +static int sys_change_mode(struct thermal_zone_device *tzd,
> +                          enum thermal_device_mode mode)
>  {
>         int ret;
>
> @@ -319,7 +319,7 @@ static struct thermal_zone_device_ops tzone_ops = {
>         .get_trip_type = sys_get_trip_type,
>         .set_trip_temp = sys_set_trip_temp,
>         .get_crit_temp = sys_get_crit_temp,
> -       .set_mode = sys_set_mode,
> +       .change_mode = sys_change_mode,
>  };
>
>  static void free_soc_dts(struct soc_sensor_entry *aux_entry)
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index e613f5c07bad..a61e91513584 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -482,8 +482,8 @@ static int thermal_zone_device_set_mode(struct thermal_zone_device *tz,
>                 return ret;
>         }
>
> -       if (tz->ops->set_mode)
> -               ret = tz->ops->set_mode(tz, mode);
> +       if (tz->ops->change_mode)
> +               ret = tz->ops->change_mode(tz, mode);
>
>         if (!ret)
>                 tz->mode = mode;
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index df013c39ba9b..b9efaa780d88 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -76,7 +76,7 @@ struct thermal_zone_device_ops {
>                        struct thermal_cooling_device *);
>         int (*get_temp) (struct thermal_zone_device *, int *);
>         int (*set_trips) (struct thermal_zone_device *, int, int);
> -       int (*set_mode) (struct thermal_zone_device *,
> +       int (*change_mode) (struct thermal_zone_device *,
>                 enum thermal_device_mode);
>         int (*get_trip_type) (struct thermal_zone_device *, int,
>                 enum thermal_trip_type *);
> --
> 2.17.1
>
