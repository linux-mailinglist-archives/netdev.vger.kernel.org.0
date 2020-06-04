Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CC01EDA55
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 03:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgFDBWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 21:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgFDBWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 21:22:47 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA52C03E96D;
        Wed,  3 Jun 2020 18:22:47 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49cp1G4XLKz9sRN;
        Thu,  4 Jun 2020 11:22:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591233764;
        bh=wXh6sMuV3RWs7MfhnDG4HbkOXO1FCrXgpCD6I81G640=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iEIi1vpjoC58WhDP9YUvXAzBVmFKs3Ip+53YsriZSkk2aO0eeKiLyOxcDaI/N9Q4s
         vqX571PtUl0tpqs48UFcbd8A+Lem0gfy7hCE30QXgIHpMPZjo4Ru0kGqe5p5J0fkYQ
         weQz3kZBSD2/s77jALTqfAgWQGOhsSFLm028qXZwluisO7wTlBq3lUgjvkCzFVL64O
         Vt3vbdi/RGAwlmUyIHuP3ORGFzUAdaQ74iTa8SLqz5cJlgHDfm27cezKsDAvU8FPS2
         Gb/4Qem9LezYVIm06SJEXKW6TMDPYpfNrZJElX1VyFX8qW7Z+Pxy+BXIkwe0CEqa+t
         ylRnebHnn1ILw==
Date:   Thu, 4 Jun 2020 11:22:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20200604112240.19c4168a@canb.auug.org.au>
In-Reply-To: <20200602121735.1a2e5d0f@canb.auug.org.au>
References: <20200602121735.1a2e5d0f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2_/vz9Nvsrtp786S7FYg8lr";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2_/vz9Nvsrtp786S7FYg8lr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 2 Jun 2020 12:17:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c:666:13: warning: 'cxgb4_ul=
d_in_use' defined but not used [-Wunused-function]
>   666 | static bool cxgb4_uld_in_use(struct adapter *adap)
>       |             ^~~~~~~~~~~~~~~~
>=20
> Introduced by commit
>=20
>   a3ac249a1ab5 ("cxgb4/chcr: Enable ktls settings at run time")
>=20
> CONFIG_CHELSIO_TLS_DEVICE is not set for this build.

I am still getting this warning.
--=20
Cheers,
Stephen Rothwell

--Sig_/2_/vz9Nvsrtp786S7FYg8lr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7YTOAACgkQAVBC80lX
0GwV1Qf/baFyd+yCb4LwWnarTKmY5IZvDMDkB98BK0GfCWbiT1ZXsHTnOxJUPINW
kpNfuUYSwu3SW+iroXI25T37B1QX0y4+2gSI3/BqAUobcUHKj81k0EIL4/++3IwN
ljeNNW1C6QETsJLlIbwo4fH8W4lAD1g1FpDgaYfACQSkLeMPQVkPWj/MqCiz8cHp
tT4Z2w2r0Stg+f7Z8rEUp2yjK0d3ynS5K5ZDNxZN0rSoQrD9POpRU0t0Td9QFKUP
f211LCKU073wSvRFZRNYfNVKMXVy4lEDlFpEDCIa9kDrYeWjc+ej+n5Egeh0nueD
d9x9C9syTWvA+leNEi+QXgFHEAYW5w==
=blgk
-----END PGP SIGNATURE-----

--Sig_/2_/vz9Nvsrtp786S7FYg8lr--
