Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9373CCBFF
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbfJESYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:24:46 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45685 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387486AbfJESYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:24:46 -0400
Received: by mail-qt1-f193.google.com with SMTP id c21so13330777qtj.12;
        Sat, 05 Oct 2019 11:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xBG8csLHdWLZa/9fnq0t3Giy1lbj4du9KpSdXIUyiS8=;
        b=sbPhFyKLL01SUKlLEe/E3ZgPudxoBAa6LMHr5Qza3OUpfUbPOMgzl9y5PotlvIVfQw
         bGpJTVjJ2pyfEMrdxSJsdLfypk3Qeov8Q1ekB19JLCe3gqd/fCt9cObGYce/aYamGgBT
         ToEPkr/PvHCNMCIjeiUsUlU5xP2cc7xrW4RrWFRQeuXWxBfzcTaCzA6OnG7dQOxUtR8n
         pat5y2g0qZiLE+V5q1ZIISdSXTW1Ou8C+CSfzpPjpRB3GegmC3elD+OFy7eoSTdoA2db
         xn0jWXlFxYNAS66QYu4qhufVsxZUeOYznBmjIRrFUw2Vy3QouHMtLhSeqV12HXDlVASj
         33yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xBG8csLHdWLZa/9fnq0t3Giy1lbj4du9KpSdXIUyiS8=;
        b=udJDizay09JfRusKy5ZvV8wkjJyQXweTh3NTuxvHbT5No0bs7vWfzPTPlHsNKnQeU6
         tHVq0Woh4YV9Q8iEErPKKjaYSiVWbVQasHZGwH/wFJVw4P0H88F0ns4mSAafS6woPtU9
         s49GAZ80zzliZQw8xsqWSL2U7ZAdquRN2AXnZ+OFfEZiIL619Fbdj9Za0O4Wd/LV60Z3
         HPpvoDiC8bpEcbWzBa2vOAC6+6xDSoyZ0ZYoaSS8nZMOHotYXBge5OrbM0zUOB/RXEhY
         6IReqlOkzlPvmshCgORllXmJdWYjDNQ5ZB8wEEjZ4UGAxkq/2DdKykONtojFUjrMMJc5
         FuNQ==
X-Gm-Message-State: APjAAAX+GSzy8fC8CGKrbpcWrvCkdaRkht5rqPkiGkD9gQQs71dyhCZM
        dQqeCRVb/kq5uvfqpObLKVxSuQjLU8YUe6z1LDP3nsGZ
X-Google-Smtp-Source: APXvYqzej2RpaNDfzeAaW8XsIJABw/6s2A4hjhcA+7flDYWYn26FGy1AU4dXQJcnsmX0DcD7Y4Q1yFrdES4T1s8t4vc=
X-Received: by 2002:aed:2726:: with SMTP id n35mr21956452qtd.171.1570299885083;
 Sat, 05 Oct 2019 11:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191005075921.3310139-1-andriin@fb.com> <20191005075921.3310139-4-andriin@fb.com>
 <b0df96f6-dc41-8baf-baa3-e98da94c54b7@fb.com>
In-Reply-To: <b0df96f6-dc41-8baf-baa3-e98da94c54b7@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 11:24:33 -0700
Message-ID: <CAEf4BzZdhBTovTfv+Ar0En__RmuP6Lr=RWF2ix3uo9hZ84oHcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 10:10 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/5/19 12:59 AM, Andrii Nakryiko wrote:
> > Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> > auto-generate it into bpf_helpers_defs.h, which is now included from
> > bpf_helpers.h.
> >
> > Suggested-by: Alexei Starovoitov<ast@fb.com>
> > Signed-off-by: Andrii Nakryiko<andriin@fb.com>
> > ---
> >   tools/lib/bpf/Makefile           |    8 +-
> >   tools/lib/bpf/bpf_helpers.h      |  264 +--
> >   tools/lib/bpf/bpf_helpers_defs.h | 2677 ++++++++++++++++++++++++++++++
> >   3 files changed, 2685 insertions(+), 264 deletions(-)
> >   create mode 100644 tools/lib/bpf/bpf_helpers_defs.h
>
> Approach looks good to me.
> imo that's better than messing with macros.
>
> Using bpf_helpers_doc.py as part of build will help man pages too.
> I think we were sloppy documenting helpers, since only Quentin
> was running that script regularly.

Yep, I agree, I had to fix few things, as well as (char *) vs (void *)
vs (__u8 *) differences were causing some extra warnings.
Please check the list of type translations whether they make sense.

>
> Only question is what is the reason to commit generated .h into git?

So originally I didn't want to depend on system UAPI headers during
Github build. But now I recalled that we do have latest UAPI synced
into Github's include/ subdir, so that's not an obstacle really. We'll
just need to re-license bpf_helpers_doc.py (I don't think Quentin will
mind) and start syncing it to Github (not a big deal at all).

There is still a benefit in having it checked in: easy to spot if
script does something wrong and double-check the changes (after
initial big commit, of course).

If you think that's not reason enough, let me know and I can drop it in v2.
