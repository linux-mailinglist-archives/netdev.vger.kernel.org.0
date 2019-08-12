Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09068A500
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfHLR42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:56:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35441 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfHLR40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 13:56:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id k2so19508012wrq.2;
        Mon, 12 Aug 2019 10:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Gl3MQ2tK3gT5Rkg1mXDEZb3rifYtV7MbGB7zqaaTNjM=;
        b=KS2A7osSztDhQm7wnRwCJMQpkcZjvC7WtVcQmA9QJ27tlxwcDZYgTSw1t4Kmy8j/pK
         WbFOPdHXiYMXJ5pB/etlWb0pFpI3tPwjoZAHt+lS6vI0Lq0xSR2OwSSP9mxf88J4Scte
         IFNTqeeIsl5bRaYzTaetJFIHBau0cZ77B5L7EBrgh7pzpTK0v7BTMKJcAj3O8Su+74H2
         vn1gyP+k5sRpSri/LcidBwVxQ74EWcqYiRDDGpYtQl/0i/SwR4dM17uc9gWIIDXQpGRt
         t9SoPYYVfJoSsDnJK98cIo4DxBAlQ/hiFj2gGKqWYeufpnxjskvRVMmWCmbXvzGX7alm
         jFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gl3MQ2tK3gT5Rkg1mXDEZb3rifYtV7MbGB7zqaaTNjM=;
        b=aKZnKcxztTnnPJG3oSZ87uGEqPj75lONdvfvGdYXyXdH3AJ6njvU0AXIaBbMHuL1X+
         IT4ZVtQ7WRlS/6OzX1YpAVHsjhxtsBuOavZwNanb24YDCo8Y/TUyIkyi73Eua9joW7wr
         HL9ai8bTk8xJQi7KyGvg1S/SBy7n8R32yaGInsHWqwUIouPAZOJ/bvGozeywjqbgzc8t
         Vtd/9Eb1L1xYaWLdRLrSIOGuy6vumVVoh2dlc1YMx0Cdqtcmjvx+Xhl8wRLg1NHWErBU
         uSszlU5fLMslGi7A42aG2bCUlBHkhWS5l8ZvrC2gLZ6quW7DP+DCFaSUjPpP2rEvAJrW
         lXTw==
X-Gm-Message-State: APjAAAXt/DghgeT3ihphI0kr2r71fiSjJweEJ/twGSTPoPf3cHZJCX7p
        KKDhf5TjnVF4rbxIhIzvOEND0TLv
X-Google-Smtp-Source: APXvYqwCorf8OVy3FnwJDHRo5pDsoGs4Ka9e15CSz7OYly9qvMRE4aDMfgmsHeq9cvnU0KE3Inr4ug==
X-Received: by 2002:a5d:528a:: with SMTP id c10mr8612833wrv.111.1565632584205;
        Mon, 12 Aug 2019 10:56:24 -0700 (PDT)
Received: from [192.168.8.147] (239.169.185.81.rev.sfr.net. [81.185.169.239])
        by smtp.gmail.com with ESMTPSA id a11sm8258030wrx.59.2019.08.12.10.56.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 10:56:23 -0700 (PDT)
