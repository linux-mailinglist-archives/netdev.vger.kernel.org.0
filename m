Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615C554D297
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 22:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344642AbiFOUbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 16:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiFOUbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 16:31:44 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCEC54690
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:31:43 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d13so11333351plh.13
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 13:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fpnE6nHtSjUSKqXU6fnALe7aO5eA8LKcqENY22+Rndc=;
        b=pTeJk2Mnb89txBPOCbbatDaIESO6S+lAtnWLv6zhbf9p6DNJR9Au1PP37FODNtChaz
         TGZiizpvnMvLuHcxvCkYg487yR14MrxMKLWkY+Dcms+p/rMLVfNBY9phFlm123b3Zzto
         KiQnQGUuPgwTCZ34w9gYgoxK92pjJ+D9CvYuD2eWjLflQesNMr9jP/lU7zKZOQRcVMh3
         6ELA/H6kcgP29/5wpJIfE1+fNTT9aewC8QKHw5a7CfofE+67rFAo99F7iZJE/omFQLwL
         7F+DQD2SkoRp+witu0DwUcq0JYu8w5ko6MTy6TQ8CNjRowd/R8GINA4upZQhkuEEBNg+
         zo4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fpnE6nHtSjUSKqXU6fnALe7aO5eA8LKcqENY22+Rndc=;
        b=nDX0s0EHoEGOApyOxHbPO0gZ5MBX6BNic7TE9rcRk4QnFNuNbO+PE9Vbg9p4oX66fU
         YeFyS6OL1bwSW6HKjNEob+BGLjzr7CxYf5/oZ40AsN4kV0trlyhTotu3pXK72n0i3TRR
         VwDjNdZva/hYGg1FfR71I9Q3VBCs2VkzS/xI7j+YQKRoKsrsZNrf3dJ4ch++MpDiVjr/
         7I4cCKlbBa7lOf5cvjXdlOo2ow2XbOSS/4JVv6RL/P1ohB4UIMMyWnWJMJb3rSOmkx5l
         xNmNpy2s0C5OjhQqzDbw10KxAdtfQwDupA8qcUe40CCxLgxoeqVXOTUIlDRG7TJvWTlU
         C4OQ==
X-Gm-Message-State: AJIora9U9ArUbauI8F5MtZcwN3cpHisEotWsZ4sJnCvtfLpohAADwyDV
        sUe1f5DK+mznu6mGi/D2tnziDw==
X-Google-Smtp-Source: AGRyM1s7fRBrNtAWzouVO7vvSCCkcXumrDmw1B4FVWlfOsEuXpJKBvXfKK3XpSIp/vVvVbWrtZBVMg==
X-Received: by 2002:a17:902:e5ca:b0:164:1958:c84a with SMTP id u10-20020a170902e5ca00b001641958c84amr1363392plf.72.1655325102617;
        Wed, 15 Jun 2022 13:31:42 -0700 (PDT)
Received: from [172.22.33.26] ([192.77.111.2])
        by smtp.googlemail.com with ESMTPSA id f11-20020a170902684b00b001635c9e7f77sm57050pln.57.2022.06.15.13.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 13:31:42 -0700 (PDT)
Message-ID: <f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org>
Date:   Wed, 15 Jun 2022 22:31:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal zone
 detection
Content-Language: en-US
To:     Vadim Pasternak <vadimp@mellanox.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux@roeck-us.net, rui.zhang@intel.com,
        edubezval@gmail.com, jiri@resnulli.us, idosch@mellanox.com
References: <20190529135223.5338-1-vadimp@mellanox.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20190529135223.5338-1-vadimp@mellanox.com>
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

On 29/05/2019 15:52, Vadim Pasternak wrote:
> When multiple sensors are mapped to the same cooling device, the
> cooling device should be set according the worst sensor from the
> sensors associated with this cooling device.
> 
> Provide the hottest thermal zone detection and enforce cooling device to
> follow the temperature trends the hottest zone only.
> Prevent competition for the cooling device control from others zones, by
> "stable trend" indication. A cooling device will not perform any
> actions associated with a zone with "stable trend".
> 
> When other thermal zone is detected as a hottest, a cooling device is to
> be switched to following temperature trends of new hottest zone.
> 
> Thermal zone score is represented by 32 bits unsigned integer and
> calculated according to the next formula:
> For T < TZ<t><i>, where t from {normal trip = 0, high trip = 1, hot
> trip = 2, critical = 3}:
> TZ<i> score = (T + (TZ<t><i> - T) / 2) / (TZ<t><i> - T) * 256 ** j;
> Highest thermal zone score s is set as MAX(TZ<i>score);
> Following this formula, if TZ<i> is in trip point higher than TZ<k>,
> the higher score is to be always assigned to TZ<i>.
> 
> For two thermal zones located at the same kind of trip point, the higher
> score will be assigned to the zone, which closer to the next trip point.
> Thus, the highest score will always be assigned objectively to the hottest
> thermal zone.

While reading the code I noticed this change and I was wondering why it 
was needed.

The thermal framework does already aggregates the mitigation decisions, 
taking the highest cooling state [1].

That allows for instance a spanning fan on a dual socket. Two thermal 
zones for one cooling device.

AFAICS, the code hijacked the get_trend function just for the sake of 
returning 1 for the hotter thermal zone leading to a computation of the 
trend in the thermal core code.

I would like to get rid of the get_trend ops in the thermal framework 
and the changes in this patch sounds like pointless as the aggregation 
of the cooling action is already handled in the thermal framework.

Given the above, it would make sense to revert commit 6f73862fabd93 and 
2dc2f760052da ?

Thanks

   -- Daniel

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/tree/drivers/thermal/thermal_helpers.c#n190


[ ... ]


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
