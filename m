Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32232139B2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGCMFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 08:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgGCMFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 08:05:08 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D26C08C5DD
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 05:05:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a6so22227481wmm.0
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 05:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b/2h7xwQ3PLCO21KCpNHtwNw5XKKdaueZj6bzj1qaFI=;
        b=FwFjz9kczp/fmEq/3CY2LzY2MoAX4g3txWk2jZPo1VMcZhFboGhbIg3T8rhW0rPtbh
         qKWbZioeDBQZ9CKsivZWPupCioAGqQYcUfu4IlduD6az4TVr0iBMZzhBOKPL9J7uMbWA
         mquofFZR7KwyKNOmBpOWqsQ2cDTqZBtJ4MhCqXeld9v0yHNq686i8GUu6NvzX52yGtCB
         wdhzw6IXYtGUX0Q+WUJVgugYssLiqaRgCYqUWIi7yrmmC5szxCxNsSn3Qy+dVlKZF2Z/
         21oufd7NY1SMIhg2z1KYznt2bu66fmWXV174+G1DLqnoRRv5lvwFG0EieYGNbAm9E8hr
         EE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/2h7xwQ3PLCO21KCpNHtwNw5XKKdaueZj6bzj1qaFI=;
        b=YqDX4HbrLgE5hnTBhj+m1deFsLVcafp76xSOXK05eeuGh7EMoE6YiCos9ILLJGIF/G
         ksfVTxYjv+M6ommQcc3aVAj6U878ec3i4DkRLFuvTN44GUOUe03u4lUBFQChHXF2qjQL
         G/WrHsJJXC0HIao0TrysqIRqSmJoQoPviMbH3psoCPjjyYH7iv8jQl9oUUXbpqPePQ82
         vX8piUOisVjuNmNUvZPSU8onWtttCRQ3gEPR+f/EzYqCy63l3juc4F7kQ9PhHkctyGcp
         9UqdnTN7WAIaMEbSPcHsAl8KS8oyw4HVXDGJKT80XfE2PmLhM17Mz00hM7+zAaVpbVyJ
         2xMg==
X-Gm-Message-State: AOAM530qnnnFyp/ctbYv7YQPKotx0/1/mupkTLKjiQIVHh5wanPwPpFm
        2WiHoTY8VJz8bNCSERx/pl5nsg==
X-Google-Smtp-Source: ABdhPJwumsxgGpUFT/dRsPTyUr8OuykwTKjzsUJJ7FiUIydVdbcw33LRfbaUoxiLbcb0XM3MhDfEJQ==
X-Received: by 2002:a1c:9e84:: with SMTP id h126mr25473497wme.61.1593777905183;
        Fri, 03 Jul 2020 05:05:05 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:7019:4e9b:2970:f860? ([2a01:e34:ed2f:f020:7019:4e9b:2970:f860])
        by smtp.googlemail.com with ESMTPSA id k20sm13379403wmi.27.2020.07.03.05.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 05:05:04 -0700 (PDT)
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
 <fc1bb7f5-2096-a604-8c30-81d34bf5b737@linaro.org>
 <91db4c89-0615-4a69-9695-ed5d3c42e1b7@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <79ae59af-d3b9-852c-d5f3-5b80d9c6ea8c@linaro.org>
Date:   Fri, 3 Jul 2020 14:05:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <91db4c89-0615-4a69-9695-ed5d3c42e1b7@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/07/2020 13:57, Andrzej Pietrasiewicz wrote:
> Hi,
> 
> W dniu 03.07.2020 o 13:06, Daniel Lezcano pisze:
>> On 03/07/2020 12:43, Andrzej Pietrasiewicz wrote:
>>> This short series contains fixes for "Stop monitoring disabled devices"
>>> series https://www.spinics.net/lists/arm-kernel/msg817861.html
>>>
>>> Invocation of thermal_zone_device_is_enabled() in acpi/thermal is now
>>> redundant, because thermal_zone_device_update() now is capable of
>>> handling disabled devices.
>>>
>>> In imx's ->get_temp() the lock must not be taken, otherwise a deadlock
>>> happens. The decision whether explicitly running a measurement cycle
>>> is needed is taken based on driver's local irq_enabled variable.
>>>
>>> Finally, thermal_zone_device_is_enabled() is made available to the
>>> core only, as there are no driver users of it.
>>>
>>> Andrzej Pietrasiewicz (3):
>>>    acpi: thermal: Don't call thermal_zone_device_is_enabled()
>>>    thermal: imx: Use driver's local data to decide whether to run a
>>>      measurement
>>>    thermal: Make thermal_zone_device_is_enabled() available to core only
>>>
>>>   drivers/acpi/thermal.c         | 3 ---
>>>   drivers/thermal/imx_thermal.c  | 7 ++++---
>>>   drivers/thermal/thermal_core.c | 1 -
>>>   drivers/thermal/thermal_core.h | 2 ++
>>>   include/linux/thermal.h        | 5 -----
>>>   5 files changed, 6 insertions(+), 12 deletions(-)
>>
>> Is this series easily merge-able with the other series?
>>
> 
> So-so.
> 
> Some simple conflicts needed to be resolved.
> 
> I have created a branch for you to look at and decide
> how far off it is from the original and whether the
> original Acked-by/Reviewed-by can be retained.
> 
> Note that I might have lost some portions of code
> during conflict resolution. It seems to me I haven't
> but you know.
> 
> The branch:
> 
> https://gitlab.collabora.com/andrzej.p/kernel-tests/-/tree/thermal-dont-poll-disabled-for-daniel

Ok, I propose to keep the these three patches on top of V7.

Rui are you fine with that ?



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
