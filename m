Return-Path: <netdev+bounces-7945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BCB7222E4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1B4A281239
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E3E156CC;
	Mon,  5 Jun 2023 10:05:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962C3156C8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E1DC433EF;
	Mon,  5 Jun 2023 10:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685959539;
	bh=gNAXt0ZkQ87t2ah/jsazFmjCzovUxGfPfHbH39U9ZPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EJRM5rOaMiAPOBMqM1weILjl2dJIJ/M/bhJDVeQYEladWoJfpMth9nYCnL3xvfC+N
	 4SsGI0BjF+8vMT8CEtCv+V9GnPffpGC+nsRP1oQSkyHBKJvyqN3uqrW8K+riSQEMqP
	 u4Hh/so8LWTE+gE4H8LW6c7eJbvZuXZYW+AwueMfGaRlJR7DifNWOX0MMrdz8PCwxs
	 KS85LkSYAkGaThk4hn9Q6Uxwlv++PgLX6/n4czAV2irq7hwqI2QIN96j3M668Qndd5
	 3UyDAaX4e/GjLOBIqazodyLO52FPfvSgNVgH5zNaXdGskKdZZhk0pdUM/79YEpIR8J
	 iZvb49qeUfaeA==
Date: Mon, 5 Jun 2023 12:05:35 +0200
From: 'Wolfram Sang' <wsa@kernel.org>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
Subject: Re: [PATCH net-next v11 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZH2zb7smT/HbFx9k@shikoro>
Mail-Followup-To: 'Wolfram Sang' <wsa@kernel.org>,
	Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com,
	'Piotr Raczynski' <piotr.raczynski@intel.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
 <20230605025211.743823-3-jiawenwu@trustnetic.com>
 <ZH2IaM86ei2gQkfA@shikoro>
 <00c901d9977e$af0dc910$0d295b30$@trustnetic.com>
 <ZH2UT55SRNwN15t7@shikoro>
 <00eb01d99785$8059beb0$810d3c10$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DvdjgQgradLVMDIm"
Content-Disposition: inline
In-Reply-To: <00eb01d99785$8059beb0$810d3c10$@trustnetic.com>


--DvdjgQgradLVMDIm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Yes, other patches will build even without this patch. But SFP will not work.
> This patch series implement I2C, GPIO, SFP and PHYLINK. The support of SFP
> is dependent on I2C and GPIO. If these patches will be end up merging in the
> same upstream version, it's not a problem to merge them in different trees,
> I think.

That's how I saw it as well.

Applied to for-next, thanks!


--DvdjgQgradLVMDIm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmR9s28ACgkQFA3kzBSg
KbbS7w//Rq62rLGlptygEQeddLKTgUHMlTQmNiB9H3eyRXGXfiG84npKEAoeS8xS
ymuGC4nKmh90mxqNB62OWVTI0eRSq08uyenbbRKfY2QTlKExacXvbdXZZVwB0+hi
u32Mgd5443ihWCD4jHBpTuu2fZP1XVz7sWNPwan3IAM+wut7BVZMlf58zQdqesh8
j33fWfmFKfIjUzUQ4GezUcjx8ZwOc91H11NKRfX8br6kLTAIeW+2p8vu6ZOy03Ay
K1JclPdmoTbcFltW/rWcwz/2Y9VuYSl6E0hGz0bIjty6rOapIshxAkwiqEFAB8YO
5LwhMG3VO156NM173hWcGgXl6hm9vgWg0SjYWwGrqTym2xE1wSb6xXbn67RZbz5c
NUI7g2a+BEu9ayOzUaBpGOX+FcummrABDjjCHEBC4F4kR0lnyYFhceIYg1sO4Okg
WKtBn8YciExPAd7FEhDS/l+AMI1zLW6ukQ3Zra/cmNKO7ZC1XwVUN/4XTzFDJlUv
52f9PfdnuKBHrPCTim3imRUxXbNfiDgA2c1WMrmwPaRFQDo2SmpgawVwxtaH6juy
aRvLAtfHfQAs7msGHnJFJLwwmL4F03lQsn//S1w/A4Trc5gFiJiVpk7dU1mYksUK
ahxeM/X0FmdLWNYBT0F+WKOc4s5yV/B85NhSz6ktX37KyX0u2uo=
=WOdz
-----END PGP SIGNATURE-----

--DvdjgQgradLVMDIm--

