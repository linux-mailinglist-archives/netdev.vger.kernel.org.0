Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688F7212529
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgGBNrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbgGBNrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:47:45 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905FEC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 06:47:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a6so28499090wrm.4
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 06:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZwC2KofFJKO2Kz1ZnDpUC9vH2nMKW6u7oZXxLzQv40I=;
        b=dmiLcwDhJk1NQcYlu03OuKMtUIE/NeC2LLeLbrwxiWP/CQWVh678undWuJpSMFfWKt
         pqJQFbXDS3SmeqvEKXm69oZpdNbYtPr6K3bey6rLz4r9xng9TFETrFIQ4hIDCxrfauBv
         GRYt0qlTOeZ49+GYrf+gmLrcYXd/cnfabq6G/6qUAp59taYwc4gBHa3cG+n+S7WK2WBM
         bGRllAgbervVwDtmS+KJwhmnJnQLcCPvhcoveFej6391OZEALA4RpW2ZaSp+wxwu9qX6
         lLqF4S+Po6BfziWbngftEcLQyKYRo1r1AtxgL+iQTjhEXqpcEujdUBJ/nnzFqdttjO26
         +8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZwC2KofFJKO2Kz1ZnDpUC9vH2nMKW6u7oZXxLzQv40I=;
        b=H/y8BWTPK+iDPSuSxXFHHkSQzjSr45LIEseocyCXpMj2SY9YUTaLCSh0HeRLYZ58l5
         n0MY+wLIYmqUKwGeUmXT8Gl/kGsiwq75mzvGPwaOs0iT74VCqGbWzToBg0tf6J4xiGBG
         1defMC9A+d+f50bjksq8kmsQjPabzFZsDHJhtYkUyfMUQLba0PHgaIo9j8+nqN7Mg7QF
         gZvhwsHjfOBoczO0Q9J2IT1u+QHXW0HTGl7tUBpjUy5G5xdLjApyF3JkUA+aZPBquJ/p
         GwU5RsJhX9BxXmKf0kFNhcJTSKwmb/37JDCd43v+Y6Moxeoo9poNxNgCsp0pKLCOlW5t
         UfOg==
X-Gm-Message-State: AOAM530YALUI38xNl3aycsjEiTtRhMhUkflxZjjvOnAromnXw5MAT6RH
        MrL7G3Tdm1ERd0GB4zCnYkvUug==
X-Google-Smtp-Source: ABdhPJxkjl0IEjS3JqN7KaPO6L0oyFA19XXhKeCpfVTk+YyOUUQhs0LWqu5F2t0O0dXW3DG2OnPg/w==
X-Received: by 2002:adf:c44d:: with SMTP id a13mr32528906wrg.205.1593697663121;
        Thu, 02 Jul 2020 06:47:43 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0? ([2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0])
        by smtp.googlemail.com with ESMTPSA id g16sm11988699wrh.91.2020.07.02.06.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 06:47:42 -0700 (PDT)
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
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <374dddd9-b600-3a30-d6c3-8cfcefc944d9@linaro.org>
Date:   Thu, 2 Jul 2020 15:47:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <73942aea-ae79-753c-fe90-d4a99423d548@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2020 12:23, Andrzej Pietrasiewicz wrote:
> Hi,
> 
> W dniu 30.06.2020 o 20:33, Daniel Lezcano pisze:
>> On 30/06/2020 18:56, Andrzej Pietrasiewicz wrote:
>>> Hi,
>>>
>>> W dniu 30.06.2020 o 17:53, Daniel Lezcano pisze:
>>>> On 30/06/2020 17:29, Andrzej Pietrasiewicz wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> W dniu 30.06.2020 o 16:53, Daniel Lezcano pisze:
>>>>>> On 30/06/2020 15:43, Andrzej Pietrasiewicz wrote:
>>>>>>> Hi Daniel,
>>>>>>>
>>>>>>> I am reading the logs and can't find anything specific to thermal.
>>>>>>>
>>>>>>> What I can see is
>>>>>>>
>>>>>>> "random: crng init done"
>>>>>>>
>>>>>>> with large times (~200s) and then e.g.
>>>>>>>
>>>>>>> 'auto-login-action timed out after 283 seconds'
>>>>>>>
>>>>>>> I'm looking at e.g.
>>>>>>> https://storage.kernelci.org/thermal/testing/v5.8-rc3-11-gf5e50bf4d3ef/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-sabrelite.html
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>
>>>>> f5e50bf4d3ef is PATCH 11/11. Does the problem happen at PATCH 1-10/11?
>>>>> PATCH 11/11 renames a method and the code compiles, so it seems
>>>>> unlikely that this is causing problems. One should never say never,
>>>>> though ;)
>>>>
>>>> The sha1 is just the HEAD for the kernel reference. The regression
>>>> happens with your series, somewhere.
>>>>
>>>>> The reported failure is not due to some test failing but rather due
>>>>> to timeout logging into the test system. Could it be that there is
>>>>> some other problem?
>>>>
>>>> I did reproduce:
>>>>
>>>> v5.8-rc3 + series => imx6 hang at boot time
>>>> v5.8-rc3 => imx6 boots correctly

So finally I succeeded to reproduce it on my imx7 locally. The sensor
was failing to initialize for another reason related to the legacy
cooling device, this is why it is not appearing on the imx7.

I can now git-bisect :)



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
