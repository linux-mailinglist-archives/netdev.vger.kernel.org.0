Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956FC3A5A58
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 22:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhFMU3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 16:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhFMU3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 16:29:23 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD4AC061766
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 13:27:21 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c18so21482725qkc.11
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 13:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=faFbMyl80bXR7GuaaFJL1FeJ9TBhi6dPb9qmsanjzk4=;
        b=UyslCa2RJDNps23ZMqWWYXURCA5ha631E1EoxTOD8iJMzcxCDV4g237tz3C1rKJxs/
         Zb2gvGh1xNm+rTwIBcpuWpzi4Hm9RtQ+uyKkD5NqHPRNodvMUKbUmJWY5KqXOe8TXEF2
         DfqNAuCYJ+VuLM0ULMsCur2So6/hXtb5OR9MfG2QaGpfy0wDcp3GFuI8S5D7Wn5LNgw2
         hgCPw00oSmTDMxMTFhHAKvVzh1I5hjox0LvwTP/nv10XfjTPMRFqWZ+NkkmZ1X2/d8fz
         vwZThF2ISmuFr5PU7+ZqxyEOpLVuYnyuxinEYFu7nA9Y/XcY+SHkXsQwiWqcBCpOpb+H
         geHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=faFbMyl80bXR7GuaaFJL1FeJ9TBhi6dPb9qmsanjzk4=;
        b=uct1zp+f0PW60nLIromudokjwg/pNry6MRTovYwycrxhUVoQXqjgGsFzA2EKmgiF9m
         OKscNv0eyW8fsdvHo/r8TmWqqrs3Ls9bOvzb+sjrPoctvkqngs+jc/8SSZvvHq2+1qsp
         dICTI3vUGZQbiOnh3pDbAyCMi7OTiWS66pCQsDpV0TgqvObSL4Ulp9pWrVHpv1rp5TnB
         UVVfOkqpE+rOn+nDWtrgyVBQ6BsT0JoCjGWTJun5GLsPU14/N7vSfhogsQl+b/S2g/fd
         UYcx/rhelpasJ3taCnOtrPQ2i/Q86NimPXtIEwLjP/9Er1DNlCYu+QQoYitMCBhSovsm
         wevw==
X-Gm-Message-State: AOAM533B3MMY7sBgz9/5YcaHkGBQ3EsFkI3OuhYagdPovI0v0nDXtKfN
        oyvy98AHRz4xT71oGMl6tfhS6LIU6CszicL6
X-Google-Smtp-Source: ABdhPJz1/+CwNBN3ZuLOyC7Gvo5yL6x8cBfnUoHo4gZXv4Q+Hd7xnB0LrUTblZvdIoSyOk3JCQ+XiQ==
X-Received: by 2002:a05:620a:131c:: with SMTP id o28mr13509782qkj.421.1623616038494;
        Sun, 13 Jun 2021 13:27:18 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-211.dsl.bell.ca. [184.148.47.211])
        by smtp.googlemail.com with ESMTPSA id t187sm8698626qkc.56.2021.06.13.13.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Jun 2021 13:27:17 -0700 (PDT)
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo>
 <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
Date:   Sun, 13 Jun 2021 16:27:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210613025308.75uia7rnt4ue2k7q@apollo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry - but i havent kept up with the discussion so some of this
and it is possible I may be misunderstanding some things you mention
in passing below (example that you only support da mode or the classid 
being able to be handled differently etc).
XDP may not be the best model to follow since some things that exist
in the tc architecture(example ability to have multi-programs)
seem to be plumbed in later (mostly because the original design intent
for XDP was to make it simple and then deployment follow and more
features get added)

Integrating tc into libbpf is a definete bonus that allows with a
unified programmatic interface and a singular loading mechanism - but
it wasnt clear why we loose some features that tc provides; we have
them today with current tc based loading scheme. I certainly use the
non-da scheme because over time it became clear that complex
programs(not necessarily large code size) are a challenge with ebpf
and using existing tc actions is valuable.
Also, multiple priorities are  important for the same reason - you
can work around them in your singular ebpf program but sooner than
later you will run out "tricks".

We do have this monthly tc meetup every second monday of the month.
Unfortunately it is short notice since the next one is monday 12pm
eastern time. Maybe you can show up and a high bandwidth discussion
(aka voice) would help?

cheers,
jamal

