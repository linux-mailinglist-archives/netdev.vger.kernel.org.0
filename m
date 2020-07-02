Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7803212AAD
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgGBRBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgGBRBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:01:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B11C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 10:01:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 22so27855029wmg.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 10:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=flBxVR+xgEi2+YA19ddsMUzuXtuBdGIE8ZZciur9odQ=;
        b=X8VtyAG69G9o+OhKKU5KR5Ou9DAi4LonHCqCtERfwULRkKasZ3pQe76Bz1YyzYHwQr
         ws99d31JYzUxaGm0OGqg6Pzu5jcR8B4piEAegN+fN4LdAJHmWRt/8hPsUPXyoOWSkCeI
         x7bc8xR9zQTlg4QLUesz//hFLffa0ET2EDmI7elOjt3yQstVDDlowt3e4VES6jufJYjc
         GYG0XIStN4GBKCWODb/oJZHPyotpkOg6Q7ZsRfRPPXC1pJuaL3eEOt8PbKIEx1H/5iyU
         7NOp3nqP9yifePxAPsTJkWFJGtwdikenoRQwm9CAFkCEWIMz4AEHVWDYBeg0IO97ZMLt
         YmjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=flBxVR+xgEi2+YA19ddsMUzuXtuBdGIE8ZZciur9odQ=;
        b=j8C9xWrLSVRniPn3kEmZ4izR9TsbIHFL441m8PMVS2N4FdmMBqFTGCWOjn+Sym3n9i
         mFi+giekhneZKEfgd0yHkINcsAfzGZKa1tHDhCZ8OgJVz47C2hY8wYZ2KGc7f5V7ATyp
         TTYafh5jAcO6+hpNWpguFoumK/9kls3nLdbWxUuECCNpmRox1YRvESpbkpZoWDRc2LKY
         3ceBb4N9ixbrptMpQK4Xq1m1Jg1HgrlikmXYyOukzlGhADpyzy2PtAY7b4zKkflW6nfi
         HIZp2SCzgz4kIoyb+sNJclxOcxmLFK/oTMmYF3cjtllD7t//4WtgpO9RCuBuIha1LbWq
         7CSQ==
X-Gm-Message-State: AOAM5309dSm+lg5SoZCmaofVNQVGIGLbBEQ1Ipt4RKkBPqAZC9zjOoe5
        xwaO6kRmWEqUcynTLfE3xSoWOg==
X-Google-Smtp-Source: ABdhPJzajrw/m876+yzQuQ3H9T3jwQrrB1vLEjC1hnKAqAmsNMvSNkjjEksKsiyoLlxGDOq7GvZKKg==
X-Received: by 2002:a1c:2543:: with SMTP id l64mr9723246wml.31.1593709275497;
        Thu, 02 Jul 2020 10:01:15 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0? ([2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0])
        by smtp.googlemail.com with ESMTPSA id y16sm11329360wro.71.2020.07.02.10.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 10:01:14 -0700 (PDT)
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
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <8aeb4f51-1813-63c1-165b-06640af5968f@linaro.org>
Date:   Thu, 2 Jul 2020 19:01:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5a28deb7-f307-8b03-faad-ab05cb8095d1@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 15:53, Andrzej Pietrasiewicz wrote:
> Hi Daniel,
> 
> <snip>
> 
>>>>>>
>>>>>> I did reproduce:
>>>>>>
>>>>>> v5.8-rc3 + series => imx6 hang at boot time
>>>>>> v5.8-rc3 => imx6 boots correctly
>>
>> So finally I succeeded to reproduce it on my imx7 locally. The sensor
>> was failing to initialize for another reason related to the legacy
>> cooling device, this is why it is not appearing on the imx7.
>>
>> I can now git-bisect :)
>>
> 
> That would be very kind of you, thank you!

With the lock correctness option enabled:

