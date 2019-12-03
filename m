Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD50111B6B
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 23:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfLCWLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 17:11:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41650 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfLCWLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 17:11:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id s18so2519620pfd.8
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 14:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fKabNn9df0KKwioEHZ2TbPiYWD+uCzVkn8AhLZ5xjLU=;
        b=jAKoN0zKxKrMrwP4ExWiJ+pG3n/C8x+s5yOCrN3Ch6VQerUB41CkmmAppCbIS++RHt
         GsLxuKfii3/6PNKx27W9YU5Xv2hTHFZ6/aQTGybueMMGGdEwW4klIIm393nagvu4y5Cd
         +7XCQrW5ZdLjgfFGxp4En9GTEsTCwdgWPWtiWMtre1OvtwK98PRgw6MvehBwy03UFIqW
         Ckf/5aOWbSa13eAAyPI031gZL5kJdDXueSlDIJFIPXa1V4tiX06bUfxP5rmy++Me7GWW
         koF9yOlNbDr3SgbhmI7YekjBM/9CofMBU5958TV6BqpphvjGyBwozfF9CX2SFRmku++J
         gFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fKabNn9df0KKwioEHZ2TbPiYWD+uCzVkn8AhLZ5xjLU=;
        b=bVpGTCTgHQH3vVHhFHRzmoNWcEGvMLWpmN7oqcycWZgZSWu+hNnPA8ZKkmC6Lj53jc
         4VBSMiEVRCYHv8PjCQ0cMuWTilhkdDoBB8s8a87rIULqP4ndlEcvwfeI21bcq6eXY90H
         pS72PQArCW0/7J7cCoPaXMPhYHwJhpL0KpIo59v72QrEWm3D3PL3c4yju2KvgnhDn/Ra
         OpZJfS9cq9TMKUvG4VK+uxI5T01WR0KG2QAhkW+BTXou2bJXR8PFU1Ws+updu9bEejz/
         nbGxTTkWy5o8dXD0nOqouVvsAzlJl9/rxjuc6o/3T1D/L3JSMTgbrwIYFbcnBaOoptnQ
         NK7g==
X-Gm-Message-State: APjAAAXILEpkBGVYBgM+RlXP6XfT9ra+9ZHep1gyo6LCNHBKUVtQYHKr
        zUqn86+eWN+AdP/T5HOOGSiL4A==
X-Google-Smtp-Source: APXvYqz/J2vCzyEFtPRTDnWoMbG6QWpwBjzII9Uf4CLUG3UEFJy1opA8wCr2dxY/GJp7EXfAbvF3BA==
X-Received: by 2002:a62:1a97:: with SMTP id a145mr119864pfa.244.1575411092312;
        Tue, 03 Dec 2019 14:11:32 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f30sm4499876pga.20.2019.12.03.14.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 14:11:31 -0800 (PST)
Date:   Tue, 3 Dec 2019 14:11:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Udo van den Heuvel <udovdh@xs4all.nl>,
        Holger =?UTF-8?B?SG9mZnN0w6R0?= =?UTF-8?B?dGU=?= 
        <holger@applied-asynchrony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: 5.4.1 WARNINGs with r8169
Message-ID: <20191203141118.483edd2d@hermes.lan>
In-Reply-To: <3a1706be-e236-6f08-73eb-734f0ae41bbb@gmail.com>
References: <46e7dcf9-3c89-25c1-ccb8-336450047bec@xs4all.nl>
        <aa3b11a5-eb7e-dc2c-e5b4-96e53942246d@applied-asynchrony.com>
        <3a1706be-e236-6f08-73eb-734f0ae41bbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Dec 2019 20:58:04 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> On 01.12.2019 10:52, Holger Hoffst=C3=A4tte wrote:
