Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D39219E8B
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 13:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgGILAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 07:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgGILA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 07:00:29 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93649C061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 04:00:29 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so712718qvb.11
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 04:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gzs80DbqizQb6PWbYEUQZBzsoiPrDpqyMc4SXWZRAiM=;
        b=0sI956gw9jxUG1e1UOMPiJs9Z9cLl2CNMpVDTxypqgsfoHL0C6/HLjATiDDAU2ZqHW
         hht02QJeRKwBATNcybhccD2uG/ekGaJUDPFmRPrIdvpyUO7XGv90AohhRchw3FTX/apo
         kVKBG26KxY6RMvjSnHi6QZIddvaVo5T9N3LKPt5OK+VVMl70x0TskTgSG6op6h7NgaAu
         R5q6YhBJlyTnu6TY/p61FFWzZ8kdJuzcosGjbcOCQZFSo3lLy1kwHTTG6lI6/gomkjtb
         i9RlN1pYlXfPrsL3AaMd1k7pJ7MOJPYIKc0+LnYE7cIoFK5D4KjH99mqSbTFnz4iJ0vS
         7g0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gzs80DbqizQb6PWbYEUQZBzsoiPrDpqyMc4SXWZRAiM=;
        b=STxCPHDqGdIZ9ZuDp5Su8z3s999lzG8HNS3kozVdxg0ebxFv9xFtHi9MX/TVyuG3uB
         ppK0FboXYSUAj6PLuvjb9jwpzghpIj78TASCXhFWBhw3GstJHeuC19pHTsODmUHvbOxh
         Zpww3ITzu8U4BnWqmoB7E1VdrMqui68JbrfEgo08tS++A1ChXDa//QYtpAWcKEGIcV1G
         IWLMiqZExE2Hj4MljX/yt6JhHP10JfKYmEUVnhuFyZoWGhAv5KagsR6XWXfogwJ0OqcU
         E+VcfNmvWpRDr2SW0yxHR7dMw3ht+ZUvSw+Hs7zJCbzGH+IKmkMSxOKfMqxLyIlJzWL3
         kApw==
X-Gm-Message-State: AOAM530HS8jZZiqyNRwuOoDhdIbmDfOIjYC5dVc/47dt+gLBSh2eRTvB
        lV8SK8bgIx5+HWtKSlnFIGx2og==
X-Google-Smtp-Source: ABdhPJy7a7Tb5EAs+c+DzcAN1xdy+9xyJkorOc7z3/kv6FU1N+fdKElXuKcJZiapQLISMvW9u3VVkw==
X-Received: by 2002:a05:6214:12c:: with SMTP id w12mr15635680qvs.78.1594292428742;
        Thu, 09 Jul 2020 04:00:28 -0700 (PDT)
Received: from [192.168.1.117] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id x29sm3500984qtx.74.2020.07.09.04.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 04:00:27 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/3] ] TC datapath hash api
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        kuba@kernel.org, xiyou.wangcong@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
References: <20200701184719.8421-1-lariel@mellanox.com>
 <13b36fb1-f93e-dad7-9dba-575909197652@mojatatu.com>
 <20200707100556.GB2251@nanopsycho.orion>
 <20877e09-45f2-fa89-d11c-4ae73c9a7310@mojatatu.com>
 <20200708144508.GB3667@nanopsycho.orion>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <908144ff-315c-c743-ed2e-93466d40523c@mojatatu.com>
Date:   Thu, 9 Jul 2020 07:00:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708144508.GB3667@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-08 10:45 a.m., Jiri Pirko wrote:
> Wed, Jul 08, 2020 at 03:54:14PM CEST, jhs@mojatatu.com wrote:
>> On 2020-07-07 6:05 a.m., Jiri Pirko wrote:


[..]
>> IMO:
>> For this specific case where _offload_ is the main use case i think
>> it is not a good idea because flower on ingress is slow.
> 
> Eh? What do you mean by that?
> 
> 
>> The goal of offloading classifiers to hardware is so one can reduce
>> consumed cpu cycles on the host. If the hardware
>> has done the classification for me, a simple hash lookup of the
>> 32 bit skbhash(similar to fw) in the host would be a lot less
>> compute intensive than running flower's algorithm.
> 
> It is totally up to the driver/fw how they decide to offload flower.
> There are multiple ways. So I don't really follow what do you mean by
> "flower's algorithm"
> 

Nothing to do with how a driver offloads. That part is fine.

By "flower's algorithm" I mean the fact you have to parse and
create the flow cache from scratch on ingress - that slows down
the ingress path. Compare, from cpu cycles pov, to say fw
classifier which dereferences skbmark and uses it as a key
to lookup a hash table.
An skbhash classifier would look the same as fw in its
approach.
subtle point i was making was: if your goal was to save cpu cycles
by offloading the lookup(whose result you then use to do
less work on the host) then you need all the cycles you can
save.

Main point is: classifying based on hash(and for that
matter any other metadata like mark) is needed as a general
utility for the system and should not be only available for
flower. The one big reason we allow all kinds of classifiers
in tc is in the name of "do one thing and do it well".
It is impossible for any one classifier to classify everything
and do a good job at it. For example, I hope you are NEVER
going to add string classification in flower.

Note, what i am describing has precendence:
I can do the same thing with skbmark offloading today.
On ingress I use fw classifier (not u32 or flower).

> 
>>
>> I think there is a line for adding everything in one place,
>> my main concern is that this feature this is needed
>> by all classifiers and not just flower.
> 
> "All" is effectively only flower. Let's be clear about that.
> 

Unless I am misunderstanding, why is it just about flower?
u32 does offload to some hardware. RSS can set this value
and various existing things like XDP, tc ebpf and the action
posted by Ariel.

cheers,
jamal
