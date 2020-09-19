Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B29271099
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgISVQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:16:35 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:35227 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:16:32 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MKbc4-1k3BIm3TWm-00L0SP; Sat, 19 Sep 2020 23:16:29 +0200
Received: by mail-qk1-f169.google.com with SMTP id v123so10707353qkd.9;
        Sat, 19 Sep 2020 14:16:27 -0700 (PDT)
X-Gm-Message-State: AOAM531+emzl8B3DqL41Bk83MYXpOUqzqfDVocNDlNc7kY058mjTM2a4
        CmAubHAtnd4y0KjZA2ijcOrze8TZs8thcCm6Bsc=
X-Google-Smtp-Source: ABdhPJzEvevcaGdjT3rDawI+GUfFFyk1d/TYHLiGAQUL5WydIguceSQ8UIqVNU/fh2JOVxE549L743HO0rSqi5ww2Ew=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr40303905qkf.352.1600550186478;
 Sat, 19 Sep 2020 14:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200918134012.GY3421308@ZenIV.linux.org.uk> <20200918134406.GA17064@lst.de>
 <20200918135822.GZ3421308@ZenIV.linux.org.uk> <20200918151615.GA23432@lst.de> <CALCETrW=BzodXeTAjSvpCoUQoL+MKaKPEeSTRWnB=-C9jMotbQ@mail.gmail.com>
In-Reply-To: <CALCETrW=BzodXeTAjSvpCoUQoL+MKaKPEeSTRWnB=-C9jMotbQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 19 Sep 2020 23:16:10 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
Message-ID: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:wnNAt0YQaQqE+S7E2jXWhut4vc34wb69sEYYMS2LRgo37wnXoFa
 U5jNY34Mhb6zCLv7UZrXPhqOwTPEKPsdRpRBIsvUzI4lCW8zNqTUwVGGBSMe9Sn/rqP+0Hc
 ZE2V2uxGuYnfv74AcslE8K94pghU8VDghg11No6WQ4CDmZQjGTkgwAwxRTd79ToUMk2jbhY
 GAHuppk5TR0x8YjxOHq4w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sCszT6SAIfU=:EMbLDFo/4IQYxLPBQi+idh
 b6TytVGhby0fIjgUjRLtGhNalYCQqk0iEjqjSgeP94XpxR9jGaqDAi1Y0Gb7/bSKG2rXCgoHb
 Z80PODNcCqbXF9+DPY1M/dBSDA5WoqExxfMy34LEfOCijEHlQC1fgWoKJN+l9eS0XzuFzSLOQ
 yPa4Q5en6gDbFGquLyeS0PP9fr9c0co9EcOvX0Un9vPckFT23e2cxKfuzJ8WVC4zFscR8dA3L
 MTJ7XiQLdddcaDSNzS+2SC4v2pUdXTjHjSTdTWboqKbPnr16LNoZ11YSxAOXZN8UghZLxs8p2
 RuTiyjItuzhEhNkPbbQmJJ9+aHAcQgVHg6Jy2nKsUA+d54zxL2f4XolSOVcKSktt/a+pggVYn
 36dCvpjFvkbouzb/D9GOvY3Rs6Yu7rFIjjy9Nz0bxaox2iRB9lswOkbrQBfEuDbBizwWp4xLO
 nVphyraUcdFX0eqhlEICFjqe5GFTy3hHDfNgnadgMIIY1j0vBUXzZqcPXlp3ja1EmtwumlpGK
 K+VcW/HaKszRxVibxSKg8aObdVYiYIkK2uXoxcQ2jUHetnZlWR7bifWQmPrRndlCG1xY3sYd0
 Nq7pPhdm9mNCuy5pmZITSDP2d3RpX92bo14P6qA7ms9a3PTfrrOC9HjQAiBXlpjn5cMHGU331
 1Cu0H/rzXbq2dK8QgF+X0qIkU/IcqX5nN/ZsuRF6BWFDJRQoGTDVB2qIa8xk/AZVSsGFMZ9Sz
 XtuObu2/qhC1DdRkg3oWrPs1udblQvJZH9D911HFE7TrE9cCuc/X+ezFIwxec/yr2ZvhSl/fX
 WyPaO4XwWbnjQeuaaWmPic1FLY0vdTePBjBHJjlO7kq3bre409ZX7yzUcZ4eezydOp4oRcd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 6:21 PM Andy Lutomirski <luto@kernel.org> wrote:
> On Fri, Sep 18, 2020 at 8:16 AM Christoph Hellwig <hch@lst.de> wrote:
> > On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> > > Said that, why not provide a variant that would take an explicit
> > > "is it compat" argument and use it there?  And have the normal
> > > one pass in_compat_syscall() to that...
> >
> > That would help to not introduce a regression with this series yes.
> > But it wouldn't fix existing bugs when io_uring is used to access
> > read or write methods that use in_compat_syscall().  One example that
> > I recently ran into is drivers/scsi/sg.c.

Ah, so reading /dev/input/event* would suffer from the same issue,
and that one would in fact be broken by your patch in the hypothetical
case that someone tried to use io_uring to read /dev/input/event on x32...

For reference, I checked the socket timestamp handling that has a
number of corner cases with time32/time64 formats in compat mode,
but none of those appear to be affected by the problem.

> Aside from the potentially nasty use of per-task variables, one thing
> I don't like about PF_FORCE_COMPAT is that it's one-way.  If we're
> going to have a generic mechanism for this, shouldn't we allow a full
> override of the syscall arch instead of just allowing forcing compat
> so that a compat syscall can do a non-compat operation?

The only reason it's needed here is that the caller is in a kernel
thread rather than a system call. Are there any possible scenarios
where one would actually need the opposite?

       Arnd
