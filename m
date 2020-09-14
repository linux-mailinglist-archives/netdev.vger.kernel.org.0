Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C046726922E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgINQts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgINQtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:49:09 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA64C06174A;
        Mon, 14 Sep 2020 09:49:05 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 60so554270otw.3;
        Mon, 14 Sep 2020 09:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=UQd14MrNI2dVyj4vddZznODKBP6iyEjRBKlOB9SCyyk=;
        b=UMCxcXpXAjG8hUblozlsdUha8qZ5DdK5EIpbUpzMn7h/pUPO9q4EVETWQJcIa1eArC
         v7U9rT2Az2ZMd7HW6AtlZFbXQQCPBD1OyDc3moNmfpzqC86IiNKgjxVnpJAGTlo+5PcI
         zqDSKLRhOxcbsqL5bUK7qXmSjtYy2G08q0QvwKJrj/L7Y7SdhG0x2ZFU7RMBu9WK0AdY
         KFzfgqLSrFl/jOEIGZUDfmuxVieiw+/ZC0Y4QGwL+fdNY2lorcHJzJK4tSUDpDohl2ni
         IIKslabI127orWF5E9GV/spUl8Gp0u50FxUpUNJuI9IJ10nsE+LVYNbGwQJaoBpIcr28
         deXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=UQd14MrNI2dVyj4vddZznODKBP6iyEjRBKlOB9SCyyk=;
        b=Ygsg6ij1LhITM76C/AJQsn1P2RWoofOuXRDRPRC3u94wEJl1tn8NCgvzVfHCSV0ZSb
         1j64bW9jaqv6cgzv3DtaUofPIh7/+nRkB5KJMt1MvQhhvbgZWVIzOunnKqoG/XyLPyU5
         iLuZfx7j1EZEYGvWhkhZqfYk0iubd9v5TABWmzA/8i8eBMlzcOqpgCN7NLkDQ8gnuaT3
         95H8NxqHFj5/E5RiPu8yOKaDDrKc69RihBbjiZ/hB8wqZScnww5owSLgFh4wCjB+sADw
         ZcUf9mjVUs95xkCHkZ8c6w9V0gTXdk9f3aKhTUfS+B+MQw8dji7yttcLiQD7CNZcrqir
         hBUw==
X-Gm-Message-State: AOAM532UrLnJJhQItrPi5eIN9/eBsYmuJzVHU7oyDWUfGGiqvzdQZniD
        ggl5RiPj4SVrcrDe7608j8S/ld7UQ5UyNncchXs=
X-Google-Smtp-Source: ABdhPJwIM19kabeOk22hHOr7fcgPIYMv5Pk2QsP1+3fs9VT6mQUmQfmQ5Twc6vsykAm8VzlVnUGpjbbznX+AOXVocHw=
X-Received: by 2002:a05:6830:110b:: with SMTP id w11mr9253920otq.109.1600102144839;
 Mon, 14 Sep 2020 09:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu> <20200901064302.849-2-w@1wt.eu>
 <b460c51a3fa1473b8289d6030a46abdb@AcuMS.aculab.com> <20200901131623.GB1059@1wt.eu>
 <CANEQ_+Kuw6cxWRBE6NyXkr=8p3W-1f=o1q91ZESeueEnna9fvw@mail.gmail.com>
 <CA+icZUUmQeww+94dVOe1JFFQRkvUYVZP3g2GP+gOsdX4kP4x+A@mail.gmail.com> <20200914162909.GA12439@1wt.eu>
In-Reply-To: <20200914162909.GA12439@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 14 Sep 2020 18:48:53 +0200
Message-ID: <CA+icZUWH_JuGzNPFCpURpt1=Q3rF71bSihQsRUdttgosqnwXvw@mail.gmail.com>
Subject: Re: [PATCH 1/2] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Amit Klein <aksecurity@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        George Spelvin <lkml@sdf.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tytso@mit.edu" <tytso@mit.edu>, Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 6:29 PM Willy Tarreau <w@1wt.eu> wrote:
>
> On Mon, Sep 14, 2020 at 06:16:40PM +0200, Sedat Dilek wrote:
> > On Mon, Sep 14, 2020 at 4:53 PM Amit Klein <aksecurity@gmail.com> wrote:
> > >
> > > Hi
> > >
> > > Is this patch being pushed to any branch? I don't see it deployed anywhere (unless I'm missing something...).
> > >
> >
> > It's here:
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/log/?h=20200901-siphash-noise
>
> By the way I didn't get any feedback from those who initially disagreed
> with the one that was mergd, so for now I'm not doing anything on it
> anymore. I can propose it again for 5.10-rc1 but will not push anymore
> if there's no interest behind it.
>

As a feedback:

Just some minutes ago...
I have booted into Linux v5.9-rc5 with your (above mentioned) patchset
plus some individual mostly Clang related patchset.

While dealing with that topic, there was a "fast random" patchset from
[1] offered in this context.
I am not subscribed to any linux-random mailing-list, but I have this
one included, too.
Unsure, if there was any feedback on this.
With WARN_ALL_UNSEEDED_RANDOM=y it reduces here the number of warnings.

As a use-case I ran this PERF-SESSION...

Link: https://github.com/ClangBuiltLinux/linux/issues/1086#issuecomment-675783804

/home/dileks/bin/perf list | grep prandom_u32 | column -t
random:prandom_u32  [Tracepoint  event]

cd /opt/ltp

echo 0 | tee /proc/sys/kernel/kptr_restrict /proc/sys/kernel/perf_event_paranoid

/home/dileks/bin/perf record -a -g -e random:prandom_u32 ./runltp -f
net.features -s tcp_fastopen
/home/dileks/bin/perf report --no-children --stdio > ./perf-report.txt
/home/dileks/bin/perf script > ./perf-script.txt

echo 1 | tee /proc/sys/kernel/kptr_restrict /proc/sys/kernel/perf_event_paranoid

I was curious (mostly) to see what the impact of tcp_conn_request()
<-> prandom_u32() was and the improvements by the patch from Eric.
I can send the perf-report.txt if desired.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=random/fast
