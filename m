Return-Path: <netdev+bounces-7676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A08D2721086
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BF92281A74
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47E1D2F4;
	Sat,  3 Jun 2023 14:44:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF88BE8
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:44:23 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949318D
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:44:19 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-565a6837a0bso33911947b3.3
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 07:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685803458; x=1688395458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9H4zuMawJzDnvtkpHZ6E1WTVd2o3dKO6Lo0wVwCFUyU=;
        b=BvwjlPda1EMGmzmwTDiz4OXQUME9VL9MTw/DclA1uvjyxa1Gyv8Y8a4b1yeWo7Rj8k
         +QFl0RAwb3+N0GhFUYuVyMYc38jxe10WV2Mx/P3tsJK03qrfOuW1+bujow6kywUQhfBl
         CRozQRh2oiqprrtC9HDeqNZMuLwg4+eS/FPI3eU0bsDJPt/H8/lBXHIOy42VnaaDz0Dk
         MGs2ySK4vxqDgwNklvqq3kJsUxLCEBwjiJ5uJ3cYP9Zz9IWhRRMAN+Yjg5Yo6JxAPXcp
         8WFw5xWOgqnyRtght8MpPoKSgKfgiBS+ebBGN1G3g6WPve2VmT9e/WxVcEvakVOv1XB2
         Go4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685803458; x=1688395458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9H4zuMawJzDnvtkpHZ6E1WTVd2o3dKO6Lo0wVwCFUyU=;
        b=ZknZM3hIaPqfQvFY8Uh5BCZQf6p0bIN/NiZgYRMKuAoVgh77xa8bOqwSRB86jwOefC
         D6IV8yrXvpIoQZNI7dC5SyA7T1noQyffom1COLL2H3lM6TJMam4cXKtW+eQXfKOtOHY7
         1LUtFS9l0z/yezjbu4/QjshISgszR75idgY2p28ulXDeRWY7CAiEwEbc4eB22sD1Ca26
         48U8WW7wmUUnTBnNv9TjcODTcMioA9rKWaE5Xk8pGvjDkCjzjSinqgMRWg9CKyvdcaKn
         mfzZpVPQgHYbnQkoscu2gpPtBiylN55vutua8mx73zxUoxz/VXvEjeutVc/H4XUkeGNN
         uRHQ==
X-Gm-Message-State: AC+VfDxBvzyQEKvt6r49qgQakL66VZfiNPKT5innk/fk1n+2t6h1yUlF
	0ScbfmVzj2LfT69B8x7SWOncyqdMiwVnUkmLgKw3xg==
X-Google-Smtp-Source: ACHHUZ7NkT0AyyK0uDtWN2dHlKj5PVCKD/UKC5QeqekTHl6Cz0odjXtHzX/D+5Vw4NCq1xNjfS09F+neM2rUoUJMFLI=
X-Received: by 2002:a81:5dc6:0:b0:569:82b1:2ba5 with SMTP id
 r189-20020a815dc6000000b0056982b12ba5mr1487441ywb.20.1685803458476; Sat, 03
 Jun 2023 07:44:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602123747.2056178-1-edumazet@google.com>
