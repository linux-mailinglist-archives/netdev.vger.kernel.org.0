Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FA416EAB9
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgBYQBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:01:09 -0500
Received: from mail-il1-f173.google.com ([209.85.166.173]:40268 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730638AbgBYQBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:01:09 -0500
Received: by mail-il1-f173.google.com with SMTP id i7so2597989ilr.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2u1Ev0vulCwxueW70Ya5jKtsKB7DQsdwt7dE9mgYpx0=;
        b=Ig8wLRLEVRxUc8XXylaEo3rQDeXW1LsrchwYKhFqCMxqSWubwK0NqU8NwJhPGLjuWJ
         SvB5t1p0T6jYKzctECiLE0jANfFRMBLpj+rqgrwL26cf9+ctVdnBrsMdV6qeqkbuXHdq
         A6QevU6qWxmCHa22IgRlzktGGxcAOCMZIYwENG5fvZzWBXS7nBrLxct2Eva5ABi9YQSZ
         VbwjnZqEzfAswRhsRfGvoZ+D/lMae4cFCaLmeOlWbGoU6VljvjHwc57Nddes8mVF2soL
         aGYpW2qGzO8DNvIBznEz5hVQLuF8bn/IKGAvbTILdRMi4bhfSSC9tXrsHajO2JhstOQN
         J73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2u1Ev0vulCwxueW70Ya5jKtsKB7DQsdwt7dE9mgYpx0=;
        b=qQr7caFTKkPHoohPipXwJakXo+lnWv7mUx7odthO2sdpxCn7wBCUl8NZvnQ430M0ct
         iNC44MwAQ67e/dOUpH9OFflbxJzlsZyftq5FaZ400/7jPeojaC6P28bihndS32eXeT5V
         oPgFxt5CVfpy8eMSpQTN6ZCzzBZYhwpnX3I3vfT8+497UgCbn5NiUWtFaQjlM/47P5II
         GEl7r8SLzVg2vl5af/8yXf42OLOCwH6lpyn3b42OJ1ggY6rCqlDwCkinbq78+E5PP5dX
         Bum0Tuy1egeDaPP2YuNNse2szW+nIpqBcwJdyQKoO5XpQEkWeIw1W7JHgqkbL7l87g9C
         DGmA==
X-Gm-Message-State: APjAAAX6bZ/3cIPYddh0yX5wppw1P+r2fS9rQmBvOQW5NZZ3a7sDPdVP
        WE4p4sAc5iXDb8KG3ZiXeAu1Iw==
X-Google-Smtp-Source: APXvYqzRuLJ5b8jkde//PnpUt5KOsiSPmvpkW8i3/AfbI9P/CJo2IcO0Ovf6QhPoJCn5uPXznlRvow==
X-Received: by 2002:a92:5ec8:: with SMTP id f69mr71518014ilg.8.1582646467815;
        Tue, 25 Feb 2020 08:01:07 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id v3sm5673761ili.0.2020.02.25.08.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 08:01:07 -0800 (PST)
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        pablo@netfilter.org, mlxsw@mellanox.com,
        Marian Pritsak <marianp@mellanox.com>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
Date:   Tue, 25 Feb 2020 11:01:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224162521.GE16270@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc Marian.

On 2020-02-24 11:25 a.m., Jiri Pirko wrote:
> Mon, Feb 24, 2020 at 04:45:57PM CET, jhs@mojatatu.com wrote:
>> On 2020-02-24 8:11 a.m., Jiri Pirko wrote:
>>> Mon, Feb 24, 2020 at 12:38:20PM CET, ecree@solarflare.com wrote:
>>>> On 22/02/2020 06:38, Jiri Pirko wrote:
>>

>> There's also a requirement for the concept of "sharing" - think
>> "family plans" or "small bussiness plan".
>> Counters may be shared across multiple filter-action chains for example.
> 
> In hardware, we have a separate "counter" action with counter index.

Ok, so it is similar semantics.
In your case, you abstract it as a speacial action, but in most
abstractions(including P4) it looks like an indexed table.
 From a tc perspective you could abstract the equivalent to
your "counter action" as a gact "ok" or "pipe",etc depending
on your policy goal. The counter index becomes the gact index
if there is no conflict.
In most actions "index" attribute is really mapped to a
"counter" index. Exception would be actions with state
(like policer).

> You can reuse this index in multiple counter action instances.

That is great because it maps to tc semantics. When you create
an action of the same type, you can specify the index and it
is re-used. Example:

sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
match ip dst 127.0.0.8/32 flowid 1:8 \
action vlan push id 8 protocol 802.1q index 8\
action mirred egress mirror dev eth0 index 111

sudo tc filter add dev lo parent ffff: protocol ip prio 8 u32 \
match ip dst 127.0.0.15/32 flowid 1:10 \
action vlan push id 15 protocol 802.1q index 15 \
action mirred egress mirror index 111 \
action drop index 111

So for the shared mirror action the counter is shared
by virtue of specifying index 111.

What tc _doesnt allow_ is to re-use the same
counter index across different types of actions (example
mirror index 111 is not the same instance as drop 111).
Thats why i was asking if you are exposing the hw index.

> However, in tc there is implicit separate counter for every action.
> 

Yes, and is proving to be a challenge for hw. In s/w it makes sense.
It seemed sensible at the time; existing hardware back then
(broadcom 5691 family and cant remember the other vendor, iirc)
hard coded the actions with counters. Mind you they would
only support one action per match.

Some rethinking is needed of this status quo.
So maybe having syntaticaly an index for s/w vs h/w may make
sense.
Knowing the indices is important. As an example, for telemetry
you may be very interesting in dumping only the counter stats
instead of the rule. Dumping gact has always made it easy in
my use cases because it doesnt have a lot of attributes. But it
could make sense to introduce a new semantic like "dump action stats .."

> The counter is limited resource. So we overcome this mismatch in mlxsw
> by having action "counter" always first for every rule inserted:
> rule->action_counter,the_actual_action,the_actual_action2,...the_actual_actionN
>

So i am guessing the hw cant support "branching" i.e based on in
some action state sometime you may execute action foo and other times
action bar. Those kind of scenarios would need multiple counters.
> and we report stats from action_counter for all the_actual_actionX.

This may not be accurate if you are branching - for example
a policer or quota enforcer which either accepts or drops or sends next
to a marker action etc .
IMO, this was fine in the old days when you had one action per match.
Best is to leave it to whoever creates the policy to decide what to
count. IOW, I think modelling it as a pipe or ok or drop or continue
and be placed anywhere in the policy graph instead of the begining.

>> Sharing then becomes a matter of specifying the same drop action
>> with the correct index across multiple filters.
>>
>> If you dont have enough hw counters - then perhaps a scheme to show
>> separate hardware counter index and software counter index (aka action
>> index) is needed.
> 
> I don't, that is the purpose of this patchset, to be able to avoid the
> "action_counter" from the example I wrote above.

IMO, it would make sense to reuse existing gact for example and
annotate s/w vs h/w indices as a starting point. It keeps the
existing approach intact.

> Note that I don't want to share, there is still separate "last_hit"
> record in hw I expose in "used X sec". Interestingly enough, in
> Spectrum-1 this is per rule, in Spectrum-2,3 this is per action block :)

I didnt understand this one..

cheers,
jamal
