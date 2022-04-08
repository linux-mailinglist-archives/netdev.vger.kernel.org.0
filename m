Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97DF4F9FB6
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbiDHWqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiDHWqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:46:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1674B1CC
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 15:44:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so857625pjb.4
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 15:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=TruSdrM8C2DX0RyJ7IyFyvZiVE+VFsGwy0z2/WXycXs=;
        b=NQ+IWZKHTd3kOT93oaV5EIFOJsunvTEgPptl/nwR++NEx8rjWykxRXYRXOMeDpkgRy
         Ji1UTr3t6pwpcN13B8N/0whOsIEWToEwDln3AfaoxP1sq6llc5JlLpnN5TGTv3F5DYuu
         Zq8w12WsTiyJySH/tUn3m9EkeUiP1iqk6mEO2uOZrro4gKMaap5OLrPV6c2bqAoBxlZX
         63KAjAIJpwSYgDFxfrlIsI7S6l7LW98Lll0EaFs8zz0Cds2+fpbaArsnsg5s9YdJpUpp
         PuOMmFel1F5hq37LX7bGJQbZFT7G5SZXfNCdPgYbjhHJHHNiNTQM/7+QZ8P9s5AWW50e
         ipBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TruSdrM8C2DX0RyJ7IyFyvZiVE+VFsGwy0z2/WXycXs=;
        b=LnftIwRd56RRVvkAwzjwYYp7+a8cRggq7GZu6Zx64RaYZCk0T0UbX0l/kfyXLOybIH
         TDKQIxsbe4Defq2dFxZYHNrr+V7lbWjHdetqI+kl+2qbiYufrE9ilS4/2bud8l1lQxUx
         rp9nJT4OwYU6sRBNi9Ehgwr03QDcKrnzpBCvd0VgExVCuc/KK1lvYS5bWJtkekjM0Ycl
         8E1mn7V5/LHVsAL9ooomiv/NdQDNPYI0CwEdDwZgIQ5hymqUbAylSrIoOTg8E5TexzwG
         tOVlR9/3bChHJurE5IJ8o57J79HTbYbMvVkMqZHmaSrBhVg/ijnZu5w4oxE6umyLstd8
         K4Cw==
X-Gm-Message-State: AOAM532Tsl9/MbMWFD+FDAlGXOsOxleFeAGFWEicpNCiJNhY+oBA5Amw
        9piddyOJdciv3vENFKm96CEO888pu3c=
X-Google-Smtp-Source: ABdhPJzMPG9v5fmhFNWJr6p6HsZMpfYNqJYdbbCvmjEMHlJcUNaBqiwTeFGeyp2ObWppmrnkHP6xFA==
X-Received: by 2002:a17:90b:1a8a:b0:1c7:c60b:f12 with SMTP id ng10-20020a17090b1a8a00b001c7c60b0f12mr24098355pjb.139.1649457881198;
        Fri, 08 Apr 2022 15:44:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s24-20020a63af58000000b003981789eadfsm22578279pgo.21.2022.04.08.15.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 15:44:40 -0700 (PDT)
Message-ID: <5cb85634-1c74-bcd2-3fe2-0e9ef61993b2@gmail.com>
Date:   Fri, 8 Apr 2022 15:44:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: =?UTF-8?Q?Re=3a_TCP_stack_gets_into_state_of_continually_advertisin?=
 =?UTF-8?B?ZyDigJxzaWxseSB3aW5kb3figJ0gc2l6ZSBvZiAx?=
Content-Language: en-US
To:     Erin MacNeil <emacneil@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BY3PR05MB8002A408749086AA839466C2D0E69@BY3PR05MB8002.namprd05.prod.outlook.com>
 <1c29e93f-5bfa-fcd1-eaa8-49983db8d3bb@gmail.com>
 <be35a6ae-ec41-ef6f-9244-44f061376949@juniper.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <be35a6ae-ec41-ef6f-9244-44f061376949@juniper.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/7/22 18:10, Erin MacNeil wrote:
>
>
> On 2022-04-07 4:31 p.m., Eric Dumazet wrote:
>> [External Email. Be cautious of content]
>>
>>
>> On 4/7/22 10:57, Erin MacNeil wrote:
>>> In-Reply-To: 
>>> <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05.prod.outlook.com> 
>>>
>>>
>>>> On 4/6/22 10:40, Eric Dumazet wrote:
>>>>> On 4/6/22 07:19, Erin MacNeil wrote:
>>>>> This issue has been observed with the  4.8.28 kernel, I am 
>>>>> wondering if it may be a known issue with an available fix?
>>>>>
> ...
>>>
>>>> Presumably 16k buffers while MTU is 9000 is not correct.
>>>>
>>>> Kernel has some logic to ensure a minimal value, based on standard MTU
>>>> sizes.
>>>>
>>>>
>>>> Have you tried not using setsockopt() SO_RCVBUF & SO_SNDBUF ?
>>> Yes, a temporary workaround for the issue is to increase the value 
>>> of SO_SNDBUF which reduces the likelihood of device A’s receive 
>>> window dropping to 0, and hence device B sending problematic TCP 
>>> window probes.
>>>
>>
>> Not sure how 'temporary' it is.
>>
>> For ABI reason, and the fact that setsockopt() can be performed
>> _before_  the connect() or accept() is done, thus before knowing MTU
>> size, we can not after the MTU is known increase buffers, as it might
>>
>> break some applications expecting getsockopt() to return a stable value
>> (if a prior setsockopt() has set a value)
>>
>> If we chose to increase minimal limits, I think some users might 
>> complain.
>>
>
> Is this not a TCP bug though?  The stream was initially working "ok" 
> until the window closed.  There is no data the in the socket queue 
> should the window not re-open to where it had been.


We do not want to deal with user forcing TCP stack into a stupid 
ping-pong mode, one packet at a time.

If you have a patch that is reasonable, please let us know, but I bet  
this will break some applications.

Adding code in linux TCP fast path, testing for conditions that will 
never trigger in 99.9999999% of the time makes little sense.

MTU=9000 is 6 times bigger than MTU=1500, make sure you have increased 
SO_XXX values by 6x.



