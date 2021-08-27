Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC45D3F9CF3
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhH0Qvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbhH0Qva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:51:30 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160DBC0617AE
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:50:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id v123so6148540pfb.11
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IoCnbaxvh/rWutqs/Zqh9RzCD4EeG4wA1jwu7wJ8wV4=;
        b=THIOCM1kcv1Cto18zmQmedF8Gng24+nw4gDILfoijsm44It/8UWxGf95tnQFmGfwRq
         BaWvkfSfc/dLqVRIdYpYuHlGb9iT6d7ONbMO5WywRckIWdAuBxPeaQWHUp2WbPwrCnGt
         bHQt75s31s1lqoppnMMJwPA3yWbYO6M53mbuLZ7QAxUiC0jznsV2YkL4q00xsDJ+TpNB
         yZQ91YDEc+2zs5T0cd5UuSOKf2r1TOLMnLFI8REo+8KGD0glA5oUddNwRn2dYQ6+9/Ma
         JIOyRNGob8SMfbhz73MCnYUWpZs+SnsV5W0rJV9wBett7jO3i0DqFUNTBmRCLlcHjQEg
         jMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IoCnbaxvh/rWutqs/Zqh9RzCD4EeG4wA1jwu7wJ8wV4=;
        b=TrVcoo47LYks8Myrw3EG2xDRaRm58tFdeUyUzbRYAeAAJYti3qpQ1kItapSDSXRj7M
         HA8p+qYLCiu33tXJmvmZOHhID2UymBZjJAqeGufjL9a60IhqA7v8yKghBqBhj17auyU9
         274MxydfTeanb48meeeMA9oVNRaYM9WbyW/ui0j04K0lZY7/q/NJAPfKdsrEYqvKDamC
         IUArhnhOMWgdVo/uQUk65qRqmwBl9yvT3eaFD8uOYXlZQYYwRkCdyCwLanac9kkF2wrW
         6HYUEF/YztpMnhpww5QQOAchXkC7/QwNYgohP4jTdn4VkFZ5YO1NlswhS6RJNwkSXqt7
         z55A==
X-Gm-Message-State: AOAM531UTAsTWir4H01vZAnuAw/DxFdpSHGWidtW4EcAFMjeYPAynxxr
        FTPMFQUA5M9CtLsQkZ6gsTRSmmPtuW0=
X-Google-Smtp-Source: ABdhPJw8O2lqrobWzL0YqgKxhgHNYAXQASGMCgMAadALDdE7FMa+N9stTpIo7DbLDLEP9HRtu4oX1Q==
X-Received: by 2002:a62:5304:0:b029:3c7:9dce:8a4c with SMTP id h4-20020a6253040000b02903c79dce8a4cmr9763145pfb.37.1630083035407;
        Fri, 27 Aug 2021 09:50:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id m13sm4344944pjv.20.2021.08.27.09.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 09:50:34 -0700 (PDT)
Subject: Re: IP routing sending local packet to gateway.
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <15a53d9cc54d42dca565247363b5c205@AcuMS.aculab.com>
 <adaaf38562be4c0ba3e8fe13b90f2178@AcuMS.aculab.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <532f9e8f-5e48-9e2e-c346-e2522f788a40@gmail.com>
Date:   Fri, 27 Aug 2021 09:50:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <adaaf38562be4c0ba3e8fe13b90f2178@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/21 9:39 AM, David Laight wrote:
> From: David Laight
>> Sent: 27 August 2021 15:12
>>
>> I've an odd IP routing issue.
>> A packet that should be sent on the local subnet (to an ARPed address)
>> is being send to the default gateway instead.
> 
> I've done some tests on a different network where it all appears to work.
> 
> But running 'tcpdump -pen' shows that all the outbound packets for the
> TCP connections are being sent to the default gateway.
> 
> 5.10.30, 5.10.61 and 5.14.0-rc7 all behave the same way.
> 
> If do a ping (in either direction) I get an ARP table entry.
> But TCP connections (in or out) always use the default gateway.
> 
> I'm now getting more confused.
> I noticed that the 'default route' was missing the 'metric 100' bit.
> That might give the behaviour I'm seeing if the netmask width is ignored.
> 
> But if I delete the default route (neither netstat -r or ip route show
> it) then packets are still being sent to the deleted gateway.
> If I delete the arp/neigh entry for the deleted default gateway an
> outward connection recreates the entry - leaving the one for the actual
> address 'STALE'.
> 
> Something very odd is going on.

perf record -e fib:* -a -g -- <run tests>
ctrl-c
perf script

It should tell you code paths and route lookup results. Should shed some
light on why the gw vs local.
