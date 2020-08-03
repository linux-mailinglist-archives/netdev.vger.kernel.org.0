Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17948239DDB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 05:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHCDcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 23:32:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51778 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgHCDcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 23:32:39 -0400
Received: from deadeye.i.decadent.org.uk ([192.168.2.121] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1k2RDJ-0008IM-8d; Mon, 03 Aug 2020 04:32:37 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1k2RDI-0012uc-SP; Mon, 03 Aug 2020 04:32:36 +0100
Message-ID: <db7d2f4dde6db2af82c880756d76af1b7c1e41e8.camel@decadent.org.uk>
Subject: Re: Bug#966459: linux: traffic class socket options (both
 IPv4/IPv6) inconsistent with docs/standards
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Thorsten Glaser <t.glaser@tarent.de>, 966459@bugs.debian.org
Cc:     netdev <netdev@vger.kernel.org>
Date:   Mon, 03 Aug 2020 04:32:36 +0100
In-Reply-To: <alpine.DEB.2.23.453.2008022243310.15898@tglase-nb.lan.tarent.de>
References: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>
          <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>
          <Pine.BSM.4.64L.2008021919500.2148@herc.mirbsd.org>
         <e1beb0b98109d90738e054683f5eb1dd483011dd.camel@decadent.org.uk>
         <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>
         <alpine.DEB.2.23.453.2008022243310.15898@tglase-nb.lan.tarent.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-IiMZclPh8WA+et0iWSLR"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.121
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-IiMZclPh8WA+et0iWSLR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2020-08-02 at 22:44 +0200, Thorsten Glaser wrote:
> On Sun, 2 Aug 2020, Ben Hutchings wrote:
>=20
> > The RFC says that the IPV6_TCLASS option's value is an int, and that
>=20
> for setsockopt (=E2=80=9Coption's=E2=80=9D), not cmsg
>=20
> > No, the wording is *not* clear.
>=20
> Agreed.
>=20
> So perhaps let=E2=80=99s try to find out what=E2=80=99s actually right=E2=
=80=A6

For what it's worth, FreeBSD/Darwin and Windows also put 4 bytes of
data in a IPV6_TCLASS cmsg.  So whether or not it's "right", it's
consistent between three independent implementations.

Ben.

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.



--=-IiMZclPh8WA+et0iWSLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl8nhVQACgkQ57/I7JWG
EQl8YBAAizWN6RG47jCK2KI9vyjYz6y5T5iHhHn7o/peUVGEgB3NjBjpXnbmdXLJ
ONPY72Mfw/nXJ4+fuAau1yOpCFk4rfwfhdd+JuBXmlmP9VfPU5cRfcMkYH09FcfC
4+cEzYkJU2NvM6i5lsuRCP5x2mN586C9S5dSMm5EZcNwXIWIQ3NSi7/naarqYWqA
APGsHPwpgHDvrfR3sCrERq+4PBjTgzNcUJyPqPtRfNR5UEEga+xMiF4eQrQsrj5b
msax1oMZUkB8zJU88VoiyJDgcjD8z4vD1yXKLXyIgVpaqUSeQKvZLiUcZ9n8HTEd
vfBTGpajknPr08SCfcjT7tACq1DKALvQE3vMhJkGgTii2VInow20ZUSOZhVi2C1c
+Mr9QCzhmu3biVr5HA42mAiKwWcK51VVnMLA4JyDdpfjAvtRn70+cTI1/FbjteMF
TA+XjasmOwdb/MsPGMhSw/DhjFqRC9QbPMrBwsTtiUBzD4wG1CYriAtRqEKdrFKr
2rJN6SwcQCkzC8NdXsjKK1oHsRfrnND5GKc0lvFYC7PBE120MIW67nPF/pJZLwTi
LZQ3rEB55J3B81L14jnRF8tkIuOuYDrCwnRo8Eux/sjerj1h4p/n+pgjXs4Ibnic
pPr9+t+JT9QR4sZhVcTtxQsb+eEIzbrV7RUUin7vzXKnw8RTEbE=
=AxRQ
-----END PGP SIGNATURE-----

--=-IiMZclPh8WA+et0iWSLR--
