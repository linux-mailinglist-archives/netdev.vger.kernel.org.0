Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED54F20EC10
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgF3Dfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgF3Dfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:35:40 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B224C061755;
        Mon, 29 Jun 2020 20:35:40 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id r22so17328665qke.13;
        Mon, 29 Jun 2020 20:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X+G/fC1ZJxg9D7sXRo1zoSpZ6TzsmSrYBlcJIXJdrBw=;
        b=sh9H+6YC61FqM9Yw+5iHaaiVQkb2rlCgmYWQk1dbBhyDcKvVeVftDplFj9lxl8ZUR1
         SRaeO+jLM9dB9rwHVVH9Qj9y1e4E7ZFE+z9ZIt66fGk0PgK/qEfrpQ1Ro0clydTZaWrG
         21TjROTW5DUPNpq/6myomXJtwNu52/zO23JNCh9mowDzlJM1DhY3r+5X5ZPJSxJsYLhR
         B4raugXWyZdRJam1qOfWsvtYW5yoToxc715xsF2zGWHviMPge+kusxKU8kmgXNsNBR+4
         nHUxqhEKTVH73ZGnIte1bm8Duklryj/foxTzJMZA7EmIVlmQDrYAbZmTjVlPvV5XjQaT
         U3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X+G/fC1ZJxg9D7sXRo1zoSpZ6TzsmSrYBlcJIXJdrBw=;
        b=Gv9steNxr15YhVeXlYZUsDvmXNSzy/jzK5Vfu49695yVyulP5gpRzHv0NnaIvFbP0F
         +n9IuPCuNKiJXts9A3OMVPJ/4fXXByj7QQIwd0haq7+qms2TnKl00pKsV6j0ffPIEYjk
         QIIqyMQ5YXhUFlOiYM2mW6mRgxQNwwWkIIDgXibCFan2hl4KfKfSzbIN7WMpxsxyYGh5
         XTxeKPy00Oomsa4GzED3bbSlGwaNhXb8DOLOV2d0erJAGyI2Skuo2zvNqX7Ing8x+joa
         15dMoPsNpJEB7YU54SUFu83rtp4KxD8u9gl/i+ctI2LeEPWTPG1Ez9X1SHNPxAQlchJC
         yVYA==
X-Gm-Message-State: AOAM530/YpLe4vKpdYuYailjr7FBPlsL+9/0OpL0NxsJWcLWfP3GhmWb
        aXTj2UK3BK1IvjNCFOTZIurAzKdUANP33I3vZf0=
X-Google-Smtp-Source: ABdhPJzP6AII8IaFL3yt6fo39puoK2J/siP1rOLK+tXJea71FjRs32d2Bi+fbupo/AUmMp1zOIDkcEjNIcFfZiTKnWw=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr18763746qkn.36.1593488139441;
 Mon, 29 Jun 2020 20:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200630020539.787781-1-andriin@fb.com> <20200630030910.p7xnbnywofvzcr7r@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200630030910.p7xnbnywofvzcr7r@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 20:35:28 -0700
Message-ID: <CAEf4BzZdxvFwv11NKJGX4YzCtSHMs0i8nMMhOgxdU_mm0iHnow@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make bpf_endian co-exist with vmlinux.h
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 8:09 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 29, 2020 at 07:05:38PM -0700, Andrii Nakryiko wrote:
> > Copy over few #defines from UAPI swab.h header to make all the rest of
> > bpf_endian.h work and not rely on any extra headers. This way it can be used
> > both with linux header includes, as well with a vmlinux.h. This has been
> > a frequent complaint from users, that need this header.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/bpf_endian.h | 22 ++++++++++++++++++++--
> >  1 file changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
> > index fbe28008450f..a4be8a70845c 100644
> > --- a/tools/lib/bpf/bpf_endian.h
> > +++ b/tools/lib/bpf/bpf_endian.h
> > @@ -2,8 +2,26 @@
> >  #ifndef __BPF_ENDIAN__
> >  #define __BPF_ENDIAN__
> >
> > -#include <linux/stddef.h>
> > -#include <linux/swab.h>
> > +/* copied from include/uapi/linux/swab.h */
>
> You cannot just copy due to different licenses.

Ah, I see. I was thinking that because it's from UAPI header it might
be ok. Alright, I'll try to re-implement it instead.
