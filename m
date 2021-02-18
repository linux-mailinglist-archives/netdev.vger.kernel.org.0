Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678AB31E523
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 05:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBREXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 23:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhBREXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 23:23:32 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73A1C0613D6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 20:22:51 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id 80so790367oty.2
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 20:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8oY3+hBS7HKyq1cNaFZMy0hOHTWoFPax0mpOWicnEg=;
        b=sVa5znoA+n13GOYmUbAL0Merg4RRzMzSXBlV0Iel4bRWHFTkjYz+rK+bnUHUV8MqAL
         hYKO/CSpKG5JFKd9VHIXtcfobS/i6tGzgqedtrjG1tHq9sSAM/sV5hns2rf2ZAtwIQWj
         B6FBlxY0VNR4+uxxlZyGbFKaRVzIExLLWpbndogLJAlJ3w2Xg6FCt+ofchZ+yfs6FbYi
         WFbnRylUi/kyxDPAAE2fScW4fn0lBf3v+KeY/EyhA09PX5Ixhc3IiEj2BxdYQUB7gMJR
         w04RaDZsuf11PsCQdC2CkUMvomnaf7jCS7waXhrYHBICkJJwZ4x39XZ8zAy1SQs+15NU
         jBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8oY3+hBS7HKyq1cNaFZMy0hOHTWoFPax0mpOWicnEg=;
        b=rGUaPqEE/JUHrq3XN3yT58oH1MFs7XpXkLA+gzTgCi4M3ZZ2vgJnRAJ12/wXP98qqJ
         1QosoZmpeyvLIWfLY3DGw/erW9y76Gw0pY206Cq9DeCUbp6dNozWrAqMVxrzbuh4VWMV
         xNUgyGC0CrXOgS7KARNzU8yh6oxsuDl9YHd1YpvnYrmMFP6+KmBuRj0AX9/jPgLNCeht
         lA5eVi3gLNXcYscp3jOlICrpIkiqBiCazlpJLJQ85Cg9Ui3XoS92jzwz47XVxv/Fhtsk
         YoMDoITShlFCkw1ph9LeJiER06kRmkFsmlwX675UBNBoeu0FMlAOd124YNY0LVPx+VY6
         XpgQ==
X-Gm-Message-State: AOAM532FDKSs4vEJS5qJpLdMncDz7l/dd0DQdBV80kVjL4M+2h7E3wbk
        AxkLEGnAS7CMz1IqkAlwLN3K7ShIRJ649mHuE7Sxfw==
X-Google-Smtp-Source: ABdhPJzgAr61Ally+5+Wz2l53uNAG1MM31KgN8aAurrCxAimEPIZlJwMf5uxDIKMe+sdOZ6BZcUiFhZd5dN0ErOVb8Q=
X-Received: by 2002:a9d:480f:: with SMTP id c15mr1696507otf.55.1613622171042;
 Wed, 17 Feb 2021 20:22:51 -0800 (PST)
MIME-Version: 1.0
References: <20210217010821.1810741-1-joe@wand.net.nz> <871rdewqf2.fsf@meer.lwn.net>
In-Reply-To: <871rdewqf2.fsf@meer.lwn.net>
From:   Joe Stringer <joe@cilium.io>
Date:   Wed, 17 Feb 2021 20:22:33 -0800
Message-ID: <CADa=RyzDXeJeW7jAVce0zfGX2zN5ZcAv5nwYsX7EtAz=bgZYkg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/17] Improve BPF syscall command documentation
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     bpf@vger.kernel.org, Joe Stringer <joe@cilium.io>,
        linux-man@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        mtk.manpages@gmail.com, ast@kernel.org, brianvv@google.com,
        Daniel Borkmann <daniel@iogearbox.net>, daniel@zonque.org,
        john.fastabend@gmail.com, ppenkov@google.com,
        Quentin Monnet <quentin@isovalent.com>, sean@mess.org,
        yhs@fb.com, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 9:32 AM Jonathan Corbet <corbet@lwn.net> wrote:
