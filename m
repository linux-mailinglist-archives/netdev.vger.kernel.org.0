Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C25246E71
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 07:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfFOFRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 01:17:08 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38060 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfFOFRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 01:17:07 -0400
Received: by mail-lf1-f68.google.com with SMTP id b11so3078989lfa.5;
        Fri, 14 Jun 2019 22:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWRhLmpBbC3Bwa+dd84M6pBEnObbFDBtYhQXVaEn1qs=;
        b=anHHBk5OSmRogUlK1HOP2vd2EEiFh6loSjqPKIoeElbSG/l6W/6mPXn+XOWMJteTu1
         9ga6vLgnNsKjTukkzxv13+NKexWjC8/JLsBQ7TRivf1MtZjWnlTTNnjBPGhOIpOwX0fA
         wKIGcgFonecx04LhtpWn3NlQTrReZXLLYNGlSfG6zrWrUUfNUsLlwlocALJkCtQHkGId
         hmvWVfFzx92whZgyqfS9JXhuiVNQmb0AeSEDLe4ayTtNeELkJRdKUvJCm9EKWwECFnPq
         UpDhscrlUVsZbPUufRWTARJQvMBWWNltqUHFrH/Eudiqs0kdJtGdQ+7RevHPGIorMKKm
         shWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWRhLmpBbC3Bwa+dd84M6pBEnObbFDBtYhQXVaEn1qs=;
        b=jEgPJTCRYhZsVSD3JrD7QC8QvbhvXI/8ryNu/5E3+fXi3VWzjCtsjk/HH7CrWOFHmJ
         eIROeZt7ILr5926Ng3F0gwtwpeMnAZEZXpCM0H+E8URaJRZJz4eDQEbiEagDDzrBFCop
         hwGEeF2gvCzyr5i6clq3Z1uWyQWXOfxFv/8cpLKIdWPakXLDzQJ42/htfnSAv8ClqgwD
         QKjMTRdRXatBoC0aoUxrf8/c8Ryu65kSD9AxphjaMQJElGoEluhv79ljC3lJQsaLv5Id
         J5FaTh7u2ZP1CGQu8gcaFzV33VFohgakCOa61rjCSnKg9xuc0Eee18tLy4xBuG2xr9Kv
         GXDg==
X-Gm-Message-State: APjAAAXcpVUIvVNXU0LXdeAousild630z/xqbQ7/4pp9Ci5Mmp2hRcVW
        2mJ8zxPK+cnI9HLnEWwDABBqA0elgZhURMJpd/Y=
X-Google-Smtp-Source: APXvYqwWjUYlTpIfM2o3hOyDyGjre3lFXP1VpxqxCz1KsvZ9/Iub9UPvQwGApybJrggex8HEFqdRQhz2gsgonVaKCQ8=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr10006593lfh.15.1560575825177;
 Fri, 14 Jun 2019 22:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560534694.git.jpoimboe@redhat.com> <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
 <20190614211916.jnxakyfwilcv6r57@treble> <CAADnVQJ0dmxYTnaQC1UiSo7MhcTy2KRWJWJKw4jyxFWby-JgRg@mail.gmail.com>
 <20190614231311.gfeb47rpjoholuov@treble> <CAADnVQKOjvhpMQqjHvF-oX2U99WRCi+repgqmt6hiSObovxoaQ@mail.gmail.com>
 <20190614235417.7oagddee75xo7otp@treble> <CAADnVQ+mjtgZExhtKDu6bbaVSHUfOYb=XeJodPB5+WdjtLYvCA@mail.gmail.com>
 <20190615042747.awyy4djqe6vfmles@treble>
In-Reply-To: <20190615042747.awyy4djqe6vfmles@treble>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 14 Jun 2019 22:16:53 -0700
Message-ID: <CAADnVQJV6Yb9EyXE+NG6Nd1KLhhoF2Nr6BN=fihYnW7H0cvRoQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 9:27 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Jun 14, 2019 at 05:02:36PM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 14, 2019 at 4:54 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > The previous patch you posted has my patch description, push/pop and
> > > comment changes, with no credit:
> > >
> > > https://lkml.kernel.org/r/20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com
> >
> > I'm sorry for reusing one sentence from your commit log and
> > not realizing you want credit for that.
> > Will not happen again.
>
> Um.  What are you talking about?  The entire patch was clearly derived
> from mine.  Not just "one sentence from your commit log".  The title,
> the pushes/pops in the prologue/epilogue, the removal of the
> "ebpf_from_cbpf" argument, the code spacing, and some of the non trivial
> comment changes were the same.
>
> > I also suggest you never touch anything bpf related.
> > Just to avoid this credit claims and threads like this one.
>
> Wth.  I made a simple request for credit.  Anybody can see the patch was
> derived from mine.  It's not like I really care.  It's just basic human
> decency.

derived? do you really think so ?
Please fix your orc stuff that is still broken.
Human decency is fixing stuff that you're responsible for.
Your commit d15d356887e7 on April 23 broke stack traces.
And we reported it 3 weeks ago.
Yet instead of fixing it you kept arguing about JIT frame pointers
that is orthogonal issue and was in this state for the last 2 years.
