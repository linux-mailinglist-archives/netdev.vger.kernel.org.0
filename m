Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83EB1A2ECA
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 07:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgDIFbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 01:31:23 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:41738 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIFbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 01:31:22 -0400
Received: by mail-il1-f195.google.com with SMTP id t6so9096318ilj.8;
        Wed, 08 Apr 2020 22:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i9fLIXUSp9PMnTR1VW9gKNaZd1p/oGp3W/BU0tnDSL4=;
        b=RNJsoIOVIUGSvTNAQ3DBkkDzWUB+lHzjDn9PpWaOVz30hXHpoIjXSGFi/bzd6UelFA
         mc7eQOAFO21+YFPR+Tk4tOarHp9Oh/ozYph0g+bbJxHk7eNmbrpKsFMA2pQelxqcBfWU
         Xbm3DgFmjiPnY3EuhquLoQPzbvQBbn5qQim7ZLWOn4IWcbgLooJ7dR6rymx1juBjWMZs
         USvfVStX17R5iQp5Os1ehbgQJ1I47SOW2+SHYLdgrchukN6J1d4urVdt+mhwRx65Xi61
         S4DwLy1cYa8QWsiLm83pZRtzjjtADncxUIGy5unK5uRFR5UenXigl5ck97KafQdCoLDf
         eESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i9fLIXUSp9PMnTR1VW9gKNaZd1p/oGp3W/BU0tnDSL4=;
        b=VL2JpUHrlqcaH03eITo+HrP8F0meV302XZHQA6zyjzXyqCxJ9BSsK+rF7vV5MXJFpI
         qrP78uHr3HkBEdb2hZ8lhIPqgSDPmeahnzCgUM5y2Nk7okgrH9qnCUFS6N3UqVsho+nI
         vGGGqoBJ3ib7t3RhVD4NaoKVsRO1466U09Y0xxoaOf4KIlEw/iupTNfIXwC9kU3eLuSZ
         2fl9GaMSbUvA+YGrEy2lg4h8bSL0T0gh5tYYVf+vXbkg8OZYJQcQehi/dk86MXK4Yql5
         taByJXCYk9sfHHvn5iGbgRsxfmms9ICO55Rpjq/EmivzVORw3ilEXyLPLjjXL/GBypYG
         Irnw==
X-Gm-Message-State: AGi0PuZ/JOT/1/ISAjnlbcxdTBankheZ26tWNYXzYiycp7K6S0G75OVI
        ISqcqOiK+bZnMsSayK26Btd6KT/8T4G/2CHHOx8=
X-Google-Smtp-Source: APiQypJDUip9PqaZcs25DVe7tBFwutdMUvW4NKqG5PF9UdWYvNeR3vZcAH0CIrfbvTyUYT8wVsvRKZJbiiM9wp6alLE=
X-Received: by 2002:a92:9e99:: with SMTP id s25mr11302828ilk.306.1586410282506;
 Wed, 08 Apr 2020 22:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <1586240904-14176-1-git-send-email-komachi.yoshiki@gmail.com> <CAEf4BzZaMX=xPSkOdggX6kMa_a2eWZws9W0EiJm7Qf1x1sR+cQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZaMX=xPSkOdggX6kMa_a2eWZws9W0EiJm7Qf1x1sR+cQ@mail.gmail.com>
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
Date:   Thu, 9 Apr 2020 14:31:11 +0900
Message-ID: <CAA6waGJNzgtKuNps6QZn39Nx3L0WJD3F0ikgAUh6-6ZWyMchmw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Make bpf/bpf_helpers.h self-contained
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020=E5=B9=B44=E6=9C=887=E6=97=A5(=E7=81=AB) 15:52 Andrii Nakryiko <andrii.=
nakryiko@gmail.com>:
>
> On Mon, Apr 6, 2020 at 11:29 PM Yoshiki Komachi
> <komachi.yoshiki@gmail.com> wrote:
> >
> > I tried to compile a bpf program including bpf_helpers.h, however it
> > resulted in failure as below:
> >
> >   # clang -I./linux/tools/lib/ -I/lib/modules/$(uname -r)/build/include=
/ \
> >     -O2 -Wall -target bpf -emit-llvm -c bpf_prog.c -o bpf_prog.bc
> >   ...
> >   In file included from linux/tools/lib/bpf/bpf_helpers.h:5:
> >   linux/tools/lib/bpf/bpf_helper_defs.h:56:82: error: unknown type name=
 '__u64'
> >   ...
> >
> > This is because bpf_helpers.h depends on linux/types.h and it is not
> > self-contained. This has been like this long time, but since bpf_helper=
s.h
> > was moved from selftests private file to libbpf header file, IMO it
> > should include linux/types.h by itself.
> >
> > Fixes: e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian, t=
racing}.h into libbpf")
> > Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> > ---
> >  tools/lib/bpf/bpf_helpers.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index f69cc208778a..d9288e695eb1 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -2,6 +2,7 @@
> >  #ifndef __BPF_HELPERS__
> >  #define __BPF_HELPERS__
> >
> > +#include <linux/types.h>
> >  #include "bpf_helper_defs.h"
>
> It's actually intentional, so that bpf_helpers.h can be used together
> with auto-generated (from BTF) vmlinux.h (which will have all the
> __u64 and other typedefs).

Thanks for kind comments, and I found out that it=E2=80=99s not wrong but i=
ntentional.

However users (like me) may not be aware of it at this point, because
there is no related statement as far as I know. Instead of my previous
proposal, we should add some comments (e.g., this header needs to
include either auto-generated (from BTF) vmlinux.h or linux/types.h
before using) to bpf_helpers.h header, IMO.

> >
> >  #define __uint(name, val) int (*name)[val]
> > --
> > 2.24.1
> >
