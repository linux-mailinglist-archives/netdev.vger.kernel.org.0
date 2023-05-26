Return-Path: <netdev+bounces-5737-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FEB671297E
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF068281845
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122E9271E0;
	Fri, 26 May 2023 15:29:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064CE171A0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:29:55 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BECF3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:29:54 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f600a6a890so72985e9.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685114992; x=1687706992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11kvH2/w8+/j27zICJ7H+elZ2FOLnEq/iHQYQEgeVyU=;
        b=Xk/GvjBDVdqc+7jqhKEG3aIsPCmQ+0jViFDIaERZ7pysnS+oInnRks/1a2hNnsPX0e
         LpqZi+qhKBPgBAMNCNf3qVeY1UnEj8OPYwqsI4YALxpXPbJQ8jISsH47Yf36HyH8eNXi
         7PnSrcKGSlk7VyyGLQkCkz5QFeHRYlU4PoLk7S4yNBmvGO7JuITjeNZxf9Dsvyhk6zCb
         t6JipA3vXrgfF5ugk4gUIPKGhyNQ3xWLiLGlROuVAKH6NsfKQhHtWfYHdtsY+tDoF2BT
         Mle7Z0+er7X78IRUr9LHj8rO/OwYfxBhvl1qx4eZ1/agCnwVcfkOPxqduq9rmP0sHR9+
         kVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685114992; x=1687706992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11kvH2/w8+/j27zICJ7H+elZ2FOLnEq/iHQYQEgeVyU=;
        b=Q+gP4ntlz3pdPeGH2khkxaojh9EVlszY45PXw385dhH+vAUqunteKPnh4OMuxRd1h+
         evxrKS9wyZuwRDSEa8pxBIGAehjCOz9Djr7AF7nWrJlSzTS4JT7gZnP+DLL7958XBC8n
         i+erAcSLzZUaofZVOcH2r5bUz6nAetK9LQWB2mA/gUaO8i5e2RnDnSJgzzqsGaFMX8nF
         k0Lf8V1POCoE36fqot504M0KlMOpTwVm9xtxcowQDUHvzpE8xGKOwMF5wHL1bnR2WW4k
         V+DaGlgYf5D7fBf4C+EvxZEugCyMiN6v2BkmT6k3wh4X9J1E/kknOw33Ad5ZLbcE9Hwv
         lxvg==
X-Gm-Message-State: AC+VfDyyeUaLOAX7uTqgO+xK1BeNMALBkWsaVsAvhnU08zpsZQo98ruM
	1z5evqgL9N4p+AHI5I6jMERWL/2lhJoBwl0cYetSyGMqjTQquSHFl/cvJw==
X-Google-Smtp-Source: ACHHUZ7/PW5oi1QxByQp+2dnJSmeNg5G3WW6rGN9o5Q5Y7U7JvrxNI5F50BfkNMxcYP0mt7Aq9GozHET7p34VjflXM0=
X-Received: by 2002:a05:600c:cca:b0:3f1:70d1:21a6 with SMTP id
 fk10-20020a05600c0cca00b003f170d121a6mr120145wmb.0.1685114992299; Fri, 26 May
 2023 08:29:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526150806.1457828-1-VEfanov@ispras.ru>
In-Reply-To: <20230526150806.1457828-1-VEfanov@ispras.ru>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 17:29:40 +0200
Message-ID: <CANn89i+p7_UB8Z5FQ+iWg4G_caAnUf9W4P-t+VOzigUuJo+qRw@mail.gmail.com>
Subject: Re: [PATCH] udp6: Fix race condition in udp6_sendmsg & connect
To: Vladislav Efanov <VEfanov@ispras.ru>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 5:08=E2=80=AFPM Vladislav Efanov <VEfanov@ispras.ru=
> wrote:
>
> Syzkaller got the following report:
> BUG: KASAN: use-after-free in sk_setup_caps+0x621/0x690 net/core/sock.c:2=
018
> Read of size 8 at addr ffff888027f82780 by task syz-executor276/3255

Please include a full report.

>
> The function sk_setup_caps (called by ip6_sk_dst_store_flow->
> ip6_dst_store) referenced already freed memory as this memory was
> freed by parallel task in udpv6_sendmsg->ip6_sk_dst_lookup_flow->
> sk_dst_check.
>
>           task1 (connect)              task2 (udp6_sendmsg)
>         sk_setup_caps->sk_dst_set |
>                                   |  sk_dst_check->
>                                   |      sk_dst_set
>                                   |      dst_release
>         sk_setup_caps references  |
>         to already freed dst_entry|


>
> The reason for this race condition is: udp6_sendmsg() calls
> ip6_sk_dst_lookup() without lock for sock structure and tries to
> allocate/add dst_entry structure to sock structure in parallel with
> "connect" task.
>
> Found by Linux Verification Center (linuxtesting.org) with syzkaller.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

This is a bogus Fixes: tag

In old times, UDP sendmsg() was using the socket lock.

Then, in linux-4.0 Vlad Yasevich made UDP v6 sendmsg() lockless (and
racy in many points)


> Signed-off-by: Vladislav Efanov <VEfanov@ispras.ru>
> ---
>  net/ipv6/udp.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index e5a337e6b970..a5ecd5d93b0a 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1563,12 +1563,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr =
*msg, size_t len)
>
>         fl6->flowlabel =3D ip6_make_flowinfo(ipc6.tclass, fl6->flowlabel)=
;
>
> +       lock_sock(sk);
>         dst =3D ip6_sk_dst_lookup_flow(sk, fl6, final_p, connected);
>         if (IS_ERR(dst)) {
>                 err =3D PTR_ERR(dst);
>                 dst =3D NULL;
> +               release_sock(sk);
>                 goto out;
>         }
> +       release_sock(sk);
>
>         if (ipc6.hlimit < 0)
>                 ipc6.hlimit =3D ip6_sk_dst_hoplimit(np, fl6, dst);
> --
> 2.34.1
>

There must be another way really.
You just killed UDP performance.

