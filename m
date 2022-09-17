Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E2A5BBA65
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiIQUeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 16:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiIQUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 16:34:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5242C2F002
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 13:34:16 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r7so170186wrm.2
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 13:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date;
        bh=B89EGstKMjyJPRZQutPTGslF1FXxHpPL5tbfYC9ZDzI=;
        b=cuB7qdGzqin+9+js23X5eKiyS2zMgvrtOEj8/MAk0PplX+BIa0o6RAVxWd/2EcCkJM
         EYTkwZmno9IogYgTr/fdMgax8rSufAjsO62BXMtqSxSSudqEOnl2SDkpaMBPSgBnBMMK
         q0ePt6NKs5Y+8i9Dh8lN0pGrRnbZrOXQD5SXFn/G7BPB+I7uzpakJXg1p4z4uL7gg5zV
         pDsn9ERHzx0cvODKfHHbaT+KPVKR3Fpd9KEI3CxrObexAyGLZlodcGfo6YF+8gilgBkE
         H1B9t5dxikekUxG9seEvFx9wXY57my+43mlIiiopsSnxSBtyTu6O8h3GOuQ4gDC1X9oq
         5eqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=B89EGstKMjyJPRZQutPTGslF1FXxHpPL5tbfYC9ZDzI=;
        b=Mkc76BDdceZ17xsv46NNogwyaDJyE93sFTOm02FYahhcA0rc38EKZsOV3UyszYq8MW
         UBv4IHgME/n5PZNfsvURoSc7nN4DWGhHH/XqecbvOU5uDAZzWmLpIImgoJ8Qv/eVUGsR
         iyrVEa0R0GuuPwi41KWiIQyXNeYwpqR2OHikSExzzRjvKp7c53VhyLKQD/rZk/cu7Ebp
         uuBGKkqg0JfQLSC0pzfcMtjQ1bMecsEqkYJg7pt7lM6RmVQnWZfTmKmyOiyyJ4yRP2bO
         SqQZ2rc1Xbb8mv177yuqqZdgdWkixHeH7H8HHXrRUIlvdFHJDL5ESP/2ClWnbktwTEZx
         CL7w==
X-Gm-Message-State: ACrzQf2KdDxNie/8dl+uPi0pzilU+jNi9vLhK318ebVG2Yh8eFc37jsC
        H//P3sRZpCpth0PBR6WjbC4DRDiQ0yk=
X-Google-Smtp-Source: AMsMyM5a3s6VUH6ZOHGvoHMn5195cauljLM5bUyCi7siRRp7Wg4ryDQfHwb6+Jqa1HZ1bAgaiBT8Aw==
X-Received: by 2002:a5d:508c:0:b0:228:de49:b808 with SMTP id a12-20020a5d508c000000b00228de49b808mr6410127wrt.23.1663446854729;
        Sat, 17 Sep 2022 13:34:14 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id h130-20020a1c2188000000b003a682354f63sm7164843wmh.11.2022.09.17.13.34.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Sep 2022 13:34:14 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Bug Report kernel 5.19.9 Networking NAT 
Date:   Sat, 17 Sep 2022 23:34:12 +0300
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, pablo@netfilter.org
In-Reply-To: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
Message-Id: <E0E441FF-D5F7-4E80-B01C-2643B23BAC98@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One more update :


[81463.921129] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81466.401421] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81485.314601] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81488.241055] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81490.982605] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81499.225338] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81508.272738] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81526.742498] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81539.072597] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81542.472532] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81544.781057] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81547.931925] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81561.741816] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81561.741816] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81572.312282] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81575.764512] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81575.764512] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81577.486948] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81577.486948] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81580.855781] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81580.958084] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81583.501366] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?
[81583.501366] softirq: huh, entered softirq 3 NET_RX 000000001471e2c3 =
with preempt_count 00000100, exited with 7fffff00?




