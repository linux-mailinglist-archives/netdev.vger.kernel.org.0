Return-Path: <netdev+bounces-6646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DAA27172BB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 652502812B0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704AAEA9;
	Wed, 31 May 2023 00:51:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E095A2D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:51:10 +0000 (UTC)
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1651C9C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:51:09 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-565c3aa9e82so58361667b3.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685494268; x=1688086268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNHCAG+P/w9+A5skzp7C1aUDLoQJRhNX+Ld1PKa8KXE=;
        b=4lagthLM9YJvwGlz6pDlvgv4FJmjbpgcnYyCY2q7q0LljyMnBI2BjoHzMCNg/1XEOO
         teItyk1zLiH89m8gOnlE1nx+0oDbOSCHTlaaCGlVFFaJbwZDg9u3nypWgRbWfXxqPCJv
         dcEXVpKk1ALnnsv/t791sWRywKutwXY60o5xu5lXPmxXJJAEIO6qOVy91MHlKROu+Aum
         a3zX8RISdtTr8+MIgRoDeXXElY6/GmtjAd+asnAWR83LZnC4j8y6jVCXPbYWzPcY/Si3
         R/Cj2PzZoCAyork76H+PmwiI3JJSdq6+voGLUCrwMVml74uk7lw1hRKJzUUI+yopGG8m
         uixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685494268; x=1688086268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNHCAG+P/w9+A5skzp7C1aUDLoQJRhNX+Ld1PKa8KXE=;
        b=SAsDqKruSyQQTThhvA6dwsCzGitTvb8hATbFPb9sDFm3dEuw0jmdoS7LT5qe/zbbYC
         GsVx39+lmz2XlRUHl6kMs2DwAXbAQgBpp+Wlp8TAWlbvmD5U2Dvssd2Oo7FWtphVpISA
         xu2j6z0EF5sbE17XjMlefauMyzQd7ut/g34vcOJcUes1WGt5LcIgz7po1fAfLlUGeNYR
         D/FtQC04sfj2ylTpYQiLAYsZ8hM83OG7DTunkIHvWdrX1Ky+94UBiuQRBgzGVw2iD25Y
         xn0oAjN8Y0bjKCcYi9BIzXvi4tgNgdnTOznThSVrQXzWqdRktIhSd6LKnzY5mF+TLN/W
         0xCA==
X-Gm-Message-State: AC+VfDy85cB6UVRFcnL0m9ajMFy8JXWkfM7kY1ClVR0sKAyuYt2D9TEc
	l/qpuXCki8mppDzrz9LvuHMGX9+2z+7P4qoSy5mPOQ==
X-Google-Smtp-Source: ACHHUZ7Sz1cAYu3T5CpibG3ocBAAKR8lYcsF+pJK+X3tTzqC0bIPnLrGnKx8BKbMkzRjaPh8T3aXKWcQA4LEnpPQmoY=
X-Received: by 2002:a81:710b:0:b0:561:9d69:22e1 with SMTP id
 m11-20020a81710b000000b005619d6922e1mr4436065ywc.22.1685494268302; Tue, 30
 May 2023 17:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
In-Reply-To: <20230527093747.3583502-1-shaozhengchao@huawei.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 30 May 2023 20:50:57 -0400
Message-ID: <CAM0EoM=sUhpnNdevqOPPaUx8oXZuchUEobd8=WpkD6GyYyLYQw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	weiyongjun1@huawei.com, yuehaibing@huawei.com, wanghai38@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 5:30=E2=80=AFAM Zhengchao Shao <shaozhengchao@huawe=
i.com> wrote:
>
> When use the following command to test:
> 1)ip link add bond0 type bond
> 2)ip link set bond0 up
> 3)tc qdisc add dev bond0 root handle ffff: mq
> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
>
> The kernel reports NULL pointer dereference issue. The stack information
> is as follows:
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
00000000000
> Internal error: Oops: 0000000096000006 [#1] SMP
> Modules linked in:
> pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : mq_attach+0x44/0xa0
> lr : qdisc_graft+0x20c/0x5cc
> sp : ffff80000e2236a0
> x29: ffff80000e2236a0 x28: ffff0000c0e59d80 x27: ffff0000c0be19c0
> x26: ffff0000cae3e800 x25: 0000000000000010 x24: 00000000fffffff1
> x23: 0000000000000000 x22: ffff0000cae3e800 x21: ffff0000c9df4000
> x20: ffff0000c9df4000 x19: 0000000000000000 x18: ffff80000a934000
> x17: ffff8000f5b56000 x16: ffff80000bb08000 x15: 0000000000000000
> x14: 0000000000000000 x13: 6b6b6b6b6b6b6b6b x12: 6b6b6b6b00000001
> x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> x8 : ffff0000c0be0730 x7 : bbbbbbbbbbbbbbbb x6 : 0000000000000008
> x5 : ffff0000cae3e864 x4 : 0000000000000000 x3 : 0000000000000001
> x2 : 0000000000000001 x1 : ffff8000090bc23c x0 : 0000000000000000
> Call trace:
> mq_attach+0x44/0xa0
> qdisc_graft+0x20c/0x5cc
> tc_modify_qdisc+0x1c4/0x664
> rtnetlink_rcv_msg+0x354/0x440
> netlink_rcv_skb+0x64/0x144
> rtnetlink_rcv+0x28/0x34
> netlink_unicast+0x1e8/0x2a4
> netlink_sendmsg+0x308/0x4a0
> sock_sendmsg+0x64/0xac
> ____sys_sendmsg+0x29c/0x358
> ___sys_sendmsg+0x90/0xd0
> __sys_sendmsg+0x7c/0xd0
> __arm64_sys_sendmsg+0x2c/0x38
> invoke_syscall+0x54/0x114
> el0_svc_common.constprop.1+0x90/0x174
> do_el0_svc+0x3c/0xb0
> el0_svc+0x24/0xec
> el0t_64_sync_handler+0x90/0xb4
> el0t_64_sync+0x174/0x178
>
> This is because when mq is added for the first time, qdiscs in mq is set
> to NULL in mq_attach(). Therefore, when replacing mq after adding mq, we
> need to initialize qdiscs in the mq before continuing to graft. Otherwise=
,
> it will couse NULL pointer dereference issue in mq_attach(). And the same
> issue will occur in the attach functions of mqprio, taprio and htb.
> ffff:fff1 means that the repalce qdisc is ingress. Ingress does not allow
> any qdisc to be attached. Therefore, ffff:fff1 is incorrectly used, and
> the command should be dropped.
>
> Fixes: 6ec1c69a8f64 ("net_sched: add classful multiqueue dummy scheduler"=
)
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/sch_api.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index fdb8f429333d..dbc9cf5eea89 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1596,6 +1596,10 @@ static int tc_modify_qdisc(struct sk_buff *skb, st=
ruct nlmsghdr *n,
>                                         NL_SET_ERR_MSG(extack, "Qdisc par=
ent/child loop detected");
>                                         return -ELOOP;
>                                 }
> +                               if (clid =3D=3D TC_H_INGRESS) {
> +                                       NL_SET_ERR_MSG(extack, "Ingress c=
annot graft directly");
> +                                       return -EINVAL;
> +                               }
>                                 qdisc_refcount_inc(q);
>                                 goto graft;
>                         } else {
> --
> 2.34.1
>
>

