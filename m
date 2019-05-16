Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6283021090
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfEPWgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 18:36:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:14416 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbfEPWgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 18:36:18 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 15:36:17 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 16 May 2019 15:36:16 -0700
Message-ID: <19c1d6910766549625766d4209ded28c26cebfe8.camel@intel.com>
Subject: Re: ixgbe device for Intel C3508
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Paul Stewart <pstew@chromium.org>, netdev@vger.kernel.org,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Cc:     andrewx.bowers@intel.com
Date:   Thu, 16 May 2019 15:36:14 -0700
In-Reply-To: <CAMcMvsgiebYeAc7csDog=j4cj9h2_QdLm7dO=7hU5BOceN6anw@mail.gmail.com>
References: <CAMcMvsgiebYeAc7csDog=j4cj9h2_QdLm7dO=7hU5BOceN6anw@mail.gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JCuSoS8vkQpIrPqPQkUf"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-JCuSoS8vkQpIrPqPQkUf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-16 at 12:53 -0700, Paul Stewart wrote:
> I was pleased to fine that the ixgbe driver had good support for the
> 10GBit interfaces on the Atom C3708 device I was using.  However, the
> same is not true of the 2.5GBit interfaces on the Atom C3508.  The
> PCI
> IDs on these interfaces are very similar -- 8086:15cf on the C3508 vs
> 8086:15ce on the C3708.  Modifying the ixgbe driver to simply treat
> 8086:15cf almost works -- the 4 Ethernet interfaces are discovered
> and
> *something* happens when I plug in a Gigiabit ethernet cable into the
> SFP port:
>=20
> [  269.233242] ixgbe 0000:0c:00.0 eth1: NIC Link is Up 1 Gbps, Flow
> Control: RX/
> TX
> [  269.240733] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes
> ready
> [  269.337230] ixgbe 0000:0c:00.0 eth1: NIC Link is Down
> [  289.682588] ixgbe 0000:0c:00.1 eth2: detected SFP+: 6
> [  392.859888] ixgbe 0000:0c:00.0: removed PHC on eth1
> [  393.497099] ixgbe 0000:0c:00.1: removed PHC on eth2
> [  394./MA257214] ixgbe 0000:0d:00.0: removed PHC on eth3
> [  394.867122] ixgbe 0000:0d:00.1 eth4: NIC Link is Up 1 Gbps, Flow
> Control: RX/TX
> [  394.889384] ixgbe 0000:0d:00.1: removed PHC on eth4
>=20
> Clearly not all is well, as could be expected -- I'm sure there's a
> real reason why these are separate PCI IDs.   Is there someone out
> there that can point me at docs I can use to support the device
> myself, or does anyone know if support is coming?  Should this device
> be considered an X550 or is this a different device fundamentally
> (should I not use the Intel X550 docs as a reference, if I were to
> hunt down some documentation about the difference between these
> parts?)

Adding the intel-wired-lan mailing, which is the proper mailing list
for issues like this.

Let me look into this and get back to you.

--=-JCuSoS8vkQpIrPqPQkUf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzd5d4ACgkQ5W/vlVpL
7c6mWhAApiJNKHdZELQE2OJyHKg7krP3ZVadEpI1LXRJvx+5uVJ0iZ9zsqTS1cXF
EbGq4ouB4uAtAfdQOdQKIk77OiiMt+64oCgOGlsCvviht09p2kB2/9tFFdIFESbB
QZRQ82EnYaCLPQpBsKzApsoYIun8wRDJN+ouCMezrBsoHmvStzVOWG4gj+YyUQ0s
aud13pFxWG18/0loVwUS2o9vCEo1hUYy5ntFGBSgRranGk9fIki0Psc6RvsPgVfr
UhDU8QMIis6mYY4SUS1s3/tV2ZPWLR86kBFkACkaE/6l8cWCxS1v1EqSa1RB42fZ
0t3WIbfPxdWPUy727wzPFkSqreu8Xe2DWokG1iIBjsyLRqwdrYQVW7Xukzo6mucC
jdm1xs1bj/K3UW2Sm5toBR8KSXPcyQEkD0adPZ5Vnxfkg0BRSg4evISkN4FfUaRZ
Daiy4Y/sMOGmU8eca2yb9ZENw0EycKvP9zTS+Me/3BkUsQA6qt0nznlBO4H7UDev
OfWG8mQ4LrhZEm26w7LKwBgXvSPLD8cRkcLBijbYMv8z1Wo3z3h+L5iboJojgJNL
Y0eu1zFFw8Q4JWH89tpsUZLsWbPw7qTaE6K+5Vt/F4G1vTVWuQyOTGW3Bg7rrYr/
HaRRKALh+2z40r2xpY/0U4WoZtMha/Lc8YF3aSQZA5KWBSXvToo=
=ln/b
-----END PGP SIGNATURE-----

--=-JCuSoS8vkQpIrPqPQkUf--

