Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5F14FBBA1
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiDKMHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiDKMHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:07:07 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CF73A1A6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:04:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id u17-20020a05600c211100b0038eaf4cdaaeso3286706wml.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E//4mWhP6CG/ZkqhrqSeXFwz+Zo69xEls9lzXQvB3jU=;
        b=ZLiJC4Ve9WtWf5EZ62GPCgydug1v92Jyr48OphLJr+OavIuIGPhQWY1Qpynv13R+Ku
         CYk8cOfTDs3/+4u3bnQjK4WbgVMT7L14j/d1nTz74+IvGB/V8Wz5ONhEorF8vXdDwtTo
         F9fs5wV+trKSMZpI27NA6OpkiLhgiCnj9wvQlM1VWpJETU/gAJ0tAkE1cK7O4ZfI1H19
         L8aAxShicLc1Th+cWA/BaL16foR8BFhX68RAaVZFlzMpf9QROsRjX+EWwhFyMQfJH/Tq
         kh1X2/Z5QvpLy7pE5Ws4Q0GjeaLeO+Fw8rC5CBgRbgl26pnWToVVyW/33hunNqMAFdUt
         gt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E//4mWhP6CG/ZkqhrqSeXFwz+Zo69xEls9lzXQvB3jU=;
        b=fhVGnL4Q7sdwAJi2GvmoZn6DGFU3FZ5DjUYu8/vdoqhLC6Q3onETzbtYh/7i5sdck3
         x/3RB89bUxE5ZBb3PuHyZ4OYRCd/h3eR/m7WaZ1PpxXdoWffdYwv5FbfyGqL/eWLCmrV
         eVw9zIY7mxv1HnUjNOuu5MOMJwPMJjedL9lKxYljQQOZ6TBIgZ2vT77UcaxdwYXBalqg
         oIWcjY5hv4yXCLqudbvr7YN0K0qrXwr147dEO35g2F+bXqUo9G1mSibcyTjk0TB5AvMK
         Aq7g4JchyzBaaFzzXKL3B7onGQ2xSKgd4DlP3Atzu1rRz/CrK0tDHs+tFppeoAmKVCe7
         hN8w==
X-Gm-Message-State: AOAM530PfXkDL2xUovUiOUTF83OYDjtz2UUW+eQ7kBgAH24QiuZ+cZvS
        fyN5NjDUdozKOao+/pLTPmQ=
X-Google-Smtp-Source: ABdhPJwoGsB2Qx8UmmDV3bQVWdIOcq0fd1QnOVjtLtxDIOPgZppRJ8lVCf+WaTsHUg5jhdcfLrsTWw==
X-Received: by 2002:a1c:3b08:0:b0:38e:ae26:87c3 with SMTP id i8-20020a1c3b08000000b0038eae2687c3mr11090567wma.117.1649678690954;
        Mon, 11 Apr 2022 05:04:50 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id r129-20020a1c2b87000000b0038e6a025d05sm18582510wmr.18.2022.04.11.05.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 05:04:50 -0700 (PDT)
Message-ID: <f0a8e790-aff5-db72-d42e-1cbfe711a092@gmail.com>
Date:   Mon, 11 Apr 2022 13:04:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [RFC net-next 00/27] net and/or udp optimisations
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>
References: <cover.1648981570.git.asml.silence@gmail.com>
 <CANn89iL0anmfcX1v1NqOQ6xi2VfY7CmiUwav0jNbz6GuSjUspQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CANn89iL0anmfcX1v1NqOQ6xi2VfY7CmiUwav0jNbz6GuSjUspQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/22 10:44, Eric Dumazet wrote:
> On Sun, Apr 3, 2022 at 6:08 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> A mix of various net optimisations, which were mostly discovered during UDP
>> testing. Benchmarked with an io_uring test using 16B UDP/IPv6 over dummy netdev:
>> 2090K vs 2229K tx/s, +6.6%, or in a 4-8% range if not averaging across reboots.
>>
>> 1-3 removes extra atomics and barriers from sock_wfree() mainly benefitting UDP.
>> 4-7 cleans up some zerocopy helpers
>> 8-16 do inlining of ipv6 and generic net pathes
>> 17 is a small nice performance improvement for TCP zerocopy
>> 18-27 refactors UDP to shed some more overhead
>>

