Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFDA170936
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 21:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBZUIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 15:08:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42252 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727277AbgBZUIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 15:08:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id p18so297515wre.9
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 12:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6nmkRakw8L5BPvaGIGQR5OtpcJrK8hwwBj5MXGXP5Rk=;
        b=I05naOND32Ne2tXwSFGddJ0mmAtgAHaZuKDa5qhvMQIWdxnKi6uMMKUxFsaEh9iq3W
         g0dLPQNZDVx96rgPyKtbfBh1z1q0iloohSfvEflcmcZx8s3hWGkdhWb8AFXBoiZoLB8R
         ludlDfge6p2iRknSRpoufVaYjqSBNIgbgqgpvR5eWCkFjpHT8yziV+EQWMyDO9999ti/
         RO2cQnH1H7njIkjNeeoedQWy8zvFvGr8WYoL2xZmC7+wv1DIXkPFGfjuzc/Exc2HYHex
         Papie4zG18EBrg+8nw3aaB637ynKlUuHsVGwO5Hi5DDViPvgEYePXWz5whWjXrsf6Zs/
         bTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6nmkRakw8L5BPvaGIGQR5OtpcJrK8hwwBj5MXGXP5Rk=;
        b=ANVEY0uzti4aQZfmtFeUZVc1VCagxVP5aUj+Jagqk9RGABTABe3YCVfhLdg7UVGYhF
         TFm3ZLUIQETOSKmC3u9kXnDOt0xkFM6mpF17w28tfobEaB4sT4hCCEfsb2Y9ibI15ZgC
         /cNPm93JVUvjODYCUhVRV/uvvtkenl+Un54CEBMGIVJTEF//RCdwIG9K09uEeSbPEAUU
         ZuG/jnB1FU2cOa9E93eWlQUdZQAWqEGz7Xs7P+/zQyZFmgXmrPbFngRbi4s75tjLBEe3
         pyd04SFHBSkGBXUdYPwFu2CwmE/2G90qAxFlomQtL1ItRxCI3pN9tX32eZ4fjrm/nU3y
         eYZg==
X-Gm-Message-State: APjAAAURIYlwdPEefNxv14iQHB7k2aHDmLU5pt9H57xyvtVdNWnfC3+l
        iywSeEdTqPImJdDC2NdljatBknSj
X-Google-Smtp-Source: APXvYqxTwe55irC/TjWCYNe9vVXLGOn+90Muxc6WXLOaIKsbK9fMP6lQUL4EZcDNvD4ab0gc6dEHaA==
X-Received: by 2002:adf:e543:: with SMTP id z3mr301985wrm.369.1582747687927;
        Wed, 26 Feb 2020 12:08:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:38ea:e5eb:bce2:2ee3? (p200300EA8F29600038EAE5EBBCE22EE3.dip0.t-ipconnect.de. [2003:ea:8f29:6000:38ea:e5eb:bce2:2ee3])
        by smtp.googlemail.com with ESMTPSA id i18sm1493200wrv.30.2020.02.26.12.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 12:08:07 -0800 (PST)
Subject: Re: net/sched/sch_generic.c stacktrace
To:     Guido Trentalancia <guido@trentalancia.com>, kuznet@ms2.inr.ac.ru
Cc:     netdev@vger.kernel.org
References: <1582722037.31734.10.camel@trentalancia.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <140eb61d-6be1-3c0e-d5c4-9390975616a9@gmail.com>
Date:   Wed, 26 Feb 2020 21:08:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1582722037.31734.10.camel@trentalancia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2020 14:00, Guido Trentalancia wrote:
> Here is a stacktrace I get with kernel 5.4.19 after unplugging and
> replugging the Ethernet interface.
> 
Strange is that link comes up with 10Mbps/half. Most likely there's an
issue with the link, resulting in the tx timeout.
-> Is this reproducable?
-> What was the last known good kernel version?
-> Standard question: did you check with another cable?

Also a full dmesg log would be helpful.


