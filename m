Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2902FEA35
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 03:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKPCHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 21:07:32 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:36813 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfKPCHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 21:07:32 -0500
Received: by mail-ot1-f51.google.com with SMTP id f10so9699014oto.3
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 18:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UiJOx0feRjqs4cBrw3GQ1eO/2u+7cvWu567DYWM07zI=;
        b=nI0SXpz95V61zXrDXn+JWo1wEZ8I+amEugSyTpTz38A7JnrGbXtfojojxzi9rnw3AX
         HYLWlk8xZUuFxgLQuXRpUx1VTaDMc/Konnga1g7a6Sr9z6hnyXMH2mrO/EkWi7yGTmxg
         u7nee2jwYuJPOJdRtrmKWOPXBxhLzqyD81YQf+jCOdp3nQRPK6SnACAXyM2m7OS+LObH
         ZeayDeQa7EEJo+MWr53dNVcQ8UQgYGYP2TEU4wYI7yobPSoSJ/Rj4y2cF7VSmLwS3FD4
         oH9vP5SzQpPPmW7jWddeG1rWUfyC0Mwxmyt4UU+C3Wno1rE5ZzxQTiceX8zT5H7ugeBs
         wjyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UiJOx0feRjqs4cBrw3GQ1eO/2u+7cvWu567DYWM07zI=;
        b=DzisXRajQ940thrt/pCI008OdYni51lVi9C1ogJYQlZVv6/Awl7+dvz7XD+2e9EdK6
         FUCeBYtmjIGmtultlI/6W1Lpg7Swr0T2Sh/S3aDec1jzrBBe+5k1lrJl6k+w+huUk6aJ
         6LCK3AHIuSVdoxVp0nJhJ4QpDwV/f3B4yU7wo6H0GySLiS+UoCGqp6wzEsUte0WHuJ2V
         NI4eEAtDCwtLTJtfCxdB9v6c9PVQXgUsGr/KKFhDJsq+/2Ud21NdCGsGyqXJnFE340bQ
         k5ABSgB2uoi3Gp6AAnbrkKSUJPWivhtSouv05qXrBYSZeabrneyjkMB8fO9CLZ3SlIdK
         S7eQ==
X-Gm-Message-State: APjAAAWOGhXaCXi8sh9GrtEUcizsB0gkwH+1mii3nl6srubUB7KPvM9u
        K1Rt+thBkNU6xjZVR5NIlC5+coO5WYpLgcwYOhk=
X-Google-Smtp-Source: APXvYqzjpdQhJ+oJPLn1XG46/vRjRTMm+mqt16WgMWozDT9UkOdl7ZOacoyTIgsEM4EF3SNHYMnh5GIFJ4HkAx2ZJMY=
X-Received: by 2002:a9d:6f92:: with SMTP id h18mr7151318otq.242.1573870051042;
 Fri, 15 Nov 2019 18:07:31 -0800 (PST)
MIME-Version: 1.0
References: <CAJwzM1k7iW9tJZiO-JhVbnT-EmwaJbsroaVbJLnSVY-tyCzjLQ@mail.gmail.com>
 <0d553faa-b665-14cf-e977-d2b0ff3d763e@gmail.com> <CAJwzM1=uv8NG=upCiRonvA504dn1u5Tj5DNM83BCSMbSmwvLuw@mail.gmail.com>
 <5bc7724f-c713-1810-2988-75520cb6f5eb@gmail.com>
In-Reply-To: <5bc7724f-c713-1810-2988-75520cb6f5eb@gmail.com>
From:   Avinash Patil <avinashapatil@gmail.com>
Date:   Fri, 15 Nov 2019 18:07:20 -0800
Message-ID: <CAJwzM1m-CTK-H9At_LdpMUP8kZNGkY6v1jZmusyFpChG2sGefQ@mail.gmail.com>
Subject: Re: Possible bug in TCP retry logic/Kernel crash
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No; I am not using an official tree. There are certain changes to
arch/arc directory which are specific to Synposys ARC platform.
However, there are no changes to TCP module and this is why I suspect
crash is generic TCP issue.

Thanks,
Avinash


