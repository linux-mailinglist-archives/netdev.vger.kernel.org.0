Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F36F21E88
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 21:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfEQTie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 15:38:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37827 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729709AbfEQTid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 15:38:33 -0400
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hRigY-0003jA-Tt; Fri, 17 May 2019 21:38:30 +0200
Received: from mgr by ptx.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hRigY-0004Vp-0s; Fri, 17 May 2019 21:38:30 +0200
Date:   Fri, 17 May 2019 21:38:30 +0200
From:   Michael Grzeschik <mgr@pengutronix.de>
To:     "Kenton, Stephen M." <skenton@ou.edu>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ARCNET Contemporary Controls PCI20EX PCIe Card
Message-ID: <20190517193829.effwzuu4pfjlp7rn@pengutronix.de>
References: <be572630-98e4-95bc-f50a-e711ded62526@ou.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bzclpkknxrqdijaw"
Content-Disposition: inline
In-Reply-To: <be572630-98e4-95bc-f50a-e711ded62526@ou.edu>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:36:02 up  1:54, 19 users,  load average: 0.16, 0.12, 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bzclpkknxrqdijaw
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2019 at 07:03:19PM +0000, Kenton, Stephen M. wrote:
> I've got some old optical (as in eyeglasses) equipment that only talks=20
> over ARCNET that I want to get up and running. The PEX PCIe-to-PCI=20
> bridge is on the card with the SMC COM20022 and lspci sees them
>=20
> 02:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX 8111 PCI
> Express-to-PCI Bridge [10b5:8111] (rev 21)
> 03:04.0 Network controller [0280]: Contemporary Controls Device
> [1571:a0e4] (rev aa)
>   =A0=A0=A0 Subsystem: Contemporary Controls Device [1571:a0e4]
>=20
> I just pulled the current kernel source and 1571:a0e4 does not seem to be=
 supported by the driver.
>=20
> Before I start trying to invent wheels, is/has anyone else looking in thi=
s area?

Hi,

you should probably add a new entry into com20020pci_id_table
with the mentioned id 1571:a0e4 in drivers/net/arcnet/com20020-pci.c
and try how far you will come.

Regards,
Michael

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--bzclpkknxrqdijaw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEElXvEUs6VPX6mDPT8C+njFXoeLGQFAlzfDa8ACgkQC+njFXoe
LGTPpg/7B6Ii5bBE1CCUomj/+qbtZIUGCSDs8KRnEOiKDtopmjG3d3j0VUjlfSu7
IPaY5gnNNRQRX5fb/9UY544yZSB7yWLzMv0opvgqbqnfTvoHNcLNoAlmdM/ddJNJ
DsTz1OoEppMOVUGE0vF679oSqkZUGR6IIZbJgu0k+yZgA8H9MOScDBQ+0pIbBs2b
k7AmzTsrBLvWOz/cdjqA+lbPgKxBC58H6xv1MKPinXGuwLDNQntxhuBPSkkziM8Q
5pb6ZpURsZY0wptTJyqxOoZtH3LQMELfhu5kBMmC8DZkDr8VzqbyOwmt3AlQdYu6
Ec/UeWO2al2CbS7GE7twdREG8U2RgVE12O7Cy/9YJbxIFqYvw5hKMs1WNBKHKJt/
3O9Cl7t/uk/eJWwBdFPBfmYm1TODMHgKs/jjw3U7woVOYuKglBPxBubYT/Ja42hW
JChO434wi3PG6gpd1Auer4BLCGDLzwXfmVa7dN7AdXQ6YgpLa8SVkYTUmtA5eCE/
M1Z0ZRBGnNgFyRC3TeQxlSqy7VEbczbtAL6vFIT7JfHmdDoemSodxzM8psXc3rGe
JEmCxdNkpqyQB8iKKVLpIH3US9aYXSCs+TAT85kt4x8+maoHWhoBIu9b+WXn1i8O
L3k6oZYpq4WbJMjbKgnLRs76gnUXkezH9A09ntn7yDkk+3BuySo=
=H2/A
-----END PGP SIGNATURE-----

--bzclpkknxrqdijaw--