> On 17 Sep 2022, at 11:03, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> HI team
>=20
> This is NAT server with 2gb/s traffic have 2x 10Gb 82599 in Bonding=20
>=20
> one report if find any solution write me :
>=20
>=20
> [35857.548356] ------------[ cut here ]------------
> [35857.548358] WARNING: CPU: 28 PID: 0 at net/core/skbuff.c:728 =
skb_release_head_state+0x8d/0xa0
> [35857.548364] Modules linked in: nft_limit nf_conntrack_netlink  =
pppoe pppox ppp_generic slhc nft_nat nft_masq nft_chain_nat nf_nat xt_CT =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nf_tables =
netconsole coretemp bonding i40e xt_NAT(O) acpi_ipmi ipmi_si =
ipmi_devintf ipmi_msghandler rtc_cmos
> [35857.548379] CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O  =
    5.19.9 #1
> [35857.548381] Hardware name: Supermicro SYS-5038MR-H8TRF/X10SRD-F, =
BIOS 3.3 10/28/2020
> [35857.548383] RIP: 0010:skb_release_head_state+0x8d/0xa0
> [35857.548385] Code: 8b bb d8 00 00 00 5b e9 21 e8 ff ff e8 ec 30 08 =
00 eb d4 be 03 00 00 00 e8 60 b4 d2 ff eb c8 48 83 e7 fe e8 85 e4 01 00 =
eb cb <0f> 0b eb 94 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 85 =
ff
> [35857.548387] RSP: 0018:ffffb484406c0d30 EFLAGS: 00010206
> [35857.548388] RAX: ffffffffb55b7480 RBX: ffff9f01b19f4800 RCX: =
000000000002e288
> [35857.548389] RDX: 00000000000f0000 RSI: 0000000000000001 RDI: =
0000000000000000
> [35857.548390] RBP: ffff9f0146a812d0 R08: 0000000000000000 R09: =
00000000000000ed
> [35857.548391] R10: 0000000000000001 R11: ffff9f01fdc63710 R12: =
ffff9f01d6b750e2
> [35857.548392] R13: 0000000000000000 R14: 0000000000000000 R15: =
ffff9f01d6b750ce
> [35857.548393] FS:  0000000000000000(0000) GS:ffff9f089fd00000(0000) =
knlGS:0000000000000000
> [35857.548394] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [35857.548395] CR2: 00007f4d25bcb38c CR3: 000000010dd1a005 CR4: =
00000000003706e0
> [35857.548396] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [35857.548397] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> [35857.548398] Call Trace:
> [35857.548400]  <IRQ>
> [35857.548401]  kfree_skb_reason+0x1c/0x70
> [35857.548404]  sk_stream_kill_queues+0x52/0xe0
> [35857.548408]  inet_csk_destroy_sock+0x46/0xf0
> [35857.548410]  tcp_fin+0xdf/0x150
> [35857.548414]  tcp_data_queue+0x374/0x510
> [35857.548417]  tcp_rcv_state_process+0x259/0x6f0
> [35857.548419]  tcp_v4_do_rcv+0xa9/0x1e0
> [35857.548422]  tcp_v4_rcv+0xcb9/0xd60
> [35857.548424]  ip_protocol_deliver_rcu+0x1b/0x1a0
> [35857.548428]  ip_local_deliver_finish+0x68/0x90
> [35857.548431]  ? ip_protocol_deliver_rcu+0x1a0/0x1a0
> [35857.548434]  __netif_receive_skb_one_core+0x3f/0x50
> [35857.548438]  process_backlog+0x7c/0x110
> [35857.548440]  __napi_poll+0x20/0x100
> [35857.548443]  net_rx_action+0x26d/0x330
> [35857.548446]  __do_softirq+0xaf/0x1d7
> [35857.548449]  do_softirq+0x5a/0x80
> [35857.548453]  </IRQ>
> [35857.548453]  <TASK>
> [35857.548454]  flush_smp_call_function_queue+0x3f/0x60
> [35857.548459]  do_idle+0xa6/0xc0
> [35857.548464]  cpu_startup_entry+0x14/0x20
> [35857.548467]  start_secondary+0xd6/0xe0
> [35857.548472]  secondary_startup_64_no_verify+0xd3/0xdb
> [35857.548475]  </TASK>
> [35857.548475] ---[ end trace 0000000000000000 ]=E2=80=94
>=20
>=20
>=20
>=20
> [35936.566314] ------------[ cut here ]------------
> [35936.566315] WARNING: CPU: 8 PID: 0 at kernel/time/timer.c:1425 =
del_timer_sync+0xce/0xe0
> [35936.566324] Modules linked in: nft_limit nf_conntrack_netlink pppoe =
pppox ppp_generic slhc nft_nat nft_masq nft_chain_nat nf_nat xt_CT =
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nf_tables =
netconsole coretemp bonding i40e xt_NAT(O) acpi_ipmi ipmi_si =
ipmi_devintf ipmi_msghandler rtc_cmos
> [35936.566341] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G        W  O    =
  5.19.9 #1
