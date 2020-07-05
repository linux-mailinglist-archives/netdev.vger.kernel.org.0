Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6107F214A80
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 08:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgGEGEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 02:04:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:53525 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgGEGEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 02:04:34 -0400
IronPort-SDR: pHnVBsnIxSx5WKl1RlaRCjXrBR5HrZUnQ9z4I8Ty1cV8AXChURgWwbzJjdlA4BNDJYgri+i7nc
 +huKGr37dUTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9672"; a="147301297"
X-IronPort-AV: E=Sophos;i="5.75,314,1589266800"; 
   d="scan'208";a="147301297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2020 23:04:33 -0700
IronPort-SDR: RTZKJhnrLEZugPly4VtR2NDpLYKGxq/qbqDz6diM18IhrJLYpFDA0aIulzr5x/OJiPJ0R6pdFP
 RzzxPLYsn14A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,314,1589266800"; 
   d="scan'208";a="282715546"
Received: from yangblan-mobl2.ccr.corp.intel.com ([10.255.29.148])
  by orsmga006.jf.intel.com with ESMTP; 04 Jul 2020 23:04:22 -0700
Message-ID: <9627f15fb2145525b40d6c1aed6752e13df876e9.camel@intel.com>
Subject: Re: [PATCH 0/3] Fixes for stop monitoring disabled devices series
From:   Zhang Rui <rui.zhang@intel.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
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
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        kernel@collabora.com
Date:   Sun, 05 Jul 2020 14:04:21 +0800
In-Reply-To: <79ae59af-d3b9-852c-d5f3-5b80d9c6ea8c@linaro.org>
References: <20200703104354.19657-1-andrzej.p@collabora.com>
         <fc1bb7f5-2096-a604-8c30-81d34bf5b737@linaro.org>
         <91db4c89-0615-4a69-9695-ed5d3c42e1b7@collabora.com>
         <79ae59af-d3b9-852c-d5f3-5b80d9c6ea8c@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-07-03 at 14:05 +0200, Daniel Lezcano wrote:
> On 03/07/2020 13:57, Andrzej Pietrasiewicz wrote:
> > Hi,
> > 
> > W dniu 03.07.2020 o 13:06, Daniel Lezcano pisze:
> > > On 03/07/2020 12:43, Andrzej Pietrasiewicz wrote:
> > > > This short series contains fixes for "Stop monitoring disabled
> > > > devices"
> > > > series https://www.spinics.net/lists/arm-kernel/msg817861.html
> > > > 
> > > > Invocation of thermal_zone_device_is_enabled() in acpi/thermal
> > > > is now
> > > > redundant, because thermal_zone_device_update() now is capable
> > > > of
> > > > handling disabled devices.
> > > > 
> > > > In imx's ->get_temp() the lock must not be taken, otherwise a
> > > > deadlock
> > > > happens. The decision whether explicitly running a measurement
> > > > cycle
> > > > is needed is taken based on driver's local irq_enabled
> > > > variable.
> > > > 
> > > > Finally, thermal_zone_device_is_enabled() is made available to
> > > > the
> > > > core only, as there are no driver users of it.
> > > > 
> > > > Andrzej Pietrasiewicz (3):
> > > >    acpi: thermal: Don't call thermal_zone_device_is_enabled()
> > > >    thermal: imx: Use driver's local data to decide whether to
> > > > run a
> > > >      measurement
> > > >    thermal: Make thermal_zone_device_is_enabled() available to
> > > > core only
> > > > 
> > > >   drivers/acpi/thermal.c         | 3 ---
> > > >   drivers/thermal/imx_thermal.c  | 7 ++++---
> > > >   drivers/thermal/thermal_core.c | 1 -
> > > >   drivers/thermal/thermal_core.h | 2 ++
> > > >   include/linux/thermal.h        | 5 -----
> > > >   5 files changed, 6 insertions(+), 12 deletions(-)
> > > 
> > > Is this series easily merge-able with the other series?
> > > 
> > 
> > So-so.
> > 
> > Some simple conflicts needed to be resolved.
> > 
> > I have created a branch for you to look at and decide
> > how far off it is from the original and whether the
> > original Acked-by/Reviewed-by can be retained.
> > 
> > Note that I might have lost some portions of code
> > during conflict resolution. It seems to me I haven't
> > but you know.
> > 
> > The branch:
> > 
> > 
https://gitlab.collabora.com/andrzej.p/kernel-tests/-/tree/thermal-dont-poll-disabled-for-daniel
> 
> Ok, I propose to keep the these three patches on top of V7.
> 
> Rui are you fine with that ?

Yes, that works for me.

thanks,
rui
> 
> 
> 

