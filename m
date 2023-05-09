Return-Path: <netdev+bounces-1160-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADFB26FC62D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAD69281291
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89F7182BC;
	Tue,  9 May 2023 12:22:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6C6DDB7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:22:30 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C84201
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:22:25 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pwMM2-0004Zj-En; Tue, 09 May 2023 14:22:06 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id B3EC51C0DDB;
	Tue,  9 May 2023 12:22:04 +0000 (UTC)
Date: Tue, 9 May 2023 14:22:04 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: dario.binacchi@amarulasolutions.com, wg@grandegger.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] can: bxcan: Remove unnecessary print function dev_err()
Message-ID: <20230509-sensitive-upper-bd97c6e9abe1-mkl@pengutronix.de>
References: <20230506080725.68401-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uke4yzmz6wgdsbsm"
Content-Disposition: inline
In-Reply-To: <20230506080725.68401-1-jiapeng.chong@linux.alibaba.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--uke4yzmz6wgdsbsm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.05.2023 16:07:25, Jiapeng Chong wrote:
> The print function dev_err() is redundant because
> platform_get_irq_byname() already prints an error.
>=20
> ./drivers/net/can/bxcan.c:970:2-9: line 970 is redundant because platform=
_get_irq() already prints an error.
> ./drivers/net/can/bxcan.c:964:2-9: line 964 is redundant because platform=
_get_irq() already prints an error.
> ./drivers/net/can/bxcan.c:958:2-9: line 958 is redundant because platform=
_get_irq() already prints an error.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3D4878
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Applied to linux-can-next

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--uke4yzmz6wgdsbsm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRaOukACgkQvlAcSiqK
BOgvnAgAtQPyQ1WfKt2BrYRfZ8kxWYSXEQ4y8VEhvujRjZUvbCLLaZPzAPVM5lBN
gBdiEuwbid/nlRlB70y/ihG0m1LLnex9IRlgoaVid/QYocRLQ+u9x+tNHh5Q/igQ
o2WPJTsiV5QNxsY3rVqSWUG9iB/JOhlA/DEa5fNBxrYrgXbsfRf6GczLtx85FEZG
Ixp4onofSdOLZ9eKwDNXP5Kz92lm35XnEKtEpv0cTtG/q4kd170kxowDMhfu8cUU
Omx1iZfQ9tO//jN+7D9/eOe5dkqYTm2OVYdY2zfhbeZ6bcbGaA5Q5x3N/sEqO2wy
1jj1OrFrgRLt7Kl82CupH1/mHevfAw==
=JG2b
-----END PGP SIGNATURE-----

--uke4yzmz6wgdsbsm--

