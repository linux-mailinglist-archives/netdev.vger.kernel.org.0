Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27AC5E108F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 05:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbfJWD3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 23:29:50 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:43537 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730047AbfJWD3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 23:29:50 -0400
Received: by mail-il1-f195.google.com with SMTP id t5so17514524ilh.10;
        Tue, 22 Oct 2019 20:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfLiaBCBu+ssqI8B8vy02/5vORFk0hv2XQ1/X2pqyto=;
        b=XDbFYHPtFUjRkr1AgOaSMj1swoVQU6QyEt1z/v8JjsjdJ+S9aVH2uVFoe5ym5zKBW5
         6NYtAUUF23psCmgcTAjVhrlo9j/zs2QJvH6/wAidky/FCcYr63F8AoSlMECn4h6pzj2c
         awL6PGYehQRuA0fjIE7UI9onJA65xg8t/XQOvGQt1vtkKOl3OWCkzNRNdWm/472/Az7q
         qZaSghejGIEgxM5Nh7+EFrknifA5LotpbYvJBnubzUAWzL8q+q22dfNzboGZK4M/3hLr
         8IreORkiqikkF5v4R/Q7B1Yv6IGhsP2zfjFN/A/LM52KK12LHotY9Sz5EA84RizuPrGk
         977A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfLiaBCBu+ssqI8B8vy02/5vORFk0hv2XQ1/X2pqyto=;
        b=sPn1Pzqs/OwR5huHXTMBUGvWr+/YA6M0yNR4xAe7RMmoodEHxqADDcftT6FL1jVFQL
         0++CJy3jUHv/0Cmf0oF8IOxxdL0KknlfiGoP8zQ+F1JRUV2ld6FqzO2RFtlJJWQPbOE7
         H9jQZnhGCrNdC6Jk4JsGi9TteOYK7mRwQDOFALYumWKE90CEHQgvM1gicgQW688irI6m
         +p7Iwsa3L3k0t9++sPrINnPOAFQ1glpmBHvc4z7+x5CITNafyYSZ4ARHXRzBgORsslhD
         uvg0ZiwUSp+5odZWjck/T3XIsEtA+unAJ1lUk0prxLt+iFXWULf2M5xXNbdSGH0X3XkH
         Osvw==
X-Gm-Message-State: APjAAAVqilQtC3BuFMCtDv5GjcN9HidPojAhvVc2jT03NGDqWwOsxBXO
        x33QBirYrkM4Wd1KkYqWqbGG7EqdO2SvrKKmvJw=
X-Google-Smtp-Source: APXvYqzTQdNzQPv+An5qgw6CDOOFWWZ5CZIs/KiHbhkLGylhO8s4nro9lnE9BWmw62TTd5Bo48NY7KAfDdoIiXsHWfQ=
X-Received: by 2002:a92:c608:: with SMTP id p8mr35183176ilm.10.1571801389499;
 Tue, 22 Oct 2019 20:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com> <6fddbb7c-50e4-2d1f-6f88-1d97107e816f@fb.com>
In-Reply-To: <6fddbb7c-50e4-2d1f-6f88-1d97107e816f@fb.com>
From:   Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Date:   Wed, 23 Oct 2019 08:59:38 +0530
Message-ID: <CAJ2QiJLONfJKdMVGu6J-BHnfNKA3R+ZZWfJV2RNrmUO90LPWPQ@mail.gmail.com>
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
To:     Yonghong Song <yhs@fb.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Yonghong for replying.



On Wed, Oct 23, 2019 at 8:04 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 10/22/19 6:35 PM, Prabhakar Kushwaha wrote:
> >
> >   Adding other mailing list, folks...
> >
> > Hi All,
> >
> > I am trying to build kselftest on Linux-5.4 on ubuntu 18.04. I installed
> > LLVM-9.0.0 and Clang-9.0.0 from below links after following steps from
> > [1] because of discussion [2]
>
> Could you try latest llvm trunk (pre-release 10.0.0)?
> LLVM 9.0.0 has some codes for CORE, but it is not fully supported and
> has some bugs which are only fixed in LLVM 10.0.0. We intend to make
> llvm 10 as the one we claim we have support. Indeed CORE related
> changes are mostly added during 10.0.0 development period.
>

can you please help me the link to download as
"https://prereleases.llvm.org/" does not have LLVM-10.0.0 packages.

--pk