> Please send a smaller series first.

Apologies for delays. Ok, I'll split it.

> About inlining everything around, make sure to include performance
> numbers only for the inline parts.
> We can inline everything and make the kernel 4 x time bigger.
> Synthetic benchmarks will still show improvements but in overall, we
> add icache cost that is going to hurt latencies.

I do care about kernel bloating, but I think we can agree that for most
patches inlining is safe. There are 6 such patches (9-12,15,16). Three
of them (9,11,15) only do simple redirecting to another function
skb_csum_hwoffload_help() in 10 has only two callers. I think we can
agree that they're safe to inline.

That leaves ip6_local_out() with ~8 callers and used quite heavily. And
fl6_update_dst() with ~12 users, I don't have exact data but it appears
not everybody uses ip6 options and so the function does nothing. At
least that's true for UDP cases I care about. I think it's justified
to be inlined. Would you prefer these two to be removed?


> I vote that you focus on the other parts first.
> 
> Thank you.
> 
>> Pavel Begunkov (27):
>>    sock: deduplicate ->sk_wmem_alloc check
>>    sock: optimise sock_def_write_space send refcounting
>>    sock: optimise sock_def_write_space barriers
>>    skbuff: drop zero check from skb_zcopy_set
>>    skbuff: drop null check from skb_zcopy
>>    net: xen: set zc flags only when there is ubuf
>>    skbuff: introduce skb_is_zcopy()
>>    skbuff: optimise alloc_skb_with_frags()
>>    net: inline sock_alloc_send_skb
>>    net: inline part of skb_csum_hwoffload_help
>>    net: inline skb_zerocopy_iter_dgram
>>    ipv6: inline ip6_local_out()
>>    ipv6: help __ip6_finish_output() inlining
>>    ipv6: refactor ip6_finish_output2()
>>    net: inline dev_queue_xmit()
>>    ipv6: partially inline fl6_update_dst()
>>    tcp: optimise skb_zerocopy_iter_stream()
>>    net: optimise ipcm6 cookie init
>>    udp/ipv6: refactor udpv6_sendmsg udplite checks
>>    udp/ipv6: move pending section of udpv6_sendmsg
>>    udp/ipv6: prioritise the ip6 path over ip4 checks
>>    udp/ipv6: optimise udpv6_sendmsg() daddr checks
>>    udp/ipv6: optimise out daddr reassignment
>>    udp/ipv6: clean up udpv6_sendmsg's saddr init
>>    ipv6: refactor opts push in __ip6_make_skb()
>>    ipv6: improve opt-less __ip6_make_skb()
>>    ipv6: clean up ip6_setup_cork
>>
>>   drivers/net/xen-netback/interface.c |   3 +-
>>   include/linux/netdevice.h           |  27 ++++-
>>   include/linux/skbuff.h              | 102 +++++++++++++-----
>>   include/net/ipv6.h                  |  37 ++++---
>>   include/net/sock.h                  |  10 +-
>>   net/core/datagram.c                 |   2 -
>>   net/core/datagram.h                 |  15 ---
>>   net/core/dev.c                      |  28 ++---
>>   net/core/skbuff.c                   |  59 ++++-------
>>   net/core/sock.c                     |  50 +++++++--
>>   net/ipv4/ip_output.c                |  10 +-
>>   net/ipv4/tcp.c                      |   5 +-
>>   net/ipv6/datagram.c                 |   4 +-
>>   net/ipv6/exthdrs.c                  |  15 ++-
>>   net/ipv6/ip6_output.c               |  88 ++++++++--------
>>   net/ipv6/output_core.c              |  12 ---
>>   net/ipv6/raw.c                      |   8 +-
>>   net/ipv6/udp.c                      | 158 +++++++++++++---------------
>>   net/l2tp/l2tp_ip6.c                 |   8 +-
>>   19 files changed, 339 insertions(+), 302 deletions(-)
>>   delete mode 100644 net/core/datagram.h
>>
>> --
>> 2.35.1
>>

-- 
Pavel Begunkov
