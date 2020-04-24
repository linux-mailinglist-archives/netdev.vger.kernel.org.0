Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC9A1B7035
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgDXJEB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Apr 2020 05:04:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:33393 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgDXJEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 05:04:01 -0400
IronPort-SDR: qIAIfFNtAjFsuldYT5wCSBposeGCOkoytbul3mroTiEFVlr6vZ1Ufz6GJJhG16jXzFIEYvIAYS
 dxYiIB/ZmSrw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 02:04:00 -0700
IronPort-SDR: 3SAvLIk0KN+WtdbnyIlIpHsSgCNHuLoEG5MFe0W5WEAli89MdmWowTPM+6iGENS1KWttUGvrO2
 w6jCqjReSCYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="366287367"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga001.fm.intel.com with ESMTP; 24 Apr 2020 02:03:59 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Apr 2020 02:03:32 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Apr 2020 02:03:31 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 24 Apr 2020 02:03:31 -0700
Received: from shsmsx108.ccr.corp.intel.com ([169.254.8.7]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.146]) with mapi id 14.03.0439.000;
 Fri, 24 Apr 2020 17:03:29 +0800
From:   "Zhang, Rui" <rui.zhang@intel.com>
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
CC:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "Support Opensource" <support.opensource@diasemi.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kernel@collabora.com" <kernel@collabora.com>,
        Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: RE: [PATCH v3 2/2] thermal: core: Stop polling DISABLED thermal
 devices
Thread-Topic: [PATCH v3 2/2] thermal: core: Stop polling DISABLED thermal
 devices
Thread-Index: AQHWGZBG4VqXwdwSNk6/8EtFFGs1V6iH9bQA
Date:   Fri, 24 Apr 2020 09:03:29 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926377CF60E3@SHSMSX108.ccr.corp.intel.com>
References: <a3998ad2-19bc-0893-a10d-2bb5adf7d99f@samsung.com>
 <20200423165705.13585-1-andrzej.p@collabora.com>
 <20200423165705.13585-3-andrzej.p@collabora.com>
In-Reply-To: <20200423165705.13585-3-andrzej.p@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrzej,

Thanks for the patches. My Linux laptop was broken and won't get fixed till next
week, so I may lost some of the discussions previously.

> -----Original Message-----
> From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> Sent: Friday, April 24, 2020 12:57 AM
> To: linux-pm@vger.kernel.org
> Cc: Zhang, Rui <rui.zhang@intel.com>; Rafael J . Wysocki
> <rjw@rjwysocki.net>; Len Brown <lenb@kernel.org>; Jiri Pirko
> <jiri@mellanox.com>; Ido Schimmel <idosch@mellanox.com>; David S .
> Miller <davem@davemloft.net>; Peter Kaestle <peter@piie.net>; Darren
> Hart <dvhart@infradead.org>; Andy Shevchenko <andy@infradead.org>;
> Support Opensource <support.opensource@diasemi.com>; Daniel Lezcano
> <daniel.lezcano@linaro.org>; Amit Kucheria
> <amit.kucheria@verdurent.com>; Shawn Guo <shawnguo@kernel.org>;
> Sascha Hauer <s.hauer@pengutronix.de>; Pengutronix Kernel Team
> <kernel@pengutronix.de>; Fabio Estevam <festevam@gmail.com>; NXP
> Linux Team <linux-imx@nxp.com>; Heiko Stuebner <heiko@sntech.de>;
> Orson Zhai <orsonzhai@gmail.com>; Baolin Wang
> <baolin.wang7@gmail.com>; Chunyan Zhang <zhang.lyra@gmail.com>; linux-
> acpi@vger.kernel.org; netdev@vger.kernel.org; platform-driver-
> x86@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kernel@collabora.com; Andrzej Pietrasiewicz <andrzej.p@collabora.com>;
> Barlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH v3 2/2] thermal: core: Stop polling DISABLED thermal devices
> Importance: High
> 
> Polling DISABLED devices is not desired, as all such "disabled" devices are
> meant to be handled by userspace. This patch introduces and uses
> should_stop_polling() to decide whether the device should be polled or not.
> 
Thanks for the fix, and IMO, this reveal some more problems.
Say, we need to define "DISABLED" thermal zone.
Can we read the temperature? Can we trust the trip point value?

IMO, a disabled thermal zone does not mean it is handled by userspace, because
that is what the userspace governor designed for.
Instead, if a thermal zone is disabled, in thermal_zone_device_update(), we should
basically skip all the other operations as well.

I'll try your patches and probably make an incremental patch.

Thanks,
rui

> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/thermal/thermal_core.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c
> b/drivers/thermal/thermal_core.c index a2a5034f76e7..03c4d8d23284 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -305,13 +305,22 @@ static void thermal_zone_device_set_polling(struct
> thermal_zone_device *tz,
>  		cancel_delayed_work(&tz->poll_queue);
>  }
> 
> +static inline bool should_stop_polling(struct thermal_zone_device *tz)
> +{
> +	return thermal_zone_device_get_mode(tz) ==
> THERMAL_DEVICE_DISABLED; }
> +
>  static void monitor_thermal_zone(struct thermal_zone_device *tz)  {
> +	bool stop;
> +
> +	stop = should_stop_polling(tz);
> +
>  	mutex_lock(&tz->lock);
> 
> -	if (tz->passive)
> +	if (!stop && tz->passive)
>  		thermal_zone_device_set_polling(tz, tz->passive_delay);
> -	else if (tz->polling_delay)
> +	else if (!stop && tz->polling_delay)
>  		thermal_zone_device_set_polling(tz, tz->polling_delay);
>  	else
>  		thermal_zone_device_set_polling(tz, 0); @@ -503,6 +512,9
> @@ void thermal_zone_device_update(struct thermal_zone_device *tz,  {
>  	int count;
> 
> +	if (should_stop_polling(tz))
> +		return;
> +
>  	if (atomic_read(&in_suspend))
>  		return;
> 
> --
> 2.17.1