> [35936.566343] Hardware name: Supermicro SYS-5038MR-H8TRF/X10SRD-F, =
BIOS 3.3 10/28/2020
> [35936.566344] RIP: 0010:del_timer_sync+0xce/0xe0
> [35936.566349] Code: 8b 34 24 e8 44 71 6e 00 0f ae e8 e9 6c ff ff ff =
48 0f b3 4f 28 c6 47 24 01 48 8b 03 48 8b 53 08 48 89 02 48 85 c0 74 87 =
eb 81 <0f> 0b e9 4b ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 53 48 89 =
fb
> [35936.566351] RSP: 0018:ffffb48440350d50 EFLAGS: 00010246
> [35936.566353] RAX: 00000000ffffff00 RBX: ffff9f01424beee0 RCX: =
0000000000000001
> [35936.566355] RDX: ffffffffb685d680 RSI: ffff9f01424bee50 RDI: =
ffff9f01424beee0
> [35936.566357] RBP: ffff9f014bc4a200 R08: 000000000000ca34 R09: =
ffffb48440350d50
> [35936.566358] R10: 0000000000000000 R11: 0000000000000000 R12: =
ffff9f01be40ea00
> [35936.566360] R13: ffff9f01be40ea00 R14: 0000000000001000 R15: =
0000000000001000
> [35936.566362] FS:  0000000000000000(0000) GS:ffff9f089f800000(0000) =
knlGS:0000000000000000
> [35936.566364] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [35936.566365] CR2: 00007f645362a38c CR3: 00000001d77b0001 CR4: =
00000000003706e0
> [35936.566366] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [35936.566367] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> [35936.566368] Call Trace:
> [35936.566369]  <IRQ>
> [35936.566370]  ? inet_ehash_nolisten+0xa/0x60
> [35936.566376]  inet_csk_reqsk_queue_drop+0x5a/0x230
> [35936.566379]  inet_csk_complete_hashdance+0x23/0x3c0
> [35936.566380]  tcp_check_req+0x18f/0x600
> [35936.566384]  tcp_v4_rcv+0x99a/0xd60
> [35936.566386]  ip_protocol_deliver_rcu+0x1b/0x1a0
> [35936.566388]  ip_local_deliver_finish+0x68/0x90
> [35936.566391]  ? ip_protocol_deliver_rcu+0x1a0/0x1a0
> [35936.566393]  __netif_receive_skb_one_core+0x3f/0x50
> [35936.566398]  process_backlog+0x7c/0x110
> [35936.566400]  __napi_poll+0x20/0x100
> [35936.566403]  net_rx_action+0x26d/0x330
> [35936.566405]  __do_softirq+0xaf/0x1d7
> [35936.566409]  do_softirq+0x5a/0x80
> [35936.566412]  </IRQ>
> [35936.566413]  <TASK>
> [35936.566413]  flush_smp_call_function_queue+0x3f/0x60
> [35936.566418]  do_idle+0xa6/0xc0
> [35936.566423]  cpu_startup_entry+0x14/0x20
> [35936.566425]  start_secondary+0xd6/0xe0
> [35936.566430]  secondary_startup_64_no_verify+0xd3/0xdb
> [35936.566433]  </TASK>
> [35936.566433] ---[ end trace 0000000000000000 ]---