>
> [CC += linux-doc]
>
> Joe Stringer <joe@wand.net.nz> writes:
>
> > From: Joe Stringer <joe@cilium.io>
> >
> > The state of bpf(2) manual pages today is not exactly ideal. For the
> > most part, it was written several years ago and has not kept up with the
> > pace of development in the kernel tree. For instance, out of a total of
> > ~35 commands to the BPF syscall available today, when I pull the
> > kernel-man-pages tree today I find just 6 documented commands: The very
> > basics of map interaction and program load.
> >
> > In contrast, looking at bpf-helpers(7), I am able today to run one
> > command[0] to fetch API documentation of the very latest eBPF helpers
> > that have been added to the kernel. This documentation is up to date
> > because kernel maintainers enforce documenting the APIs as part of
> > the feature submission process. As far as I can tell, we rely on manual
> > synchronization from the kernel tree to the kernel-man-pages tree to
> > distribute these more widely, so all locations may not be completely up
> > to date. That said, the documentation does in fact exist in the first
> > place which is a major initial hurdle to overcome.
> >
> > Given the relative success of the process around bpf-helpers(7) to
> > encourage developers to document their user-facing changes, in this
> > patch series I explore applying this technique to bpf(2) as well.
>
> So I am totally in favor of improving the BPF docs, this is great work.
>
> That said, I am a bit less thrilled about creating a new, parallel
> documentation-build system in the kernel.  I don't think that BPF is so
> special that it needs to do its own thing here.
>
> If you started that way, you'd get the whole existing build system for
> free.  You would also have started down a path that could, some bright
> shining day, lead to this kind of documentation for *all* of our system
> calls.  That would be a huge improvement in how we do things.
>
> The troff output would still need implementation, but we'd like to have
> that anyway.  We used to create man pages for internal kernel APIs; that
> was lost in the sphinx transition and hasn't been a priority since
> people haven't been screaming, but it could still be nice to have it
> back.
>
> So...could I ask you to have a look at doing this within the kernel's
> docs system instead of in addition to it?  Even if it means digging into
> scripts/kernel-doc, which isn't all that high on my list of Fun Things
> To Do either?  I'm willing to try to help, and maybe we can get some
> other assistance too - I'm ever the optimist.

Hey Jon, thanks for the feedback. Absolutely, what you say makes
sense. The intent here wasn't to come up with something new. Based on
your prompt from this email (and a quick look at your KR '19
presentation), I'm hearing a few observations:
* Storing the documentation in the code next to the things that
contributors edit is a reasonable approach to documentation of this
kind.
* This series currently proposes adding some new Makefile
infrastructure. However, good use of the "kernel-doc" sphinx directive
+ "DOC: " incantations in the header should be able to achieve the
same without adding such dedicated build system logic to the tree.
* The changes in patch 16 here extended Documentation/bpf/index.rst,
but to assist in improving the overall kernel documentation
organisation / hierarchy, you would prefer to instead introduce a
dedicated Documentation/userspace-api/bpf/ directory where the bpf
uAPI portions can be documented.

From the above, there's a couple of clear actionable items I can look
into for a series v2 which should tidy things up.

In addition to this, today the bpf helpers documentation is built
through the bpftool build process as well as the runtime bpf
selftests, mostly as a way to ensure that the API documentation
conforms to a particular style, which then assists with the generation
of ReStructured Text and troff output. I can probably simplify the
make infrastructure involved in triggering the bpf docs build for bpf
subsystem developers and maintainers. I think there's likely still
interest from bpf folks to keep that particular dependency in the
selftests like today and even extend it to include this new
Documentation, so that we don't either introduce text that fails
against the parser or in some other way break the parser. Whether that
validation is done by scripts/kernel-doc or scripts/bpf_helpers_doc.py
doesn't make a big difference to me, other than I have zero experience
with Perl. My first impressions are that the bpf_helpers_doc.py is
providing stricter formatting requirements than what "DOC: " +
kernel-doc would provide, so my baseline inclination would be to keep
those patches to enhance that script and use that for the validation
side (help developers with stronger linting feedback), then use
kernel-doc for the actual html docs generation side, which would help
to satisfy your concern around duplication of the documentation build
systems.

Cheers,
Joe
