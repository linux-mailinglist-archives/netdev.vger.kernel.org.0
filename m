Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB54B7B45
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244572AbiBOXiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:38:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244570AbiBOXiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:38:50 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79699A4FB
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:38:38 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id h9so684286qvm.0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 15:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8SsLtS4tPebNRfj6b8mD9v4xQ54HCUXQMxFf3XsHYrs=;
        b=xFUbdbFaus0agFZUzVWQXL0yLB/RFVN5BYD8bqXtDPEhhYPCuujqG4x7eQPFSJbwLd
         DdumwDqN0h+I/jgJFgA8Eo078gzXGawQ9UtoMqhZCJxNT2mX8qcNt1LktCd3fEuaVWIr
         OmxGMgEpLK4TYDuvY0XIEE4jWYCgXEPyCwmrxbO3IEq+s8iJbIkCqD/mFY9awKCDtFaX
         HzQG22XXpyTTi+fCZoPUdfoPKbhp6lKUVRExogcguXZPr1GIFN+ItTE10xHBxa9KxynT
         x280hL2HZiHUQwbmK+delbMZy0FBzsTx86cwGGWisurRUEZiAnad7SgIfrGk4Dv7+XL0
         V33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8SsLtS4tPebNRfj6b8mD9v4xQ54HCUXQMxFf3XsHYrs=;
        b=qIhmGE2FFnBwcn59uVszJSMzzkYIuBTbTlFM8paZRhL/dpGUdRpcbSralc4QAGh56M
         Bp0XxHd64C5PEKZ2gokZ1LY5oCEPkNuNrZlpCVcwyh9CT15y/7rI1iZXzReAwjalt4M+
         LPiKq+EQVy4ETCcuHCWehPrjaIP2JIDUizWdp07ejysdOda8IyFVIfBI68CMQxD2Dg0c
         t1E/rayE2q2Bnmn7oyklNt92ZtmQJnTt9pf9e0AZ11/s5DqYftl3upyT3vX5lZlglXJl
         COjoGx87SJ8mpKcXOEMHGlzl5/X37l4DJi7roPShnBujQv+k+jYmLGK9R+ESZUjcTzQ4
         /oDA==
X-Gm-Message-State: AOAM531CdXqgHbxf0z44TcZ1M0NxzEN0esBdoApLd6WZsLwlE7yFl25i
        wsIXxqEAZ9xt4GChZOmbKeR4vwHWbDs5nw==
X-Google-Smtp-Source: ABdhPJyhTSoT1ieClt8DGBx49iBQe66oYdDdWNgGd7CXIVnMWA6qROS7+fFHsFw8N7cK6HzrFkLblg==
X-Received: by 2002:a05:6214:d82:b0:42c:1263:c7eb with SMTP id e2-20020a0562140d8200b0042c1263c7ebmr240841qve.47.1644968318105;
        Tue, 15 Feb 2022 15:38:38 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id bq33sm18764778qkb.64.2022.02.15.15.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 15:38:37 -0800 (PST)
Message-ID: <b394f7b5-393e-d079-c909-4cb05e061655@mojatatu.com>
Date:   Tue, 15 Feb 2022 18:38:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net] net: sched: limit TC_ACT_REPEAT loops
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        syzbot <syzkaller@googlegroups.com>
References: <20220214203434.838623-1-eric.dumazet@gmail.com>
 <YgsE30gfoQkruTYS@pop-os.localdomain>
 <CANn89i+2KYH+DKrNPttbmrvx992P+ufgo=QWyvr1Ku6b=1BY0Q@mail.gmail.com>
 <CANn89iJDWUE5mTSuWQaHO0SfyXLTso5Cp=rYzRGwWoZC_gHmmg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CANn89iJDWUE5mTSuWQaHO0SfyXLTso5Cp=rYzRGwWoZC_gHmmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-15 12:27, Eric Dumazet wrote:
> On Mon, Feb 14, 2022 at 5:54 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>>>> +             repeat_ttl = 10;
>>>
>>> Not sure if there is any use case of repeat action with 10+ repeats...
>>> Use a sufficiently larger one to be 100% safe?
>>
>> I have no idea of what the practical limit would be ?
>>
>> 100, 1000, time limit ?
> 
> Jamal, you already gave your Ack, but Cong is concerned about the 10 limit.
> 
> What should I used for v2 ?
> 
> Honestly I fail to see a valid reason for TC_ACT_REPEAT more than few times,
> but I have no idea of what real world actions using REPEAT look like.
> 

I havent seen more than a few. I was indifferent but maybe go for
something like 32.

cheers,
jamal


