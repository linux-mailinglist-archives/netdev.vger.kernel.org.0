Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2212947F9
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440665AbgJUF5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:57:46 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39735 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394425AbgJUF5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:57:45 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CGKXM1Q5Gz9sSC;
        Wed, 21 Oct 2020 16:57:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1603259863;
        bh=mkLwb6kYwQ5MuroG8erdEQ/q9dFxwaXcp8HOCQlFz1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oftk9kwaznnWGT5R4ERP84VjA88qUyCKap8AoP+wGfibOEhmSJLrDGuFebks+JhBU
         Yl2AIoqmupABt314t71hQRu1GidmRFmsW8fmUPzIZJzHaxnRAm796dtCBPU8e7isGF
         csooTmikT+1/gbscxO/rhVeMAWpBI0rGOucCJr1O1Qiuncz6pxH1LNiQIztBT85q6E
         V82XrX6wffAj7IqIVhRKJcUVJ7Bh9s87H3f6BgGy/FkNgUaB8j/Nd3z/sENeEr33KB
         vg/dlhJrI8qrQWPKzfwhfUrHz8GqTKpcPuQo2xOeIvBHvpQ6LVa6d+rk8zvuEK8CbC
         Lj8EqMLViJN+w==
Date:   Wed, 21 Oct 2020 16:57:37 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian@brauner.io>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: arm64 build broken on linux next 20201021 -
 include/uapi/asm-generic/unistd.h:862:26: error: array index in initializer
 exceeds array bounds
Message-ID: <20201021165737.4d1ad838@canb.auug.org.au>
In-Reply-To: <CA+G9fYuL9O2BLDfCWN7+aJRER3sQW=C-ayo4Tb7QKdffjMYKDw@mail.gmail.com>
References: <CA+G9fYuL9O2BLDfCWN7+aJRER3sQW=C-ayo4Tb7QKdffjMYKDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vsMUGu8oXuZ.cm_zXu.FKjI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vsMUGu8oXuZ.cm_zXu.FKjI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Naresh,

On Wed, 21 Oct 2020 10:35:10 +0530 Naresh Kamboju <naresh.kamboju@linaro.or=
g> wrote:
>
> arm64 build broken while building linux next 20201021 tag.
>=20
> include/uapi/asm-generic/unistd.h:862:26: error: array index in
> initializer exceeds array bounds
> #define __NR_watch_mount 441

Yeah, the __NR_syscalls in include/uapi/asm-generic/unistd.h needed to
be fixed up in the notifications tree merge to be 442.  Sorry about
that, I will use the correct merge resolution tomorrow.

--=20
Cheers,
Stephen Rothwell

--Sig_/vsMUGu8oXuZ.cm_zXu.FKjI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+PzdEACgkQAVBC80lX
0GyPywf/eOyBnEM2pUsqMWeBkDZe16m8CuoJYhbnpwflfBozng3GxkRWKdPv4Rhi
//GTB5VrdFww/QJDlBLQpZO8c+ROedFYTwGCXuCjGm0DRbLsM9M+ZnCiMG44wgvk
dCeCMmtzNfa9vhJAdKCmXeIiqwO4zyynkn1c/WHNSPLp5SfaBsZYyn4Oc4Rh5fuN
O0ZsRGEpaTvr30L01hAOoj1XhR4mf/SI/tYPyVHveglKYw6A7ObLWbHK6oytVAVU
Ez44wifav6vPxCoouWsJ0v56fsB0BCmqRAaEC6Zg9cs9J1vUneScsn5NM5IWwk49
e6jyMR/MaJzqiZjWNn1BApxzap7oRw==
=sb06
-----END PGP SIGNATURE-----

--Sig_/vsMUGu8oXuZ.cm_zXu.FKjI--
