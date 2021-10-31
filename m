Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66617440EBF
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 15:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhJaOQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhJaOQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 10:16:57 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21BCC061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 07:14:25 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n15so766785qkp.12
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 07:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=43Su5xi2hv6819FQ4CQzU9X/G5y9nMdNyZHMOXl1Pyc=;
        b=btsEwiVToeFSWvJSQj65Gc0DIm2HCjsWTUXtneIk9C9nuLQZHs6LI38n6OdGpul/lL
         oKG6GLuunwQ5eQlGxcNLn+NQ3hXMmJUwz114M7ES25ksoFExUw9wr/gHqDTYa1MulzXL
         SE7htJPzo8WaM5lJ8aepdWbIENKwR7qhVr34S76BkyDQ27xsl6lMG6EDSN9BtIo6ops9
         mGHDt3FT4AIkfW3GUMgCpj609u8dSmx3cqg+9NkykR7/jDV/fcCLfr34UeqVnUqOSQyS
         +J+3Y9SbUldDWneD7R3Y6ZVsrXPP2gRKW9ys0bOaszyeqzAtry+E6g6IVLdPoqxtsICR
         F20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=43Su5xi2hv6819FQ4CQzU9X/G5y9nMdNyZHMOXl1Pyc=;
        b=g8JO3NHTB+YwFfDYc20g20MBpG5C2KvHDwGdPcvl5hiQoZSwBoYrwR7EbQR9552s31
         OdMM3PvL+DDdOmekiUncyXvI78DNtRWOrE9o8eDossl7ibHxRPJldyzHswrLdYA3ddt8
         7Tv+ZnGgop78Yhows9IYNmms4nAdJOUIsLN9yr823gA/VWoQDHv/lhBnk+Z5nXLkcDTO
         mBr3m79Rd3XLdDKAZUaMxpruO2SlWOLTvt3QeS3UMr+sF5OvvckVMPqVj9Xun+52M1LK
         Z+MvEet/pSmSCC/VLpoLeUCjLZZpmYUNUfN6luTTvKmzFS6TU3wfejiLYoZ/vpVUXjpu
         hGGw==
X-Gm-Message-State: AOAM532pEoY5KRpS23VW7LVlX/C7c/tD6c0Dcpa3AFyAc8FVKBi8dmwC
        /wYMg4iKZbXA93MCQnS1ZnpyKg==
X-Google-Smtp-Source: ABdhPJymRVPBWlLTm23oXHrxXVu6m89m9yDFPx/vaFk8ESS+kpbBe32lqa19fDxOg3exQWsrNd98pg==
X-Received: by 2002:a05:620a:430d:: with SMTP id u13mr18369193qko.93.1635689664842;
        Sun, 31 Oct 2021 07:14:24 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id z6sm8647162qta.31.2021.10.31.07.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 07:14:24 -0700 (PDT)
Message-ID: <4247ecd8-e4ca-0c35-5c0f-1124a043080f@mojatatu.com>
Date:   Sun, 31 Oct 2021 10:14:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
To:     Dave Taht <dave.taht@gmail.com>, Oz Shlomo <ozsh@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <CAA93jw4VphJ17yoV1S6aDRg2=W7hg=02Yr3XcX_aEBTzAt0ezw@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAA93jw4VphJ17yoV1S6aDRg2=W7hg=02Yr3XcX_aEBTzAt0ezw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-31 08:03, Dave Taht wrote:
[..]

> 
> Just as an on-going grump: It has been my hope that policing as a
> technique would have died a horrible death by now. Seeing it come back
> as an "easy to offload" operation here - fresh from the 1990s! does
> not mean it's a good idea, and I'd rather like it if we were finding
> ways to
> offload newer things that work better, such as modern aqm, fair
> queuing, and shaping technologies that are in pie, fq_codel, and cake.
> 
> policing leads to bursty loss, especially at higher rates, BBR has a
> specific mode designed to defeat it, and I ripped it out of
> wondershaper
> long ago for very good reasons:
> https://www.bufferbloat.net/projects/bloat/wiki/Wondershaper_Must_Die/
> 
> I did a long time ago start working on a better policing idea based on
> some good aqm ideas like AFD, but dropped it figuring that policing
> was going to vanish
> from the planet. It's baaaaaack.

A lot of enthusiasm for fq_codel in that link ;->
Root cause for burstiness is typically due to large transient queues
(which are sometimes not under your admin control) and of course if
you use a policer and dont have your double leaky buckets set properly
to compensate for both short and long term rates you will have bursts
of drops with the policer. It would be the same with shaper as well
if the packet burst shows up when the queue is full.

Intuitively it would feel, for non-work conserving approaches,
delaying a packet (as in shaping) is better than dropping (as in
policing) - but i have not a study which scientifically proves it.
Any pointers in that regard?
TCP would recover either way (either detecting sequence gaps or RTO).

In Linux kernel level i am not sure i see much difference in either
since we actually feedback an indicator to TCP to indicate a local
drop (as opposed to guessing when it is dropped in the network)
and the TCP code is smart enough to utilize that knowledge.
For hardware offload there is no such feedback for either of those
two approaches (so no difference with drop in the blackhole).

As to "policer must die" - not possible i am afraid;-> I mean there
has to be strong evidence that it is a bad idea and besides that
_a lot of hardware_ supports it;-> Ergo, we have to support it as well.
Note: RED for example has been proven almost impossible to configure
properly but we still support it and there's a good set of hardware
offload support for it. For RED - and i should say the policer as well -
if you configure properly, _it works_.


BTW, Some mellanox NICs offload HTB. See for example:
https://legacy.netdevconf.info/0x14/session.html?talk-hierarchical-QoS-hardware-offload

cheers,
jamal
