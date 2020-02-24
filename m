Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB2B16AA63
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBXPqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:46:00 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:34092 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgBXPqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:46:00 -0500
Received: by mail-io1-f42.google.com with SMTP id 13so10162997iou.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 07:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+DgbknlwiU6yyG30rDrjXfOHnZwS8rANqwXxEZKuu8=;
        b=DxUscNQzZelROVMEy5kPR5F6zPdWWbydVAZ9FcJw6VAZymXF/lqPhKPHTO4of5kcwV
         gX90iUdkNAq3EB48Rlf/R+ofsb7K0nnywU+diA8rgqam95piiZNJAr+VhmA95erVQH2N
         TF4JPQpWYOFu3EoXTt/hmC3W3SrGzHGSVoFDa18MHtjbI1gtGp5TELlEjCGeMb+dlpjD
         GUoXF+sB84raXxiyfIA2RnjCbuFyfiLU5bWAFeiYk++b7xBke2BAG+ngl++GHckAjBLC
         XuzRf3q7hRGrfXDI+fOEbxhTYSbl+3LStCp+XazYfToeG+pW5nVMCehE2EwJ2IDeSt7E
         KZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+DgbknlwiU6yyG30rDrjXfOHnZwS8rANqwXxEZKuu8=;
        b=VAt5zqLOWKkA1ldK7uwKZjiuCVg3GCWTYxzSzpZ66KsclWvYFqfwkkxgTBg2CdjH4F
         R2jeXenZOT/u+JJkKvUcKuAi8va7TK5+IXUN6dCH93D56/NUH29s+I8H3fIgaOLVgLq8
         UF7blLWJjMtOlrJUrgZbmrLwkvO9WLfK3J/7Pq/HAYYUMbcmiq6JnG/4vgsw/tZ2iMh/
         +mIwl6pq9aaZPDvv7gwaqRhPDfEqgNNxhUXKQEj81wlR/BvmchoF7TcGOZ7G1fk0poB6
         HLK+N62t2QTEP+v5Al3BNAYw+3iHk8PSA89bXnNo5upf0sV/NevfpUcRDqm7+dFCDabi
         NPMw==
X-Gm-Message-State: APjAAAUpwXp4jtYuOBrlh814bIff3a1KK9oCPJwundhPN7b+n875v8Ye
        PKivi4LE3qwQyc/JpPSU3MQJew==
X-Google-Smtp-Source: APXvYqz67PgQcfCb3+f4UTUyxgnSKJg2ARdWz5JD3wPxqbavRoe4qnX210bmZPcHZm4s89Eozfh+Dw==
X-Received: by 2002:a05:6602:2591:: with SMTP id p17mr50459523ioo.38.1582559159541;
        Mon, 24 Feb 2020 07:45:59 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id r7sm3089880ioo.7.2020.02.24.07.45.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:45:58 -0800 (PST)
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jiri Pirko <jiri@resnulli.us>, Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
Date:   Mon, 24 Feb 2020 10:45:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224131101.GC16270@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-24 8:11 a.m., Jiri Pirko wrote:
> Mon, Feb 24, 2020 at 12:38:20PM CET, ecree@solarflare.com wrote:
>> On 22/02/2020 06:38, Jiri Pirko wrote:

[..]
>> Potentially a user could only want stats on one action and disable them
>>   on another.  For instance, if their action chain does delivery to the
>>   'customer' and also mirrors the packets for monitoring, they might only
>>   want stats on the first delivery (e.g. for billing) and not want to
>>   waste a counter on the mirror.
> 
> Okay.
> 

+1  very important for telco billing use cases i am familiar with.

Ancient ACL implementations that had only one filter and
one action (drop/accept) didnt need more than one counter.
But not anymore in my opinion.

There's also a requirement for the concept of "sharing" - think
"family plans" or "small bussiness plan".
Counters may be shared across multiple filter-action chains for example.

> 
>>
>>> Plus, if the fine grained setup is ever needed, the hw_stats could be in
>>> future easilyt extended to be specified per-action too overriding
>>> the per-filter setup only for specific action. What do you think?
>> I think this is improper; the stats type should be defined per-action in
>>   the uapi, even if userland initially only has UI to set it across the
>>   entire filter.  (I imagine `tc action` would grow the corresponding UI
>>   pretty quickly.)  Then on the driver side, you must determine whether
>>   your hardware can support the user's request, and if not, return an
>>   appropriate error code.
>>
>> Let's try not to encourage people (users, future HW & driver developers)
>>   to keep thinking of stats as per-filter entities.
> > Okay, but in that case, it does not make sense to have "UI to set it
> across the entire filter". The UI would have to set it per-action too.
> Othewise it would make people think it is per-filter entity.
> But I guess the tc cmdline is chatty already an it can take other
> repetitive cmdline options.
> 

I normally visualize policy as a dag composed of filter(s) +
actions. The UI and uAPI has to be able to express that.

I am not sure if mlxsw works this way, but:
Most hardware i have encountered tends to have a separate
stats/counter table. The stats table is indexed.

Going backwards and looking at your example in this stanza:
---
   in_hw in_hw_count 2
   hw_stats immediate
         action order 1: gact action drop
          random type none pass val 0
          index 1 ref 1 bind 1 installed 14 sec used 7 sec
         Action statistics:
----

Guessing from "in_hw in_hw_count 2" - 2 is a hw stats table index?
If you have enough counters in hardware, the "stats table index"
essentially can be directly mapped to the action "index" attribute.

Sharing then becomes a matter of specifying the same drop action
with the correct index across multiple filters.

If you dont have enough hw counters - then perhaps a scheme to show
separate hardware counter index and software counter index (aka action
index) is needed.

cheers,
jamal

> What do you think?
> 
> 
> Thanks!
> 

