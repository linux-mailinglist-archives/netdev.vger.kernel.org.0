Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC2510C3B6
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 06:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfK1FZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 00:25:10 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36103 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfK1FZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 00:25:10 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so4366106wma.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 21:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E4dUTlDfQXybQ9vefTQKU74qbm5ETGHdSLQ5wmFDBhQ=;
        b=NDZdmQaSRvWh4AZiqmnlV++OReoy62FNzrJS7ldLWhGVx+OFLOiOsjYbR6RLLqbmu9
         t0TTeDlUYNrED80n0duJyuJWnAn1/Zulr82Mhwq1EX41xeMGnoTWLK3bxr/CDU0cTG7o
         5ENIdooilowJS2JPZ2E+cDO1pCLy2JTxPnT4dp9ezS0mkgZY7cBAXR+KdHeWaKN/IUAa
         ZUaH8nM8CuDhi/dTfB7t2nI9BVgjC4bRSzhTBng0NdxqIFeOdldjt/mVpvslyukzZqxt
         94Q3UODKaFOvrGJUpbPmPHhz8oc6ww6pLhNE4N5pcYkQn+JNCnTcvaP/YAUmnsawN/pC
         ZjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E4dUTlDfQXybQ9vefTQKU74qbm5ETGHdSLQ5wmFDBhQ=;
        b=qrONMcSDPq1Bh03Xf1hZb5n+9tmpK1Y6t2pGr1CZCe7gmaWiKVl/jmNAxAoJN1NXxU
         phGda7QZb38GECTwl0ZlQeSOiCsxhi5dMS7uZgmobxcB1D84rRUMCOKAh3otD5Yoca2G
         cv4HBIBoZ+qUDMg1vedyvATU0cgOsn3nNcD/ZHAX2te/uVh/jN2OUibRVJspKgyvB7Bh
         r14naecqV874jU7cKReOOF3RZPxr7yU85D6D9KNaTkYR8tHLZ6FBB48s351Nh59CnQcm
         0pWFRdJX1TUCfy09IbcpdMn5hpNXj+HXhDwZ/74ACQPRVME9t+xObWpCqEGrs2KUfr+W
         WTrg==
X-Gm-Message-State: APjAAAWVqD+eTwzRRKNAxlBfxwQqPO8sbuvA0s9PGn9NAhlX+QyHV430
        MO5IwEyxEGN+HhSsBDLfUNJrEFXYjnP4tkOYN64=
X-Google-Smtp-Source: APXvYqwI7D3SuN3DUcOAGzPIp0tA3yH1PJc0Hp5rP8GvH11lrOtvcelCRoaJDbt4hCHBFSrPEMFVpKvBLU/VwkZIoVI=
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr7875598wmh.101.1574918706174;
 Wed, 27 Nov 2019 21:25:06 -0800 (PST)
MIME-Version: 1.0
References: <20191127052059.162120-1-brianvv@google.com> <20191127082655.2e914675@hermes.lan>
 <CANP3RGctgy98FsyeHq+aVk2S=N8ndY0Y+qMkZUhTB=26H_Y3Rg@mail.gmail.com> <CAMzD94R4AqjgtqxgpnZ67H6GvQzin1idxj8OjMmOfmruEc9_CQ@mail.gmail.com>
In-Reply-To: <CAMzD94R4AqjgtqxgpnZ67H6GvQzin1idxj8OjMmOfmruEc9_CQ@mail.gmail.com>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Thu, 28 Nov 2019 10:54:29 +0530
Message-ID: <CAHv+uoHM+v3ot4GiL3CJbqUshYkaaumtG6FreHRm5aCDKpbPvg@mail.gmail.com>
Subject: Re: [PATCH iproute2] tc: fix warning in q_pie.c
To:     Brian Vazquez <brianvv@google.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:55 PM Brian Vazquez <brianvv@google.com> wrote:
>
> On Wed, Nov 27, 2019 at 8:44 AM Maciej =C5=BBenczykowski <maze@google.com=
> wrote:
> >
> > > What compiler is this?
> > > The type seems correct already.  The type of double / unsigned long i=
s double.
> > > And the conversion may give different answer.
>
> I don't think this conversion will give a different answer, the
> compiler already change the value from UINT64_MAX to 'UINT64_MAX + 1'
> which is pow of 2 and can be represented precisely in a double.  This
> change is just making that conversion explicit to avoid the warning.

If it helps get rid of the warning on clang, I don't see any issue
with this patch.
The explicit conversion doesn't change the final result at all.
I verified this on GCC 7.4.0 just to be sure.

UINT64_MAX is (2^64 - 1) -- the required value for the calculation.
(double)UINT64_MAX is (2^64) -- the value used by the compiler (in this cas=
e)
regardless of whether the conversion is implicit or explicit. This small ch=
ange
in the required value doesn't affect the precision of the result.


> >
> > Probably some recent version of clang with -Wall.
>
> It's clang 10
>
> >
> > That said, I think the warning/error is correct.
> > UINT64 doesn't fit in double (which is also 64 bits, but includes sign
> > and exponent) - you lose ~13 bits of precision.
> > I'm not aware of a way to (natively) divide a double by a uint64
> > without the loss (not that it really matters since the double doesn't
> > have the requisite precision in the first place).
> >
> > Why do you think the conversion will give a different answer?
> > Isn't this exactly what the compiler will do anyway?
> > It's not like we have long double anymore...