On Fri, Nov 15, 2019 at 6:01 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 11/15/19 5:52 PM, Avinash Patil wrote:
> > Hi Eric,
> >
> > I integrated all patches till 4.19.83 as per your suggestion.
> > Unfortunately, I still see crash.
>
> What do you mean by integrating patches ?
>
> Are you using an official/pristine tree ?
>
> >
> > [  991.291968] [ECR   ]: 0x00230400 => Misaligned r/w from 0x00000001
> > [  991.299766] [EFA   ]: 0x00000001
> > [  991.299766] [BLINK ]: tcp_clean_rtx_queue+0x2a4/0xc88
> > [  991.299766] [ERET  ]: __list_del_entry_valid+0x12/0x1a0
> > [  991.313350] [STAT32]: 0x00000206 : K         E2 E1
> > [  991.318323] BTA: 0x8b188843   SP: 0x8f04fcf4  FP: 0x00000000
> > [  991.323977] LPS: 0x8b2e2942  LPE: 0x8b2e2946 LPC: 0x00000000
> > [  991.329660] r00: 0x8cbf2224  r01: 0x8cbf21c0 r02: 0x6e6c53fe
> > [  991.329660] r03: 0x00000001  r04: 0x00000000 r05: 0x39ef6f1d
> > [  991.329660] r06: 0x8f3e3180  r07: 0x00000000 r08: 0x3b14d54c
> > [  991.329660] r09: 0x00000000  r10: 0x0000c0ef r11: 0x00000000
> > [  991.329660] r12: 0x04c80000  r13: 0x8cbf21c0 r14: 0x00000000
> > [  991.329660] r15: 0x00000000  r16: 0x00000001 r17: 0x00000000
> > [  991.329660] r18: 0x8f3e3580  r19: 0x8f3e2d80 r20: 0x00000004
> > [  991.329660] r21: 0x8f04fd7c  r22: 0x00000001 r23: 0x3b14d54c
> > [  991.329660] r24: 0x00000000  r25: 0x8f0315c0
> > [  991.329660]
> > [  991.329660]
> > [  991.382333]
> > [  991.382333] Stack Trace:
> > [  991.386374] Firmware build version: avinashp6_bbic5_a-cl103643
> > [  991.386374] Firmware configuration: pearl_10gax_config
> > [  991.386374] Hardware ID           : 65535
> > [  991.401461]   __list_del_entry_valid+0x12/0x1a0
> > [  991.406125]   tcp_clean_rtx_queue+0x2a4/0xc88
> > [  991.410618]   tcp_ack+0x484/0x914
> > [  991.414073]   tcp_rcv_established+0x538/0x724
> > [  991.418564]   tcp_v4_do_rcv+0xda/0x120
> > [  991.422456]   tcp_v4_rcv+0x954/0xa7c
> > [  991.426105]   ip_local_deliver+0x72/0x208
> > [  991.430257]   process_backlog+0xbe/0x1b0
> > [  991.434319]   net_rx_action+0x106/0x294
> > [  991.438286]   __do_softirq+0xf0/0x218
> > [  991.442014]   run_ksoftirqd+0x2a/0x3c
> > [  991.445812]   smpboot_thread_fn+0xb4/0x10c
> > [  991.450054]   kthread+0xd8/0xdc
> > [  991.453338]   ret_from_fork+0x18/0x1c
> > [  991.457067]
> >
> > Thank you!
> >
> > -Avinash
> >
> > On Sun, Nov 10, 2019 at 3:48 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 11/9/19 9:59 PM, Avinash Patil wrote:
> >>> Hi everyone,
> >>>
> >>> Kernel: Linux 4.19.35 kernel built from linux-stable
> >>>
> >>
> >> This is quite an old version.
> >>
> >> Please upgrade to the latest one.
> >>
> >> $ git log --oneline v4.19.35..v4.19.82 -- net/ipv4/tcp*c
> >> 3fdcf6a88ded2bb5c3c0f0aabaff253dd3564013 tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
> >> 67fe3b94a833779caf4504ececa7097fba9b2627 tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR
> >> 5977bc19ce7f1ed25bf20d09d8e93e56873a9abb tcp: remove empty skb from write queue in error cases
> >> 6f3126379879bb2b9148174f0a4b6b65e04dede9 tcp: inherit timestamp on mtu probe
> >> 1b200acde418f4d6d87279d3f6f976ebf188f272 tcp: Reset bytes_acked and bytes_received when disconnecting
> >> c60f57dfe995172c2f01e59266e3ffa3419c6cd9 tcp: fix tcp_set_congestion_control() use from bpf hook
> >> 6323c238bb4374d1477348cfbd5854f2bebe9a21 tcp: be more careful in tcp_fragment()
> >> dad3a9314ac95dedc007bc7dacacb396ea10e376 tcp: refine memory limit test in tcp_fragment()
> >> 59222807fcc99951dc769cd50e132e319d73d699 tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
> >> 7f9f8a37e563c67b24ccd57da1d541a95538e8d9 tcp: add tcp_min_snd_mss sysctl
> >> ec83921899a571ad70d582934ee9e3e07f478848 tcp: tcp_fragment() should apply sane memory limits
> >> c09be31461ed140976c60a87364415454a2c3d42 tcp: limit payload size of sacked skbs
> >> 6728c6174a47b8a04ceec89aca9e1195dee7ff6b tcp: tcp_grow_window() needs to respect tcp_space()
> >>
