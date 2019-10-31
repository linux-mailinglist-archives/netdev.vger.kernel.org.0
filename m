Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE3EB9A0
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbfJaWTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:19:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:54327 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387441AbfJaWTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:19:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 15:19:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="asc'?scan'208";a="400666125"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 31 Oct 2019 15:19:05 -0700
Message-ID: <e75607e9ef5adce6956aed76b3291f798851bc57.camel@intel.com>
Subject: Re: [net 0/7][pull request] Intel Wired LAN Driver Updates
 2019-10-31
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Date:   Thu, 31 Oct 2019 15:19:04 -0700
In-Reply-To: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-XspZPA0Yb4p8XErIMW87"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-XspZPA0Yb4p8XErIMW87
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-10-31 at 15:17 -0700, Jeff Kirsher wrote:
> This series contains updates to e1000, igb, igc, ixgbe, i40e and
> driver
> documentation.
>=20
> Lyude Paul fixes an issue where a fatal read error occurs when the
> device is unplugged from the machine.  So change the read error into
> a
> warn while the device is still present.
>=20
> Manfred Rudigier found that the i350 device was not apart of the
> "Media
> Auto Sense" feature, yet the device supports it.  So add the missing
> i350 device to the check and fix an issue where the media auto sense
> would flip/flop when no cable was connected to the port causing
> spurious
> kernel log messages.
>=20
> I fixed an issue where the fix to resolve receive buffer starvation
> was
> applied in more than one place in the driver, one being the incorrect
> location in the i40e driver.
>=20
> Wenwen Wang fixes a potential memory leak in e1000 where allocated
> memory is not properly cleaned up in one of the error paths.
>=20
> Jonathan Neusch=C3=A4fer cleans up the driver documentation to be
> consistent
> and remove the footnote reference, since the footnote no longer
> exists in
> the documentation.
>=20
> Igor Pylypiv cleans up a duplicate clearing of a bit, no need to
> clear
> it twice.

Double checked to ensure all my SOB's are on the patches.

--=-XspZPA0Yb4p8XErIMW87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl27XdgACgkQ5W/vlVpL
7c5Q4Q//a2TKFNyg6DaFMmSRIX/Rk1BpMErnHwHc0U6hscQmnqdPzeeR+e6dWIBS
t7c4+nA6JYlbKbvJsNSGUWBXpktHLrs4XRufyYhEGMGr3jkkqaJhFWgmfAkyuxKY
QrXekDy2lT8FCAfgT92X26dMo3UDoBfN1vOyXvVBLj07F1cO/pp3m40ZkvqmnG13
OCvYHqYgDeuVROzklyYnnFz6qLQs09POXoC2eC8uGv//W+4WINHfgqCt+nm2bCic
p+4yAyvEJbYZ21jKCc4V6iCFda6LXS8EXlEiUn9CpNZ6LgTn1XlRxec3Iz+mFvIN
S/6HIlnddAPdSDVvvshKMODLfdBIugkMFPUr01UdkoFKvHeRCYyWeakq1nJ/rEqb
vgxf3IzDdUDvUtERK6BKk/l9WSEWxyoObdyxivufZQ44tbCSrcZkoXMmrxd9Rtjo
V7vU6JzBXS1f2mxgjRG6hmTXxRMVNRKBGvVaSg8afbhgU7G3dyCH80K2osnxN+R/
SYUxWhnBZ4Ut7C+KakZofBNb0R0JnMLpXYwdWho2pv530AfASUafsO7CuqkiEDST
cyaa9o8gs/ynXHrRFuAn06LWlwJqs5eI0B+krHnfmXZQUhp5a5E6hYL5Ieq0PlqB
/IdRxKPZAH6eQ8WVHwe0dtdnV+8UcT/1iswcCo1IVvPfCd35xjY=
=jIZz
-----END PGP SIGNATURE-----

--=-XspZPA0Yb4p8XErIMW87--

