Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4088D6B000
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbfGPTjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:39:47 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37048 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388808AbfGPTjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:39:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so15556747qkl.4;
        Tue, 16 Jul 2019 12:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+cxueJ2GgvizTSViC8kxyOvo5oouUBLRFOwgy5sGeBE=;
        b=k7oglli4eAzx+aZKA/aiODwTM9edbjK1dKDs8hJsMBHykoIRD0GENEvIRuXZv0TpUr
         d+o3AjvFxWyY0PBDRAPIaPIcY1QYD71x5gyrEIK+M/ZlGleps9ni2OqOLWe4wIuclbfe
         GivjEiZhqJgNKcE8TbWC0WXBCMtdaNEvLT49ox6PVDklVFmZo3iFbxSyCNj6WLhQyoPI
         3Agi2v0DxoQsLJmpCvsel+xhb9Q3awfP9TRfhILnWODbepoL8jVbtqKT+ITEQ03usNJ0
         +3Yq3dssejdVjDCGas7wHflpmGgRxaAZjuT1mC1EhyU+KGanpIokj4y/uhVD4F+oR1yO
         OEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+cxueJ2GgvizTSViC8kxyOvo5oouUBLRFOwgy5sGeBE=;
        b=McmyijC0b3nbbHKqlCUTR+9LCYkUrAjiHb4hUGVUQEvgwUGTDxmrqAuyjDoEi7SbOw
         sFOqx+aYMLhYWD2Qa9C4RO+aX5iYX0hx/pLgAhVvb/Kb8Lrs+RC4mXQRr6ZiLpxWDWNQ
         QKC+ja8qFD1ZsSBllJbf7nir2avNzQ3e+WQgz0eiY4VRXKUCS8AseyUSbQO8zFi2w1ka
         Y/McT+B6xwwIuKTuXk/idLhXiJ0tpq8cIcoxr8tQfgfVInANuctnXR2CPaQX45PA8rei
         r/puPrHBYlfN5f92FKkW+xuubb1wFhSfSdmfVTdcPH9i1VvvB7itZ9XVp7A4JTKz2RWv
         UfqA==
X-Gm-Message-State: APjAAAW5vb5YjbSNPiAbPfw2iBL1Or9v8xsIQFKcbf3QKoGErg6RYGUb
        VFTbVQ1l20E+Hu9kdGkSlCp8LGM9+BLDaAkt1dE=
X-Google-Smtp-Source: APXvYqzYOcpQ+P4UensnbQI03bZvF1na6R6BM6HKgwdDozLL0VOr2/MtYablqmyYh2v1jDVrSnwRydWKj8Xkf8DFL34=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr22935790qkj.39.1563305986325;
 Tue, 16 Jul 2019 12:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190712135631.91398-1-iii@linux.ibm.com> <a3823fec-3816-9c38-bb2d-a8391766e64d@iogearbox.net>
 <CAADnVQKzZQ_mbaMHEU6HA-JEy=1jXvBWULg8yKQY_2zwSmU86g@mail.gmail.com>
In-Reply-To: <CAADnVQKzZQ_mbaMHEU6HA-JEy=1jXvBWULg8yKQY_2zwSmU86g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jul 2019 12:39:35 -0700
Message-ID: <CAEf4BzYt9Hstc91ZbC0JtYTPYGivn-1ikfiAriFuJckef6Sdug@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: make directory prerequisites order-only
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        gor@linux.ibm.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 10:49 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jul 15, 2019 at 3:22 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 7/12/19 3:56 PM, Ilya Leoshkevich wrote:
> > > When directories are used as prerequisites in Makefiles, they can cause
> > > a lot of unnecessary rebuilds, because a directory is considered changed
> > > whenever a file in this directory is added, removed or modified.
> > >
> > > If the only thing a target is interested in is the existence of the
> > > directory it depends on, which is the case for selftests/bpf, this
> > > directory should be specified as an order-only prerequisite: it would
> > > still be created in case it does not exist, but it would not trigger a
> > > rebuild of a target in case it's considered changed.
> > >
> > > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> >
> > Applied, thanks!
>
> Hi Ilya,
>
> this commit breaks map_tests.

This change just exposed existing problem with Makefile. Sent out fix.

> To reproduce:
> rm map_tests/tests.h
> make
> tests.h will not be regenerated.
> Please provide a fix asap.
> We cannot ship bpf tree with such failure.
