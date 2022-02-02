Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35A04A703D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 12:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244954AbiBBLrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 06:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiBBLrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 06:47:13 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF966C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 03:47:13 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id h8so11008968qtk.13
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 03:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T7USrvqAHZtDJugmbg1hEZMDsjj+Vrg2o2uUmBZZLPo=;
        b=yP+WvpHL9AeRNer4fKjlyr9+v47fvQvaxH99fIPQmOLWHLjNjb+I2paSjpzWse+ibN
         6Ss1Uc9brSCRQsO6+FdM3xIsLUPLo/SBiL8hc8ghtfs4ucQ1sQkQm1yeS6KIjNHXgs4q
         LuhFt2uskPwAsLFsjhojKS7ZzCNs7NLy5VH5g8gEP4GhJznlyEZyvTIEoQK98c6DL8/s
         6FEPIwcQYAZOJ6X1hfDoDWMRoz/5Bz/5NovXnBvpHqqgxeTUrmZ8NRt8UJWLoS89k/hu
         h/NK8wJ87XYD+CAY6rLa/mHIpmi2Ep+FZCLapAzuZ+IF3YLY/lIdHGsXJBDplZPazsHW
         2GDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T7USrvqAHZtDJugmbg1hEZMDsjj+Vrg2o2uUmBZZLPo=;
        b=7SB2FIslr0tKFL4OruXw76UM76kQWLPotsFiABJsnee7qBYTJIhd1um1HwlDQM2X6y
         pvGCXWRPvm8RRdTe81FN+2E7tgoPL+/CXahzJFunrgw2tsK5sG2ZVCp69WZs9TLKh52u
         Cznt6fXcO6ZZaME/xR9kzl/uTMCNXclbRsAqkfLkTfALItmQ7SQodW/U/n6aRRAHkhDF
         gpq9veLPC77K7M97SAg0Us6DwONIABQGX88u9wtQhtarxJD59vBKXmaC0M9YJQx5BCA8
         0kQmIUZSU+KUQZS3U7h3WnCZUCxVD7zqIGZwr48VzgaGH9+bDxNHZjiQlpLz6Dre20Wx
         Ya0A==
X-Gm-Message-State: AOAM531qgeIKsLLbSms7IV3eWlKtZSW3XGvmq8PrlfDDY+SihpR9r3Jc
        wPWfS9QDmMbR4Dpz5VGNgCRgDTjsWO0vAw==
X-Google-Smtp-Source: ABdhPJwPnxnzetPTDMlcNjRu8aP9b3VMqy+tt2KC8G1bGlMRyGLiFL/JAuoJzBdXKba15TJTGlbCAA==
X-Received: by 2002:ac8:5cce:: with SMTP id s14mr22775758qta.178.1643802432834;
        Wed, 02 Feb 2022 03:47:12 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id c78sm11507651qkg.42.2022.02.02.03.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 03:47:12 -0800 (PST)
Message-ID: <8a777b6f-0084-5262-40f6-d9400f7e6b15@mojatatu.com>
Date:   Wed, 2 Feb 2022 06:47:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Roi Dayan <roid@nvidia.com>,
        Victor Nogueira <victor@mojatatu.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
 <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
 <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-02 04:37, Baowen Zheng wrote:
> Hi Roi:
> Thanks for bring this to us, please see the inline comments.
> 
>> On 2022-02-02 10:39 AM, Roi Dayan wrote:
>>>
>>>
>>> On 2022-01-31 9:40 PM, Jamal Hadi Salim wrote:
>>>> On 2022-01-26 08:41, Victor Nogueira wrote:
>>>>> On Wed, Jan 26, 2022 at 3:55 AM Baowen Zheng
>>>>> <baowen.zheng@corigine.com> wrote:
>>>>>>
>>>>>> Add skip_hw and skip_sw flags for user to control whether offload
>>>>>> action to hardware.
>>>>>>
>>>>>> Also we add hw_count to show how many hardwares accept to offload
>>>>>> the action.
>>>>>>
>>>>>> Change man page to describe the usage of skip_sw and skip_hw flag.
>>>>>>
>>>>>> An example to add and query action as below.
>>>>>>
>>>>>> $ tc actions add action police rate 1mbit burst 100k index 100
>>>>>> skip_sw
>>>>>>
>>>>>> $ tc -s -d actions list action police total acts 1
>>>>>>       action order 0:  police 0x64 rate 1Mbit burst 100Kb mtu 2Kb
>>>>>> action reclassify overhead 0b linklayer ethernet
>>>>>>       ref 1 bind 0  installed 2 sec used 2 sec
>>>>>>       Action statistics:
>>>>>>       Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>>>>>       backlog 0b 0p requeues 0
>>>>>>       skip_sw in_hw in_hw_count 1
>>>>>>       used_hw_stats delayed
>>>>>>
>>>>>> Signed-off-by: baowen zheng <baowen.zheng@corigine.com>
>>>>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>>>>
>>>>> I applied this version, tested it and can confirm the breakage in
>>>>> tdc is gone.
>>>>> Tested-by: Victor Nogueira <victor@mojatatu.com>
>>>>
>>>> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>>>>
>>>> cheers,
>>>> jamal
>>>
>>>
>>> Hi Sorry for not catching this early enough but I see an issue now
>>> with this patch. adding an offload tc rule and dumping it shows
>>> actions not_in_hw.
>>>
>>> example rule in_hw and action marked as not_in_hw
>>>
>>> filter parent ffff: protocol arp pref 8 flower chain 0 handle 0x1
>>> dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50
>>>     eth_type arp
>>>     in_hw in_hw_count 1
>>>           action order 1: gact action drop
>>>            random type none pass val 0
>>>            index 2 ref 1 bind 1
>>>           not_in_hw
>>>           used_hw_stats delayed
>>>
>>>
>>> so the action was not created/offloaded outside the filter but it is
>>> acting as offloaded.
> Hi Roi, the flag in_hw and not_in_hw in action section describes if the action is offloaded as an action independent of any filter. So the actions created along with the filter will be marked with not_in_hw.

Probably the language usage is causing the confusion and I missed
this detail in the output as well. Let me see if i can break this down.

Either both action and  filter are in h/w or they are not. i.e

action in h/w  + filter in h/w == GOOD
action in h/w  + filter in s/w == BAD
action in s/w  + filter in h/w == BAD
action in s/w  + filter in s/w == GOOD

The kernel patches did have those rules in place - and Baowen added
tdc tests to check for this.

Now on the workflow:
1) If you add an action independently to offload before you add a filter
when you dump actions it should say "skip_sw, ref 1 bind 0"
i.e information is sufficient here to know that the action is offloaded
but there is no filter attached.

2) If you bind this action after to a filter which _has to be offloaded_
(otherwise the filter will be rejected) then when you dump the actions
you should see "skip_sw ref 2 bind 1"; when you dump the filter you
should see the same on the filter.

3) If you create a skip_sw filter without step #1 then when you dump
you should see "skip_sw ref 1 bind 1" both when dumping in
IOW, the not_in_hw is really unnecessary.

So why not just stick with skip_sw and not add some new language?

cheers,
jamal
