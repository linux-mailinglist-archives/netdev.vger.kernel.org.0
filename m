Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D221272C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgGBO6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729518AbgGBO6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:58:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01713C08C5DF
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 07:58:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 22so27178686wmg.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 07:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x8u1Qd58Jra03vuD/Ujnb8vgjM3oVoZL6nudEwpIjQU=;
        b=MuVybhw3sv5NBKOe6y2sDqWGb6wf25zluQ+REINq2DD7Z+G0/vL+1PjKXCx7BKu36I
         rkOhMxsrdH5ggNXyGtUArqqK6FFDtfoucPppNg9Ac+hzT2ib7NgaqP0jqhE6wN/Uu+8z
         v+G0SlqZQN+IlE68CkVhUzr6RbLF8Keh04beeKuAifk1Z731BvyUs42Io9/Px37GRxeX
         yncDnRQqK5X92hTB50me7klYSTEYamFN0yXSRdJF0BHVUgiLPDfmTBzIkJZE4CJvAKyL
         RaMTiVIc2TEWIqPmtRek99oHZherYcLqVesA9MCxFhhjk91a5Rg2NrQso0apj3CruhoK
         A3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8u1Qd58Jra03vuD/Ujnb8vgjM3oVoZL6nudEwpIjQU=;
        b=WpGrBSTideYsmV3/ERUhBO3BOhi9KrSsFqN5cWgBwDsejelpd8ovOy83ZR6lEu/RY5
         QjvKdVADYNux+tMwZxTeUO8SsMxexRYieTdbeJj5X0FLHhxGiJV2srz93w2ccHrJuY3l
         npb3jHgvsoijKp8OEON07iCFGY4zqe0nIni+g9MhHjeqTk8mQOTai915iZ/OZtltu5G3
         MTzuEq/sMMg6R0e3EvMZltSWPGEKOZV7rsQ/LPt9/2xEz/VotK5PJtOTegb1O4x5OtEm
         dce+w1TNDnF8QmnPwbczgRhKnp5EfA0RClkqLvRzE2McB0dg9sCf0CaPOIArs6q59XUQ
         UTyw==
X-Gm-Message-State: AOAM530fXyedSNxXV1MVbm42xNQpC+DvyxsarYy007n18OQtkCRcAtOu
        dhesZKkiBLrCXHOFSutjVBxOow==
X-Google-Smtp-Source: ABdhPJwDLcM1T+80bGDziotECthUV0hMUrJkGQgjNgyDlPfrA+vwPUEsl/LS3IvbqZBTaU5G7yjFLg==
X-Received: by 2002:a7b:cd07:: with SMTP id f7mr30660667wmj.115.1593701911400;
        Thu, 02 Jul 2020 07:58:31 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0? ([2a01:e34:ed2f:f020:c88a:7b2b:a4a1:46d0])
        by smtp.googlemail.com with ESMTPSA id v24sm13394737wrd.92.2020.07.02.07.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 07:58:30 -0700 (PDT)
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
Message-ID: <134e1e38-02d0-32ed-bd59-cf283a161b35@linaro.org>
Date:   Thu, 2 Jul 2020 16:58:26 +0200
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

Author: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Date:   Mon Jun 29 14:29:21 2020 +0200

    thermal: Use mode helpers in drivers

    Use thermal_zone_device_{en|dis}able() and
thermal_zone_device_is_enabled().



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
