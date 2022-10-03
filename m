Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED28B5F37B7
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 23:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiJCV1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 17:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiJCV1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 17:27:17 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC21558E6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 14:18:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u10so18400110wrq.2
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 14:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Axxsa4o83JxVySF0VeMEEgQfzZQEKD42u7jzjyEhlTA=;
        b=Xj5R/xtYz0KVD8v36F7VJfwh0AouVJWpEaeGMIJV93h8iQ0EYzDjZ1zTozM6TufDg3
         0KM9P0ctFd3Fs7cUhCJjrwScSreI+E9HIlZm/OZ/bkI1nqVDTey0WZYSWgaiEJfegKim
         /LJw/rCP1DeHLNdozCvsBhU3yFjf4n80/pMNtq1T8zjTiJ36lahBrdTiZ9jB1PlJPLG4
         eJpf94uwUzubWN/ss3zYtJJ37EO6J2ndTIECOcuK/YgL77S2SyUyW/wFzGVFObQ+WgbF
         g4KiY4ITBf4jbBVOTXr5v4v+khxASQWurI+57sRxRT8flp5xOw8DV2jJif41PPNbicf0
         Or4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Axxsa4o83JxVySF0VeMEEgQfzZQEKD42u7jzjyEhlTA=;
        b=uoNL0DUxAsl4JXjhir66pbzdGhBNnW9k2+h0Pu8wYyChZYu7XYn6SoTg8b6mhtTb/b
         FRponJEjxUb6PM7VcYasYj5Scon1vhhYy1DRiwh+IN9Z+utzbP7f3J32qXQWW9AOCm37
         GEpMFu78Ww9lIryKQCGt6BUKLv8DdywV5/w5ru+g8R493N4SPFm9kLZoFpjrpZnEPwy6
         MCzplwLszQe+zXAjlX2Cwdazb0mHopYnWeP8eGtJYsGuH737P+qpPsouHI2CLFpJafun
         T62dzNBgadutjd1MuWZFSocdc+N4dFj+E3LVbxr/BjU4eiowipAkOKMIFHcKMvhOGEEH
         AEnQ==
X-Gm-Message-State: ACrzQf1Bjorv5zsFyY1REVSk4ZyaNgDTq6RFs9jGpDpuSKJs8xn8OlDM
        Ir5shRlGPlxkKB3mbbnVhgTdMA==
X-Google-Smtp-Source: AMsMyM5ldop9A6R5ttlN72dKmImyDiKX+QeWExu9pLifC5OYYNjcvQZwV3oYzqRijrfGYgHtgvvn7Q==
X-Received: by 2002:a05:6000:2ad:b0:228:cf8f:fe85 with SMTP id l13-20020a05600002ad00b00228cf8ffe85mr14608289wry.94.1664831890494;
        Mon, 03 Oct 2022 14:18:10 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:c456:8337:99aa:2667? ([2a05:6e02:1041:c10:c456:8337:99aa:2667])
        by smtp.googlemail.com with ESMTPSA id g10-20020a05600c4eca00b003a62400724bsm14660100wmq.0.2022.10.03.14.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 14:18:09 -0700 (PDT)
Message-ID: <c3258cb2-9a56-d048-5738-1132331a157d@linaro.org>
Date:   Mon, 3 Oct 2022 23:18:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
Content-Language: en-US
To:     Marek Szyprowski <m.szyprowski@samsung.com>, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rui.zhang@intel.com,
        Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
 <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2022 16:10, Marek Szyprowski wrote:
