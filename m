Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45ACC17B268
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCEXs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:48:29 -0500
Received: from ozlabs.org ([203.11.71.1]:41713 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCEXs3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:48:29 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48YSB155jSz9sP7;
        Fri,  6 Mar 2020 10:48:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583452106;
        bh=aKI80ctxF7IvsW1krFEsE8cXOaKoo4tVc2DQGlUj7rI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WxFZB3GwZo6Ut4w78eBhRwny/yH4RSgXiwcxD5cc3se6aUgSML98td+Lzj7j4WATJ
         xa5dxrFC4sHrgN1WZ7CEn5GQ9ckIJG+C9pCbre539QRgCK5sgfyAL16gO0CB2h003n
         +MaUlaahiBtvGaQG0/gWvHD/LSKOWs0L6fZYbHE7mITHkOXTqt3ZzbjmWzsw9lNHSn
         e4oTj6M9j2VI3kJitMLrK5LlQvjtwa4cyC5h0/yhDYdUuGC7jGbuWDg3ZoxZCzxmzD
         7gZN4qdrc3ogMuy8KYP5DubWvO05JEtbY/MmeeEjnATJsouquJCXnjv/OysBBAvm7S
         GF1icts+c4YEA==
Date:   Fri, 6 Mar 2020 10:48:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: linux-next: the nfc-next tree seems to be old
Message-ID: <20200306104825.068268eb@canb.auug.org.au>
In-Reply-To: <20200130105538.7b07b150@canb.auug.org.au>
References: <20200130105538.7b07b150@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jZ4rfO48cZsNWT59fxfh2e/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/jZ4rfO48cZsNWT59fxfh2e/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 30 Jan 2020 10:55:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Samuel,
>=20
> I noticed that the nfc-next tree has not changed since June 2018 and
> has been orphaned in May 2019, so am wondering if the commits in it are
> still relevant or should I just remove the tree from linux-next.

Since I have had no response, I will remove it tomorrow.

--=20
Cheers,
Stephen Rothwell

--Sig_/jZ4rfO48cZsNWT59fxfh2e/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5hj8kACgkQAVBC80lX
0GxKXQf/QrO0WJTnS2wQvjtyNK40yRXdrrmm6M8Oim+Rwv3/BL6RCTPSXkoXngAD
bkKuOZ1S3hs6dJy9YI31pFjJ4dU80gZgyKidcAggX5zBba2xqlAaBm5n7f4BMkis
z13+zYkHlnD0KSFtItp3rZa0eXbW3lx24baJxzluJFfJxMH8PUx9uM5uiPxUO48U
uo77cNLpiyfRXTHYu8t+hpTwhfXZkPacpQM4fSCkK9CdfJV0ibbO5xMsia4GfhLl
KeC1+EHvKTt6G/PECYLr08Oi776kFAZLeHkZxS1EHE2WLGo6HYKOJtVKm0uM+yyT
Q/4VzFZx0GuQeHieQ3Bpu7LPGL849g==
=OkeH
-----END PGP SIGNATURE-----

--Sig_/jZ4rfO48cZsNWT59fxfh2e/--
