Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F387820F8E7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389792AbgF3PxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389385AbgF3PxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:53:19 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8936FC03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:53:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so18612833wmf.0
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZlhxamwqaiEMIpmJScsP8WaHtcSePSX2SSE4z4msAfU=;
        b=pZMbiCji8j2GB9THF+qXVSgiyMCUWOFHbpWrTaTQ5T5hngskdKThzcqyS/urr5eKVO
         equszs6sppekKylDyaCAdUDTCjVL0NqhJlKigviPxF3AkeCBXankW5oAu5fSYw3sJL0j
         pN95T60h1NnV60aqhcJ4+JOxAl5l7GXafksuzsMsCyJRmbrM5outQ43liZtosxzBoari
         8aQ+OZ567cvqIdHFwLXayD0BST12Yq8qqnxN5sT9F87L+PZg3Gg+jzIY6Vgikazpm40Y
         MsD/kbGeVX1bCXKJWA61xX/b+MlinG5QKJ97kYzr2MaCyy/nlKOVVhxNA8tCCM+yOB4j
         Osyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZlhxamwqaiEMIpmJScsP8WaHtcSePSX2SSE4z4msAfU=;
        b=XvVinTJOENcDIOYm1MBFQThktVw5RiWV/s1M5NKcS4laa6mnHXsyfs3to1BiATATs0
         nJ2nsDZEn5xetMhB8Ei+o7pUW3M5AJUCsJw1I56M19bKu4TEgtqVViYc1YxTNCrcTMWk
         X2vEr4g7fVyZR8rH+bK6OsxfB5cKxMw+vHk044Fmlw+k8iMH4GwTs4ju2gucHAeUEnPS
         hlG3e2W9NwKP9OCsP0PzedZNRpfhoVSjlvtQwy+z6z6Au59oTomfwCHjUVz0YQEyDHGN
         CTbG5Uru4lsuQO6NN/1TeGAwM14krWHBvGItD2d5H3b3ESHefT2DliUXaTevifW/S2DU
         BwhA==
X-Gm-Message-State: AOAM530kQefFLsgb9n2XCMfpqrMQ3tSTpJVtt5vc9LpzBKXY+8iNIctx
        aJWrAwJl587NOKe8+BuoRtq7Bw==
X-Google-Smtp-Source: ABdhPJxl2gp79Z5Dv6ITz5QGs5s+4SmumsdhYFya47TQ/xK22cY2dC2eBhxp9kUukoWVgtVejXnuBg==
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr21389052wmi.19.1593532397120;
        Tue, 30 Jun 2020 08:53:17 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:54f4:a99f:ab88:bc07? ([2a01:e34:ed2f:f020:54f4:a99f:ab88:bc07])
        by smtp.googlemail.com with ESMTPSA id a2sm4010629wrn.68.2020.06.30.08.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 08:53:16 -0700 (PDT)
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
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <4353a939-3f5e-8369-5bc0-ad8162b5ffc7@linaro.org>
Date:   Tue, 30 Jun 2020 17:53:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <be9b7ee3-cad0-e462-126d-08de9b226285@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2020 17:29, Andrzej Pietrasiewicz wrote:
> Hi Daniel,
> 
> W dniu 30.06.2020 o 16:53, Daniel Lezcano pisze:
>> On 30/06/2020 15:43, Andrzej Pietrasiewicz wrote:
>>> Hi Daniel,
>>>
>>> I am reading the logs and can't find anything specific to thermal.
>>>
>>> What I can see is
>>>
>>> "random: crng init done"
>>>
>>> with large times (~200s) and then e.g.
>>>
>>> 'auto-login-action timed out after 283 seconds'
>>>
>>> I'm looking at e.g.
>>> https://storage.kernelci.org/thermal/testing/v5.8-rc3-11-gf5e50bf4d3ef/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-sabrelite.html
>>>
>>>
> 
> f5e50bf4d3ef is PATCH 11/11. Does the problem happen at PATCH 1-10/11?
> PATCH 11/11 renames a method and the code compiles, so it seems
> unlikely that this is causing problems. One should never say never,
> though ;)

The sha1 is just the HEAD for the kernel reference. The regression
happens with your series, somewhere.

> The reported failure is not due to some test failing but rather due
> to timeout logging into the test system. Could it be that there is
> some other problem?

I did reproduce:

v5.8-rc3 + series => imx6 hang at boot time
v5.8-rc3 => imx6 boots correctly


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
