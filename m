Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C444558ADE5
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbiHEQHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbiHEQHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:07:16 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C959032D84
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 09:07:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p10so3728681wru.8
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 09:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=foE9NLSu+Hm19YIAVmVBxv5cqU+R70Qhy9c+iSwfgU8=;
        b=aIKKpgqOwqtohc0kEcEbtcv4xGlQ2qiXde4MKN4UU6u37Axtk1NjJ9Di04o7fRfGVb
         9RcVNIsoldcjZuMR1JP86JcdPuSS+g5O2PAF7Orpud3x2bMQaHBM/aWQYbJUSoe+zShL
         Occ/s+iJZRU1uiyFu7xyY9p4murvMWZpoIirIXzkGln3wZ3oiIeCs9YPJopsYxT0fYjz
         Valh7TSSoQomjuwv2eLixJrqCrNIyt+5/N4S0iQqk7PNjvYZ357718rqI4I5zY28J2wR
         SsTXVHfJ+pc3Fl+52/KRNN6JJajI+8XCXVMlR3AyKw1jVsYbCFRa0yFdXjHVdxu4AWbY
         5QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=foE9NLSu+Hm19YIAVmVBxv5cqU+R70Qhy9c+iSwfgU8=;
        b=2mNf1UROH+g65Y04lZP0Sy5qYGuJdunyGNswGRbA4FQ5A1WqfhfZVl4bQ7S1TYlQAw
         YwIKGRS8bQU+PndZQG3Buhg77etihkaXyHVnpZ2MhT4Ojc95bbENBn38B07IGPmEHuSl
         CJVDWQlH5yrvKIZh/P3gBFks0lNlX15Ik7QQIQXemv38npYYYNBMGZGMJ69HuT5oV28+
         d8e/HV8KTI96oleWnMuUksylqqjy2c7Cjs/eFZ1KhbEX6/pJAEzt+CaxJEH32H+khOL2
         s1sEEP9l/Yg2cEk0oRHcjtsUSEAUYYKvIO9lGHMD1YOQ2dqwsC9pX24AuqjtOGN3eQI0
         6gjg==
X-Gm-Message-State: ACgBeo2nGIeUYbiK6V7IzGKtstoDPpX71zAnvhw+5ZG+oLPaASkjV1rD
        idrCr+HYARaRgZfBE5OAZDLoc9Kp+WxCtQ==
X-Google-Smtp-Source: AA6agR7avs62yuynakGDNbLvwYzOeyYpJ1lkFW/hY7pOB/UOWJMsaHtToegMOmwouDTDbCsAYD72MQ==
X-Received: by 2002:a5d:4301:0:b0:21b:8af6:4a21 with SMTP id h1-20020a5d4301000000b0021b8af64a21mr5060330wrq.296.1659715633284;
        Fri, 05 Aug 2022 09:07:13 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:aef0:8606:da6b:79ef? ([2a05:6e02:1041:c10:aef0:8606:da6b:79ef])
        by smtp.googlemail.com with ESMTPSA id bh19-20020a05600c3d1300b003a2f6367049sm5051263wmb.48.2022.08.05.09.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 09:07:12 -0700 (PDT)
Message-ID: <6cf66002-f13d-a1ee-7fa6-dfa78d6be427@linaro.org>
Date:   Fri, 5 Aug 2022 18:07:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Content-Language: en-US
To:     Vadim Pasternak <vadimp@nvidia.com>,
        "rafael@kernel.org" <rafael@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
 <20220801095622.949079-2-daniel.lezcano@linaro.org>
 <BN9PR12MB538167CB6E0EE463ED25898CAF9F9@BN9PR12MB5381.namprd12.prod.outlook.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <BN9PR12MB538167CB6E0EE463ED25898CAF9F9@BN9PR12MB5381.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vadim,


On 04/08/2022 14:21, Vadim Pasternak wrote:
> 
> 
>> -----Original Message-----
>> From: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Sent: Monday, August 1, 2022 12:56 PM
>> To: daniel.lezcano@linaro.org; rafael@kernel.org
>> Cc: Vadim Pasternak <vadimp@nvidia.com>; davem@davemloft.net;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Ido Schimmel
>> <idosch@nvidia.com>; Petr Machata <petrm@nvidia.com>; Eric Dumazet
>> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>
>> Subject: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
>> detection"
>>
>> This reverts commit 6f73862fabd93213de157d9cc6ef76084311c628.
>>
>> As discussed in the thread:
>>
>> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-
>> bff366c8aeba@linaro.org/
>>
>> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
>> actually already handled by the thermal framework via the cooling device
>> state aggregation, thus all this code is pointless.
>>
>> The revert conflicts with the following changes:
>>   - 7f4957be0d5b8: thermal: Use mode helpers in drivers
>>   - 6a79507cfe94c: mlxsw: core: Extend thermal module with per QSFP module
>> thermal zones
>>
>> These conflicts were fixed and the resulting changes are in this patch.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Tested-by: Vadim Pasternak <vadimp@nvidia.com>

Thanks for testing

> Daniel,
> Could you, please, re-base the patch on top of net-next as Jakub mentioned?
> Or do you want me to do it?

It is fine, I can do it. The conflict is trivial.

However, I would have preferred to have the patch in my tree so I can 
continue the consolidation work.

Is it ok if I pick the patch and the conflict being simple, that can be 
handle at merge time, no?

> There is also redundant blank line in this patch:
> 							&mlxsw_thermal_module_ops,
> +
>   							&mlxsw_thermal_params,

Yeah, thanks.

-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
