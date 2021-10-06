Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747AB424608
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238764AbhJFS1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhJFS1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:27:41 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B13BC061746;
        Wed,  6 Oct 2021 11:25:48 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v195so7668420ybb.0;
        Wed, 06 Oct 2021 11:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bYXNgK9Ea66QXCwQvNInQdxaMCpjeiLm1dgz9WUQLak=;
        b=g/D+SIYqXQIfEzLePcKXbLU1Jz8ibkaOSOH3K9EPAXQOxUWZGjn+X7sk+a6fJm/1tR
         QpGmAyvJyQh676INFMCPrnrdEXtm+1lLjdw0u4cC/xyuGDTZVSci6NK6CAowVL9LBOqi
         f9RlaBr56B/dHVx/uVV73X4mMNLd3UNz6sKoA9W5ez/td4Hf9uUG3dgdXPloAmgOdnf3
         Jrcmk4p2m2ADKw/CNjUgXlZiAST1QUcAbAjeylqh5NDeiteyfrG8v+DknhZcHOR3zVvz
         +djcwtZ6P35mn+1DmDFw78Zy2O4k3R6xRpdpKt6DJmedn1CdEcxkav87lZTlGHvN722f
         JJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bYXNgK9Ea66QXCwQvNInQdxaMCpjeiLm1dgz9WUQLak=;
        b=2sya+IAJ9agDQvJHk1QVgsJu6NJKTBf/NTCYwc3An6O94k5u96U+1aWA59j436grua
         NJwLxl2rkbrWYpUNZvoFvo5XX7CvDtriw9tKdbDkyN4lSFvo4E2ztqI+qZw2vxk+gJlc
         H3v61lGZYXG0GkmhfddJxYzwXpgU4arGYpNndN5PE+LGx3rgz6gEtPIzU1VGAqsSZSTP
         tKkot+AqqT/0tCB4i8uKF4U+nvRddGLzrnOYYWK/XvkuDE62jldv5DB28PiHK4WxUkXj
         TFWi0MGNcj7ncFZRDGgPBRWCO8STd6Cm9+fo+RqttWQ1v8syLGg8uj4iEGdZ3LOB53Bg
         xmjw==
X-Gm-Message-State: AOAM530EPLX6brVScT8Pkp5rveaZG4f62qZSYX4Vpuoki60NN+zaK2Xp
        ITE24F2F0JuKIU5/rKO+VQtHYVKNTyV3I5Kwiho=
X-Google-Smtp-Source: ABdhPJzL5ufbcu+0KfD0sXAz6S9lKlPB0UcUaZrh/kHrtTBQyF7YRjiTY6GTkuZ5xZr1YJMwFC3zZWRzlfLOFjVaIsc=
X-Received: by 2002:a25:1884:: with SMTP id 126mr30621692yby.114.1633544747854;
 Wed, 06 Oct 2021 11:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <20211003192208.6297-9-quentin@isovalent.com>
 <CAEf4Bzaq460PCWTZ7jz1dcTR-Rp2nNMUKbO3UFZ-43qSsf-JLg@mail.gmail.com>
In-Reply-To: <CAEf4Bzaq460PCWTZ7jz1dcTR-Rp2nNMUKbO3UFZ-43qSsf-JLg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 11:25:36 -0700
Message-ID: <CAEf4BzaTbHHZ3+AtRxo9_LoS3bC6RKMw-cV5ME3qdoY9eB-7kQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/10] samples/bpf: update .gitignore
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 11:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > Update samples/bpf/.gitignore to ignore files generated when building
> > the samples. Add:
> >
> >   - vmlinux.h
> >   - the generated skeleton files (*.skel.h)
> >   - the samples/bpf/libbpf/ and .../bpftool/ directories, recently
> >     introduced as an output directory for building libbpf and bpftool.
> >
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> >  samples/bpf/.gitignore | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> > index fcba217f0ae2..09a091b8a4f3 100644
> > --- a/samples/bpf/.gitignore
> > +++ b/samples/bpf/.gitignore
> > @@ -57,3 +57,7 @@ testfile.img
> >  hbm_out.log
> >  iperf.*
> >  *.out
> > +*.skel.h
> > +vmlinux.h
> > +bpftool/
> > +libbpf/
>
> this will match files and directories in any subdir as well, maybe
> let's add / in front to be explicit about doing this only on current
> directly level (*.skel.h is fine)?

Oh, let's also move this patch before the samples/bpf changes, so that
there is no intermediate state between commits where we have these
files not ignored


>
> > --
> > 2.30.2
> >
