Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4003817B6
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhEOKnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhEOKnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:43:08 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01544C061573;
        Sat, 15 May 2021 03:41:55 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id z1so1993758ils.0;
        Sat, 15 May 2021 03:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RaZlLKNs1k/HMpA5We9IhXk4g4/XDVWeq+0L5EU74cg=;
        b=C8WkMUyWxR6BH2y0OFlr1I/AWWIbSb3AhNN1Eh1Q6p+YRF9iwA1aukhoPspqdnPcdi
         YpWGJb7v4mHLCNiifvrNzocDFuR0Tm3lkFJFMXo7MQYIAGldT8DnblAqZINZQaTvAiL6
         DTTi09tcUp10J0v/tozx9ed0wiRtjAFm6wER5v55BIgP4xVn7sD2l47sodwNpRxBiTwS
         lbHWy8w/BHDB8TjL24wCrtiO2EPy/ZicNEQ+r4RFIe28gtyS23ufyUinco3a9pI4YhhO
         VxStTyBWe4X2otrCar+2e663o5hAfyoPmKb5q6JLSYwNJIPoXxcWMrqX31prS6IXktGi
         DhEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RaZlLKNs1k/HMpA5We9IhXk4g4/XDVWeq+0L5EU74cg=;
        b=AWtjzqCHNF9df8+NFs3eWmfMrjqtmV8xKc4jr4KbXaMxpZ+NHp9TaEuG5lbkeBxim+
         +l4Zp7dW6Af4XABdZt8J5ULIZfQSeQ/H8AQnw5JM/gp7sAHxjn1PhvWBokoUUDjCiR8c
         82CfG5/23Jwd3aT163a8BZjI07jpUuB2ORRS6++4gXrlsohLgpGxSIh6y1mtVbPRbIyD
         LsJmBoETDAu0l0KF5ROm3yQp+Z19Z1tspCyHNDQySMonYpNSkC/EFixLkdxIVosil3XJ
         7ifCa1TxOBBISS0HvlVbCRMT1aY9GKa+NG2JWnh6QCYps8O6VL6JCQDejRb51Mh++5Dr
         FIyQ==
X-Gm-Message-State: AOAM531s7hsUcJtVI6I2S6JF8Ov1sPCH0Rz9G6Vz5jJMdUUhomdow0uP
        nV8wjGKTAMbvF2PZe5mfWvSyli+P1zXaOeS2fq4=
X-Google-Smtp-Source: ABdhPJz6I4Ldn6dLlfSLifizJEnh9QPwXBvl6LaDvSTOV45dlmpqUrjS3SKw2T5oJ6iKiE0FCLjU6mhWWNu/v0+MZNA=
X-Received: by 2002:a92:ce90:: with SMTP id r16mr45330863ilo.220.1621075314495;
 Sat, 15 May 2021 03:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210514215209.GA33310@embeddedor>
In-Reply-To: <20210514215209.GA33310@embeddedor>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 15 May 2021 12:42:03 +0200
Message-ID: <CAOi1vP8NARpXVsK2AVOZ4_m58gXMKVQSi_okZVcrLsew1nLizg@mail.gmail.com>
Subject: Re: [PATCH][next] ceph: Replace zero-length array with flexible array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 11:51 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use =E2=80=9Cflexible array members=E2=80=9D[1]=
 for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
>
> Notice that, in this case, sizeof(au->reply_buf) translates to zero,
> becase in the original code reply_buf is a zero-length array. Now that
> reply_buf is transformed into a flexible array, the mentioned line of
> code is now replaced by a literal 0.
>
> Also, as a safeguard, explicitly assign NULL to
> auth->authorizer_reply_buf, as no heap is allocated for it, therefore
> it should not be accessible.
>
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-le=
ngth-and-one-element-arrays
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/ceph/auth_none.c | 4 ++--
>  net/ceph/auth_none.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
> index 70e86e462250..10ee16d2cbf0 100644
> --- a/net/ceph/auth_none.c
> +++ b/net/ceph/auth_none.c
> @@ -111,8 +111,8 @@ static int ceph_auth_none_create_authorizer(
>         auth->authorizer =3D (struct ceph_authorizer *) au;
>         auth->authorizer_buf =3D au->buf;
>         auth->authorizer_buf_len =3D au->buf_len;
> -       auth->authorizer_reply_buf =3D au->reply_buf;
> -       auth->authorizer_reply_buf_len =3D sizeof (au->reply_buf);
> +       auth->authorizer_reply_buf_len =3D 0;
> +       auth->authorizer_reply_buf =3D NULL;
>
>         return 0;
>  }
> diff --git a/net/ceph/auth_none.h b/net/ceph/auth_none.h
> index 4158f064302e..3c68c0ee3dab 100644
> --- a/net/ceph/auth_none.h
> +++ b/net/ceph/auth_none.h
> @@ -16,7 +16,7 @@ struct ceph_none_authorizer {
>         struct ceph_authorizer base;
>         char buf[128];
>         int buf_len;
> -       char reply_buf[0];
> +       char reply_buf[];
>  };
>
>  struct ceph_auth_none_info {

Hi Gustavo,

I went ahead and removed reply_buf.  We never receive authorizer
replies in auth_none mode, so patching it to be a flexible array
is rather pointless.

Thanks,

                Ilya