Subject: Re: 5.3-rc3-ish VM crash: RIP: 0010:tcp_trim_head+0x20/0xe0
To:     Sander Eikelenboom <linux@eikelenboom.it>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <27aebb57-0ca9-fba3-092f-39131ad2b648@eikelenboom.it>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4d803565-b716-42ab-1db8-3dcade91e939@gmail.com>
Date:   Mon, 12 Aug 2019 19:56:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <27aebb57-0ca9-fba3-092f-39131ad2b648@eikelenboom.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/19 2:50 PM, Sander Eikelenboom wrote:
> L.S.,
> 
> While testing a somewhere-after-5.3-rc3 kernel (which included the latest net merge (33920f1ec5bf47c5c0a1d2113989bdd9dfb3fae9),
> one of my Xen VM's (which gets quite some network load) crashed.
> See below for the stacktrace.
> 
> Unfortunately I haven't got a clear trigger, so bisection doesn't seem to be an option at the moment. 
> I haven't encountered this on 5.2, so it seems to be an regression against 5.2.
> 
> Any ideas ?
> 
> --
> Sander
> 
> 
> [16930.653595] general protection fault: 0000 [#1] SMP NOPTI
> [16930.653624] CPU: 0 PID: 3275 Comm: rsync Not tainted 5.3.0-rc3-20190809-doflr+ #1
> [16930.653657] RIP: 0010:tcp_trim_head+0x20/0xe0
> [16930.653677] Code: 2e 0f 1f 84 00 00 00 00 00 90 41 54 41 89 d4 55 48 89 fd 53 48 89 f3 f6 46 7e 01 74 2f 8b 86 bc 00 00 00 48 03 86 c0 00 00 00 <8b> 40 20 66 83 f8 01 74 19 31 d2 31 f6 b9 20 0a 00 00 48 89 df e8
> [16930.653741] RSP: 0000:ffffc90000003ad8 EFLAGS: 00010286
> [16930.653762] RAX: fffe888005bf62c0 RBX: ffff8880115fb800 RCX: 000000008010000b

crash in " mov    0x20(%rax),%eax"   and RAX=fffe888005bf62c0 (not a valid kernel address)

Look like one bit corruption maybe.

Nothing comes to mind really between 5.2 and 53 that could explain this.

> [16930.653791] RDX: 00000000000005a0 RSI: ffff8880115fb800 RDI: ffff888016b00880
> [16930.653819] RBP: ffff888016b00880 R08: 0000000000000001 R09: 0000000000000000
> [16930.653848] R10: ffff88800ae00800 R11: 00000000bfe632e6 R12: 00000000000005a0
> [16930.653875] R13: 0000000000000001 R14: 00000000bfe62d46 R15: 0000000000000004
> [16930.653913] FS:  00007fe71fe2cb80(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000
> [16930.653943] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16930.653965] CR2: 000055de0f3e7000 CR3: 0000000011f32000 CR4: 00000000000006f0
> [16930.653993] Call Trace:
> [16930.654005]  <IRQ>
> [16930.654018]  tcp_ack+0xbb0/0x1230
> [16930.654033]  tcp_rcv_established+0x2e8/0x630
> [16930.654053]  tcp_v4_do_rcv+0x129/0x1d0
> [16930.654070]  tcp_v4_rcv+0xac9/0xcb0
> [16930.654088]  ip_protocol_deliver_rcu+0x27/0x1b0
> [16930.654109]  ip_local_deliver_finish+0x3f/0x50
> [16930.654128]  ip_local_deliver+0x4d/0xe0
> [16930.654145]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
> [16930.654163]  ip_rcv+0x4c/0xd0
> [16930.654179]  __netif_receive_skb_one_core+0x79/0x90
> [16930.654200]  netif_receive_skb_internal+0x2a/0xa0
> [16930.654219]  napi_gro_receive+0xe7/0x140
> [16930.654237]  xennet_poll+0x9be/0xae0
> [16930.654254]  net_rx_action+0x136/0x340
> [16930.654271]  __do_softirq+0xdd/0x2cf
> [16930.654287]  irq_exit+0x7a/0xa0
> [16930.654304]  xen_evtchn_do_upcall+0x27/0x40
> [16930.654320]  xen_hvm_callback_vector+0xf/0x20
> [16930.654339]  </IRQ>
> [16930.654349] RIP: 0033:0x55de0d87db99
> [16930.654364] Code: 00 00 48 89 7c 24 f8 45 39 fe 45 0f 42 fe 44 89 7c 24 f4 eb 09 0f 1f 40 00 83 e9 01 74 3e 89 f2 48 63 f8 4c 01 d2 44 38 1c 3a <75> 25 44 38 6c 3a ff 75 1e 41 0f b6 3c 24 40 38 3a 75 14 41 0f b6
> [16930.654432] RSP: 002b:00007ffd5531eec8 EFLAGS: 00000a87 ORIG_RAX: ffffffffffffff0c
> [16930.655004] RAX: 0000000000000002 RBX: 000055de0f3e8e50 RCX: 000000000000007f
> [16930.655034] RDX: 000055de0f3dc2d2 RSI: 0000000000003492 RDI: 0000000000000002
> [16930.655062] RBP: 0000000000007fff R08: 00000000000080ea R09: 00000000000001f0
> [16930.655089] R10: 000055de0f3d8e40 R11: 0000000000000094 R12: 000055de0f3e0f2a
> [16930.655116] R13: 0000000000000010 R14: 0000000000007f16 R15: 0000000000000080
> [16930.655144] Modules linked in:
> [16930.655200] ---[ end trace 533367c95501b645 ]---
> [16930.655223] RIP: 0010:tcp_trim_head+0x20/0xe0
> [16930.655243] Code: 2e 0f 1f 84 00 00 00 00 00 90 41 54 41 89 d4 55 48 89 fd 53 48 89 f3 f6 46 7e 01 74 2f 8b 86 bc 00 00 00 48 03 86 c0 00 00 00 <8b> 40 20 66 83 f8 01 74 19 31 d2 31 f6 b9 20 0a 00 00 48 89 df e8
> [16930.655312] RSP: 0000:ffffc90000003ad8 EFLAGS: 00010286
> [16930.655331] RAX: fffe888005bf62c0 RBX: ffff8880115fb800 RCX: 000000008010000b
> [16930.655360] RDX: 00000000000005a0 RSI: ffff8880115fb800 RDI: ffff888016b00880
> [16930.655387] RBP: ffff888016b00880 R08: 0000000000000001 R09: 0000000000000000
> [16930.655414] R10: ffff88800ae00800 R11: 00000000bfe632e6 R12: 00000000000005a0
> [16930.655441] R13: 0000000000000001 R14: 00000000bfe62d46 R15: 0000000000000004
> [16930.655475] FS:  00007fe71fe2cb80(0000) GS:ffff88801f200000(0000) knlGS:0000000000000000
> [16930.655502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16930.655525] CR2: 000055de0f3e7000 CR3: 0000000011f32000 CR4: 00000000000006f0
> [16930.655553] Kernel panic - not syncing: Fatal exception in interrupt
> [16930.655789] Kernel Offset: disabled
> 
