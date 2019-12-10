Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14194118771
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfLJL4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:56:36 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:35204 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfLJL4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:56:35 -0500
Received: by mail-qv1-f65.google.com with SMTP id d17so4058426qvs.2;
        Tue, 10 Dec 2019 03:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=icyiV0RkwZGTgKtaUg4qH+GVpCIVxWbtRgaACTjmezU=;
        b=PwbV3w12Itgjb8l/FkXrdXwPVcyz1mHD8YgsJSwZGWHEGvg3wENYq8qQPOKaMM0Jz8
         1KY/bhhBvsCSwKyczPyTmFLr/sMF47gkbY3lf5B8MDGrMavVZ0ST6+XPM3vQGJrSk/uO
         nX9JoMId28nclnbNTMn9YqK71lh0fEQ8pYYD1bmT/KRJjNG8ON6l33hVi69kqTt0UCJY
         7l3JrVIV+zXa2BiOMAq5Gc5eJiCfV/tk5IDA3VHLRrrliJEUB+LSdEQ1YkDln53l84VQ
         IO1N1qSAW6wbyRiPioRkkaxGcnXMAfssOVarilVDV5jl7lSHfxegk3+PV+Kf043At71Z
         nNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=icyiV0RkwZGTgKtaUg4qH+GVpCIVxWbtRgaACTjmezU=;
        b=F07w/6NkixrUAspfRzpbpNf+iBAloggrby3Nj98zGW1mUWQRmfXJBRDx/cbYGrGsYc
         Bsk9gaeM8OBnylNGWh5jWLKu9claLlnH0j4KEY0grFmGe+cmxqp1KBVrmtVPHE3megxO
         tiDPYIytmyrtU1OaaalbGgifkYrtoUZVbFIPfbXgC1YKiJCJLKV/HbVbjz33EkjpRcqO
         dpnWy9wkuDQ18xyi4NDSksVx6F3e8L3mAcsaHgBI14hL0qa1LvORC+Bt9BxJ/yiFaVeq
         d5gY26MKcwsizmRvxrK9RziXW5l2YLYdAGHUAUpE6+H8vjsxJmHlkCWaqn0xIJlEEeEh
         o/2w==
X-Gm-Message-State: APjAAAUOtBUM8ijksupFjnWiUngtYsTx0uIUnjwFpfbh/6aE1tzIVy2i
        Q9jme5geT9X+Br7yBUTfwup9gLX847TQ/p/mMCo=
X-Google-Smtp-Source: APXvYqy8ZVKNN5jBH+qkGQGREjYSjZlQJXpQc5Mfr3X61qU0LpvAWV97ZK4d4wFUVvoJQ0XnNIxE2HY99aFODE15gHU=
X-Received: by 2002:a05:6214:6f2:: with SMTP id bk18mr28126320qvb.10.1575978994582;
 Tue, 10 Dec 2019 03:56:34 -0800 (PST)
MIME-Version: 1.0
References: <20191209135522.16576-1-bjorn.topel@gmail.com> <20191209135522.16576-6-bjorn.topel@gmail.com>
 <20191210120450.3375fc4a@carbon>
In-Reply-To: <20191210120450.3375fc4a@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 10 Dec 2019 12:56:23 +0100
Message-ID: <CAJ+HfNjMyT3Ye=gyKDUkqsYJxngGp-tpV_m+C93uHbbyxbYoyQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/6] selftests: bpf: add xdp_perf test
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 at 12:05, Jesper Dangaard Brouer <brouer@redhat.com> wr=
ote:
>
> On Mon,  9 Dec 2019 14:55:21 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The xdp_perf is a dummy XDP test, only used to measure the the cost of
> > jumping into a XDP program.
>
> I really like this idea of performance measuring XDP-core in isolation.
> This is the ultimate zoom-in micro-benchmarking.  I see a use-case for
> this, where I will measure the XDP-core first, and then run same XDP
> prog (e.g. XDP_DROP) on a NIC driver, then I can deduct/isolate the
> driver-code and hardware overhead.  We/I can also use it to optimize
> e.g. REDIRECT code-core (although redir might not actually work).
>
> IMHO it would be valuable to have bpf_prog_load() also measure the
> perf-HW counters for 'cycles' and 'instructions', as in your case the
> performance optimization was to improve the instructions-per-cycle
> (which you showed via perf stat in cover letter).
>
>
> If you send a V4 please describe how to use this prog to measure the
> cost, as you describe in cover letter.
>
> from selftests/bpf run:
>  # test_progs -v -t xdp_perf
>
> (This is a nitpick, so only do this if something request a V4)
>

I'll definitely do a v4! Thanks for the input/comments! I'll address
them in the next rev!

Cheers,
Bj=C3=B6rn

>
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  .../selftests/bpf/prog_tests/xdp_perf.c       | 25 +++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_perf.c b/tools/=
testing/selftests/bpf/prog_tests/xdp_perf.c
> > new file mode 100644
> > index 000000000000..7185bee16fe4
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_perf.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +
> > +void test_xdp_perf(void)
> > +{
> > +     const char *file =3D "./xdp_dummy.o";
> > +     __u32 duration, retval, size;
> > +     struct bpf_object *obj;
> > +     char in[128], out[128];
> > +     int err, prog_fd;
> > +
> > +     err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
> > +     if (CHECK_FAIL(err))
> > +             return;
> > +
> > +     err =3D bpf_prog_test_run(prog_fd, 1000000, &in[0], 128,
> > +                             out, &size, &retval, &duration);
> > +
> > +     CHECK(err || retval !=3D XDP_PASS || size !=3D 128,
> > +           "xdp-perf",
> > +           "err %d errno %d retval %d size %d\n",
> > +           err, errno, retval, size);
> > +
> > +     bpf_object__close(obj);
> > +}
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
