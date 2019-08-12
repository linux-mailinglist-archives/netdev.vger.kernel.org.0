Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78CD8A295
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfHLPq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:46:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:37776 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfHLPq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 11:46:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 08:46:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,377,1559545200"; 
   d="asc'?scan'208";a="178379626"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 12 Aug 2019 08:46:55 -0700
Message-ID: <96c726571a7372a763db5ac7a6aa447911cb894b.camel@intel.com>
Subject: Re: [PATCH v3 14/17] fm10k: no need to check return value of
 debugfs_create functions
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org
Date:   Mon, 12 Aug 2019 08:46:55 -0700
In-Reply-To: <20190810101732.26612-15-gregkh@linuxfoundation.org>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
         <20190810101732.26612-15-gregkh@linuxfoundation.org>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-TP5enwrva10FVHjMa2s9"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-TP5enwrva10FVHjMa2s9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-08-10 at 12:17 +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic
> should
> never do something different based on this.
>=20
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c | 2 --
>  1 file changed, 2 deletions(-)


--=-TP5enwrva10FVHjMa2s9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1Rie8ACgkQ5W/vlVpL
7c6bPg/7BF9EYDdpaiAlL4I8rUBAtfVu37dFgSjiXWwI3QrWhNmVPwWz/jFBnMhO
CruByStXZ6WX41QmixQtCdhC1KTvDeJZ8vklVCVvrcdnbjOp5klWd/p8Dy5Z6qEO
U7r/tXI+UlLfCOqYVhL54NWxPoqPQSFQk71w7qCpljOWOKRBWsg2xuFz/IsynD9l
F4hju6mHAPM+VGj6Q3g1VJFq1ZII954iV2lMqBGCEkQ5k3FSAtwjxqBoeEE4LaSH
Ku+x6m/VdWy3ffMd7og4Lfqyx90zlda2xMiXIgC1fgAWZexqw8PwnEFD0Z754+4Y
xhMmZmfchAkHyXbiAme3xGmgHnqwVFl9frJriW3/Adcx6c6a2aqEPjTdklDYv+G9
zOvdRDdVP+o8hheycYz9kcP0CJb/vwTpbaL521Tz03op8Vxdx9IrvEJdScT3hlI7
h6s5sQ09FtzZdQYWOcp+8FdH2ELP6tqnfqWUXBLhGLAnUHtdk0eo1NhRNhr3VuuQ
itruAkQZ5Em3X8vNivC/UMJT6o/z0YsSTZojMbjc6sDOYuPPI5pby16bpgmSZxio
KWtZv31RGg6Zl2ljw/IW4OWgAO3ifskpUwBHzgHO9aOHF5yaJ/VxPLxTB+wnvBqL
iCjmI4O6PR3CWo/heNlULWmQl46p5hwylBKOvtSNhhpKcCb5ZNA=
=FAT3
-----END PGP SIGNATURE-----

--=-TP5enwrva10FVHjMa2s9--

