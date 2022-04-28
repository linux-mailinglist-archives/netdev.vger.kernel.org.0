Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE835137A6
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348721AbiD1PGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343735AbiD1PGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:06:54 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA24B3C71;
        Thu, 28 Apr 2022 08:03:36 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so4840740wmj.1;
        Thu, 28 Apr 2022 08:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J1yO6vfsXNk2QEX6CeOXZQScT3FcVVF3g4FzJ7/26KA=;
        b=LhtRPZjdNnlkOaBmn5PG03oSc+a/3b0eB3ZqEIpkdUTI8nrHoFW4tSlo+xphR3yRqO
         uhJMtefCFdH+EfoKxLu+NwSxpCvOllUmxvUgThgQRItwbABh9mFl91l5yQ2iMXxRXdj0
         FIVjL05C7Nd/kcWZivsMR2XHz0qrnLL4i1P061f37UqSwk7iDuvhU4CbUhEJuzlTosBS
         DD01z2ApD4xpQMjL/uZnSEJmKLNZ4mXqq/kfkAZAlVl7TS2iCXfzeTyrOIPL/bihFXyq
         ltIsiKjCxU6GpvqtOFjX8dk2lr0tkvcKLZgYmcSu4kspt6GfzUYVWAITc9b7R2YDQ/TK
         q/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J1yO6vfsXNk2QEX6CeOXZQScT3FcVVF3g4FzJ7/26KA=;
        b=vv4zWN9tloHd58mMO11MUsQ/y3qzg3/zpjLidJafnnOru7MsHY81apo76IDv7FhXNR
         +dtrm11nQ/zn5x+bCdCc7Y0ZzTAoaF2T8cdl2IyJXCiFcW0AK8UyL5pfRMVzHEBusRHt
         LhydT4Pr70maZoNV1NEZ3D4ArH8d6FLsG2PQbP/+bIsVJ4sX0aNg1yNcdX+V8J3x+rHt
         M3XDrIZeNKzMehAZlhuBSBE91UOzAN4VRryrSD62xfuYsy7DrfQ6Y7NihWoYrd3hzJ/u
         nM5sua6Vd9bVyQPmVtNuQ1eoMmO2A84750uxW7TBTii7JVVrgy85TDdur4ndDfIq9yRH
         2vbg==
X-Gm-Message-State: AOAM532FobzrFj9VGqvOItDp3TXJtwVFArPqCvMpCiRTYOSO0DGFeb2G
        t5IM3O0c8kVi7bR65Wxdc00=
X-Google-Smtp-Source: ABdhPJx9sazTAodFY/IGjny4Jl9CQ6mMn7WGsEf7+CwRiKDuw8zcLubxC/IvOM1Z2GfExZO+IMuJLw==
X-Received: by 2002:a05:600c:3393:b0:394:160a:18aa with SMTP id o19-20020a05600c339300b00394160a18aamr2459044wmp.58.1651158214520;
        Thu, 28 Apr 2022 08:03:34 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id l6-20020a1c2506000000b0038e6fe8e8d8sm216187wml.5.2022.04.28.08.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 08:03:34 -0700 (PDT)
Message-ID: <6b975bf6-453a-6020-bdcb-33fd02d275c3@gmail.com>
Date:   Thu, 28 Apr 2022 16:03:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 00/11] UDP/IPv6 refactoring
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1651071843.git.asml.silence@gmail.com>
 <353b5206205cc71d25998c9601a052dade081b94.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <353b5206205cc71d25998c9601a052dade081b94.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 15:04, Paolo Abeni wrote:
> On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
>> Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
>> cleaner than it was before and the series also removes a bunch of instructions
>> and other overhead from the hot path positively affecting performance.
>>
>> It was a part of a larger series, there were some perf numbers for it, see
>> https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/
>>
>> Pavel Begunkov (11):
>>    ipv6: optimise ipcm6 cookie init
>>    udp/ipv6: refactor udpv6_sendmsg udplite checks
>>    udp/ipv6: move pending section of udpv6_sendmsg
>>    udp/ipv6: prioritise the ip6 path over ip4 checks
>>    udp/ipv6: optimise udpv6_sendmsg() daddr checks
>>    udp/ipv6: optimise out daddr reassignment
>>    udp/ipv6: clean up udpv6_sendmsg's saddr init
>>    ipv6: partially inline fl6_update_dst()
>>    ipv6: refactor opts push in __ip6_make_skb()
>>    ipv6: improve opt-less __ip6_make_skb()
>>    ipv6: clean up ip6_setup_cork
>>
>>   include/net/ipv6.h    |  24 +++----
>>   net/ipv6/datagram.c   |   4 +-
>>   net/ipv6/exthdrs.c    |  15 ++--
>>   net/ipv6/ip6_output.c |  53 +++++++-------
>>   net/ipv6/raw.c        |   8 +--
>>   net/ipv6/udp.c        | 158 ++++++++++++++++++++----------------------
>>   net/l2tp/l2tp_ip6.c   |   8 +--
>>   7 files changed, 122 insertions(+), 148 deletions(-)
> 
> Just a general comment here: IMHO the above diffstat is quite
> significant and some patches looks completely non trivial to me.
> 
> I think we need a quite significant performance gain to justify the
> above, could you please share your performace data, comprising the
> testing scenario?

As mentioned I benchmarked it with a UDP/IPv6 max throughput kind of
test and only as a part of a larger series [1]. It was "2090K vs
2229K tx/s, +6.6%". Taking into account +3% from split out sock_wfree
optimisations, half if not most of the rest should be accounted to this
series, so a bit hand-wavingly +1-3%. Can spend some extra time
retesting this particular series if strongly required...

I was using [2], which is basically an io_uring copy of send paths of
selftests/net/msg_zerocopy. Should be visible with other tools, this
one just alleviates context switch / etc. overhead with io_uring.

./send-zc -6 udp -D <address> -t <time> -s16 -z0

It sends a number of 16 bytes UDP/ipv6 (non-zerocopy) send requests over
io_uring, then waits for them and repeats. It was 8 (default) requests
per iteration (i.e. syscall). I was using dummy netdev, so there is no
actual receiver, but it quite correlates with my server setup with mlx
cards, just takes more effort for me to test. And all with
mitigations=off

There might be some fatter targets to optimise, but udpv6_sendmsg()
and functions around take a good chunk of cycles as well, though without
particular hotspots. If we'd want some better justification than 1-3%,
then need to add more work on top, adding even more to diffstat...
vicious cycle.


[1] https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/
[2] https://github.com/isilence/liburing/blob/zc_v3/test/send-zc.c

-- 
Pavel Begunkov
