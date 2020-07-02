Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BB5212B86
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgGBRt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbgGBRt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:49:57 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA9C08C5E1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:49:56 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g75so28036351wme.5
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xQ/jbEIoi0E5v/8Oaxv5C/iCmVriuxnyUPKYmwbLhJI=;
        b=Su8z7mc7dYnPY7oZG6Qfy2JYbC+KUSrWJlUQisUIJi7j2laFEpLi08Hzg9aJEscsNx
         CNgySZxbqQ8zHjlIkbChmzaDwLiFGQwPsO3X5dNSPEv/D5J2XxENVkxE3rCu+0kw3Es7
         gAu0S3jeVQa36FEZB8+0pnpQLob/I5kajgBvYbdEAUC2zXC03tOVuW0syjSnQ5dcFOLr
         ZhU6sAuB6QYQCHmMi/h06UeD2lfNsx6eXpsJmeVe2jge71IivDIZvo67ktv2TyZILyZG
         EmVXGKoi77uzrMMN0wg4385tboOrgBWpkgPF2IGUOOhSAlQOZN0/WykOwi01hI1ZnfMr
         vsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xQ/jbEIoi0E5v/8Oaxv5C/iCmVriuxnyUPKYmwbLhJI=;
        b=iA8YM+w5AcZa7sshCPn7N5KU8w3LdS3PXZGjc7WdDVX+fNZj7vJhyil2Z1hUkfiSZg
         hHXg3tbUSEZd38iFb9z7YVApphPcyYnLTDW4sxaI+WLFkzGGM3R8MJercyExzczYNSvw
         J2Lc4IQx1w2Q0kiyCWNh7POnUK7r5kCBp/VJCfH04/tH3qREl0wJIqt4oHmGxwjsTVcY
         DC5iKR/ulEHTxhJYVUUbzqw3F4VlenbdZJfUeDN/CXhWDyakub6Ni+kpi9NufVBcZarr
         OHYFKle6/nVI53nDpvkw3ebfiMNLE4eQfmW/LU5ZEt02cBZcWftxZrOY9d+RncUIsGvX
         5PbQ==
X-Gm-Message-State: AOAM531RVQkEvTO1o/it1MiuVwvQB3cjKbmp6Afr7QxlJZDAMEfqL5vz
        bYmFrDQWAKxRJ6VwzOkbN+epmg==
X-Google-Smtp-Source: ABdhPJyzRv8aoQm207JFCd7UUYqXvDOaDeuaWNHVTkS4tsgnm3DlNfQKfqswQjF2MPlESIwAbwvFXw==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr31694303wmc.126.1593712194925;
        Thu, 02 Jul 2020 10:49:54 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0? ([2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0])
        by smtp.googlemail.com with ESMTPSA id b18sm2353454wrs.46.2020.07.02.10.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 10:49:54 -0700 (PDT)
Subject: Re: [PATCH v7 00/11] Stop monitoring disabled devices
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
References: <20200629122925.21729-1-andrzej.p@collabora.com>
 <aab40d90-3f72-657c-5e14-e53a34c4b420@linaro.org>
 <3d03d1a2-ac06-b69b-93cb-e0203be62c10@collabora.com>
 <47111821-d691-e71d-d740-e4325e290fa4@linaro.org>
 <be9b7ee3-cad0-e462-126d-08de9b226285@collabora.com>
 <4353a939-3f5e-8369-5bc0-ad8162b5ffc7@linaro.org>
 <a531d80f-afd1-2dec-6c77-ed984e97595c@collabora.com>
 <db1ff4e1-cbf8-89b3-5d64-b91a1fd88a41@linaro.org>
 <73942aea-ae79-753c-fe90-d4a99423d548@collabora.com>
 <374dddd9-b600-3a30-d6c3-8cfcefc944d9@linaro.org>
 <5a28deb7-f307-8b03-faad-ab05cb8095d1@collabora.com>
 <8aeb4f51-1813-63c1-165b-06640af5968f@linaro.org>
 <685ef627-e377-bbf1-da11-7f7556ca2dd7@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <d41bf28f-ee91-6946-2334-f11ec81f96fe@linaro.org>
