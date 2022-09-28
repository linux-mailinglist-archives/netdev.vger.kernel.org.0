Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2075EDEFC
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiI1Ok2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiI1OkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:40:23 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7428D814EA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:40:21 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id 13so27605138ejn.3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=yLfWyMSmxxr3Hiy82ggkGXf/cv3f4ok6o+BDH04/SRM=;
        b=kcxl76KcEfPbZ6YMZfiOTaabV+vCe3K75vl9C84yDE14i8zui0U2UIQlDj5bIt1P/f
         fGcjU/rjrbGm/qeIPGpnYAh3urEvfSFx2f77bxc38lzIn7Htjk/KMFMFgooE29tA2v3w
         FUiLtqmAznfaDGK6w7z/pZiz4LBnZYrGJnrxzE4o+xsE016X29H1uw/LT44xyTTFQp7Y
         YuTF2BHwdAvU5E6Sz1gmLUqBNSL76o1HEKAbIfQogy5WmCe5nfLZDAB0uD8meUNb3jbS
         RF4VPXnIa6OJom8e1O59fIbTchliXTn86HeViAa8t9vo+P/nbpXjuuZ4Lg+nijtjx0aL
         69cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yLfWyMSmxxr3Hiy82ggkGXf/cv3f4ok6o+BDH04/SRM=;
        b=M/hkYxlgNyI1GZ0mK0+vmpCFWR9woE+RyJrmSv+oHenIlBvUCdyt2jG76MuZ2R06Ep
         4sxwZvd+HAgeagrxeR0PsUpRCFdupLoH1vud2SQasfoaftWrS+9thkTKk43I1pwT2oG2
         YWhfmlv9Ea9xzZWXLu5rgO0ki7eiR09K/BbuIsV48N+RvcDAuhz8BC9rv4H90msvi1RI
         87GnCttA04Up7WuJPLMtQwqu+o90T6DpVRvAY6XJWt2DPg+ffmZDMsG4tem9kupUkvZH
         9I2ihQk9PxILwEj27NxaLmbrHQ0fRxRd+cNhMk4rFCHpVwRWdUGP6AZV6+4YcvqU9Fco
         tcXw==
X-Gm-Message-State: ACrzQf1h00saiN47VrHeukLgYAxhVcr9z0cijpyN7ppKDBakGv3Bcssm
        fDVINXjOjB+08+QbIUZgn/VviQ==
X-Google-Smtp-Source: AMsMyM4VTLc7wfYFh2YIZ2iJ8kWOWG9f8rVl+/o7ALXCwMWR3xSLvkCH86LlhF+ssbW9t2aeudZPvw==
X-Received: by 2002:a17:907:7fa3:b0:782:3034:cbc5 with SMTP id qk35-20020a1709077fa300b007823034cbc5mr27298081ejc.96.1664376019804;
        Wed, 28 Sep 2022 07:40:19 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id kx17-20020a170907775100b007262a5e2204sm2495214ejc.153.2022.09.28.07.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 07:40:19 -0700 (PDT)
Message-ID: <08b070c9-fee6-0eab-c04a-281053c52a92@blackwall.org>
Date:   Wed, 28 Sep 2022 17:40:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
 <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220928072155.600569db@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 17:21, Jakub Kicinski wrote:
> On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
>> The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
>> bulk delete to mdbs as well, and IIRC there were plans for other object types.
>> I can update the doc once they are applied, but IMO it will be more useful to explain
>> why they are used instead of who's using them, i.e. the BULK was added to support
>> flush for FDBs w/ filtering initially and it's a flag so others can re-use it
>> (my first attempt targeted only FDBs[1], but after a discussion it became clear that
>> it will be more beneficial if other object types can re-use it so moved to a flag).
>> The first version of the fdb flush support used only netlink attributes to do the
>> flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
>> finally settled on the flag[3][4] so everyone can use it.
> 
> I thought that's all FDB-ish stuff. Not really looking forward to the
> use of flags spreading but within rtnl it may make some sense. We can
> just update the docs tho, no?
> 

Sure, that's ok.

> BTW how would you define the exact semantics of NLM_F_BULK vs it not
> being set, in abstract terms?

Well, BULK is a delete modified to act on multiple objects, so I'd say if it is not
set the DELETE targets a single object vs multiple objects if set. Obviously in more
formal terms, sorry not at a PC right now. :)



