Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AB5EEAD8
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfKDVPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:15:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:13261 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfKDVPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:15:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:15:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="asc'?scan'208";a="204738833"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 04 Nov 2019 13:15:07 -0800
Message-ID: <1d1008bf581260ef00704f45ad062681b9736ddc.camel@intel.com>
Subject: Re: [net-next 5/7] ixgbe: protect TX timestamping from API misuse
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Mon, 04 Nov 2019 13:15:07 -0800
In-Reply-To: <20191104115352.49129186@cakuba.netronome.com>
References: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
         <20191102121417.15421-6-jeffrey.t.kirsher@intel.com>
         <20191104115352.49129186@cakuba.netronome.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xL59Bpj31tIvHRrQLsQX"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-xL59Bpj31tIvHRrQLsQX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-11-04 at 11:53 -0800, Jakub Kicinski wrote:
> On Sat,  2 Nov 2019 05:14:15 -0700, Jeff Kirsher wrote:
> > From: Manjunath Patil <manjunath.b.patil@oracle.com>
> >=20
> > HW timestamping can only be requested for a packet if the NIC is
> > first
> > setup via ioctl(SIOCSHWTSTAMP). If this step was skipped, then the
> > ixgbe
> > driver still allowed TX packets to request HW timestamping. In this
> > situation, we see 'clearing Tx Timestamp hang' noise in the log.
> >=20
> > Fix this by checking that the NIC is configured for HW TX
> > timestamping
> > before accepting a HW TX timestamping request.
> >=20
> > similar-to:
> >        (26bd4e2 igb: protect TX timestamping from API misuse)
> >        (0a6f2f0 igb: Fix a test with HWTSTAMP_TX_ON)
>=20
> This is not a correct way to quote a commit. Please use checkpatch.

Just an FYI, checkpatch.pl does not complain about the above commit id
references.

--=-xL59Bpj31tIvHRrQLsQX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3AlNsACgkQ5W/vlVpL
7c5ndg//V+nKChc1x6BTomWyqdB9FcdAXODoCUOb9XrBbdjUN62OVpfsnnNQaKvW
9mHCeXFSucuCa7Jb+pX3uOj3tSftkBq+6p/hIE4poCkb7OpSuHTu8WgD/SOL2gVG
cx6Mgg4jnXt234EmzUX4oXxIKXb/G8ZAX/XbQKr7jwvJgM1LCZWniLHTT2stcOdE
aGJxYWOFVe0QMlDofaDVyPivc2h30MCvpjPIfxnACuWOjj6PvdEZZ0pDWzrXLmcg
py5FWztPbuDuvumaKHBsqnhqm/yEg62JTsGc0tFTD0cqgzBvzAto6mg/BC1QAVJd
ThxqBDvrQEaUKVgivPwjgFkxRpTgre9M05F4D4Wt1jKKEcNq2d9urP8d8UyKLCk0
DSj1ILvcAJrtIRT52sI2//rD5u9pp/bhuNmNNooyGTOPVq8ZatF80YifSGGK9GFK
KpGLEF0hHbrhxWMC1V7b01D1iiZ5wq2uO/H3m1MinNPaFgYRGyr4cEGWLfpjNZqL
Ik5oBkAJtfcgt6/QgK6T6gJHEAug+AuSEYPCBz+JgHGAdE4ToBvigjzfhEU5CzOi
ZSFFJ5c4OkEzcN4OSjVaAUSfEPm14jHHvvd17wJhswH1Tk78boY1Fs9X7e6rpNrU
vhFRaWEuOJYBC3lRfYgCLvsLReMyrxsAJxUtD5uZZoNEvKty+Hc=
=tdBM
-----END PGP SIGNATURE-----

--=-xL59Bpj31tIvHRrQLsQX--

