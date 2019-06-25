Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8141155AF9
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFYWWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:22:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37779 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:22:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so256625qtk.4;
        Tue, 25 Jun 2019 15:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UIScmuqzmHtP5cs3qdtyOOMP1G/re5ti0q7i+OMbwpQ=;
        b=Jpjchimp2JDOYaaFB0LuvnV5+WYA0YOWS+6RM926A16OcqOWJ1qTpjdt8mP8+3tUND
         YWmXJ+XcDKv/ivg2fgFp039T0Lu18eMwEx2Pjj1oQ5RseN3ZbHlYSEYMrzP/VRTJ0NBO
         jiqYYN5JwqCrTh6KIbc28MT7BjCIzJj3gdc9BbBdrtwMLKavPTYQT7xlPP4a0z0uu/w/
         BHMldNz9CFIjGvCTTM49Z4ZBjtqQnvMlfMVPp33ia56peWs47hqDi0/+dRvP0DJKn57E
         d85KfK1aIa8FuPiKFoj6ZEkly4g6ZewoDZi8OzRrmJy1bj96TpHcl3ICR/zDzkX0uT1R
         Golg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UIScmuqzmHtP5cs3qdtyOOMP1G/re5ti0q7i+OMbwpQ=;
        b=VMjAIY0JubILrQCgCNhLLycKu5J5dUkcxrOGM2EKK3XeZmmXG5vAa3/YHwOY63uJ4j
         Sfb1Rn71r+EgVqK2nIAzPRuRDw9cNlsfxLKjVD7XgAR7xreBhK+F2QX+yDqxS6ySYm2N
         FcJqhbnKBOHcswCFGwinzOj6XMR5unX8vF1bfPJ1SVO7sbk7x3kswU743T1V0aYxy+3B
         pgcwjRS/AejFStdKyGSpI4HyG/8O+QwNR4pUMZg4g32HbHvLHEE/06P3s3Fd7n6TGkxM
         ZCB7Ms7tryPG2h5Rzx9uE5NvE0Jgyk1a3JVL1+vqivkDjjLh/EWlKin0DWoj8qWx2Ywy
         BWpw==
X-Gm-Message-State: APjAAAWRZqThP05Ft8jUMaUBQhWanFqrBOz81zpLIxnJVXnkj5P0h5Sx
        rv25jxM1nH3MaS0oMoA/sEer2pUEjS3eL4FJ++VeB91J
X-Google-Smtp-Source: APXvYqzP0Yga5zA3Nr8BCDYvonMXshDXZa/5tCad07XahrQVxkAFLOh/iJuYlAkPMsQxiXOrIKH61OQYX8r/fV8pcpk=
X-Received: by 2002:a0c:9807:: with SMTP id c7mr629522qvd.26.1561501337824;
 Tue, 25 Jun 2019 15:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190625114246.14726-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625114246.14726-1-ivan.khoronzhuk@linaro.org>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 15:22:06 -0700
Message-ID: <CAPhsuW4oB55TNJx9stfOq68d1O8quxuhonLv0466pdAo0cR=bg@mail.gmail.com>
Subject: Re: [[PATCH net-next]] net: core: xdp: make __mem_id_disconnect to be static
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        xdp-newbies@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 6:11 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Add missed static for local __mem_id_disconnect().
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

https://patchwork.ozlabs.org/patch/1121730/

I guess you are a little late. :)

Please ack the other patch.

Song

> ---
>  net/core/xdp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index b29d7b513a18..829377cc83db 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>         kfree(xa);
>  }
>
> -bool __mem_id_disconnect(int id, bool force)
> +static bool __mem_id_disconnect(int id, bool force)
>  {
>         struct xdp_mem_allocator *xa;
>         bool safe_to_remove = true;
> --
> 2.17.1
>
