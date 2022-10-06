Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E135F613D
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 08:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiJFGzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 02:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJFGzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 02:55:17 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9442F3A5
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 23:55:14 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j16so1157567wrh.5
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 23:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mpnbl0sOHmjZXpRaPHZuxhEh+P6N/msQTLYNVhfBBe8=;
        b=MiPZCFMrd8ZJnITo2QNV97U1PS/R+5ZaOpCPg1dg0ozuIl6v8QxOhznFxmMRbJFt61
         +KQ26aFgOClHddDkzpBN5Ti5bjTzZazFn9IOccCqYNGZm83luL0MAi2ZIMoiLBhbdpI9
         ErI4nhBYVAiDsh8U0oXUCxVcV8bop7IuJT7Ik70JSybZ18r2+2UEeGXI8zLnhalxuyPK
         D72/xbL0hdoGvzz5uUDTnekoAkjXs/FrL4Ugud+EDDTaZGiQrY2Xuz1ety4QCzOavUyl
         +n3MfQtsIn5LI92EpTTgt2DO7DNNtKRNghaJz8p+7n59IVXb/QZmDJ0puWLNYB+9gbop
         agyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mpnbl0sOHmjZXpRaPHZuxhEh+P6N/msQTLYNVhfBBe8=;
        b=g45EtHiibKUmrA0RJ3qlfkkheCR5nAug3xN9I4NK9YGzHWboMy0ZDanNQhHzG9+3EC
         v1o0u2k+WSDpbnCQrFTSdpbr9a7faU+k0Zs06vI2OCHX3NUxZ2d5rkg+OyL+and5TE97
         sfqM7zOS2pN1xtHsSLupfXKCr9uP2cpfVaWsBLMM9kl/PUMkWYQAM0o31ANWR4SmDWW+
         oNSUaQrino2qNxay8rr9BkIQVIN9M/b4NyH9yiKgZANs001HlqJ6r/lXLjelOIUNHj9e
         isJD5fZFh0niHFzGmvUC6+2t5ptYYNCAlCaoltfaReRSK8PMtPf3nDQ9vLMJAEW8HIdC
         Jghw==
X-Gm-Message-State: ACrzQf3VXv7gDAJ6L+Gx2C68FHVkQ/HfJj3+b2sM9VRoFiqQ+6Q/bQYs
        GiC6GDFLTvKqTNYRUPqoXQ9UCQ==
X-Google-Smtp-Source: AMsMyM4tUv+yoGLPcmLIx0TCLkILd2ZuyZqPgL+k6wTXzf/o8aVrTs7qe5sYTzmE/qACZEBJdXpwZw==
X-Received: by 2002:a05:6000:806:b0:22a:36df:2663 with SMTP id bt6-20020a056000080600b0022a36df2663mr1873670wrb.423.1665039312765;
        Wed, 05 Oct 2022 23:55:12 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:86cc:fff3:d44b:9793? ([2a05:6e02:1041:c10:86cc:fff3:d44b:9793])
        by smtp.googlemail.com with ESMTPSA id a5-20020adfeec5000000b0022e2c38f8basm14459474wrp.14.2022.10.05.23.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 23:55:12 -0700 (PDT)
Message-ID: <97201878-3bb8-eac5-7fac-a690322ac43a@linaro.org>
Date:   Thu, 6 Oct 2022 08:55:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 00/29] Rework the trip points creation
Content-Language: en-US
To:     Marek Szyprowski <m.szyprowski@samsung.com>
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
        linux-omap@vger.kernel.org, rafael@kernel.org
References: <CGME20221003092704eucas1p2875c1f996dfd60a58f06cf986e02e8eb@eucas1p2.samsung.com>
 <20221003092602.1323944-1-daniel.lezcano@linaro.org>
 <8cdd1927-da38-c23e-fa75-384694724b1c@samsung.com>
 <c3258cb2-9a56-d048-5738-1132331a157d@linaro.org>
 <851008bf-145d-224c-87a8-cb6ec1e9addb@linaro.org>
 <207c1979-0da2-b05d-fead-6880ad956b90@samsung.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <207c1979-0da2-b05d-fead-6880ad956b90@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marek,

On 05/10/2022 15:05, Marek Szyprowski wrote:
> 
> On 05.10.2022 14:37, Daniel Lezcano wrote:
>>
>> Hi Marek,
>>
>> On 03/10/2022 23:18, Daniel Lezcano wrote:
>>
>> [ ... ]
>>
>>>> I've tested this v8 patchset after fixing the issue with Exynos TMU
>>>> with
>>>> https://lore.kernel.org/all/20221003132943.1383065-1-daniel.lezcano@linaro.org/
>>>>
>>>> patch and I got the following lockdep warning on all Exynos-based
>>>> boards:
>>>>
>>>>
>>>> ======================================================
>>>> WARNING: possible circular locking dependency detected
>>>> 6.0.0-rc1-00083-ge5c9d117223e #12945 Not tainted
>>>> ------------------------------------------------------
>>>> swapper/0/1 is trying to acquire lock:
>>>> c1ce66b0 (&data->lock#2){+.+.}-{3:3}, at: exynos_get_temp+0x3c/0xc8
>>>>
>>>> but task is already holding lock:
>>>> c2979b94 (&tz->lock){+.+.}-{3:3}, at:
>>>> thermal_zone_device_update.part.0+0x3c/0x528
>>>>
>>>> which lock already depends on the new lock.
>>>
>>> I'm wondering if the problem is not already there and related to
>>> data->lock ...
>>>
>>> Doesn't the thermal zone lock already prevent racy access to the data
>>> structure?
>>>
>>> Another question: if the sensor clock is disabled after reading it,
>>> how does the hardware update the temperature and detect the programed
>>> threshold is crossed?
>>
>> just a gentle ping, as the fix will depend on your answer ;)
>>
> Sorry, I've been busy with other stuff. I thought I will fix this once I
> find a bit of spare time.

Ok, that is great if you can find time to fix it up because I've other 
drivers to convert to the generic thermal trips.


> IMHO the clock management is a bit over-engineered, as there is little
> (if any) benefit from such fine grade clock management. That clock is
> needed only for the AHB related part of the TMU (reading/writing the
> registers). The IRQ generation and temperature measurement is clocked
> from so called 'sclk' (special clock).
> 
> I also briefly looked at the code and the internal lock doesn't look to
> be really necessary assuming that the thermal core already serializes
> all the calls.

I looked at the code and I think the driver can be simplified (fixed?) 
even more.

IIUC, the sensor has multiple trip point interrupts, so if the device 
tree is describing more trip points than the sensor supports, there is a 
warning and the number of trip point is capped.

IMO that can be simplified by using two trip point interrupt because the 
thermal_zone_device_update() will call the set_trips callback with the 
new boundaries. IOW, the thermal framework sets a new trip point 
interrupt when one is crossed.

That should result in the simplification of the tmu_control as well as 
the tmu_probe function. As well as removing the limitation of the number 
of trip points.

In order to have that correctly working, the 'set_trips' ops must be 
used to call the tmu_control callback instead of calling it in tmu_probe.

The intialization workflow should be:

probe->...
  ->thermal_zone_device_register()
   ->thermal_zone_device_update()
    ->update_trip_points()
     ->ops->set_trips()
       ->tmu_control()

Also, replace the workqueue by a threaded interrupt.

Does it make sense?

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