> Most probably the issue also affects latest git from a couple of days
> ago (at least the code in net/sched/sch_generic.c).
> 
> The crash is not critical and the network functionality does not seem
> to be affected.
> 
> [ 6663.598726] r8169 0000:02:00.0 eth1: Link is Down
> [ 6752.433571] r8169 0000:02:00.0 eth1: Link is Up - 10Mbps/Half - flow control off
> [ 6763.194144] ------------[ cut here ]------------
> [ 6763.194149] NETDEV WATCHDOG: eth1 (r8169): transmit queue 0 timed out
> [ 6763.194177] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:447 dev_watchdog+0x1e3/0x1f0
> [ 6763.194178] Modules linked in: nf_conntrack_netlink nfnetlink xt_iprange nf_conntrack_sip xt_CT ipv6 iptable_raw
> [ 6763.194245] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G                T 5.4.19 #14
> [ 6763.194254] RIP: 0010:dev_watchdog+0x1e3/0x1f0
> [ 6763.194258] Code: 48 63 55 e0 eb 91 4c 89 ef c6 05 20 20 a6 00 01 e8 02 07 fc ff 48 89 c2 44 89 e1 4c 89 ee 48 c7 c7 60 3d dc a3 e8 39 42 a3 ff <0f> 0b eb bc 66 0f 1f 84 00 00 00 00 00 41 54 49 89 d4 55 48 89 f5
> [ 6763.194260] RSP: 0018:ffff9ba340130ea8 EFLAGS: 00010286
> [ 6763.194264] RAX: 0000000000000000 RBX: ffff8e009f856400 RCX: 0000000000000006
> [ 6763.194266] RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff8e00a6a563d0
> [ 6763.194268] RBP: ffff8e00a3c7c440 R08: 0000000000000001 R09: 0000000000000366
> [ 6763.194269] R10: ffffffffa45309e0 R11: 0000000000000004 R12: 0000000000000000
> [ 6763.194271] R13: ffff8e00a3c7c000 R14: ffff9ba340130ef0 R15: ffffffffa4005100
> [ 6763.194274] FS:  0000000000000000(0000) GS:ffff8e00a6a40000(0000) knlGS:0000000000000000
> [ 6763.194277] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 6763.194279] CR2: 00007fb9e2568000 CR3: 000000012000a002 CR4: 00000000003606e0
> [ 6763.194281] Call Trace:
> [ 6763.194284]  <IRQ>
> [ 6763.194292]  ? qdisc_put_unlocked+0x30/0x30
> [ 6763.194299]  call_timer_fn.isra.0+0x19/0x80
> [ 6763.194304]  run_timer_softirq+0x310/0x360
> [ 6763.194311]  ? timerqueue_add+0x6d/0xb0
> [ 6763.194316]  ? __hrtimer_run_queues+0x125/0x180
> [ 6763.194323]  __do_softirq+0xd7/0x216
> [ 6763.194330]  irq_exit+0x9b/0xa0
> [ 6763.194336]  smp_apic_timer_interrupt+0x5e/0x90
> [ 6763.194342]  apic_timer_interrupt+0xf/0x20
> [ 6763.194344]  </IRQ>
> [ 6763.194350] RIP: 0010:cpuidle_enter_state+0x11f/0x2a0
> [ 6763.194353] Code: e8 56 3d b0 ff 31 ff 49 89 c6 e8 8c 48 b0 ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 65 01 00 00 31 ff e8 b5 05 b5 ff fb 45 85 ed <0f> 88 c0 00 00 00 49 63 f5 48 8d 04 76 48 c1 e0 05 4c 89 f1 8b 7c
> [ 6763.194356] RSP: 0018:ffff9ba3400cbe88 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
> [ 6763.194359] RAX: ffff8e00a6a5fb00 RBX: ffffffffa4052460 RCX: 000000000000001f
> [ 6763.194361] RDX: 0000000000000000 RSI: 00000000471c745e RDI: 0000000000000000
> [ 6763.194363] RBP: 00000626adb99d58 R08: 00000626adc8a08b R09: 000000007fffffff
> [ 6763.194365] R10: ffff8e00a6a5ec20 R11: ffff8e00a6a5ec00 R12: ffff8e00a6a68e10
> [ 6763.194366] R13: 0000000000000004 R14: 00000626adc8a08b R15: 0000000000000000
> [ 6763.194373]  ? cpuidle_enter_state+0x104/0x2a0
> [ 6763.194377]  cpuidle_enter+0x24/0x40
> [ 6763.194382]  do_idle+0x1bf/0x230
> [ 6763.194387]  cpu_startup_entry+0x14/0x20
> [ 6763.194392]  start_secondary+0x153/0x1a0
> [ 6763.194397]  secondary_startup_64+0xa4/0xb0
> [ 6763.194400] ---[ end trace 56803b552c779a28 ]---
> 

