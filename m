Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851822AC785
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgKIVo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgKIVo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:44:57 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A5BC0613CF;
        Mon,  9 Nov 2020 13:44:56 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id n2so2581973ooo.8;
        Mon, 09 Nov 2020 13:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/YzuM89mASoBpBkWORGZlFLM10Sp7MghYlJKrb+EkNY=;
        b=qFXHN0Hu1Ppbdk+WWWVhcyxtDBT7iAO0lch7rqhKqwtgOsN32A7ZB2B6qbGv+g+fIx
         IzH9tnTdns2zk7BXGT86OBz1nlqGwClvzMPc2fphD8x38m8zzlFjk4945LjNRhzOlyv/
         YxvevLOoyl8d5Y3fkI65GtxvfeF2/1X5AXiWIBN6t3wZySmwlTTdGRqQeWGmXP2rTTfY
         4d1lhIUhZxdZDkgDt8SKk6xF0O3YZX0oNHNv9dw5IM/oO/lJiK/BnFEx5tsaziPT8wBz
         pzmsZFOQ34erT9SMxwHGlIzHvSAuCvtiXSbYLTUZziWkWmutuM50MftjjF553iffnBeN
         9ZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/YzuM89mASoBpBkWORGZlFLM10Sp7MghYlJKrb+EkNY=;
        b=NM4mkQX6tChv7+bjG1gl5RTyTsDOVJmEzL108xaFvMhc2L0Ep3Bov38ch+3I9BqDnU
         EsbupkC2jmJXvWW8/rOlQ9PC5vS5zTskWkbOIY2UN1fYmTp7eIxbd3rlKRLxyoz6fWlv
         PKUDpOGkx2od5160c2+HVt/dk7wyFw/WzjgrW0lsYK7ul63pw3z3a7wvio60OgJLgdEh
         LunYKGy3N5CFCDSjMhus4kuxhiPB3Ya6Z8LxwmL0rjmS9nO3hGYGdWuyVfM+zi0I01iq
         6RQxgWz7Ad6oD4U5fWuGNRsXye8z0o3Ml0+bMFljSlhRX9oT/qK8mGfg41ag+oktEH2U
         vIlQ==
X-Gm-Message-State: AOAM53391OruVfHX4GjHbcCAoT1hKTu0ZCN+g8TuBN3KDZ85Wj4jQBGA
        f6UxmOY8rdyQI5xhm88RNpk=
X-Google-Smtp-Source: ABdhPJwBRerZppo2xOiQvtM4AsleO1AwlnazGnMjZH1eCgy2anI+CQ2RJbRaW99qgAyHWKYW8hIB0w==
X-Received: by 2002:a4a:8f98:: with SMTP id c24mr1957094ooj.27.1604958296309;
        Mon, 09 Nov 2020 13:44:56 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p17sm2685090oov.1.2020.11.09.13.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:44:55 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:44:48 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5fa9b850d6de5_8c0e2089d@john-XPS-13-9370.notmuch>
In-Reply-To: <3d39a08d-2e50-efeb-214f-0c7c2d1605d7@linux.alibaba.com>
References: <1604641431-6295-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106171352.5c51342d@carbon>
 <3d39a08d-2e50-efeb-214f-0c7c2d1605d7@linux.alibaba.com>
Subject: Re: [PATCH] net/xdp: remove unused macro REG_STATE_NEW
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Shi wrote:
> =

> =

> =E5=9C=A8 2020/11/7 =E4=B8=8A=E5=8D=8812:13, Jesper Dangaard Brouer =E5=
=86=99=E9=81=93:
> > Hmm... REG_STATE_NEW is zero, so it is implicitly set via memset zero=
.
> > But it is true that it is technically not directly used or referenced=
.
> > =

> > It is mentioned in a comment, so please send V2 with this additional =
change:
> =

> Hi Jesper,
> =

> Thanks a lot for comments. here is the v2:
> =

> From 2908d25bf2e1c90ad71a83ba056743f45da283e8 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linux.alibaba.com>
> Date: Fri, 6 Nov 2020 13:41:58 +0800
> Subject: [PATCH v2] net/xdp: remove unused macro REG_STATE_NEW
> =

> To tame gcc warning on it:
> net/core/xdp.c:20:0: warning: macro "REG_STATE_NEW" is not used
> [-Wunused-macros]
> And change related comments as Jesper Dangaard Brouer suggested.
> =

> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> ---

>  net/core/xdp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> =

> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..0df5ee5682d9 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -19,7 +19,6 @@
>  #include <trace/events/xdp.h>
>  #include <net/xdp_sock_drv.h>
>  =

> -#define REG_STATE_NEW		0x0
>  #define REG_STATE_REGISTERED	0x1
>  #define REG_STATE_UNREGISTERED	0x2
>  #define REG_STATE_UNUSED	0x3

I think having the define there makes it more readable and clear what
the zero state is. But if we run with unused-macros I guess its even
uglier to try and mark it with unused attribute.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> @@ -175,7 +174,7 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
>  		return -ENODEV;
>  	}
>  =

> -	/* State either UNREGISTERED or NEW */
> +	/* State either UNREGISTERED or zero */
>  	xdp_rxq_info_init(xdp_rxq);
>  	xdp_rxq->dev =3D dev;
>  	xdp_rxq->queue_index =3D queue_index;
> -- =

> 1.8.3.1
> =



