Return-Path: <netdev+bounces-1085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 124076FC221
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 726AD2811EF
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733695663;
	Tue,  9 May 2023 08:55:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9D220F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:55:19 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD34E1BC6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:55:17 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f38a9918d1so84021cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 01:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683622517; x=1686214517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vuyu6kE4VP+GmN/RFWs7fKPD4dCEoMLF4EREkOIT10=;
        b=bKSuoqPWNJKysVKLjrKWrb03pH4C9ONPgwu5dTyD5iNEYO8LsXHWkg5+2rTQ5Uxiro
         xayXEOxa2GDacF+8ZrDNLCUt99xSj/fc8BcDS3wLxnkCiK29y+gEO8CHoWgdQXCAc3Lo
         +cP0ni4d1ObMHX58DJJ4/YKtkpdkHaWS7n/+7OlVbAXM0SubGOIiGN5Mf4y999gKTxb3
         wphr5r1QQP5zototr1qDvICpW59Rqn9mHeFpZtJIW9cxY+PCBBO70KsUZdD355t5K+AX
         KHtbkljFtbX6EoL4HkQK0NjkY6HekajWUCFDp1/4GXHzSk3BVdrAqGttDMYyTPLPzHrp
         hIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683622517; x=1686214517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6vuyu6kE4VP+GmN/RFWs7fKPD4dCEoMLF4EREkOIT10=;
        b=jxpMf2/IW4qE4ic/cf3DLjPv6FPtY/A+yUTGGxEYdl6L6YKbXIwxpb2A5hxO4QQenZ
         bmcHkA23m3sRdOKbP6or2M44uAL+Eb/KUj2s8zQ4PfbGjS+j3V1iAtWRYlxaXv0LY2bJ
         YByvD3vmeFu70rE95KbWYTzzuo9Ffm8MdAvXwqNhhz+5SYXk0ZttCmola89sl8OCdTg/
         SvEBp17n+Br6MxNO3dw7/Xugy0Tqn7MNarN/lrfwEboQpKLwuOywzqokObIj+qZ14+uo
         UGdbf8CiPOc2OIsZ0isy5V8HovCfxBHcYN5U8st6Sq1uaOt2ojmLOc0rnOV2zgt8j/53
         NcUw==
X-Gm-Message-State: AC+VfDzfZ57vZRWq7oXhJKY/Jq4A9tcm1QKmgUDW9uOkRRKP0X2zbQzu
	42K9e//Qt+3adLYd996+rOcLV1maoAf4ii8J3Ww2dK8cnO0cH0LiBi3srg==
X-Google-Smtp-Source: ACHHUZ4HZRTeSZ9MQv2Drxl1T+SrAZVjktaDT8isCG6PeQmGHcyT7JAjTr8dnNqE5ORML/IYxQSk4aPuA4aO9NR8J2A=
X-Received: by 2002:a05:622a:178e:b0:3ef:2f55:2204 with SMTP id
 s14-20020a05622a178e00b003ef2f552204mr354044qtk.6.1683622516809; Tue, 09 May
 2023 01:55:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230506085903.96133-1-wuyun.abel@bytedance.com>
In-Reply-To: <20230506085903.96133-1-wuyun.abel@bytedance.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 10:55:05 +0200
Message-ID: <CANn89iK154B-NzRFymx_ggO9ZuVW-0YyHEKi6C46zjHpdRfokQ@mail.gmail.com>
Subject: Re: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 6, 2023 at 10:59=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com> =
wrote:
>
> The commit 180d8cd942ce ("foundations of per-cgroup memory pressure
> controlling") wrapped proto::memory_pressure status into an accessor
> named sk_under_memory_pressure(), and in the next commit e1aab161e013
> ("socket: initial cgroup code") added the consideration of net-memcg
> pressure into this accessor.
>
> But with the former patch applied, not all of the call sites of
> sk_under_memory_pressure() are interested in net-memcg's pressure.
> The __sk_mem_{raise,reduce}_allocated() only focus on proto/netns
> pressure rather than net-memcg's. IOW this accessor are generally
> used for deciding whether should reclaim or not.
>
> Fixes: e1aab161e013 ("socket: initial cgroup code")
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> ---
>  include/net/sock.h |  5 -----
>  net/core/sock.c    | 17 +++++++++--------
>  2 files changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8b7ed7167243..752d51030c5a 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1404,11 +1404,6 @@ static inline int sk_under_cgroup_hierarchy(struct=
 sock *sk,
>  #endif
>  }
>
> -static inline bool sk_has_memory_pressure(const struct sock *sk)
> -{
> -       return sk->sk_prot->memory_pressure !=3D NULL;
> -}
> -
>  static inline bool sk_under_memory_pressure(const struct sock *sk)
>  {
>         if (!sk->sk_prot->memory_pressure)
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 5440e67bcfe3..8d215f821ea6 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3017,13 +3017,14 @@ int __sk_mem_raise_allocated(struct sock *sk, int=
 size, int amt, int kind)
>                 }
>         }
>
> -       if (sk_has_memory_pressure(sk)) {
> -               u64 alloc;
> -
> -               if (!sk_under_memory_pressure(sk))
> -                       return 1;
> -               alloc =3D sk_sockets_allocated_read_positive(sk);
> -               if (sk_prot_mem_limits(sk, 2) > alloc *
> +       if (prot->memory_pressure) {

I do not understand this patch.

Changelog is evasive, I do not see what practical problem you want to solve=
.

sk_has_memory_pressure() is not about memcg, simply the fact that a
proto has a non NULL memory_pressure pointer.

