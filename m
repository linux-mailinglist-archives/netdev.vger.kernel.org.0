Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B43CEA61
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfJGRPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:15:47 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:41979 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbfJGRPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:15:47 -0400
Received: by mail-yb1-f194.google.com with SMTP id 206so4921313ybc.8;
        Mon, 07 Oct 2019 10:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Nx7doSqP3vyMGuzBfy84px7RyjVFyVtPj4m80u5+fI=;
        b=fpotnShtdpDup2DXvJaoGrtqQYYBSecr7fmSn4xZCy1x5vqeP+tYHPJGGNM3I1+QEs
         Kz9yRsUrAItVCSp5XgFY8EiWRF5toWcO1WW1g78Zj+VHl9oud7+KREti4dwFMvT66ib9
         0fvzTR9AveV/XNheaCMGxeaxdUUBNTovRCfLrkX8uuCXsSmJUFWDqu1UEvgWgb1wwRW1
         sbbd2fby/5AA28HzuVW4uTUZUAEwohiwDxkRRZuFqfP6tUfx/rlOO2NaLwycc1tQssV0
         gsKlMor9+KZi+4R0ClZ8Q24n2VyyD4gTOEBynNUootX/1Y3iqeK62vH1TZSCr+5XDayy
         rliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Nx7doSqP3vyMGuzBfy84px7RyjVFyVtPj4m80u5+fI=;
        b=sXeEugSYxmypgdvTjzVlaLFkGfgNiss56fptmLtBpULndgkeUaQbnwwv9JMMlZC0Gi
         EUC8VwlLl/5W2sxN6Jhhe1Oh3bSBA72LFaQAkNxbBp006C/XigFzfXt/1DZMlQrFYeOF
         6RkSsT5H0/+RmcERpz7X4uGq/SNTJgDg1h+gAaFkp2hP1MhZPJYQ4448Xq+s6PX3c9AR
         b1zob9W5emK1CeesyaKlFdrSukznHHCY0GgWwRbFh/KolKVNrvzCMLzWsfgOB7Xy61ut
         QZBpt7d+ZEOAW7WEyWVitWkTNOcy405f9pXCOIMLMnnkbN4bDv7MNhZfhdRYkQgD5gZF
         KI1g==
X-Gm-Message-State: APjAAAUq00wTVUA+wDRVmRfTewQAFgWm5f230GMh+pMeMwZn8r6SdvH7
        vNPYwbLdmBTzpSR2B0xAbgpsR4lbjUeEfDLR0w==
X-Google-Smtp-Source: APXvYqxAe6f6zBkaVphOXDXxxig/53h6NuLQA7tKjf0QoRvgjG8+bN0tffbGCZfpLCLBqAMTXYY8Sc01CmTKFXFb28k=
X-Received: by 2002:a25:dcc6:: with SMTP id y189mr8963361ybe.9.1570468546254;
 Mon, 07 Oct 2019 10:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <20191007160635.1021-1-danieltimlee@gmail.com> <CAEf4BzYV68OubcBFZWpMvkKsHhzb3uuMQ7HcMUgYgqigog4q0g@mail.gmail.com>
In-Reply-To: <CAEf4BzYV68OubcBFZWpMvkKsHhzb3uuMQ7HcMUgYgqigog4q0g@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 8 Oct 2019 01:13:57 +0900
Message-ID: <CAEKGpzhhTn6OTQShmg31epf_Jgmo6jrqwCs4=bd3PQ8+548dZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 1:41 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Oct 7, 2019 at 9:06 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > to 600. To make this size flexible, static global variable
> > 'max_pcktsz' is added.
> >
> > By updating new packet size from the user space, xdp_adjust_tail_kern.o
> > will use this value as a new max packet size.
> >
> > This static global variable can be accesible from .data section with
> > bpf_object__find_map* from user space, since it is considered as
> > internal map (accessible with .bss/.data/.rodata suffix).
> >
> > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > will be 600 as a default.
> >
> > Changed the way to test prog_fd, map_fd from '!= 0' to '< 0',
> > since fd could be 0 when stdin is closed.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > ---
> > Changes in v6:
> >     - Remove redundant error message
> > Changes in v5:
> >     - Change pcktsz map to static global variable
> > Changes in v4:
> >     - make pckt_size no less than ICMP_TOOBIG_SIZE
> >     - Fix code style
> > Changes in v2:
> >     - Change the helper to fetch map from 'bpf_map__next' to
> >     'bpf_object__find_map_fd_by_name'.
>
>
> This should go into commit message, that's netdev preference.
>
> Otherwise looks good!
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>

Thanks for the feedback!

Will send the next patch with the modified commit message right away!

Thanks,
Daniel

> >
> >  samples/bpf/xdp_adjust_tail_kern.c |  7 +++++--
> >  samples/bpf/xdp_adjust_tail_user.c | 29 ++++++++++++++++++++---------
> >  2 files changed, 25 insertions(+), 11 deletions(-)
> >
> > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > index 411fdb21f8bc..c616508befb9 100644
> > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > @@ -25,6 +25,9 @@
> >  #define ICMP_TOOBIG_SIZE 98
> >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> >
>
> [...]
