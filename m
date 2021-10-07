Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C49F425EF4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241176AbhJGVdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJGVdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:33:16 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1289EC061570;
        Thu,  7 Oct 2021 14:31:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HQPdg6RD9z4xb9;
        Fri,  8 Oct 2021 08:31:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633642280;
        bh=5/XFPcuf7C72Hw7AsZjDnLmvBgF2glmuCRaS6v7XwFc=;
        h=Date:From:To:Cc:Subject:From;
        b=PE3E8BKuskQXJzX7thQ5I8h9kk2IOg0GcvPMPCm1wj55fIuZv1McHhh3PsLdLs1bi
         3pCk+fn/Bpq4Uji8FlEwzNMlp9nfSQw9fip6HHS/9SFmO9XO8rxKUAyuPP/mS3FFRt
         s8dqZpD0kGLB75rLUvSFe8d2If5/5t18b/Jmnob4Vrx2YnK8qkdVI3vx+ALNS73K4h
         5vXZaKSHRbYn8BRnzuOxTjcwualKIPtcK2WoLSeFaFxtpjQanD3FoZ0BqmMFJrDI0x
         P/Hy6U/gUmiBhaCrGvOgKdwis6vs0zIiTlwodf9Kfwbc/LT8hsT2wM1TIludA8IxM0
         t7FQ4VSCO0DfA==
Date:   Fri, 8 Oct 2021 08:31:18 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the bpf-next tree
Message-ID: <20211008083118.43f6d79f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aTfZNbFXbbcOWTzmiM.ECJy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aTfZNbFXbbcOWTzmiM.ECJy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  065485ac5e86 ("mips, bpf: Fix Makefile that referenced a removed file")

Fixes tag

  Fixes: 06b339fe5450 ("mips, bpf: Remove old BPF JIT implementations")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: ebcbacfa50ec ("mips, bpf: Remove old BPF JIT implementations")

--=20
Cheers,
Stephen Rothwell

--Sig_/aTfZNbFXbbcOWTzmiM.ECJy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFfZyYACgkQAVBC80lX
0GxaAgf9GJm36VIGvMepSVbgO/Yv2IfKJZt9Ou/89+kk1PiUddCqfP+ZfDe2l2k6
BGl/32KQMCrCqKIQ/VMLUMBTStrJnlyXW2tyyQr8kyhD34iVIOnXO+P+7uuBdEd9
6An8w8P43iWnSQbf0qH/kBbCzBHgViSaa60R0clh9Pm3ShDCjRofh4ofYc/kBJJX
yzHOMJh642iw/dHH86J6q2nKCW7SEQ9/8yfytvxzOSyOhzNvFflW4/OGKCrT9U0K
Y3TYx3XANlTCLRh/f6Evo07Jf2rXbpYiznGZpSxAe5dNwy/3FlmTzxKLjTbikg2r
hwIcLGkClYXJuq0h3zj9xq13Z8a8Ig==
=/nsQ
-----END PGP SIGNATURE-----

--Sig_/aTfZNbFXbbcOWTzmiM.ECJy--
