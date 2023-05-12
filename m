Return-Path: <netdev+bounces-2147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 079447007DC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EC081C211B9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F01DF52;
	Fri, 12 May 2023 12:27:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285DF7F0
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:27:56 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F54D059
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683894433; x=1715430433;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2gN6/ZEo7C7dYWYazAIa1eFMKtUGi5tXHCpJLLZ9MVE=;
  b=TQ/h9qhTlgUkgPezwJ3f7WjxPZrkFSdh+RfoC1GRPBuIBK0zi/EqdW4s
   ZYn/XcKSrT7MAHKcokvQxy/Qa2zWA9yTrEaO+DcDa/fI6Hk7fCpfnHlIy
   NtupvpqSb6x0krHFlQnmt+nOqz3uJHyzNKS7eK/Eyqg/AV/F0v6RXzXiv
   ERNirZ/NAsWg1t039Nis05DrhCCHeFA+7JPUB68beXN3Wiag1tuelqo2K
   JMkRM89FFd4LC9ya/XRKfPI3YqTnpyX9PbPuZfNRJ0ImUpZg9TP/zF2r0
   DX5rIqzAaPzD82lalK8l1XP8oWnx2poRgLpTOLEdp6CQ/XLloSa+dP3ho
   w==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677567600"; 
   d="asc'?scan'208";a="215064112"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 May 2023 05:24:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 12 May 2023 05:24:07 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 12 May 2023 05:24:05 -0700
Date: Fri, 12 May 2023 13:23:45 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: <daire.mcnamara@microchip.com>
CC: <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <20230512-strive-stump-12d1eae2ba61@wendy>
References: <20230512122032.2902335-1-daire.mcnamara@microchip.com>
 <20230512122032.2902335-2-daire.mcnamara@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OI5v1stjB8dod2GQ"
Content-Disposition: inline
In-Reply-To: <20230512122032.2902335-2-daire.mcnamara@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--OI5v1stjB8dod2GQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 12, 2023 at 01:20:32PM +0100, daire.mcnamara@microchip.com wrot=
e:
> From: Daire McNamara <daire.mcnamara@microchip.com>
>=20
> On mpfs, with SRAM configured for 4 queues, setting max_tx_len
> to GEM_TX_MAX_LEN=3D0x3f0 results multiple AMBA errors.
> Setting max_tx_len to (4KiB - 56) removes those errors.
>=20
> The details are described in erratum 1686 by Cadence
>=20
> The max jumbo frame size is also reduced for mpfs to (4KiB - 56).
>=20
> Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--OI5v1stjB8dod2GQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZF4v0QAKCRB4tDGHoIJi
0oWKAQC2KWqsF5EQy81o/HHoeY7iRxTxWosUjvhbfh45kz1Z8QEAoW3p0ew0SO6H
+HMAkaIUCTBQ02QdtWOnFsIlWxArQgM=
=dWjo
-----END PGP SIGNATURE-----

--OI5v1stjB8dod2GQ--

