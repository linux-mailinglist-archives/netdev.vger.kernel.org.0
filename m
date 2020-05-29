Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231AB1E8748
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgE2TIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgE2TIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:08:50 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180D5C03E969;
        Fri, 29 May 2020 12:08:50 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t7so1612235plr.0;
        Fri, 29 May 2020 12:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GI1G8YjdYC1/BVVh4xt8/46vLX7fto1AiKAB85tn/IA=;
        b=itTcRWHxC2KMPstmcRYoqLS+QQVVGGSmS7tq3ZFU0HVObAB58AQfGHoULlcCWTbrpW
         oNi9814k5tWtnJzOXn3Q9X2vYqaQSIodZzBeoe8tF5LtagndHxfTbJWVvPF028+hLPZJ
         rtSYRmcQTMMkSBKbRI8j9AUEZJqZ+WngEgkjqzl2v4ZuKFZWOLdg6b5fSyV8n9j6puY8
         rGRcUSe0VZEIiMvZDlIlCeb1VOprX/JIYo1G83oRBxqlC60keJNPffEmhuPHR12etRqz
         wlIZnphpBj6OCI8nYVYaqWStHKI1cCt5pl/cff3b5mfL4iY8vTDU5RLS63nS/FXk5ody
         0dBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GI1G8YjdYC1/BVVh4xt8/46vLX7fto1AiKAB85tn/IA=;
        b=bWYSPfS/TBMqh2ik1H/jKz9BxxR77VLDWU/rvxGmrwrQ8RNAu/uoX3L31b1/D0I58R
         Rf58iFqdqJx/WzW7fi8vmOmnuXKEfla4d55ev80/arbOy8QLaZvw7FJbfNQWP2a7jt9N
         T+jRdCP61uEcfdDg5Z9ZLjty9gFv6rC9z38q1k9A+ICmi70UHUJwl1qay/n7gn815uNg
         oVe5NZqKksn7oXuwv0wA4rtZZpfTkvsjMJbqT/qT0kcM3MqFNzHULZd33EkFHUp8NY6G
         NG+bDtp5TTuKNmTFR0gCX6e2sUu0MmYVysPnittB0ZQ6xqBaz06sCL30wcs6xY3DewTf
         5Mug==
X-Gm-Message-State: AOAM532vscWp7D9IyDql3e65pAfr5kDELRTVX9MY59xUIBkOhXJHQa5q
        jXHtPfzOBRy+2ifz3bHKzdU=
X-Google-Smtp-Source: ABdhPJyHV5xGLC87UW+F9nDZMYCJnbX5AfeeDURZAW851oj7hugQ2QwQ/lkIOGUs3EXvBn8f2RBZ+w==
X-Received: by 2002:a17:902:bb86:: with SMTP id m6mr9870951pls.341.1590779329529;
        Fri, 29 May 2020 12:08:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x11sm4433734pfm.196.2020.05.29.12.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 12:08:48 -0700 (PDT)
Subject: Re: [PATCH v4 04/11] thermal: Store device mode in struct
 thermal_zone_device
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
References: <20200529154205.GA157653@roeck-us.net>
 <5010f7df-59d6-92ef-c99a-0dbd715f0ad2@collabora.com>
 <a0c0310f-9870-47be-4ca3-c07e41c380fc@collabora.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <3776b295-eb43-ce3c-0d9a-c923a3bd5ffd@roeck-us.net>
Date:   Fri, 29 May 2020 12:08:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a0c0310f-9870-47be-4ca3-c07e41c380fc@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/20 10:21 AM, Andrzej Pietrasiewicz wrote:
> Hi again,
> 
> W dniu 29.05.2020 o 18:08, Andrzej Pietrasiewicz pisze:
>> Hi Guenter,
>>
>> W dniu 29.05.2020 o 17:42, Guenter Roeck pisze:
>>> On Thu, May 28, 2020 at 09:20:44PM +0200, Andrzej Pietrasiewicz wrote:
>>>> Prepare for eliminating get_mode().
>>>>
>>> Might be worthwhile to explain (not only in the subject) what you are
>>> doing here.
>>>
>>>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
>>>> ---
>>>>   drivers/acpi/thermal.c                        | 18 ++++++----------
>>>>   .../ethernet/mellanox/mlxsw/core_thermal.c    | 21 +++++++------------
>>>>   drivers/platform/x86/acerhdf.c                | 15 ++++++-------
>>>>   drivers/thermal/da9062-thermal.c              |  6 ++----
>>>>   drivers/thermal/imx_thermal.c                 | 17 +++++++--------
>>>>   .../intel/int340x_thermal/int3400_thermal.c   | 12 +++--------
>>>>   .../thermal/intel/intel_quark_dts_thermal.c   | 16 +++++++-------
>>>>   drivers/thermal/thermal_of.c                  | 10 +++------
>>>
>>> After this patch is applied on top of the thermal 'testing' branch,
>>> there are still local instances of thermal_device_mode in
>>>     drivers/thermal/st/stm_thermal.c
>>>     drivers/thermal/ti-soc-thermal/ti-thermal-common.c
>>>
>>> If there is a reason not to replace those, it might make sense to explain
>>> it here.
>>>
>>
>> My understanding is that these two are sensor devices which are "plugged"
>> into their "parent" thermal zone device. The latter is the "proper" tzd.
>> They both use thermal_zone_of_device_ops instead of thermal_zone_device_ops.
>> The former doesn't even have get_mode(). The thermal core, when it calls
>> get_mode(), operates on the "parent" thermal zone devices.
>>
>> Consequently, the drivers you mention use their "mode" members for
>> their private purpose, not for the purpose of storing the "parent"
>> thermal zone device mode.
>>
> 
> Let me also say it differently.
> 
> Both drivers which you mention use devm_thermal_zone_of_sensor_register().
> It calls thermal_zone_of_sensor_register(), which "will search the list of
> thermal zones described in device tree and look for the zone that refer to
> the sensor device pointed by @dev->of_node as temperature providers. For
> the zone pointing to the sensor node, the sensor will be added to the DT
> thermal zone device." When a match is found thermal_zone_of_add_sensor()
> is invoked, which (using thermal_zone_get_zone_by_name()) iterates over
> all registered thermal_zone_devices. The one eventually found will be
> returned and propagated to the original caller of
> devm_thermal_zone_of_sensor_register(). The state of this returned
> device is managed elsewhere (in that device's struct tzd). The "mode"
> member you are referring to is thus unrelated.
> 

Quite confusing, especially since the ti-soc driver doesn't seem to use
the variable at all after setting it, and the stm_thermal driver uses it
to reflect power status associated with suspend/resume. So, yes, I agree
this is fine.

Thanks,
Guenter

> Regards,
> 
> Andrzej

