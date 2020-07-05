Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD6214FF0
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgGEVuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgGEVuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:50:44 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20026C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:50:44 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id m8so12205739qvk.7
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r5TRWG8dCaxIrixfDzkUhb3IMQnvc+d+rvTIbDAkxL8=;
        b=SoSEjDztaWM86siiCf2NOs3hMfwoCBXa6mx2+lIkaqItWs4qgZ82XWA2utYDdJzFJw
         xnJCLfpAIsHZAos53AoLWgx+x6vRcIuxNTr3sdl0LzeS73byYraFo9yMGuZhYZ0GjxGg
         3fUQcqgc+Tt6+HadYwE0T9VKo4fcmNBOgtwEE1WnqXJ1Ll3vdlGk9tZIcpY6yflIeInI
         Qq9Up4mVNuZs9XHnJj3G5G9OyJPmYbPNNUrto6p70akNTwKucy3cbfzm/SEFqZsL73x9
         osYq/p7T4l1vRnmHunM1RcUjcLA6AyAhdwmKwDQZ0RnvmH5UL+Bda2kBas0wGBF5mAoY
         Nnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r5TRWG8dCaxIrixfDzkUhb3IMQnvc+d+rvTIbDAkxL8=;
        b=LHFwfXFEDtBb3C/cEZNvgsp1dDOlYJvhy6rZUZjoQ2EnbG3oIDEjgG+sOs9SW4kIPP
         Y8S5C75P4CHx6eYJ1FOPR4U9+JP/sW97E1EPNZ1ilwxycF1DciapfiapeD6WI+I++jOY
         ARogQAn+qp/kYqOJBg2FuhjreovCzdShG1Bnyi2mtaOoNQwzUhlaTUqXe79Td09iYYHf
         p84dJy3SOZbF3k5NPyOnOj1fWomsKFJWph918nP0iwgYFdIOCIR2/eimJvFUGl3bwg8s
         i2VpRioUC19XVHU38IRi6wRcXD9oBxpwC0ZQPm6sVMQPaABo2vwTA3p6W/o7AwKOCoyo
         SXqg==
X-Gm-Message-State: AOAM532yDNX4XbQLseT6riXCZlR5V0Utyvz0hCVkLK6Fy3ZYRXnKNcr0
        uJRu7KL5CXBOkp9EDLJcz2dZ9Q==
X-Google-Smtp-Source: ABdhPJxgr0km6IZlQYil2bgaRHIuKhSaE221J0pR6gde24Q6BjK2V4pzblpdmhj2Yqtk+TZmwPMT4A==
X-Received: by 2002:a05:6214:1584:: with SMTP id m4mr42004382qvw.60.1593985843115;
        Sun, 05 Jul 2020 14:50:43 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id e23sm16518684qkl.55.2020.07.05.14.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:50:42 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, jiri@mellanox.com, kuba@kernel.org,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7c673079-043d-927b-fba2-e7a27d05f3e2@mojatatu.com>
Date:   Sun, 5 Jul 2020 17:50:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8ea64f66-8966-0f19-e329-1c0e5dc4d6d4@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ariel,

On 2020-07-05 1:26 p.m., Ariel Levkovich wrote:
> 
> On 7/3/20 7:22 AM, Jamal Hadi Salim wrote:
[..]
> Hi Jamal,
> 
> I agree that using skbedit makes some sense and can provide the same 
> functionality.
> 
> However I believe that from a concept point of view, using it is wrong.
> 
> In my honest opinion, the concept here is to perform some calculation on 
> the packet itself and its headers while the skb->hash field
> 
> is the storage location of the calculation result (in SW).
> 
> Furthermore, looking forward to HW offload support, the HW devices will 
> be offloading the hash calculation and
> 
> not rewriting skb metadata fields. Therefore the action should be the 
> hash, not skbedit.
> 
> Another thing that I can mention, which is kind of related to what I 
> wrote above, is that for all existing skbedit supported fields,
> 
> user typically provides a desired value of his choosing to set to a skb 
> metadata field.
> 
> Here, the value is unknown and probably not a real concern to the user.
> 
> 
> To sum it up, I look at this as performing some operation on the packet 
> rather then just
> 
> setting an skb metadata field and therefore it requires an explicit, new 
> action.
> 
> 
> What do you think?

skbedit is generally the action for any skb metadata modification
(of which hash is one).
Note: We already have skbedit offload for skbmark today.
The hash feature is useful for software as well (as your use case
showed). I agree with you that the majority of the cases are going to
be a computation of some form that results in dynamic skb->hash.
But the hash should be possible to be statically set by a policy.
BTW, nothing in skbedit is against computing what the new metadata
should be.

IMO: A good arguement to not make it part of skbedit is if it adds
unnecessary complexity to skbedit or policy definitions.

> 
>>
>> 2) I think it would make sense to create a skb hash classifier
>> instead of tying this entirely to flower i.e i should not
>> have to change u32 just so i can support hash classification.
>> So policy would be something of the sort:
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto tcp \
>> action skbedit hash bpf object-file <file> \
>> action goto chain 2
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 2 proto ip \
>> handle 0x0 skbhash  flowid 1:11 mask 0xf  \
>> action mirred egress redirect dev ens1f0_1
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 2 proto ip \
>> handle 0x1 skbhash  flowid 1:11 mask 0xf  \
>> action mirred egress redirect dev ens1f0_2
>>
>> IOW, we maintain current modularity as opposed
>> to dumping everything into flower.
>> Ive always wanted to write the skbhash classifier but
>> time was scarce. At one point i had some experiment
>> where I would copy skb hash into mark in the driver
>> and use fw classifier for further processing.
>> It was ugly.
> 
> I agree but perhaps we should make it a separate effort and not block 
> this one.
> 
> I still think we should have support via flower. This is the HW offload 
> path eventually.
> 

My main concern is modularity and the tc principle of doing small
things (and in principle doing them well).
Flower is becoming the sink for everything hardware
offload but f.e u32 also does h/w offload as well and we dont
want to limit it to just those two classifiers for the future...

Note: Flower is not very good performance-wise in the ingress in
s/ware. Something that is more specialized like the way skb mark fw
classifier is will be a lot more efficient. One good reason to make
hardware[1] do the hard work is to save the cyles in the host.
So to me adding to flower does not help that cause.

cheers,
jamal

[1] Whether the hash is set by RSS or an offloaded classifier or
shows up in some simple pkt header (IFE original patch had skb
hash being  set in one machine and transported across machines
for use in a remote machine - that setup is in use in production).

cheers,
jamal
