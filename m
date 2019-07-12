Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2F67430
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfGLR2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:28:41 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40439 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfGLR2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:28:40 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so8866138qtn.7;
        Fri, 12 Jul 2019 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z0i/4VFEZ9qIYYayWluT3KCLnA32sI526RYc47mubSI=;
        b=LZRSKc0Fe6+aRoc3K/AtRrV16L9X+l37/H/RHmu1rLKiNPVoBrWW5gLeRhOz5L7nhg
         sJHA0S8wr9oF6yRup13T9kuR8pmgJfmnUgCnvP4Id4csaldwmWRiwvpYY9S1i1dyEU7i
         4u/TcMnzCaByRj/Vyn5a5PmTKT3Q4WP9soEKUD9Vf6F56I48Ei/zKwpXM7Oat7kHm0h+
         OkX5JhrrMKkg9TLTnkqUWrgP1+3Zt/F7U9TcbHrb0MPi4MtXUtCyxBsZ1cT0nuvnGbRd
         QU/nFFF9CwumW9leI8nuNU5L1SkaiPTfYx8M3NlkpeSg5VJ16GHkn/UZD3vJyTUoPRyF
         aiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z0i/4VFEZ9qIYYayWluT3KCLnA32sI526RYc47mubSI=;
        b=D4fAWguG3tfUjS3cmTonfzuaRmNnZ65iM676YqwMmP10S03yn/g/YglqfAoKwLmU53
         8/NeZpIUmpjS90dP/LhOoagpobswRfeoGNtBHThXyGOIDAIa15W5UwGo85lAmfjIcJ0C
         tDqnYl+HBJfqNoFp4rVmfUhckuDHrm7bMlU3Ec+EDYjP5LOWxhetDjuFh8QkTHTJ3TJ0
         RBM+WFulgA2Aglv6f4RfZaMdr29eb1PRA0VGa36McsTyJyLD45OgDntHcfepQ20dMhji
         oVdwr+kuuGWTYdD2hZEWd6E9vX9St8JzBNtdLBWv0pYngm2MTRyP/q5zZNG0VxxqSwdQ
         5oGw==
X-Gm-Message-State: APjAAAWm4gfIY75lEs4tjptilu6ahfuxKf9WPVtYTyuw99ZY2ZSdemSE
        0fxBe82If6/U6N9KTsRn5BX+53HomAxaazOhGLQ=
X-Google-Smtp-Source: APXvYqxeQ1MSZIBNFS2qFig2sCiWJFyjnu4lNcFqdEbDjNYp+DYNJkzJry4rbxxa5iQA7i+hSs6yju0YB2WE6jhweso=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr7934880qvv.38.1562952519810;
 Fri, 12 Jul 2019 10:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190711142930.68809-1-iii@linux.ibm.com> <20190711142930.68809-2-iii@linux.ibm.com>
 <CAEf4BzYwwqn9ATwPyVcJ8nBQM+rvaFp7KBFjqbYY4GKda3G8jA@mail.gmail.com> <6E5C9DDE-FF1D-4BFA-813E-7A0C3232B5F0@linux.ibm.com>
In-Reply-To: <6E5C9DDE-FF1D-4BFA-813E-7A0C3232B5F0@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 10:28:28 -0700
Message-ID: <CAEf4BzaHpA6fQVoCza+qw3m-h9CLGiExyRzpsd-AbUC1S2__1A@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/4] selftests/bpf: compile progs with -D__TARGET_ARCH_$(SRCARCH)
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 2:00 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> > Am 12.07.2019 um 02:53 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.com>:
> >
> > On Thu, Jul 11, 2019 at 7:32 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> >>
> >> This opens up the possibility of accessing registers in an
> >> arch-independent way.
> >>
> >> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> >> ---
> >> tools/testing/selftests/bpf/Makefile | 4 +++-
> >> 1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> >> index 2620406a53ec..ad84450e4ab8 100644
> >> --- a/tools/testing/selftests/bpf/Makefile
> >> +++ b/tools/testing/selftests/bpf/Makefile
> >> @@ -1,4 +1,5 @@
> >> # SPDX-License-Identifier: GPL-2.0
> >> +include ../../../scripts/Makefile.arch
> >>
> >> LIBDIR := ../../../lib
> >> BPFDIR := $(LIBDIR)/bpf
> >> @@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
> >>
> >> CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
> >>              $(CLANG_SYS_INCLUDES) \
> >> -             -Wno-compare-distinct-pointer-types
> >> +             -Wno-compare-distinct-pointer-types \
> >> +             -D__TARGET_ARCH_$(SRCARCH)
> >
> > samples/bpf/Makefile uses $(ARCH), why does it work for samples?
> > Should we update samples/bpf/Makefile as well?
>
> I believe that in common cases both are okay, but judging by
> linux:Makefile and linux:tools/scripts/Makefile.arch, one could use e.g.
> ARCH=i686, and that would be converted to SRCARCH=x86. So IMHO SRCARCH
> is safer, and we should change bpf/samples/Makefile. I could send a
> patch separately.

Yeah, let's do that then, thanks!
