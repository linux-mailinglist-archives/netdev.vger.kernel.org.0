Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DEF213917
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgGCLG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgGCLG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 07:06:27 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA0DC08C5E0
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 04:06:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so32171536wmf.0
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 04:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y81eMV6HsZOqLL6c1xuYsXbhUNOBcbUsGgBPDyFKgzg=;
        b=gd8gAO8UDpxTYRl0sZn4kWJeCwGEMBxcVYS4QxJfzZ9Z7a6PS2EkXghtn42SdOPbO9
         Lv0aIguI9URFJ/NdVQ1LSjkEv7oun7ZZpIEASsCzo8l2k2wXDEUf7hyXbYPXYx8p8c3G
         iGEQRz/uFuBMMbZYzRrfiGdWDf0d+by8kzqOG1KOREwBu8d0D+nbod0P74qHg14A+48t
         u4zaZrNkNsOV7fMf/DaBuNPBncf9dRCYdpT6o064KI5hFHbKvFZu3fqCzTIDH1Trt4H0
         NjHpG4Va/DgI2BFoS3vl6JlgN6rspjHg064IGsxSyMHfasd2FRZXKB68RccVFAC0cJN6
         pg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y81eMV6HsZOqLL6c1xuYsXbhUNOBcbUsGgBPDyFKgzg=;
        b=KYHZuuQhrnCcFPEogynlakQYUC/D4L93moH0LEKSo7MW7mnLSmArfS9prKsb2MC7jm
         ldm+O+JapUmHQrW39Ykpdze7UQaKTNIlbC2ZseYm9SEfhWcuNntAEOjUV//KKDwgKaIc
         48MJ/mqCRhR2aF9HftfjQKxzl88JbaJY/5FqpEY13Q2r1lBmgW+j0eiX5vbV+0/U6oXL
         jLTwEOB/aqjNM2VSsPQM7ZSVyRqF+48Kbw7wbiJWQy8QJ70fXFMCuHPUXiq7/iXMt7DH
         0kcCn77hmBIyE3nurkiuA89aISUK0iMOSa/3VcDy8gRl7otOiIWP60JqmEy5lsxE65c/
         0Irg==
X-Gm-Message-State: AOAM530/ZTWqvSoacfQxTelsrs3SNugskRPVSrGtGP433b8EnkzJHJcy
        tWFDdFdkKn6qzv2X3LvcyJjvjw==
X-Google-Smtp-Source: ABdhPJx5+hhbJDm2XrJujJyKTYGWkG0fawls1pBeitg1Zd5leR55VAdCRLM6oj6h+HEL1s7BJ19+tw==
X-Received: by 2002:a1c:e18a:: with SMTP id y132mr35371489wmg.27.1593774385057;
        Fri, 03 Jul 2020 04:06:25 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:7019:4e9b:2970:f860? ([2a01:e34:ed2f:f020:7019:4e9b:2970:f860])
        by smtp.googlemail.com with ESMTPSA id r12sm13373362wrc.22.2020.07.03.04.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 04:06:24 -0700 (PDT)
Subject: Re: [PATCH 0/3] Fixes for stop monitoring disabled devices series
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
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
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
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
References: <20200703104354.19657-1-andrzej.p@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <fc1bb7f5-2096-a604-8c30-81d34bf5b737@linaro.org>
Date:   Fri, 3 Jul 2020 13:06:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200703104354.19657-1-andrzej.p@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/07/2020 12:43, Andrzej Pietrasiewicz wrote:
> This short series contains fixes for "Stop monitoring disabled devices"
> series https://www.spinics.net/lists/arm-kernel/msg817861.html
> 
> Invocation of thermal_zone_device_is_enabled() in acpi/thermal is now
> redundant, because thermal_zone_device_update() now is capable of
> handling disabled devices.
> 
> In imx's ->get_temp() the lock must not be taken, otherwise a deadlock
> happens. The decision whether explicitly running a measurement cycle
> is needed is taken based on driver's local irq_enabled variable.
> 
> Finally, thermal_zone_device_is_enabled() is made available to the
> core only, as there are no driver users of it.
> 
> Andrzej Pietrasiewicz (3):
>   acpi: thermal: Don't call thermal_zone_device_is_enabled()
>   thermal: imx: Use driver's local data to decide whether to run a
>     measurement
>   thermal: Make thermal_zone_device_is_enabled() available to core only
> 
>  drivers/acpi/thermal.c         | 3 ---
>  drivers/thermal/imx_thermal.c  | 7 ++++---
>  drivers/thermal/thermal_core.c | 1 -
>  drivers/thermal/thermal_core.h | 2 ++
>  include/linux/thermal.h        | 5 -----
>  5 files changed, 6 insertions(+), 12 deletions(-)

Is this series easily merge-able with the other series?




-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