> Hi Daniel,
> 
> On 03.10.2022 11:25, Daniel Lezcano wrote:
>> This work is the pre-requisite of handling correctly when the trip
>> point are crossed. For that we need to rework how the trip points are
>> declared and assigned to a thermal zone.
>>
>> Even if it appears to be a common sense to have the trip points being
>> ordered, this no guarantee neither documentation telling that is the
>> case.
>>
>> One solution could have been to create an ordered array of trips built
>> when registering the thermal zone by calling the different get_trip*
>> ops. However those ops receive a thermal zone pointer which is not
>> known as it is in the process of creating it.
>>
>> This cyclic dependency shows we have to rework how we manage the trip
>> points.
>>
>> Actually, all the trip points definition can be common to the backend
>> sensor drivers and we can factor out the thermal trip structure in all
>> of them.
>>
>> Then, as we register the thermal trips array, they will be available
>> in the thermal zone structure and a core function can return the trip
>> given its id.
>>
>> The get_trip_* ops won't be needed anymore and could be removed. The
>> resulting code will be another step forward to a self encapsulated
>> generic thermal framework.
>>
>> Most of the drivers can be converted more or less easily. This series
>> does a first round with most of the drivers. Some remain and will be
>> converted but with a smaller set of changes as the conversion is a bit
>> more complex.
>>
>> Changelog:
>> v8:
>> - Pretty oneline change and parenthesis removal (Rafael)
>> - Collected tags
>> v7:
>> - Added missing return 0 in the x86_pkg_temp driver
>> v6:
>> - Improved the code for the get_crit_temp() function as suggested by
>> Rafael
>> - Removed inner parenthesis in the set_trip_temp() function and invert the
>> conditions. Check the type of the trip point is unchanged
>> - Folded patch 4 with 1
>> - Add per thermal zone info message in the bang-bang governor
>> - Folded the fix for an uninitialized variable in
>> int340x_thermal_zone_add()
>> v5:
>> - Fixed a deadlock when calling thermal_zone_get_trip() while
>> handling the thermal zone lock
>> - Remove an extra line in the sysfs change
>> - Collected tags
>> v4:
>> - Remove extra lines on exynos changes as reported by Krzysztof Kozlowski
>> - Collected tags
>> v3:
>> - Reorg the series to be git-bisect safe
>> - Added the set_trip generic function
>> - Added the get_crit_temp generic function
>> - Removed more dead code in the thermal-of
>> - Fixed the exynos changelog
>> - Fixed the error check for the exynos drivers
>> - Collected tags
>> v2:
>> - Added missing EXPORT_SYMBOL_GPL() for thermal_zone_get_trip()
>> - Removed tab whitespace in the acerhdf driver
>> - Collected tags
>>
>> Cc: Raju Rangoju <rajur@chelsio.com>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Paolo Abeni <pabeni@redhat.com>
>> Cc: Peter Kaestle <peter@piie.net>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Mark Gross <markgross@kernel.org>
>> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
>> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Amit Kucheria <amitk@kernel.org>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: Nicolas Saenz Julienne <nsaenz@kernel.org>
>> Cc: Broadcom Kernel Team <bcm-kernel-feedback-list@broadcom.com>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Ray Jui <rjui@broadcom.com>
>> Cc: Scott Branden <sbranden@broadcom.com>
>> Cc: Support Opensource <support.opensource@diasemi.com>
>> Cc: Lukasz Luba <lukasz.luba@arm.com>
>> Cc: Shawn Guo <shawnguo@kernel.org>
>> Cc: Sascha Hauer <s.hauer@pengutronix.de>
>> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
>> Cc: Fabio Estevam <festevam@gmail.com>
>> Cc: NXP Linux Team <linux-imx@nxp.com>
>> Cc: Thara Gopinath <thara.gopinath@linaro.org>
>> Cc: Andy Gross <agross@kernel.org>
>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Cc: "Niklas Söderlund" <niklas.soderlund@ragnatech.se>
>> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Jonathan Hunter <jonathanh@nvidia.com>
>> Cc: Eduardo Valentin <edubezval@gmail.com>
>> Cc: Keerthy <j-keerthy@ti.com>
>> Cc: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Antoine Tenart <atenart@kernel.org>
>> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>> Cc: Dmitry Osipenko <digetx@gmail.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: platform-driver-x86@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-rpi-kernel@lists.infradead.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-arm-msm@vger.kernel.org
>> Cc: linux-renesas-soc@vger.kernel.org
>> Cc: linux-samsung-soc@vger.kernel.org
>> Cc: linux-tegra@vger.kernel.org
>> Cc: linux-omap@vger.kernel.org
>>
>> Daniel Lezcano (29):
>> thermal/core: Add a generic thermal_zone_get_trip() function
>> thermal/sysfs: Always expose hysteresis attributes
>> thermal/core: Add a generic thermal_zone_set_trip() function
>> thermal/core/governors: Use thermal_zone_get_trip() instead of ops
>> functions
>> thermal/of: Use generic thermal_zone_get_trip() function
>> thermal/of: Remove unused functions
>> thermal/drivers/exynos: Use generic thermal_zone_get_trip() function
>> thermal/drivers/exynos: of_thermal_get_ntrips()
>> thermal/drivers/exynos: Replace of_thermal_is_trip_valid() by
>> thermal_zone_get_trip()
>> thermal/drivers/tegra: Use generic thermal_zone_get_trip() function
>> thermal/drivers/uniphier: Use generic thermal_zone_get_trip() function
>> thermal/drivers/hisi: Use generic thermal_zone_get_trip() function
>> thermal/drivers/qcom: Use generic thermal_zone_get_trip() function
>> thermal/drivers/armada: Use generic thermal_zone_get_trip() function
>> thermal/drivers/rcar_gen3: Use the generic function to get the number
>> of trips
>> thermal/of: Remove of_thermal_get_ntrips()
>> thermal/of: Remove of_thermal_is_trip_valid()
>> thermal/of: Remove of_thermal_set_trip_hyst()
>> thermal/of: Remove of_thermal_get_crit_temp()
>> thermal/drivers/st: Use generic trip points
>> thermal/drivers/imx: Use generic thermal_zone_get_trip() function
>> thermal/drivers/rcar: Use generic thermal_zone_get_trip() function
>> thermal/drivers/broadcom: Use generic thermal_zone_get_trip() function
>> thermal/drivers/da9062: Use generic thermal_zone_get_trip() function
>> thermal/drivers/ti: Remove unused macros ti_thermal_get_trip_value() /
>> ti_thermal_trip_is_valid()
>> thermal/drivers/acerhdf: Use generic thermal_zone_get_trip() function
>> thermal/drivers/cxgb4: Use generic thermal_zone_get_trip() function
>> thermal/intel/int340x: Replace parameter to simplify
>> thermal/drivers/intel: Use generic thermal_zone_get_trip() function
> 
> I've tested this v8 patchset after fixing the issue with Exynos TMU with
> https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/
> patch and I got the following lockdep warning on all Exynos-based boards:
> 
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
> ------------------------------------------------------
> swapper/0/1 is trying to acquire lock:
> c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8
> 
> but task is already holding lock:
> c2979b94 (&tz->lock){+.+.}-{3:3}, at:
> thermal_zone_device_update.part.0+0x3c/0x528
> 
> which lock already depends on the new lock.

