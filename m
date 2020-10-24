Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC646297DD3
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 19:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762631AbgJXRkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761279AbgJXRke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 13:40:34 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7626C0613CE
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 10:40:34 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id r7so4685245qkf.3
        for <netdev@vger.kernel.org>; Sat, 24 Oct 2020 10:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w4mFzWJNzkfL8PIoPoWE1IPmC/0OookPAmZJmTMQk1Y=;
        b=rfYGu4sL4Pgys5vIgSuKXQqa1HxTP7U96tNRj2U5BQ6FUtpnis+Nayq74R2W6vklAV
         a8m5XPzlRIqi7kQpWi78wknBypFqbrZhvqObVOclJZFhAc1DGu0aApbjuoEjvWAtMx9o
         xI6jiL/GmmdwFaB2QhTBKn4iyMv69RgPHWO5SRblOqjSBwO8+y7ALdx2bIYvSSUrc75j
         wInfjWmVN2zMhNFCq13+lJdrolPUuGQF0TifTBb8e0x6YKilmZeCUVTFj5vaU0RuRDLm
         j+iASuWWZoYJxPQRqVBX9tXwRnK9rMz3B10y9hLs9zPyQKNFpHYB0v70VQWo9nH30HtD
         BxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w4mFzWJNzkfL8PIoPoWE1IPmC/0OookPAmZJmTMQk1Y=;
        b=Atlmm0keW8JweXE5dmLDJvHRazkx7HI8Dk3fKFD6I69gn6KUrdtptlL9e2fKtfjp03
         cAhyTMuDPUl3L5/Hktw/meNRcaKLniwLCYqfe2GpLJGjYqTvw5/AAKFdbhnXT+2pm4G1
         TGxBe1ZJ1724Pf3C6d3ZmSDPPMhxqqPytj0jqfX+5KHNICJb/QjKhK0VYGc0BW+/SuNc
         kl1zSIO//vDK9IQXrSgdrmCyyMl3SUuJYmu52hak3Pp27XXsYPmYojYfGBaY43bPeJOw
         UkCiB0vqk5YNnBYDWx5InugDpz1qRtVap6YrAYmxyQE3r9jScq6cdO3/xCi7EBfpNCEu
         dhsQ==
X-Gm-Message-State: AOAM530vyEE1HWs8D8aD0OhwZ768xhqUVD9CgqjTYWvp+BnXYJPI8Ukt
        kFCZktu4YH9U7mFz9mPmv+WBHg==
X-Google-Smtp-Source: ABdhPJzBQmySK2p52RIaEhdDe6+b8Jm/bepyZSAbmkTuqFYae6QZoDYJKK9koThVQc6YG9Nn5MDygw==
X-Received: by 2002:a05:620a:250:: with SMTP id q16mr7330818qkn.343.1603561233876;
        Sat, 24 Oct 2020 10:40:33 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 22sm3273066qkg.15.2020.10.24.10.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 10:40:32 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
 <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
 <ygnh8sc03s9u.fsf@nvidia.com>
 <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
 <ygnh4kml9kh3.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
Date:   Sat, 24 Oct 2020 13:40:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ygnh4kml9kh3.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-23 8:48 a.m., Vlad Buslov wrote:
> On Thu 22 Oct 2020 at 17:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-21 4:19 a.m., Vlad Buslov wrote:
>>>
>>> On Tue 20 Oct 2020 at 15:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>> On 2020-10-19 11:18 a.m., Vlad Buslov wrote:
>>>> My worry is you have a very specific use case for your hardware or
>>>> maybe it is ovs - where counters are uniquely tied to filters and
>>>> there is no sharing. And possibly maybe only one counter can be tied
>>>> to a filter (was not sure if you could handle more than one action
>>>> in the terse from looking at the code).
>>>
>>> OVS uses cookie to uniquely identify the flow and it does support
>>> multiple actions per flow.
>>
>>
>> ok, so they use it like a flowid/classid to identify the flow.
>> In our use case the cookie stores all kinds of other state that
>> the controller can avoid to lookup after a query.
>> index otoh is universal i.e two different users can intepret it
>> per action tying it specific stats.
>> IOW: I dont think it replaces the index.
>> Do they set cookies on all actions in a flow?
> 
> AFAIK on only one action per flow.
> 

To each their own i guess. Sounds like it is being used as flowid
entity.
We pack a lot of metaencoding into those cookies. And to us
a "service" is essentially a filter match folowed by a graph
of actions (which could cyclic).


>>> Cookie only consumes space in resulting netlink packet if used set the
>>> cookie during action init. Otherwise, the cookie attribute is omitted.
>>
>> True, but: I am wondering why it is even considered in when terseness
>> was a requirement (and index was left out).
> 
> There was several reasons for me to include it:
> 
> - As I wrote in previous email its TLV is only included in dump if user
>    set the cookie. Users who don't use cookies don't lose any performance
>    of terse dump.
> 
> - Including it didn't require any changes to tc_action_ops->dump() (like
>    passing 'terse' flag or introducing dedicated terse_dump() callback)
>    because it is processed in tcf_action_dump_1().
> 
> - OVS was the main use-case for us because it relies on filter dump for
>    flow revalidation and uses cookie to identify the flows.
>

Which is fine - but it is a very ovs specific need.
>>
>>>> In our case we totally bypass filters to reduce the amount of data
>>>> crossing to user space (tc action ls). Theres still a lot of data
>>>> crossing which we could trim with a terse dump. All we are interested
>>>> in are stats. Another alternative is perhaps to introduce the index for
>>>> the direct dump.
>>>
>>> What is the direct dump?
>>
>> tc action ls ...
>> Like i said in our use cases to get the stats we just dumped the actions
>> we wanted. It is a lot less data than having the filter + actions.
>> And with your idea of terseness we can trim down further how much
>> data by removing all the action attributes coming back if we set TERSE
>> flag in such a request. But the index has to be there to make sense.
> 
> Yes, that makes sense. I guess introducing something like 'tc action -br
> ls ..' mode implemented by means of existing terse flag + new 'also
> output action index' flag would achieve that goal.
>

Right. There should be no interest in the cookie here at all. Maybe
it could be optional with a flag indication.
Have time to cook a patch? I'll taste/test it.

cheers,
jamal

