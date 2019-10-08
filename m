Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F841D0427
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbfJHXcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:32:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41960 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJHXcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:32:14 -0400
Received: by mail-qk1-f196.google.com with SMTP id p10so504608qkg.8;
        Tue, 08 Oct 2019 16:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wjNh5CUw5lUrvHTtLBGinf179u88y/gEO+POZbEDrVk=;
        b=bmqe8KvZzFG3lAsu2WTSJaChViqFsCe6b2YcT1wr3mqbh7hx32FUZOD50N8flahUpx
         7IuPDWw9QkL0s/QRKTytqaFGW3Ny6i9Ygtd51LtBpyatw8ZbiYofvrjSV64g1DettAPv
         nX/09ARYoszP1ASyHHqljiPVKOEbj0EbDusK9QjzCtUPLL3zaptCXUsfECvoqbsAEAxh
         +3bx5IdWCI5kAcSdT5avpiablOtACsaeotTaJJWavnLLBy6388++Eb6nqsrle1cT0Goe
         6YNC3ZER5QmXrclDS7zNMjN76hkL0cSjwWLVS2YNXWD623veGy6Za+nLwk8+8RC+5DwE
         wesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wjNh5CUw5lUrvHTtLBGinf179u88y/gEO+POZbEDrVk=;
        b=Fi/ETvUbfAWreRty0rWVg8WytSYh8g9/OzgSguF8GssriHI4R8/mUozqe7mD/8+UsO
         aDNzJYFrZZefJ+uS05UAEnH3RShMkGppov4k5Rtlj3CCbJu84yk/C0XGY2wNY0hjKwAL
         ns9jxoOhIbRwdvfaZw9II0El24RwUoLvJb1FakOtqo7kx0kTiZDkmfNpyI18DZumwRT+
         aaYvF3f13AzUEze5nsxSLzfOfVA7twHkFx1YUQ2GuNS28GXTuztnktz/LMKAX6+juI1J
         LpmJOyYD8VhzJuNrXpvdcjniiMMEDDzW2SyNZpeUmwS9USBb17HPNnxXx8GJZZJlyEO1
         Marw==
X-Gm-Message-State: APjAAAX+uvWDmIPirJrQP2UvmxBdwQXzCRNeJOe1U+sUYgmPo1oXZgYr
        jFEys3gDsw+f8MeCYodQAMX1RG+NSnAxtSvEwzM=
X-Google-Smtp-Source: APXvYqxd3+LktT9n7XdT/ePAXvLvLty4IQivusdUKsXfFXUt3GCeMlRMtXCFyunBwEafdtOAFbXNnZAGACGtNzRHHzg=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr778210qka.449.1570577532777;
 Tue, 08 Oct 2019 16:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191007030738.2627420-1-andriin@fb.com> <20191007030738.2627420-2-andriin@fb.com>
 <20191007094346.GC27307@pc-66.home> <CAEf4BzZDKkxtMGwnn+Zam58sYwS33EDuw3hrUTexmC9o7Xnj1w@mail.gmail.com>
 <20191008214937.GH27307@pc-66.home>
In-Reply-To: <20191008214937.GH27307@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 16:32:01 -0700
Message-ID: <CAEf4Bza=p1uiV0mHvzrbisSYS1s2Gnx4S2109eGjtP0Vhr_mbg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/3] uapi/bpf: fix helper docs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 8, 2019 at 2:49 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Mon, Oct 07, 2019 at 10:47:19AM -0700, Andrii Nakryiko wrote:
> > On Mon, Oct 7, 2019 at 2:43 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > On Sun, Oct 06, 2019 at 08:07:36PM -0700, Andrii Nakryiko wrote:
> > > > Various small fixes to BPF helper documentation comments, enabling
> > > > automatic header generation with a list of BPF helpers.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> [...]
> > > I'm wondering whether it would simply be much better to always just use 'void *ctx'
> > > for everything that is BPF context as it may be just confusing to people why different
> > > types are chosen sometimes leading to buggy drive-by attempts to 'fix' them back into
> > > struct sk_buff * et al.
> >
> > I'm impartial on this issue. In some cases it might be helpful to
> > specify what is the expected type of the context, if it's only ever
> > one type, but there are lots of helpers that accept various contexts,
> > so for consistency its better to just have "void *context".
>
> I would favor consistency here to always have "void *context". One
> additional issue I could see happening otherwise on top of the 'fix'
> attempts is that if existing helpers get enabled for multiple program
> types and these have different BPF context, then it might be quite
> easy to forget converting struct __sk_buff * and whatnot to void * in
> the helper API doc, so the auto-generated BPF helpers will continue
> to have only the old type.

Ok, I can create a follow-up clean up patch changing all of them to
void *. There is also a weird singular case of having three
declarations of bpf_get_socket_cookie() with different contexts. I
assume I should just combine them into a single
declaration/description, right?

>
> Thanks,
> Daniel
