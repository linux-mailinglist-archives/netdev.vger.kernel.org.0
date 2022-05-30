Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA4253870E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241275AbiE3SJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241266AbiE3SJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:09:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4FF8A310
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 11:09:33 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c65so10575186pfb.1
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 11:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Pl8z9owjAlN0s60zpUvjbG45N9hdjXgNGc2VA4kDFws=;
        b=V2Z1sA9QSwonm1qg9k4dueXsiph7iF4vgEOnjksQyCV5nEKIa5gvHHivhjveCI+RzI
         Z+V1s+9QcZvcnRF0DLJN+F1+8Ow8pgSOdEsvwerMWcxKNQu914d/ADXQIsx0JnpCP5VS
         PGSn+cvkucnLuZlziI3fofs2gPDc/p6bQpH8RSZMhB6XsIRIX1PrAqB0GRqX6UvMeh6a
         s0CUsjcbJcGjj5SFMcFM72O418RaTba7XDPPW3xtHx56S+j8jfX7QBtar4e+4ZENon0G
         2Sn/Xk7iSHqzCSiwiCR9vzP48qitvFaN5phQLKIj502KrAmfMRm4Aau5wUJv8AD5eH/9
         mCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pl8z9owjAlN0s60zpUvjbG45N9hdjXgNGc2VA4kDFws=;
        b=1eVgNztBDTbfhCPDWEr7zDvitXqrdOLc/cneFmiYFr2kO0uFTgJvkHvNYXXHTKGBWo
         CKqFPAIA63aSOf0d6BcBgekKQuXdJS0LVvVQMI2jgKAs7UXm/o2jeWqYElmA2+hXTUmT
         bXSa85pqqEp20VIs4NL9OqQfheKvE/w3l3IaeQKkTBalbCkfDcdewJP37QmHnqinqaB3
         +0SZQx8YhrPSI1gw5V5kAgHVxloyjySS+VTPd3LQ0wq+7Y+I4a9Xr+TyqzA7t5S6u4Xp
         MStpups8lvSvjE6yhzHOOwRwBFIwqzAhwvWabCbwgAcvdbq+tkXuOAGmUnEL37JEp/Jg
         Unig==
X-Gm-Message-State: AOAM530skCkWblvXgXVo6JqIeROejduGMo3avZ9muyEXP/ktoHJ4IVDD
        zWmE2GFnFNNk1I+IoLKtfaE=
X-Google-Smtp-Source: ABdhPJyAHqm7EI6RoD8DEOCD5h1OQJTAHGCFHTXMDMGPcljYhkPLjhUy7U00mJWFCIF7fgYXWtF8Ig==
X-Received: by 2002:a65:6cc9:0:b0:399:26da:29af with SMTP id g9-20020a656cc9000000b0039926da29afmr49101154pgw.489.1653934172447;
        Mon, 30 May 2022 11:09:32 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z15-20020a1709028f8f00b0015e9f45c1f4sm9550250plo.186.2022.05.30.11.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 11:09:31 -0700 (PDT)
