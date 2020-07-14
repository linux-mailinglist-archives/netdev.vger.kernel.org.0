Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8DB21EE08
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 12:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgGNKdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 06:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgGNKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 06:33:45 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B94C061755;
        Tue, 14 Jul 2020 03:33:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B5cLY64zdz9sR4;
        Tue, 14 Jul 2020 20:33:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594722823;
        bh=T1GCa5Vy5N5d3eYF6WlMYrp3IMrfmD5AdX4JkfoEC9E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C4fN4BQjdsBGEpAOvD/7rtQasM4+cMVGI3D9iXpuFfFMaAs9bHp2Mah3vWofj/iar
         XEW2FnjeWS7WZ3A6ezluQLBCcoli4Qldj24eKy92lahLAuJRF+gXbOffXOH+CF27O2
         RIMktbriLdrU6J58PVjw/Tha3el7OBOvl95R8L8/mKF1FhP8MGta6igYBtdWKPJ9QH
         b1AKF0FcepiPX5QZ44/Qzu/gP4ZXoUbP8S77F0f0i4Go0qWB1KNzSEtowfIUqnEPg/
         s0ENN7VLEuourSAXML2o++o05uWWK0WUMZzlhwGkBfE8VYKzItKxtWquvOuCVmps86
         421hW7FY9MkzA==
Date:   Tue, 14 Jul 2020 20:33:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20200714203341.4664dda3@canb.auug.org.au>
In-Reply-To: <20200714090048.GG183694@krava>
References: <20200714121608.58962d66@canb.auug.org.au>
        <20200714090048.GG183694@krava>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8Y8dGHWymmGykuT/eaFQQnB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8Y8dGHWymmGykuT/eaFQQnB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Tue, 14 Jul 2020 11:00:48 +0200 Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jul 14, 2020 at 12:16:08PM +1000, Stephen Rothwell wrote:
> >=20
> > After merging the bpf-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> >=20
> > ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' =
being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being pl=
aced in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' bei=
ng placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being p=
laced in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' =
being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being pl=
aced in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' bei=
ng placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being p=
laced in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' =
being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being pl=
aced in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' bei=
ng placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being p=
laced in section `.BTF_ids'
> >=20
> > Presumably ntroduced by the merge of the resolve_btfids branch. =20
>=20
> missing one more #ifdef.. chage below fixes it for me,
> it's squashed with the fix for the arm build, I'll post=20
> both fixes today
>=20
> thanks,
> jirka
>=20
>=20
> ---
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index fe019774f8a7..2f9754a4ab2b 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -3,6 +3,8 @@
>  #ifndef _LINUX_BTF_IDS_H
>  #define _LINUX_BTF_IDS_H
> =20
> +#ifdef CONFIG_DEBUG_INFO_BTF
> +
>  #include <linux/compiler.h> /* for __PASTE */
> =20
>  /*
> @@ -21,7 +23,7 @@
>  asm(							\
>  ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
>  ".local " #symbol " ;                          \n"	\
> -".type  " #symbol ", @object;                  \n"	\
> +".type  " #symbol ", STT_OBJECT;               \n"	\
>  ".size  " #symbol ", 4;                        \n"	\
>  #symbol ":                                     \n"	\
>  ".zero 4                                       \n"	\
> @@ -83,5 +85,12 @@ asm(							\
>  ".zero 4                                       \n"	\
>  ".popsection;                                  \n");
> =20
> +#else
> +
> +#define BTF_ID_LIST(name) u32 name[5];
> +#define BTF_ID(prefix, name)
> +#define BTF_ID_UNUSED
> +
> +#endif /* CONFIG_DEBUG_INFO_BTF */
> =20
>  #endif
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids=
/Makefile
> index 948378ca73d4..a88cd4426398 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -16,6 +16,20 @@ else
>    MAKEFLAGS=3D--no-print-directory
>  endif
> =20
> +# always use the host compiler
> +ifneq ($(LLVM),)
> +HOSTAR  ?=3D llvm-ar
> +HOSTCC  ?=3D clang
> +HOSTLD  ?=3D ld.lld
> +else
> +HOSTAR  ?=3D ar
> +HOSTCC  ?=3D gcc
> +HOSTLD  ?=3D ld
> +endif
> +AR       =3D $(HOSTAR)
> +CC       =3D $(HOSTCC)
> +LD       =3D $(HOSTLD)
> +
>  OUTPUT ?=3D $(srctree)/tools/bpf/resolve_btfids/
> =20
>  LIBBPF_SRC :=3D $(srctree)/tools/lib/bpf/
>=20

Thanks for the quick response.  However, in the mean time the bpf-next
tree has been merged into the net-next tree, so these fixes will be
needed there ASAP.

--=20
Cheers,
Stephen Rothwell

--Sig_/8Y8dGHWymmGykuT/eaFQQnB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8NigUACgkQAVBC80lX
0GySVgf/cMJcdBBXLwcgEpQv00xkAgQB+YBKXGOFePRMn8kcv3u7NouREqG8l8CJ
xNPLEZje05P7Jh4j+q+DV8OuV3CWRbYvXY2F7UCOknAEt/6kXANgE6wMH3SAewJr
ZIUzsPloopdIEBz2foeYivlZz/atH41gPAUCIDGrZ/H8748oLfq24WzvqO6aJ1hD
ZbFCrMgDJJHB2Insbv+uOBQRhb05leygZv8/5o+605KAvsdvz7zxRKl/b0+YmJxZ
TCe4Dk0YcIoi4n1ryEmyD6QTQ9K1i0YSSAibiTzkadotzFmR6Ap21f5TaNsvDG+G
fMz6wTZxiWvz2a8kGV4DKuVP/WYkig==
=JSDz
-----END PGP SIGNATURE-----

--Sig_/8Y8dGHWymmGykuT/eaFQQnB--