Date:   Thu, 2 Jul 2020 19:49:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <685ef627-e377-bbf1-da11-7f7556ca2dd7@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 19:19, Andrzej Pietrasiewicz wrote:
> Hi,
> 
> W dniu 02.07.2020 o 19:01, Daniel Lezcano pisze:
>> On 02/07/2020 15:53, Andrzej Pietrasiewicz wrote:
>>> Hi Daniel,
>>>
>>> <snip>
>>>
>>>>>>>>
>>>>>>>> I did reproduce:
>>>>>>>>
>>>>>>>> v5.8-rc3 + series => imx6 hang at boot time
>>>>>>>> v5.8-rc3 => imx6 boots correctly
>>>>
>>>> So finally I succeeded to reproduce it on my imx7 locally. The sensor
>>>> was failing to initialize for another reason related to the legacy
>>>> cooling device, this is why it is not appearing on the imx7.
>>>>
>>>> I can now git-bisect :)
>>>>
>>>
>>> That would be very kind of you, thank you!
>>
>> With the lock correctness option enabled:
>>
>> [    4.179223] imx_thermal tempmon: Extended Commercial CPU temperature
>> grade - max:105C critical:100C passive:95C
>> [    4.189557]
>> [    4.191060] ============================================
>> [    4.196378] WARNING: possible recursive locking detected
>> [    4.201699] 5.8.0-rc3-00011-gf5e50bf4d3ef #42 Not tainted
>> [    4.207102] --------------------------------------------
>> [    4.212421] kworker/0:3/54 is trying to acquire lock:
>> [    4.217480] ca09a3e4 (&tz->lock){+.+.}-{3:3}, at:
>> thermal_zone_device_is_enabled+0x18/0x34
>> [    4.225777]
>> [    4.225777] but task is already holding lock:
>> [    4.231615] ca09a3e4 (&tz->lock){+.+.}-{3:3}, at:
>> thermal_zone_get_temp+0x38/0x6c
>> [    4.239121]
>> [    4.239121] other info that might help us debug this:
>> [    4.245655]  Possible unsafe locking scenario:
>> [    4.245655]
>> [    4.251579]        CPU0
>> [    4.254031]        ----
>> [    4.256481]   lock(&tz->lock);
>> [    4.259544]   lock(&tz->lock);
>> [    4.262608]
>> [    4.262608]  *** DEADLOCK ***
>> [    4.262608]
>> [    4.268533]  May be due to missing lock nesting notation
>> [    4.268533]
>> [    4.275329] 4 locks held by kworker/0:3/54:
>> [    4.279517]  #0: cb0066a8 ((wq_completion)events){+.+.}-{0:0}, at:
>> process_one_work+0x224/0x808
>> [    4.288241]  #1: ca075f10 (deferred_probe_work){+.+.}-{0:0}, at:
>> process_one_work+0x224/0x808
>> [    4.296787]  #2: cb1a48d8 (&dev->mutex){....}-{3:3}, at:
>> __device_attach+0x30/0x140
>> [    4.304468]  #3: ca09a3e4 (&tz->lock){+.+.}-{3:3}, at:
>> thermal_zone_get_temp+0x38/0x6c
>> [    4.312408]
>> [    4.312408] stack backtrace:
>> [    4.316778] CPU: 0 PID: 54 Comm: kworker/0:3 Not tainted
>> 5.8.0-rc3-00011-gf5e50bf4d3ef #42
>> [    4.325048] Hardware name: Freescale i.MX7 Dual (Device Tree)
>> [    4.330809] Workqueue: events deferred_probe_work_func
>> [    4.335973] [<c0312384>] (unwind_backtrace) from [<c030c580>]
>> (show_stack+0x10/0x14)
>> [    4.343734] [<c030c580>] (show_stack) from [<c079d7d8>]
>> (dump_stack+0xe8/0x114)
>> [    4.351062] [<c079d7d8>] (dump_stack) from [<c03abf78>]
>> (__lock_acquire+0xbfc/0x2cb4)
>> [    4.358909] [<c03abf78>] (__lock_acquire) from [<c03ae9c4>]
>> (lock_acquire+0xf4/0x4e4)
>> [    4.366758] [<c03ae9c4>] (lock_acquire) from [<c10630fc>]
>> (__mutex_lock+0xb0/0xaa8)
>> [    4.374431] [<c10630fc>] (__mutex_lock) from [<c1063b10>]
>> (mutex_lock_nested+0x1c/0x24)
>> [    4.382452] [<c1063b10>] (mutex_lock_nested) from [<c0d932c0>]
>> (thermal_zone_device_is_enabled+0x18/0x34)
>> [    4.392036] [<c0d932c0>] (thermal_zone_device_is_enabled) from
>> [<c0d9da90>] (imx_get_temp+0x30/0x208)
>> [    4.401271] [<c0d9da90>] (imx_get_temp) from [<c0d97484>]
>> (thermal_zone_get_temp+0x4c/0x6c)
>> [    4.409640] [<c0d97484>] (thermal_zone_get_temp) from [<c0d93df0>]
>> (thermal_zone_device_update+0x8c/0x258)
>> [    4.419310] [<c0d93df0>] (thermal_zone_device_update) from
>> [<c0d9401c>] (thermal_zone_device_set_mode+0x60/0x88)
>> [    4.429500] [<c0d9401c>] (thermal_zone_device_set_mode) from
>> [<c0d9e1d4>] (imx_thermal_probe+0x3e4/0x578)
>> [    4.439082] [<c0d9e1d4>] (imx_thermal_probe) from [<c0a78388>]
>> (platform_drv_probe+0x48/0x98)
>> [    4.447622] [<c0a78388>] (platform_drv_probe) from [<c0a7603c>]
>> (really_probe+0x218/0x348)
>> [    4.455903] [<c0a7603c>] (really_probe) from [<c0a76278>]
>> (driver_probe_device+0x5c/0xb4)
>> [    4.464098] [<c0a76278>] (driver_probe_device) from [<c0a743bc>]
>> (bus_for_each_drv+0x58/0xb8)
>> [    4.472638] [<c0a743bc>] (bus_for_each_drv) from [<c0a75db0>]
>> (__device_attach+0xd4/0x140)
>> [    4.480919] [<c0a75db0>] (__device_attach) from [<c0a750b0>]
>> (bus_probe_device+0x88/0x90)
>> [    4.489112] [<c0a750b0>] (bus_probe_device) from [<c0a75564>]
>> (deferred_probe_work_func+0x68/0x98)
>> [    4.498088] [<c0a75564>] (deferred_probe_work_func) from [<c0369988>]
>> (process_one_work+0x2e0/0x808)
>> [    4.507237] [<c0369988>] (process_one_work) from [<c036a150>]
>> (worker_thread+0x2a0/0x59c)
>> [    4.515432] [<c036a150>] (worker_thread) from [<c0372208>]
>> (kthread+0x16c/0x178)
>> [    4.522843] [<c0372208>] (kthread) from [<c0300174>]
>> (ret_from_fork+0x14/0x20)
>> [    4.530074] Exception stack(0xca075fb0 to 0xca075ff8)
>> [    4.535138] 5fa0:                                     00000000
>> 00000000 00000000 00000000
>> [    4.543328] 5fc0: 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000 00000000
>> [    4.551516] 5fe0: 00000000 00000000 00000000 00000000 00000013
>> 00000000
>>
>>
>>
> 
> Thanks!
> 
> That confirms your suspicions.
> 
> So the reason is that ->get_temp() is called while the mutex is held and
> thermal_zone_device_is_enabled() wants to take the same mutex.

Yes, that's correct.

> Is adding a comment to thermal_zone_device_is_enabled() to never call
> it while the mutex is held and adding another version of it which does
> not take the mutex ok?

The thermal_zone_device_is_enabled() is only used in two places, acpi
and this imx driver, and given:

1. as soon as the mutex is released, there is no guarantee the thermal
zone won't be changed right after, the lock is pointless, thus the
information also.

2. from a design point of view, I don't see why a driver should know if
a thermal zone is disabled or not

It would make sense to end with this function and do not give the
different drivers an opportunity to access this information.

Why not add change_mode for the acpi in order to enable or disable the
events and for imx_thermal use irq_enabled flag instead of the thermal
zone mode? Moreover it is very unclear why this function is needed in
imx_get_temp(), and I suspect we should be able to get rid of it.


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
