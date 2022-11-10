Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEC2624E27
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 00:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiKJXAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 18:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKJXAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 18:00:41 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE0B13DEE
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:00:40 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso2112558wms.4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 15:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jIyXTwPC1RR9hZWg0qBQGl/4AgDRK0s8MGurzqGCeCw=;
        b=jFktgf4M7qj2RvgZwYzDszQrlDmOfG5CTJ5ldNILG8oNjYMLl6FOE1LFXX7lY+ASkF
         16irpUySQ8xXCl6JoaDp1s5gp/YOYZQjZXmIQYzoAwKGcs5Z0K5U5ydRVsvJ5V+bvGpW
         0NJgCHHp5D79qECqcs5T6/+dColmrdSwg6pVWgK6bYUa9WY8jmY9Li4cQQD87LZn4/ma
         lcsDBYoZ22xRYuXfpVHgS9WNt6/cd30LY4j9YicJ5oWHKQnwQqbYecEvsdxRyXJ+fh4X
         o75wZDusfUd9jvSz9aA4/VSmeGPwpOUWQ/BmbBg6Es0fAqoT5ch7Ap1M6iLB7rq9Dvpq
         7XxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jIyXTwPC1RR9hZWg0qBQGl/4AgDRK0s8MGurzqGCeCw=;
        b=UVxHPJ0CneG+BTHIK9YyDsFs9dA3bDV963vTS5s/7ZfUR+d1LL6CALMtVHksbGZArF
         55Ym0UYXtY40GijmXpolGj4TJF7dG2m8B1cwRBE3n3AnuGmCKugtrFrVDDVACcadl31F
         yGgnVlN+B2k9AeFCqxZZ6/HvGrmqFz8Ic+VEj5rCu2Xu4xO0VVR3l2nf3wjY+p2UuPW5
         KDd/CGok9b9vWG06tyG0dwwq5nGPdmXQlkYA68/81fr7+NthElMqevI8JVqPa41C7slz
         btB42/BOQ/1JhbZK6atWZCoEvbuVReNJszh8Fm0s0qcyIPLadOjaF5mJ+ANeQ+mKiABU
         f1XA==
X-Gm-Message-State: ACrzQf2l7bqMDjrp5Lj1YdfnnSQDFPEltekeO2pB5OEJJ8l+VRwdD9Bv
        ePLmVnbUEuogSWYOnILh4drJ20f6qsk=
X-Google-Smtp-Source: AMsMyM6Dhq3jMz2dglS8P3BBO6biDZ780WkGgHP7ZQu33BNXcPo7Hl+JLOD1uWY7ClCBRIyyzUrndA==
X-Received: by 2002:a05:600c:2d86:b0:3cf:5580:c84c with SMTP id i6-20020a05600c2d8600b003cf5580c84cmr45504180wmg.146.1668121239421;
        Thu, 10 Nov 2022 15:00:39 -0800 (PST)
Received: from [192.168.169.11] ([82.197.179.206])
        by smtp.gmail.com with ESMTPSA id p7-20020a05600c430700b003cf6a55d8e8sm898174wme.7.2022.11.10.15.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 15:00:39 -0800 (PST)
Message-ID: <aa6ad8c7-5df9-9569-2849-ee601b862645@gmail.com>
Date:   Fri, 11 Nov 2022 00:00:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 1/1] amd-xgbe: fix active cable determination
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <8c3c6939-ec3d-012d-f686-ddcf5812c21b@gmail.com>
 <20221110135705.684af895@kernel.org>
 <fcf6ad3b-8dde-a926-1b6e-e2810040d7c8@gmail.com>
 <20221110143558.793dd6bf@kernel.org>
Cc:     netdev@vger.kernel.org
From:   Thomas Kupper <thomas.kupper@gmail.com>
In-Reply-To: <20221110143558.793dd6bf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 10.11.22 um 23:35 schrieb Jakub Kicinski:
> On Thu, 10 Nov 2022 23:20:02 +0100 Thomas Kupper wrote:
>> Am 10.11.22 um 22:57 schrieb Jakub Kicinski:
>>> On Thu, 10 Nov 2022 22:03:32 +0100 Thomas Kupper wrote:
>>>> When determine the type of SFP, active cables were not handled.
>>>>
>>>> Add the check for active cables as an extension to the passive cable
>>>> check.
>>> Is this patch on top of net or net-next or... ? Reportedly it does not
>>> apply to net. Could you rebase, add a Fixes tag and repost CCing Tom
>>> and Raju?
>> I apologise, after reading through all the guidelines I forgot that it
>> was on top of the latest linux-kernel instead of net.
>>
>> Regarding the 'Fixes' tag: active cables don't works for at least since
>> kernel v5.15, to what commit would you suggest do I refer to?
> Which exact sub-version of 5.15 ? Looking at the history of the file
> commit 09c5f6bf11ac988743 seems like a candidate but you'd need to
> double check based on what you know, or just revert and see if that
> fixes your problem (to confirm that's the culprit).

Checking with git blame shows that in commit abf0a1c2b26ad from 
2016-11-10 the whole if, else if ... clause plus a lot more was 
introduced. And since then the handling of the active cables was 
missing. The check (for the passive cable) got moved up in the commit 
you mentioned.

I would then use 'Fixes: abf0a1c2b26ad ...', right? And sent pretty much 
the same mail as the first time, with Tom and Raju CCed? And Patchwork 
will realise that?


Thanks for your help and patience
Thomas

