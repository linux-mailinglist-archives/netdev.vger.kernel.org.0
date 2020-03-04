Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7017978F
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgCDSI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:08:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:57799 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgCDSI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 13:08:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 10:08:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="asc'?scan'208";a="439215936"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2020 10:08:57 -0800
Message-ID: <679f633864d4c3d2fe4a871aa5f289c8f1126516.camel@intel.com>
Subject: Re: [PATCH net-next v2 11/12] e1000e: reject unsupported coalescing
 params
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
Date:   Wed, 04 Mar 2020 10:08:57 -0800
In-Reply-To: <20200304043354.716290-12-kuba@kernel.org>
References: <20200304043354.716290-1-kuba@kernel.org>
         <20200304043354.716290-12-kuba@kernel.org>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-K8+cTYJ4tqgXWdX5KCWF"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-K8+cTYJ4tqgXWdX5KCWF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-03-03 at 20:33 -0800, Jakub Kicinski wrote:
> Set ethtool_ops->coalesce_types to let the core reject
> unsupported coalescing parameters.
>=20
> This driver did not previously reject unsupported parameters.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> ---
>  drivers/net/ethernet/intel/e1000e/ethtool.c | 1 +
>  1 file changed, 1 insertion(+)


--=-K8+cTYJ4tqgXWdX5KCWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl5f7rkACgkQ5W/vlVpL
7c48BRAAnfSygfIfSVCw9mgg3kc/qyEsFxgzptVBvFYiDm80EKfreRpceo9ORK2V
V/nbywRpzRVXXeSjyVIawT7Uirq3Thd68Kbq6Iw1Nse2xRtsqyzTZMwZioi7h3ZI
D5iXH8nPkTyGFhOliw+k+tHHse9xXZ4/eo5mf9P9oBsPmmsvV1OX7ByDVPr1OJ1c
upLnsQUaK/Vsx3uoswWPCAHz+mIeqrenkTMF5nSpXq9015vcxkgGQbGUFO2CcAkV
kMSA6zQ31HO3bqx5qwwjfUyYWGLTRVBSovbGjgYp9P9vm6pTgo3SU8qNJdlRVp3v
EdawuT4EjU+XjwSPOGTn7Ix+Ma+jfbGJYRG9rUvzT1EzlFqabxGNy2hL6Wo1ilUT
qQ9RmScALBPFBqXouYPcvkJoLDWNomL6wbflKzSrctihpCX+5m/0jsjSBWk1GO6v
qvIqYh1pJZzacgEQ7vhscQhGovJvyitJqW8GIJaFrBTPjz4v/0my0CxBgkd8uuDK
FUUTe+y6AqfCKsVsmDoLjYsFoa1MROH/ZwZbkmrbuCokzFCScCRP3eYz2mL7CaMy
YG3mi7fFvvKC8gFf67vRvmiltzr295myP5InXbehAaFtHu8LGrsN11c9I2G328hq
X5LrDmmngdNm56pKKnYEgh15Je0L/acjYpppzaaLoT2bOzC7g1s=
=tngV
-----END PGP SIGNATURE-----

--=-K8+cTYJ4tqgXWdX5KCWF--

