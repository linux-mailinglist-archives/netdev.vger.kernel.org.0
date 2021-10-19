Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0113434242
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhJSXrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhJSXrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 19:47:00 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633FAC06161C;
        Tue, 19 Oct 2021 16:44:46 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a7so7871432yba.6;
        Tue, 19 Oct 2021 16:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wRp0uCc9ib9VfUqMBmiqBgN9xyj0QNGFxJwonhYRYRA=;
        b=qDcdIniNsKQcaa8PrKQUJMx6/cSMZRZHhQ+wuB4ZJP/g8stcHSukDunoA7Ad93/NGA
         dbnJyg0sYiSLWZVfOTEKPkGY+P8qrZabyhAhIQpMz4IMI9jGirVW2btnvckTiCvaX72c
         cHfpdDMm9KT080BgS+3tqspsVltTpzWL7br6/slgftnSI+ddFN+9DkfNZGK+sj3qMeZP
         jXqYWFhMtDve1V9VZTg4rgdxQfGMVlWMt/AbG0Hgi88GmWNCP1oaexiuLUZr7NCxtGaf
         VXcUgSkT+Y6l3mD7ulvGuM1huSKI+2S9SoelPdrpbK3BHJIlmoJHnqNbGTOsV2BFpqJK
         hGAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wRp0uCc9ib9VfUqMBmiqBgN9xyj0QNGFxJwonhYRYRA=;
        b=0LQylHpCYl7txD8jCy/LThD8x2//wnfihY6dUs0ecpIzkD1N226UsbNFH7JenOsjRz
         HJ1Dg0pCMVg1/g4Q/2IqVupwtmlO9bksZj+vbmLcvl2zqi9MZUR6F4kU7uLkwUObreYz
         I4E5aV02xGs5uUMYlp/WhiR3tkbMqtEK3EQuu/GI7beM9y9xuKC2GWnD2D0FYRrMOr7i
         14p7huxae37Ry3GZQdCgJpmkfWNtYSE/4vRylS2kG3ibxADxo4jwwqXjqp+eiMOBzGRU
         z4VhfOUjgc5Qcq2iqsQ9nHjjfiKj2++ptXNEUSJGi24J3v5g+PYk2W8wJNKtlqWTdh2b
         OUoQ==
X-Gm-Message-State: AOAM532Q76GTW/8FV3s4Kwh6ViMMUTjO70Sa3KlejI74u6AlbA5S+VKe
        LAhiPppzBWZ4Shj81JbqWuHH4ZQe//za3oxff3PC+VcjcI4=
X-Google-Smtp-Source: ABdhPJyvHV2HbHY35Yyx2P+zTCdgA8+UdyqrlfCSKz+M4D+WkPvac2Jlff6sDRHrw/UsHekLvQuh6WZUWNhgWqwMIVk=
X-Received: by 2002:a25:918e:: with SMTP id w14mr23065312ybl.225.1634687085727;
 Tue, 19 Oct 2021 16:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211009210341.6291-1-quentin@isovalent.com> <616d7f32e2125_1eb12088b@john-XPS-13-9370.notmuch>
In-Reply-To: <616d7f32e2125_1eb12088b@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Oct 2021 16:44:34 -0700
Message-ID: <CAEf4BzYnX0=ub-Le0aa9YhpGUQ7ma2hfm3JeZWg_mXY606cBDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] fixes for bpftool's Makefile
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 7:05 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Quentin Monnet wrote:
> > This set contains one fix for bpftool's Makefile, to make sure that the
> > headers internal to libbpf are installed properly even if we add more
> > headers to the relevant Makefile variable in the future (although we'd like
> > to avoid that if possible).
> >
> > The other patches aim at cleaning up the output from the Makefile, in
> > particular when running the command "make" another time after bpftool is
> > built.
> >
> > Quentin Monnet (3):
> >   bpftool: fix install for libbpf's internal header(s)
> >   bpftool: do not FORCE-build libbpf
> >   bpftool: turn check on zlib from a phony target into a conditional
> >     error
> >
> >  tools/bpf/bpftool/Makefile | 29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> >
> > --
> > 2.30.2
> >
>
> I'm not a Makefile expert, but from my side these look good. Thanks.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied to bpf-next, thanks.
