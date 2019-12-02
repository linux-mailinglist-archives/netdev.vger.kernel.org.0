Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73410F11F
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 20:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfLBTyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 14:54:41 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36514 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfLBTyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 14:54:40 -0500
Received: by mail-qk1-f195.google.com with SMTP id v19so864809qkv.3;
        Mon, 02 Dec 2019 11:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2w/cy+utKSCOrRThhOlkaAEXscNjPmnC5jne6biM+7Y=;
        b=EvG48iMFy8TX2G9hixeC4PSXzFPCkkkDDIJ7UarL2ZhNPsfyxoHAgbqJSvN4Hqp4kb
         Ku82aJS5rxJ+kztooLXzL438Za5CxB+M0oh61lVpeVH4uFe3onXCfyXfX2nLIJmLwCKA
         tcu80y7xtd4qWhbuFGLinCiUTAkZAFT4r3FNpB1qymOB8Vx4m8bIe9aARTewO6o2x2bA
         5D8ee7Js/52/9pc228hjnAtnhaVRLg9btwQkPtJZIRStjmysuyV+St1G40F2qF5tARH6
         coK82FY0oM+bv0Ry1iOY4IcxuaVnUmMiFTwCThAz/rZajoczR5/4qoHM2gATcwftwAju
         hqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2w/cy+utKSCOrRThhOlkaAEXscNjPmnC5jne6biM+7Y=;
        b=m/dInyX6HgBNFYqOSNdgVDyUhWs/BrKA4t5MkrxnJZ7tvFVGTbuMofiOEOhlD33bjt
         vxY8Hstt/IMTg4tvlQWgk1/YY57MDjsVdx6iHmKuFHuGBTaRS65uUEUJ2AIjbaii9uhL
         Z2+++O/GKhiOGLijOjyyJUZk/C/UVsviFDO5p9R296S5lJhqnNUy6yVD88Xn9JCBtIr+
         vkuKfH6HvMahJAY9uwXOA7s5nOz5Lr4qQQu4YxN/nmwRg20RN2kmVnhZjC1BChZJuabF
         wb+F5A7bHH25neOxgL8bxmNAlB3i7AVzjIvpzzXEOfMj5od8M/fKG2w4auieM4nJbdmB
         R8iQ==
X-Gm-Message-State: APjAAAWT9nNasWBCA8t5nhBIZkG43mopxDL/4qxOUbeK7YM76gIL/284
        UdmPocLuQgsYw2TFVOBMGCgPPWasuPO9zT1Es1c=
X-Google-Smtp-Source: APXvYqwVOqsdllAQ3Vq04L95bqydtUe41aEkrFpnOUuic5MW9TGRlSKNp5OH8AqoD1boKD8FwFDfTukz5VDO1pN5Xb8=
X-Received: by 2002:a37:a685:: with SMTP id p127mr665719qke.449.1575316478929;
 Mon, 02 Dec 2019 11:54:38 -0800 (PST)
MIME-Version: 1.0
References: <20191127094837.4045-1-jolsa@kernel.org> <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
 <87zhgappl7.fsf@toke.dk> <CAEf4BzYoJUttk=o+p=NHK8K_aS3z2LdLiqzRni7PwyDaOxu68A@mail.gmail.com>
 <20191202192122.GA22100@krava>
In-Reply-To: <20191202192122.GA22100@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 11:54:27 -0800
Message-ID: <CAEf4BzbqSKZyTyn5wTr3rt=-9W3bFZeupSiNr5YiTPp_Z8rOQw@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 11:21 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Dec 02, 2019 at 10:42:53AM -0800, Andrii Nakryiko wrote:
> > On Mon, Dec 2, 2019 at 10:09 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> > >
> > > > On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >>
> > > >> hi,
> > > >> adding support to link bpftool with libbpf dynamically,
> > > >> and config change for perf.
> > > >>
> > > >> It's now possible to use:
> > > >>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1
> > > >
> > > > I wonder what's the motivation behind these changes, though? Why is
> > > > linking bpftool dynamically with libbpf is necessary and important?
> > > > They are both developed tightly within kernel repo, so I fail to se=
e
> > > > what are the huge advantages one can get from linking them
> > > > dynamically.
> > >
> > > Well, all the regular reasons for using dynamic linking (memory usage=
,
> > > binary size, etc).
> >
> > bpftool is 327KB with statically linked libbpf. Hardly a huge problem
> > for either binary size or memory usage. CPU instruction cache usage is
> > also hardly a concern for bpftool specifically.
> >
> > > But in particular, the ability to update the libbpf
> > > package if there's a serious bug, and have that be picked up by all
> > > utilities making use of it.
> >
> > I agree, and that works only for utilities linking with libbpf
> > dynamically. For tools that build statically, you'd have to update
> > tools anyways. And if you can update libbpf, you can as well update
> > bpftool at the same time, so I don't think linking bpftool statically
> > with libbpf causes any new problems.
>
> it makes difference for us if we need to respin just one library
> instead of several applications (bpftool and perf at the moment),
> because of the bug in the library
>
> with the Toke's approach we compile some bits of libbpf statically into
> bpftool, but there's still the official API in the dynamic libbpf that
> we care about and that could carry on the fix without bpftool respin

See my replies on v4 of your patchset. I have doubts this actually
works as we hope it works.

I also don't see how that is going to work in general. Imagine
something like this:

static int some_state =3D 123;

LIBBPF_API void set_state(int x) { some_state =3D x; }

int get_state() { return some_state; }

If bpftool does:

set_state(42);
printf("%d\n", get_state());


How is this supposed to work with set_state() coming from libbpf.so,
while get_state() being statically linked? Who "owns" memory of `int
some_state` -- bpftool or libbpf.so? Can they magically share it? Or
rather maybe some_state will be actually two different variables in
two different memory regions? And set_state() would be setting one of
them, while get_state() would be reading another one?

It would be good to test this out. Do you mind checking?

>
> > > No reason why bpftool should be special in that respect.
> >
> > But I think bpftool is special and we actually want it to be special
> > and tightly coupled to libbpf with sometimes very intimate knowledge
> > of libbpf and access to "hidden" APIs. That allows us to experiment
> > with new stuff that requires use of bpftool (e.g., code generation for
> > BPF programs), without having to expose and seal public APIs. And I
> > don't think it's a problem from the point of code maintenance, because
> > both live in the same repository and are updated "atomically" when new
> > features are added or changed.
>
> I thought we solved this by Toke's approach, so there' no need
> to expose any new/experimental API .. also you guys will probably
> continue using static linking I guess
>
> jirka
>
> >
> > Beyond superficial binary size worries, I don't see any good reason
> > why we should add more complexity and variables to libbpf and bpftool
> > build processes just to have a "nice to have" option of linking
> > bpftool dynamically with libbpf.
>
