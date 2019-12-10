Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E08118F80
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfLJSHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:07:00 -0500
Received: from mga04.intel.com ([192.55.52.120]:18183 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfLJSHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 13:07:00 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 10:06:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,300,1571727600"; 
   d="asc'?scan'208";a="264613838"
Received: from dssnyder-mobl.amr.corp.intel.com ([10.254.45.55])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Dec 2019 10:06:41 -0800
Message-ID: <324a6a4c7553cea5225b6f94ff224e155a252b36.camel@intel.com>
Subject: Re: [net-next v3 00/20][pull request] Intel Wired LAN Driver
 Updates 2019-12-09
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, parav@mellanox.com
Date:   Tue, 10 Dec 2019 10:06:41 -0800
In-Reply-To: <20191210172233.GA46@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
         <20191210172233.GA46@ziepe.ca>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-OTL8bKDFxhcCLS247rmA"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-OTL8bKDFxhcCLS247rmA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-12-10 at 13:22 -0400, Jason Gunthorpe wrote:
> On Mon, Dec 09, 2019 at 02:49:15PM -0800, Jeff Kirsher wrote:
> > This series contains the initial implementation of the Virtual Bus,
> > virtbus_device, virtbus_driver, updates to 'ice' and 'i40e' to use the
> > new
> > Virtual Bus and the new RDMA driver 'irdma' for use with 'ice' and
> > 'i40e'.
> >=20
> > The primary purpose of the Virtual bus is to provide a matching service
> > and to pass the data pointer contained in the virtbus_device to the
> > virtbus_driver during its probe call.  This will allow two separate
> > kernel objects to match up and start communication.
> >=20
> > The last 16 patches of the series adds a unified Intel Ethernet
> > Protocol
> > driver for RDMA that supports a new network device E810 (iWARP and
> > RoCEv2 capable) and the existing X722 iWARP device.  The driver
> > architecture provides the extensibility for future generations of Intel
> > hardware supporting RDMA.
> >=20
> > The 'irdma' driver replaces the legacy X722 driver i40iw and extends
> > the
> > ABI already defined for i40iw.  It is backward compatible with legacy
> > X722 rdma-core provider (libi40iw).
>=20
> Please don't send new RDMA drivers in pull requests to net. This
> driver is completely unreviewed at this point.

This was done because you requested a for a single pull request in an
earlier submission 9 months ago.  I am fine with breaking up submission,
even though the RDMA driver would be dependent upon the virtual bus and LAN
driver changes.

--=-OTL8bKDFxhcCLS247rmA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3v3rEACgkQ5W/vlVpL
7c6Ypg/+PSeQoqTj7hqPY0EBgLsZEpeCmVppaaeUkTATK0mjOD1NrNfnwTTXBIGB
cUKkszb+Q/jqYDHIwXG2dZt+nlTAdvd0y+F7OkxU19GupImReBxQ73nME1uUx4Um
0ZWsDD7PfJ6qh0itBxaFB4e3DRAp2wxKszdZ8KtAjJeNQwgKU733t+VC2rsbxwwc
F39clibEfwcGc64twOCam27wdg2paz1bgpqFFazOzGhUYUrJcqQ9GtMn5TUW6h14
So745EIwkTjPOsj8wsCEEuqLeDmXe8xYNhmZ9ON/14e39rHXRqEJSl0hLgHITMp2
PG1kVk6zMu1JW5+Mnkz0PWfFRcfXBI/Um1mcXLmV0jNvL+XPleoTJYqVGjNeocX1
BZqaTi4WrNg6RA2Il2bLIE5VCQcATgr93cE8i4MSEhjigj+E+yChuxNas1o1k88W
KFMKxszjvfnPWRGCzJs8lujDQUpxvSlHBijY/x8qarj/w3c5m9XqrSChX/AJ9N7V
maGXLjSaAfLoLM8aobiW/UAX5SBbzUgpJ75tsQf7M68nmeH0j95dYIvq9YzqDOTP
EiY6BEMOeXPXL5TxRI9wttQEoW8DQy5ORHH9O9bZ/xT9LZmJ5OX1YLE+AJGx3Sf/
LbopooM6+DZlzLwpnG8lDmV5DCh9tqYseWjZf9nOpLt0ka5UjsU=
=zz7Q
-----END PGP SIGNATURE-----

--=-OTL8bKDFxhcCLS247rmA--

