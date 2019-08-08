Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF78686A91
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbfHHT2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:28:44 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45695 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfHHT2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:28:44 -0400
Received: by mail-yb1-f193.google.com with SMTP id s41so12372736ybe.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEA38hARLo4SuT5GCZPzTtdySvuM017Qa0pF++XwdV8=;
        b=r6LEmxzm3OtAanowl1SIgfTe/QEftawdCk0MD8u0Y9GLT9b+KQIm9TBFwWVFY++6Di
         CVm6xoxR1re7mLEXkQGSn59ptYqKL6pY5aKH8Oq8oCmuk0FMlStUP5aKTGrIFTdu2InR
         cEM6uT5lb1QS+HtTTsfh1zJFfmcAusNA6HlNR0fSVQ0H5lVMvHhUOL3+hNmbFwx3em/U
         8HppZXH4eA2garzMpEOqgvvVgWbfNEu0eNX0n7CkYm5Zj4Wi63Dv3lSU/g0GANmwTOOH
         ZjfQ+ddCcS2vcmZdMOibWHWycr/v3uAq92Xw+3qfw/oLyzEDOq7p6H7MjhxvgJcOmfcW
         LmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEA38hARLo4SuT5GCZPzTtdySvuM017Qa0pF++XwdV8=;
        b=As0xEgHv5q2ck/brqb6UfP9mNLS8OPnaeeHcktYva9u9lckj7cB2LLX1dlTd46oZAs
         tr/XL6UbaXy2ioxj0cyfGTQon31jdSuBUL/8unhKmu/G7RoeNs17xq+KxmyfpClVyva9
         ZUloh0M41e5WR6+60S4chL1seE6Mf2UiAvzF/jyEoh/6cNUdI68HfimmYVT8mnU8a/gZ
         ah6Of9dqJpyhq0ermX2h3dmpuggV1DKCjuYofYX18QG6Ib54HRqkv51dUg1kx6pgFNyQ
         H1HzjIGCIz2xy9qdlCgvLRtD2emov4R757XCFqX6Pu0+qTE/Vc/JPfNyu12a2YBJPhLA
         sjqg==
X-Gm-Message-State: APjAAAVCzVOMOp62cwq8p5xhPV9wYIPdOtgyGjB1suwNz/iYrxGPFpd+
        GiUXFyUuICnlHnLkiztIPHks/uGG7HYXMKik9w==
X-Google-Smtp-Source: APXvYqy9Ex52zGlHxdEP1GmRjit5t5IsEN55bQJbm+RLE+ilGcyTJV93iLd/bMY8JAwDfO+TUHdWFOiW2o2m4F0pLt8=
X-Received: by 2002:a5b:d08:: with SMTP id y8mr11125134ybp.464.1565292523316;
 Thu, 08 Aug 2019 12:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190807022509.4214-1-danieltimlee@gmail.com> <20190807022509.4214-4-danieltimlee@gmail.com>
 <5cd88036-8682-8d26-b795-caf96e1e883f@netronome.com>
In-Reply-To: <5cd88036-8682-8d26-b795-caf96e1e883f@netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 9 Aug 2019 04:28:32 +0900
Message-ID: <CAEKGpzgOEG0yi4vXFf23vVSAWwttJQpni-Cg+iD7ORHrbSitiA@mail.gmail.com>
Subject: Re: [v3,3/4] tools: bpftool: add bash-completion for net attach/detach
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 1:48 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-08-07 11:25 UTC+0900 ~ Daniel T. Lee <danieltimlee@gmail.com>
> > This commit adds bash-completion for new "net attach/detach"
> > subcommand for attaching XDP program on interface.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  tools/bpf/bpftool/bash-completion/bpftool | 64 +++++++++++++++++++----
> >  1 file changed, 55 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> > index c8f42e1fcbc9..1d81cb09d478 100644
> > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > @@ -201,6 +201,10 @@ _bpftool()
> >              _bpftool_get_prog_tags
> >              return 0
> >              ;;
> > +        dev)
> > +            _sysfs_get_netdevs
> > +            return 0
> > +            ;;
>
> Makes sense to have this for "dev", thanks! But it seems you missed one
> place where it was used, for "bpftool feature probe" (We have "[[ $prev
> == "dev" ]] && _sysfs_get_netdevs && return 0"). Could you also remove
> that one please?
>
> Other than this looks good, thanks:
>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

My bad. Thanks for letting me know.
I'll update it with the next version of patch.

Thank you for your review.
I really appreciate it.
