Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535C654D48E
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349675AbiFOW1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345418AbiFOW1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:27:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D2D25C64
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:27:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e24so12468908pjt.0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 15:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MMvuOJrnUVUZI47wUypXdKLm16jsivR2Q4mH7CgSlQ8=;
        b=smo/JHGLTf4JN5DLcm8CMQt6H0M9OzaFyxqNLSO+uCPRoNhqrAsd+0VK7h/Ys/cxeC
         VtFMLcACb+L0LrvrqePqY0KtDidfqFmgP4wHzPZ9aGm3jKPGfCXW258n5L1WqWXDEgPd
         dzR4lBGtH+QHj5aI/5dI3SiCLN0GtBLonpCXHTG8qq9DDdV7RjcZXevfkhbDrp72CnKo
         2/kNNIwrnrJaTUL9dRhg8JbxwwWok10Mk8P1b+hmYfIybgS9Ap+N95yemJzxg06sn61k
         PFP6mGOYxMxhQoWpqoAys11grjJH50LQ5ik/KPSOBcabom6sKvm9bXyiOjMe9SKlGNgd
         PedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MMvuOJrnUVUZI47wUypXdKLm16jsivR2Q4mH7CgSlQ8=;
        b=7fPhyeB/07IyS1CM0UYK/GNk7Kpwqmeqj/A+C3syMZIfRJRzfGMDQnQ/B+0/iK9Vr4
         fwJIrV77s03qnzFdcBZiCMlTl9D83yuOGmF9ygTuHfAzsrpdIskzJmoe5BNphdwJyctU
         OeduiL1ewVF4MUFJPa7hW2JrB/s/sDXJuNhiqeaCAM/3AZSjjkOp/vaPA8B13egrL40B
         HzLNRviJiQVH+KcBp9EZ9iqI7Q7BENRt8FaovdM1ArdoJojrxI2T4IcTlVuv6ScWk7ti
         7KCzSPJnllxunxhnX8a8qUYVc3grf13kv8KGQOIC6KlRhIGremoS5EPFyoNnCUYRwaWr
         KccQ==
X-Gm-Message-State: AJIora8SdA5VxSI5FJ1uKEifoTV7zBIG7695NWucev/l2tSQdI9z29hD
        gxuGYF4dW5ssxZ29qYSI8wihhw==
X-Google-Smtp-Source: AGRyM1sB8RU0nspQKeyVOjpvwniOPXyv5odmqyt2HEa6tdjlMkNRMNEMFij0tx3xNeroxqxsoF+5xQ==
X-Received: by 2002:a17:90b:38c1:b0:1e8:5df7:cfd8 with SMTP id nn1-20020a17090b38c100b001e85df7cfd8mr12503606pjb.79.1655332060683;
        Wed, 15 Jun 2022 15:27:40 -0700 (PDT)
Received: from [172.22.33.26] ([192.77.111.2])
        by smtp.googlemail.com with ESMTPSA id bj2-20020a056a00318200b0051c77027d7fsm113012pfb.218.2022.06.15.15.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 15:27:40 -0700 (PDT)
Message-ID: <7cfa0391-798e-3993-5fa7-a8b31bcef534@linaro.org>
Date:   Thu, 16 Jun 2022 00:27:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal zone
 detection
Content-Language: en-US
To:     Vadim Pasternak <vadimp@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Ido Schimmel <idosch@nvidia.com>
References: <20190529135223.5338-1-vadimp@mellanox.com>
 <f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org>
 <BN9PR12MB53814C07F1FF66C06BCDC5FAAFAD9@BN9PR12MB5381.namprd12.prod.outlook.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <BN9PR12MB53814C07F1FF66C06BCDC5FAAFAD9@BN9PR12MB5381.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vadim,

