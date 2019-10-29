Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E5FE9336
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 23:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfJ2Wxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 18:53:47 -0400
Received: from mail-yw1-f54.google.com ([209.85.161.54]:35853 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ2Wxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 18:53:46 -0400
Received: by mail-yw1-f54.google.com with SMTP id p187so211067ywg.3
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 15:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=97LgdEfvoqPm3GE5gx1FOR3MZDD5yfXiggiilVNWanA=;
        b=Sh033H8Uz8ewwytNTd18xU4pG6eHYNxNW1sJciXrJs08UKKLJn6XVYfdt3scgpm3J0
         7zdViTMkhwCNAv8h5ovITEkViRX0IX3MMRQVO6+8T0fSac9mbD7eSrEtWR+dROdbeaSN
         Wex/GnAMenopPeMpdcP4xdie4vMyjSeIb32QFOqLN1f/V0KvCWJFbjWdS13XEJ6eJpTr
         TPp9SWytMSVd6VUdyTBybh2yQnJXd80zNLsddpUik3Qgs05BTRsKzzdB4W46EDJIm7YP
         ekeIP5uErNhaj7YL4VdUPpL8gj3kO0a+8hcgYaiU7Ib3t3DIIUjyAEVArtEuwH9djqre
         XKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=97LgdEfvoqPm3GE5gx1FOR3MZDD5yfXiggiilVNWanA=;
        b=E+V01C+DUo/wOg9S5StHoyxb/QQnmRJqVMNazTWQFj7cI98/hqDsT6tRwFnCBSpy6A
         TmWTsgBwSKqxs+pDBK9CVq1wWT0PAlqnJhy+vTxHmy0KxGvthIrQykCMjNXIAbs7ivU0
         ULhOiq6S6R1svht4Y8RDAGIHDfSj3XsBHX0PLpogBSx307L55vl7Ok6hlMXaKiS3HMrV
         +Eme/T6XOK0j2krtdEHytuGTbD7r3bIxn0Bf4kHTNXkYPY+Hp00GjHm2vmWibLJAttUc
         RXROJ4DiXU0hztraFy7rMIqDptdesN3yEyjlFnLI6l1o5OHvUvQQ6UsXlZ4WulFtOxjw
         0Z4g==
X-Gm-Message-State: APjAAAX/oD2+X5TgEBd8S7TlUVdvmYf9lu+e26axbZB2UCrqsvN7rv+v
        ydEFwMfmw6Qd/eR/kWYNu0XAYojvICPjARqBAWH5Aw==
X-Google-Smtp-Source: APXvYqwBrI7xuUzD5nUMC17pAc/QCMMpIhQHtRz9d4N1qzLWtyiXWp/pK9B5spV1PBkmEfAIEnL+6/Y+/lnKS3xQ/yA=
X-Received: by 2002:a81:99d3:: with SMTP id q202mr256291ywg.170.1572389625207;
 Tue, 29 Oct 2019 15:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
 <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com>
 <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com>
 <CANn89iJYKurw-3-EooE9qyM8-2MzQvCz8qdV91J1hVNxXwsyng@mail.gmail.com>
 <CABWYdi0nmGE6Y+iUkfGvR07zU640Fu4op4EXbCp6ou6GJMcfww@mail.gmail.com>
 <CANn89iKvLFDHPU2W86TfC7jNFW8HM5o8tE8wiRc7E=CRXLT=-Q@mail.gmail.com>
 <CANn89i+uxbxB8vTWXhOuW4-weP-NO2yFbbs15cJh7+BJtjSSkA@mail.gmail.com> <CABWYdi2qvpJ4srwFQo=znvsDs2-h7kiR7V++jbNXjCdypS-W5A@mail.gmail.com>
In-Reply-To: <CABWYdi2qvpJ4srwFQo=znvsDs2-h7kiR7V++jbNXjCdypS-W5A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Oct 2019 15:53:33 -0700
Message-ID: <CANn89iLXQzwv39+79jJ0=rQfKWhD0fkTS_AMkLrkmsu_=uHFvA@mail.gmail.com>
Subject: Re: fq dropping packets between vlan and ethernet interfaces
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 2:23 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> You were right about some non-standard forwarding I forgot about, we
> use glb-redirect:
>
> [Tue Oct 29 21:21:00 2019] ------------[ cut here ]------------
> [Tue Oct 29 21:21:00 2019] WARNING: CPU: 12 PID: 0 at
> net/sched/sch_fq.c:386 fq_enqueue+0x544/0x610 [sch_fq]
> [Tue Oct 29 21:21:01 2019] Modules linked in: nf_tables_set
> nft_counter nf_tables ip_gre gre veth xfrm_user xfrm_algo xt_connlimit
> nf_conncount xt_hashlimit iptable_security sch_ingress sch_fq
> ip6table_nat ip6table_mangle ip6table_security ip6table_raw xt_nat
> iptable_nat nf_nat xt_TCPMSS xt_TPROXY nf_tproxy_ipv6 nf_tproxy_ipv4
> xt_u32 xt_connmark iptable_mangle xt_owner xt_CT xt_socket
> nf_socket_ipv4 nf_socket_ipv6 iptable_raw xt_bpf ipt_REJECT
> nf_reject_ipv4 ip6table_filter ip6_tables nfnetlink_log xt_NFLOG
> xt_comment xt_conntrack xt_mark xt_multiport xt_set xt_tcpudp
> ipt_GLBREDIRECT(O) fou ip6_udp_tunnel udp_tunnel iptable_filter
> bpfilter ip_set_hash_netport ip_set_hash_net ip_set_hash_ip ip_set
> nfnetlink md_mod dm_crypt algif_skcipher af_alg dm_mod dax sit ipip
> tunnel4 ip_tunnel tun nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 8021q
> garp stp mrp llc ses enclosure sb_edac x86_pkg_temp_thermal kvm_intel
> kvm irqbypass crc32_pclmul crc32c_intel aesni_intel glue_helper
> crypto_simd cryptd
> [Tue Oct 29 21:21:01 2019]  intel_cstate ipmi_ssif mpt3sas
> intel_uncore raid_class sfc(O) igb ipmi_si scsi_transport_sas
> i2c_algo_bit intel_rapl_perf ipmi_devintf mdio dca ipmi_msghandler
> efivarfs ip_tables x_tables
> [Tue Oct 29 21:21:01 2019] CPU: 12 PID: 0 Comm: swapper/12 Tainted: G
>          O      5.4.0-rc5-cloudflare-2019.10.16 #2019.10.16
> [Tue Oct 29 21:21:01 2019] Hardware name: Quanta
> S210-X22RQ/S210-X22RQ, BIOS S2RQ3A27 10/31/2013
> [Tue Oct 29 21:21:01 2019] RIP: 0010:fq_enqueue+0x544/0x610 [sch_fq]
> [Tue Oct 29 21:21:01 2019] Code: e8 c1 ba f5 e7 45 85 ff 75 d4 49 8b
> 6d 00 e9 ec fb ff ff 48 83 83 30 02 00 00 01 e9 fa fc ff ff 4c 89 fa
> 31 c0 e9 c2 fc ff ff <0f> 0b e9 72 fc ff ff 41 8b 46 08 39 45 28 0f 84
> 09 fc ff ff 8b 83
> [Tue Oct 29 21:21:01 2019] RSP: 0018:ffffa53c06604338 EFLAGS: 00010202
> [Tue Oct 29 21:21:01 2019] RAX: 00000006fc23ac00 RBX: ffff998717cafc00
> RCX: 0000000000000017
> [Tue Oct 29 21:21:01 2019] RDX: 15d23af8c069e56c RSI: 15d2397b4f4a52fe
> RDI: ffffffffa941dc60
> [Tue Oct 29 21:21:01 2019] RBP: ffff9980509d1718 R08: ffff998717cafcac
> R09: 0000000000000052
> [Tue Oct 29 21:21:01 2019] R10: ffff99972da40000 R11: ffff99872caee04c
> R12: ffff99871774d800
> [Tue Oct 29 21:21:01 2019] R13: ffff9986fa874888 R14: 00000000000001c3
> R15: ffff9980509d1700
> [Tue Oct 29 21:21:01 2019] FS:  0000000000000000(0000)
> GS:ffff99873f980000(0000) knlGS:0000000000000000
> [Tue Oct 29 21:21:01 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [Tue Oct 29 21:21:01 2019] CR2: 00007f5c5f08e018 CR3: 0000001df8e0a006
> CR4: 00000000000606e0
> [Tue Oct 29 21:21:01 2019] Call Trace:
> [Tue Oct 29 21:21:01 2019]  <IRQ>
> [Tue Oct 29 21:21:01 2019]  ? nf_conntrack_tuple_taken+0x52/0x1f0 [nf_conntrack]
> [Tue Oct 29 21:21:01 2019]  ? netdev_pick_tx+0xd6/0x210
> [Tue Oct 29 21:21:01 2019]  __dev_queue_xmit+0x451/0x960
> [Tue Oct 29 21:21:01 2019]  ? packet_rcv+0x34c/0x460
> [Tue Oct 29 21:21:01 2019]  vlan_dev_hard_start_xmit+0x8e/0x100 [8021q]
> [Tue Oct 29 21:21:01 2019]  dev_hard_start_xmit+0x8d/0x1e0
> [Tue Oct 29 21:21:01 2019]  __dev_queue_xmit+0x712/0x960
> [Tue Oct 29 21:21:01 2019]  ?
> nf_ct_del_from_dying_or_unconfirmed_list+0x32/0x70 [nf_conntrack]
> [Tue Oct 29 21:21:01 2019]  ? eth_header+0x26/0xc0
> [Tue Oct 29 21:21:01 2019]  ip_finish_output2+0x198/0x550
> [Tue Oct 29 21:21:01 2019]  ip_output+0x71/0xf0
> [Tue Oct 29 21:21:01 2019]  ? __ip_finish_output+0x1c0/0x1c0
> [Tue Oct 29 21:21:01 2019]
> glbredirect_handle_inner_tcp_generic+0x331/0x790 [ipt_GLBREDIRECT]
> [Tue Oct 29 21:21:01 2019]  glbredirect_tg4+0x2ad/0x5c0 [ipt_GLBREDIRECT]
> [Tue Oct 29 21:21:01 2019]  ? efx_enqueue_skb+0x501/0xa30 [sfc]
> [Tue Oct 29 21:21:01 2019]  ? bpf_sk_storage_clone+0x48/0x1b0
> [Tue Oct 29 21:21:01 2019]  ? packet_rcv+0x43/0x460
> [Tue Oct 29 21:21:01 2019]  ? efx_hard_start_xmit+0x59/0xe0 [sfc]
> [Tue Oct 29 21:21:01 2019]  ? dev_hard_start_xmit+0x8d/0x1e0
> [Tue Oct 29 21:21:01 2019]  ? select_idle_sibling+0x22/0x550
> [Tue Oct 29 21:21:01 2019]  ? efx_farch_msi_interrupt+0x77/0x90 [sfc]
> [Tue Oct 29 21:21:01 2019]  ? efx_farch_tx_write+0x170/0x170 [sfc]
> [Tue Oct 29 21:21:01 2019]  ? efx_tx_map_chunk+0x47/0x80 [sfc]
> [Tue Oct 29 21:21:01 2019]  ? efx_enqueue_skb+0x501/0xa30 [sfc]
> [Tue Oct 29 21:21:01 2019]  ? packet_rcv+0x43/0x460
> [Tue Oct 29 21:21:01 2019]  ? fib4_rule_action+0x65/0x70
> [Tue Oct 29 21:21:01 2019]  ? fib4_rule_fill+0x100/0x100
> [Tue Oct 29 21:21:01 2019]  ? fib_rules_lookup+0x143/0x1a0
> [Tue Oct 29 21:21:01 2019]  ? __fib_lookup+0x6b/0xb0
> [Tue Oct 29 21:21:01 2019]  ? __fib_validate_source+0x1dd/0x430
> [Tue Oct 29 21:21:01 2019]  ? fib4_rule_action+0x65/0x70
> [Tue Oct 29 21:21:01 2019]  ? fib4_rule_fill+0x100/0x100
> [Tue Oct 29 21:21:01 2019]  ? fib_rules_lookup+0x143/0x1a0
> [Tue Oct 29 21:21:01 2019]  ? fib_validate_source+0x47/0xf0
> [Tue Oct 29 21:21:01 2019]  ? ipt_do_table+0x306/0x640 [ip_tables]
> [Tue Oct 29 21:21:01 2019]  ipt_do_table+0x306/0x640 [ip_tables]
> [Tue Oct 29 21:21:01 2019]  ? ipt_do_table+0x351/0x640 [ip_tables]
> [Tue Oct 29 21:21:01 2019]  nf_hook_slow+0x40/0xb0
> [Tue Oct 29 21:21:01 2019]  ip_local_deliver+0xd1/0xf0
> [Tue Oct 29 21:21:01 2019]  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
> [Tue Oct 29 21:21:01 2019]  ip_rcv+0xbc/0xd0
> [Tue Oct 29 21:21:01 2019]  ? ip_rcv_finish_core.isra.0+0x390/0x390
> [Tue Oct 29 21:21:01 2019]  __netif_receive_skb_one_core+0x80/0x90
> [Tue Oct 29 21:21:01 2019]  netif_receive_skb_internal+0x2f/0xa0
> [Tue Oct 29 21:21:01 2019]  netif_receive_skb+0x18/0xb0
> [Tue Oct 29 21:21:02 2019]  efx_rx_deliver+0x10e/0x1c0 [sfc]
> [Tue Oct 29 21:21:02 2019]  __efx_rx_packet+0x393/0x800 [sfc]
> [Tue Oct 29 21:21:02 2019]  efx_poll+0x311/0x460 [sfc]
> [Tue Oct 29 21:21:02 2019]  net_rx_action+0x13a/0x380
> [Tue Oct 29 21:21:02 2019]  __do_softirq+0xe0/0x2ca
> [Tue Oct 29 21:21:02 2019]  irq_exit+0xa0/0xb0
> [Tue Oct 29 21:21:02 2019]  do_IRQ+0x58/0xe0
> [Tue Oct 29 21:21:02 2019]  common_interrupt+0xf/0xf
> [Tue Oct 29 21:21:02 2019]  </IRQ>
> [Tue Oct 29 21:21:02 2019] RIP: 0010:cpuidle_enter_state+0xb2/0x410
> [Tue Oct 29 21:21:02 2019] Code: c5 66 66 66 66 90 31 ff e8 ab 4c 9c
> ff 80 7c 24 0b 00 74 12 9c 58 f6 c4 02 0f 85 36 03 00 00 31 ff e8 92
> 69 a1 ff fb 45 85 e4 <0f> 88 74 02 00 00 4c 2b 2c 24 49 63 cc 48 8d 04
> 49 48 c1 e0 05 8b
> [Tue Oct 29 21:21:02 2019] RSP: 0018:ffffa53c0638be70 EFLAGS: 00000206
> ORIG_RAX: ffffffffffffffda
> [Tue Oct 29 21:21:02 2019] RAX: ffff99873f9a8d40 RBX: ffffffffa94fcb40
> RCX: 000000000000001f
> [Tue Oct 29 21:21:02 2019] RDX: 0000000000000000 RSI: 00000000402794b1
> RDI: 0000000000000000
> [Tue Oct 29 21:21:02 2019] RBP: ffff99873f9b2500 R08: 0000017dd5dc66ea
> R09: 000000000000085f
> [Tue Oct 29 21:21:02 2019] R10: ffff99873f9a7c80 R11: ffff99873f9a7c60
> R12: 0000000000000005
> [Tue Oct 29 21:21:02 2019] R13: 0000017dd5dc66ea R14: 0000000000000005
> R15: ffff99873bf05b80
> [Tue Oct 29 21:21:02 2019]  cpuidle_enter+0x29/0x40
> [Tue Oct 29 21:21:02 2019]  do_idle+0x1b8/0x200
> [Tue Oct 29 21:21:02 2019]  cpu_startup_entry+0x19/0x20
> [Tue Oct 29 21:21:02 2019]  start_secondary+0x143/0x170
> [Tue Oct 29 21:21:02 2019]  secondary_startup_64+0xa4/0xb0
> [Tue Oct 29 21:21:02 2019] ---[ end trace 47f595949b82e151 ]---
>

Nice, I guess this out-of-tree module needs to be fixed.
