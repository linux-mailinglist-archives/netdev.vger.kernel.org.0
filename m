Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198584E5E7
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfFUK3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 06:29:55 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38517 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfFUK3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 06:29:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id d17so5830674oth.5
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 03:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vABUrhDDlgLaEgsGYnr/fcBvwyUpWVTqO8p1TtDrOes=;
        b=Ggf5g8mV1RaLfhmi+55Hhcpvg4Cp6BH2/Tcn+fpGfUQ9h9LUe6rCX8Xbe3OPSigdTZ
         4xm0uQHwoNTm1xtFSfocJXBGHywpv0VddCYw+YWFKvG9RGnsgrEny61YAo6vpBmxaONq
         kh9EaiVpkq4Ym4nj510rrp+CWDMtuDi2IzxmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vABUrhDDlgLaEgsGYnr/fcBvwyUpWVTqO8p1TtDrOes=;
        b=CXU3e7xEPG4Cs1pQY10C13gKjqtAtogrTjvIMHY7PQ9dmwHSExJYy9nzoHTvhO2T2V
         DamxtXpihNXdGUXkJSr0A3nl57oPSbwSUox0R3dNg4gtGkh1YO0hUuUZVu5JQe9EymCr
         p8fDVbHEojiRxUxV+cmJ1RtXu1oTuJbJNE8KwEogitZiZ71bFJv0JIpya3JvKQ9rp4x8
         MnoCZEydP+kjoVEOFuFd0+UJ+aswSKZtNjXfvMJBSlWi3apK5XxMicZ7G4hG+GwdiOsg
         RQxh1eqEAQvSTYCOA5EYeg6JZrpecFfw5Rrq5DZO+Y24xryAd9LR1mIjFslUYH43ty+X
         f7Mw==
X-Gm-Message-State: APjAAAWRqfrrfa3z5IDsqYzYSVAAkCld5Wlb+KUf5d+jmU1/fpm+1/m+
        WRQ5WTsw3Iebem4eAKL3+XCXdHbXwQvF+VzLCbT/JA==
X-Google-Smtp-Source: APXvYqzTpSPH+cBe6LlLDSpKphkGr0r0xfPseC0JOnxcRKwD1PfhAR8nsM73tuVcqTixadrdxhwNYlNrXApm8Ndkppo=
X-Received: by 2002:a9d:6548:: with SMTP id q8mr15942333otl.132.1561112993753;
 Fri, 21 Jun 2019 03:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190617192700.2313445-1-andriin@fb.com> <30a2c470-5057-bd96-1889-e77fd5536960@iogearbox.net>
 <CAEf4Bzae1CPDkhPrESa2ZmiOH8Mqf0KA_4ty9z=xnYn=q7Frhw@mail.gmail.com>
 <CACAyw9-L0qx8d9O66SaYhJGjsyKo_6iozqLAQHEVa1AW-U=2Tg@mail.gmail.com> <CAEf4BzYaHG9Z_eFQCtwxA7t5GwQq2wr=AEeFWZpqx9vdQqKv1g@mail.gmail.com>
In-Reply-To: <CAEf4BzYaHG9Z_eFQCtwxA7t5GwQq2wr=AEeFWZpqx9vdQqKv1g@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 21 Jun 2019 11:29:42 +0100
Message-ID: <CACAyw98JqwZbcTdpRNcG_fT6A-ekEqn9D5Zx4myB8oiX73uZkw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jun 2019 at 05:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 20, 2019 at 7:49 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Tue, 18 Jun 2019 at 22:37, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > > > I would just drop the object-scope pinning. We avoided using it and I'm not
> > > > aware if anyone else make use. It also has the ugly side-effect that this
> > > > relies on AF_ALG which e.g. on some cloud provider shipped kernels is disabled.
> > > > The pinning attribute should be part of the standard set of map attributes for
> > > > libbpf though as it's generally useful for networking applications.
> > >
> > > Sounds good. I'll do some more surveying of use cases inside FB to see
> > > if anyone needs object-scope pinning, just to be sure we are not
> > > short-cutting anyone.
> >
> > I'm also curious what the use cases for declarative pinning are. From my
> > limited POV it doesn't seem that useful? There are a couple of factors:
>
> Cilium is using it pretty extensively, so there are clearly use cases.
> The most straigtforward use case is using a map created and shared by
> another BPF program (to communicate, read stats, what have you).

I think Cilium is in the quirky position that it has a persistent daemon, but
shells out to tc for loading programs. They are probably also the most
advanced (open-source) users of BPF out there. If I understood their comments
correctly they want to move to using a library for loading their ELF. At that
point whether something is possible in a declarative way is less important,
because you have the much more powerful APIs at your disposal.

Maybe Daniel or someone else from the Cilium team can chime in here?

> > * Systemd mounts the default location only accessible to root, so I have to
> >   used my own bpffs mount.
> > * Since I don't want to hard code that, I put it in a config file.
> > * After loading the ELF we pin maps from the daemon managing the XDP.
>
> So mounting root would be specified per bpf_object, before maps are
> created, so user-land driving application will have an opportunity to
> tune everything. Declarative is only the per-map decision of whether
> that map should be exposed to outer world (for sharing) or not.

So `tc filter add bpf obj foo.elf pin-root /gobbledygook`?

> Then check tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
> for more crazy syntax ;)
>
> typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));

Not on a Friday ;P

> > What if this did
> >
> >   __type(value, struct my_value)[1000];
> >   struct my_value __member(value)[1000]; // alternative
> >
> > instead, and skipped max_entries?
>
> I considered that, but decided for now to keep all those attributes
> orthogonal for more flexibility and uniformity. This syntax might be
> considered a nice "syntax sugar" and can be added in the future, if
> necessary.

Ack.

> > At that point you have to understand that value is a pointer so all of
> > our efforts
> > are for naught. I suspect there is other weirdness like this, but I need to play
> > with it a little bit more.
>
> Yes, C can let you do crazy stuff, if you wish, but I think that
> shouldn't be a blocker for this proposal. I haven't seen any BPF
> program doing that, usually you duplicate the type of inner value
> inside your function anyway, so there is no point in taking
> sizeof(map.value) from BPF program side. From outside, though, all the
> types will make sense, as expected.

Right, but in my mind that is a bit of a cop out. I like BTF map definitions,
and I want them to be as unsurprising as possible, so that they are
easy to use and adopt.

If a type encodes all the information we need via the array dimension hack,
couldn't we make the map variable itself a pointer, and drop the inner pointers?

struct my_map_def {
  int type[BPF_MAP_TYPE_HASH];
  int value;
  struct foo key;
  ...
}

struct my_map_def *my_map;

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
