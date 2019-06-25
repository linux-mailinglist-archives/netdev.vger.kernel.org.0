Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B3355AFF
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfFYWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:23:38 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36286 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfFYWXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:23:36 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so56408qkl.3;
        Tue, 25 Jun 2019 15:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sIswbHwSgwSuwLr12QK1wbcjOcRm9pBAZPfq0tTPI80=;
        b=Kd+OIZ4ILZQeUT4uqYRzZCi57MzQutS8qVccTvXg3Y881AcKiY/VGcvk5Tnq7TJxsi
         aTeNWHp/cE+chparMWuUSn9pfGUxuZL34U89IAbnDl+20fpCbMBC3A6YV5r+Tzb8Mp2r
         Xz31U3gYgxprK+5DRzhxx9nv3bGmHzztjawhgFg2/6Sf42ISGyMlbSNf1ZC1UgZbaXA6
         yfUHQDMWB5SE/j2FAFIqwdC2x6sPwXw+QLmlZqXeA7cvL4Bk/5x+XZQr3cieIjaVQ8SL
         rbPa7m6v/XvLiMYwJ8UvpwE0RPuifekrcaaoh3wxXOroz7eYKe2L4QsFXE9x7+NI8edP
         hRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sIswbHwSgwSuwLr12QK1wbcjOcRm9pBAZPfq0tTPI80=;
        b=nR9qRqxc+CmtthuxtB7Y0JBgiOIEKmQDG4BjgqeIrQtIsYNYXrsvttucspnoPtlRuZ
         4xoejsXqmKF40VXMT1AT4Dae9ZmP2AuieYp8/DcAm8gfMsV0GsVLN3yScPb8tVx+8qjK
         MCO4LiVYTH0UmntHsDpWvJ1AMRP97t7EY3je+xUNz/uqbtef/p/1P7FgVJAtjMvBrO1S
         kizQtpoA8r8aqLZBnou5eqGUuLUYCCUdKGg6vqtpPxgmJl6RWL/KdVlnzeiMDl16JUfa
         +K+eU2PC6hHWBGzZwhwG0JOBIfzeXhy2Zn7CibM2Z4NcUwPeQnhrWk30SIcwVcENe9Fo
         qeNA==
X-Gm-Message-State: APjAAAWQc6xbpqy41/w8tsigUrgiwDJMv6NxP1IjHJXKPhPx5X2g+UCD
        lPrpwiPtTOCXUhPJ7YCXt5rp9KmpER7Jyw7Pwlk=
X-Google-Smtp-Source: APXvYqyNaJzdwtghH1BJIpZux6J6aG6NzXOARLRHwdRwvCxVslZjvITlICUOdMwqZAi1K5yeWj6dSC47b+65ljYb6TY=
X-Received: by 2002:a37:4d82:: with SMTP id a124mr995904qkb.72.1561501415343;
 Tue, 25 Jun 2019 15:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190625023137.29272-1-yuehaibing@huawei.com> <20190625112104.6654a048@carbon>
In-Reply-To: <20190625112104.6654a048@carbon>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 15:23:24 -0700
Message-ID: <CAPhsuW7e8KLooD_ASwWE_dbJwNTcs5sqR66LTWxR-cH3SBzSJw@mail.gmail.com>
Subject: Re: [PATCH net-next] xdp: Make __mem_id_disconnect static
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, xdp-newbies@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:52 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 25 Jun 2019 10:31:37 +0800
> YueHaibing <yuehaibing@huawei.com> wrote:
>
> > Fix sparse warning:
> >
> > net/core/xdp.c:88:6: warning:
> >  symbol '__mem_id_disconnect' was not declared. Should it be static?
>
> I didn't declare it static as I didn't want it to get inlined.  As
> during development I was using kprobes to inspect this function.  In
> the end I added a tracepoint in this function as kprobes was not enough
> to capture the state needed.
>
> So, I guess we can declare it static.
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I think the rule is, non-static function must be declared in a header.

Acked-by: Song Liu <songliubraving@fb.com>

>
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  net/core/xdp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index b29d7b5..829377c 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
> >       kfree(xa);
> >  }
> >
> > -bool __mem_id_disconnect(int id, bool force)
> > +static bool __mem_id_disconnect(int id, bool force)
> >  {
> >       struct xdp_mem_allocator *xa;
> >       bool safe_to_remove = true;
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
