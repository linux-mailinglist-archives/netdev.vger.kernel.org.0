Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F309B17D6F
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 17:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfEHPlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 11:41:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39629 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfEHPlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 11:41:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id w22so8981119pgi.6;
        Wed, 08 May 2019 08:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6nlZyrDFPAuXjOlK7kJCVfvkw03cc4Rw/z9UVKA0jkM=;
        b=G/2JhBJiH3bwAo5cTbBJg+isnzV1nxr7HW6irNRUPpb+slECHMaqgFSBZb7IOMu4AP
         8knEQ5cpwLvYp/YNRCpyeWZImGJoj+J53+aPioRUvfxor2Gpg4h4vP9it5nzkzkTUOUO
         t2HQNzrTuV2nc5UgtbAR9C88kqtHMNKuiIDtuOEATEEn1soGfgtyYSdXJwVFJSih2Hdz
         xLK8GZoOF5nGEMUDHlf0+TYSPHtzb2N2LS3EgzXrqz9rNe+32nox2JwMtlNl7XTVsc39
         cbohI1KQsTaoYPtfmLPazbq2qQHRU2hw40RXukeO3M9bdzXDKqOQIH53R9IQR+UulcRJ
         8FHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6nlZyrDFPAuXjOlK7kJCVfvkw03cc4Rw/z9UVKA0jkM=;
        b=OEgqlbEPz0KhOCHpwWwWyvsD2Qe7nj4fqXIQh/UUhzEEcsP97JJ2uw9v6u0qd7ytci
         nfsJWyxeiqEMuxiGSwcJz+GucDV7SRALWX3p5/miIr4kyn5hExk+zkiC6Y86Ty8Mgg28
         hr6c8aHcw4lOP+8qg1kmho7+T3wHzsh8o4p3WTLbIXRoFC7TV7QkgC81wseAE40sCMIN
         6D4QvHB0TGCw91HUY+Y3Or8s+GpZyHIK6/KjDimRuRQxWmGVDZEL58ZfNkFXFJEgqIW8
         P1FVuUutFWxldH59rGv1gd0YJYZruopH0KA62e1m3YkXZA0ZKqHLpt0SbOckJKbFVy+n
         xA7A==
X-Gm-Message-State: APjAAAXlwE8PeVyl3xjJcRynEDTMW26odc2pRZXTKYcI9iHog/alZpfB
        JVsePvBtQRyKdhYXJauNFak=
X-Google-Smtp-Source: APXvYqwouA4u/g0nE8nv2+7NcLZWFYLytNjDxo8XzEPX8QhWsJZ/q3B0WtmIPClcZILTv8Jrxn2kiw==
X-Received: by 2002:a65:500d:: with SMTP id f13mr49479600pgo.250.1557330075758;
        Wed, 08 May 2019 08:41:15 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id l19sm21842612pff.1.2019.05.08.08.41.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 08:41:14 -0700 (PDT)
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups option
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>
Date:   Wed, 8 May 2019 08:41:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/19 11:25 AM, Lukasz Pawelczyk wrote:
> On Wed, 2019-05-08 at 07:58 -0700, Eric Dumazet wrote:
>>
>> On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
>>> The XT_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID to
>>> be also checked in the supplementary groups of a process.
>>>
>>> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
>>> ---
>>>  include/uapi/linux/netfilter/xt_owner.h |  1 +
>>>  net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++-
>>> --
>>>  2 files changed, 21 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/netfilter/xt_owner.h
>>> b/include/uapi/linux/netfilter/xt_owner.h
>>> index fa3ad84957d5..d646f0dc3466 100644
>>> --- a/include/uapi/linux/netfilter/xt_owner.h
>>> +++ b/include/uapi/linux/netfilter/xt_owner.h
>>> @@ -8,6 +8,7 @@ enum {
>>>  	XT_OWNER_UID    = 1 << 0,
>>>  	XT_OWNER_GID    = 1 << 1,
>>>  	XT_OWNER_SOCKET = 1 << 2,
>>> +	XT_SUPPL_GROUPS = 1 << 3,
>>>  };
>>>  
>>>  struct xt_owner_match_info {
>>> diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
>>> index 46686fb73784..283a1fb5cc52 100644
>>> --- a/net/netfilter/xt_owner.c
>>> +++ b/net/netfilter/xt_owner.c
>>> @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct
>>> xt_action_param *par)
>>>  	}
>>>  
>>>  	if (info->match & XT_OWNER_GID) {
>>> +		unsigned int i, match = false;
>>>  		kgid_t gid_min = make_kgid(net->user_ns, info-
>>>> gid_min);
>>>  		kgid_t gid_max = make_kgid(net->user_ns, info-
>>>> gid_max);
>>> -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
>>> -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
>>> -		    !(info->invert & XT_OWNER_GID))
>>> +		struct group_info *gi = filp->f_cred->group_info;
>>> +
>>> +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
>>> +		    gid_lte(filp->f_cred->fsgid, gid_max))
>>> +			match = true;
>>> +
>>> +		if (!match && (info->match & XT_SUPPL_GROUPS) && gi) {
>>> +			for (i = 0; i < gi->ngroups; ++i) {
>>> +				kgid_t group = gi->gid[i];
>>> +
>>> +				if (gid_gte(group, gid_min) &&
>>> +				    gid_lte(group, gid_max)) {
>>> +					match = true;
>>> +					break;
>>> +				}
>>> +			}
>>> +		}
>>> +
>>> +		if (match ^ !(info->invert & XT_OWNER_GID))
>>>  			return false;
>>>  	}
>>>  
>>>
>>
>> How can this be safe on SMP ?
>>
> 
> From what I see after the group_info rework some time ago this struct
> is never modified. It's replaced. Would get_group_info/put_group_info
> around the code be enough?

What prevents the data to be freed right after you fetch filp->f_cred->group_info ?


