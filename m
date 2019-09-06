Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47176AB4E6
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404129AbfIFJcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:32:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40470 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392912AbfIFJcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:32:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id g4so6299499qtq.7;
        Fri, 06 Sep 2019 02:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLWP6NHVSlCxVbIED1XY7sj98JN5gmS0DomSdcvtZ7s=;
        b=opcXYV1d0o/AlbZYXpPJPKF1g+Qg7wMOd5r4EDndIvpNSLjniHPAapb4FI3hXS7ApY
         rIOBITvpgfgEaORp4G80Yj+MNQoV62Df+XSpFTWAiP81iFNDLarlNyh4wd4tQxJflMBR
         DujZu+M1O8p3ULjHZPNHTCCnIAz3UqLkXCRqKv0h+SDmwVGmv8hmfQzknvcL3/DDXet5
         7xrUPDzVR5uEO6Mb6N9xlE9oiJeiOVzFdgEbv1xWfftKdIo58ytZ5Z76tQK3owd27pwP
         74zvUaVBHmcmdMr5D6svhyBHVdPp7blRsTiTY9hY0Pf6mgB7dCAqOHwsTH9I5PcLKt7i
         xd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLWP6NHVSlCxVbIED1XY7sj98JN5gmS0DomSdcvtZ7s=;
        b=LQuW4OjDO4vi9GyMSapVV8mkixds4JWfZP7v6mnO1N8RcK7uocnN96fXbMIDHvD7/7
         EW5D9dcnkVo+O+08uZGJ1TQqGC3G6gvz//iATHcByurj6GoagAz5HEseVNnMY0jAhAcr
         eVtu+BFFZ+DT7QHZT/LWgzzaXzqrZgxVkRsjgxLt/d0gi4LyDFjdXEKdNMsQVLb9LNS/
         Nj5KGeGKwAk6mP5OAoiFde3wmwRh/CNUYwYwXYPqicPURc0vdRrU2oli6IYGgfC6G7NK
         810zvTklQQWJofIof6Bad8JGch0j0le5lFfVgM6Gtait8SOhIkC2nfVsAL85wABt2lQj
         X37Q==
X-Gm-Message-State: APjAAAXkhydOf0XMH0qeeFGQq085p5sH7+cAaWTfFDDArfTrtMVm3+oK
        o1nt4VfWRFmwGtrxvA+mYs1JGc7lHGxxNxo9qAQ=
X-Google-Smtp-Source: APXvYqwkOBbJA908ZAOxlCtMjEN3cMkMp7dOIzjGQtWT4BKY4vBwlMoyBjBRQyhC6QAqXOEGg2Es4HVP/SPR1QzBCD8=
X-Received: by 2002:aed:2726:: with SMTP id n35mr7930949qtd.171.1567762369366;
 Fri, 06 Sep 2019 02:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190904162509.199561-1-sdf@google.com> <20190904230331.ld4zsn4jgldu7l6q@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190904230331.ld4zsn4jgldu7l6q@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Sep 2019 02:32:38 -0700
Message-ID: <CAEf4Bzaoh0Ur6Ze0VLNYqhTJ21Vp6D2NBMkb7yAeseqom=TyKA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] selftests/bpf: move sockopt tests under test_progs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 4:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 04, 2019 at 09:25:03AM -0700, Stanislav Fomichev wrote:
> > Now that test_progs is shaping into more generic test framework,
> > let's convert sockopt tests to it. This requires adding
> > a helper to create and join a cgroup first (test__join_cgroup).
> > Since we already hijack stdout/stderr that shouldn't be
> > a problem (cgroup helpers log to stderr).
> >
> > The rest of the patches just move sockopt tests files under prog_tests/
> > and do the required small adjustments.
>
> Looks good. Thank you for working on it.
> Could you de-verbose setsockopt test a bit?
> #23/32 setsockopt: deny write ctx->retval:OK
> #23/33 setsockopt: deny read ctx->retval:OK
> #23/34 setsockopt: deny writing to ctx->optval:OK
> #23/35 setsockopt: deny writing to ctx->optval_end:OK
> #23/36 setsockopt: allow IP_TOS <= 128:OK
> #23/37 setsockopt: deny IP_TOS > 128:OK
> 37 subtests is a bit too much spam.

If we merged test_btf into test_progs, we'd have >150 subtests, which
would be pretty verbose as well. But the benefit of subtest is that
you can run just that sub-test and debug/verify just it, without all
the rest stuff.

So I'm wondering, if too many lines of default output is the only
problem, should we just not output per-subtest line by default?

>
