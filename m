Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F392A337E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgKBTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 14:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgKBS77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 13:59:59 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E36C0617A6;
        Mon,  2 Nov 2020 10:59:59 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id b138so12625361yba.5;
        Mon, 02 Nov 2020 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpf57obcTDUfpgE4X4aU2uC5mE04uKRHqZ7salaebWY=;
        b=uIuQHo1bXiaGsEZs1SD690jNAApi1irtsV2HmJhEYpjfIvNYYDblmOlMnBE+35n9in
         yjkEiUizRO2qnAsIGDqxw//QMoA9DYkrSzTqflaiCczVSAIovv9ZVSbWCkPjRwPVjWg0
         gB17Xe4pdfDCK4rypE2cdD/w2tS1iHIz5E8RIL/IGHIhHPRTrIR4JlevYkUbYIiIeqzo
         lyHtNLcm2U8XvmB0PkcL78GGmvSlB45Z7KeK3I0wBkIXBrpwfSRvBPhGb65vdF6zISWi
         /W9r3Z0AR9CL9kezruGAvSECiCBYBuh2/C5+E/SgjQO1NLErI+LG8C3Mh9V+KJhyej5L
         lRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dpf57obcTDUfpgE4X4aU2uC5mE04uKRHqZ7salaebWY=;
        b=RrkuB7aeqCsSzlnu9kyeZhxi4eZwJXzOBbWz84SwvNe++bNZhTzZjTU1a0fckXYwOf
         geKL2QxovY+fKhyA/8AM2txg5zWSzrK18UqVtF03WRRH88MUyn2n5zFj1VcDYDhtK2OL
         x85r4/dWokT8NmLtBHIIark724q9LFNrGaSdYPdVPdENKfBSxbpH8iOfQ+SFSpgOdGB6
         2s3jEhiCfLgF7gFROUJtUVOVAo0TwggbwReF6L5tCkh2SqMqsRFu7PNMfWuwepgJwJ3W
         qPum/TEBmLm9O4RJT419+iVlmfmC7J92dqYdwkv+pGeoaJ/OJI7VuLVIzB9vjTUvnT7s
         X/jA==
X-Gm-Message-State: AOAM531LwKrIU4kFI+9KgJseWOFX69D3rWWBuiwgXHj8GdDrVxImBG1h
        ScHmIvAz33OxNqZIha6LWvUcPHydF9BNE0qwvwoDKYV62Cklxw==
X-Google-Smtp-Source: ABdhPJxeZbSScoQ+As7CbT+Gg8VIx5tt5UejlPgz4LaSFdFAdNjkpOYBr4EFlysevakPxMbUijmoyLqWGxxZKj9Af94=
X-Received: by 2002:a25:da4e:: with SMTP id n75mr22709876ybf.425.1604343598235;
 Mon, 02 Nov 2020 10:59:58 -0800 (PST)
MIME-Version: 1.0
References: <20201101153647.2292322-1-trix@redhat.com>
In-Reply-To: <20201101153647.2292322-1-trix@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 10:59:47 -0800
Message-ID: <CAEf4BzY+_aqCpww9ZCHOMCnunvWrszWTUFDP=cEy2CY75S1yRg@mail.gmail.com>
Subject: Re: [PATCH] net: core: remove unneeded semicolon
To:     trix@redhat.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>, ap420073@gmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>, jiri@mellanox.com,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 1, 2020 at 7:38 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> A semicolon is not needed after a switch statement.
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---

Yep.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 751e5264fd49..10f5d0c3d0d7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8898,7 +8898,7 @@ static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
>                 return dev->netdev_ops->ndo_bpf;
>         default:
>                 return NULL;
> -       };
> +       }
>  }
>
>  static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
> --
> 2.18.1
>
