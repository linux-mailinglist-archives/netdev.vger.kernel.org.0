Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7540F1EDB68
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 04:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgFDCxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 22:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgFDCxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 22:53:47 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81E0C03E96D;
        Wed,  3 Jun 2020 19:53:46 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d5so4673723ios.9;
        Wed, 03 Jun 2020 19:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=iPa6WDxkXnezV97Gv8ktsN2vMvnblioziS1zAvyim80=;
        b=gV3DINCKuZMpDCcJsHDr9sszAXGMneIMI9KCtZ/1A8KL8Ro8YmZMB8pbOf6XvwEEzL
         3s/WZ64Ad1THwC1yIcoFtMfrjuy9MChcgCUeVc2yt6Fhqv5YnQlKfybyJa868B56C64R
         SpWLnoPhud5yWqrZVnmnqlgYyhjIfWw9LqP/fxle2AdjsoTo956wTTJnEH2/k/fpJpV8
         AlEmkB8V6/jcUVOOJnMZ+E5Zm/eCneQHSejIbdNntpH48J0GSb9f7+yK1rM1n2Ds+iYc
         oegcVR8oOw7YMCXmQJAWTc+Zqvl8pQBXc+Tu4Mxm/lQXO2FR+n8tx0M6aLA2yfHxQbwF
         EZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=iPa6WDxkXnezV97Gv8ktsN2vMvnblioziS1zAvyim80=;
        b=iqaKh9GqlRIdw6Q1Oog/DmwRsqEYT1GkWFBgBgnMreReAmfj8DtuBdf+t/MAaUNF/V
         O/0h66BhgOlPUAzcmUD2r7n9Oiku4RaBVqUO3UKoOV91Gx2KnF0I/0N9BzbGWHL/qgDA
         lMe1hgFwuh59Bg6QHybLtpdE3W62Li9np6N+VoC9KlmhOzvPlvFL+RpAD9C6uGdmiDHJ
         kfV5/GFwa2Pzpg+W02p3Xo7PLRFPmJhXuf0yRxiQU7JDgiZ/nGIX9PMh163izR8Gdt5u
         q4io2MV65S+8NEJqyuHODi1Aodbd2oc2K6ZZxmzr3XoALIqm2Cdqy8iAp3R2WZbIdMMH
         Xa4Q==
X-Gm-Message-State: AOAM531reE8KCPcUUcuxK3DoM9pYUF9aK7ptbTQfOoQbx29Ok/85DnzJ
        tNqgDuE0Tm8lLlWxAI8XkvxWzEbkZK0BGzKe6Q8=
X-Google-Smtp-Source: ABdhPJySRKD1t147Rxyby0Eo8wAO+qnFmJBtx6pTIjJ6uS6L8CSs9GvotZtKdMSuFL1kS3zXMhEH8p9JZsy+Uo4RRkU=
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr2465452iow.70.1591239226196;
 Wed, 03 Jun 2020 19:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-9-keescook@chromium.org> <ff9087b0571e1fc499bd8a4c9fd99bfc0357f245.camel@perches.com>
 <202006031838.55722640DC@keescook> <6f921002478544217903ee4bfbe3c400e169687f.camel@perches.com>
 <202006031944.9551FAA68E@keescook>
In-Reply-To: <202006031944.9551FAA68E@keescook>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jun 2020 04:53:34 +0200
Message-ID: <CA+icZUVg24VrpPgMdfsgPa+Wckci9XkzKUdtwhVB3ZW96uZOWw@mail.gmail.com>
Subject: Re: [PATCH 08/10] checkpatch: Remove awareness of uninitialized_var() macro
To:     Kees Cook <keescook@chromium.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

can you push that change also to kees/linux.git#kspp/uninit/v5.7/macro ?

Thanks in advance.

Regards,
- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/uninit/v5.7/macro

On Thu, Jun 4, 2020 at 4:44 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Jun 03, 2020 at 06:47:13PM -0700, Joe Perches wrote:
> > On Wed, 2020-06-03 at 18:40 -0700, Kees Cook wrote:
> > > On Wed, Jun 03, 2020 at 05:02:29PM -0700, Joe Perches wrote:
> > > > On Wed, 2020-06-03 at 16:32 -0700, Kees Cook wrote:
> > > > > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > > > > (or can in the future), and suppresses unrelated compiler warnings
> > > > > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > > > > either simply initialize the variable or make compiler changes.
> > > > >
> > > > > In preparation for removing[2] the[3] macro[4], effectively revert
> > > > > commit 16b7f3c89907 ("checkpatch: avoid warning about uninitialized_var()")
> > > > > and remove all remaining mentions of uninitialized_var().
> > > > >
> > > > > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > > > > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > > > > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > > > > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> > > >
> > > > nack.  see below.
> > > >
> > > > I'd prefer a simple revert, but it shouldn't
> > > > be done here.
> > >
> > > What do you mean? (I can't understand this and "fine by me" below?)
> >
> > I did write "other than that"...
> >
> > I mean that the original commit fixed 2 issues,
> > one with the uninitialized_var addition, and
> > another with the missing void function declaration.
> >
> > I think I found the missing void function bit because
> > the uninitialized_var use looked like a function so I
> > fixed both things at the same time.
> >
> > If you change it, please just remove the bit that
> > checks for uninitialized_var.
>
> Ah! Gotcha. Thanks; I will update it.
>
> -Kees
>
> >
> > Thanks, Joe
> >
> > > > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > > []
> > > > > @@ -4075,7 +4074,7 @@ sub process {
> > > > >                 }
> > > > >
> > > > >  # check for function declarations without arguments like "int foo()"
> > > > > -               if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {
> > > > > +               if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
> > > >
> > > > This isn't right because $Type includes a possible trailing *
> > > > where there isn't a space between $Type and $Ident
> > >
> > > Ah, hm, that was changed in the mentioned commit:
> > >
> > > -               if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
> > > +               if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {
> > >
> > > > e.g.:     int *bar(void);
> > > >
> > > > Other than that, fine by me...
> > >
> > > Thanks for looking it over! I'll adjust it however you'd like. :)
> > >
> >
>
> --
> Kees Cook
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/202006031944.9551FAA68E%40keescook.
