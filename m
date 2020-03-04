Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4576417978D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgCDSIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:08:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:8060 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgCDSIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:08:11 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 10:08:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="asc'?scan'208";a="352153660"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 04 Mar 2020 10:08:10 -0800
Message-ID: <554e1a91bd0d4256720060d513f6d0fdd1d1c884.camel@intel.com>
Subject: Re: [PATCH net-next v2 08/12] ice: let core reject the unsupported
 coalescing parameters
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 04 Mar 2020 10:08:10 -0800
In-Reply-To: <20200304043354.716290-9-kuba@kernel.org>
References: <20200304043354.716290-1-kuba@kernel.org>
         <20200304043354.716290-9-kuba@kernel.org>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-y5pzeiTp8SN4r7bxr7tT"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-y5pzeiTp8SN4r7bxr7tT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-03-03 at 20:33 -0800, Jakub Kicinski wrote:
> Set ethtool_ops->coalesce_types to let the core reject
> unsupported coalescing parameters.
>=20
> This driver correctly rejects all unsupported parameters.
> As a side effect of these changes the info message about
> the bad parameter will no longer be printed. We also
> always reject the tx_coalesce_usecs_high param, even
> if the target queue pair does not have a TX queue.
>=20
> v2: allow adaptive TX
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 59 +-----------------
> --
>  1 file changed, 3 insertions(+), 56 deletions(-)


--=-y5pzeiTp8SN4r7bxr7tT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl5f7ooACgkQ5W/vlVpL
7c48WQ//ZIVFryzEkFJpu4fB99rMG2fqicmmzQiW9+wPhbfl3C3xxQ56ukeuDuhY
jtHHovaARjEq0ItpwttKaEaCORN0EPlPhFhsZmwQ/yhUWuRIaGHbNKyMOg2pLJE1
c5KQx2CXL+pLlp1qhWPs4yeqk/3tLByOiTTbb192GZme+toDAfD6rfAJUfrqiYgK
2KM5S3GD3rkfAcnPyI2X8C1eg2eNFnNgkFy9FZBpNtBhxfOrlESkOoVXQ8i/iC3N
glbUSxeuRIHhNnJBvPRygxb2i99HTBc0KuQFj8ElnJBBf4fS85B01juVm/u4nYF5
Cw70T2J/5+xBQkdxjpn8J804G25GpSG5YmQ/AoCixIvQdYG1m7efNUwfngimPuKF
aMnC8mZJxcCfkTER0utE5KqbmQyYXobckUjsEGpcCQ58OPFK05C4A04nrzo63MHF
f1T+OwUTM9n/gDcPDsoeFp040HqKQ0dSvAC99uslkCry0XX57WyHKRJmFhiuYPx+
QIjj+GVH0C4RbLAjv3FObvQ1Ldic6a0ImkiRqaev9vRIa/4FuSU6eHkBUAAygzbh
qxLfC1n4Fv4t4cXy9ceNXhHUCT2Bl6mRZoQiVeE5vvRe2RNMJRtMXRvJ03DOksgB
Xa9iiyjorEEiNo1sPeB9heEJTLJqu442NYQeNhGPxmQzw2GlOnU=
=h0Hu
-----END PGP SIGNATURE-----

--=-y5pzeiTp8SN4r7bxr7tT--

