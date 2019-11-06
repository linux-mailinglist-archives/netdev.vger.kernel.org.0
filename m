Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2747CF22DD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732433AbfKFXt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:49:58 -0500
Received: from mga17.intel.com ([192.55.52.151]:33197 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfKFXt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 18:49:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 15:49:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="asc'?scan'208";a="233058262"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 06 Nov 2019 15:49:57 -0800
Message-ID: <327bddf3762b297cc106123e5b0e090c8bf495dc.camel@intel.com>
Subject: Re: [net-next v2 00/14][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-11-06
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     davem@davemloft.net,
        "jakub.kicinski" <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Date:   Wed, 06 Nov 2019 15:49:57 -0800
In-Reply-To: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
References: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-8ekChnq11Ec272kiqvK1"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-8ekChnq11Ec272kiqvK1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-06 at 11:37 -0800, Jeff Kirsher wrote:
> This series contains updates to ice driver only.
>=20
> Jesse implements set_eeprom functionality in ethtool by adding
> functions
> to enable reading of the NVM image.
>=20
> Scott adds ethtool -m support so that we can read eeprom data on
> SFP/OSFP
> modules.
>=20
> Anirudh updates the return value to properly reflect when SRIOV is
> not
> supported.
>=20
> Md Fahad updates the driver to handle a change in the NVM, where the
> boot configuration section was moved to the Preserved Field Area
> (PFA)
> of the NVM.
>=20
> Paul resolves an issue when DCBx requests non-contiguous TCs,
> transmit
> hangs could occur, so configure a default traffic class (TC0) in
> these
> cases to prevent traffic hangs.  Adds a print statement to notify the
> user when unsupported modules are inserted.
>=20
> Bruce fixes up the driver unload code flow to ensure we do not clear
> the
> interrupt scheme until the reset is complete, otherwise a hardware
> error
> may occur.
>=20
> Dave updates the DCB initialization to set is_sw_lldp boolean when
> the
> firmware has been detected to be in an untenable state.  This will
> ensure that the firmware is in a known state.
>=20
> Michal saves off the PCI state and I/O BARs address after PCI bus
> reset
> so that after the reset, device registers can be read.  Also adds a
> NULL
> pointer check to prevent a potential kernel panic.
>=20
> Mitch resolves an issue where VF's on PF's other than 0 were not
> seeing
> resets by using the per-PF VF ID instead of the absolute VF ID.
>=20
> Krzysztof does some code cleanup to remove a unneeded wrapper and
> reduces the code complexity.
>=20
> Brett reduces confusion by changing the name of ice_vc_dis_vf() to
> ice_vc_reset_vf() to better describe what the function is actually
> doing.
>=20
> v2: dropped patch 3 "ice: Add support for FW recovery mode detection"
>     from the origin al series, while Ani makes changes based on
>     community feedback to implement devlink into the changes.

Sorry for the thrash, I will need to generate a v3 of this series.  I
need to drop patch 1 of the series as well, since these driver changes
will be affected by Ani's work to implement devlink into the driver, as
well as we found a bug with this particular patch.

--=-8ekChnq11Ec272kiqvK1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3DXCUACgkQ5W/vlVpL
7c7h/Q/9F0RmgIBq8qoHft8LzjKBxPKZMM6yry3vd/cPRDmwdzbO/Ow5thsalvu/
+/pT6ViEaF00sZZFz+68Ym0AMLbCoG4llxBYijeJAh7L2/fvEGaMiE6XTDf9uN5D
d7DluG31Pv5NA33fPDRA/vg892r4vjtsV9CLbIqsDWJHOrY5fA+FZiyqLyeb/BDH
zk6dK2Yd3FxNbZpA/5rEpzHhonvcjeJQvlsMS6ufSUyuBkrmt7PC+k32NsNsAZUe
H8TsUODD4ihIhVYDBqnfNPK1n/sRy/o50QkBYSpx6HAp1xEEeTfO3Sd3Ba48qeJq
vPwM+1Yrtn6SGPcCgXGkKEDiSHJPFrAE1+F+3n5M8a62wVzGSVd9tmBNHozRWp5y
JHynP1x2vwi0hyxquUOPSKkJT1q3IPZI3sUs3i83WLmMwcFRmKXzy20hhARqLK+I
yYkGJurGzMatkPJcWhTmm/fBs7bxqDlI+74oUFx/1oc/n8JdILEfEFD4mOUIbPYs
2PMscdsDQHN1TqKUMejvHXXINmVgHtuUNRMx+sVzqNwFkAVJag/11Tvq3rI7Awt/
WXV+EnRcQd9+LFLmrUs8/0qO3kIkTFCBy0M5aiCYaGRFxeYRtA1T0acoQm9VAOzd
SsiZr+YmM5TZLm231R+slVbC1Hv2apn8z7zJRmf7BNX/5ZIN4Lg=
=8qFk
-----END PGP SIGNATURE-----

--=-8ekChnq11Ec272kiqvK1--

