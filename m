Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F63EC2AE3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfI3XaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:30:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35871 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfI3XaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:30:14 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so19312693qtf.3;
        Mon, 30 Sep 2019 16:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7qsde0PkcLZQqxIUC5MiQCVNlQ/k0a83bZxqbnwpXwQ=;
        b=m8SlPVK1FqFX3LghWJOxmmo0ppzFkJqDOufERO2/E+qlYQPHkA5UcQLgUfPMNXkKql
         p3C0yZxYsCXRVDcvC3Pm4mIEJwOcp7UBrKTJkeDskGg6Kst0FiUVtir+SYm1G3AXM3U0
         Ngdjk0OMCKELJcUS1x8x/12Jnf+kArbVCu0Km9cb87yOW66SQ3FXs9F/pp34BoGIoH7L
         YUzK873d97eSj4c2i3BTC6FsJNsHxZBR7uc96+KS2NmLGVj1ti/5rEZLmXZvSQNZMuFV
         AQz375wj31bsyhwNEr+w/G84+2wp/gTPsjxlaAhDZQ2PprQ5Wiz4PdS4/uMpa2ub7h2J
         VUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7qsde0PkcLZQqxIUC5MiQCVNlQ/k0a83bZxqbnwpXwQ=;
        b=ed3r72Ol6PdiByx9qOzv++PocA8SReWBscPgt6RDgNCPDs0XrzfDuwdxLtvRJWxTL/
         mSEtQU1dpjeX3zCMcH+Iqqvs6V20GJOJFmoMlQXUWc7+wu6Q8/6c1nBSIOhnewMR3skY
         DiN25SWiBr80OVnpZDleIAMjK47ql8M+2N09julHMQym2yNz61dusCUT3jYTB6BzT1MC
         P80UpoJf7gaO2qqTKR6qLuGEzY/vizHdtUCCfbSQiCj7EjrGelk/N2qmJWuBDii/wKXN
         0yguOpAWm3HJ324o+pcnXA/y9a/KTULMu2ahJ/OgKRAemJIXU78BYN5yxK+iQHryIWzX
         Gx9g==
X-Gm-Message-State: APjAAAXIbW+VyZq14PFNm/geZaRV69WEhdvYAyW0bg9INY4eRIcqDC1e
        AnDu72liDdDw2f2PZQHmC3GvLUQVDU0uqJ170fbA3SXc7Os=
X-Google-Smtp-Source: APXvYqxtePaQaMW9ez6Hk8/WUTELS1vpCxsWpAKTEYbdqzOf84apmW8psfr0Wj4ATOqQUdIFG3+V4HpfOIvImhiKOs8=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr27742052qtn.117.1569886213666;
 Mon, 30 Sep 2019 16:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
 <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com> <20190930161814.381c9bb0@cakuba.netronome.com>
In-Reply-To: <20190930161814.381c9bb0@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Sep 2019 16:30:02 -0700
Message-ID: <CAEf4BzYBUVJTexS8h0smJiw09V_W+C_AeRyDbFvCum2ESzPO6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 4:18 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 30 Sep 2019 15:58:35 -0700, Andrii Nakryiko wrote:
> > On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrote:
> > >
> > > On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > > >
> > > > Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> > > > are installed along the other libbpf headers.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
> > > many +++ and ---?
> >
> > I arranged them that way because of Github sync. We don't sync
> > selftests/bpf changes to Github, and it causes more churn if commits
> > have a mix of libbpf and selftests changes.
> >
> > I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
> > don't worry about reviewing contents ;)
>
> I thought we were over this :/ Please merge the patches.

I'll merge those two patches, our sync script can handle that now,
though with a bit of human input. I'm not exactly sure on the "why"
though, I think generally splitting libbpf changes and selftests
changes is a good thing, no?
