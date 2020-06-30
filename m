Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D0720FBCC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390839AbgF3Sdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390833AbgF3Sdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:33:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D965DC08C5DB
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:33:49 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z15so9875260wrl.8
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fJpxH5/djWt9U3VYoQjuqMYzJN+p95+ihodoPPW+SNQ=;
        b=QtRvGqVxjzxpiFVybIea7lqehIQLky2ZFc2aG1M6771qlNANmaszRuCoEuuKojC4wO
         e3gUMOhd6TiyI5C3zuqPkGO0Q61l1AUfwUIyFir+LMpB+pXEgIoiTyIse+E+W0JIoF1S
         Ulyhd/nP9MSIRL7CQFpcHG+cwScKqaWXcQ/tUEnD/6C37OGTdUaiJf+DPwkPtWe/8/+H
         pW6dOiQPIe+l5evZRZ/JGlvO4MKwSS91ACC5sj6UoHMgGtVpVLEnFRxyvyjuZIe8ACvV
         zt1UeqXVyKh3Xxm3WcxDd6DXGrfYHQSZ3gPsXzrDcM2C9jWuSc6Z39R9xenraJNNEyLy
         YGMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fJpxH5/djWt9U3VYoQjuqMYzJN+p95+ihodoPPW+SNQ=;
        b=tVeCnJaHcQmB/Rjka7yPXCFFsFoeG4g8QrNCgttHSYt4TS0Hn3nYQUVpTz5nFpEEdq
         pQyxoU+zDxx8wqAt+mWWg83BvjuFbyFAXn9JNduZ9iQqOeYHiK3EgMFuWnUFw+oI8jC1
         urWR82T8u7Rvg2ugHQdgvgHNxvVldtgE3RJzmB0Jvah8chZFy0nVeMVQqihZHYRcXLUi
         Mulaer1tb2EG58dHfVQ+TyBlf6dQOfBqgtSXrgJ0qfiJAzAXrxMHwC4h4Al+yhmZPhff
         KytZrx6b7hu3jj6xIfQD3NjljcRbniaVA0fy6X2UfdE8jyydyaANO8CYXx3ziCRVMi5a
         Pz2Q==
X-Gm-Message-State: AOAM532tPs7wo6CSlMpiHriKa6mSyWEepTTz3nZrhcXu5PkP8jX2IUDH
        LMibon0vVUsKmvV+gcuKzXqXMA==
X-Google-Smtp-Source: ABdhPJxLhcXrkHLv2/YCvgyaaG9WujOJsdKLAP5iiMsukPW0YrKfbKY169ibr3i+yNbysUtJLv4bdw==
X-Received: by 2002:a5d:6ac1:: with SMTP id u1mr22357628wrw.123.1593542028223;
        Tue, 30 Jun 2020 11:33:48 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:54f4:a99f:ab88:bc07? ([2a01:e34:ed2f:f020:54f4:a99f:ab88:bc07])
        by smtp.googlemail.com with ESMTPSA id b10sm4104203wmj.30.2020.06.30.11.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:33:47 -0700 (PDT)
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
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <db1ff4e1-cbf8-89b3-5d64-b91a1fd88a41@linaro.org>
Date:   Tue, 30 Jun 2020 20:33:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a531d80f-afd1-2dec-6c77-ed984e97595c@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2020 18:56, Andrzej Pietrasiewicz wrote:
> Hi,
> 
> W dniu 30.06.2020 o 17:53, Daniel Lezcano pisze:
>> On 30/06/2020 17:29, Andrzej Pietrasiewicz wrote:
>>> Hi Daniel,
>>>
>>> W dniu 30.06.2020 o 16:53, Daniel Lezcano pisze:
>>>> On 30/06/2020 15:43, Andrzej Pietrasiewicz wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> I am reading the logs and can't find anything specific to thermal.
>>>>>
>>>>> What I can see is
>>>>>
>>>>> "random: crng init done"
>>>>>
>>>>> with large times (~200s) and then e.g.
>>>>>
>>>>> 'auto-login-action timed out after 283 seconds'
>>>>>
>>>>> I'm looking at e.g.
>>>>> https://storage.kernelci.org/thermal/testing/v5.8-rc3-11-gf5e50bf4d3ef/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-sabrelite.html
>>>>>
>>>>>
>>>>>
>>>
>>> f5e50bf4d3ef is PATCH 11/11. Does the problem happen at PATCH 1-10/11?
>>> PATCH 11/11 renames a method and the code compiles, so it seems
>>> unlikely that this is causing problems. One should never say never,
>>> though ;)
>>
>> The sha1 is just the HEAD for the kernel reference. The regression
>> happens with your series, somewhere.
>>
>>> The reported failure is not due to some test failing but rather due
>>> to timeout logging into the test system. Could it be that there is
>>> some other problem?
>>
>> I did reproduce:
>>
>> v5.8-rc3 + series => imx6 hang at boot time
>> v5.8-rc3 => imx6 boots correctly
>>
> 
> I kindly ask for a bisect.

I will give a try but it is a very long process as the board is running
on kernelci.

I was not able to reproduce it on imx7 despite it is the same sensor :/


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
