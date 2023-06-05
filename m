Return-Path: <netdev+bounces-7897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC1F722026
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:52:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74B882811DE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A019B11CAE;
	Mon,  5 Jun 2023 07:52:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC18BEA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349B0C433D2;
	Mon,  5 Jun 2023 07:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685951570;
	bh=TNVRxCQhdjIrgRWsVLXN70a1rHW/Qh2TiUaNU0Hd33s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jNxhb4oZ2hp905rSPM0DgzNr+jkfXE0MNODJyVsaGsuc+E8wLqgDSVYrUVXUzgD9F
	 Lcoy3F1m38qnFINjeqT6fNNuDeBslIh9E0F69wpMP/r1r7SIu1QSjTNZHKKedxEh03
	 hUFy/OGwL4juXVTFl8A7Jhh4D/nD6rO7AL3p60zUKqF6MavRXGVX8pHxY9mAy97kUf
	 JbiErDBMqqhaFKe0ROjLnj8sD7KSX+mKbJWCC6ccct1uuq7YEUZsopdvYNIG6VFOzn
	 gF2PjMEe/XyOfqUv1XG2v5JKU5dbcw/e1eB3MNVFYjUTJtQcDtOHQTDFlM7ZL6Iqw6
	 q4VPZZzjmmgnw==
Date: Mon, 5 Jun 2023 09:52:47 +0200
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
Message-ID: <ZH2UT55SRNwN15t7@shikoro>
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
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nwovrhgZcwq2rkeX"
Content-Disposition: inline
In-Reply-To: <00c901d9977e$af0dc910$0d295b30$@trustnetic.com>


--nwovrhgZcwq2rkeX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Do you mean the device tree binding? This property in only used in case of software
> node, for wangxun Soc, which has no device tree structure.

I see, thanks.

How is the dependency of these patches? I'd like to take this patch via
the i2c tree if possible. I guess the other patches will build even if
this patch is not in the net-tree? Or do we need an immutable branch? Or
is it really better if all goes in via net? We might get merge conflicts
then, though. There are other designware patches pending.


--nwovrhgZcwq2rkeX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmR9lEsACgkQFA3kzBSg
Kbb6jA/+NTCSYYuDsAGOl7OkZQhhpfSfYjH6QYkuxKtOHAk6nxl3HbNYRZsJ7BgH
V7NVRdhOvL2yksm/aPXzUkMSqlV/6kvbSfXzKWFDDQ8Z4NGY010C4EdSTjKHWv0n
wfAgY/gmA3ZMmSZkRLhPphE25U2FPpy1IE83IploKp5U2DrQR3HHQlvwn3hmbTC+
jCZAXsWsTnIK5Biylgi9/dkZXtlHSdPuUXVZXXBLDYsVuwb1XPLre+sSMbuPuXVV
sof0WeEGe1B0ktx2PrMFY659ck6rySaluL/f+cTt1ODZEyA0i/FV+g35Q4JZY0Ha
4CZ6Ts9pHlrNnxX8hFJ0y2loepVUH1TMNDKXAJeQavzZpxEwEkRXosEtc0MKMnjg
LOWMtLDWIHgXbOJNj5GinIC84r0EqQHOWIHveNJt00fIpjDVjBIEyR+gslUYhFC8
IzL2X7dzKmPb3yYqLOWXQYtx+znxNK34wJaALFej2mj+NYH7YSshAmdM4Nm/TJCn
QcPz4Ie44vi1JqkxfiujoJlHWmjGJ8yyoxfF3vuNq1rVcfTk/aibMM26Wy9kguwK
Rt8pYIEWVLxA2YCKjZ2LlQTO7ngVtrv0VWziCq2V7zNXXCBq2qZlL/puFQLwyPmK
iZEXNkiSNMTz24xe0bdmlol2x/HJ3QvdHXwdOvYefHc5z5eXPcg=
=T8vQ
-----END PGP SIGNATURE-----

--nwovrhgZcwq2rkeX--

