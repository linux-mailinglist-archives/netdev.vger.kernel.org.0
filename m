Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E43B45C825
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235155AbhKXPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 10:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhKXPBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 10:01:52 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7A5C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 06:58:43 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id t34so2848408qtc.7
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 06:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KdBodORbv1RLWB/trJTK+HU1y8JIRuv6eBqBIM2qlZY=;
        b=2cTOfEXN4vfy3HEc9EOvNUVqJaTBjqzE3sqCiC6d4hAnR1za0jbuoDyLsXVA/bblNJ
         JMZUrDSdiajDyRWF/v+75PRa3P8A/QAqXn8HNe/lOIqUJ4SVAiEziTXfExsL6tyXRb++
         SMuDquYTUyIaNQvVxg46q1sODfhtp4ZXNxtzlmEEA9ggz0m7Vepb/uAoKEiMguqD2vmO
         xcb+soUrx/kjAr/fv2w6EHGo/EWpmwFqCtwXjs5mcf3kE705CpZebLFmHySTxvO3jiK8
         Pp7Qec5feudslOjHywlVenoTw6mcIMJJngncYQTfttX86x9s9oxhco7zu6ztlKAOtAy/
         aseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KdBodORbv1RLWB/trJTK+HU1y8JIRuv6eBqBIM2qlZY=;
        b=BKmFlpfwE7zzSXaFlYdPlu8DM/CHBQ/5e9gukefL/7WShkQQtzmswhSUuDKauRXXDm
         kJOSOOFsMnSTF3J4YMvXdQ86zN1b/7y36ohngPaSpWeDYKdPsxTZdMBjoBpovrbZNarT
         H0IUNTNhLNzaKXO09dHXsgGehnNlIW30/VOxyCXr3D4ftJVJPj0ywa25rucQwzzrHcEj
         oGaK45BZI9QRsjOveXLleWAD/DjnyN9yAfjp1NVmJyLtMjfDP5LNBEXAwb+AtgA/Drw6
         bSwG3QLe3gyNv8pCWf9q22LRhX3RjSb8wqlmZJiMPexWIctsjq2M4reR0NnJdnIv1RFw
         HrXA==
X-Gm-Message-State: AOAM532f+OEAhPfd/3mNrShCWTJUycrNVY0YfneSyE1M1PmZgxCVb6+f
        mosjeYa5WW+O8CCfs4/0mm5AqQ==
X-Google-Smtp-Source: ABdhPJyE91pedTkcF8TxSshWMIwthWBxSIJfmRu0xeAtvgCpJYHCjmMy314FHcglem2gJqmgwHKLWw==
X-Received: by 2002:ac8:7774:: with SMTP id h20mr7854880qtu.236.1637765922173;
        Wed, 24 Nov 2021 06:58:42 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id y11sm17492qta.6.2021.11.24.06.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 06:58:41 -0800 (PST)
Message-ID: <8fd369db-9256-633b-1b83-2d2684147636@mojatatu.com>
Date:   Wed, 24 Nov 2021 09:58:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Content-Language: en-US
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
 <DM5PR1301MB2172ED85399FCC4B89F70792E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <a899b3b5-c30b-2b91-be6a-24ec596bc786@mojatatu.com>
 <DM5PR1301MB2172F332AED4A4940C2ECAF8E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172F332AED4A4940C2ECAF8E7619@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-24 08:47, Baowen Zheng wrote:
> On November 24, 2021 7:40 PM, Jamal Hadi Salim wrote:
>> On 2021-11-23 21:59, Baowen Zheng wrote:
>>> Sorry for reply this message again.
>>> On November 24, 2021 10:11 AM, Baowen Zheng wrote:
>>>> On November 24, 2021 3:04 AM, Jamal Hadi Salim wrote:
>>
>> [..]
>>
>>>>>
>>>>> BTW: shouldnt extack be used here instead of returning just -EINVAL?
>>>>> I didnt stare long enough but it seems extack is not passed when
>>>>> deleting from hardware? I saw a NULL being passed in one of the patches.
>>> Maybe I misunderstand what you mean previously, when I look through
>>> the implement in flow_action_init, I did not found we use the extack to
>> make a log before return -EINVAL.
>>> So could you please figure it out? Maybe I miss something or misunderstand
>> again.
>>
>> I mean there are maybe 1-2 places where you called that function
>> flow_action_init() with extack being NULL but the others with legitimate extack.
>> I pointed to offload delete as an example. This may have existed before your
>> changes (but it is hard to tell from just eyeballing patches); regardless it is a
>> problem for debugging incase some delete offload fails, no?
> Yes, you are right, for the most of the delete scenario, the extack is NULL since
> The original implement to delete the action does not include an extack, so we will
> Use extack when it is available.

You may have to go deeper in the code for this to work. I think if it is
tricky to do consider doing it as a followup patch.

>>
>> BTW:
>> now that i am looking at the patches again - small details:
>> struct flow_offload_action is sometimes initialized and sometimes not (and
>> sometimes allocated and sometimes off the stack). Maybe to be consistent
>> pick one style and stick with it.
> For this implement, it is because for the action offload process, we need items of
> flow_action_entry in the flow_offload_action, then the size of flow_offload_action is
> dependent on the action to be offloaded. But for delete case, we just need a pure
> flow_offload_action, so we take it in stack.  You can refer to the implement in cls_flower,
> it is similar with our case.
> Do you think if it make sense to us?

I think it does. Let me see if i can explain it in my words:
For delete you dont have any attributes to pass but for create you need
to pass attributes which may be variable sized depending on the action.
And for that reason for create you need to allocate (but for delete
you can use a variable on the stack).
If yes, then at least make sure you are consistent on the stack values;
I think i saw some cases you initialize and in some you didnt.

cheers,
jamal
