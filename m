Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED17FC037
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 07:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfKNGaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 01:30:10 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:33716 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfKNGaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 01:30:10 -0500
Received: by mail-qv1-f66.google.com with SMTP id x14so1920805qvu.0;
        Wed, 13 Nov 2019 22:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PAJAgtxelmA9jZR8B3iBVB346ndl9IOeWf4Sx6YjY6k=;
        b=mXufSrNeykxFxi4MYrOI804ug0N12GiajFfA1iL7ar4uOip1pH6Ip3uNm7sf5Fux1t
         2Y3RibiWsWGdJUMiNqkbLt4hM5l5fYSHBI/lCU6RvrawoU/IYxdNX512kRqTOpWQ38qC
         m2b/ZPMsJxfvaYCyp+6I3e2NxJTHjtkh/4X3yiOlPhm9b7wRhouSDIC/CBlfE+NmwzCl
         Kk1PCjLLq6hu1BjP4uUiFWAOXJ/vVnvQhhrD+vM/cjVqxmE/DumgJmmZDRJXawQnVP6W
         ORoNZQmCCzkm1Pu5WHF4JzMe/QVd4HjTeUWGx2cDAOOR0kV2NTbv9Xi96275j7feoGEq
         AdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PAJAgtxelmA9jZR8B3iBVB346ndl9IOeWf4Sx6YjY6k=;
        b=K+9SaPFnV0DKmHR8QVD6NKXsR3zuTt/GHZQWnybV4Mc4nS3Lixk43iY6pAry/BiPQU
         hNCQWcA8hUah1AssPY/QNe6QDv5QbBC+VJk02YMuVpIUil5hGKnksOVtb+Kv8cG8g5P8
         ERRDxVIB2BW5b58U9BXKlVrnohtJ8Z6wSNs8TeEXpzVS9SAcozgK31yxzLtVXSHcw7nc
         nd2hAo0yruiQHwmlpM3vz9ZzBIBdO1tK9waERhU94Hr3MJ1eTAFjvAN6YBYz3rxrGatL
         SNZsCS/GfxlZjxywMYvwMAjaDD+PhrSC99pViDCUgnYIrHCi4Foj2HZmzOVJlLqU0Oad
         CNcw==
X-Gm-Message-State: APjAAAWvEz7lu50sqTUK5IzXXZHL/6FXWQOVZRxkjNl2yU0R95oxw06/
        AUlu9f2+N/wzpcUgYgcPEx3xGOG/oQMsK1I+GCs=
X-Google-Smtp-Source: APXvYqwdbEIuiWY178M2VwowThBQXGIeNAS9b08YOFnH+OnGxb6wAMu8e1ecyn5hRATbjfJSmv04zRPPH+U4wZ0/C1A=
X-Received: by 2002:a05:6214:70f:: with SMTP id b15mr6524128qvz.97.1573713008743;
 Wed, 13 Nov 2019 22:30:08 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
 <fa188bb2-6223-5aef-98e4-b5f7976ed485@solarflare.com>
In-Reply-To: <fa188bb2-6223-5aef-98e4-b5f7976ed485@solarflare.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 14 Nov 2019 07:29:57 +0100
Message-ID: <CAJ+HfNiDa912Uwt41_KMv+Z-sGr8fU7s4ncBPiUSx4PPAMQQqQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     Edward Cree <ecree@solarflare.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 at 22:41, Edward Cree <ecree@solarflare.com> wrote:
>
> On 13/11/2019 20:47, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The BPF dispatcher builds on top of the BPF trampoline ideas;
> > Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
> > code. The dispatcher builds a dispatch table for XDP programs, for
> > retpoline avoidance. The table is a simple binary search model, so
> > lookup is O(log n). Here, the dispatch table is limited to four
> > entries (for laziness reason -- only 1B relative jumps :-P). If the
> > dispatch table is full, it will fallback to the retpoline path.
> >
> > An example: A module/driver allocates a dispatcher. The dispatcher is
> > shared for all netdevs. Each netdev allocate a slot in the dispatcher
> > and a BPF program. The netdev then uses the dispatcher to call the
> > correct program with a direct call (actually a tail-call).
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> The first-come-first-served model for dispatcher slots might mean that
>  a low-traffic user ends up getting priority while a higher-traffic
>  user is stuck with the retpoline fallback.  Have you considered using
>  a learning mechanism, like in my dynamic call RFC [1] earlier this
>  year?  (Though I'm sure a better learning mechanism than the one I
>  used there could be devised.)
>

My rationale was that this mechanism would almost exclusively be used
by physical HW NICs using XDP. My hunch was that the number of netdevs
would be ~4, and typically less using XDP, so a more sophisticated
mechanism didn't really make sense IMO. However, your approach is more
generic and doesn't require any arch specific work. What was the push
back for your work? I'll read up on the thread. I'm intrigued to take
your series for a spin!

> > +static int bpf_dispatcher_add_prog(struct bpf_dispatcher *d,
> > +                                struct bpf_prog *prog)
> > +{
> > +     struct bpf_prog **entry =3D NULL;
> > +     int i, err =3D 0;
> > +
> > +     if (d->num_progs =3D=3D BPF_DISPATCHER_MAX)
> > +             return err;
> > +
> > +     for (i =3D 0; i < BPF_DISPATCHER_MAX; i++) {
> > +             if (!entry && !d->progs[i])
> > +                     entry =3D &d->progs[i];
> > +             if (d->progs[i] =3D=3D prog)
> > +                     return err;
> > +     }
> > +
> > +     prog =3D bpf_prog_inc(prog);
> > +     if (IS_ERR(prog))
> > +             return err;
> > +
> > +     *entry =3D prog;
> > +     d->num_progs++;
> > +     return err;
> > +}
> If I'm reading this function right, it always returns zero; was that
>  the intention, and if so why isn't it void?
>

Ugh, yeah. In general the error handling should be improved in this
RFC. If it makes sense to move forward with this series, I'll make
sure to address that. Thanks for taking a look, and for the pointers
to your work!


Cheers,
Bj=C3=B6rn

> -Ed
>
> [1] https://lkml.org/lkml/2019/2/1/948
