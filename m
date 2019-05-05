Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2366313C93
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEEBXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:23:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:64242 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfEEBXJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:23:09 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:23:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="asc'?scan'208";a="343683608"
Received: from vbhyrapu-mobl.amr.corp.intel.com ([10.252.138.72])
  by fmsmga006.fm.intel.com with ESMTP; 04 May 2019 18:23:07 -0700
Message-ID: <7aeaec2041875afecbe63301dc51809aa1a3a93d.camel@intel.com>
Subject: Re: [net-next v2 11/11] i40e: Introduce recovery mode support
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alice Michael <alice.michael@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Piotr Marczak <piotr.marczak@intel.com>,
        Don Buchholz <donald.buchholz@intel.com>
Date:   Sat, 04 May 2019 18:23:06 -0700
In-Reply-To: <20190504073522.3bc7e00d@cakuba.netronome.com>
References: <20190503230939.6739-1-jeffrey.t.kirsher@intel.com>
         <20190503230939.6739-12-jeffrey.t.kirsher@intel.com>
         <20190504073522.3bc7e00d@cakuba.netronome.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-xPeOpsrLU2bXUqCatDDm"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-xPeOpsrLU2bXUqCatDDm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-05-04 at 07:35 -0400, Jakub Kicinski wrote:
> On Fri,  3 May 2019 16:09:39 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >=20
> > This patch introduces "recovery mode" to the i40e driver. It is
> > part of a new Any2Any idea of upgrading the firmware. In this
> > approach, it is required for the driver to have support for
> > "transition firmware", that is used for migrating from structured
> > to flat firmware image. In this new, very basic mode, i40e driver
> > must be able to handle particular IOCTL calls from the NVM Update
> > Tool and run a small set of AQ commands.
>=20
> What's the "particular IOCTL" you speak of?  This patch adds a fake
> netdev with a .set_eeprom callback.  Are you wrapping the AQ commands
> in the set_eeprom now?  Or is there some other IOCTL here?
>=20
> Let me repeat my other question - can the netdev you spawn in
> i40e_init_recovery_mode() pass traffic?
>=20
> > These additional AQ commands are part of the interface used by
> > the NVMUpdate tool.  The NVMUpdate tool contains all of the
> > necessary logic to reference these new AQ commands.  The end user
> > experience remains the same, they are using the NVMUpdate tool to
> > update the NVM contents.
>=20
> IOW to update FW users still need your special tool, but they can use
> ethtool -f to.. change the app-specific (DPDK) parser profiles?  Joy :)
>=20
> > Signed-off-by: Alice Michael <alice.michael@intel.com>
> > Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
> > Tested-by: Don Buchholz <donald.buchholz@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

I will see if I can get either the author or one of our tools developers
respond to your questions while I am on vacation (all next week).  If not,
I will respond in a week.  Sorry in advance, if you have to wait for a week
for a response.

--=-xPeOpsrLU2bXUqCatDDm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzOOvsACgkQ5W/vlVpL
7c7UFw//Z6Fe3bXcPPi8aqUItQyUnBmEazY1gv3gLdFKwjIbbCYLYjEecf65Zjr/
P6vc9/GkexhZMNA5/Es3XMpkxQzeqAKws1ioAtaAAhez7mw23ueIe9OrE/fUsXc6
EQgHheycrwXomkuiaEzwcxa6JMspA0o46JGD3mpahFQhsbBezceTjoh1+zcQk2Ed
PMxABnFrXWxTb2PO6tF9QFHRVb2Gqm6yNrE46i/FYjCLoSmroyPpEbUIt8Kd5vZq
GRMrneqOZV4aqt/Zxw86AWT9GkjurW6fZcrJFLdEVouI9A3ZhK7XbKkJeCFpYEBT
eYUcGTtoZFZWQMFbbR6ztVcYUUfJ/e/QZQY7tj02wckWef56oH8A1zOkwxeAORcy
hZrQm2bSmRGiWJlPZJa3mYHOrT1A9xzJksu9fR24AxV7ytliVm5uzM6ThpQC4imD
dXe/e8ZptdpGSlsXc7Uwv1LDcub9rHCEBwMFU3NBLugXKE+4QBtLaZDUvenAGtLw
n/OiAT7b5V87x3rBhMqinJDXTMQWYtVbKJbWkxKDCL44SSMN4QDlKK/D8WVqMjri
BtkKra/89NQVxvBHmlPtZdy2YoXcBoGUlX4j/aQOhrnLbBwlesrcxvR45B2Nh8Dq
xvsnWb8UCeUQyN0EwZnuCkHM9S0g9fPzXKyBv51duK00ZYqE2+U=
=yRF5
-----END PGP SIGNATURE-----

--=-xPeOpsrLU2bXUqCatDDm--

