Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C527328D7A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387966AbfEWWzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:55:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:63184 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387693AbfEWWzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:55:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:55:09 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 23 May 2019 15:55:09 -0700
Message-ID: <f8d774415fcb66c46ebc08a9b66f32d825c004ac.camel@intel.com>
Subject: Re: [RESEND PATCH] intel-ethernet: warn when fatal read failure
 happens
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Feng Tang <feng.tang@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron F Brown <aaron.f.brown@intel.com>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org
Date:   Thu, 23 May 2019 15:55:15 -0700
In-Reply-To: <20190523032233.29277-1-feng.tang@intel.com>
References: <20190523032233.29277-1-feng.tang@intel.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-y1OFu1nRmlcChIbRxZiy"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-y1OFu1nRmlcChIbRxZiy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-23 at 11:22 +0800, Feng Tang wrote:
> Failed in reading the HW register is very serious for igb/igc driver,
> as its hw_addr will be set to NULL and cause the adapter be seen as
> "REMOVED".
>=20
> We saw the error only a few times in the MTBF test for
> suspend/resume,
> but can hardly get any useful info to debug.
>=20
> Adding WARN() so that we can get the necessary information about
> where and how it happens, and use it for root causing and fixing
> this "PCIe link lost issue"
>=20
> This affects igb, igc.
>=20
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Acked-by: Sasha Neftin <sasha.neftin@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>  drivers/net/ethernet/intel/igc/igc_main.c | 1 +
>  2 files changed, 2 insertions(+)

This patch is already in my next series of 1GbE patches to push to
Dave, so you can expect this to be pushed upstream before the weekend.

--=-y1OFu1nRmlcChIbRxZiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlznJNMACgkQ5W/vlVpL
7c7v5Q/9F2bwo0bdt/sXDiOiWfpgLcTVVN3sYMsjzDHCJCZQAEZuGEvlnhl6GIgc
KwYrE0Am0ZvnhMtX6KYi29f51EZo3fpZ979hAUAZlIFBLgBVtg4F/j5YdpL283ku
U2c2MpnoDZEvlRjaOIzUsqygNmif9jNqsTINKazBm2FFm8qBMXPhJ3ivUWAmYx6J
AyyeoHDUUohDR4JxIdQkOiNumbaFszgNa6Rek5E8VV7jgujCic9TRV+SkvAYNViU
tDqBgoJJGlyHOUmJEYlW8EiHF+hQ8n03ycAct/57lU0BjDizZVBktdvxdSura3MP
klr1PTiuMwLMFaH+YzgVD+fuWplAALbrqhDtXpqG471Q+q0twvU1HIWIjOywjzxY
Lo9G3Ru0HBwyhELGotBi8NzsE3/w950jKefSYv37CzYKIAr6EwgvJydG1tW2VubW
s5jcDdxrr0qbSY1v5eI8HlKvcFKYRw+LYyHeOEVR0DLs8mXEker9qzluG4OBNm9W
URQN5F/Myy8pejMOQPCqSFyWSCzxddCzUy1KPaIUN82pIdz3pfMgQZfaseOH4GyV
/bzaXPU8EXAtjan6/P6XDJ71AW3+VSXIcfEC1UAV/9VAu8GY1N4aJym85NPCRyKD
tW1jAIXiErijG8ddQ0zHuv2kDT82mG8ggklcjElIIBu/ULE3GPc=
=3A37
-----END PGP SIGNATURE-----

--=-y1OFu1nRmlcChIbRxZiy--

