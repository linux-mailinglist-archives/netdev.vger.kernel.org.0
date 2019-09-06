Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6ADABE36
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393234AbfIFRCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 13:02:16 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46947 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfIFRCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 13:02:16 -0400
Received: by mail-lf1-f66.google.com with SMTP id t8so5598423lfc.13;
        Fri, 06 Sep 2019 10:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSJtPQwc4FrIdIn1bFWZE5T/k3cdh8UKTtNfZmczf4g=;
        b=OTmQvZcnK0iCDnsELaip34muwYlWJFwcsA7THUU6pGovXF2OzoDwBgA4ee9kibQ+HR
         8mGEpxMlrXnSZ7mPNeUtTvTEsIAgHyvJpq5/RpWE5KOvNNXArFzLXc98UmE3JqcvbXaa
         R9Y6CeTFqGBgYioSfm1stCN/FmtZwHwB54LHCwVAAPDOTPzc8mjJAM+MkV2iC8bEBjZK
         YaDp3oqyrbMePBEET/ZsT65fyybS3qsaHUShcYU2kVG3yUAjND5YyAxhNRZX7EeaVLUr
         GsvWUtqkX11NnndkTDZqF2+HPV10NI7t1er2xfaSbKCqkznGt0vfJiwKGW6e5iiXfXPb
         X1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSJtPQwc4FrIdIn1bFWZE5T/k3cdh8UKTtNfZmczf4g=;
        b=EExyamqqs7sAu2VzJSH6doLHO+D1qKmcV7k1RP2z/+Mmhhy9hB/IfEnQodaVsDtbxx
         XTICd3IubkCCv2xTVnJFqor1WbAOTcn/FivaCovAea3SDb+636snSeet6Y8xU1Zf3dn3
         lrARgpsC/KfXf5DmHC+wzs/6kmkChRx0y+X9gO/5b5PWKrFi1Bc1/OGYNqduTQFZVPWx
         ME8whtuya/8ahPnIvTk3KtnLbkA/eK+JETUKnMEbDSQKAHUMxPg7MRO69Pm09mWYBhob
         OpopDFQYa0LG1/1YGezgcx9jsqrj3jvT3rN4AT6QJzxTb5jGSQZa86t+ZJ64ANGP2QNG
         /Wnw==
X-Gm-Message-State: APjAAAU7ojtLUtg8Z2l4osO+F9wZiq6yQRskRT6n/16ZZQC1iJyqigQF
        9AhNBOZWlYpYSniz0NtbmlS8kit4+iPGcvqiRvk=
X-Google-Smtp-Source: APXvYqyBNLjlyzQhzCYJ7R3Kb2Tml2uNfthnuo1Qdlo+bzwYhOsqQmyV1Ws/aC/ow0vTkrwDqP+se+q8W1085BzCv+A=
X-Received: by 2002:ac2:558a:: with SMTP id v10mr6734254lfg.162.1567789333878;
 Fri, 06 Sep 2019 10:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190904162509.199561-1-sdf@google.com> <20190904230331.ld4zsn4jgldu7l6q@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bzaoh0Ur6Ze0VLNYqhTJ21Vp6D2NBMkb7yAeseqom=TyKA@mail.gmail.com>
 <20190906151808.GD2101@mini-arch> <20190906164233.npuhtaeoezpp2dol@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190906164233.npuhtaeoezpp2dol@ast-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 6 Sep 2019 10:02:02 -0700
Message-ID: <CAADnVQLbp72bCkqjV4RdchYre+Jc7buwE==vJZx_o9LTrnHj3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] selftests/bpf: move sockopt tests under test_progs
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 9:42 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Sep 06, 2019 at 08:18:08AM -0700, Stanislav Fomichev wrote:
> > On 09/06, Andrii Nakryiko wrote:
> > > On Wed, Sep 4, 2019 at 4:03 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Sep 04, 2019 at 09:25:03AM -0700, Stanislav Fomichev wrote:
> > > > > Now that test_progs is shaping into more generic test framework,
> > > > > let's convert sockopt tests to it. This requires adding
> > > > > a helper to create and join a cgroup first (test__join_cgroup).
> > > > > Since we already hijack stdout/stderr that shouldn't be
> > > > > a problem (cgroup helpers log to stderr).
> > > > >
> > > > > The rest of the patches just move sockopt tests files under prog_tests/
> > > > > and do the required small adjustments.
> > > >
> > > > Looks good. Thank you for working on it.
> > > > Could you de-verbose setsockopt test a bit?
> > > > #23/32 setsockopt: deny write ctx->retval:OK
> > > > #23/33 setsockopt: deny read ctx->retval:OK
> > > > #23/34 setsockopt: deny writing to ctx->optval:OK
> > > > #23/35 setsockopt: deny writing to ctx->optval_end:OK
> > > > #23/36 setsockopt: allow IP_TOS <= 128:OK
> > > > #23/37 setsockopt: deny IP_TOS > 128:OK
> > > > 37 subtests is a bit too much spam.
> > >
> > > If we merged test_btf into test_progs, we'd have >150 subtests, which
> > > would be pretty verbose as well. But the benefit of subtest is that
> > > you can run just that sub-test and debug/verify just it, without all
> > > the rest stuff.
> > >
> > > So I'm wondering, if too many lines of default output is the only
> > > problem, should we just not output per-subtest line by default?
> > Ack, we can output per-subtest line if it fails so it's easy to re-run;
> > otherwise, hiding by default sounds good. I'll prepare a v3 sometime
> > today; Alexei, let us know if you disagree.
>
> If the subtests are runnable and useful individually it's good to have
> them as subtests.
> I think in the above I misread them as a sequence of sub-checks that needs
> to happen before actual test result.
> Looking at test_sockopt.c I see that they're separate tests,
> so yeah keep them.
> No need to hide by default or extra flags.
> Let me look at v1 and v2 again...

I applied v1 set. Thanks!
