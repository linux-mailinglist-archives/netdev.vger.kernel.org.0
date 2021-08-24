Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644323F55D8
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 04:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhHXCaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 22:30:16 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57709 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhHXCaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 22:30:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GttNS6P5Zz9sXM;
        Tue, 24 Aug 2021 12:29:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629772169;
        bh=DbEFW/IIRW+UwgP8364jSKU0PNtWC18/znjAXv4/bRw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oRi3KBSDFUn9k58eFnKb61NHHXc/bPEztPQUY9mVgjlG73bgtxBTepOP9BLL05u8Y
         ppcVC0A3JB1m/wT5zDIKF2JV/l/hRLFTStAHnKYcwlQ6WIOgmgDYau6YCsJYOUbiX3
         y3RSYfYRtf7b3efua81dFKUnSRo1SrHisF8hZFbgjWSX0dk6pbWkB6SC4Oh4aLQgtM
         b/6XROyoYktvkwp2uRQv8sRuw6QdkTsgCUPvVNob0JDeAUme0flYjwsuBU4QKFXPfP
         guSFAnQhJTfH5sbCBGMRbXMR70+MGE9Hf8C10cD+njlCw78TmNNQCIB0gyEuQPxGB+
         S/PgHbt9tKgog==
Date:   Tue, 24 Aug 2021 12:29:27 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210824122927.69ea49d3@canb.auug.org.au>
In-Reply-To: <YSRVj0gwlp91UAiF@fedora>
References: <20210823075432.2069fb0b@canb.auug.org.au>
        <YSRVj0gwlp91UAiF@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+HU+wUBB/zdfdG4I/7aL9tZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+HU+wUBB/zdfdG4I/7aL9tZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Shreyansh,

On Tue, 24 Aug 2021 07:42:31 +0530 Shreyansh Chouhan <chouhan.shreyansh630@=
gmail.com> wrote:
>
> Apologies for the wrong fixes tag.
>=20
> Since the patch is already in the tree, (and since this is the first
> time I am facing this,) I wanted to ask if I should resend the patch
> with the correct fixes tag to fix this.

The only way it can be fixed is to rebase the tree it is in.  However,
Dave does not rebase his trees, so you should just take this as a
learning experience and remember for next time.

--=20
Cheers,
Stephen Rothwell

--Sig_/+HU+wUBB/zdfdG4I/7aL9tZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEkWYcACgkQAVBC80lX
0Gx1lAgAk0eyvjWeQeXdGan+Xx+Y2RScHvtKJYLKmAC8xPs97o2+zrp0rgU40qIZ
J5J5M0sHOJl/f3rLNAXVhhGt543dzccKXE1BDNYASp46UDtC3D2Smka/m2wsdJR8
Mwkmsc7m3N68q/QzujWDXyYiCCc11Rv92wV5LLxYVKLo1ILxReas9bqkDP6EDm0X
rBZJLXIZoWw3MCoIF0S/h/+ZeARm3ZSyaYS4GnejWY/a1pjSZejjaCDbr8GLIu5L
3vEtA0WNnhfb5ABuoNfmluWGwrculJDTT4mNd2kl5fOCqY2Y7kl0cNNt70BENc+b
UPpw4V+g7xptdmCpC8ezfI76f9JB5Q==
=omnH
-----END PGP SIGNATURE-----

--Sig_/+HU+wUBB/zdfdG4I/7aL9tZ--
