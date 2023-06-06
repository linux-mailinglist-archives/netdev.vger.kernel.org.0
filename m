Return-Path: <netdev+bounces-8269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D05BE7236CE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C3DA1C20E2B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 05:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E017E360;
	Tue,  6 Jun 2023 05:27:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B1655
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C2FC433EF;
	Tue,  6 Jun 2023 05:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686029219;
	bh=BLl0mkMoL0v1sW48e4IHDWa6iCQ8N7NjfDo/zzW2nkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dAQO5qCv+gWcmiSiduWE/+ZDJpM78Nw7L5YlXvvTQ4CK/g/FRPuDGGmOnc6Vd4NwV
	 0HFcGgcMAcgSWJmQ1Fq7iHeP7fw9CCEb2LkPYfwGVQJHkTz34wYAfaNGDjtxKuNluI
	 OuIRNdUqIiS8CPx+iMIj17MFubj8Kjol0drKITAFuArj4/PglIdN0EDeB9SdJGQOIr
	 Pckt1C/4c9rPL5Mg3fcQXvmKBIllfiUCmh8NroG1GLoB1RjeWGJ9ySwTgJjphe7eDG
	 GaHvvRzog8v8W+A8WxTgCiwddWS9BFHZdC4lNGqOjL+cgv5WDJWF1IIC4XYBGKPtBB
	 5gEvTB1qSBmwA==
Date: Tue, 6 Jun 2023 07:26:56 +0200
From: 'Wolfram Sang' <wsa@kernel.org>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: "'Russell King (Oracle)'" <linux@armlinux.org.uk>,
	netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v11 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZH7DoH7ZeO43xPvj@kunai>
Mail-Followup-To: 'Wolfram Sang' <wsa@kernel.org>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	"'Russell King (Oracle)'" <linux@armlinux.org.uk>,
	netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
 <20230605025211.743823-3-jiawenwu@trustnetic.com>
 <ZH2IaM86ei2gQkfA@shikoro>
 <00c901d9977e$af0dc910$0d295b30$@trustnetic.com>
 <ZH2UT55SRNwN15t7@shikoro>
 <00eb01d99785$8059beb0$810d3c10$@trustnetic.com>
 <ZH2zb7smT/HbFx9k@shikoro>
 <ZH22jS7KPPBEVS2a@shell.armlinux.org.uk>
 <ZH3bwBZvjyIoFaVv@shikoro>
 <018701d9981a$7278a0a0$5769e1e0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZFZ+vYFy7tC5jGbx"
Content-Disposition: inline
In-Reply-To: <018701d9981a$7278a0a0$5769e1e0$@trustnetic.com>


--ZFZ+vYFy7tC5jGbx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Okay, v12 series will be other 8 patches for net-next.
> Do I need to send this independent patch to I2C tree?

No, it is already applied.


--ZFZ+vYFy7tC5jGbx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmR+w5QACgkQFA3kzBSg
KbZqoA//TIjh4sRiK7Przqrp3B8C96QjTxGC43wKbwKJO8CKPaceclhZ5FsDg3Xb
6E+auV+tJs7cruYSvK8sahs+HCFDhezmU+79JnTaZLzUBbdU10BEiZyDmqjvSq1D
RdkymmRwQOxY6vQkNz6ykaofnNhBz2q26t1vE1CI9jnksrvmBc6u25d+zS7aEAdp
Bxd+AVaBVil68B8C+4QZbo5W4r700TfJ42zv/f90fESJj5CU/1ASt2MaaXkxdvHP
ss9BX9pkaB3T3CvbhcbYHmH0Cz3yg1C5u6z7xDDERTVO/Hmg/Gc4xUjUEOMushYh
M3X0SuMrFejjbshlYPZ+GDjXnUvU5HRKYI4M31/vdt4yTck8GTb911mOF4KUV5cL
z8QfJHzB1ZfB4FTTZ2DQESy/gUT6AUcdEVFfDTXAkSCqSWunberFDG9yr9S09OO2
P3fo/k4WV+Q724cxk9nvxbTdWhnFPiCG8kvbAYoUt1IpVBM8N8rF+wxf8veUKPxE
OVs7w2G/iTvlkgAjFFQF6zHn86ut8V/qAe87+/L8yWGUEB8X0hdVe+tNe1zjG57t
qkw7M/UheUExql8a6ymBSMfwi1o/KKoiKsx13Mo77P1ZExc3ac9f0Gy9tn8aGePL
PVAEtFXAfCDFWOSDxH68Sxy4sN5okfk3UCBgslKos4QWQp4GwgQ=
=Otg4
-----END PGP SIGNATURE-----

--ZFZ+vYFy7tC5jGbx--

