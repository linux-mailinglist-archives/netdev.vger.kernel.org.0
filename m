Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275F72717F0
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 22:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgITUt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 16:49:28 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59005 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITUt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 16:49:27 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N8XHb-1kWs4J3JmT-014Ptw; Sun, 20 Sep 2020 22:49:23 +0200
Received: by mail-qt1-f182.google.com with SMTP id g3so10564365qtq.10;
        Sun, 20 Sep 2020 13:49:21 -0700 (PDT)
X-Gm-Message-State: AOAM533FAqUmi9ggyBgk95+0qEs9x8sjXEEQE6YM9b/GmWlH5oFml7xM
        tQFQtTWGHBUJ+ZKkulQ0J5mbPHkWHrsIJ3/Vf1A=
X-Google-Smtp-Source: ABdhPJwBXwBil3iRHV11f3BxYsgRD++l69TenwTYSqKgYe+2Dux9TFUrSKvqlq1FFlXpzrttVMSzDz47tEK6RfJnMjg=
X-Received: by 2002:aed:2ce5:: with SMTP id g92mr30020804qtd.204.1600634960428;
 Sun, 20 Sep 2020 13:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org> <20200920180742.GN3421308@ZenIV.linux.org.uk>
 <20200920190159.GT32101@casper.infradead.org> <20200920191031.GQ3421308@ZenIV.linux.org.uk>
 <20200920192259.GU32101@casper.infradead.org> <CALCETrXVtBkxNJcMxf9myaKT9snHKbCWUenKHGRfp8AOtORBPg@mail.gmail.com>
In-Reply-To: <CALCETrXVtBkxNJcMxf9myaKT9snHKbCWUenKHGRfp8AOtORBPg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 20 Sep 2020 22:49:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a37BRFj_qg61gP2oVrjJzBrZ58y1vggeTk_5n55Ou5U2Q@mail.gmail.com>
Message-ID: <CAK8P3a37BRFj_qg61gP2oVrjJzBrZ58y1vggeTk_5n55Ou5U2Q@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
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
X-Provags-ID: V03:K1:CVl0ZST0kq+ZM8bIyVy4buxByYewwVWTGaSQX2cG7S+fxfOLfg4
 3IYQ1WP9vOXA8wRJwMcZrEPB4//duV8Ezeyis3yGi12DLKgs/AttJWnePBnn8Tp2+uaC/ge
 glaUSs0pf4QOVqQCS3dbPqrr+HVUhs3EVO6/ZQWS1fjn9MdptiKjtHzdDpBD3MOE+/lqWn4
 qrZAlLdnkVWlRVBK6p/Xg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:f3fveQ4ykwA=:KAthfX0nOA+uyVgjLJ5kAm
 +/NVDftUAleKVGB39k3aR+WDoJXnKOKr6t0aNGpkuqe7jfEq/uGu2lDt3nAOfF8VCbJPOf4sD
 EgLD/hnHr9RytPu/kIn5l/M3EBZ8RMtiJ1xJQZNflulbXLsBTwNWmmZ8iZ6gB6DuAOUBSBxSC
 t853woJyRuBR5tuswbZynFfuGe33fG3jbhQK7yAXsaw9n7fUE0xDXyYvaZCdUz8xqATZDqjey
 nYZQbfbxA4yMlNPr70CtwEsRXZfZeS1qFqGeT43XWfVwEWJi2jjBUEMh4JhQ21IT5k7O+EobU
 kGGbTkmhquG64kwlsXoOIPQrgEv7h40navwp6Hox2SlcjftISGtvKG5O/CcTZ1vU4HX/HvuHC
 kFKPhyT89sDque3Fz2CYyKS24aoMJMsiee2bPj12K0A1+lSil9cIuWHnhrgHHYwgzFDFNtLC0
 WyJH63cIEgohAbXtU9AmMhBTOAYK2MBtu5WarlG36VJyxmIEXBsEi8AiU6DMZrkNB7rKhw0SH
 g7tVgijFac4tF/ImrUh3277u2SPu3b+aCRqOSlL6ujCW6QJNhZT6bEH0UzrVkMQOPe8RX4mqd
 3Q3/xiTMKfaOWNw4LpD2G3oAnrxTrvMVK64rlvlguG9O2vzugecMZ1ODciPfxq+rXPGyAfJRu
 pLeh2aR8vSevKSlkxmTUYkCNXe8vIwxrPDZQZuIOzVaJqVxHH4NzxwbWjk5IyiiV3590nWd2f
 UB4Gj65iTtx5p/d2Mv52pqinXBPIOrh02+jFufA90d1Pj9Az9vPqOY5Df2zY2LWHaUsBZXxB0
 BqJAswtSXAA97rNNoyP5162ODXNDLV8UHH0m6k/E9vkD8feGqKIjajwGStAE1k0b1BXWEin
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 9:28 PM Andy Lutomirski <luto@kernel.org> wrote:
> On Sun, Sep 20, 2020 at 12:23 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Sun, Sep 20, 2020 at 08:10:31PM +0100, Al Viro wrote:
> > > IMO it's much saner to mark those and refuse to touch them from io_uring...
> >
> > Simpler solution is to remove io_uring from the 32-bit syscall list.
> > If you're a 32-bit process, you don't get to use io_uring.  Would
> > any real users actually care about that?
>
> We could go one step farther and declare that we're done adding *any*
> new compat syscalls :)

Would you also stop adding system calls to native 32-bit systems then?

On memory constrained systems (less than 2GB a.t.m.), there is still a
strong demand for running 32-bit user space, but all of the recent Arm
cores (after Cortex-A55) dropped the ability to run 32-bit kernels, so
that compat mode may eventually become the primary way to run
Linux on cheap embedded systems.

I don't think there is any chance we can realistically take away io_uring
from the 32-bit ABI any more now.

      Arnd
