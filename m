Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DDC5EDF0D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbiI1On7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiI1Onr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:43:47 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958D2B0298
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:43:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id y8so17576535edc.10
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=x4sIrTLpeDm8/vigcE2FyWD3HUNso59AFJBgmirvbVY=;
        b=cc5Jxwm5gGr7aiRzISg3brSQyJcld58y5SQVvTmp6PwCw+Tqd48fvqGJYgzusSqdTp
         1H8LbTDeYjis+PKGLNhT7bjI8CSPr9muGyAmZfunOpAyJV4op0td67CsNYtMrX1nOtNT
         LWcgsB3B1y7DfxqwNO8sqdBwBPxPMThnGWYIRDBI7OWTMRkfDKsc9m43Bxigfe1Zdnpr
         ckrBBe3Oy3UrCXVyPJBTegfm5kSzvqvEHnJaLt0/sVXCwkTrd+mCbXv+SiK+HSxyABMa
         vP0klED/vQmnzuBNYBMwLTHP4fAk6uhgdYKztIK9BS1bG/K8W/WLp4MHD1D0RlCB9hB3
         MYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=x4sIrTLpeDm8/vigcE2FyWD3HUNso59AFJBgmirvbVY=;
        b=LrM2P2Wy1htP+JcEAwfJDNw5rTmccFxYculYaieaexZtis8+bnd42lfzMcPpn69bGt
         N9Dv6yCPzS2p6G6C32eGFpwIKJmZpnIq32VlaDCqrn/pmH36wonzYS7D8oQGGPRzl8h0
         ZmUmdxTqamcvesx7+lQT744oCrONxIaAb2ZibyFKZpJx2ABN+aIi78qnadJcc2Q0fE/M
         jnRYR4ayV6IBDCCCf+yNm9eWi030p57d+RqMtL47ROt6wQD/ROqqifyPOTUPUed1HczE
         Rp8+XcADNby6cLf0qsF1rLe4zPL+VlTouKRXnMwAvVldk09rRBR2FY2VwtGLsbw96hKf
         mBIg==
X-Gm-Message-State: ACrzQf0rN+IS0Wy5FgtfkNIRj6NiKzgfFeGwSVteHSbcRz0YxAob6Cfk
        jzwXfhlvS3a16sYa6gBfZ9EtFA==
X-Google-Smtp-Source: AMsMyM5p3CCqfVd2oFw3qKLhJW/W/gzMW+wSDlfindqOHeLvsSXl6to+gfWURS8kX7lkAzL+oPlYLg==
X-Received: by 2002:a05:6402:1009:b0:456:f370:5263 with SMTP id c9-20020a056402100900b00456f3705263mr22872071edu.392.1664376225008;
        Wed, 28 Sep 2022 07:43:45 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id hh16-20020a170906a95000b0078246b1360csm2474695ejb.225.2022.09.28.07.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 07:43:44 -0700 (PDT)
Message-ID: <017e5bb5-52c1-53dd-7ed9-3e9c542d5ee6@blackwall.org>
Date:   Wed, 28 Sep 2022 17:43:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
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
 <08b070c9-fee6-0eab-c04a-281053c52a92@blackwall.org>
In-Reply-To: <08b070c9-fee6-0eab-c04a-281053c52a92@blackwall.org>
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

On 28/09/2022 17:40, Nikolay Aleksandrov wrote:
> On 28/09/2022 17:21, Jakub Kicinski wrote:
>> On Wed, 28 Sep 2022 10:03:07 +0300 Nikolay Aleksandrov wrote:
>>> The part about NLM_F_BULK is correct now, but won't be soon. I have patches to add
>>> bulk delete to mdbs as well, and IIRC there were plans for other object types.
>>> I can update the doc once they are applied, but IMO it will be more useful to explain
>>> why they are used instead of who's using them, i.e. the BULK was added to support
>>> flush for FDBs w/ filtering initially and it's a flag so others can re-use it
>>> (my first attempt targeted only FDBs[1], but after a discussion it became clear that
>>> it will be more beneficial if other object types can re-use it so moved to a flag).
>>> The first version of the fdb flush support used only netlink attributes to do the
>>> flush via setlink, later moved to a specific RTM command (RTM_FLUSHNEIGH)[2] and
>>> finally settled on the flag[3][4] so everyone can use it.
>>
>> I thought that's all FDB-ish stuff. Not really looking forward to the
>> use of flags spreading but within rtnl it may make some sense. We can
>> just update the docs tho, no?
>>
> 
> Sure, that's ok.
> 
>> BTW how would you define the exact semantics of NLM_F_BULK vs it not
>> being set, in abstract terms?
> 
> Well, BULK is a delete modified to act on multiple objects, so I'd say if it is not
> set the DELETE targets a single object vs multiple objects if set. Obviously in more
> formal terms, sorry not at a PC right now. :)
> 

s/modified/modifier/
in terms of the comments above these flags in the header file


