Return-Path: <netdev+bounces-7877-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BAA721EB9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 238A11C20AF6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EBB6101;
	Mon,  5 Jun 2023 07:02:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83422194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F522C433EF;
	Mon,  5 Jun 2023 07:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685948524;
	bh=UY3nLgx5ktjqstws5tU2oB1vOZhXh6L50Bolq73FYzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NjQVjTBw6Rf8UlLW8WTLW3bXDKiDFhS2c9HwJmdPwNLS/oTlipVqQu7dnj7tnt8tF
	 Q13nE97Xf7UFskZt0KEZaUBYbolmeQVMkRgUEf7oisbmZf1nL4mbUPkSbXiTQZnrtI
	 iZGuWovK6+7d6zqJD1q4TargREutBqctvZ6nKX6GwPuULvATlI++pclzsYMOMsme/r
	 NDaWIRUYekDHCMF2RxSJVQgV1UetbNyQLdBVhgWU3ctuhmOMJfCZWMk8/VEKiz8Ct2
	 fyhlxqo89DZ/o6JQnN/n9WekduA3xGjoam4meOUL+Eb7haV7WwH5EQ5tKTX7BwxxIe
	 d82v55d1BB35Q==
Date: Mon, 5 Jun 2023 09:02:00 +0200
From: Wolfram Sang <wsa@kernel.org>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v11 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZH2IaM86ei2gQkfA@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
	Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	Piotr Raczynski <piotr.raczynski@intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
 <20230605025211.743823-3-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C7Kg18qcwmutGUSx"
Content-Disposition: inline
In-Reply-To: <20230605025211.743823-3-jiawenwu@trustnetic.com>


--C7Kg18qcwmutGUSx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 05, 2023 at 10:52:04AM +0800, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
>=20
> Introduce the property "wx,i2c-snps-model" to match device data for Wangx=
un

Does this not need some binding documentation somewhere?

> in software node case. Since IO resource was mapped on the ethernet drive=
r,
> add a model quirk to get regmap from parent device.

All the best,

   Wolfram


--C7Kg18qcwmutGUSx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmR9iGUACgkQFA3kzBSg
KbbYrQ/9FEyXD3uaVkL6TjkfZKbPWVKFYOJxtDnXR8jyBwK1G41bCdSggGp7ShSF
tcF1YqIbZmDRiElwRDWgeYYvHfWETGFvAx+Jn5njZWOQSp1FeFNZh3//MTBd9Mv2
weVom24lGR07d61JbAsei3ax3lqGCjkbvOUHXjeQWSAYWA5e6bK/KL3ZkrjJUmjx
CglJFynmsXdbPMZ/oIFYON7xEJo2LXsd8MfLSoNYyscRA53ntezaOlKRiPd7ASe8
3LW9y3dYAccZGrEenxoV3CPdCICt8AhE8bZa7/xJOaqjzvHDMOsxr58ptzw6HIRM
rMAvt7RBiSv6IPBzUWAYh1JOpfjqmKXAi4rL5b6QVjpmxofB2M57kR/imueOHWx9
12F/CbZj28seONdyDGDzhnwsxXQi6YOslB46b5D/g+K7s8znqmzRqPeN78j0TFoM
5dUJQqvt/o8BlE9fGawb06rDn3VwDuMLq4+viHsCbQ1ZrTsXA9AtwCpXvaUFS++M
i/qiUFnClmXtrYmb0PUCaLshQAsDttb1upNzbtzwPo3zDgrscB41tcl9tsZaZeNf
vpGlPr3gQhk7c3hLCO8lLYfq/q7VtMkVYhQdpDZNHXsVUOEYexiW16Pzphv7kSwz
LBdgLkNFgSUJaW+jCyX6GxzUMEqlIpfx3q1JFopfbfJJNzI630w=
=/Ntz
-----END PGP SIGNATURE-----

--C7Kg18qcwmutGUSx--