On 2021-06-12 10:53 p.m., Kumar Kartikeya Dwivedi wrote:
> On Fri, Jun 11, 2021 at 07:30:49AM IST, Cong Wang wrote:
>> On Tue, Jun 8, 2021 at 12:20 AM Kumar Kartikeya Dwivedi
>> <memxor@gmail.com> wrote:
>>>
>>> So we're not really creating a qdisc here, we're just tying the filter (which in
>>> the current semantics exists only while attached) to the bpf_link. The filter is
>>> the attachment, so tying its lifetime to bpf_link makes sense. When you destroy
>>> the bpf_link, the filter goes away too, which means classification at that
>>> hook (parent/class) in the qdisc stops working. This is why creating the filter
>>> from the bpf_link made sense to me.
>>
>> I see why you are creating TC filters now, because you are trying to
>> force the lifetime of a bpf target to align with the bpf program itself.
>> The deeper reason seems to be that a cls_bpf filter looks so small
>> that it appears to you that it has nothing but a bpf_prog, right?
>>
> 
> Yes, pretty much.
> 
>> I offer two different views here:
>>
>> 1. If you view a TC filter as an instance as a netdev/qdisc/action, they
>> are no different from this perspective. Maybe the fact that a TC filter
>> resides in a qdisc makes a slight difference here, but like I mentioned, it
>> actually makes sense to let TC filters be standalone, qdisc's just have to
>> bind with them, like how we bind TC filters with standalone TC actions.
> 
> You propose something different below IIUC, but I explained why I'm wary of
> these unbound filters. They seem to add a step to classifier setup for no real
> benefit to the user (except keeping track of one more object and cleaning it
> up with the link when done).
> 
> I understand that the filter is very much an object of its own and why keeping
> them unbound makes sense, but for the user there is no real benefit of this
> scheme (some things like classid attribute are contextual in that they make
> sense to be set based on what parent we're attaching to).
> 
>> These are all updated independently, despite some of them residing in
>> another. There should not be an exceptional TC filter which can not
>> be updated via `tc filter` command.
> 
> I see, but I'm mirroring what was done for XDP bpf_link.
> 
> Besides, flush still works, it's only that manipulating a filter managed by
> bpf_link is not allowed, which sounds reasonable to me, given we're bringing
> new ownership semantics here which didn't exist before with netlink, so it
> doesn't make sense to allow netlink to simply invalidate the filter installed by
> some other program.
> 
> You wouldn't do something like that for a cooperating setup, we're just
> enforcing that using -EPERM (bpf_link is not allowed to replace netlink
> installed filters either, so it goes both ways).
> 
>>
>> 2. For cls_bpf specifically, it is also an instance, like all other TC filters.
>> You can update it in the same way: tc filter change [...] The only difference
>> is a bpf program can attach to such an instance. So you can view the bpf
>> program attached to cls_bpf as a property of it. From this point of view,
>> there is no difference with XDP to netdev, where an XDP program
>> attached to a netdev is also a property of netdev. A netdev can still
>> function without XDP. Same for cls_bpf, it can be just a nop returns
>> TC_ACT_SHOT (or whatever) if no ppf program is attached. Thus,
>> the lifetime of a bpf program can be separated from the target it
>> attaches too, like all other bpf_link targets. bpf_link is just a
>> supplement to `tc filter change cls_bpf`, not to replace it.
>>
> 
> So this is different now, as in the filter is attached as usual but bpf_link
> represents attachment of bpf prog to the filter itself, not the filter to the
> qdisc.
> 
> To me it seems apart from not having to create filter, this would pretty much be
> equivalent to where I hook the bpf_link right now?
> 
> TBF, this split doesn't really seem to be bringing anything to the table (except
> maybe preserving netlink as the only way to manipulate filter properties) and
> keeping filters as separate objects. I can understand your position but for the
> user it's just more and more objects to keep track of with no proper
> ownership/cleanup semantics.
> 
> Though considering it for cls_bpf in particular, there are mainly three things
> you would want to tc filter change:
> 
> * Integrated actions
>    These are not allowed anyway, we force enable direct action mode, and I don't
>    plan on opening up actions for this if its gets accepted. Anything missing
>    we'll try to make it work in eBPF (act_ct etc.)
> 
> * classid
>    cls_bpf has a good alternative of instead manipulating __sk_buff::tc_classid
> 
> * skip_hw/skip_sw
>    Not supported for now, but can be done using flags in BPF_LINK_UPDATE
> 
> * BPF program
>    Already works using BPF_LINK_UPDATE
> 
> So bpf_link isn't really prohibitive in any way.
> 
> Doing it your way also complicates cleanup of the filter (in case we don't want
> to leave it attached), because it is hard to know who closes the link_fd last.
> Closing it earlier would break the link for existing users, not doing it would
> leave around unused object (which can accumulate if we use auto allocation of
> filter priority). Counting existing links is racy.
> 
> This is better done in the kernel than worked around in userspace, as part of
> attachment.
> 
>> This is actually simpler, you do not need to worry about whether
>> netdev is destroyed when you detach the XDP bpf_link anyway,
>> same for cls_bpf filters. Likewise, TC filters don't need to worry
>> about bpf_links associated.
>>
>> Thanks.
> 
> --
> Kartikeya
> 

