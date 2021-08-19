Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB93F1DCB
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhHSQZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhHSQZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 12:25:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78AFC061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:25:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g14so5974456pfm.1
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9Kji5q2RtwQn0Hx2PzmOSC1Ki18iQxXyauob87mOFRA=;
        b=FbRIYo3fElWYyhNizmIFVcqr2a1rSFIO/vtz8OrfGK0jfZKMw7y+ZG+7WCq5u5qM4A
         nAvwTbqdXl8UuwE1YejlastYNLgIxCt1ynDrTsmDUOzKGkVkMoz0Nye7SJ6BC3pXft4U
         kqM0Pyh4oY0byswwYPn78alQhAldqHp/8RAVJdzRDkif0nXtylrVdhUqjcVhCGuE2YwR
         2X9Qm5YYSCEpWmR4+q1MeVhvYJG3jz/jVTIXDK63D5Kvuej0RoaEdbkNClyw8bFKwTm3
         PbiATaj1aXxtjWVEOBDPZQKXMc5NdAbTQni1b9OKawoRYtFLtYFt3avANxBcEjKIATZP
         VgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9Kji5q2RtwQn0Hx2PzmOSC1Ki18iQxXyauob87mOFRA=;
        b=bBpQKfx+x8rixKammaf8x2AYCOZy+odcZz+0Zou1J6Tk/osGOTuHw+xo+8AIr0bz2i
         VH7f9dnCmJDUi4X95tIgVB8WOgGja38cBipAOD2ugH3HNn8kfQ4JPv24p2F5iL+F2TbW
         e5u9wWFCPPZpn9CCBZvdNCcQxvmWOVbvGD63aGCeuyEabx+eJ3Mpe+aN9WEXLJnF8Qdc
         Tykew1TwV4rfLwFe2QIp3YqFyofKkgYsaStzuYRAgqUPKrlDfBCc/dzTXwbDJuZftNKJ
         VswfxqF/4gV6G4U9FJQpD617OT7eVNPowfng9c4hJ7oo321Rt/m55RBn/Pus79yoKCBB
         7N3A==
X-Gm-Message-State: AOAM530QjfLcxIz2lU1kZDdYkDo1GU+dcbCua8r/onfTleQcpN97hneG
        QZXTfVi1OvrA6d7g+VYQl33ElgcLhN1kjw==
X-Google-Smtp-Source: ABdhPJw8j2RJyUbqTLVaZBmZgZNpZtermA22rRXXqH+/ERZs2FSJf9iqGIpNWqP3Nt2SRvxlrUmJ2Q==
X-Received: by 2002:aa7:80d1:0:b029:399:ce3a:d617 with SMTP id a17-20020aa780d10000b0290399ce3ad617mr15249441pfn.16.1629390317765;
        Thu, 19 Aug 2021 09:25:17 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 136sm4719468pge.77.2021.08.19.09.25.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 09:25:17 -0700 (PDT)
Date:   Thu, 19 Aug 2021 09:25:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 214107] New: UBSAN: misaligned-access in
 net/ipv4/tcp_ipv4.c:1862:15
Message-ID: <20210819092513.052cfa72@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not sure if this a real issue, looks like encapped packet can have
unaligned IPV4 header.

Begin forwarded message:

Date: Thu, 19 Aug 2021 12:42:27 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214107] New: UBSAN: misaligned-access in net/ipv4/tcp_ipv4.c:1862:15


https://bugzilla.kernel.org/show_bug.cgi?id=214107

            Bug ID: 214107
           Summary: UBSAN: misaligned-access in
                    net/ipv4/tcp_ipv4.c:1862:15
           Product: Networking
           Version: 2.5
    Kernel Version: 5.13
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: janpieter.sollie@edpnet.be
        Regression: No

When compiling the kernel with debug tools, UBSAN check for misaligned pointer
addresses:
>
> ==============================================================================
> UBSAN: misaligned-access in net/ipv4/tcp_ipv4.c:1862:15
> member access within misaligned address 000000002519ea50 for type 'struct
> tcphdr'
> which requires 4 byte alignment
> CPU: 29 PID: 0 Comm: swapper/29 Not tainted 5.13.7debug+ #20
> Hardware name: Gigabyte Technology Co., Ltd. X399 DESIGNARE EX/X399 DESIGNARE
> EX-CF, BIOS F12 12/11/2019
> Call Trace:
>  <IRQ>
>  dump_stack+0x6b/0x86
>  ubsan_epilogue+0x9/0x45
>  handle_misaligned_access+0x88/0xa0
>  __ubsan_handle_type_mismatch_v1+0x5c/0x70
>  tcp_add_backlog+0x15c5/0x1f30
>  tcp_v6_rcv+0x2552/0x2b90
>  ? __ubsan_handle_type_mismatch_v1+0x5c/0x70
>  ip6_protocol_deliver_rcu+0x1a3/0x10f0
>  ? ip6_dst_check+0x145/0x3f0
>  ip6_input+0xdc/0x160
>  ip6_sublist_rcv_finish+0xb8/0x1e0
>  ip6_list_rcv_finish.constprop.0+0x3e1/0xa10
>  ip6_sublist_rcv+0x2f/0xb0
>  ipv6_list_rcv+0x1c5/0x3a0
>  ? ipv6_rcv+0x390/0x390
>  __netif_receive_skb_list_core+0x2c9/0x8b0
>  __netif_receive_skb_list+0x1e5/0x580
>  ? napi_gro_receive+0x116/0x830
>  ? ktime_get_with_offset+0x81/0x170
>  netif_receive_skb_list_internal+0x169/0x730
>  napi_complete_done+0x1c6/0x640
>  igb_poll+0x99/0x7a0 [igb]
>  ? __napi_schedule+0xe6/0x220
>  __napi_poll+0x6f/0x4a0
>  net_rx_action+0x269/0xe50
>  __do_softirq+0x107/0x487
>  irq_exit_rcu+0xd5/0x170
>  common_interrupt+0x9b/0xc0
>  </IRQ>
>  asm_common_interrupt+0x1b/0x40
> RIP: 0010:cpuidle_enter_state+0x136/0xc90  
....
>  ? cpuidle_enter_state+0x11a/0xc90
>  cpuidle_enter+0x4c/0xd0
>  cpuidle_idle_call+0x192/0x3d0
>  do_idle+0xbd/0x190
>  cpu_startup_entry+0x20/0x30
>  start_secondary+0x8a/0x90
>  secondary_startup_64_no_verify+0xb0/0xbb  
================================================================================

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
