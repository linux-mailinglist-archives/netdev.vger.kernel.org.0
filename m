Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34955031F
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 08:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiFRGMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 02:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiFRGMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 02:12:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4082B27A
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 23:12:25 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a17so3531774pls.6
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 23:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+uOEIfSc7pxI0y9Tw3dI/WukQys0WuOE4Fwu16Y2jU4=;
        b=WDNXgrpAwROeQ8zxU57EeBZyL3lH4sCJDYrHm+DUdhNfjoK+jCvmRu4TPnnFMe5sTz
         9/14RcGH8yeYeRqa846s0fnHEbzLNZPTHCeL4wt2PaZEocqLxY3e/kdeszOGim0Z6u1j
         MWukO/ZNxYlxD5E+xaMfi7C7H7I/x29wdIcPuZxMFm8T3c7ySaJD9ualkuxWH5w7tTUk
         e1hjAg1BSZ3eJLQJZObO1/SaUW49xjO8NNhGgqinea09UVgvObqQ1mCXGrJEn79r63q3
         k0vRLtoAMFp0awOo5z0fNJjE8kxnbOY7GN39QzDXAtZTBxfQfV9a74JAS6VYy/6KC6cf
         CjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+uOEIfSc7pxI0y9Tw3dI/WukQys0WuOE4Fwu16Y2jU4=;
        b=QtzcaCq/uyfaRxfkBxrKX+VwRR5THLHDnyf/m3fnEVw4fH4aZVD7Vt2JH/PU2xwDkJ
         7El5kBXpF4rJFG+U3hs09lhsxwunSNdFIOqq/u4OlGqQiWBPVHi9cvYTzOPbhx/HhSdf
         +ORZa+bJn3CHsJwktA6SItLhR6S2rdunQ2R9rbSCaYnQNhmCZuPl9HXE+5foqHxgqjP3
         FTOlU4h25FTMKz85dd7hvGboj3SQmX9EkwD0G8x1iXMnc42wyxTXbh8gKEvHuEubkxOE
         WMXt01e7OQyd6GT+A1e6aiK5anOYr2g0v3bUqsOcZhCKaXkGLQ5A+uDSeab83qBeCVqP
         Kfuw==
X-Gm-Message-State: AJIora+U6FOoEdZevcUHF6Fp7ClwLgVOLChF3De+HapNs1jIWs1lfZLE
        06dJ1BNoGBw9XgCnddxUun6jlQ==
X-Google-Smtp-Source: AGRyM1tLUw5Jo3/UbCtAFL4uNT1h/tqmrgkIHRhH17ED/UbuojGIDF6l6A8ZmbTJX7XRtLrQswcIbQ==
X-Received: by 2002:a17:90a:a016:b0:1ea:97b9:6c1b with SMTP id q22-20020a17090aa01600b001ea97b96c1bmr14443952pjp.212.1655532744332;
        Fri, 17 Jun 2022 23:12:24 -0700 (PDT)
Received: from [10.0.0.227] (50-206-141-130-static.hfc.comcastbusiness.net. [50.206.141.130])
        by smtp.gmail.com with ESMTPSA id d12-20020a62f80c000000b005185407eda5sm4717970pfh.44.2022.06.17.23.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 23:12:23 -0700 (PDT)
Message-ID: <fbaca11c-c706-b993-fa0d-ec7a1ba34203@pensando.io>
Date:   Fri, 17 Jun 2022 23:12:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
References: <20220614123326.69745-1-jiri@resnulli.us>
 <Yqmiv2+C1AXa6BY3@shredder> <YqoZkqwBPoX5lGrR@nanopsycho>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <YqoZkqwBPoX5lGrR@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/22 10:40 AM, Jiri Pirko wrote:
> Wed, Jun 15, 2022 at 11:13:35AM CEST, idosch@nvidia.com wrote:
>> On Tue, Jun 14, 2022 at 02:33:15PM +0200, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@nvidia.com>
>>>
>>> This patchset implements two features:
>>> 1) "devlink dev info" is exposed for line card (patches 3-8)
>>> 2) "devlink dev flash" is implemented for line card gearbox
>>>     flashing (patch 9)
>>>
>>> For every line card, "a nested" auxiliary device is created which
>>> allows to bind the features mentioned above (patch 2).
>>
[...]>>
>>>
>>> The relationship between line card and its auxiliary dev devlink
>>> is carried over extra line card netlink attribute (patches 1 and 3).
>>>
>>> Examples:
>>>
>>> $ devlink lc show pci/0000:01:00.0 lc 1
>>> pci/0000:01:00.0:
>>>    lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>>
>> Can we try to use the index of the line card as the identifier of the
>> auxiliary device?
> 
> Not really. We would have a collision if there are 2 mlxsw instances.
> 

Can you encode the base device's PCI info into the auxiliary device's id
to make it unique?  Or maybe have each mlxsw instance have a unique ida 
value to encode in the linecard auxiliary device id?

sln