In-Reply-To: <20230602123747.2056178-1-edumazet@google.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 10:44:07 -0400
Message-ID: <CAM0EoMn=eVZRxsEG11Avr=QhhLHAq_on+1hyDTJ+JQyq1vq4cw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: fq_pie: ensure reasonable
 TCA_FQ_PIE_QUANTUM values
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 8:37=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
> We got multiple syzbot reports, all duplicates of the following [1]
>
> syzbot managed to install fq_pie with a zero TCA_FQ_PIE_QUANTUM,
> thus triggering infinite loops.
>
> Use limits similar to sch_fq, with commits
> 3725a269815b ("pkt_sched: fq: avoid hang when quantum 0") and
> d9e15a273306 ("pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM")
>
> [1]
> watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [swapper/0:0]
> Modules linked in:
> irq event stamp: 172817
> hardirqs last enabled at (172816): [<ffff80001242fde4>] __el1_irq arch/ar=
m64/kernel/entry-common.c:476 [inline]
> hardirqs last enabled at (172816): [<ffff80001242fde4>] el1_interrupt+0x5=
8/0x68 arch/arm64/kernel/entry-common.c:486
> hardirqs last disabled at (172817): [<ffff80001242fdb0>] __el1_irq arch/a=
rm64/kernel/entry-common.c:468 [inline]
> hardirqs last disabled at (172817): [<ffff80001242fdb0>] el1_interrupt+0x=
24/0x68 arch/arm64/kernel/entry-common.c:486
> softirqs last enabled at (167634): [<ffff800008020c1c>] softirq_handle_en=
d kernel/softirq.c:414 [inline]
> softirqs last enabled at (167634): [<ffff800008020c1c>] __do_softirq+0xac=
0/0xd54 kernel/softirq.c:600
> softirqs last disabled at (167701): [<ffff80000802a660>] ____do_softirq+0=
x14/0x20 arch/arm64/kernel/irq.c:80
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.4.0-rc3-syzkaller-geb0f1697d7=
29 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 04/28/2023
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : fq_pie_qdisc_dequeue+0x10c/0x8ac net/sched/sch_fq_pie.c:246
> lr : fq_pie_qdisc_dequeue+0xe4/0x8ac net/sched/sch_fq_pie.c:240
> sp : ffff800008007210
> x29: ffff800008007280 x28: ffff0000c86f7890 x27: ffff0000cb20c2e8
> x26: ffff0000cb20c2f0 x25: dfff800000000000 x24: ffff0000cb20c2e0
> x23: ffff0000c86f7880 x22: 0000000000000040 x21: 1fffe000190def10
> x20: ffff0000cb20c2e0 x19: ffff0000cb20c2e0 x18: ffff800008006e60
> x17: 0000000000000000 x16: ffff80000850af6c x15: 0000000000000302
> x14: 0000000000000100 x13: 0000000000000000 x12: 0000000000000001
> x11: 0000000000000302 x10: 0000000000000100 x9 : 0000000000000000
> x8 : 0000000000000000 x7 : ffff80000841c468 x6 : 0000000000000000
> x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
> x2 : ffff0000cb20c2e0 x1 : ffff0000cb20c2e0 x0 : 0000000000000001
> Call trace:
> fq_pie_qdisc_dequeue+0x10c/0x8ac net/sched/sch_fq_pie.c:246
> dequeue_skb net/sched/sch_generic.c:292 [inline]
> qdisc_restart net/sched/sch_generic.c:397 [inline]
> __qdisc_run+0x1fc/0x231c net/sched/sch_generic.c:415
> __dev_xmit_skb net/core/dev.c:3868 [inline]
> __dev_queue_xmit+0xc80/0x3318 net/core/dev.c:4210
> dev_queue_xmit include/linux/netdevice.h:3085 [inline]
> neigh_connected_output+0x2f8/0x38c net/core/neighbour.c:1581
> neigh_output include/net/neighbour.h:544 [inline]
> ip6_finish_output2+0xd60/0x1a1c net/ipv6/ip6_output.c:134
> __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
> ip6_finish_output+0x538/0x8c8 net/ipv6/ip6_output.c:206
> NF_HOOK_COND include/linux/netfilter.h:292 [inline]
> ip6_output+0x270/0x594 net/ipv6/ip6_output.c:227
> dst_output include/net/dst.h:458 [inline]
> NF_HOOK include/linux/netfilter.h:303 [inline]
> ndisc_send_skb+0xc30/0x1790 net/ipv6/ndisc.c:508
> ndisc_send_rs+0x47c/0x5d4 net/ipv6/ndisc.c:718
> addrconf_rs_timer+0x300/0x58c net/ipv6/addrconf.c:3936
> call_timer_fn+0x19c/0x8cc kernel/time/timer.c:1700
> expire_timers kernel/time/timer.c:1751 [inline]
> __run_timers+0x55c/0x734 kernel/time/timer.c:2022
> run_timer_softirq+0x7c/0x114 kernel/time/timer.c:2035
> __do_softirq+0x2d0/0xd54 kernel/softirq.c:571
> ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
> call_on_irq_stack+0x24/0x4c arch/arm64/kernel/entry.S:882
> do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:85
> invoke_softirq kernel/softirq.c:452 [inline]
> __irq_exit_rcu+0x28c/0x534 kernel/softirq.c:650
> irq_exit_rcu+0x14/0x84 kernel/softirq.c:662
> __el1_irq arch/arm64/kernel/entry-common.c:472 [inline]
> el1_interrupt+0x38/0x68 arch/arm64/kernel/entry-common.c:486
> el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:491
> el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:587
> __daif_local_irq_enable arch/arm64/include/asm/irqflags.h:33 [inline]
> arch_local_irq_enable+0x8/0xc arch/arm64/include/asm/irqflags.h:55
> cpuidle_idle_call kernel/sched/idle.c:170 [inline]
> do_idle+0x1f0/0x4e8 kernel/sched/idle.c:282
> cpu_startup_entry+0x24/0x28 kernel/sched/idle.c:379
> rest_init+0x2dc/0x2f4 init/main.c:735
> start_kernel+0x0/0x55c init/main.c:834
> start_kernel+0x3f0/0x55c init/main.c:1088
> __primary_switched+0xb8/0xc0 arch/arm64/kernel/head.S:523
>
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/sch_fq_pie.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
> index 6980796d435d9d496bbf6db773dc6d8b5857c50c..c699e5095607dedbc921802f3=
1e8f4c78c35985f 100644
> --- a/net/sched/sch_fq_pie.c
> +++ b/net/sched/sch_fq_pie.c
> @@ -201,6 +201,11 @@ static int fq_pie_qdisc_enqueue(struct sk_buff *skb,=
 struct Qdisc *sch,
>         return NET_XMIT_CN;
>  }
>
> +static struct netlink_range_validation fq_pie_q_range =3D {
> +       .min =3D 1,
> +       .max =3D 1 << 20,
> +};
> +
>  static const struct nla_policy fq_pie_policy[TCA_FQ_PIE_MAX + 1] =3D {
>         [TCA_FQ_PIE_LIMIT]              =3D {.type =3D NLA_U32},
>         [TCA_FQ_PIE_FLOWS]              =3D {.type =3D NLA_U32},
> @@ -208,7 +213,8 @@ static const struct nla_policy fq_pie_policy[TCA_FQ_P=
IE_MAX + 1] =3D {
>         [TCA_FQ_PIE_TUPDATE]            =3D {.type =3D NLA_U32},
>         [TCA_FQ_PIE_ALPHA]              =3D {.type =3D NLA_U32},
>         [TCA_FQ_PIE_BETA]               =3D {.type =3D NLA_U32},
> -       [TCA_FQ_PIE_QUANTUM]            =3D {.type =3D NLA_U32},
> +       [TCA_FQ_PIE_QUANTUM]            =3D
> +                       NLA_POLICY_FULL_RANGE(NLA_U32, &fq_pie_q_range),
>         [TCA_FQ_PIE_MEMORY_LIMIT]       =3D {.type =3D NLA_U32},
>         [TCA_FQ_PIE_ECN_PROB]           =3D {.type =3D NLA_U32},
>         [TCA_FQ_PIE_ECN]                =3D {.type =3D NLA_U32},
> --
> 2.41.0.rc0.172.g3f132b7071-goog
>