[    4.179223] imx_thermal tempmon: Extended Commercial CPU temperature
grade - max:105C critical:100C passive:95C
[    4.189557]
[    4.191060] ============================================
[    4.196378] WARNING: possible recursive locking detected
[    4.201699] 5.8.0-rc3-00011-gf5e50bf4d3ef #42 Not tainted
[    4.207102] --------------------------------------------
[    4.212421] kworker/0:3/54 is trying to acquire lock:
[    4.217480] ca09a3e4 (&tz->lock){+.+.}-{3:3}, at:
thermal_zone_device_is_enabled+0x18/0x34
[    4.225777]
[    4.225777] but task is already holding lock:
[    4.231615] ca09a3e4 (&tz->lock){+.+.}-{3:3}, at:
thermal_zone_get_temp+0x38/0x6c
[    4.239121]
[    4.239121] other info that might help us debug this:
[    4.245655]  Possible unsafe locking scenario:
[    4.245655]
[    4.251579]        CPU0
[    4.254031]        ----
[    4.256481]   lock(&tz->lock);
[    4.259544]   lock(&tz->lock);
[    4.262608]
[    4.262608]  *** DEADLOCK ***
[    4.262608]
[    4.268533]  May be due to missing lock nesting notation
[    4.268533]
[    4.275329] 4 locks held by kworker/0:3/54:
[    4.279517]  #0: cb0066a8 ((wq_completion)events){+.+.}-{0:0}, at:
process_one_work+0x224/0x808
[    4.288241]  #1: ca075f10 (deferred_probe_work){+.+.}-{0:0}, at:
process_one_work+0x224/0x808
[    4.296787]  #2: cb1a48d8 (&dev->mutex){....}-{3:3}, at:
__device_attach+0x30/0x140
[    4.304468]  #3: ca09a3e4 (&tz->lock){+.+.}-{3:3}, at:
thermal_zone_get_temp+0x38/0x6c
[    4.312408]
[    4.312408] stack backtrace:
[    4.316778] CPU: 0 PID: 54 Comm: kworker/0:3 Not tainted
5.8.0-rc3-00011-gf5e50bf4d3ef #42
[    4.325048] Hardware name: Freescale i.MX7 Dual (Device Tree)
[    4.330809] Workqueue: events deferred_probe_work_func
[    4.335973] [<c0312384>] (unwind_backtrace) from [<c030c580>]
(show_stack+0x10/0x14)
[    4.343734] [<c030c580>] (show_stack) from [<c079d7d8>]
(dump_stack+0xe8/0x114)
[    4.351062] [<c079d7d8>] (dump_stack) from [<c03abf78>]
(__lock_acquire+0xbfc/0x2cb4)
[    4.358909] [<c03abf78>] (__lock_acquire) from [<c03ae9c4>]
(lock_acquire+0xf4/0x4e4)
[    4.366758] [<c03ae9c4>] (lock_acquire) from [<c10630fc>]
(__mutex_lock+0xb0/0xaa8)
[    4.374431] [<c10630fc>] (__mutex_lock) from [<c1063b10>]
(mutex_lock_nested+0x1c/0x24)
[    4.382452] [<c1063b10>] (mutex_lock_nested) from [<c0d932c0>]
(thermal_zone_device_is_enabled+0x18/0x34)
[    4.392036] [<c0d932c0>] (thermal_zone_device_is_enabled) from
[<c0d9da90>] (imx_get_temp+0x30/0x208)
[    4.401271] [<c0d9da90>] (imx_get_temp) from [<c0d97484>]
(thermal_zone_get_temp+0x4c/0x6c)
[    4.409640] [<c0d97484>] (thermal_zone_get_temp) from [<c0d93df0>]
(thermal_zone_device_update+0x8c/0x258)
[    4.419310] [<c0d93df0>] (thermal_zone_device_update) from
[<c0d9401c>] (thermal_zone_device_set_mode+0x60/0x88)
[    4.429500] [<c0d9401c>] (thermal_zone_device_set_mode) from
[<c0d9e1d4>] (imx_thermal_probe+0x3e4/0x578)
[    4.439082] [<c0d9e1d4>] (imx_thermal_probe) from [<c0a78388>]
(platform_drv_probe+0x48/0x98)
[    4.447622] [<c0a78388>] (platform_drv_probe) from [<c0a7603c>]
(really_probe+0x218/0x348)
[    4.455903] [<c0a7603c>] (really_probe) from [<c0a76278>]
(driver_probe_device+0x5c/0xb4)
[    4.464098] [<c0a76278>] (driver_probe_device) from [<c0a743bc>]
(bus_for_each_drv+0x58/0xb8)
[    4.472638] [<c0a743bc>] (bus_for_each_drv) from [<c0a75db0>]
(__device_attach+0xd4/0x140)
[    4.480919] [<c0a75db0>] (__device_attach) from [<c0a750b0>]
(bus_probe_device+0x88/0x90)
[    4.489112] [<c0a750b0>] (bus_probe_device) from [<c0a75564>]
(deferred_probe_work_func+0x68/0x98)
[    4.498088] [<c0a75564>] (deferred_probe_work_func) from [<c0369988>]
(process_one_work+0x2e0/0x808)
[    4.507237] [<c0369988>] (process_one_work) from [<c036a150>]
(worker_thread+0x2a0/0x59c)
[    4.515432] [<c036a150>] (worker_thread) from [<c0372208>]
(kthread+0x16c/0x178)
[    4.522843] [<c0372208>] (kthread) from [<c0300174>]
(ret_from_fork+0x14/0x20)
[    4.530074] Exception stack(0xca075fb0 to 0xca075ff8)
[    4.535138] 5fa0:                                     00000000
00000000 00000000 00000000
[    4.543328] 5fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    4.551516] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
