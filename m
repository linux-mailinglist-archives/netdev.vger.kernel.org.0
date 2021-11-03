Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67084441A0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhKCMgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhKCMgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:36:32 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1899C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 05:33:55 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id u25so2837731qve.2
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 05:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Oi+Q6UKvzbCawmbGBPLr1JcXHPqAwCswGOALaYFpZMI=;
        b=7TEuT3p8EIPQG4fnbgXwzaiGjLpK5r+52yRtjiNucm63W38evXr3x5UMy/3ljE6gva
         +JeB3B7PHmR7skWO3oHjc5DQcw2yl/M6jKSO3Z8B+y7VNmV8wc8BLj6K5SLgkSGme/E6
         8SULvSQt8ZsdQs7sCkaxWiOgFYQmsbD8eKKfYEKL9j8MExNhBuz+O4xEBSqCfkZ35r7J
         jZMxtxh4hmv9yCwkZAB4Ap8LujijQhldik114dJgOag5QHJE2zph/yn2rCSabJc78VXW
         /3+wMJF2l/rdIJG+t5fDWYhiid4EFdK4Q15Cf5VIPnlHqJIItg5tfwsWx9CNa3eBcmJZ
         QHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Oi+Q6UKvzbCawmbGBPLr1JcXHPqAwCswGOALaYFpZMI=;
        b=IaXe0IhmRzjrvPeylkc6eauOL/d4A5C6rE/o9BUdUi/71sHnR+ZVIUe/mrbOCfBF2m
         juhYc0kvooXO9XB4k266GEC23L8xY43hdCpHgZTsuAB6uhWqIT8RQXR+5o/Dd/6W0oqm
         PdbSGE+3N/SLuIcT2q1SFh97fe00osC0lrdp6uXa5aHZ5vBEQsVXL23Phig1ggnSXsxQ
         IKQtIpqaj/oJqbBtmsL3OCH/1mOPHtZx+YDCBVf7Mkeh3HZQC48M5fanoJVmKF+zlGGE
         xWIcACVEcN4kW8BB+Eqq7sHzoewj2XxolnAl6v3d9XS/XTFPTsGrB9fTC/Q9gbSvxN2L
         20Vw==
X-Gm-Message-State: AOAM533rHvRi+bv0hnJmWG+TQtRO9FjLOrPnRTieuKBBPPjA0Ra4a/hF
        A+KbKnZFWoA5sEuvD5ng+KkPFw==
X-Google-Smtp-Source: ABdhPJx1jJbmZ33C8Ny3AmpZ3lB+riI2Btkw1C2nCAoRHaAao+Fw7qkxyczSdmmwMQbmSc642P+Fmg==
X-Received: by 2002:ad4:42cb:: with SMTP id f11mr18606260qvr.23.1635942835122;
        Wed, 03 Nov 2021 05:33:55 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id 13sm1326961qkc.40.2021.11.03.05.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 05:33:54 -0700 (PDT)
Message-ID: <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
Date:   Wed, 3 Nov 2021 08:33:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Content-Language: en-US
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
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-03 07:30, Baowen Zheng wrote:
> On November 3, 2021 6:14 PM, Jamal Hadi Salim wrote:
>> On 2021-11-03 03:57, Baowen Zheng wrote:
>>> On November 2, 2021 8:40 PM, Simon Horman wrote:
>>>> On Mon, Nov 01, 2021 at 09:38:34AM +0200, Vlad Buslov wrote:
>>>>> On Mon 01 Nov 2021 at 05:29, Baowen Zheng
>>
>> [..]
>>>>>
>>>>> My suggestion was to forgo the skip_sw flag for shared action
>>>>> offload and, consecutively, remove the validation code, not to add
>>>>> even more checks. I still don't see a practical case where skip_sw
>>>>> shared action is useful. But I don't have any strong feelings about
>>>>> this flag, so if Jamal thinks it is necessary, then fine by me.
>>>>
>>>> FWIIW, my feelings are the same as Vlad's.
>>>>
>>>> I think these flags add complexity that would be nice to avoid.
>>>> But if Jamal thinks its necessary, then including the flags
>>>> implementation is fine by me.
>>> Thanks Simon. Jamal, do you think it is necessary to keep the skip_sw
>>> flag for user to specify the action should not run in software?
>>>
>>
>> Just catching up with discussion...
>> IMO, we need the flag. Oz indicated with requirement to be able to identify
>> the action with an index. So if a specific action is added for skip_sw (as
>> standalone or alongside a filter) then it cant be used for skip_hw. To illustrate
>> using extended example:
>>
>> #filter 1, skip_sw
>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>      skip_sw ip_proto tcp action police blah index 10
>>
>> #filter 2, skip_hw
>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>      skip_hw ip_proto udp action police index 10
>>
>> Filter2 should be illegal.
>> And when i dump the actions as so:
>> tc actions ls action police
>>
>> For debugability, I should see index 10 clearly marked with the flag as skip_sw
>>
>> The other example i gave earlier which showed the sharing of actions:
>>
>> #add a policer action and offload it
>> tc actions add action police skip_sw rate ... index 20 #now add filter1 which is
>> offloaded using offloaded policer tc filter add dev $DEV1 proto ip parent ffff:
>> flower \
>>      skip_sw ip_proto tcp action police index 20 #add filter2 likewise offloaded
>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>      skip_sw ip_proto udp action police index 20
>>
>> All good and filter 1 and 2 are sharing policer instance with index 20.
>>
>> #Now add a filter3 which is s/w only
>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>      skip_hw ip_proto icmp action police index 20
>>
>> filter3 should not be allowed.
> I think the use cases you mentioned above are clear for us. For the case:
> 
> #add a policer action and offload it
> tc actions add action police skip_sw rate ... index 20
> #Now add a filter4 which has no flag
> tc filter add dev $DEV1 proto ip parent ffff: flower \
>       ip_proto icmp action police index 20
> 
> Is filter4 legal? 

Yes it is _based on current semantics_.
The reason is when adding a filter and specifying neither
skip_sw nor skip_hw it defaults to allowing both.
i.e is the same as skip_sw|skip_hw. You will need to have
counters for both s/w and h/w (which i think is taken care of today).


>basically, it should be legal, but since filter4 may be offloaded failed so
> it will run in software, you know the action police should not run in software with skip_sw,
> so I think filter4 should be illegal and we should not allow this case.
> That is if the action is skip_sw, then the filter refers to this action should also skip_sw.
> WDYT?

See above..

cheers,
jamal

