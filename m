Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D036317E97
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfEHQxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:53:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32869 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfEHQxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:53:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so10808073pfk.0;
        Wed, 08 May 2019 09:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZwiOMtENvmMkHu78PmaAVyD9pxhAQKB/9ZXuwE9X/ZE=;
        b=gj0fgpKK5FWw4At3xTt9HipeqnKOZ1XuU8O7cP1a7mBhm1xO5vPUsO/YQY0nJ9mOLa
         gdt8iwT4fOzAvTVSA/PkEhBINEB6658iHjW4aLjM8RNiM0IIujZCQSuG9836sZqrEHwa
         10HELt4Tl43c1C9xdu+E13+djSiYUUgeAqdAF65F4IuUlB9diFVPRGJcBFCRcs6FQuqD
         CT1X4pfaCiD2dXxnX6w1goDhRGBAIPjqlwk/8CRRkE+tv5wCmF1Qv8WA53hVCj/9UQhp
         g7sVtv3ET4fGD7QVprf0+3NroajKuzI10ucroJxtSdaUoXkUyMVfTFfxa2BqElnZAC0u
         dQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZwiOMtENvmMkHu78PmaAVyD9pxhAQKB/9ZXuwE9X/ZE=;
        b=NqkN8qT7wQfmLO/LonoDei3gXyTsNWHdW5nbkiTFOnO7Tw30iJTBfgeMohAPNsE1Ng
         Tr9XLNuKFVtgLQEZIqjhjrTqygtGF4c2ROGMWc48//FFqVtW4I8c+JsBt09GUWxcLYZD
         y0BOpCBJt4JEd0I1pMqsDkv3qJ7Vm+cNGswYGdMAeN/3VvZw2TpWf+82NdSPg4cjrFYA
         XwzUx+H+4phqZPAR6YaOXKY2tqAivcgMNw3yk82VzpZAjoqBQv/Flbtnc8mRxZgqB5Bq
         t3n0SUY8XitkHKDTIzAJ6NMRMyamGh/Ydrb0aibn+AQcuVQ4mNqSmwqPWGfW4ZVZoaF7
         7PJg==
X-Gm-Message-State: APjAAAV1YzGCwte6eX8ZajAuj7yLFXZjchCXxAKOcycP8xgnAgfVA/AF
        WpW5GjYFvqPuIB7rhY7jYiBCii/L
X-Google-Smtp-Source: APXvYqzZdAGVdxxNWXXjaeqD2KRVv/mZe/e1dFC6cvwzoE9dM6kQnCOPDRcDzvaJCUEhXho5fgLizg==
X-Received: by 2002:a65:5886:: with SMTP id d6mr48292774pgu.295.1557334423619;
        Wed, 08 May 2019 09:53:43 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r138sm35707143pfr.2.2019.05.08.09.53.41
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 09:53:42 -0700 (PDT)
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups option
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>
 <20190508141211.4191-1-l.pawelczyk@samsung.com>
 <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>
 <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
 <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>
 <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com>
Date:   Wed, 8 May 2019 09:53:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/19 11:56 AM, Lukasz Pawelczyk wrote:
> On Wed, 2019-05-08 at 08:41 -0700, Eric Dumazet wrote:
>>
>> On 5/8/19 11:25 AM, Lukasz Pawelczyk wrote:
>>> On Wed, 2019-05-08 at 07:58 -0700, Eric Dumazet wrote:
>>>> On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
>>>>> The XT_SUPPL_GROUPS flag causes GIDs specified with
>>>>> XT_OWNER_GID to
>>>>> be also checked in the supplementary groups of a process.
>>>>>
>>>>> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
>>>>> ---
>>>>>  include/uapi/linux/netfilter/xt_owner.h |  1 +
>>>>>  net/netfilter/xt_owner.c                | 23
>>>>> ++++++++++++++++++++-
>>>>> --
>>>>>  2 files changed, 21 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/netfilter/xt_owner.h
>>>>> b/include/uapi/linux/netfilter/xt_owner.h
>>>>> index fa3ad84957d5..d646f0dc3466 100644
>>>>> --- a/include/uapi/linux/netfilter/xt_owner.h
>>>>> +++ b/include/uapi/linux/netfilter/xt_owner.h
>>>>> @@ -8,6 +8,7 @@ enum {
>>>>>  	XT_OWNER_UID    = 1 << 0,
>>>>>  	XT_OWNER_GID    = 1 << 1,
>>>>>  	XT_OWNER_SOCKET = 1 << 2,
>>>>> +	XT_SUPPL_GROUPS = 1 << 3,
>>>>>  };
>>>>>  
>>>>>  struct xt_owner_match_info {
>>>>> diff --git a/net/netfilter/xt_owner.c
>>>>> b/net/netfilter/xt_owner.c
>>>>> index 46686fb73784..283a1fb5cc52 100644
>>>>> --- a/net/netfilter/xt_owner.c
>>>>> +++ b/net/netfilter/xt_owner.c
>>>>> @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct
>>>>> xt_action_param *par)
>>>>>  	}
>>>>>  
>>>>>  	if (info->match & XT_OWNER_GID) {
>>>>> +		unsigned int i, match = false;
>>>>>  		kgid_t gid_min = make_kgid(net->user_ns, info-
>>>>>> gid_min);
>>>>>  		kgid_t gid_max = make_kgid(net->user_ns, info-
>>>>>> gid_max);
>>>>> -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
>>>>> -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
>>>>> -		    !(info->invert & XT_OWNER_GID))
>>>>> +		struct group_info *gi = filp->f_cred-
>>>>>> group_info;
>>>>> +
>>>>> +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
>>>>> +		    gid_lte(filp->f_cred->fsgid, gid_max))
>>>>> +			match = true;
>>>>> +
>>>>> +		if (!match && (info->match & XT_SUPPL_GROUPS)
>>>>> && gi) {
>>>>> +			for (i = 0; i < gi->ngroups; ++i) {
>>>>> +				kgid_t group = gi->gid[i];
>>>>> +
>>>>> +				if (gid_gte(group, gid_min) &&
>>>>> +				    gid_lte(group, gid_max)) {
>>>>> +					match = true;
>>>>> +					break;
>>>>> +				}
>>>>> +			}
>>>>> +		}
>>>>> +
>>>>> +		if (match ^ !(info->invert & XT_OWNER_GID))
>>>>>  			return false;
>>>>>  	}
>>>>>  
>>>>>
>>>>
>>>> How can this be safe on SMP ?
>>>>
>>>
>>> From what I see after the group_info rework some time ago this
>>> struct
>>> is never modified. It's replaced. Would
>>> get_group_info/put_group_info
>>> around the code be enough?
>>
>> What prevents the data to be freed right after you fetch filp-
>>> f_cred->group_info ?
> 
> I think the get_group_info() I mentioned above would. group_info seems
> to always be freed by put_group_info().

The data can be freed _before_ get_group_info() is attempted.

get_group_info() would do a use-after-free

You would need something like RCU protection over this stuff,
this is not really only a netfilter change.


