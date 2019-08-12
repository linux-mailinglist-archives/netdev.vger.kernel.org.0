Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4D918A2AF
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfHLPw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:52:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:17537 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfHLPwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 11:52:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 08:49:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,378,1559545200"; 
   d="asc'?scan'208";a="200178298"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 12 Aug 2019 08:49:35 -0700
Message-ID: <1ddf059408158e6a1819f222127b353476110ba4.camel@intel.com>
Subject: Re: [PATCH v3 16/17] ixgbe: no need to check return value of
 debugfs_create functions
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org
Date:   Mon, 12 Aug 2019 08:49:35 -0700
In-Reply-To: <20190810101732.26612-17-gregkh@linuxfoundation.org>
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
         <20190810101732.26612-17-gregkh@linuxfoundation.org>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-EOUtTASVq+viiz5NfBUM"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-EOUtTASVq+viiz5NfBUM
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
>  .../net/ethernet/intel/ixgbe/ixgbe_debugfs.c  | 22 +++++----------
> ----
>  1 file changed, 5 insertions(+), 17 deletions(-)


--=-EOUtTASVq+viiz5NfBUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl1Rio8ACgkQ5W/vlVpL
7c73CQ/+MRQwSGF5f4EP5Z5xB+mOP5Ik7hfozeweg8oRT1+81W3b6rUlHc7Lm/0p
tMHpLpGkZj/+Mis6IF07QCWZCszCf6ViCt1TWBzF200tbbcXZGQMfy2jr0ng5/vH
oftOvfvKR2UdzYwXNENsn6/unL4Drx7HM1Tfgd+qK1t1WpRWy4JS4p/6EP3gaqxy
yyoLFK4g8gI9AQBokCH4QWgifONAoy9Uq5djlh3nl9p409M12Y2JN4Gb2cbzZ6Aw
pxK6nEfz8FiwRIlNstL20Hb2GSb6yY14SnvQipGwfwJL/KOZB2HCsgo7rrjzTFPd
KHUvFDN1uiX7A14j33Nyosr5J7cr13ZdgsSQf30rZQ7AWMRbqZVBIdgYUA6EGalT
6r4cF2RwCHiVLxrVDXLilNIGJju0g2A6op6huTdYn6sSmnuN8rZstrgWWkKqUVWB
VnhqVQNDJ/zD9J9PWKgyEqiWXvQf3MmfwCn2kefdxzB17Oliu5d14XAhqvjjW9pr
cX2mX7HNATe+Fk1Q5zpOIULXxjnNSdv4kItuvZjiONZM7yoUMMHzajAckOj4HnDA
+Q746vqjwwA77xOl+dVLiU7FIGOQ57nDaWRbyutxH9OkhQz1JI7Qht7uotwt68Sm
BeQfnnVGK+at578k+vCoaAhWMAB+XNsKqyMyOWMkgd/wG+RCy0E=
=mVRo
-----END PGP SIGNATURE-----

--=-EOUtTASVq+viiz5NfBUM--

