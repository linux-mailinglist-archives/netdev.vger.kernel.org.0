Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D295711730E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfLIRpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:45:25 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44427 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLIRpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:45:24 -0500
Received: by mail-qk1-f194.google.com with SMTP id w127so2014624qkb.11;
        Mon, 09 Dec 2019 09:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i2Mwzc15iM61QIxqgAOa/5jWd5oyFYsgXlLYGSha3RM=;
        b=HSnNVJEaIFKF0L+et6abXYpxvo7Y8jpybTGA8oc3dn5Tczpmy5+ETt8yZiVWzTZB7+
         iUMxIRCQ58ToaBF77h1G//zhHPnen9xIsYX9bYrums+4JASdHmaopNEdfYSuFuyplcYm
         Ok5+3V+Kx+OUTj7Hd6mnVPBK4T31YaXr15uvcTl0e0ItHHLaLD6ACg8pbKAfssr7Jn15
         bEgMcNCynqJj2zARuD3r4oR3q1bhF/Eqn1JOi7t5l5firO3lNfnCYcuUUbU+EhJOXe4I
         7EQBX7wLRfqQqD9spisuM3oB4/WY+dC9hwwIKGUomQYafNQOEv3dXstx5L9CJ2OVNXjS
         HNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i2Mwzc15iM61QIxqgAOa/5jWd5oyFYsgXlLYGSha3RM=;
        b=LeXG27fmYUPC6AXde2yBVek2vuymcGIcdh8qhTJ58MNSRl/8hWVkMYMsyPlK1PUI02
         2vPIasNKtX3MSSmPinZZhbOF1VFcaK0GVfMIVadqyNhL1/sVF7B63VmMhBpyAeXx1nv5
         6updDOqF16RoK48CfAzzNvFGdQ9jVUXzrfIy0moOI4Amy8xSBXIWPClQqw+blR6Bz/Ip
         y8Mu9owyK0kHOvgscUNhYkbUPjLuvpkVNGSQSsZ3HBwX+BejcG+1EpnQ06jbEs1bWIhB
         9rbq1mhEw8KTOATEwHBq5af/C5a4yaXV21uZXabv87SmKxDKX3iyY9F1Co1/MzL1PPbo
         NozA==
X-Gm-Message-State: APjAAAWcNvwNIdP7Ctu6le3YafybassDVrj4pa1FfhIzCyY5zNPD/0Nt
        cMnunPfzRs0w0jYKrUR0E6KJpoRQQL9KiVlOkPU=
X-Google-Smtp-Source: APXvYqw/iS/FpMOYn1Won2Fo8515cPxktCM33KtpHQV04d2xt675Fjdku7DJQy6+G/WEYfRXHOzEWAXZyGNSwYLwMY0=
X-Received: by 2002:a05:620a:14a4:: with SMTP id x4mr21615604qkj.493.1575913523761;
 Mon, 09 Dec 2019 09:45:23 -0800 (PST)
MIME-Version: 1.0
References: <20191209135522.16576-1-bjorn.topel@gmail.com> <20191209180008.72c98c53@carbon>
In-Reply-To: <20191209180008.72c98c53@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 9 Dec 2019 18:45:12 +0100
Message-ID: <CAJ+HfNhikfpdAi3wC_s72Z-S8iMYUe7=hOBP_jNFQz++jrPgzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Mon, 9 Dec 2019 at 18:00, Jesper Dangaard Brouer <brouer@redhat.com> wro=
te:
>
> On Mon,  9 Dec 2019 14:55:16 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > Performance
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The tests were performed using the xdp_rxq_info sample program with
> > the following command-line:
> >
> > 1. XDP_DRV:
> >   # xdp_rxq_info --dev eth0 --action XDP_DROP
> > 2. XDP_SKB:
> >   # xdp_rxq_info --dev eth0 -S --action XDP_DROP
> > 3. xdp-perf, from selftests/bpf:
> >   # test_progs -v -t xdp_perf
> >
> >
> > Run with mitigations=3Dauto
> > -------------------------
> >
> > Baseline:
> > 1. 22.0 Mpps
> > 2. 3.8 Mpps
> > 3. 15 ns
> >
> > Dispatcher:
> > 1. 29.4 Mpps (+34%)
> > 2. 4.0 Mpps  (+5%)
> > 3. 5 ns      (+66%)
>
> Thanks for providing these extra measurement points.  This is good
> work.  I just want to remind people that when working at these high
> speeds, it is easy to get amazed by a +34% improvement, but we have to
> be careful to understand that this is saving approx 10 ns time or
> cycles.
>
> In reality cycles or time saved in #2 (3.8 Mpps -> 4.0 Mpps) is larger
> (1/3.8-1/4)*1000 =3D 13.15 ns.  Than #1 (22.0 Mpps -> 29.4 Mpps)
> (1/22-1/29.4)*1000 =3D 11.44 ns. Test #3 keeps us honest 15 ns -> 5 ns =
=3D
> 10 ns.  The 10 ns improvement is a big deal in XDP context, and also
> correspond to my own experience with retpoline (approx 12 ns overhead).
>

Ok, good! :-)

> To Bj=C3=B8rn, I would appreciate more digits on your Mpps numbers, so I =
get
> more accuracy on my checks-and-balances I described above.  I suspect
> the 3.8 Mpps -> 4.0 Mpps will be closer to the other numbers when we
> get more accuracy.
>

Ok! Let me re-run them. If you have some spare cycles, yt would be
great if you could try it out as well on your Mellanox setup.
Historically you've always been able to get more stable numbers than
I. :-)

>
> > Dispatcher (full; walk all entries, and fallback):
> > 1. 20.4 Mpps (-7%)
> > 2. 3.8 Mpps
> > 3. 18 ns     (-20%)
> >
> > Run with mitigations=3Doff
> > ------------------------
> >
> > Baseline:
> > 1. 29.6 Mpps
> > 2. 4.1 Mpps
> > 3. 5 ns
> >
> > Dispatcher:
> > 1. 30.7 Mpps (+4%)
> > 2. 4.1 Mpps
> > 3. 5 ns
>
> While +4% sounds good, but could be measurement noise ;-)
>
>  (1/29.6-1/30.7)*1000 =3D 1.21 ns
>
> As both #3 says 5 ns.
>

True. Maybe that simply hints that we shouldn't use the dispatcher here?


Thanks for the comments!
Bj=C3=B6rn


> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
