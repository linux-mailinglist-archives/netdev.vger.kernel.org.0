Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266A32714B3
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgITN4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 09:56:11 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:46411 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbgITN4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 09:56:09 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MMoOy-1k1Dwv2q28-00Ijbf; Sun, 20 Sep 2020 15:56:05 +0200
Received: by mail-qk1-f179.google.com with SMTP id w16so12205786qkj.7;
        Sun, 20 Sep 2020 06:56:04 -0700 (PDT)
X-Gm-Message-State: AOAM533+Tg7GsRoHCgP40ir59ld5C/1Vm0N7+PC3SG26gIqEIleq3ONH
        fksm3LFFVG+V0/cydp/yoybdjQO0QWCzFdtRnVg=
X-Google-Smtp-Source: ABdhPJwjhkL3KLtOGKzNMPo/as4noBlQ9Jb8z4PXaKINeNIOOA3tWOtTq+bHeowiwT9kTTVa6K2ILOsBaWuTHLMSx30=
X-Received: by 2002:a37:a495:: with SMTP id n143mr41151530qke.394.1600610163343;
 Sun, 20 Sep 2020 06:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200918134012.GY3421308@ZenIV.linux.org.uk> <20200918134406.GA17064@lst.de>
 <20200918135822.GZ3421308@ZenIV.linux.org.uk> <20200918151615.GA23432@lst.de> <20200919220920.GI3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200919220920.GI3421308@ZenIV.linux.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 20 Sep 2020 15:55:47 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3QApj3isPu3TkLahArsfb5jaABb7DJ7EKMxey1T1YPbA@mail.gmail.com>
Message-ID: <CAK8P3a3QApj3isPu3TkLahArsfb5jaABb7DJ7EKMxey1T1YPbA@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:DEeFGJUPrk6u/LSjSFLEBpcAP+oeK32PoUjTZYC6fPIs6n+k1mv
 XDMz6XlgCh1Nyx4j17+27me+L64NgDjpVdd7dXJCFrjon/aTAyIu+oh95nm9X9KaWl6wa9w
 jNEmllGRXAiSS7LrTZQ8rS4tQWtbNU8yEqoB7YoTh84C0NTdLZyWEaqn7c0+w0xlPbaxYu4
 ur3P1v08FrYIfJVpNVfUg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6mkBVY6Bong=:SqXPt0trLeYLMHgx1cvXuJ
 U5p4iiPSwCCzF8iboycWFBfO05sNkLPSd9pwnBrqqztOBcPkNasCWa49qwp+g4/XCsXhPAeIp
 ZEo2wIs2JuHkQHCsr1J07cwiEuu+Jpl8XT2iP7S5i5y3yZeYsvvpW+zjEoGvo0lUUzt50b+DF
 d+etXRDTAS4MI0KZwR66GwCASGNxKnFcidiAQ7uHqKF4jBCdVZRVVC3unjWR/zDQrf1UsSGl5
 yiA+FMkQ1meD61zxEhK4DYTj39EHaC1fCYgevYfr50bwM5KeXfxunkJdrXZB40zmP6hwiP8U7
 ZAYUI2x6IdnJZ7j005UTxSUKkFfiSfHKfIcRoNLVxmyXZFSZpZv1lHhqR5Lc7mlnrYMV7yfwX
 jEWPWgGYdVS/0Pqp4mDctdka7FBBmnDQpnQCFWndo9r29o5kZmF/0FWZTAYaiXIc1zXQ0CNGs
 ITo99AkK8c2i8ikDCjq3PgczN6CdTTM3aiqzqHKeSvyXfbkvI1hCX/5ydNZHKVZf8msKr2S8H
 vq/kWx12tz5+znGWLFrLlf7992gz4tbGhg+ohl2KdxHhWBaLbGq7B7TrxKF2dX7bnaN+L5Zp/
 vJ8JYq605hJO1se4r8NW3ew1++WG531E7DL/6Lx0YnzfRjxiToXb8Pg4KnyC0djlxEMEwUAlv
 CmSJKACAV0HY6EMSYJ8+oWpo6MOxbBfBPrBaLdo9nEybAZsqUhO7gMBhw4FLPWxPNJ4TahNDG
 ZB13aOM7zMIaLy9bXTcJUkAShP8ZyjBNl+F3C7ClxLkP593ksjcwF70rTpIg8nnqaoxY/0Dee
 smdON9VOaGsvyMjHBc085FK8V3s316O5YhVW2qcAg2UzaNBdL/34eax1MABsisTpCdIrIGW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 12:09 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 18, 2020 at 05:16:15PM +0200, Christoph Hellwig wrote:
> > On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> > > Said that, why not provide a variant that would take an explicit
> > > "is it compat" argument and use it there?  And have the normal
> > > one pass in_compat_syscall() to that...
> >
> > That would help to not introduce a regression with this series yes.
> > But it wouldn't fix existing bugs when io_uring is used to access
> > read or write methods that use in_compat_syscall().  One example that
> > I recently ran into is drivers/scsi/sg.c.
>
> So screw such read/write methods - don't use them with io_uring.
> That, BTW, is one of the reasons I'm sceptical about burying the
> decisions deep into the callchain - we don't _want_ different
> data layouts on read/write depending upon the 32bit vs. 64bit
> caller, let alone the pointer-chasing garbage that is /dev/sg.

Would it be too late to limit what kind of file descriptors we allow
io_uring to read/write on?

If io_uring can get changed to return -EINVAL on trying to
read/write something other than S_IFREG file descriptors,
that particular problem space gets a lot simpler, but this
is of course only possible if nobody actually relies on it yet.

      Arnd
