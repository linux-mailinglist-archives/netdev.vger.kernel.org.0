Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5485B144262
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgAUQp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:45:26 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34885 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAUQpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:45:25 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so4036295wro.2
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 08:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qzZZUh2NrbbLW3DGqGZzI7MJ+6fKqb30zcjn/wosma4=;
        b=XcDt1BFibRymeR5abGJ9hFSUNhqPwyTlrsiFrylnnfMaqLVFJGbwuAe5IZuBmOQbqk
         rSr749lKgSD8xwC7cPg2NgUIRgCdaYLrilzWnRyty7YnIEYl2WwyhXSxX/S9LyIPVEuA
         yGdUrT19tFfh2e+ht/SvH9w24fxapsswCpoYa6BEqtJVBprfVBsXt/vQdlhU61+RVSEx
         GhqZltof0olb4ZhVGNZm7FOLOrwUZjRP+PLoqZOIBFM2T5ELCt1VE/ClFwEYmLDaTTq6
         qMSLPwqTNH/NbqarkTVTNb51VnjyhNg3pbJ39iEYw1pCHtBEmkRhZ0UnAAIQIlJ+K3OL
         TFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qzZZUh2NrbbLW3DGqGZzI7MJ+6fKqb30zcjn/wosma4=;
        b=QqoATofqrc5wGJWoum5AKwPuOlept8x2ey/iExViw5Ne/91fLSrPSvZGoTXYkT+TCk
         Xii0BfMiKc2zNpJiMtnkZOgLHXt85jAZhCZru8Wtt/zP8YudkSaIxRenwdhaleuahdJJ
         p9rG2IqhCSC0DdNPUDgKIlEnaaVj98W8UOCLuTNLcbzMOks5MskomRtfUX0E9GG4v4TJ
         CmtocBkE3lDZgaISmN1bSS3mHWD5AgMf71jgTem/exACi6x1ohUzMuOj2qrBvVbcV1Lf
         eQvoQOc78Wz7olOM1wWuRCqtMZGYhFSdFEmtMEq9JXamZeUdxWm3EIS2XrhlXTd9OsmR
         itcw==
X-Gm-Message-State: APjAAAXM0U4EfIx+I8co4hzKjD3v6IzELmxGHoWbrIyKhs+h95QUGVH8
        e9/MuaCruPtAs6sEXHbUqdPvpi9eOX9WIMwJ/YwbAw==
X-Google-Smtp-Source: APXvYqxFtDk1TwdzzKWYLbNU/MQ0BfD982FTNloa/irZM0onn45eBFpXODSQOJ0x3JcgsXmLjXahUuHk4ZR6rRSvw1Q=
X-Received: by 2002:a5d:534b:: with SMTP id t11mr6062001wrv.120.1579625123475;
 Tue, 21 Jan 2020 08:45:23 -0800 (PST)
MIME-Version: 1.0
References: <20200121141250.26989-1-gautamramk@gmail.com> <20200121141250.26989-6-gautamramk@gmail.com>
 <20200121.153522.1248409324581446114.davem@davemloft.net> <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com>
 <87ftg8bxw6.fsf@toke.dk>
In-Reply-To: <87ftg8bxw6.fsf@toke.dk>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Tue, 21 Jan 2020 22:14:47 +0530
Message-ID: <CAHv+uoETju_JxyLRxSM67KmnCE0Be6LBjB70huOOy3LmGNTWvQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/10] pie: rearrange structure members and
 their initializations
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Dave Taht <dave.taht@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 9:32 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Gautam Ramakrishnan <gautamramk@gmail.com> writes:
>
> > On Tue, Jan 21, 2020 at 8:05 PM David Miller <davem@davemloft.net> wrot=
e:
> >>
> >> From: gautamramk@gmail.com
> >> Date: Tue, 21 Jan 2020 19:42:44 +0530
> >>
> >> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> >> >
> >> > Rearrange the members of the structures such that they appear in
> >> > order of their types. Also, change the order of their
> >> > initializations to match the order in which they appear in the
> >> > structures. This improves the code's readability and consistency.
> >> >
> >> > Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
> >> > Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> >> > Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
> >>
> >> What matters for structure member ordering is dense packing and
> >> grouping commonly-used-together elements for performance.
> >>
> > We shall reorder the variables as per their appearance in the
> > structure and re-submit. Could you elaborate a bit on dense packing?
>
> The compiler will align struct member offsets according to their size,
> adding padding as necessary to achieve this.
> So this struct:
>
> struct s1 {
>        u32 mem32_1;
>        u64 mem64_1;
>        u32 mem32_2;
>        u64 mem64_2;
> };
>
> will have 4 bytes of padding after both mem32_1 and mem32_2, whereas
> this struct:
>
> struct s2 {
>        u64 mem64_1;
>        u32 mem32_1;
>        u32 mem32_2;
>        u64 mem64_2;
> };
>
> won't. So sizeof(struct s1) =3D=3D 32, and sizeof(struct s2) =3D=3D 24, a=
nd we
> say that s2 is densely packed, whereas s1 has holes in it.
>
> The pahole tool is useful to see the layout of compiled structures
> (pahole -C). It will also point out any holes.
>
> -Toke
>

Thanks Toke. Used the pahole tool. There seem to be no
problems with the structures in include/net/pie.h, at least not on
an x86_64 system. We might have to change things in sch_pie.c
and sch_fq_pie.c though.