> > (cc:'ing netdev & Heiner)
> >=20
> > Are you using Jumbo packets? If so please check the thread at
> > https://lore.kernel.org/lkml/24034.56114.248207.524177@wylie.me.uk/
> >=20
> > Btw you should use a more descriptive Subject line, otherwise people mi=
ght
> > miss your message..
> >=20
> > -h
> >=20
> > -------- Forwarded Message --------
> > Subject: 5.4.1 WARNINGs
> > Date: Sun, 1 Dec 2019 08:06:37 +0100
> > From: Udo van den Heuvel <udovdh@xs4all.nl>
> > Organization: hierzo
> > To: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
> > Newsgroups: gmane.linux.kernel
> >=20
> > Hello,
> >=20
> > While booting into 5.4.1 I noticed these.
> > Any advice please?
> >=20
> >=20
> > Dec=C2=A0 1 07:59:28 vuurmuur named[1318]: resolver priming query compl=
ete
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ------------[ cut here ]---------=
---
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: NETDEV WATCHDOG: eth0 (r8169): tr=
ansmit
> > queue 0 timed out
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: WARNING: CPU: 0 PID: 9 at
> > net/sched/sch_generic.c:447 dev_watchdog+0x208/0x210
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Modules linked in: act_police
> > sch_ingress cls_u32 sch_sfq sch_cbq pppoe pppox ip6table_raw nf_log_ipv6
> > ip6table_mangle xt_u32 xt_CT xt_nat nf_log_ipv4 nf_log_common
> > xt_statistic nf_nat_sip nf_conntrack_sip xt_recent xt_string xt_lscan(O)
> > xt_TARPIT(O) iptable_raw nf_nat_h323 nf_conntrack_h323 xt_TCPMSS
> > xt_length xt_hl xt_tcpmss xt_owner xt_mac xt_mark xt_multiport xt_limit
> > nf_nat_irc nf_conntrack_irc xt_LOG xt_DSCP xt_REDIRECT xt_MASQUERADE
> > xt_dscp nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat
> > mq_deadline 8021q ipt_REJECT nf_reject_ipv4 iptable_filter ip6t_REJECT
> > nf_reject_ipv6 xt_state xt_conntrack ip6table_filter nct6775 ip6_tables
> > sunrpc amdgpu mfd_core gpu_sched drm_kms_helper syscopyarea sysfillrect
> > sysimgblt fb_sys_fops ttm snd_hda_codec_realtek snd_hda_codec_generic
> > drm snd_hda_codec_hdmi snd_hda_intel drm_panel_orientation_quirks
> > cfbfillrect snd_intel_nhlt amd_freq_sensitivity cfbimgblt snd_hda_codec
> > aesni_intel cfbcopyarea i2c_algo_bit fb glue_helper
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: snd_hda_core crypto_simd fbdev sn=
d_pcm
> > cryptd pl2303 backlight snd_timer snd i2c_piix4 acpi_cpufreq sr_mod
> > cdrom sd_mod autofs4
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: CPU: 0 PID: 9 Comm: ksoftirqd/0
> > Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
O=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.4.1 #2
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Hardware name: To Be Filled By O.=
E.M.
> > To Be Filled By O.E.M./QC5000M-ITX/PH, BIOS P1.10 05/06/2015
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RIP: 0010:dev_watchdog+0x208/0x210
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Code: 63 54 24 e0 eb 8d 4c 89 f7 =
c6 05
> > fc a0 b9 00 01 e8 6d fa fc ff 44 89 e9 48 89 c2 4c 89 f6 48 c7 c7 48 79
> > dd 81 e8 98 5a b5 ff <0f> 0b eb bd 0f 1f 40 00 48 c7 47 08 00 00 00 00
> > 48 c7 07 00 00 00
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RSP: 0018:ffffc9000006fd68 EFLAGS=
: 00010286
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RAX: 0000000000000000 RBX:
> > ffff88813a1d6400 RCX: 0000000000000006
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RDX: 0000000000000007 RSI:
> > ffffffff8203aa58 RDI: ffff88813b216250
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RBP: ffff8881394ee460 R08:
> > 0000000000080001 R09: 0000000000000002
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: R10: 0000000000000001 R11:
> > 0000000000000001 R12: ffff8881394ee4b8
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: R13: 0000000000000000 R14:
> > ffff8881394ee000 R15: ffff88813a1d6480
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: FS:=C2=A0 0000000000000000(0000)
> > GS:ffff88813b200000(0000) knlGS:0000000000000000
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: CS:=C2=A0 0010 DS: 0000 ES: 0000 =
CR0:
> > 0000000080050033
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: CR2: 00007f09b9c20a78 CR3:
> > 00000001385d4000 CR4: 00000000000406b0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Call Trace:
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: call_timer_fn.isra.0+0x78/0x110
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? add_timer_on+0xd0/0xd0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: run_timer_softirq+0x19d/0x1c0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? _raw_spin_unlock_irq+0x1f/0x40
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? finish_task_switch+0xb2/0x250
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? finish_task_switch+0x81/0x250
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: __do_softirq+0xcf/0x210
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: run_ksoftirqd+0x15/0x20
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: smpboot_thread_fn+0xe9/0x1f0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: kthread+0xf1/0x130
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? sort_range+0x20/0x20
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? kthread_park+0x80/0x80
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ret_from_fork+0x22/0x40
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ---[ end trace e771bca3c459d7f9 ]=
---
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ------------[ cut here ]---------=
---
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: WARNING: CPU: 0 PID: 9 at
> > net/sched/sch_generic.c:447 dev_watchdog+0x208/0x210
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Modules linked in: act_police
> > sch_ingress cls_u32 sch_sfq sch_cbq pppoe pppox ip6table_raw nf_log_ipv6
> > ip6table_mangle xt_u32 xt_CT xt_nat nf_log_ipv4 nf_log_common
> > xt_statistic nf_nat_sip nf_conntrack_sip xt_recent xt_string xt_lscan(O)
> > xt_TARPIT(O) iptable_raw nf_nat_h323 nf_conntrack_h323 xt_TCPMSS
> > xt_length xt_hl xt_tcpmss xt_owner xt_mac xt_mark xt_multiport xt_limit
> > nf_nat_irc nf_conntrack_irc xt_LOG xt_DSCP xt_REDIRECT xt_MASQUERADE
> > xt_dscp nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat
> > mq_deadline 8021q ipt_REJECT nf_reject_ipv4 iptable_filter ip6t_REJECT
> > nf_reject_ipv6 xt_state xt_conntrack ip6table_filter nct6775 ip6_tables
> > sunrpc amdgpu mfd_core gpu_sched drm_kms_helper syscopyarea sysfillrect
> > sysimgblt fb_sys_fops ttm snd_hda_codec_realtek snd_hda_codec_generic
> > drm snd_hda_codec_hdmi snd_hda_intel drm_panel_orientation_quirks
> > cfbfillrect snd_intel_nhlt amd_freq_sensitivity cfbimgblt snd_hda_codec
> > aesni_intel cfbcopyarea i2c_algo_bit fb glue_helper
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: snd_hda_core crypto_simd fbdev sn=
d_pcm
> > cryptd pl2303 backlight snd_timer snd i2c_piix4 acpi_cpufreq sr_mod
> > cdrom sd_mod autofs4
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: CPU: 0 PID: 9 Comm: ksoftirqd/0
> > Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
O=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5.4.1 #2
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Hardware name: To Be Filled By O.=
E.M.
> > To Be Filled By O.E.M./QC5000M-ITX/PH, BIOS P1.10 05/06/2015
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RIP: 0010:dev_watchdog+0x208/0x210
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Code: 63 54 24 e0 eb 8d 4c 89 f7 =
c6 05
> > fc a0 b9 00 01 e8 6d fa fc ff 44 89 e9 48 89 c2 4c 89 f6 48 c7 c7 48 79
> > dd 81 e8 98 5a b5 ff <0f> 0b eb bd 0f 1f 40 00 48 c7 47 08 00 00 00 00
> > 48 c7 07 00 00 00
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RSP: 0018:ffffc9000006fd68 EFLAGS=
: 00010286
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RAX: 0000000000000000 RBX:
> > ffff88813a1d6400 RCX: 0000000000000006
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RDX: 0000000000000007 RSI:
> > ffffffff8203aa58 RDI: ffff88813b216250
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: RBP: ffff8881394ee460 R08:
> > 0000000000080001 R09: 0000000000000002
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: R10: 0000000000000001 R11:
> > 0000000000000001 R12: ffff8881394ee4b8
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: R13: 0000000000000000 R14:
> > ffff8881394ee000 R15: ffff88813a1d6480
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: FS:=C2=A0 0000000000000000(0000)
> > GS:ffff88813b200000(0000) knlGS:0000000000000000
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: CS:=C2=A0 0010 DS: 0000 ES: 0000 =
CR0:
> > 0000000080050033
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: CR2: 00007f09b9c20a78 CR3:
> > 00000001385d4000 CR4: 00000000000406b0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: Call Trace:
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: call_timer_fn.isra.0+0x78/0x110
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? add_timer_on+0xd0/0xd0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: run_timer_softirq+0x19d/0x1c0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? _raw_spin_unlock_irq+0x1f/0x40
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? finish_task_switch+0xb2/0x250
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? finish_task_switch+0x81/0x250
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: __do_softirq+0xcf/0x210
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: run_ksoftirqd+0x15/0x20
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: smpboot_thread_fn+0xe9/0x1f0
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: kthread+0xf1/0x130
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? sort_range+0x20/0x20
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ? kthread_park+0x80/0x80
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ret_from_fork+0x22/0x40
> > Dec=C2=A0 1 07:59:34 vuurmuur kernel: ---[ end trace e771bca3c459d7f9 ]=
---
> >=20
> >=20
> > Kind regards,
> > Udo
> >  =20
> If the problem persists, please create a ticket at bugzilla.kernel.org,
> including:
>=20
> - full dmesg log
> - last known good kernel version
> - whether problem persists if you switch the one interface with jumbo
>   packets to standard MTU
> - best would be a bisect result
>=20
> Heiner


Bugzilla.kernel.org is not used for networking bugs.
This is not good advice, and would like to discourage more use of bugzilla.
I am the only person who gets notified and I end up forwarding them
to the mailing list.
