Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AFB21F2BA
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgGNNfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:35:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54006 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726624AbgGNNfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 09:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594733711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YyXMs9kCrSxJtbUrGH5EMqms1GtICtU2BsMz6QmOyPw=;
        b=UrxiSubF3KPJFSh9CnCTQf0OyTvLU5BQAgjO39lOnnQF8wnCeQCdBknhzWMmvE+TtXle4B
        3MiT46ZmzIVqk24qAAEnoc07PfxDP16bz42hp0DoNTpueRiJGVX2ZRu9XxFvx+wiRRbQI7
        bEBbj1wojvVclPk6eQLTAC/9B2r1mJc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-kjCoNZ70PLOE8vVscC6vHw-1; Tue, 14 Jul 2020 09:35:02 -0400
X-MC-Unique: kjCoNZ70PLOE8vVscC6vHw-1
Received: by mail-wr1-f71.google.com with SMTP id i12so21694775wrx.11
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 06:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YyXMs9kCrSxJtbUrGH5EMqms1GtICtU2BsMz6QmOyPw=;
        b=uDgwy9LH/HxQau55KRCbpUUD7opma865iZHjZOvqdLPms2N+sbD/mzWvfxtuva8ic/
         JYo1Z3KNfRGkv2KTuVYmi50GiZlikTPpXHWDY1GqOd4ezG0+YQ65ySmkraDBR4NlfwNI
         59XYKBMZcdY2htFlGdaECKj6AQCrb1lELjZ+O/Po4xNlTJEwVsTPSA+6O/GZXXT8jMz3
         j+30CEK8IieugR4nj8yamIKkGGU/dbfjdtYsHltpKGyVWYeH0wrAq2H/CSNsDizUFXkI
         510EKHngH6vJ9JVHNmA2RiP6UXKF9OC4mp9Rv/bqM0jBsscvyJxx7ZdwtEzGyrKfJbSc
         COeA==
X-Gm-Message-State: AOAM531q+dkI20rX/2nggVFMqJx5oF+3f5SMGnByM73dOYZ4bCczXzPf
        3PdX50VF5qPtEv5tsaYMiERrGiruNCF/By0KILe+2jBfGMesROB+fDGnpj2EmfYSxfZz3HtcYGE
        P//YAn7iUfK1eB9q2
X-Received: by 2002:a1c:1dc7:: with SMTP id d190mr4495202wmd.36.1594733701122;
        Tue, 14 Jul 2020 06:35:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGh3/6sjDQU9IIgJHN4xz6oYipDxS/J68wQyfwoBRTwcDc4b5rRUUm8k18us3UqW0F0Yl7jw==
X-Received: by 2002:a1c:1dc7:: with SMTP id d190mr4495179wmd.36.1594733700847;
        Tue, 14 Jul 2020 06:35:00 -0700 (PDT)
Received: from localhost ([151.48.133.17])
        by smtp.gmail.com with ESMTPSA id g14sm29594650wrm.93.2020.07.14.06.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 06:35:00 -0700 (PDT)
Date:   Tue, 14 Jul 2020 15:34:56 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: Re: [PATCH v6 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200714133456.GB2174@localhost.localdomain>
References: <cover.1593941895.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <cover.1593941895.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
> capability to attach and run a XDP program to CPUMAP entries.
> The idea behind this feature is to add the possibility to define on which=
 CPU
> run the eBPF program if the underlying hw does not support RSS.
> I respin patch 1/6 from a previous series sent by David [2].
> The functionality has been tested on Marvell Espressobin, i40e and mlx5.
> Detailed tests results can be found here:
> https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpuma=
p04-map-xdp-prog.org
>=20

Hi Alexei and Daniel,

I will post a v7 since v6 does not apply anymore to bpf-next.

Regards,
Lorenzo

> Changes since v5:
> - move bpf_prog_put() in put_cpu_map_entry()
> - remove READ_ONCE(rcpu->prog) in cpu_map_bpf_prog_run_xdp
> - rely on bpf_prog_get_type() instead of bpf_prog_get_type_dev() in
>   __cpu_map_load_bpf_program()
>=20
> Changes since v4:
> - move xdp_clear_return_frame_no_direct inside rcu section
> - update David Ahern's email address
>=20
> Changes since v3:
> - fix typo in commit message
> - fix access to ctx->ingress_ifindex in cpumap bpf selftest
>=20
> Changes since v2:
> - improved comments
> - fix return value in xdp_convert_buff_to_frame
> - added patch 1/9: "cpumap: use non-locked version __ptr_ring_consume_bat=
ched"
> - do not run kmem_cache_alloc_bulk if all frames have been consumed by th=
e XDP
>   program attached to the CPUMAP entry
> - removed bpf_trace_printk in kselftest
>=20
> Changes since v1:
> - added performance test results
> - added kselftest support
> - fixed memory accounting with page_pool
> - extended xdp_redirect_cpu_user.c to load an external program to perform
>   redirect
> - reported ifindex to attached eBPF program
> - moved bpf_cpumap_val definition to include/uapi/linux/bpf.h
>=20
> [1] https://patchwork.ozlabs.org/project/netdev/cover/20200529220716.7538=
3-1-dsahern@kernel.org/
> [2] https://patchwork.ozlabs.org/project/netdev/patch/20200513014607.4041=
8-2-dsahern@kernel.org/
>=20
> David Ahern (1):
>   net: refactor xdp_convert_buff_to_frame
>=20
> Jesper Dangaard Brouer (1):
>   cpumap: use non-locked version __ptr_ring_consume_batched
>=20
> Lorenzo Bianconi (7):
>   samples/bpf: xdp_redirect_cpu_user: do not update bpf maps in option
>     loop
>   cpumap: formalize map value as a named struct
>   bpf: cpumap: add the possibility to attach an eBPF program to cpumap
>   bpf: cpumap: implement XDP_REDIRECT for eBPF programs attached to map
>     entries
>   libbpf: add SEC name for xdp programs attached to CPUMAP
>   samples/bpf: xdp_redirect_cpu: load a eBPF program on cpumap
>   selftest: add tests for XDP programs in CPUMAP entries
>=20
>  include/linux/bpf.h                           |   6 +
>  include/net/xdp.h                             |  41 ++--
>  include/trace/events/xdp.h                    |  16 +-
>  include/uapi/linux/bpf.h                      |  14 ++
>  kernel/bpf/cpumap.c                           | 159 ++++++++++---
>  net/core/dev.c                                |   9 +
>  samples/bpf/xdp_redirect_cpu_kern.c           |  25 ++-
>  samples/bpf/xdp_redirect_cpu_user.c           | 209 ++++++++++++++++--
>  tools/include/uapi/linux/bpf.h                |  14 ++
>  tools/lib/bpf/libbpf.c                        |   2 +
>  .../bpf/prog_tests/xdp_cpumap_attach.c        |  70 ++++++
>  .../bpf/progs/test_xdp_with_cpumap_helpers.c  |  36 +++
>  12 files changed, 529 insertions(+), 72 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_att=
ach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpuma=
p_helpers.c
>=20
> --=20
> 2.26.2
>=20

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXw20fQAKCRA6cBh0uS2t
rHeXAQCy+/GADfP2TyJc0N1IAYYd2vttaLQXoZH9mY9QwAuqJAD/VFWuiHMHHJiG
5DidFtIuEt+2kzOLg6eEdMDKcUyxqwU=
=37K8
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--

