Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D472A58DB
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgKCWAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730033AbgKCV7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:59:41 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8641C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 13:59:41 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id p3so16783737qkk.7
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 13:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iThggrApoc6Nt/h56BHCsw7WftFjHiAx3M8iiesY0ak=;
        b=IeQmzX2WpLbBzmEUvAQy3lyY8kux32hJ+2KKPHHWX8o0a0qB0Xalf8sajyUj6VMlEW
         P9p43Jxp0yKheODAkKbX8WiGqT8shQqdXG9evmGH5z7DmIEa9vpnd5Diedl99fD9QquE
         QNnJ4YrZTjdDDJ+2xeXHFnxxwOMFWBG7a5rsyvrPQxDjBKtg6aIjia8rRJVas5oRXc24
         1OSBZxtGqRWdcJ6nd6xo2vpfbJIxf+02TrSOIIosPRLvpALcJ3f14lHYWP6hqNyleSlX
         s5Yf3XN/sXwXAewSMkrpdeETEWz9zYaxQfLcQq3JpcAwRN8zojHidP8I5aA+Cer4xWVD
         r/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iThggrApoc6Nt/h56BHCsw7WftFjHiAx3M8iiesY0ak=;
        b=hd5Wbp6d2dlVdy5jyHBkoHSSvnFeXzp0PAlSHoJb9tabRG1BIoo1DY4AxCnG451kGJ
         568vgNoTUzZUmb5zOL5iRPGuf9P41JDGFvCEnxhgOz8oFuevQQIndaWICTv/3GvXYSwj
         ZvEtktAZcjlAF7AX9klDmoyIN7hfdbrkUYD91Q/qCQer30+WUddYK14KPLzStIJqLiGh
         ThM0BGMhLT3O1LDmq2AWV6iS9Y7ErK9sW2POcfLPfn+6iCe3OseMeduKjEOtyh/2XsMk
         kGY8+EUO6J9wDGtufP9B1sUpz2EvpWorQzmJHmef/pMxCb5tTBPsGKit9+kUfxoI7CgY
         lUzA==
X-Gm-Message-State: AOAM533WmsT6Hnos90yxb94w6+XSEGA70erh1mIiHR7qgUiNO/NLuKwe
        HdELzEvAOa39KPE8zdyDv2hWTS+irawhzA==
X-Google-Smtp-Source: ABdhPJxQ+oY7RZBT8aNl4fX2b+zXccURfLhDB7bQ2vNJjQmnNCBAnOxdgwXrsggcmBe2uClzZ5QqIQ==
X-Received: by 2002:a37:ec2:: with SMTP id 185mr21887634qko.456.1604440780977;
        Tue, 03 Nov 2020 13:59:40 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id o2sm129898qkd.12.2020.11.03.13.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 13:59:40 -0800 (PST)
Subject: Re: [PATCH iproute2-next] tc: implement support for action terse dump
To:     Vlad Buslov <vlad@buslov.dev>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
References: <20201031201644.247605-1-vlad@buslov.dev>
 <20201031202522.247924-1-vlad@buslov.dev>
 <ddd99541-204c-1b29-266f-2d7f4489d403@gmail.com> <87wnz25vir.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <178bdf87-8513-625f-1b2e-79ad435bcdf3@mojatatu.com>
Date:   Tue, 3 Nov 2020 16:59:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87wnz25vir.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-03 10:07 a.m., Vlad Buslov wrote:
> 
> On Tue 03 Nov 2020 at 03:48, David Ahern <dsahern@gmail.com> wrote:
>> On 10/31/20 2:25 PM, Vlad Buslov wrote:
>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>> index 5ad84e663d01..b486f52900f0 100644
>>> --- a/include/uapi/linux/rtnetlink.h
>>> +++ b/include/uapi/linux/rtnetlink.h
>>> @@ -768,8 +768,12 @@ enum {
>>>    * actions in a dump. All dump responses will contain the number of actions
>>>    * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
>>>    *
>>> + * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
>>> + * includes essential action info (kind, index, etc.)
>>> + *
>>>    */
>>>   #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
>>> +#define TCA_FLAG_TERSE_DUMP		(1 << 1)
>>>   
>>
>> there is an existing TCA_DUMP_FLAGS_TERSE. How does this differ and if
>> it really is needed please make it different enough and documented to
>> avoid confusion.
> 
> TCA_FLAG_TERSE_DUMP is a bit in TCA_ROOT_FLAGS tlv which is basically
> "action flags". TCA_DUMP_FLAGS_TERSE is a bit in TCA_DUMP_FLAGS tlv
> which is dedicated flags attribute for filter dump. We can't just reuse
> existing filter dump constant because its value "1" is already taken by
> TCA_FLAG_LARGE_DUMP_ON. This might look confusing, but what do you
> suggest? Those are two unrelated tlv's. I can rename the constant name
> to TCA_FLAG_ACTION_TERSE_DUMP to signify that the flag is action
> specific, but that would make the naming inconsistent with existing
> TCA_FLAG_LARGE_DUMP_ON.
> 

Its unfortunate that the TCA_ prefix ended being used for both filters
and actions. Since we only have a couple of flags maybe it is not too
late to have a prefix TCAA_ ? For existing flags something like a
#define TCAA_FLAG_LARGE_DUMP_ON TCA_FLAG_LARGE_DUMP_ON
in the uapi header will help. Of course that would be a separate
patch which will require conversion code in both the kernel and user
space.

FWIW, the patch is good for what i tested. So even if you do send an
update with a name change please add:

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
