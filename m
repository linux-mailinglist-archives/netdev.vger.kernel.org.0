Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7D027616B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgIWTxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:53:10 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:49141 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWTxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 15:53:09 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mof1D-1knLhY1WDR-00p1Cg; Wed, 23 Sep 2020 21:53:05 +0200
Received: by mail-qk1-f175.google.com with SMTP id c62so1009747qke.1;
        Wed, 23 Sep 2020 12:53:03 -0700 (PDT)
X-Gm-Message-State: AOAM530ZlfmksSqecWKDQ3DFtZU062m1eW50TJHuAOM1NehNCZNSs1hi
        XGsSJeH6U+rOX7g6WJ5h3KiEI72zgD5M/7gTGgc=
X-Google-Smtp-Source: ABdhPJw80vxbxwT0bQ4Vkw0aE+k6Uuv2/dRNGRP/PGmAg2m3M1syddgA8VQgAKVqDM0S7SkWa6ZTkZVQ5JNt1c0Eq1g=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr1587539qkf.352.1600890783036;
 Wed, 23 Sep 2020 12:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200923060547.16903-1-hch@lst.de> <20200923060547.16903-6-hch@lst.de>
 <20200923142549.GK3421308@ZenIV.linux.org.uk> <20200923143251.GA14062@lst.de>
 <20200923145901.GN3421308@ZenIV.linux.org.uk> <20200923163831.GO3421308@ZenIV.linux.org.uk>
 <CAK8P3a3nkLUOkR+jwz2_2LcYTUTqdVf8JOtZqKWbtEDotNhFZA@mail.gmail.com> <20200923194755.GR3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200923194755.GR3421308@ZenIV.linux.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 23 Sep 2020 21:52:47 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1VPh0ufiUMbcRuj9wrpqojzQ_8mO68Vjc8yzLGxVNkpw@mail.gmail.com>
Message-ID: <CAK8P3a1VPh0ufiUMbcRuj9wrpqojzQ_8mO68Vjc8yzLGxVNkpw@mail.gmail.com>
Subject: Re: [PATCH 5/9] fs: remove various compat readv/writev helpers
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
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
X-Provags-ID: V03:K1:FcOmYEc7S70x327+yC5nQPBEM0rt3a6h0aY4XmvYdCQO/8YHm6L
 kQ4zWoMsMiqUpkNCuPq40vpPiey/pLiaKIbN7QkQudHxc4Jh3awCIgTkZ9zYNjIGusQwsP4
 1f1B0nElrTF0UDKdAoVLxWVksyAkcP1rgW6OWMr1s5U6Ho/SuN3wPdE/qoJwLEFRspiRqUj
 yq6+or7yQpPXAv/J1caXQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WeZ7mFq3nUo=:ejU75HdVaJwErPbl07WyY/
 SzJqUDCrQEJB1WeBXC2y8Ssm/xYmjapzEBN2ahXTydur/hOzj69Kg2Qzgtoc3VNc8XFmw919o
 ESSsgSfQzPzPrlX3MgopJwOnkQ3I4bvWzTa2ZlS7YrZa/AyhvFw4gd4FCpGxRi6WmPfp76f1e
 myF7aStZTXsarPDA2STRNrZOIUYyDueuimX9V2S7rv5BW/onorUna7NOsEwkE7aU0mJt+v0Hl
 HIA6IfIR05QbpoKPI/OpdgJEact/NAJX3zC1ZJXh62ABmy+E/nnChSTV1nsGJIXjNhCuBVdFk
 bQBjXBaT8FGfl83RztO1RmQ3bqsqk8ku9XIaqGrmQ9i5OX6DAQHK7c30Vm+EMZDuan5IKUoxh
 cYHDHFlB37P7T0CXow6euG48MwQQRXwNWG94LigYmIKrGfCNIQ4DHyCeRw1+68wkbtADxLVH8
 CB0nRpMe7rUrmHGpqYNqt8wLM0pJKHM0tsjdDP650XCTmpPS3/NlStYy3mgCJIW9hqkuS7w7A
 GkIBYy2IUu1bbRxzL8ypcn4Cp96IkenTf/tXQXtLAggbQEk+CIKr/QP9S6AMOum8srwv1+VKM
 ORMh1sY7JkDqzxIAYpvgHUPA1mej8HF4555mPWMlPk7ICBIsJDcaGzkmlBgB6B23rbiKuCCsr
 iyC89P2nxjFi+GzaaYFHYRrz399DxPlViaNhzrAVJsWX0gM3VD02wi37/y8AW5K3d0vI6p/7f
 DV1q85DyULmO6ez5MisWBBUBROpFlvx1IghlxiINd/QvCa5H+comengpnbWjgMe/VluZszkB9
 P0Qk+w+vd9NiE3WeN+I42nTS8gMPYeMp7/0S9Nib8gESVnNDFc2shVtY2bhFcaVX6Tkq2thRH
 4RYELGgsPV/p/jHf0yA1sgT5WRYlN6txBoLIeSX9HQ3uUovY6j9F6HIzPfzzcZCcKlkVPUElJ
 DqEhYfcAAh7V0lJVm7vBtu55QYk5+o4wTMvTEFkCyMYNWNypOQGY7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:48 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> FWIW, after playing with that for a while...  Do we really want the
> compat_sys_...() declarations to live in linux/compat.h?  Most of
> the users of that file don't want those; why not move them to
> linux/syscalls.h?

Sure, let's do that. The trend overall is to integrate the compat stuff
more closely into where the native implementation lives, so this
would just follow that trend.

I think with Christoph's latest patches, about half of them are
going away as well.

> Reason: there's a lot more users of linux/compat.h than those of
> linux/syscalls.h - it's pulled by everything in the networking stack,
> for starters...

Right, the network headers pull in almost everything else through
multiple indirect inclusions, anything we can do to reduce that
helps.

     Arnd
