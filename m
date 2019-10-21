Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC8DE371
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfJUFDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:03:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38081 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbfJUFDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:03:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id o25so5673822qtr.5;
        Sun, 20 Oct 2019 22:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yNA4IJh7IyVo9n7MPHM6S3n+LSxLyl9PYyPGaB6d5jg=;
        b=vEUGlEnp1rwVVxS5Jx61vGmhip0OwhHMmGyL0yVwzQ0FCripho21Z0NtCXyGe8INhh
         pSPdtRohJLUiifxn9saAlL/DmVE3vXz/J0UZwG9JeXd3bdFAXzUgJh65mNZKE2jUAtL0
         BBIV1MOc4xycQbIrmkdNc1LoOKPxrxjCZM2+HFLEeFJtz7N9cr7z0S25+oKU/RmzOTrG
         EcmgbeqHNZCBirRJ46GNQcodBWKZMGbEODnUEBZSk8C4MwQfej6j0xxjTDOvdAvQiaPU
         Mr6KhW46ejKmti8qJYuhwsJJ5YC8+qobJhMD86T0SFOWma2cL7QG0Bx03REq+Rr8nle7
         yLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yNA4IJh7IyVo9n7MPHM6S3n+LSxLyl9PYyPGaB6d5jg=;
        b=C6f0TG5PHA8LCsz3hG8XIZB/fKcMJt8v6wrygRwMF2LrX/jepF2ZaKrLbWCH0TSaDH
         KgqxjAaV1cab9pamsiwyQiUNFbxM6nWvXSS4kl8FBr28mksEbT2tK7eaD+dhxNJCz2uS
         i5gAU5OXqDUyLPYBfaEnpO0+CjK5PLDt1Bizvjpn7Lz3kLyE2fSiAKR6N7bzuzSM5mH3
         WomTviKol3GFEbc26o3QHztvGUqXill4qh99Um+eYSin1TkkEBgV9Hcsycpd3NpzbetE
         JJZZNL3m8e2iqpWy6Dc3oLA3N6DVxXSH2x18zoSS05YkXmHr809ZF2jzjGPDaAb6+FbE
         LO+g==
X-Gm-Message-State: APjAAAXHQOIE4Ybv98DWL6Hkrq5C87tUlsjF5leVGD4spRGGPQN4JWwp
        9c7JXfNEkvDevliyA49STZ97d91Zd+TS5RYP2gg=
X-Google-Smtp-Source: APXvYqx+kG6LmHZ83Z0ALN68pee6pOEFXjATi0Z0/HaeHUJfEgdNcXyfZQcm+JF430XF2xZ15b8hGOYvuWC1oLROoM8=
X-Received: by 2002:ac8:2f90:: with SMTP id l16mr16097989qta.359.1571634216731;
 Sun, 20 Oct 2019 22:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191020170711.22082-1-bjorn.topel@gmail.com> <87pnirb3dc.fsf@toke.dk>
In-Reply-To: <87pnirb3dc.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 21 Oct 2019 07:03:25 +0200
Message-ID: <CAJ+HfNh+RFUQr852HDmq0DufxzrkyD_Tu99UtJUtd==L+tgB8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: remove explicit XSKMAP lookup from
 AF_XDP XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Oct 2019 at 21:53, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
> > eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
> > which means that the explicit lookup in the XDP program for AF_XDP is
> > not needed.
> >
> > This commit removes the map lookup, which simplifies the BPF code and
> > improves the performance for the "rx_drop" [1] scenario with ~4%.
>
> Nice, 4% is pretty good!
>
> I wonder if the program needs to be backwards-compatible (with pre-5.3
> kernels), though?
>
> You can do that by something like this:
>
> ret =3D bpf_redirect_map(&xsks_map, index, XDP_PASS);
> if (ret > 0)
>   return ret;
>
> if (bpf_map_lookup_elem(&xsks_map, &index))
>    return bpf_redirect_map(&xsks_map, index, 0);
> return XDP_PASS;
>

Ah, yes. Thanks for pointing that out. I'll do a respin.


Thanks,
Bj=C3=B6rn

>
> This works because bpf_redirect_map() prior to 43e74c0267a3 will return
> XDP_ABORTED on a non-0 flags value.
>
> -Toke
>
