Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A0E3E55AC
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbhHJIkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhHJIkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 04:40:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B65BC06179A
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 01:39:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mDNIK-0005c9-Hf; Tue, 10 Aug 2021 10:39:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3e5f:f87b:aeb2:97cf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2CADF6644FB;
        Tue, 10 Aug 2021 08:39:28 +0000 (UTC)
Date:   Tue, 10 Aug 2021 10:39:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v4 2/3] can: rcar_canfd: Add support for RZ/G2L family
Message-ID: <20210810083925.weikjhpnzmq77oeh@pengutronix.de>
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdU7-AahJmKLabba_ZF2bcPwktU00Q_uBOYm+AdiBVGyTA@mail.gmail.com>
 <CA+V-a8vfnnfgK1cY8dqsPJUwotK7SZZu5MjeGuJTa--+qaN4gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vkropsazvj3b2glc"
Content-Disposition: inline
In-Reply-To: <CA+V-a8vfnnfgK1cY8dqsPJUwotK7SZZu5MjeGuJTa--+qaN4gg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vkropsazvj3b2glc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.08.2021 09:36:50, Lad, Prabhakar wrote:
> > > +static void rcar_canfd_handle_global_recieve(struct rcar_canfd_globa=
l *gpriv, u32 ch)
> >
> > receive (everywhere)
> >
> Ouch, I'll respin with the typo's fixed.

No need, I've fixed it here.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vkropsazvj3b2glc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmESOzsACgkQqclaivrt
76kzEgf/e8P5d8gzJH9hFLmHPfxAeSlOqHCR1gaFp6wdOsEHL0aPmn7S9dENHVvG
6dikjk204VjmfslEGv9Nk/A1IJACHKCqkqd99O5vMYsYD/5N29KPjrncpBWN3YAC
KoT7Yu3X4HWHBDXPEi/Dpj/hrx3cKNYToMawObcZ2QOtK5IbNjWX+pYx5uxwHYG1
p42/qKGr3JPBXFJtaMt91bhiMMA//uhdi6KsMlxq1KXD4yKf+bEoUJmQYx6WEif5
IZ/LO/q/DoQzAm/AfiBxhga9cbB9RLFX7m+YlDYwJJKpGD7auJeNjjEdVBm8W8ox
w+nsTjcuf1nac9ZYH51KDBUFMTSVYQ==
=6kXf
-----END PGP SIGNATURE-----

--vkropsazvj3b2glc--
