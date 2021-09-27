Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53C341A15C
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 23:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhI0Vfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 17:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbhI0Vff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 17:35:35 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC41DC061575;
        Mon, 27 Sep 2021 14:33:56 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id n23so14258377pfv.4;
        Mon, 27 Sep 2021 14:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KRUntgfDBi53GMkxCXevXBnnvVff9jqBgaMDIpl5H9U=;
        b=NZG3prOK6Mm7t4GMt7iudh91oMNsRrL3PwjYwvntsEwTdafFfnzHZbyLXzmrc+C1v6
         2alNXGI3br9pd+zw1FoScE0y4hqEoggzGiIZugN3fija0q2BeMNutWmuGbIfcyurqUAC
         BshrTpfMsuQ9+v4+s8EQHhQ+B72n5B54bCagkSmwetYr4SZf6s8WP83RWcdRqoebaydW
         HByv7sJjahpqWiexJsTRXarwyDESHgvhEe2NOLnUqoLmicvtKw0l0bXCZQANLCAErMfL
         x+oGylpo8KIc+1f1/cS4824fmQetsKrJJkkZi2ioVdrrPAoSHZjLL26ZrnzDLVAlqhjh
         9YCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KRUntgfDBi53GMkxCXevXBnnvVff9jqBgaMDIpl5H9U=;
        b=hyPmH7EmAW1azNIwZKcjg1G0KTq6KOl91x34Ngp4WxuEOaoBqS/1v3G74PaMvP4R0l
         Uj1rMIdWdFw+b18Q4GF4PgY55dijzeknSL/1wVjA4TpiqLGrFt5SxK/8W2YqETkFfwlp
         OwvmGujZqAOM5eCf5yowRYhp/+lDIu9SOeB58NMln2eVTxnfzulz3k7LdX4mQbaPEv6y
         Ne6TQmbOObia1yBUOX696JHdF7wag2GKH15VkM+jBZIIs2K4UJM875SUS8RLLx/lgdhk
         14gqe0yLFes/9fzh4amEG4E/jUghcyirArhjkLWu4o9atTao3GNqEfqIFeFcTte8jMJz
         km7Q==
X-Gm-Message-State: AOAM532QG6V7eZ+4ZMTdR4nLHcwO0tJlFobPv7uIdbBS+EKt6M5kws83
        TaFN/ll70B9fQ5PXCLbxjW4=
X-Google-Smtp-Source: ABdhPJzQ3X/28Btcaf33Y7MrHc26PINFM5RCKbVGJsbtX2FhOsjKSFTNkptwiftzEbSfQyqpJlgecA==
X-Received: by 2002:a63:ce52:: with SMTP id r18mr1470379pgi.350.1632778436358;
        Mon, 27 Sep 2021 14:33:56 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i24sm339788pjl.8.2021.09.27.14.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 14:33:55 -0700 (PDT)
Subject: Re: [PATCH] fs: eventpoll: add empty event
To:     Johannes Lundberg <jlundberg@llnw.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Alexander Aring <aahringo@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
References: <20210927202923.7360-1-jlundberg@llnw.com>
 <CANn89iJP7xpVnw6UnZwnixaAh=2+5f571CiqepYi2sy3-1MXmQ@mail.gmail.com>
 <c675343d-a5bc-dce0-bcde-8a952682e698@llnw.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <dc5ddf13-b524-42a8-ed7a-5db91aaee4ef@gmail.com>
Date:   Mon, 27 Sep 2021 14:33:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c675343d-a5bc-dce0-bcde-8a952682e698@llnw.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/21 2:17 PM, Johannes Lundberg wrote:
> 
> On 9/27/21 1:47 PM, Eric Dumazet wrote:
>> On Mon, Sep 27, 2021 at 1:30 PM Johannes Lundberg <jlundberg@llnw.com> wrote:
>>> The EPOLLEMPTY event will trigger when the TCP write buffer becomes
>>> empty, i.e., when all outgoing data have been ACKed.
>>>
>>> The need for this functionality comes from a business requirement
>>> of measuring with higher precision how much time is spent
>>> transmitting data to a client. For reference, similar functionality
>>> was previously added to FreeBSD as the kqueue event EVFILT_EMPTY.
>>
>> Adding yet another indirect call [1] in TCP fast path, for something
>> (measuring with higher precision..)
>> which is already implemented differently in TCP stack [2] is not desirable.
>>
>> Our timestamping infrastructure should be ported to FreeBSD instead :)
>>
>> [1] CONFIG_RETPOLINE=y
>>
>> [2] Refs :
>>     commit e1c8a607b28190cd09a271508aa3025d3c2f312e
>>        net-timestamp: ACK timestamp for bytestreams
>>      tools/testing/selftests/net/txtimestamp.c
> 
> Hi Eric
> 
> Thanks for the feedback! If there's a way to achieve the same thing with current Linux I'm all for it. I'll look into how to use timestamps for this.
> 

You are welcome !

Note that timestamping allows to trigger many events, even if write queue is not empty.

This is particularly useful when an application does not want a write queue to be drained,
since this would add transmit stalls.

Also, since the events are time stamped exactly when the relevant ACK are processed,
they are more accurate than something based on epoll, since I guess you would
get timestamps after a thread wakeup.

