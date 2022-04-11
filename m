Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1BF4FC698
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 23:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbiDKVTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 17:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiDKVTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 17:19:33 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B26A1B7B8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:17:17 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ks6so8818441ejb.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LPHhFNa0qT1EDY4FHCe2aNKpZTv07j4swcwL4H1d2NI=;
        b=2f2x0x+moPfz9iTX/8HD0Y1Z06Sd0wS1T6mSeB2CdN2V6l7j6aG/1aFUKWYRUSK+EF
         jQIyPLMxzDyFYoKTzNhWneRrxqLrLxjgyxa4ppDeIdbLLlj5z3TPWXj6l6RjVoulK7VJ
         hZTfIDnilPjiH7j8+xZwSMsZbXK6/GYEdoyYexOUnEpe3XzjQwbRGedSAa2196FV1ImZ
         YwU0w1iqcImS1pAYZKzSp4LVJLxroCOed+wDbClgZg85xhfe1XyVstGOebu5gf3Q7xma
         wD/EKgdbZlyN52OFjKBl5U0dOWPY5U3eD/mYiS1K258hveGAJq0aS37MAElZACuzXlzm
         AA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LPHhFNa0qT1EDY4FHCe2aNKpZTv07j4swcwL4H1d2NI=;
        b=uSryeo/8atR8oC+5/CdP03IO8mt0lYuQtwC6n0t5K7r9G5LSCtSCTerD7xbae4M2yV
         PA4uYkr9OUSdnGe/s90sJl0FCzdhmT7dNz58kNf+wRObIVRyZRXdNOKChT8ROcGqYviF
         h2D3CdAJDSdPX5o/RurY7cpanKtENUNNecow7W3Yn6pDkoMqVs6MTrBJbCyWCna7FAqL
         eNWVXuF4Lw8wBclY/4TsTDFcYScjyXBGrtDlGiiIssLhBP6Xv2frWW9LsvlpwzD4oqY3
         JXTo9k6MP8FdcZRx8lUpd3UsFEr4kjOBjLlCmuxly1xm6LWb6fPyQ8hkM7zx/B19knIf
         wdyg==
X-Gm-Message-State: AOAM532D1f0VUJh8fq3gvmMG+Hv01uA2JqbmZcN216k8j2enk+upj9z3
        zeWokiN+4nFtsSie7HuyNB+JJgdt7e/7aRhe
X-Google-Smtp-Source: ABdhPJywSn/oMniv4F7bpXhrkPdhQiB5SJ8b1jVDT+tLZSIhqVI885pSRq4jYuKPHsPr9hMomzxEWg==
X-Received: by 2002:a17:906:5d05:b0:6e8:40cc:1a99 with SMTP id g5-20020a1709065d0500b006e840cc1a99mr20264956ejt.734.1649711836027;
        Mon, 11 Apr 2022 14:17:16 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id s11-20020a170906284b00b006e108693850sm12299316ejc.28.2022.04.11.14.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 14:17:15 -0700 (PDT)
Message-ID: <d47fe5e3-2820-196d-b375-2bf98cd784d3@blackwall.org>
Date:   Tue, 12 Apr 2022 00:17:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        idosch@idosch.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220411172934.1813604-1-razor@blackwall.org>
 <0d08b6ce-53bb-bffa-4f04-ede9bfc8ab63@nvidia.com>
 <c46ac324-34a2-ca0c-7c8c-35dc9c1aa0ab@blackwall.org>
 <92f578b7-347e-22c7-be83-cae4dce101f6@blackwall.org>
 <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
 <20220411124910.772dc7a0@kernel.org>
 <3c25f674-d90b-7028-e591-e2248919cca9@blackwall.org>
 <20220411134857.3cf12d36@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220411134857.3cf12d36@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 23:48, Jakub Kicinski wrote:
> On Mon, 11 Apr 2022 23:34:23 +0300 Nikolay Aleksandrov wrote:
>> On 11/04/2022 22:49, Jakub Kicinski wrote:
>>>> all great points. My only reason to explore RTM_DELNEIGH is to see if we 
>>>> can find a recipe to support similar bulk deletes of other objects 
>>>> handled via rtm msgs in the future. Plus, it allows you to maintain 
>>>> symmetry between flush requests and object delete notification msg types.
>>>>
>>>> Lets see if there are other opinions.  
>>>
>>> I'd vote for reusing RTM_DELNEIGH, but that's purely based on  
>>
>> OK, I'll look into the delneigh solution. Note that for backwards compatibility
>> we won't be able to return proper error because rtnl_fdb_del will be called without
>> a mac address, so for old kernels with new iproute2 fdb flush will return "invalid
>> address" as an error.
> 
> If only we had policy dump for rtnl :) Another todo item, I guess.
> 

:)

>>> intuition, I don't know this code. I'd also lean towards core
>>> creating struct net_bridge_fdb_flush_desc rather than piping
>>> raw netlink attrs thru. Lastly feels like fdb ops should find   
>>
>> I don't think the struct can really be centralized, at least for the
>> bridge case it contains private fields which parsed attributes get mapped to,
>> specifically the ndm flags and state, and their maps are all mapped into
>> bridge-private flags. Or did you mean pass the raw attribute vals through a
>> struct instead of a nlattr table?
> 
> Yup, basically the policy is defined in the core, so the types are
> known. We can extract the fields from the message there, even if 
> the exact meaning of the fields gets established in the callback.
> 

That sounds nice, but there are a few catches, f.e. some ndo_fdb implementations
check if attributes were set, i.e. they can also interpret 0, so it will require
additional state (either special value, bitfield or some other way of telling them
it was actually present but 0).
Anyway I think that is orthogonal to adding the flush support, it's a nice cleanup but can
be done separately because it will have to be done for all ndo_fdb callbacks and I
suspect the change will grow considerably.
OTOH the flush implementation via delneigh doesn't require a new ndo_fdb call way,
would you mind if I finish that up without the struct conversion?

> BTW setting NLA_REJECT policy is not required, NLA_REJECT is 0 so 
> it will be set automatically per C standard.
> 

Indeed - habits, I'll drop it. :)

>>> a new home rather than ndos, but that's largely unrelated..  
>>
>> I like separating the ops idea. I'll add that to my bridge todo list. :)
>>
>> Thanks,
>>  Nik
>>
> 

