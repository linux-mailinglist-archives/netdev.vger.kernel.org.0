Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996B81EED55
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 23:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgFDVdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 17:33:06 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:60944 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgFDVdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 17:33:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 486EA1C0C0B; Thu,  4 Jun 2020 23:33:04 +0200 (CEST)
Date:   Thu, 4 Jun 2020 23:33:02 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] net/xdp: use shift instead of 64 bit division
Message-ID: <20200604213302.GA8569@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

64bit division is kind of expensive, and shift should do the job here.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7ZaI4ACgkQMOfwapXb+vLavQCgqQbEaQpyedhluujd0zWVBTjk
5XAAoIoV7O/g/f44CbUUwgjMQSTUhS0/
=TaRr
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
