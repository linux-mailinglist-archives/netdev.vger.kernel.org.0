Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EC23E4DD
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHFXwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHFXwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:52:32 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB121C061574;
        Thu,  6 Aug 2020 16:52:31 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v12so223936ljc.10;
        Thu, 06 Aug 2020 16:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qz1jgyy5KwnzRbzxBRE0+X3/jeLgG3MlEZC2GxNudI8=;
        b=m3PsQ+PDi4k8lQCMS+e9yfGC98lm0tPx2wEYrIU1ZMOnnq2dzjY6WvBc91IrYungtz
         n3mYfbXZ5K+bQBu7bStBi+Xm8zkF2vbaREtPKpVPGD/Zkr5VdymyOK5EG6u1q9dkN25G
         /lre0OjnVoPefrVBrFXzgoyeD/7SiTCDKp7gbULymgNJ4OTcAgKAhT18UEy6pBrOzuGW
         M9Sbc+2TXXVLR0P00QVWn1ig2Lx6C/71K783jnJK4V/8ZrmtyC+hvafhYUUeTwYvM6sd
         RxD/U3MgKGVC3fV3qOVX1EKJnBMh8b2LhTAj9pkzRpQTtdNL41S+6Z/Meu3vknvCouEm
         FAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qz1jgyy5KwnzRbzxBRE0+X3/jeLgG3MlEZC2GxNudI8=;
        b=VaqfmLAdga+uoD2uQi4ChNcM7kYGBwk+aYepSbYVlcbPHXMy9Yfi7A7qhH7W201tM2
         UZQJp6CewTemkC+aW+ulf1wi9qYFNJ4rbrVSeWhqUoRK/JfU9I3liz6mVSSloZNwTOd+
         Tsq/USPqv1UNQkQfYYv+ngsRv/j0iHJysPCCD5qRmBSjW/oXG9J90ygdfzXtUiujO2l3
         5Jqc/5rq9T2Od7NVRSzcuVAIJvIgUiIDh8IONSHmouTdQtECaAwvjU3ocqKGSrZkJfEo
         L+FPd39fi2T8JfJQxD+yvNIq6VCTq6Fx76iLnkaiJWeq9ipM90/SxjtsnwBo9ALiE2jt
         5tsg==
X-Gm-Message-State: AOAM531OxxXwXK16Y2Fl/MbXIEmKJsgr9l3R3lkunnGVAvJPT6xg8tS1
        FU+axvJWuxXi/hjgEotVvAMMuG2pr8g3sH/0FzjV2g==
X-Google-Smtp-Source: ABdhPJxCr4q0x1ObIxT0L9dmKE0kM4gTx1gtH/bVdKxMT9XFDouPQhs6rb3eDvdJ+67/2uoLh7EuQ2ffJFBilgBdfLo=
X-Received: by 2002:a2e:b6c3:: with SMTP id m3mr5103034ljo.450.1596757950339;
 Thu, 06 Aug 2020 16:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200806155225.637202-1-sdf@google.com> <20200806182209.GG184844@google.com>
In-Reply-To: <20200806182209.GG184844@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 16:52:18 -0700
Message-ID: <CAADnVQLnKo+V9tR+RmtwChqT8m211iDfHUjoZ=3psL_Brov6aA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: add missing return to resolve_btfids
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 11:22 AM <sdf@google.com> wrote:
>
> On 08/06, Stanislav Fomichev wrote:
> > int sets_patch(struct object *obj) doesn't have a 'return 0' at the end.
>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >   tools/bpf/resolve_btfids/main.c | 1 +
> >   1 file changed, 1 insertion(+)
>
> > diff --git a/tools/bpf/resolve_btfids/main.c
> > b/tools/bpf/resolve_btfids/main.c
> > index 52d883325a23..4d9ecb975862 100644
> > --- a/tools/bpf/resolve_btfids/main.c
> > +++ b/tools/bpf/resolve_btfids/main.c
> > @@ -566,6 +566,7 @@ static int sets_patch(struct object *obj)
>
> >               next = rb_next(next);
> >       }
> > +     return 0;
> >   }
>
> >   static int symbols_patch(struct object *obj)
> > --
> > 2.28.0.236.gb10cc79966-goog
>
> Sorry, forgot:
>
> Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in
> ELF object")

Applied. Thanks
