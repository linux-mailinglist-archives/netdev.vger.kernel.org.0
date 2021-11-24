Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6DC45B919
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 12:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbhKXLfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 06:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238267AbhKXLfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 06:35:43 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFC7C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:32:33 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id z9so2248378qtj.9
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 03:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=7TWQDRvvhMp/wOOCUXoX6kvXCTDQ9F3RXJlbl2gRMAI=;
        b=NraT1i4pbuDxvSmrkuWBmvCtaE2NZjPDgL6+r5Oloqy6+Rpcm0UALK56vSE2zjFhfm
         G5QC5JQY2htuNNe/qZ2mvFF5s0vaEFZ/todRZHq57ifYgXsGn+sUaj9Qz2QtluJKY09R
         Z9zaMNDXe4Aeszf3FZlK6vI/iVdGdJ/+Iz6b/1GxPf6/DET/m8r5/30d/D52SuhbzYOj
         NmjZQN9/NaDawiGOB3PF+7A0t3ljh72cvnGQVY70pLShd1u2mc2z32103nuPBPj5hqVy
         ocWx392Cq/M8HcvQeWPE+PdgUB47nHxiM2ddOusZ+APsRUUbwREXHYOBwB1tjLTaFy1X
         2nlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=7TWQDRvvhMp/wOOCUXoX6kvXCTDQ9F3RXJlbl2gRMAI=;
        b=8KFqN2P0aka8MnyNFULOd+vAP0xKh9732itjfQdiy5Xu/iRQkmurpBO1LkR6SXuNON
         O1zVHqIVJzK17ectFmeqtniACJk95egQDR1W3n2aF0F/DebhBirwbVW5kdfrsh3wh9IO
         EKlP+w5GhfctIp2Z+RH00X0hIKNb4sORI1MAbpyeZZkTTZuZh+dWTXeN9rdLEhEfJXzs
         mz2EuJ4qNzy+Ck1he38ZfFCE7EB2VlPHxuxP39VWX61FDuMt5bkDGo0zsKyOtjmezfEk
         BRqMO3hhzBiPCb9S8eD1ABJzaiue08vv0INq4OQHeBpLfo8iC2+kg9GfVJi/dZ57f1IX
         gWOg==
X-Gm-Message-State: AOAM531Wo5A1GTiHYuCmKnJnpdQbTtz0FOYqBjr2i4KHowrcg41FGjIb
        nQBvoKWFoMEPjh1zXTpZ/PATrg==
X-Google-Smtp-Source: ABdhPJx1QTIDgotonBkR2GJbaWwTdgdb40LjBk3hbeUApDW8K9CEijlzpssrHZJlL7rY2sMe9u3YLw==
X-Received: by 2002:a05:622a:20d:: with SMTP id b13mr6228547qtx.368.1637753552425;
        Wed, 24 Nov 2021 03:32:32 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id o21sm8133777qta.89.2021.11.24.03.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 03:32:32 -0800 (PST)
Message-ID: <f92c3979-4a33-94ec-e687-e9639663e83c@mojatatu.com>
Date:   Wed, 24 Nov 2021 06:32:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Content-Language: en-US
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
 <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <404a4871-0e12-3cdc-e8c7-b0c85e068c53@mojatatu.com>
 <DM5PR1301MB21725BE79994CD548CEA0CC4E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <07cd52bc-2e47-6365-db7e-076e8a9cfb51@mojatatu.com>
In-Reply-To: <07cd52bc-2e47-6365-db7e-076e8a9cfb51@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-24 06:10, Jamal Hadi Salim wrote:
> On 2021-11-23 21:11, Baowen Zheng wrote:
>> On November 24, 2021 3:04 AM, Jamal Hadi Salim wrote:
> 
> [..]
> 
>>> The simplest approach seems to be adding a field in ops struct and 
>>> call it
>>> hw_id (we already have id which represents the s/w side).
>>> All your code in flow_action_init() then becomes something like:
>>>
>>>          if (!fl_action)
>>>                  return -EINVAL;
>>>
>>>          fl_action->extack = extack;
>>>          fl_action->command = cmd;
>>>          fl_action->index = act->tcfa_index;
>>>
>>>
>>>          fl_action->id = act->hwid;
>>>
>>> And modules continue to work. Did i miss something?
>>>
>> Hi Jamal, for your suggestion, I think it will work for most of the 
>> case. But there maybe some kind of actions
>> that will be assigned different hw_id in different case, such as the 
>> gact, we need to think about this case.
>> So I will prefer to add a callback in action ops struct to implement 
>> the flow_action_init function for the new added
>> Standalone action.
>> WDYT?
>>
> 
> Yes, the callback makes sense. I imagine this would be needed also
> if you offload mirred (selecting whether to mirror or redirect).
> 

BTW, I think i am able to parse your earlier message better. There is
an equivalent piece of code in cls_api.c. I didnt realize you had
cutnpasted from that code.
So this callback change has to be a separate patch. i.e
patchset 1 to
1) add the callback 2) simplify cls_api.c code
patchset 2: Your patchset that then uses the cb.

I am also wondering why that code is in the cls_api.c to begin with...

cheers,
jamal

I think if you add the action
callback then you can also simplify that.

Unfortunately that is now a separate patch given tha
