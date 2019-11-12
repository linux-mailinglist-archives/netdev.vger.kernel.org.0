Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB21F8EE0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLLr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:47:27 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43781 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfKLLr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:47:26 -0500
Received: by mail-yw1-f66.google.com with SMTP id g77so6304949ywb.10;
        Tue, 12 Nov 2019 03:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3UYrx1Q4+DVT94FR58gcKhUdU1Fdt9yi4lSDD2fveXY=;
        b=jjWPVVwAVmncoDMJiv71gezhbWNhROMy8sPVAgXrlw+HxDE3mPXNGOH9ogW0DDDTbs
         SV6du7zrKp/R1g+NBSjtYA8z0BehFHx62ug38ewkmCFPEYbUJwNMtt3ftYNKeujHW1H2
         nRcTy0IXFAISdd916ogA3BpXyXcGwkkHIG759/jetpR34YKSV36h1Xe11QFKQzMYHOeZ
         taezyf/ZV2H+Imu9gbZPGjTC6kVmXhIjBivOXrPCPvJwa28tZ7CJO503s+0no0MXnOrR
         DpYSZeCRwzwf7QAIW2Ge3DU3x3e7RqZ/4NTJyjHypueS2GGV2ZR3IkvuqapPjzC9x/iS
         z9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3UYrx1Q4+DVT94FR58gcKhUdU1Fdt9yi4lSDD2fveXY=;
        b=B1aJeiuqR3ScrNoM12y5H577T7zzha3Xt704yvMU+vBaL0rqVmbNOKvt4pdTTkakL8
         QfTDj1qz1Mw3hwmq2y/NAX/ep0dWqDxZ7r6qzBNluQCVcsDKKUEW2D8OfR8d2PtUYWyg
         ToVXK2V+nteVH8qfA816qJVA7Ak2jTTuhi+hY/9WASWj2UiOJcJXF9mzxDrMRdOrxzSj
         eZL6ScuhwmIbbT5obV0tyyqz4oQkfIEDCxYx5+2AIrPO0E6Rau8k2/EmCwWuxYMs7Pos
         zuCpyAX/LYGlCAesOuI2juCf69e7i1e2sWLEOe5g7Qi8qjjlwIGz9lcjb9DJfvBhAxNm
         e01A==
X-Gm-Message-State: APjAAAWbAxsuA+H+lZJ8YFGXocs0HkAiXm+AY032qlUu8CSntTOWW447
        TBv+dg28qDnQKDjMsm3kBHucxUlAv+pP0+apCA==
X-Google-Smtp-Source: APXvYqxdSWT8Che6XyGolwdhjIal0/SIqJMOJh4hg+Kl478KydJiSj42Rln6j79F876ts2wqRJgLiZ3xqG+GgR5N3Bk=
X-Received: by 2002:a81:f201:: with SMTP id i1mr18967673ywm.69.1573559245694;
 Tue, 12 Nov 2019 03:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20191110081901.20851-1-danieltimlee@gmail.com>
 <CAEf4BzYRqeg5vFm+Ac2TVVeAw=N+qhosy5qF9Dr_ka3hn8DsPg@mail.gmail.com> <87bltircil.fsf@toke.dk>
In-Reply-To: <87bltircil.fsf@toke.dk>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 12 Nov 2019 20:47:10 +0900
Message-ID: <CAEKGpzg_yijpW6+jm8q8Xj-RR97fbGotBKOMocP7AfxmgU9gqQ@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix outdated README build command
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 6:24 PM Toke H=C3=B8iland-J=C3=B8rgensen
<thoiland@redhat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Sun, Nov 10, 2019 at 12:19 AM Daniel T. Lee <danieltimlee@gmail.com>=
 wrote:
> >>
> >> Currently, building the bpf samples under samples/bpf directory isn't
> >> working. Running make from the directory 'samples/bpf' will just shows
> >> following result without compiling any samples.
> >>
> >
> > Do you mind trying to see if it's possible to detect that plain `make`
> > is being run from samples/bpf subdirectory, and if that's the case,
> > just running something like `make M=3Dsamples/bpf -C ../../`? If that's
> > not too hard, it would be a nice touch to still have it working old
> > (and intuitive) way, IMO.
>
> I think it's just the M=3D that's missing. Tentatively, the below seems t=
o
> work for me (I get some other compile errors, but I think that is
> unrelated).
>
> -Toke
>
>

Thanks for the review!
Modifying the Makefile seems better solution!

Again, It's just the issue has been solved as Daniel Borkmann mentioned.
Thanks for the review!

Best,
Daniel

> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 8a9af3ab7769..48e7f1ff7861 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -246,7 +246,7 @@ endif
>
>  # Trick to allow make to be run from this directory
>  all:
> -       $(MAKE) -C ../../ $(CURDIR)/ BPF_SAMPLES_PATH=3D$(CURDIR)
> +       $(MAKE) -C ../../ M=3D$(CURDIR) BPF_SAMPLES_PATH=3D$(CURDIR)
>
>  clean:
>         $(MAKE) -C ../../ M=3D$(CURDIR) clean
>
