Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217B7233A64
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgG3VQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726978AbgG3VQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:16:21 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6039C061574;
        Thu, 30 Jul 2020 14:16:21 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a34so10156151ybj.9;
        Thu, 30 Jul 2020 14:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5NaovValSYr4yuny0MmOs2lawjRMcuEoZkrb5hbJG6U=;
        b=cn461Dyoi/FtS3cTcEnVOK+iADAi1AfKNqHeQW6g9IpuK7n9mcfP1z912qf8c4FU0e
         FJOGbiXD0xo32ZldXzVzsNXM2seTTWYtQTYdx3JvfWE9iAHznG6uCnDKOO/b+Q+/E+2m
         05TTFFnRybxuiQcnEMaJOwp/DpVta+Qh8ewkg0e4cHuxt/HBcGcDnInsLAJ279rE124P
         Wlpb5zqgFOB7EbJaQ9VhSqNOXDH/7fQIXVK5AtdDlU/FyUt+SnL15xlMvcIFjPlW4DWI
         RbcCF+wi0p/92ziyFk6myhq47W24BEHcMm5Gxj2X8N3bYieOoZA1k9qEt93YGuZRbEzX
         lOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5NaovValSYr4yuny0MmOs2lawjRMcuEoZkrb5hbJG6U=;
        b=rCh7l+BXoj+39rEPrW9HArvjrwQMU5Z6Ym2HUDNe8uve6uLct0dVXhUtugHuIqXJSo
         eW20mJ5GWcKkzAir9ykwk9uwt/ePXGTTcRcU1aAETz/RY9AoQ/pndrqP1sFU5gLWXAJe
         GP/PZUVNqPUl/u34gW4CNopkju7awPg2Db8NEMxaBQ01dQ6hgM97MMr/CPkKePx31C/S
         ysVC3JktHpG5HrUzUTthqQ/Trs2l3QWAfYr36CNr+zCL0GEgj14DrBwx7yp0dJ0T/yAB
         fh5/Hse8aV57Ohvj/SIqDDXnxNTC28XC7+hGI3zN5ruW77OFXmCavGQMjbok6M1YP5yo
         OVcQ==
X-Gm-Message-State: AOAM531SJ0+lmBtWAH2RpAtE5YMklzMXii2uttkQTK/Iv4gtGkZ0x3nQ
        2Eoh63FuK7p79tzjnocNUY5JnXGQWYzGa/K1R3U=
X-Google-Smtp-Source: ABdhPJy8z7GCu2Ce0xY7Vr+4b/zzcclnS0YqoyEkq2vpPyUZytHokhSXJSLMWaw7mDyrKpdZT/VKOAT7WNZaX2FxUkQ=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr1351602ybg.347.1596143781019;
 Thu, 30 Jul 2020 14:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200729230520.693207-1-andriin@fb.com> <20200729230520.693207-6-andriin@fb.com>
 <770B112E-DBDF-4537-8614-765D19EDF641@fb.com>
In-Reply-To: <770B112E-DBDF-4537-8614-765D19EDF641@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jul 2020 14:16:09 -0700
Message-ID: <CAEf4BzYOmtjmYRPjA_Crbt8TjQZpTG12YZSp1xTrr4d4dADcNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] tools/bpftool: add documentation and
 bash-completion for `link detach`
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 2:13 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add info on link detach sub-command to man page. Add detach to bash-completion
> > as well.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With one nitpick below.
>
> > ---
>
> [...]
>
> > @@ -49,6 +50,13 @@ DESCRIPTION
> >                 contain a dot character ('.'), which is reserved for future
> >                 extensions of *bpffs*.
> >
> > +     **bpftool link detach** *LINK*
> > +               Force-detach link *LINK*. BPF link and its underlying BPF
> > +               program will stay valid, but they will be detached from the
> > +               respective BPF hook and BPF link will transition into
> > +               a defunct state until last open file descriptor for that
>
> Shall we say "a defunct state when the last open file descriptor for that..."?


No-no, it is in defunc state between LINK_DETACH and last FD being
closed. Once last FD is closed, BPF link will get destructed and freed
in kernel. So I think until is more precise here?

>
>
> > +               link is closed.
> > +
> >       **bpftool link help**
> >                 Print short help message.
> >
>
> [...]