I'm wondering if the problem is not already there and related to 
data->lock ...

Doesn't the thermal zone lock already prevent racy access to the data 
structure?

Another question: if the sensor clock is disabled after reading it, how 
does the hardware update the temperature and detect the programed 
threshold is crossed?

> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&tz->lock){+.+.}-{3:3}:
>          mutex_lock_nested+0x1c/0x24
>          thermal_zone_get_trip+0x20/0x44
>          exynos_tmu_initialize+0x144/0x1e0
>          exynos_tmu_probe+0x2b0/0x728
>          platform_probe+0x5c/0xb8
>          really_probe+0xe0/0x414
>          __driver_probe_device+0xa0/0x208
>          driver_probe_device+0x30/0xc0
>          __driver_attach+0xf0/0x1f0
>          bus_for_each_dev+0x70/0xb0
>          bus_add_driver+0x174/0x218
>          driver_register+0x88/0x11c
>          do_one_initcall+0x64/0x380
>          kernel_init_freeable+0x1c0/0x224
>          kernel_init+0x18/0x12c
>          ret_from_fork+0x14/0x2c
>          0x0
> 
> -> #0 (&data->lock#2){+.+.}-{3:3}:
>          lock_acquire+0x124/0x3e4
>          __mutex_lock+0x90/0x948
>          mutex_lock_nested+0x1c/0x24
>          exynos_get_temp+0x3c/0xc8
>          __thermal_zone_get_temp+0x5c/0x12c
>          thermal_zone_device_update.part.0+0x78/0x528
>          __thermal_cooling_device_register.part.0+0x298/0x354
>          __cpufreq_cooling_register.constprop.0+0x138/0x218
>          of_cpufreq_cooling_register+0x48/0x8c
>          cpufreq_online+0x8d0/0xb2c
>          cpufreq_add_dev+0xb0/0xec
>          subsys_interface_register+0x108/0x118
>          cpufreq_register_driver+0x15c/0x380
>          dt_cpufreq_probe+0x2e4/0x434
>          platform_probe+0x5c/0xb8
>          really_probe+0xe0/0x414
>          __driver_probe_device+0xa0/0x208
>          driver_probe_device+0x30/0xc0
>          __driver_attach+0xf0/0x1f0
>          bus_for_each_dev+0x70/0xb0
>          bus_add_driver+0x174/0x218
>          driver_register+0x88/0x11c
>          do_one_initcall+0x64/0x380
>          kernel_init_freeable+0x1c0/0x224
>          kernel_init+0x18/0x12c
>          ret_from_fork+0x14/0x2c
>          0x0
> 
> other info that might help us debug this:
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                    CPU1
>          ----                    ----
>     lock(&tz->lock);
>                                  lock(&data->lock#2);
>                                  lock(&tz->lock);
>     lock(&data->lock#2);
> 
>    *** DEADLOCK ***
> 
> 5 locks held by swapper/0/1:
>    #0: c1c8648c (&dev->mutex){....}-{3:3}, at: __driver_attach+0xe4/0x1f0
>    #1: c1210434 (cpu_hotplug_lock){++++}-{0:0}, at:
> cpufreq_register_driver+0xc4/0x380
>    #2: c1ed8298 (subsys mutex#8){+.+.}-{3:3}, at:
> subsys_interface_register+0x4c/0x118
>    #3: c131f944 (thermal_list_lock){+.+.}-{3:3}, at:
> __thermal_cooling_device_register.part.0+0x238/0x354
>    #4: c2979b94 (&tz->lock){+.+.}-{3:3}, at:
> thermal_zone_device_update.part.0+0x3c/0x528
> 
> stack backtrace:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc1-00083-ge5c9d117223e
> #12945
> Hardware name: Samsung Exynos (Flattened Device Tree)
>    unwind_backtrace from show_stack+0x10/0x14
>    show_stack from dump_stack_lvl+0x58/0x70
>    dump_stack_lvl from check_noncircular+0xf0/0x158
>    check_noncircular from __lock_acquire+0x15e8/0x2a7c
>    __lock_acquire from lock_acquire+0x124/0x3e4
>    lock_acquire from __mutex_lock+0x90/0x948
>    __mutex_lock from mutex_lock_nested+0x1c/0x24
>    mutex_lock_nested from exynos_get_temp+0x3c/0xc8
>    exynos_get_temp from __thermal_zone_get_temp+0x5c/0x12c
>    __thermal_zone_get_temp from thermal_zone_device_update.part.0+0x78/0x528
>    thermal_zone_device_update.part.0 from
> __thermal_cooling_device_register.part.0+0x298/0x354
>    __thermal_cooling_device_register.part.0 from
> __cpufreq_cooling_register.constprop.0+0x138/0x218
>    __cpufreq_cooling_register.constprop.0 from
> of_cpufreq_cooling_register+0x48/0x8c
>    of_cpufreq_cooling_register from cpufreq_online+0x8d0/0xb2c
>    cpufreq_online from cpufreq_add_dev+0xb0/0xec
>    cpufreq_add_dev from subsys_interface_register+0x108/0x118
>    subsys_interface_register from cpufreq_register_driver+0x15c/0x380
>    cpufreq_register_driver from dt_cpufreq_probe+0x2e4/0x434
>    dt_cpufreq_probe from platform_probe+0x5c/0xb8
>    platform_probe from really_probe+0xe0/0x414
>    really_probe from __driver_probe_device+0xa0/0x208
>    __driver_probe_device from driver_probe_device+0x30/0xc0
>    driver_probe_device from __driver_attach+0xf0/0x1f0
>    __driver_attach from bus_for_each_dev+0x70/0xb0
>    bus_for_each_dev from bus_add_driver+0x174/0x218
>    bus_add_driver from driver_register+0x88/0x11c
>    driver_register from do_one_initcall+0x64/0x380
>    do_one_initcall from kernel_init_freeable+0x1c0/0x224
>    kernel_init_freeable from kernel_init+0x18/0x12c
>    kernel_init from ret_from_fork+0x14/0x2c
> Exception stack(0xf082dfb0 to 0xf082dff8)
> ...
> 
> Let me know if You need anything more to test.
> 
> 
>> drivers/net/ethernet/chelsio/cxgb4/cxgb4.h | 2 -
>> .../ethernet/chelsio/cxgb4/cxgb4_thermal.c | 41 +----
>> drivers/platform/x86/acerhdf.c | 73 +++-----
>> drivers/thermal/armada_thermal.c | 39 ++---
>> drivers/thermal/broadcom/bcm2835_thermal.c | 8 +-
>> drivers/thermal/da9062-thermal.c | 52 +-----
>> drivers/thermal/gov_bang_bang.c | 39 +++--
>> drivers/thermal/gov_fair_share.c | 18 +-
>> drivers/thermal/gov_power_allocator.c | 51 +++---
>> drivers/thermal/gov_step_wise.c | 22 ++-
>> drivers/thermal/hisi_thermal.c | 11 +-
>> drivers/thermal/imx_thermal.c | 72 +++-----
>> .../int340x_thermal/int340x_thermal_zone.c | 33 ++--
>> .../int340x_thermal/int340x_thermal_zone.h | 4 +-
>> .../processor_thermal_device.c | 10 +-
>> drivers/thermal/intel/x86_pkg_temp_thermal.c | 120 +++++++------
>> drivers/thermal/qcom/qcom-spmi-temp-alarm.c | 39 ++---
>> drivers/thermal/rcar_gen3_thermal.c | 2 +-
>> drivers/thermal/rcar_thermal.c | 53 +-----
>> drivers/thermal/samsung/exynos_tmu.c | 57 +++----
>> drivers/thermal/st/st_thermal.c | 47 +----
>> drivers/thermal/tegra/soctherm.c | 33 ++--
>> drivers/thermal/tegra/tegra30-tsensor.c | 17 +-
>> drivers/thermal/thermal_core.c | 160 +++++++++++++++---
>> drivers/thermal/thermal_core.h | 24 +--
>> drivers/thermal/thermal_helpers.c | 28 +--
>> drivers/thermal/thermal_netlink.c | 21 +--
>> drivers/thermal/thermal_of.c | 116 -------------
>> drivers/thermal/thermal_sysfs.c | 133 +++++----------
>> drivers/thermal/ti-soc-thermal/ti-thermal.h | 15 --
>> drivers/thermal/uniphier_thermal.c | 27 ++-
>> include/linux/thermal.h | 10 ++
>> 32 files changed, 559 insertions(+), 818 deletions(-)
>>
> Best regards
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
