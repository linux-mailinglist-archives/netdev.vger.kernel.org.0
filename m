Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5CA49CB5E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiAZNwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240280AbiAZNwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:52:32 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EFC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:52:32 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id c19so27215293qtx.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 05:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hn8g3f+REAYKMhYE7mU2v2rrLyYty/cWT6omS4Bwt5U=;
        b=Buy2NcHxv8hPORHgV4XxB4FzENE9magoZJjr7Afbo2iVfiqvpPDwVlX4BvjaFAaHYz
         KZwgAY+WeqyoMKV4vmciEH2fUPAQt3NmnxXmCG+T/y5gfEruXIoQy4CQITAdqd2Y5Vnb
         EKPogH52YSAvLc4HhiskxbLEQsD12j4u10nWe2zrzGhUQ7o20xXBil5eDHn4emctIMMq
         a09roZleuD1rCi0f2VhGd53dgZFXcd5TGLdTtodG1A926vtdr559C8R97m4/NPgzV7Kf
         aRQ6mCXEF9OUAuT1OWM3T2xrlZfFqN+P+Yzg0mQrd/4nAG28ZYRYW09XrmlcqKAG5gCU
         amGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hn8g3f+REAYKMhYE7mU2v2rrLyYty/cWT6omS4Bwt5U=;
        b=MsJUmzgbTnHT+d5WpoLRsi2fRAvowdoq15nX6GDRpNpYO05q57QV4oSa6Whm3Dtfeo
         RsXLcyEAHnsIct+eOjV8MqoWzX2qnpnd2I8D45xilzcYj+V5VLYtzeUVrcy9ftQCQZLj
         XbPi1wRYvQ5K/7m53oxr2yilKFrMy0+k7O4inBcsqv8jNpSHo29yV21wyZ9sWJk3Yr1R
         15noMkKbAu7hHCkInXAWXQAAp8JD8qW0xhDWvGV7DEg56IStEZVpdS9Bd+tasbQri3c0
         2FDmwohyEdNOuxl/wS9Axs2VVYlbKL6EcxkLpVQcr/BMRvzrqOWFWt0nobpu1kSn+D5w
         zEnQ==
X-Gm-Message-State: AOAM530itcOOjz8ujX5T47RrKkT1Yj7ElHxJfiX3An3CLZYcTWTivZu4
        Nr1mTEMUI3eUbFm0Tg6xhSuAtA==
X-Google-Smtp-Source: ABdhPJwQz2gvALXCo/FtzrEV9SDa4pzLUr46eV5jnjnA6FwLhe4vTmYblwYIv4sTNbifWGWy2Ea9Gg==
X-Received: by 2002:a05:622a:1b8e:: with SMTP id bp14mr20332661qtb.357.1643205151724;
        Wed, 26 Jan 2022 05:52:31 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id c11sm10408802qte.28.2022.01.26.05.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 05:52:31 -0800 (PST)
Message-ID: <848d9baa-76d1-0a60-c9e4-7d59efbc5cbc@mojatatu.com>
Date:   Wed, 26 Jan 2022 08:52:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local> <Ye7vAmKjAQVEDhyQ@tc2>
 <20220124105016.66e3558c@hermes.local> <Ye8abWbX5TZngvIS@tc2>
 <20220124164354.7be21b1c@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220124164354.7be21b1c@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-24 19:43, Stephen Hemminger wrote:
> On Mon, 24 Jan 2022 22:30:21 +0100
> Andrea Claudi <aclaudi@redhat.com> wrote:
> 
>> On Mon, Jan 24, 2022 at 10:50:16AM -0800, Stephen Hemminger wrote:
>>> On Mon, 24 Jan 2022 19:25:06 +0100
>>> Andrea Claudi <aclaudi@redhat.com> wrote:
>>>    
>>>> On Thu, Jan 06, 2022 at 02:30:13PM -0800, Stephen Hemminger wrote:
>>>>> On Thu,  6 Jan 2022 13:45:51 -0500
>>>>> Wen Liang <liangwen12year@gmail.com> wrote:
>>>>>      
>>>>>>   	} else if (sel && sel->flags & TC_U32_TERMINAL) {
>>>>>> -		fprintf(f, "terminal flowid ??? ");
>>>>>> +		print_bool(PRINT_ANY, "terminal_flowid", "terminal flowid ??? ", true);
>>>>>
>>>>> This looks like another error (ie to stderr) like the earlier case
>>>>>     
>>>>

>>>
>>> Just always put the same original message on stderr.
>>>    
>>
>> Let me phrase my case better: I think the "terminal flowid" message
>> should not be on stderr, as I don't think this is an error message.
>>
>> Indeed, "terminal flowid ???" is printed every time we use "action" or
>> "policy" (see my previous email for details), even when no error is
>> present and cls_u32 is working ok. In these cases, not having a flowid
>> is legitimate and not an error.
>>
>> As this is the case, I think the proper course of action is to have this
>> message printed out only in non-json output to preserve the same output
>> of older iproute versions. It would be even better if we decide to
>> remove this message altogether, as it is not adding any valuable info to
>> the user.
> 
> Agree, I have never used this obscure corner of u32 so will defer to others.

Andrea is correct: it is not an error and not deserving to be in stderr.
And it is _not_ an obscure case just for u32. The classid/flowid is a
classifier concept - in most cases is used to select a queue upon
a filter  match but could also be used to uniquely identify a flow.
Consider it a mini-action which identifies the flow. It is omni-present.
In this case u32 is only reporting it wasnt set. It doesnt affect
the datapath functionality. So u32 is doing the right thing. Flower is
a big culprit in that when you visit the googles hardly any example
shows this field being set and the iproute2 side of flower
code just ignores it.

> But the existing message is unhelpful and looks like a bug.
> The output should be clear and correct for both json and non-json cases;
> and any ??? kind of output should be reserved for cases where some bogus
> result is being returned by the kernel.  Some version skew, or partial
> result of previous operation maybe.

Makes sense in particular if we have formal output format like json.
If this breaks tdc it would be worth to fix tdc (and not be backward
compatible)

So: Since none of the tc maintainers was Cced in this thread, can we
please impose a rule where any changes to tc subdir needs to have tdc
tests run (and hopefully whoever is making the change will be gracious
to contribute an additional testcase)?
Do you need a patch for that in some documentation?

cheers,
jamal
