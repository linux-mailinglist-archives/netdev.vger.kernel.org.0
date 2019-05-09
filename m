Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7EE11895C
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfEIL5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 07:57:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37191 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfEIL5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 07:57:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id p15so1056683pll.4;
        Thu, 09 May 2019 04:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/+gEI3yaV3GlMf2auut9mO3euCItpGQhrTRtASP99ek=;
        b=bSU2bw0zzTND+6Nkc9pTgOCkpMWwE7ylxfZwyr3B7sHQE1pdDmaOiJIVZTtV0Q3XL1
         z+Kp0nr+y5bKXfsOwv9qx0lEge/zL4u9wJw8/8RIfn9XmxMPOCwciKdqaOxb+Pd7xEMw
         GN9RXrqz2nBITORCC+C9T/yTGKKuuQkd5xQU9dAhZE2zVjFPpp0R6sQwYfjN5LdBLvuI
         0hj/wAYimrA/1AhQC6bGSvYKXxe7NbLQFEu80fzc4GmVEDmKtuQUMr61izuEwrn87XbS
         1RTyYmphM54hszmyWrmPOKaCotBqmzFP6WMcZZvXFtxOIOKXtLnjri8+47cWGL58e8Ju
         DRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/+gEI3yaV3GlMf2auut9mO3euCItpGQhrTRtASP99ek=;
        b=JA9Vj3ICVNnpLQJmkmaAP1YudGZq1cN6NcVdDnIHfOUKHXwd5Wbmtquojc97Bcc8Qv
         f+H1qMiURjZiM010YAo3KgqpqtXu57NYbHtn5hA2urhM1xyhTeAW2m8TiJ1WbpAvWAtM
         zGRoljYRjmmNZ5nlPk2ItM5DICtgtjdCJatvU+FKf3cY4l6EHoy3OvMJto5mfpKIG/Nd
         /Z3V2p0ScjGt8lo0puc39xEmPEl4YNf8u1jAeJdYhKSSHY0i5lVYZhWQEPRqCi221x9F
         Rt7gzyoPb1/Y4ZxIK2Bo5NLjKP7hdA9bdX4SHSZFcxwKA7Dn/U0puUzAB5NQPNJSc9IB
         deUQ==
X-Gm-Message-State: APjAAAXE1j0Us2DTtnI+Uk4VzhLj9XO6FCz+XixFTpFCgOah4BrAU43z
        F8XqD0bxBXzo9kQiJIV6+ETikugk
X-Google-Smtp-Source: APXvYqyTksCb5lbv7US3nxwHdIQdRplTSv56fx2ksvuoc7mRgE/ObhChKm0LTE8v17wG8M4Md47CZQ==
X-Received: by 2002:a17:902:2847:: with SMTP id e65mr4416051plb.319.1557403061601;
        Thu, 09 May 2019 04:57:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id a19sm2286539pgm.46.2019.05.09.04.57.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 04:57:40 -0700 (PDT)
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
 <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>
 <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>
 <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com>
 <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ffbaeda9-1e0c-f526-15aa-e865fcb4ec95@gmail.com>
