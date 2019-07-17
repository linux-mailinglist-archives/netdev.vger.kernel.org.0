Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5058E6B36F
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 03:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfGQBgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 21:36:09 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45807 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfGQBgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 21:36:09 -0400
Received: by mail-lj1-f195.google.com with SMTP id m23so21851466lje.12;
        Tue, 16 Jul 2019 18:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qWO940pMJO4ZymWj5Lb7uIRr1s/46e+FeEyw+BZ1KrQ=;
        b=rM956dfhNiUfnI6x3mNUjAp19DwuSqYBCXebjUx36tROXnICbcajZ0F4WWdDs/u4P8
         QkYoWtvQcmDIMUOWE2IZIAWsRYokDYZHXiscRHl15VmJdT9T8pHuP0J+vI84Cy2vTsWU
         KVVO5JzPbmPzzBuM2HkvR7epHTX0HZvlVb2RsdkEA8n+UtGO/d7ncHfKR/P5xLPaHqyP
         kxoqJTt0AtQKgNJpCWhA///DpF6QXXO7t7cqH/qxlFnORmynH0pvCK91opipUr1xlHms
         jaDtGvjxSOvMrq+P5uAbvWNwb6XCAycA5OqznknghUIX2trqIw7nCgEFglR5FdIOnim1
         SCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qWO940pMJO4ZymWj5Lb7uIRr1s/46e+FeEyw+BZ1KrQ=;
        b=ZRN+hU8EOB+3uRQgXQKKR+DZxQfMHLm2OCDMjLmAk8GuMbYDzbFAZKZ4Og8quDRzQt
         4CCgMJxBr+zRGkBty/FpIdaHqTveinF/TI1mLaZy0Leoq5Ld3dJgu4+QlGTpXWwXWQaa
         TbToKSiPDZRw09B+16TEoQl0+1eQWKmYc7cNHrdUxZNPY9b6QKT5bgj1CATi5T1l/jrW
         YwmvUHHMz7DY6QugEZIDR2vf6FrTUBkDSlKNmoAOE03YIj4VQ9kVlXSBQXWaB9WVN8tC
         mv/BKtaisxJNAvD9Fd22U1ru79/f41k8Vuh4nl34s4BJY76geGec5cvNcmcuDPDZu27H
         8ITw==
X-Gm-Message-State: APjAAAXgVR3X/OuVLit/q+cu6r5uo/VdkaZWHyHQMwItx5otIO+pg29s
        Ay0Ps4rBtphUZ7ydg8o1T42/lAEUeco2xJXV0qg=
X-Google-Smtp-Source: APXvYqwjmBPeJyt7/FpBY830uGJ+ncWrhpcaSVI85aV1J7rGG4UWVSAqKxXZ2ETt9WWVoML43ELhP9XTl7mHxaRxbX8=
X-Received: by 2002:a2e:93cc:: with SMTP id p12mr19531900ljh.11.1563327366873;
 Tue, 16 Jul 2019 18:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190716193837.2808971-1-andriin@fb.com> <20190716195544.GB14834@mini-arch>
 <CAEf4BzZ4XAdjasYq+JGFHnhwEV3G5UYWBuqKMK1yu1KRLn19MQ@mail.gmail.com>
 <20190716225735.GC14834@mini-arch> <CAEf4BzY7NYZSGuRHVye_CerZ1BBBLsDyOT2ar5sBXsPGy8g0xA@mail.gmail.com>
 <20190717001457.GD14834@mini-arch> <CAEf4BzZQ9MRTNH434=oyxBjQQXWEfjMV4nU14-=LfvERafwRKw@mail.gmail.com>
In-Reply-To: <CAEf4BzZQ9MRTNH434=oyxBjQQXWEfjMV4nU14-=LfvERafwRKw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jul 2019 18:35:55 -0700
Message-ID: <CAADnVQKSW8KFTosny9mDvy0aqbAqU_q0o3C_P=Gz8Fu=11KQfw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: fix test_verifier/test_maps make dependencies
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 5:22 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > Makefile becomes hairier by the day, thx for cleaning it up a bit :-)
> >
> > > But I also don't think we need to worry about creating them, because
> > > there is always at least one test (otherwise those tests are useless
> > > anyways) in those directories, so we might as well just remove those
> > > dependencies, I guess.
> > We probably care about them for "make -C tools/selftests O=$PWD/xyz" case
> > where OUTPUT would point to a fresh/clean directory.
>
> Oh, yes, out-of-tree builds, forgot about that, so yeah, we need that.

Anyhow the patches fixed the issue I was seeing.
Hence both applied.