On 16/06/2022 00:06, Vadim Pasternak wrote:
> Hi Daniel,
> 
>> -----Original Message-----
>> From: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Sent: Wednesday, June 15, 2022 11:32 PM
>> To: Vadim Pasternak <vadimp@nvidia.com>; davem@davemloft.net
>> Cc: netdev@vger.kernel.org; linux@roeck-us.net; rui.zhang@intel.com;
>> edubezval@gmail.com; jiri@resnulli.us; Ido Schimmel <idosch@nvidia.com>
>> Subject: Re: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal
>> zone detection
>>
>>
>> Hi Vadim,
>>
>> On 29/05/2019 15:52, Vadim Pasternak wrote:
>>> When multiple sensors are mapped to the same cooling device, the
>>> cooling device should be set according the worst sensor from the
>>> sensors associated with this cooling device.
>>>
>>> Provide the hottest thermal zone detection and enforce cooling device
>>> to follow the temperature trends the hottest zone only.
>>> Prevent competition for the cooling device control from others zones,
>>> by "stable trend" indication. A cooling device will not perform any
>>> actions associated with a zone with "stable trend".
>>>
>>> When other thermal zone is detected as a hottest, a cooling device is
>>> to be switched to following temperature trends of new hottest zone.
>>>
>>> Thermal zone score is represented by 32 bits unsigned integer and
>>> calculated according to the next formula:
>>> For T < TZ<t><i>, where t from {normal trip = 0, high trip = 1, hot
>>> trip = 2, critical = 3}:
>>> TZ<i> score = (T + (TZ<t><i> - T) / 2) / (TZ<t><i> - T) * 256 ** j;
>>> Highest thermal zone score s is set as MAX(TZ<i>score); Following this
>>> formula, if TZ<i> is in trip point higher than TZ<k>, the higher score
>>> is to be always assigned to TZ<i>.
>>>
>>> For two thermal zones located at the same kind of trip point, the
>>> higher score will be assigned to the zone, which closer to the next trip
>> point.
>>> Thus, the highest score will always be assigned objectively to the
>>> hottest thermal zone.
>>
>> While reading the code I noticed this change and I was wondering why it was
>> needed.
>>
>> The thermal framework does already aggregates the mitigation decisions,
>> taking the highest cooling state [1].
>>
>> That allows for instance a spanning fan on a dual socket. Two thermal zones
>> for one cooling device.
> 
> Here the hottest thermal zone is calculated for different thermal zone_devices, for example, each
> optical transceiver or gearbox is separated 'tzdev', while all of them share the same cooling device.
> It could up to 128 transceivers.
> 
> It was also intention to avoid a competition between thermal zones when some of them
> can be in trend up state and some  in trend down.
> 
> Are you saying that the below code will work for such case?
> 
> 	/* Make sure cdev enters the deepest cooling state */
> 	list_for_each_entry(instance, &cdev->thermal_instances, cdev_node) {
> 		dev_dbg(&cdev->device, "zone%d->target=%lu\n",
> 			instance->tz->id, instance->target);
> 		if (instance->target == THERMAL_NO_TARGET)
> 			continue;
> 		if (instance->target > target)
> 			target = instance->target;
> 	}

Yes, that is my understanding.

For the thermal zones which are under the temperature limit, their 
instance->target will be THERMAL_NO_TARGET and will be discarded by this 
loop.

For the ones being mitigated, the highest cooling state will be used.

The purpose of this loop is exactly for your use case. If it happens it 
does not work as expected, then it is something in the core code to be 
fixed.


>> AFAICS, the code hijacked the get_trend function just for the sake of
>> returning 1 for the hotter thermal zone leading to a computation of the trend
>> in the thermal core code.
> 
> Yes, get_trend() returns one just to indicate that cooling device should not be
> touched for a thermal zone, which is not hottest.
> 
>>
>> I would like to get rid of the get_trend ops in the thermal framework and the
>> changes in this patch sounds like pointless as the aggregation of the cooling
>> action is already handled in the thermal framework.
>>
>> Given the above, it would make sense to revert commit 6f73862fabd93 and
>> 2dc2f760052da ?
> 
> I believe we should run thermal emulation to validate we are OK.

Sure, let me know

Thanks

   -- Daniel

> 
> Thanks,
> Vadim.
> 
>>
>> Thanks
>>
>>     -- Daniel
>>
>> [1]
>> https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/tree/drive
>> rs/thermal/thermal_helpers.c#n190
>>
>>
>> [ ... ]
>>
>>
>> --
>> <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
