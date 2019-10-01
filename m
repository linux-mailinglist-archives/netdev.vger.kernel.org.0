Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E778DC4140
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 21:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfJAToh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 15:44:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42098 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfJATog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 15:44:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so23162755qto.9;
        Tue, 01 Oct 2019 12:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NQqk+zzsCxGt5UlKzbUJguxLPZ6yaVc5dPU0ThR+onY=;
        b=eAp/LuiIUwhIG6kuDE3KYpUZqdalPy7X5VO0jykDRu5wQu2U+uDB/3tj8/s052kPMV
         5m8Mf9+LLg0RWO1vWQITXfHPrbHlxyJgRc0lnANYygVLjLgp1+fKyEzBQOAQZ03jte0Q
         UelRZ6gVk/lxGMpx81yY7yB8UyCAb2oUcdCHzcwKOHk1RcUvBVO0qhL/5ApQVx6rAw+U
         CGRLOLykko7nBM2ePqQZqFKQ9oR/1I2cKH+GHq2nRfn2PLlXFWPYXv9SdbH7w3lWda/3
         /JoROmlWz8wwVhy8zSRudqqngHXxhEQ/jc1/mdIDv2vZa01030psypmFY4NL8XB07MkL
         dqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NQqk+zzsCxGt5UlKzbUJguxLPZ6yaVc5dPU0ThR+onY=;
        b=KEP88nksbFxWJuyKa5apOsTjlop7geG3FSg2mBLLfVcxdQ8ei45spGYriFSEk8jnaC
         7YFSx8L5Xyg3t4X0DIQoQkgdf0sxAWjYBNYkZsKJH8ROf1Llf/rfZPNAmSr2VofZfXIu
         VRwW/1voe2QCk6A7O4oXndRFWF09a5DVMLeW50eKKVNoZLF7y2/MI390JaBQNVDmS4R/
         ya4RxhCLES8lCMwcecNgwcDdMd9ILkpaM3gCJ8Z7hJbZbb4pHFzwR/+zIQKxSB5OWPoz
         7aoWXmQxGFSgNE0LEnyB50uikVJVLlF6e0EV3yvTnmP1Y/G96ezA06rMB2CZbSvf7Tw4
         1Xqw==
X-Gm-Message-State: APjAAAVQwATE7Xy9pnQOcN1psdhvIMH43JYfhgc1GqYBzBkHtBI8Z87K
        cRQZ4qtfOyjv77X+Xq35vmCJcEJr/dlICgBxRW4FUVoN
X-Google-Smtp-Source: APXvYqyEQKs5ATRfKw+wIPy8qoLShf0RsO0iVE/w8djwNybzaD3KUOWkRpcyhaLzNbMUR5ZxaueJ6Ay6DhXon6DsGkg=
X-Received: by 2002:ac8:c01:: with SMTP id k1mr31968547qti.59.1569959074309;
 Tue, 01 Oct 2019 12:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <87d0fhvt4e.fsf@toke.dk> <5d93a6713cf1d_85b2b0fc76de5b424@john-XPS-13-9370.notmuch>
In-Reply-To: <5d93a6713cf1d_85b2b0fc76de5b424@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 12:44:23 -0700
Message-ID: <CAEf4Bzb8Q5nUppqBqnXH93U1con3895BJFHP88hQi5r6wohR6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 12:18 PM John Fastabend <john.fastabend@gmail.com> w=
rote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >
> > > +struct bpf_map_def {
> > > +   unsigned int type;
> > > +   unsigned int key_size;
> > > +   unsigned int value_size;
> > > +   unsigned int max_entries;
> > > +   unsigned int map_flags;
> > > +   unsigned int inner_map_idx;
> > > +   unsigned int numa_node;
> > > +};
> >
> > Didn't we agree on no new bpf_map_def ABI in libbpf, and that all
> > additions should be BTF-based?
> >
> > -Toke
> >
>
> We use libbpf on pre BTF kernels so in this case I think it makes
> sense to add these fields. Having inner_map_idx there should allow
> us to remove some other things we have sitting around.

We had a discussion about supporting non-BTF and non-standard BPF map
definition before and it's still on my TODO list to go and do a proof
of concept how that can look like and what libbpf changes we need to
make. Right now libbpf doesn't support those new fields anyway, so we
shouldn't add them to public API.

>
> .John
