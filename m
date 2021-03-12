Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEDF3398CC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhCLVBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbhCLVBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 16:01:05 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE8FC061761
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 13:01:04 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id e9so2503048wrw.10
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 13:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OW16M2oHQuCJpM+XkMtF+2gBz8Vr9GAENBLb54tN4k0=;
        b=a2xUD1NIAyX1PU+RXEUjBJnwAyPaiu7CGe4gS/xted4LweaXqUDTmMu/L2xT28GfDK
         aCQk2Pfmxce3Q33+KClCT08OPlVlX+fylA49UZwNoCT12pIqpWIwAbb0kZLMxFAKJT69
         bCVyXy4T/kUAx1ZFePPd+Oa203ZkrXhrAtRWWB/2l/+6Hb+Skq9zrOCODCg2uvBacG7w
         kfrIXtIQI7Dq4IFUsLD4slkq947MuBJpKLOXKO7TDZePieKwEfvMM35+IkXnS6zriObj
         gLz/lwiVDr0TJeatb115lBvIxKSoaxjR13htAmvBEGu8qJ5BlXV/qOICOraoA/5f0f9q
         OIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OW16M2oHQuCJpM+XkMtF+2gBz8Vr9GAENBLb54tN4k0=;
        b=C6y6Ph8UAWzHQFszqc6ApJeS4apZ2e9TThpiiRGRXjqfrXcJQJ/0mMHAbpZ6FegbTD
         oMEuMTYycDkiQFQz5pfOGgNNDI9R9qudQh8j4Mj0VM2xugvTSUUeT2d/wt+O8lwuZ8eT
         KKfjk4AkSY/jIj12hRZLl5nOLphRPmlW9JtB3dnie/4uQGQ4dhrV8Xs8MXG202ukFaZu
         4hM2gQezbG4eUgAIq/810lLoQugZAkdrg3yQQ1bvJVbLJfZoYe/L/5yn6399oXyLfZm9
         i5LS92VyjCLpOA7NA6rpFrTxmbCtJbwKtoaPe3l4dqQArGhqFlYs2I4mthMe8dmxfR0y
         U8rQ==
X-Gm-Message-State: AOAM532R3u5waitvX7/thUz5D0eEepmIYiOBSylsChdATg3QK9ZrbktW
        eLywD0xKTL81XO4fY8/4S9RCwcKe5LZZ9Q==
X-Google-Smtp-Source: ABdhPJxhfA3kkeuqBusRtxq6EFIznZgwWgg+rpuPM02a8+c1eg+ny7oLWW4UwxxUmR+bvfg+H5WJ1g==
X-Received: by 2002:adf:fbce:: with SMTP id d14mr15343716wrs.44.1615582863265;
        Fri, 12 Mar 2021 13:01:03 -0800 (PST)
Received: from ?IPv6:2a01:e34:ed2f:f020:846c:d89e:20aa:2765? ([2a01:e34:ed2f:f020:846c:d89e:20aa:2765])
        by smtp.googlemail.com with ESMTPSA id u2sm4434387wmm.5.2021.03.12.13.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:01:02 -0800 (PST)
Subject: Re: [PATCH v2 1/5] thermal/drivers/core: Use a char pointer for the
 cooling device name
To:     Lukasz Luba <lukasz.luba@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
References: <20210312170316.3138-1-daniel.lezcano@linaro.org>
 <18fdc11b-abda-25d9-582f-de2f9dfa2feb@arm.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <f51fcec0-1483-cecb-d984-591097c324ca@linaro.org>
Date:   Fri, 12 Mar 2021 22:01:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <18fdc11b-abda-25d9-582f-de2f9dfa2feb@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2021 19:49, Lukasz Luba wrote:
> 
> 
> On 3/12/21 5:03 PM, Daniel Lezcano wrote:
>> We want to have any kind of name for the cooling devices as we do no
>> longer want to rely on auto-numbering. Let's replace the cooling
>> device's fixed array by a char pointer to be allocated dynamically
>> when registering the cooling device, so we don't limit the length of
>> the name.
>>
>> Rework the error path at the same time as we have to rollback the
>> allocations in case of error.
>>
>> Tested with a dummy device having the name:
>>   "Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch"
>>
>> A village on the island of Anglesey (Wales), known to have the longest
>> name in Europe.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   .../ethernet/mellanox/mlxsw/core_thermal.c    |  2 +-
>>   drivers/thermal/thermal_core.c                | 38 +++++++++++--------
>>   include/linux/thermal.h                       |  2 +-
>>   3 files changed, 24 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> index bf85ce9835d7..7447c2a73cbd 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
>> @@ -141,7 +141,7 @@ static int mlxsw_get_cooling_device_idx(struct
>> mlxsw_thermal *thermal,
>>       /* Allow mlxsw thermal zone binding to an external cooling
>> device */
>>       for (i = 0; i < ARRAY_SIZE(mlxsw_thermal_external_allowed_cdev);
>> i++) {
>>           if (strnstr(cdev->type, mlxsw_thermal_external_allowed_cdev[i],
>> -                sizeof(cdev->type)))
>> +                strlen(cdev->type)))
>>               return 0;
>>       }
>>   diff --git a/drivers/thermal/thermal_core.c
>> b/drivers/thermal/thermal_core.c
>> index 996c038f83a4..9ef8090eb645 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -960,10 +960,7 @@ __thermal_cooling_device_register(struct
>> device_node *np,
>>   {
>>       struct thermal_cooling_device *cdev;
>>       struct thermal_zone_device *pos = NULL;
>> -    int result;
>> -
>> -    if (type && strlen(type) >= THERMAL_NAME_LENGTH)
>> -        return ERR_PTR(-EINVAL);
>> +    int ret;
>>         if (!ops || !ops->get_max_state || !ops->get_cur_state ||
>>           !ops->set_cur_state)
>> @@ -973,14 +970,17 @@ __thermal_cooling_device_register(struct
>> device_node *np,
>>       if (!cdev)
>>           return ERR_PTR(-ENOMEM);
>>   -    result = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
>> -    if (result < 0) {
>> -        kfree(cdev);
>> -        return ERR_PTR(result);
>> +    ret = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
>> +    if (ret < 0)
>> +        goto out_kfree_cdev;
>> +    cdev->id = ret;
>> +
>> +    cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
>> +    if (!cdev->type) {
>> +        ret = -ENOMEM;
> 
> Since we haven't called the device_register() yet, I would call here:
> kfree(cdev);
> and then jump

I'm not sure to understand, we have to remove the ida, no ?

> Other than that, LGTM
> 
> Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
> 
> Regards,
> Lukasz


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
