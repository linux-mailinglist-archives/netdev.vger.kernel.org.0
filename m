Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3864436D43
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhJUWMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhJUWMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 18:12:43 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65022C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:10:27 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id g125so2675089oif.9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 15:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RMDwoM57XY+gH18HGTFMx5PERtEFBaeXWiF9b2Bm7xI=;
        b=Ms0Yn5ipOPf7FMibR72at3r+/f0KXmISnK2+h/VqJGg2szJKX3ym82SBjBWIug5oiT
         GbDZfSNOb1ASmPfpiYxTwpkLNw5jEdxyYg29ZHr98QJdQvljl6LPpffQ8wa1dHRJRlGQ
         fmZQJ63iqaslCtaBuaB4KyFR8FrV4EKLxWCz3dWwJeTuLajZhAHi/oMemYeSG2fym1Nr
         dm/cpW2jDe51qnuubOmwqMhqyRVtEVgYAwHLJBu7EFvanNzTqys7nOyWXEQ5nT6zI7Hh
         dAuinr5l7nzMaOKy7/39h106RaIgssr1UFxO8ZU8/CRQkZwz/QvBjn+JWaO2hAPqBdLT
         x9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RMDwoM57XY+gH18HGTFMx5PERtEFBaeXWiF9b2Bm7xI=;
        b=eneKbECxDgaogMGV03X5p6G+Tyn73lkBanMktrKKiTmAKT7UD1fp6nxoimaHAGC4ar
         uMwu3g7osDcSTBWbt7gLIubV3/wc378fcUfWOzYTsxel5UfuNrdQo1A03D4QTuOFmVzq
         N/2RiC93BetLTdGnETYs9fFlkuqZKztxl4VQPpS5AW+OTpRhah2apsKeUSYz4zdleiE1
         iIbDWVXjJVidlbNo7BKhImKgKFCrdSs0WjswKDc/eh3PeIiQhtcLRfSIWnZjWpcHpDf+
         mcaqrY/P2+a79Z5EK2fh2Lrbp5mM82VPOVdk+ZKdBkh5NYMbHYCdJuk0g7JLXYOg0uw4
         812A==
X-Gm-Message-State: AOAM5305xV+Rai74EI8EhAIkGf1aXjBrWGBxfYnnWtUL6Oe4YIuXvXQy
        Xu7PnPKZs+kwRGS/LSoRP6FYlYWJ7M0=
X-Google-Smtp-Source: ABdhPJzhoKmyxX7kdfcWyqopmwnDPo2oSMAEQZ8HipfTYxNQHoIM7pd4k5Hd4mAV9i5zsClzzCSZ0A==
X-Received: by 2002:a05:6808:1508:: with SMTP id u8mr6683107oiw.4.1634854226843;
        Thu, 21 Oct 2021 15:10:26 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id h2sm1324206otr.37.2021.10.21.15.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 15:10:26 -0700 (PDT)
Message-ID: <5e6586d2-3bbc-1499-a578-77f4a2320801@gmail.com>
Date:   Thu, 21 Oct 2021 16:10:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH iproute2 v2] xfrm: enable to manage default policies
Content-Language: en-US
To:     nicolas.dichtel@6wind.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, antony.antony@secunet.com,
        steffen.klassert@secunet.com
References: <20210923061342.8522-1-nicolas.dichtel@6wind.com>
 <20211018083045.27406-1-nicolas.dichtel@6wind.com>
 <1ee8e8ec-734b-eec7-1826-340c0d48f26e@gmail.com>
 <9acfb0e5-872d-e527-9feb-6e9f5cf2f447@6wind.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <9acfb0e5-872d-e527-9feb-6e9f5cf2f447@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/21 3:23 PM, Nicolas Dichtel wrote:
> 
> 
> Le 21/10/2021 à 16:55, David Ahern a écrit :
>> On 10/18/21 2:30 AM, Nicolas Dichtel wrote:
>>> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
>>> index ecd06396eb16..378b4092f26a 100644
>>> --- a/include/uapi/linux/xfrm.h
>>> +++ b/include/uapi/linux/xfrm.h
>>> @@ -213,13 +213,13 @@ enum {
>>>  	XFRM_MSG_GETSPDINFO,
>>>  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
>>>  
>>> +	XFRM_MSG_MAPPING,
>>> +#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>>> +
>>>  	XFRM_MSG_SETDEFAULT,
>>>  #define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
>>>  	XFRM_MSG_GETDEFAULT,
>>>  #define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
>>> -
>>> -	XFRM_MSG_MAPPING,
>>> -#define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
>>>  	__XFRM_MSG_MAX
>>>  };
>>>  #define XFRM_MSG_MAX (__XFRM_MSG_MAX - 1)
>>> @@ -514,9 +514,12 @@ struct xfrm_user_offload {
>>>  #define XFRM_OFFLOAD_INBOUND	2
>>>  
>>>  struct xfrm_userpolicy_default {
>>> -#define XFRM_USERPOLICY_DIRMASK_MAX	(sizeof(__u8) * 8)
>>> -	__u8				dirmask;
>>> -	__u8				action;
>>> +#define XFRM_USERPOLICY_UNSPEC	0
>>> +#define XFRM_USERPOLICY_BLOCK	1
>>> +#define XFRM_USERPOLICY_ACCEPT	2
>>> +	__u8				in;
>>> +	__u8				fwd;
>>> +	__u8				out;
>>>  };
>>>  
>>>  /* backwards compatibility for userspace */
>>
>> that is already updated in iproute2-next.
> But this is needed for the iproute2 also. These will be in the linux v5.15 release.

new functionality is added to -next first; that's why it exists.


> 
> [snip]
> 
>>
>> create xfrm_str_to_policy and xfrm_policy_to_str helpers for the
>> conversions between "block" and "accept" to XFRM_USERPOLICY_BLOCK and
>> XFRM_USERPOLICY_ACCEPT and back.
> Ok.
> 

