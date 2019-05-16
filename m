Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A3B20F3D
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfEPTfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:35:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:16787 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfEPTfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 15:35:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 12:35:29 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 16 May 2019 12:35:29 -0700
Message-ID: <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
Subject: Re: [PATCH] igb: add parameter to ignore nvm checksum validation
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Nikunj Kela <nkela@cisco.com>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 16 May 2019 12:35:27 -0700
In-Reply-To: <1557357269-9498-1-git-send-email-nkela@cisco.com>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-z4gzyTVe/RxHVRF6YPc2"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-z4gzyTVe/RxHVRF6YPc2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
> Some of the broken NICs don't have EEPROM programmed correctly. It
> results
> in probe to fail. This change adds a module parameter that can be
> used to
> ignore nvm checksum validation.
>=20
> Cc: xe-linux-external@cisco.com
> Signed-off-by: Nikunj Kela <nkela@cisco.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 28
> ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)

NAK for two reasons.  First, module parameters are not desirable
because their individual to one driver and a global solution should be
found so that all networking device drivers can use the solution.  This
will keep the interface to change/setup/modify networking drivers
consistent for all drivers.

Second and more importantly, if your NIC is broken, fix it.  Do not try
and create a software workaround so that you can continue to use a
broken NIC.  There are methods/tools available to properly reprogram
the EEPROM on a NIC, which is the right solution for your issue.

--=-z4gzyTVe/RxHVRF6YPc2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlzdu38ACgkQ5W/vlVpL
7c7ZxA/+PPTvaNQhtRytI+u56SLmQrJVgitUmXA5alK0EjlDbd8qdyb18SqLryUv
IwdXvVKa4L9IwiH7szS10YNgzDDxHB4y5EXWRI3xQvguf7gsTwujOcIyMXGRJAhY
3bHsOXmMYdwQHosm7iybtUyNjwYLS3BUqVCpUl5FvXgZnpSNqmHpCP8T/Lx0Rr+D
LeM2w5Q0g8IVVhXGPEhaVsI4QYFekfLBWAJpv/5vT9DTqmIUILssRGbNe2OMopb3
VCLaCRGbs3e9v8BMtRd5pU7F/Joo5g8zaHOtyGeUFkd4+zFD7STlrNAlbtQsi5no
SSwdCCDuljlQkCKiLrutlsuOEJstaN0Ix8bOx8RiMW20asDf76GSGBUbZxDDpjew
VCBrzNSbI/vFC8vSdDyWMB0LyuC7ZTCD39nrHyqTJazogkPjEH7usUs93MqHoJ1l
3Iv1WQgThHl9r0aZYQw4/DzJ3triye2iDnyZ8d2gjlwxA124BFtJumPDzGfKwjJq
U+GfCkYZ4CIbJS3VorNW8bSFvRVMc5ZM3xW2rnvUIXUILwTC6ziUdaOrvAqye58k
VV5FWfE7N6/0ntbQ5vAS5xaP6L1xCCi/Zd5jNzYrc/I0+WIlG0q49lY31KHfLIW0
Y5fKAAKkEu7HY442WEWhJZViQtDSgAkxrX/5Z4BpkCtiaRBdn8Q=
=4Goj
-----END PGP SIGNATURE-----

--=-z4gzyTVe/RxHVRF6YPc2--

