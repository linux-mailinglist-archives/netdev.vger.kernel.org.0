Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD0C1EA6C8
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 17:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgFAPWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 11:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgFAPWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 11:22:50 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE53C05BD43
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 08:22:50 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 131so3632294pfv.13
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 08:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=PFTYtiID5NZeg1rWK7pXyZ/qApyyzvSobj3kF2ZWM70=;
        b=iPLY+muTCrb/lj2sZC0jNAXWvP5m6bsCYHPngR/C9VVCuG4lysa5The8eWA5ZkAiYj
         oxCP6UrRA4l8toLdr1aB5+0vbHBUZM8Cb6bb2qU1s+pWMzZDoa5Gy+cIE2MDJD4HAQ7b
         K2MxyyqSgfToRVm6+WPZs5Y9nbbrw9cC1CPWHzBAV2eypWy09XKq4mF9RePN06mxl4+G
         cJwnULIs8sLabZmrOQUGZeKL61hDRchwNczgzbChNERM8X6BEJJuzZ0RlbXofh03AOs8
         0mOb3UaWgjcu/39DQMEavQZAkYZoz3MAjlmFsBBoJ7arUGrJke3dk5fqtpEUSuIOvhZz
         Qwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=PFTYtiID5NZeg1rWK7pXyZ/qApyyzvSobj3kF2ZWM70=;
        b=D5r8a4V3cIXdiqWjs1aMrbzc6pUo0eP8SjRA9W8YGdsd/Yapj0cdmx/O85ZbnUMoBR
         56npRXbol/KTo1O2tlvktYwCDKrDCG+n6/9bmXyVGBuxAf8gxVQgxiraC+iEhxYA4BDo
         Qsf8stve0nqxB8cwrmuSTmIRCiSsxlf6qanYAZC+L/PUm65W5P0u+3tgvejFyt4FuZ1j
         Jpsc27Q750tmnm0hgcyZDnufNzomXK8EkN+rfjdVuJXuUXCFtiPZDQm4mthBU1miT7BB
         6+0a5H3zIJEr73jlOd+mO2H4DBgzh8OoBy/yAFF4usjQxOfoWZOnwfXbmOHAh6g/PV1y
         qzvA==
X-Gm-Message-State: AOAM533k7INRdv0n9aRI9U3uXdHIGu20x/STS6mpAbHki7bUZf7gva0F
        kvuTec6lQQV9mlUOYcxajQCUtXVkaQk=
X-Google-Smtp-Source: ABdhPJwgU9k6gSv8RFyo//ifTnQvpcmV5qRsVVugVHLSvIY42Gp/RjElAmefLuNNUE3L4m07l1TjBA==
X-Received: by 2002:aa7:8084:: with SMTP id v4mr21484474pff.211.1591024969390;
        Mon, 01 Jun 2020 08:22:49 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j7sm14625186pfh.154.2020.06.01.08.22.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 08:22:49 -0700 (PDT)
Date:   Mon, 1 Jun 2020 08:22:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 208003] New: kernel panic RIP:
 0010:__cgroup_bpf_run_filter_skb+0xd9/0x230
Message-ID: <20200601082241.0d15abca@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sun, 31 May 2020 14:08:42 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 208003] New: kernel panic RIP: 0010:__cgroup_bpf_run_filter_skb+0xd9/0x230


https://bugzilla.kernel.org/show_bug.cgi?id=208003

            Bug ID: 208003
           Summary: kernel panic RIP:
                    0010:__cgroup_bpf_run_filter_skb+0xd9/0x230
           Product: Networking
           Version: 2.5
    Kernel Version: 5.6.15
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: karsten.elfenbein@gmail.com
        Regression: No

Created attachment 289439
  --> https://bugzilla.kernel.org/attachment.cgi?id=289439&action=edit  
blurry kernel panic :(

I get random kernel panic on one of my systems.
It is running Arch Linux with Kernel 5.6.15-arch1-1 with an AMD Ryzen 5 2400G
and "RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)"
(1462:7a40)

The machine uses a bridge, vlan and docker.
I could only take a photo of the panic as netconsole does not log it.

BUG: kernel NULL pointer dereference, address: 00000000000010
#PF supervisor read access in kernel mode
#PD: error_code(0x0000) - not-present page
PGD 3e65a6067 P4D 3e65a6067 PUD 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.6.15-arch1-1 #1
Hardware name: Micro-Star International Co., ltd. MS-7A40/B450I GAMING PLUS AC
(MS-7A40), BIOS A.60 03/06/2019
RIP: 0010:__cgroup_bpf_run_filter_skb+0xd9/0x230
Code: 00 48 01 c8 48 89 43 50 41 83 ff 01 0f 84 c2 00 00 00 e8 ca f2 ec ff e8
85 31 f2 ff 44 89 fa 48 8d 84 d5 30 06 00 00 48 8b 00 <48> 8b 78 10 4c 8d 78 10
48 85 ff 0f 84 29 01 00 00 bd 01 00 00 00
RSP: 0018:ffffad9b402e4758 EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff93d66b09c900 RCX: 00000000000000f0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff93d67abe8000 R08: 0000000000000000 R09: 0000000000000001
R10: 000000000000b302 R11: ffff93d66b09c9d4 R12: 0000000000000014
R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS: ffff93d6908c0000(0000) knlGS: 0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 00000003ecfa0000 CR4: 00000000003406e0
Call Trace:
 <IRQ>
 sk_filter_trim_cap+0x12f/0x270
 ? tcp_v4_inbound_md5_hash+0x5e/0x170
 tcp_v4_rcv+0xb18/0xd80
 ip_protocol_deliver_rcu+0x2b/0x1e0
 ip_local_deliver_finish+0x55&0x70
 ip_local_deliver+0x155/0x130
 ? ip_protocol_deliver_rcu+0x1e0/0x1e0
 ip_sabotage_in+0x5a/0x70 [br_netfilter]
 nf_hook_slow+0x3f/0xb0
 ip_rcv+0xd1/0x110
 ? ip_rev_finish_core.constprop.0+0x470/0x470
 __netif_receive_skb_one_core+0x80/0x90
 netif_receive_skb+0x162/0x1b0
 br_pass_frame_up+0xf0/0x1d0 [bridge]
...

-- 
You are receiving this mail because:
You are the assignee for the bug.