Message-ID: <7492f8e7-d4cc-8fe2-a02c-6749a8068be5@gmail.com>
Date:   Mon, 30 May 2022 11:09:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Bug in tcp_rtx_synack?
Content-Language: en-US
To:     Laurent Fasnacht <laurent.fasnacht@proton.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
References: <99ZT3wzzJiMfHBn9Ul-NdFqpZAo3QoZbOGfgFx-X60_EOIzwtUNC6991CzKn0CSNukTVz1ib9TrLSgTlhePSDVK70nTaQlx5oTxXHYbsSyg=@proton.ch>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <99ZT3wzzJiMfHBn9Ul-NdFqpZAo3QoZbOGfgFx-X60_EOIzwtUNC6991CzKn0CSNukTVz1ib9TrLSgTlhePSDVK70nTaQlx5oTxXHYbsSyg=@proton.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/30/22 03:08, Laurent Fasnacht wrote:
> Hello,
>
> I'm having the following bug on a 5.16 kernel, it happens periodically (a few times per day, on every of our production server that has this kernel). I'm unable to reproduce on machines with lower load and I also know for sure that it doesn't happen on the 5.10 kernel.
>
> I wonder if it's related to trace_tcp_retransmit_synack?
>
> I'm happy to help, let me know.
>
> Cheers,
> Laurent
>
> ---
>
> (gdb) l *(tcp_rtx_synack+0x8d)
> 0xffffffff817ee76d is in tcp_rtx_synack (arch/x86/include/asm/preempt.h:95).
> 90       * a decrement which hits zero means we have no preempt_count and should
> 91       * reschedule.
> 92       */
> 93      static __always_inline bool __preempt_count_dec_and_test(void)
> 94      {
> 95              return GEN_UNARY_RMWcc("decl", __preempt_count, e, __percpu_arg([var]));
> 96      }
> 97
> 98      /*
> 99       * Returns true when we need to resched and can (barring IRQ state).
> (gdb) l *(tcp_rtx_synack+0x8d-4)
> 0xffffffff817ee769 is in tcp_rtx_synack (include/trace/events/tcp.h:190).
> 185             TP_PROTO(struct sock *sk),
> 186
> 187             TP_ARGS(sk)
> 188     );
> 189
> 190     TRACE_EVENT(tcp_retransmit_synack,
> 191
> 192             TP_PROTO(const struct sock *sk, const struct request_sock *req),
> 193
> 194             TP_ARGS(sk, req),
>
> --
>
> BUG: using __this_cpu_add() in preemptible [00000000] code: epollpep/2180
> caller is tcp_rtx_synack.part.0+0x36/0xc0
> CPU: 10 PID: 2180 Comm: epollpep Tainted: G           OE     5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
> Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x48/0x5e
>   check_preemption_disabled+0xde/0xe0
>   tcp_rtx_synack.part.0+0x36/0xc0
>   tcp_rtx_synack+0x8d/0xa0
>   ? kmem_cache_alloc+0x2e0/0x3e0
>   ? apparmor_file_alloc_security+0x3b/0x1f0
>   inet_rtx_syn_ack+0x16/0x30
>   tcp_check_req+0x367/0x610
>   tcp_rcv_state_process+0x91/0xf60
>   ? get_nohz_timer_target+0x18/0x1a0
>   ? lock_timer_base+0x61/0x80
>   ? preempt_count_add+0x68/0xa0
>   tcp_v4_do_rcv+0xbd/0x270
>   __release_sock+0x6d/0xb0
>   release_sock+0x2b/0x90
>   sock_setsockopt+0x138/0x1140
>   ? __sys_getsockname+0x7e/0xc0
>   ? aa_sk_perm+0x3e/0x1a0
>   __sys_setsockopt+0x198/0x1e0
>   __x64_sys_setsockopt+0x21/0x30
>   do_syscall_64+0x38/0xc0
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fefe7d4441a
> Code: ff ff ff c3 0f 1f 40 00 48 8b 15 71 ea 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 46 ea 0b 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffca1cd0ab8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fefe7d4441a
> RDX: 0000000000000009 RSI: 0000000000000001 RDI: 00000000000006f3
> RBP: 00007ffca1cd1410 R08: 0000000000000004 R09: 0000560e9f8a55ec
> R10: 00007ffca1cd10f0 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffca1cd1190 R14: 00007ffca1cd1198 R15: 00007ffca1cd23f0
>   </TASK>
>

I think this is related to FastOpen server code.

It seems that we retransmit a SYNACK if we receive the SYN another time.

This means tcp_rtx_synack() can be called from process context (instead 
of BH handler) in this particular case.

Fix could be:

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 
b4b2284ed4a2c9e2569bd945e3b4e023c5502f25..1c054431e358328fe3849f5a45aaa88308a1e1c8 
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4115,8 +4115,8 @@ int tcp_rtx_synack(const struct sock *sk, struct 
request_sock *req)
         res = af_ops->send_synack(sk, NULL, &fl, req, NULL, 
TCP_SYNACK_NORMAL,
                                   NULL);
         if (!res) {
-               __TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
-               __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
+               TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
+               NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
                 if (unlikely(tcp_passive_fastopen(sk)))
                         tcp_sk(sk)->total_retrans++;
                 trace_tcp_retransmit_synack(sk, req);