Date:   Thu, 9 May 2019 04:57:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/19 6:47 AM, Lukasz Pawelczyk wrote:
> On Wed, 2019-05-08 at 09:53 -0700, Eric Dumazet wrote:
>>
>> On 5/8/19 11:56 AM, Lukasz Pawelczyk wrote:
>>> On Wed, 2019-05-08 at 08:41 -0700, Eric Dumazet wrote:
>>>> On 5/8/19 11:25 AM, Lukasz Pawelczyk wrote:
>>>>> On Wed, 2019-05-08 at 07:58 -0700, Eric Dumazet wrote:
>>>>>> On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
>>>>>>> The XT_SUPPL_GROUPS flag causes GIDs specified with
>>>>>>> XT_OWNER_GID to
>>>>>>> be also checked in the supplementary groups of a process.
>>>>>>>
>>>>>>> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
>>>>>>> ---
>>>>>>>  include/uapi/linux/netfilter/xt_owner.h |  1 +
>>>>>>>  net/netfilter/xt_owner.c                | 23
>>>>>>> ++++++++++++++++++++-
>>>>>>> --
>>>>>>>  2 files changed, 21 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/uapi/linux/netfilter/xt_owner.h
>>>>>>> b/include/uapi/linux/netfilter/xt_owner.h
>>>>>>> index fa3ad84957d5..d646f0dc3466 100644
>>>>>>> --- a/include/uapi/linux/netfilter/xt_owner.h
>>>>>>> +++ b/include/uapi/linux/netfilter/xt_owner.h
>>>>>>> @@ -8,6 +8,7 @@ enum {
>>>>>>>  	XT_OWNER_UID    = 1 << 0,
>>>>>>>  	XT_OWNER_GID    = 1 << 1,
>>>>>>>  	XT_OWNER_SOCKET = 1 << 2,
>>>>>>> +	XT_SUPPL_GROUPS = 1 << 3,
>>>>>>>  };
>>>>>>>  
>>>>>>>  struct xt_owner_match_info {
>>>>>>> diff --git a/net/netfilter/xt_owner.c
>>>>>>> b/net/netfilter/xt_owner.c
>>>>>>> index 46686fb73784..283a1fb5cc52 100644
>>>>>>> --- a/net/netfilter/xt_owner.c
>>>>>>> +++ b/net/netfilter/xt_owner.c
>>>>>>> @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb,
>>>>>>> struct
>>>>>>> xt_action_param *par)
>>>>>>>  	}
>>>>>>>  
>>>>>>>  	if (info->match & XT_OWNER_GID) {
>>>>>>> +		unsigned int i, match = false;
>>>>>>>  		kgid_t gid_min = make_kgid(net->user_ns, info-
>>>>>>>> gid_min);
>>>>>>>  		kgid_t gid_max = make_kgid(net->user_ns, info-
>>>>>>>> gid_max);
>>>>>>> -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
>>>>>>> -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
>>>>>>> -		    !(info->invert & XT_OWNER_GID))
>>>>>>> +		struct group_info *gi = filp->f_cred-
>>>>>>>> group_info;
>>>>>>> +
>>>>>>> +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
>>>>>>> +		    gid_lte(filp->f_cred->fsgid, gid_max))
>>>>>>> +			match = true;
>>>>>>> +
>>>>>>> +		if (!match && (info->match & XT_SUPPL_GROUPS)
>>>>>>> && gi) {
>>>>>>> +			for (i = 0; i < gi->ngroups; ++i) {
>>>>>>> +				kgid_t group = gi->gid[i];
>>>>>>> +
>>>>>>> +				if (gid_gte(group, gid_min) &&
>>>>>>> +				    gid_lte(group, gid_max)) {
>>>>>>> +					match = true;
>>>>>>> +					break;
>>>>>>> +				}
>>>>>>> +			}
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		if (match ^ !(info->invert & XT_OWNER_GID))
>>>>>>>  			return false;
>>>>>>>  	}
>>>>>>>  
>>>>>>>
>>>>>>
>>>>>> How can this be safe on SMP ?
>>>>>>
>>>>>
>>>>> From what I see after the group_info rework some time ago this
>>>>> struct
>>>>> is never modified. It's replaced. Would
>>>>> get_group_info/put_group_info
>>>>> around the code be enough?
>>>>
>>>> What prevents the data to be freed right after you fetch filp-
>>>>> f_cred->group_info ?
>>>
>>> I think the get_group_info() I mentioned above would. group_info
>>> seems
>>> to always be freed by put_group_info().
>>
>> The data can be freed _before_ get_group_info() is attempted.
>>
>> get_group_info() would do a use-after-free
>>
>> You would need something like RCU protection over this stuff,
>> this is not really only a netfilter change.
>>
> 
> sk_socket keeps reference to f_cred. f_cred keeps reference to
> group_info. As long as f_cred is alive and it doesn't seem to be the
> issue in the owner_mt() function, group_info should be alive as well as
> far as I can see. Its refcount will go down only when f_cred is freed
> (put_cred_rcu()).
> 
> If there is something I'm missing please correct me.

The problem is that you can´t clearly explain why the code is safe :/

Why would get_group_info() be needed then ?

You need to explain this in the changelog, so that future bug hunters do not have
to guess.

Note to netfilter maintainers : 

owner_mt() reads sk->sk_socket multiple times, this looks racy to me.

(sock_orphan() could be done in the middle from another cpu)


diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 46686fb73784bf71c79282e87e3f01f2c0411f5c..6adfb992bfe1765c57430b4bb98212786086d379 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -66,8 +66,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
        const struct file *filp;
        struct sock *sk = skb_to_full_sk(skb);
        struct net *net = xt_net(par);
+       struct socket *sock;
 
-       if (!sk || !sk->sk_socket || !net_eq(net, sock_net(sk)))
+       sock = sk ? READ_ONCE(sk->sk_socket) : NULL;
+       if (!sock || !net_eq(net, sock_net(sk)))
                return (info->match ^ info->invert) == 0;
        else if (info->match & info->invert & XT_OWNER_SOCKET)
                /*
@@ -76,7 +78,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
                 */
                return false;
 
-       filp = sk->sk_socket->file;
+       filp = sock->file;
        if (filp == NULL)
                return ((info->match ^ info->invert) &
                       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
