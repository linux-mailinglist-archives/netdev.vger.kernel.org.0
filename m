Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5783C249F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732112AbfI3PqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:46:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:14565 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731865AbfI3PqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 11:46:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 08:46:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="asc'?scan'208";a="181394397"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 30 Sep 2019 08:46:18 -0700
Message-ID: <30473f53cd3bc46f87c4fe87587acaf0aa90741f.camel@intel.com>
Subject: Re: [RFC 00/20] Intel RDMA/IDC Driver series
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Date:   Mon, 30 Sep 2019 08:46:18 -0700
In-Reply-To: <CAJ3xEMgJrj3JT-NS7xf8cpAWrQzDi-UAQ0f8S1rsk9Mv7jCsgA@mail.gmail.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
         <CAJ3xEMgJrj3JT-NS7xf8cpAWrQzDi-UAQ0f8S1rsk9Mv7jCsgA@mail.gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-kuaUc1E86xtWAwuFki4g"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-kuaUc1E86xtWAwuFki4g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-09-29 at 12:28 +0300, Or Gerlitz wrote:
> On Thu, Sep 26, 2019 at 7:46 PM Jeff Kirsher
> <jeffrey.t.kirsher@intel.com> wrote:
> > This series is sent out as an RFC to verify that our implementation
> > of
> > the MFD subsystem is correct to facilitate inner driver
> > communication
> > (IDC) between the new "irdma" driver to support Intel's ice and
> > i40e
> > drivers.
> >=20
> > The changes contain the modified ice and i40e driver changes using
> > the
> > MFD subsystem.  It also contains the new irdma driver which is
> > replacing
> > the i40iw driver and supports both the i40e and ice drivers.
>=20
> Hi Jeff,
>=20
> Can this be fetched from somewhere? didn't see a related branch at
> your trees with these bits..

I can make these patches available, I had not pushed them to my tree
because they were RFC.

I will push these series of patches to the "rdma" branch of my next-
queue git tree on kernel.org.

--=-kuaUc1E86xtWAwuFki4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl2SI0oACgkQ5W/vlVpL
7c7Pmg//ZbsdLzhA4yeSv9dRD6dv7fvY61TBrWVOqp4C/Qt9N7Zz6081k3H8EIdW
NJ4ErvTEUYjJqooondLy42oD31mXr8eY6KRy7p1GnKlqswnV7MRI5Zzx32RD0tD0
Peizjkl+CSZix7o0JRSnqcHXkHn0RzMKFw5/Xolt2Mu4sFI8wpsknA64mXaaqv6Y
4v3TZiwNmo5S+nnY4IrbqSAW4prOhjlyzYihqx0teQ7vhbRaSydlXME+qMC2qi7V
RXVYvBGecJ5gWlHS29B6vzLOADP2+RNXWSyxMtfp3t56Da8yCXYa29EN5OQLo1p1
7Q1waCbHLg4nF/kRHmxBf1ikFzabLFOMIs3PJxUT7PfhE6/5A8UGAuO7B49ausQC
LW0SMmevu5zlQNY9dDp6Q6zRdq7z518RQcNuuwLz8523hzLBhcWB+IrHZwsrrNCd
/dVysFu0OToXyz8apljK1dnILNss3TomP1qIC5zm0T4m6Q8Tp4+I7pI3i7dY0DnF
Mm0qLy6APjC/SR13yjmuQwBr8Q95hgaoYKXmG929CIYoI5qX2FH4pve8aRNesWJU
tM2NkjTTtBQEbGkJ/l+9rZDgHqp8LfgNH49wQEBZFl5CEjJ2BaP58guCw0+wufSd
NRn5ay/u+lbGCKxyX1sQ8CZc+jsXz4oqa5bdiY2Ifyap+2MmV0w=
=OHFM
-----END PGP SIGNATURE-----

--=-kuaUc1E86xtWAwuFki4g--

