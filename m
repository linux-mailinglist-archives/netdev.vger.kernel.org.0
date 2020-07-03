Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E5621344B
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgGCGiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCGiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 02:38:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C811FC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 23:38:53 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j18so30817609wmi.3
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 23:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eorUmfUDMZcNbxM4Fi+PFLp5IkxH/y0wJ21yqWKUjto=;
        b=TW3k/K6sgcyOzEJs1rw4KfmOe6mN35kwzPQC2F/IgbreSFQA8LXxI7YB4jg768YPf/
         qlg1GD44Sj2mlQxBQfGEjhGX+c1yfO9Z2Mc+s3nSyOkzpJAHcbxMv5x83AFf4RMl33Gm
         yETeAQpLmJArPgsTWZB5qQKZ8Av/jgJcSZrGjUH26ysjAUnp1x07PQ8p12XuVcqaQK5X
         GMh0+9HUQqJoYLlyJFUBhedpmjHLeeAZnlpCjwpSz8Hl1wDM4IBIpPuTU1aSgw+6hhf5
         PQOMSuzQnnW914bYoIpCxkKUDZ3G876lD7uO8p49b0PgquhyTREZXOsoMzsDs/Eo5jcO
         p6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eorUmfUDMZcNbxM4Fi+PFLp5IkxH/y0wJ21yqWKUjto=;
        b=RBi9mP7CNFo9ogx20FgXRNhr1PrekT/1iFKnkCjbYpxupdqt7jvmkLLzn6klzEo0EV
         B9Z46KJ0D6+JsKaFoF8fgxBrwU3IBiAgBJy+UOrcXdq9xJ/34vt8D1hmoyUGnEonEVvW
         MazTvU4BE1mIzI4a2CbwS/2m2QS+m8KhSXq52MTA+apFs4/yUoYzy8dLviNPtSJN4NJY
         fX8yVp7BM44rS52WZf+fWArA/qYu9NspsNFTkN2BVBHM/6nW9hY29t1LcoChcTWN9f6f
         N3o7srDSJy+tYKJ1ywN/mTgq+bHzutzMevQPdE/MpMk+aL7/fbgYVFVtnZePpnjFE4s8
         CHMA==
X-Gm-Message-State: AOAM530iPacxPE6PPosXDDpQorWYfCTyacS68xV0X3+rau+gUyUzuc8B
        EuC9qqebX3t840Ihne78Dn1msA==
X-Google-Smtp-Source: ABdhPJwx/dU/vear+SglZ3FxU9XUXFqcn8iwzYeLZYSHOLOaUd4iFi5d4+vvIppL6IdFuFPEJc4a0g==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr24326224wmb.60.1593758332203;
        Thu, 02 Jul 2020 23:38:52 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:7019:4e9b:2970:f860? ([2a01:e34:ed2f:f020:7019:4e9b:2970:f860])
        by smtp.googlemail.com with ESMTPSA id 65sm13709437wre.6.2020.07.02.23.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 23:38:51 -0700 (PDT)
Subject: Re: [PATCH v7 00/11] Stop monitoring disabled devices
To:     Zhang Rui <rui.zhang@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
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
 <d41bf28f-ee91-6946-2334-f11ec81f96fe@linaro.org>
 <44c622dd7de8c7bf143c4435c0edd1b98d09a3d6.camel@intel.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <58265668-fc6d-729a-c126-0c73c2ea853b@linaro.org>
Date:   Fri, 3 Jul 2020 08:38:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <44c622dd7de8c7bf143c4435c0edd1b98d09a3d6.camel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/07/2020 03:49, Zhang Rui wrote:
> On Thu, 2020-07-02 at 19:49 +0200, Daniel Lezcano wrote:

[ ... ]

>>> So the reason is that ->get_temp() is called while the mutex is
>>> held and
>>> thermal_zone_device_is_enabled() wants to take the same mutex.
>>
>> Yes, that's correct.
>>
>>> Is adding a comment to thermal_zone_device_is_enabled() to never
>>> call
>>> it while the mutex is held and adding another version of it which
>>> does
>>> not take the mutex ok?
>>
>> The thermal_zone_device_is_enabled() is only used in two places, acpi
>> and this imx driver, and given:
>>
>> 1. as soon as the mutex is released, there is no guarantee the
>> thermal
>> zone won't be changed right after, the lock is pointless, thus the
>> information also.
>>
>> 2. from a design point of view, I don't see why a driver should know
>> if
>> a thermal zone is disabled or not
>>
>> It would make sense to end with this function and do not give the
>> different drivers an opportunity to access this information.
> 
> I agree.
>>
>> Why not add change_mode for the acpi in order to enable or disable
>> the
>> events
> 
> thermal_zone_device_is_enabled() is invoked in acpi thermal driver
> because we only want to do thermal_zone_device_update() when the acpi
> thermal zone is enabled.
> 
> As thermal_zone_device_update() can handle a disabled thermal zone now,
> we can just remove the check.

Ah yes, good point!



-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
