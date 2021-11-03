Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4B444275
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhKCNgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhKCNgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:36:31 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4DDC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 06:33:54 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id s1so764389qta.13
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Dtyqav1xIcS+lIQBgzs/o7w+kKJKhZZY0S7Ome7qVh0=;
        b=XApYQtqrnWUfP6i/6Em0n+8de0+luHfJBKHdDm0RxKiadoHt0gDvlgeuK87jFom5fT
         rGvnJFwc3iN1WK5/HN85MiFA71cGdfPdhh/ljKciNSng+YItR2GjheM+9KgWv1mMqFjK
         NytuVvI6f3WFUa8YTLeWXnipUD6b/8WhiwgpMo4/1J44WnFxubRPjezHoLCAc3y8f1ri
         ucoiI+nxwyCQ108gHgcs90jlpas3nhlvYSMmvrYrZ+rLTHmVMgLmttzSrW0CQgagIyIe
         cQ/oRg2k38T1DFGLhNzhCeAlgMHfiSGPNpoTnHGC0QadUNqzEfYl8GLLqnERoKpiZL5s
         XIsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Dtyqav1xIcS+lIQBgzs/o7w+kKJKhZZY0S7Ome7qVh0=;
        b=UUFY5eoC/xxE4eitrbloa7ZBm1TlFmLbjdi4cBjiWfFXLflUVtChSnOmoqVjkp/KVx
         b9aD7VZQW+M0Ur+lyww+lECEcVVle2PylmC7o/+3OVONhxTxwQqm8fwPRLgQshba1AAX
         jzTSbgsn4ukT42ALhMRPltaTo65xOGISKUCymEukhji+UycHVEEJt+EIKyBulvLWWZs/
         T3mgKkyOUJ/wsjiyqRvOou8WE66Go8RFabkgurFuMm6F1V94DchUr8hMYpo0oNB80/et
         efMB45gxROEAIEztvT4DaEtehbN3u/Ft7FjnHkH9p0CJSt7JyXmrg1XyivctP8CBG9tO
         aP8w==
X-Gm-Message-State: AOAM532uW1GmpcIdcOcRkq1NcNz5uKM8s48+64mUvndYmk+/ugPabexj
        9V2Z5uHiadyncVLgWIRHxFqC0w==
X-Google-Smtp-Source: ABdhPJwFGRRqpJEElp0JIwpVmyPbeVM2tpwm2RSN/1zxddrB8PcJxsWAyKrmd3YVm43Rea2kBbZ9/g==
X-Received: by 2002:ac8:5853:: with SMTP id h19mr35920490qth.273.1635946433621;
        Wed, 03 Nov 2021 06:33:53 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id a11sm1762946qtx.9.2021.11.03.06.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 06:33:53 -0700 (PDT)
Message-ID: <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
Date:   Wed, 3 Nov 2021 09:33:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
In-Reply-To: <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-03 08:33, Jamal Hadi Salim wrote:
> On 2021-11-03 07:30, Baowen Zheng wrote:
>> On November 3, 2021 6:14 PM, Jamal Hadi Salim wrote:
>>> On 2021-11-03 03:57, Baowen Zheng wrote:
>>>> On November 2, 2021 8:40 PM, Simon Horman wrote:
>>>>> On Mon, Nov 01, 2021 at 09:38:34AM +0200, Vlad Buslov wrote:
>>>>>> On Mon 01 Nov 2021 at 05:29, Baowen Zheng
>>>
>>> [..]
>>>>>>
>>>>>> My suggestion was to forgo the skip_sw flag for shared action
>>>>>> offload and, consecutively, remove the validation code, not to add
>>>>>> even more checks. I still don't see a practical case where skip_sw
>>>>>> shared action is useful. But I don't have any strong feelings about
>>>>>> this flag, so if Jamal thinks it is necessary, then fine by me.
>>>>>
>>>>> FWIIW, my feelings are the same as Vlad's.
>>>>>
>>>>> I think these flags add complexity that would be nice to avoid.
>>>>> But if Jamal thinks its necessary, then including the flags
>>>>> implementation is fine by me.
>>>> Thanks Simon. Jamal, do you think it is necessary to keep the skip_sw
>>>> flag for user to specify the action should not run in software?
>>>>
>>>
>>> Just catching up with discussion...
>>> IMO, we need the flag. Oz indicated with requirement to be able to 
>>> identify
>>> the action with an index. So if a specific action is added for 
>>> skip_sw (as
>>> standalone or alongside a filter) then it cant be used for skip_hw. 
>>> To illustrate
>>> using extended example:
>>>
>>> #filter 1, skip_sw
>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>      skip_sw ip_proto tcp action police blah index 10
>>>
>>> #filter 2, skip_hw
>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>      skip_hw ip_proto udp action police index 10
>>>
>>> Filter2 should be illegal.
>>> And when i dump the actions as so:
>>> tc actions ls action police
>>>
>>> For debugability, I should see index 10 clearly marked with the flag 
>>> as skip_sw
>>>
>>> The other example i gave earlier which showed the sharing of actions:
>>>
>>> #add a policer action and offload it
>>> tc actions add action police skip_sw rate ... index 20 #now add 
>>> filter1 which is
>>> offloaded using offloaded policer tc filter add dev $DEV1 proto ip 
>>> parent ffff:
>>> flower \
>>>      skip_sw ip_proto tcp action police index 20 #add filter2 
>>> likewise offloaded
>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>      skip_sw ip_proto udp action police index 20
>>>
>>> All good and filter 1 and 2 are sharing policer instance with index 20.
>>>
>>> #Now add a filter3 which is s/w only
>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>      skip_hw ip_proto icmp action police index 20
>>>
>>> filter3 should not be allowed.
>> I think the use cases you mentioned above are clear for us. For the case:
>>
>> #add a policer action and offload it
>> tc actions add action police skip_sw rate ... index 20
>> #Now add a filter4 which has no flag
>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>       ip_proto icmp action police index 20
>>
>> Is filter4 legal? 
> 
> Yes it is _based on current semantics_.
> The reason is when adding a filter and specifying neither
> skip_sw nor skip_hw it defaults to allowing both.
> i.e is the same as skip_sw|skip_hw. You will need to have
> counters for both s/w and h/w (which i think is taken care of today).
> 
> 

Apologies, i will like to take this one back. Couldnt stop thinking
about it while sipping coffee;->
To be safe that should be illegal. The flags have to match _exactly_
for both  action and filter to make any sense. i.e in the above case
they are not.

cheers,
jamal

