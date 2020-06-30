Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6320ED26
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgF3FIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728444AbgF3FIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:08:11 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411C3C03E97B
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 22:08:11 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id g22so73266vke.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 22:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HiecufVTiEjOfo/YHcow5WgExinvPEroQaoEf3MmndY=;
        b=Lr2pHMkEu39c/kfeHzuatr6eZAI4j9ZdxptYHISRg5Eh2WH9+3IF2NKMMTm4H/9yVC
         t8RL72pfvAAL3kYe+FHjfpo3ARELLKqLaUrqn3SqgebiTgvHLvaeOZcIK4Civp57p1i3
         wgEZg8CN2UVsvNi/6sYKNX4oawpo4MB7YVy+q7u8haFR25zGpWj1xvg59Ufkbr+Z8k5E
         YFhvQjJxBNUlRqRaeY8CLd4zVGTEpy2ptu3FBFCIQVT1UXWvB8WenDOvwRAc4nwI0SRr
         bIoBmhkLQTiBGcBPaz8QFRCCU7qLfMvKdxQWV1QWWDSZ3B6pKeLU5EnihwMffppil0pr
         f1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HiecufVTiEjOfo/YHcow5WgExinvPEroQaoEf3MmndY=;
        b=AiGRXQGHz2sifGttPw3jvT47hA+UjbHWH8nIuhgBmcTqP/RnQZ0DcmNBTo33yzz6nc
         U3IHdfXRn4uC+B5bBlv/tFkEi/WbqZGa16zjVyoyVfzlajmkNNB1zBi5VD9bokE6A4BZ
         AeSVJ3pa71KKu1GMRoXwliq5ARJyZvS4ASDHIphcvdvCMGol2pVDWYrnRgRIZURkTf2p
         k0+2UkjFuxy7LVoRf3+Ikfo61DIydOLJaJkzPREehGQvwJKglNpmbL4CBHaxTKEYkuED
         et42tGChw9XUHOkdXAEPGJs9PeBI3DiCoMSldguHIaePMCOnUgOdYfu7CGIPT1OF8F5H
         PBiQ==
X-Gm-Message-State: AOAM532ePWSCF8Gdunzlfwi3hX7a9Fa0a4+0NUcJFdNnAAwgAlGWwjZ0
        Wa+D639ui/OgIv+ORTgIgK9F0Iu3DfnEDYymF7MKIQ==
X-Google-Smtp-Source: ABdhPJxO+cstx9z+jGKxT0HzDYpm5WXp00sfrhanyuT0fPwKT3gZlJRtmAWrNKAj+ujbX7PSNvT1giMzEkoD6jC2TxU=
X-Received: by 2002:a1f:1f04:: with SMTP id f4mr12481194vkf.73.1593493690261;
 Mon, 29 Jun 2020 22:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200629122925.21729-1-andrzej.p@collabora.com> <20200629122925.21729-9-andrzej.p@collabora.com>
In-Reply-To: <20200629122925.21729-9-andrzej.p@collabora.com>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Tue, 30 Jun 2020 10:37:59 +0530
Message-ID: <CAHLCerPdEX8QxmahJPSnPp6sSh3G07Ur-+82+5QuozO26W58RQ@mail.gmail.com>
Subject: Re: [PATCH v7 08/11] thermal: Explicitly enable non-changing thermal
 zone devices
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

On Mon, Jun 29, 2020 at 5:59 PM Andrzej Pietrasiewicz
<andrzej.p@collabora.com> wrote:
>
> Some thermal zone devices never change their state, so they should be
> always enabled.
>
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>

> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c       | 8 ++++++++
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c              | 9 ++++++++-
>  drivers/platform/x86/intel_mid_thermal.c                 | 6 ++++++
>  drivers/power/supply/power_supply_core.c                 | 9 +++++++--
>  drivers/thermal/armada_thermal.c                         | 6 ++++++
>  drivers/thermal/dove_thermal.c                           | 6 ++++++
>  .../thermal/intel/int340x_thermal/int340x_thermal_zone.c | 5 +++++
>  drivers/thermal/intel/intel_pch_thermal.c                | 5 +++++
>  drivers/thermal/intel/intel_soc_dts_iosf.c               | 3 +++
>  drivers/thermal/intel/x86_pkg_temp_thermal.c             | 6 ++++++
>  drivers/thermal/kirkwood_thermal.c                       | 7 +++++++
>  drivers/thermal/rcar_thermal.c                           | 9 ++++++++-
>  drivers/thermal/spear_thermal.c                          | 7 +++++++
>  drivers/thermal/st/st_thermal.c                          | 5 +++++
>  14 files changed, 87 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
> index 3de8a5e83b6c..e3510e9b21f3 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
> @@ -92,6 +92,14 @@ int cxgb4_thermal_init(struct adapter *adap)
>                 ch_thermal->tzdev = NULL;
>                 return ret;
>         }
> +
> +       ret = thermal_zone_device_enable(ch_thermal->tzdev);
> +       if (ret) {
> +               dev_err(adap->pdev_dev, "Failed to enable thermal zone\n");
> +               thermal_zone_device_unregister(adap->ch_thermal.tzdev);
> +               return ret;
> +       }
> +
>         return 0;
>  }
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
> index 418e59b7c671..0c95663bf9ed 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
> @@ -733,7 +733,7 @@ static  struct thermal_zone_device_ops tzone_ops = {
>
>  static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
>  {
> -       int i;
> +       int i, ret;
>         char name[16];
>         static atomic_t counter = ATOMIC_INIT(0);
>
> @@ -759,6 +759,13 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
>                 return;
>         }
>
> +       ret = thermal_zone_device_enable(mvm->tz_device.tzone);
> +       if (ret) {
> +               IWL_DEBUG_TEMP(mvm, "Failed to enable thermal zone\n");
> +               thermal_zone_device_unregister(mvm->tz_device.tzone);
> +               return;
> +       }
> +
>         /* 0 is a valid temperature,
>          * so initialize the array with S16_MIN which invalid temperature
>          */
> diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
> index f402e2e74a38..f12f4e7bd971 100644
> --- a/drivers/platform/x86/intel_mid_thermal.c
> +++ b/drivers/platform/x86/intel_mid_thermal.c
> @@ -493,6 +493,12 @@ static int mid_thermal_probe(struct platform_device *pdev)
>                         ret = PTR_ERR(pinfo->tzd[i]);
>                         goto err;
>                 }
> +               ret = thermal_zone_device_enable(pinfo->tzd[i]);
> +               if (ret) {
> +                       kfree(td_info);
> +                       thermal_zone_device_unregister(pinfo->tzd[i]);
> +                       goto err;
> +               }
>         }
>
>         pinfo->pdev = pdev;
> diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
> index 02b37fe6061c..90e56736d479 100644
> --- a/drivers/power/supply/power_supply_core.c
> +++ b/drivers/power/supply/power_supply_core.c
> @@ -939,7 +939,7 @@ static struct thermal_zone_device_ops psy_tzd_ops = {
>
>  static int psy_register_thermal(struct power_supply *psy)
>  {
> -       int i;
> +       int i, ret;
>
>         if (psy->desc->no_thermal)
>                 return 0;
> @@ -949,7 +949,12 @@ static int psy_register_thermal(struct power_supply *psy)
>                 if (psy->desc->properties[i] == POWER_SUPPLY_PROP_TEMP) {
>                         psy->tzd = thermal_zone_device_register(psy->desc->name,
>                                         0, 0, psy, &psy_tzd_ops, NULL, 0, 0);
> -                       return PTR_ERR_OR_ZERO(psy->tzd);
> +                       if (IS_ERR(psy->tzd))
> +                               return PTR_ERR(psy->tzd);
> +                       ret = thermal_zone_device_enable(psy->tzd);
> +                       if (ret)
> +                               thermal_zone_device_unregister(psy->tzd);
> +                       return ret;
>                 }
>         }
>         return 0;
> diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada_thermal.c
> index 7c447cd149e7..c2ebfb5be4b3 100644
> --- a/drivers/thermal/armada_thermal.c
> +++ b/drivers/thermal/armada_thermal.c
> @@ -874,6 +874,12 @@ static int armada_thermal_probe(struct platform_device *pdev)
>                         return PTR_ERR(tz);
>                 }
>
> +               ret = thermal_zone_device_enable(tz);
> +               if (ret) {
> +                       thermal_zone_device_unregister(tz);
> +                       return ret;
> +               }
> +
>                 drvdata->type = LEGACY;
>                 drvdata->data.tz = tz;
>                 platform_set_drvdata(pdev, drvdata);
> diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_thermal.c
> index 75901ced4a62..73182eb94bc0 100644
> --- a/drivers/thermal/dove_thermal.c
> +++ b/drivers/thermal/dove_thermal.c
> @@ -153,6 +153,12 @@ static int dove_thermal_probe(struct platform_device *pdev)
>                 return PTR_ERR(thermal);
>         }
>
> +       ret = thermal_zone_device_enable(thermal);
> +       if (ret) {
> +               thermal_zone_device_unregister(thermal);
> +               return ret;
> +       }
> +
>         platform_set_drvdata(pdev, thermal);
>
>         return 0;
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> index 432213272f1e..6e479deff76b 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> @@ -259,9 +259,14 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
>                 ret = PTR_ERR(int34x_thermal_zone->zone);
>                 goto err_thermal_zone;
>         }
> +       ret = thermal_zone_device_enable(int34x_thermal_zone->zone);
> +       if (ret)
> +               goto err_enable;
>
>         return int34x_thermal_zone;
>
> +err_enable:
> +       thermal_zone_device_unregister(int34x_thermal_zone->zone);
>  err_thermal_zone:
>         acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
>         kfree(int34x_thermal_zone->aux_trips);
> diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
> index 56401fd4708d..65702094f3d3 100644
> --- a/drivers/thermal/intel/intel_pch_thermal.c
> +++ b/drivers/thermal/intel/intel_pch_thermal.c
> @@ -352,9 +352,14 @@ static int intel_pch_thermal_probe(struct pci_dev *pdev,
>                 err = PTR_ERR(ptd->tzd);
>                 goto error_cleanup;
>         }
> +       err = thermal_zone_device_enable(ptd->tzd);
> +       if (err)
> +               goto err_unregister;
>
>         return 0;
>
> +err_unregister:
> +       thermal_zone_device_unregister(ptd->tzd);
>  error_cleanup:
>         iounmap(ptd->hw_base);
>  error_release:
> diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
> index f75271b669c6..4f1a2f7c016c 100644
> --- a/drivers/thermal/intel/intel_soc_dts_iosf.c
> +++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
> @@ -329,6 +329,9 @@ static int add_dts_thermal_zone(int id, struct intel_soc_dts_sensor_entry *dts,
>                 ret = PTR_ERR(dts->tzone);
>                 goto err_ret;
>         }
> +       ret = thermal_zone_device_enable(dts->tzone);
> +       if (ret)
> +               goto err_enable;
>
>         ret = soc_dts_enable(id);
>         if (ret)
> diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> index a006b9fd1d72..b81c33202f41 100644
> --- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> +++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> @@ -363,6 +363,12 @@ static int pkg_temp_thermal_device_add(unsigned int cpu)
>                 kfree(zonedev);
>                 return err;
>         }
> +       err = thermal_zone_device_enable(zonedev->tzone);
> +       if (err) {
> +               thermal_zone_device_unregister(zonedev->tzone);
> +               kfree(zonedev);
> +               return err;
> +       }
>         /* Store MSR value for package thermal interrupt, to restore at exit */
>         rdmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, zonedev->msr_pkg_therm_low,
>               zonedev->msr_pkg_therm_high);
> diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
> index 189b675cf14d..7fb6e476c82a 100644
> --- a/drivers/thermal/kirkwood_thermal.c
> +++ b/drivers/thermal/kirkwood_thermal.c
> @@ -65,6 +65,7 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
>         struct thermal_zone_device *thermal = NULL;
>         struct kirkwood_thermal_priv *priv;
>         struct resource *res;
> +       int ret;
>
>         priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>         if (!priv)
> @@ -82,6 +83,12 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
>                         "Failed to register thermal zone device\n");
>                 return PTR_ERR(thermal);
>         }
> +       ret = thermal_zone_device_enable(thermal);
> +       if (ret) {
> +               thermal_zone_device_unregister(thermal);
> +               dev_err(&pdev->dev, "Failed to enable thermal zone device\n");
> +               return ret;
> +       }
>
>         platform_set_drvdata(pdev, thermal);
>
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index 46aeb28b4e90..787710bb88fe 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -550,12 +550,19 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>                         priv->zone = devm_thermal_zone_of_sensor_register(
>                                                 dev, i, priv,
>                                                 &rcar_thermal_zone_of_ops);
> -               else
> +               else {
>                         priv->zone = thermal_zone_device_register(
>                                                 "rcar_thermal",
>                                                 1, 0, priv,
>                                                 &rcar_thermal_zone_ops, NULL, 0,
>                                                 idle);
> +
> +                       ret = thermal_zone_device_enable(priv->zone);
> +                       if (ret) {
> +                               thermal_zone_device_unregister(priv->zone);
> +                               priv->zone = ERR_PTR(ret);
> +                       }
> +               }
>                 if (IS_ERR(priv->zone)) {
>                         dev_err(dev, "can't register thermal zone\n");
>                         ret = PTR_ERR(priv->zone);
> diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
> index f68f581fd669..ee33ed692e4f 100644
> --- a/drivers/thermal/spear_thermal.c
> +++ b/drivers/thermal/spear_thermal.c
> @@ -131,6 +131,11 @@ static int spear_thermal_probe(struct platform_device *pdev)
>                 ret = PTR_ERR(spear_thermal);
>                 goto disable_clk;
>         }
> +       ret = thermal_zone_device_enable(spear_thermal);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Cannot enable thermal zone\n");
> +               goto unregister_tzd;
> +       }
>
>         platform_set_drvdata(pdev, spear_thermal);
>
> @@ -139,6 +144,8 @@ static int spear_thermal_probe(struct platform_device *pdev)
>
>         return 0;
>
> +unregister_tzd:
> +       thermal_zone_device_unregister(spear_thermal);
>  disable_clk:
>         clk_disable(stdev->clk);
>
> diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
> index b928ca6a289b..1276b95604fe 100644
> --- a/drivers/thermal/st/st_thermal.c
> +++ b/drivers/thermal/st/st_thermal.c
> @@ -246,11 +246,16 @@ int st_thermal_register(struct platform_device *pdev,
>                 ret = PTR_ERR(sensor->thermal_dev);
>                 goto sensor_off;
>         }
> +       ret = thermal_zone_device_enable(sensor->thermal_dev);
> +       if (ret)
> +               goto tzd_unregister;
>
>         platform_set_drvdata(pdev, sensor);
>
>         return 0;
>
> +tzd_unregister:
> +       thermal_zone_device_unregister(sensor->thermal_dev);
>  sensor_off:
>         st_thermal_sensor_off(sensor);
>
> --
> 2.17.1
>
