Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E4F4B8823
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 13:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbiBPMvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 07:51:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiBPMvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 07:51:33 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23542A5223
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 04:51:06 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id h16so2063262iol.11
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 04:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x24nyj3c+jNTzuxSLSLbGozjSfPrAS4Pun8RfLld6c4=;
        b=tk78Dgne/TIwoTelhzS5C0k3lrt5Ki942mdzw0QwGjQdspUZFPVWWHqF8i202nUqd5
         i9kInBjc6yjkfwYABEzObv49v+HlH7p2bIpXRW4iJ01Yfn4tL+DA7HwDDgAmBw0Dq3x1
         iRpbpw0MI/3B0wrkEHj6gEHnCfbFxbGR0s08RvN54be/HYyv/m80n+NfevtG97QgZZSg
         G3DmDi/eJCPH19EALNZ7nMfEbCS+JnddUCQ3z4Eyh9ueCI1n2ojmKxZuHzxc0Oj4gMj/
         oaABPNNwcVs74E6xQtkaGMVDBWVaPykNWWI2/3lvSrGCFIRe7gl5HeeJeE6f2Pa1Caki
         I3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x24nyj3c+jNTzuxSLSLbGozjSfPrAS4Pun8RfLld6c4=;
        b=nDW5OlrVt3/p42X+KRaFDW7OWWJ2VTPcI9b6xzFlpdPao9hIeDnvGUOcvTNEWmGWdj
         sByCjUPVXGLTwyLrb5CKaDpomDTfzB+K7wZ2ubFbSh4CazvVYVblUtKwpwAGUDtBXIar
         x3OMbv751eOvoQy5RJS7sFhOMbsYlVYTId3e/G/qYiIPshq7SR4FDX0iD4xHbFhmg5bI
         y8dNxzz+p3Hv9tgMPi29Jr9+vY0nuO0gBHONDGtus4uyCX7FvomcdY+e/uWyARuGFKXD
         h7RKm9l0e55pB2oyV2AMreS8davCJCheGh/dmOUFZ49XKGSxzT923tNqT8vJ9RiWZakJ
         BJpw==
X-Gm-Message-State: AOAM533IMb7zGijyo7QvFst/K1Hz8BbcQnI9pSYjo5mua9q7i1cwaIni
        up5T54FJqyCVJnLbl2LYBfetYQ==
X-Google-Smtp-Source: ABdhPJxhH9k9GtbRdf7tzutSFoKdh2TgeKiN0wF8Ez3KnyHcZhFpU+HZPsTKmCaB4jm3Xluv/4NVEA==
X-Received: by 2002:a05:6602:2257:b0:614:3f29:6ec6 with SMTP id o23-20020a056602225700b006143f296ec6mr1708404ioo.82.1645015866123;
        Wed, 16 Feb 2022 04:51:06 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id k9sm8344797ilv.31.2022.02.16.04.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 04:51:05 -0800 (PST)
Message-ID: <280e716c-a588-5c7b-d77e-d5d09bb0148b@mojatatu.com>
Date:   Wed, 16 Feb 2022 07:51:04 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
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
 <8a777b6f-0084-5262-40f6-d9400f7e6b15@mojatatu.com>
 <DM5PR1301MB21722969131F70DD7FA350EFE7309@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB21722969131F70DD7FA350EFE7309@DM5PR1301MB2172.namprd13.prod.outlook.com>
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

On 2022-02-11 05:01, Baowen Zheng wrote:
> Hi Jamal:
> Sorry for the delay of the reply.
>

I guess it is my turn to say sorry for the latency ;->

> On February 2, 2022 7:47 PM, Jamal wrote:
>> On 2022-02-02 04:37, Baowen Zheng wrote:
>>> Hi Roi:
>>> Thanks for bring this to us, please see the inline comments.
>>>

[..]
>>
>> Probably the language usage is causing the confusion and I missed this detail
>> in the output as well. Let me see if i can break this down.
>>
>> Either both action and  filter are in h/w or they are not. i.e
>>
>> action in h/w  + filter in h/w == GOOD
>> action in h/w  + filter in s/w == BAD
>> action in s/w  + filter in h/w == BAD
>> action in s/w  + filter in s/w == GOOD
>>
>> The kernel patches did have those rules in place - and Baowen added tdc tests
>> to check for this.
>>
>> Now on the workflow:
>> 1) If you add an action independently to offload before you add a filter when
>> you dump actions it should say "skip_sw, ref 1 bind 0"
>> i.e information is sufficient here to know that the action is offloaded but there
>> is no filter attached.
>>
>> 2) If you bind this action after to a filter which _has to be offloaded_
>> (otherwise the filter will be rejected) then when you dump the actions you
>> should see "skip_sw ref 2 bind 1"; when you dump the filter you should see
>> the same on the filter.
>>
>> 3) If you create a skip_sw filter without step #1 then when you dump you
>> should see "skip_sw ref 1 bind 1" both when dumping in IOW, the not_in_hw
>> is really unnecessary.
>>
>> So why not just stick with skip_sw and not add some new language?
>>
> If I do not misunderstand, you mean we just show the skip_sw flag and do not show other information(in_hw, not_in_hw and in_hw_count), I think it is reasonable to show the action information as your suggestion if the action is dumped along with the filters.
> 

Yes, thats what i am saying - it maintains the existing semantics people
are aware of for usability.

> But as we discussed previously, we added the flags of skip_hw, skip_sw, in_hw_count mainly for the action dump command(tc -s -d actions list action xxx).
> We know that the action can be created with three flags case: skip_sw, skip_hw and no flag.
> Then when the actions are dumped independently, the information of skip_hw, skip_sw, in_hw_count will become important for the user to distinguish if the action is offloaded or not.
> 
> So does that mean we need to show different item when the action is dumped independent or along with the filter?
> 

I see your point. I am trying to visualize how we deal with the
tri-state  in filters and we never considered what you are suggesting.
Most people either skip_sw or skip_hw in presence of offloadable hw.
In absence of hardware nobody specifies a flag, so nothing is displayed.
My eyes are used to how filters look like. Not sure anymore tbh. Roi?

cheers,
jamal


