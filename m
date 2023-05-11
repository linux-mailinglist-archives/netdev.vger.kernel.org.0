Return-Path: <netdev+bounces-1682-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFEC6FECC6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7A9E281218
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1FF1B8EF;
	Thu, 11 May 2023 07:28:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C47D81F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:28:53 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31913198C;
	Thu, 11 May 2023 00:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683790132; x=1715326132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uJ3+rSSCVgRwRP1p8wI15bvqJ+LZjvxecomrsBtB0eI=;
  b=SATewahYYddKJcPkPKnx0Gdbg5s977dr/VF/upgHA22gjHAg/Rz/l/Im
   XFLdyvpxW4b0Rv2OngVycqUo0hIgrG1oVYsxA9togWPNrlMitMZDEIBgy
   MdYyALVTQLXjeU65NMo0D+mkDaW0FF+DEkH5MhcDhaF7SJupOxdlF/Y/c
   /5QF6CmH/vKjRgSbxCtCZtF7RCNmPjCssGMuvMi88flNS1PhZe7Y9bmRe
   lT07xA550f8V4IS2rfwvSMsUCHfNe8k1atsy+4LsS8ORqlvm9Q3hdjlw4
   eVYNBUfncq9IP0KO5d7UwLpt3tzzYc1CyGJ0mc6xesJwcmDw3CXMh4YIf
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,266,1677567600"; 
   d="asc'?scan'208";a="214819223"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 May 2023 00:28:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 11 May 2023 00:28:49 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 11 May 2023 00:28:47 -0700
Date: Thu, 11 May 2023 08:28:27 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
CC: <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
	<palmer@dabbelt.com>, <git@amd.com>, <michal.simek@amd.com>,
	<harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>
Subject: Re: [PATCH net-next v2 2/2] net: macb: Add support for partial store
 and forward
Message-ID: <20230511-drudge-scrounger-e850f112d497@wendy>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-3-pranavi.somisetty@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SCdDR1RMamuy5fAc"
Content-Disposition: inline
In-Reply-To: <20230511071214.18611-3-pranavi.somisetty@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--SCdDR1RMamuy5fAc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 11, 2023 at 01:12:14AM -0600, Pranavi Somisetty wrote:
> When the receive partial store and forward mode is activated, the
> receiver will only begin to forward the packet to the external AHB
> or AXI slave when enough packet data is stored in the packet buffer.
> The amount of packet data required to activate the forwarding process
> is programmable via watermark registers which are located at the same
> address as the partial store and forward enable bits. Adding support to
> read this rx-watermark value from device-tree, to program the watermark
> registers and enable partial store and forwarding.
>=20
> Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>

In passing, this looks like an odd SoB chain. You are the patch's author
and the sender, what did everyone else here do?
If these people helped with the patch, should they have Co-developed-by:
lines too?

Cheers,
Conor.

--SCdDR1RMamuy5fAc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZFyZGwAKCRB4tDGHoIJi
0h7zAQDofuyYk2C7X+aRDtla/7I1koSaX1omCjWvq9I0kpLpagD/X+kDLq6Wb7XR
M9UpbuAJiYODjZUvbtK1V/SrbnxQOQU=
=CMDY
-----END PGP SIGNATURE-----

--SCdDR1RMamuy5fAc--

