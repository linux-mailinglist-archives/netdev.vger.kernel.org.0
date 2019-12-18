Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD019123EE2
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 06:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfLRFWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 00:22:55 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38866 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRFWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 00:22:55 -0500
Received: by mail-qt1-f196.google.com with SMTP id n15so1000611qtp.5;
        Tue, 17 Dec 2019 21:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ng6Q3HDN7Tu8qlJXEbrJWkk5dh68heNprHCqJ1DjbDI=;
        b=Ot9G/o1lFjVjUw8iKWA303GvM/d1ePWP+zOWPgmT/nz00+Ei98TVqBBsxDT1hLobDH
         ZdCQ071VuQH0Rzwjf0lhu3fDxESwvnRQnjIajmzO/u8Yf402DAs9J6XaMmVIsBhF+Bbr
         QvSa55I5BG4bRZtDpYtHDmBTQvKDla8CZoK3L1dwS2f9tsig7szW363z+fi8zSJGb8ys
         yUVhMOan6CZAOR+NHEP/jgurg7viX5nesTuE0JX/qLAhLHICbEVCLUrFWsH7EjhQcowb
         +9NYmlruQjZ1QEzbC5xODDvGPdm07vYksS/vyj+k/QN5ozFYLJ7SIB1YZ893DQc4oPia
         d8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ng6Q3HDN7Tu8qlJXEbrJWkk5dh68heNprHCqJ1DjbDI=;
        b=ht8oBNnhBQtcwN9XbXBOsGfprzydrP8tGzaZ3Kl/BWG90uBn4U2RtM5kBaWtMhJd1E
         7+AE8zSTz52Jm1IR+pPpRWCkwMIZecFEYVdtcUfuwdRmwGEqGOPfggTdUnu7ReHhMMS2
         M9froT0yf8VpVP+qGa0nCK/JYQa3zPve7TsNarRioehHpyMR83ELdiFkMYR9EUnSTRBg
         PY7XhP71GbqEZ1OMeAj8ZTYr0B7wfSHfgUPYQYlcB0S6dU96TSTWYd0E4Hx6kMYyV3Qt
         26KE5fwwXJMj9cKSH5apJafzXpnTcfq+MzII+kVXMFaCf00LiOVHFrYAVLjJ0lvYs+ds
         +h8Q==
X-Gm-Message-State: APjAAAW72zhPgBp4JyxOpi6BhRz+bvBHx6YqB2nd54zyDc3wbUtlRVcy
        lTzuN6JU2nyS4IBIKeZgQJr8EtxKQI4qamwafCw=
X-Google-Smtp-Source: APXvYqy/hFG3npesbFucaROfPlfZ4qfcglKqFQ6KePKJrR1OWjWk9G0aOUJ2rLpc8Ovg9lk1IMt7IOj4rBXnCmJV0P8=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr648045qtu.141.1576646572911;
 Tue, 17 Dec 2019 21:22:52 -0800 (PST)
MIME-Version: 1.0
References: <20191217230038.1562848-1-andriin@fb.com> <20191217230038.1562848-4-andriin@fb.com>
 <20191218030525.lhxuieceglidv3jf@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191218030525.lhxuieceglidv3jf@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Dec 2019 21:22:41 -0800
Message-ID: <CAEf4BzayD4Luv3=LivvJo3XK3+PNhjsd5T0B8p8JJ=T1dQspmg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/3] bpftool: add gen subcommand manpage
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 7:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 17, 2019 at 03:00:38PM -0800, Andrii Nakryiko wrote:
> > Add bpftool-gen.rst describing skeleton on the high level. Also include
> > a small, but complete, example BPF app (BPF side, userspace side, generated
> > skeleton) in example section to demonstrate skeleton API and its usage.
> >
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../bpf/bpftool/Documentation/bpftool-gen.rst | 302 ++++++++++++++++++
>
> Please test it more thoroughly.
>
>   GEN      bpftool-gen.8
> bpftool-gen.rst:244: (ERROR/3) Unexpected indentation.
> bpftool-gen.rst:285: (ERROR/3) Unexpected indentation.

yep, my bad, didn't realize there is Makefile I'm supposed to run...

Fixed those two errors, reStructuredText is strict about code blocks.

>
> Patch 1 probably needs foo(void) instead of just foo().
> I think some compilers warn on it.
>

Added. Also simplified xxx__create_skeleton() a bit.
