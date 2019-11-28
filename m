Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65F10C159
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 02:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfK1BUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 20:20:32 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33921 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK1BUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 20:20:32 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so19183927ljc.1;
        Wed, 27 Nov 2019 17:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Nui3t1Giy2hesD3VIS/HTTxWM7eEAwvUXFkykKsTd4=;
        b=iK/xry5vgvOHvs3SR0V8wndpNJiEidjl/53X70zbEhk4w24ChLutdZvKbvpaSMglvO
         kZokQT+pqqq6h/sgBSphWAif4dR+pdUeOtu+CoqKC82404/usmCcTxbkuO/46bJcpFg0
         aiR7BdQrLt8Ns0I20pvnnVYkR2Rn0vEmuCiIxJYT22Qu48m2kCxZc4UnPGn16VmpCthe
         1JFyKqqMMORGTAxeCY7P/JyziP08QZZHGz5o8CyvdvCWzR1n4GKxbMgUady9jbYcR4Gj
         5DsozflKFIPICY1r0d+55juOBVlqEMLsZ5QTA6+PkNR/VsuOJ/wQeNpH7drCsP2pPIeD
         dzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Nui3t1Giy2hesD3VIS/HTTxWM7eEAwvUXFkykKsTd4=;
        b=b6HzdwUOr2XnetMDEEeWgMhJs9WXQYzhfAvYJnvNSu+f6ZleN9F1iyKU97NXQZoufc
         fFA53ljEZFXlbFqlKJlzC84yvlIVhNW7k68Ne9YRkut2EkHVNyqkQLZTwB9iQpItLs5K
         LzGWuZk9VSQGm0mLnpYDPxHW8zCBmpcJv6aEGQVQqGIO+tJUdedFN9cal8Zh+8eJ7BKC
         OrkM9+2zajhGV8umquqa4RTTpW8vKll3G+Ggluy+AsqbZ8bjO/ZBRBDSfvvM1KD1RHwH
         eYY7sAxRbn7n8vV77Y0T+zc1u81WFOyYsYBb+SCJpDuiKJsogC11hjHbvSCyxtH0DMNx
         UWwQ==
X-Gm-Message-State: APjAAAUlhJGBcJ4ZMe8+GpY9ExpPWtvquJdVElQ4GgTTO4SEm+0B9PDZ
        94O/zCavJ7IC/ou+8Al74yDiOHPHkPyFhUBZ5+U=
X-Google-Smtp-Source: APXvYqzWw0cjA2oQ7I4nZPNNxZ4X01KBGJFQYcTnrRwOaQ/WZHSQkqM0sRkG4K0WpkuguQGlCgsZeAONnEF6jc+22kY=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr33391991lji.142.1574904029363;
 Wed, 27 Nov 2019 17:20:29 -0800 (PST)
MIME-Version: 1.0
References: <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org> <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net> <20191126155228.0e6ed54c@cakuba.netronome.com>
 <20191127013901.GE29071@kernel.org> <CAADnVQJCMpke49NNzy33EKdwpW+SY1orTm+0f0b-JuW8+uA7Yw@mail.gmail.com>
 <2993CDB0-8D4D-4A0C-9DB2-8FDD1A0538AB@kernel.org> <CAADnVQJc2cBU2jWmtbe5mNjWsE67DvunhubqJWWG_gaQc3p=Aw@mail.gmail.com>
 <58CA150B-D006-48DF-A279-077BA2FFD6EC@kernel.org>
In-Reply-To: <58CA150B-D006-48DF-A279-077BA2FFD6EC@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Nov 2019 17:20:17 -0800
Message-ID: <CAADnVQLFVH000BJM4cN29kcC+KKDmVek3jaen3cZz2=12jP58g@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 5:17 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> On November 27, 2019 9:59:15 PM GMT-03:00, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >On Wed, Nov 27, 2019 at 4:50 PM Arnaldo Carvalho de Melo
> ><arnaldo.melo@gmail.com> wrote:
> >>
> >> Take it as one, I think it's what should have been in the cset it is
> >fixing, that way no breakage would have happened.
> >
> >Ok. I trimmed commit log and applied here:
> >https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=1fd450f99272791df8ea8e1b0f5657678e118e90
> >
> >What about your other fix and my suggestion there?
> >(__u64) cast instead of PRI ?
> >We do this already in two places:
> >libbpf.c:                shdr_idx, (__u64)sym->st_value);
> >libbpf.c:             (__u64)sym.st_value, GELF_ST_TYPE(sym.st_info),
>
>
> I'm using the smartphone now, but I thought you first suggested using a cast to long, if you mean using %llu + cast to __u64, then should be was ugly as using PRI, IOW, should work on both 64 bit and 32 bit. :-)

Yes. I suggested (long) first, but then found two cases in libbpf that
solve this with (__u64),
so better to stick to that for consistency.
