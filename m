Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D5633692C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCKAr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCKAre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 19:47:34 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19632C061574;
        Wed, 10 Mar 2021 16:47:29 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DwqzK6csKz9sRR;
        Thu, 11 Mar 2021 11:47:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1615423646;
        bh=/imjzPaihzDddAbJxiZ1d6fJrn+8s663u8iFdGFD8bU=;
        h=Date:From:To:Cc:Subject:From;
        b=MSgUptuS287gmfcz3ta13qGfPCejwDnxoM1+ddnsS6nNIEutj5WZ/H8spuHqR6eb1
         k6DcOdqpjO5b/OAnkkPtY/mhKruAgzzr6rcNBk6nl2uttWhppkTZ70CuVv/0XSOqMJ
         NUMTfHtZ9PwHD6Zneo/QoCxIP0xeZyPoeJgAZllLcK+UgNrwkwDiVzVhLzKjoaD8Q2
         uIdoGN2OouILjyZHda3GEvGn87v16RMgKOSVFeRSD8eAR3DgIbaDnxshNG3BXpe5W7
         b+GsonAKQ6KOAgupF+cNCRG50w/wKQ7SnX11QM8h4dNjvP/By3HDHogTtskOu1Avp8
         KG9zyGLYudJ8A==
Date:   Thu, 11 Mar 2021 11:47:23 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210311114723.352e12f8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KHDO_qP2e1=2nJb80WjgDHF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KHDO_qP2e1=2nJb80WjgDHF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (perf) failed
like this:

make[3]: *** No rule to make target 'libbpf_util.h', needed by '/home/sfr/n=
ext/perf/staticobjs/xsk.o'.  Stop.

Caused by commit

  7e8bbe24cb8b ("libbpf: xsk: Move barriers from libbpf_util.h to xsk.h")

I have used the bpf tree from next-20210310 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/KHDO_qP2e1=2nJb80WjgDHF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBJaJsACgkQAVBC80lX
0GyzQwf+KEu2eFmPB6gHMPuaxtZ7SredwOaBOs9jlA1KTeRBjoQY29UZ0l9kpb9+
xNSn/rapEZtzl7C8ZS+4DXd0XPpG/vv6v6AfU1L5fxjduQlddNA4sFY13c501Ubj
RtvsSeaKH9CHyIk9vx8a1accGseJrVcMbm/DzUMSeC0QGhEAM36hcF5eU6jRKGzB
i67/NrQf8Mw2bhD8+27wJlGlGni6oapL4+PQtZtJrSAQvcpyfimS8TzEtt8Z+YRR
qqomhwWdgbghLsMpKp5uJZsJXKp/ZreEuon2QQ4TLlb0AlNhakbluebjgf4LfG4f
R9Wrm1eeJe639mwpXGqr/5xvk9WOow==
=gb6G
-----END PGP SIGNATURE-----

--Sig_/KHDO_qP2e1=2nJb80WjgDHF--
