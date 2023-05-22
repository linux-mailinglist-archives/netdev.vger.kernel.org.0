Return-Path: <netdev+bounces-4172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3409A70B774
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F07E280E01
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782567474;
	Mon, 22 May 2023 08:19:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699015380
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:19:59 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6275B4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 01:19:57 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1q10lk-0000SH-GF; Mon, 22 May 2023 10:19:52 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 90A841C967B;
	Mon, 22 May 2023 08:00:32 +0000 (UTC)
Date: Mon, 22 May 2023 10:00:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: git@cookiesoft.de
Cc: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	Marcel Hellwig <mhellwig@mut-group.com>
Subject: Re: [PATCH] can: dev: add transceiver capabilities to xilinx_can
Message-ID: <20230522-oak-pushiness-5c3148a5bd6c-mkl@pengutronix.de>
References: <20230417085204.179268-1-git@cookiesoft.de>
 <831053285.870396.1684740257842@office.mailbox.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="423kqso3xgjizgbr"
Content-Disposition: inline
In-Reply-To: <831053285.870396.1684740257842@office.mailbox.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--423kqso3xgjizgbr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.05.2023 09:24:17, git@cookiesoft.de wrote:
> Hey everyone,
>=20
> is there anything I can do to get this merged?
> Is there anything missing?

Looks good, while applying I'v moved the phy_power_off() after the
pm_runtime_put() to make it symmetric with respect to xcan_open().

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--423kqso3xgjizgbr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRrIR0ACgkQvlAcSiqK
BOikLwf/aKy7oAZNj42dKNt/lv47zCagGNVIw0/0LP3UADNMUb/gY257XXdw6BNR
37VTKFNxgFi4GHWND4D8SNaXfpxE2RjgpMLxgaWZAr5Ctf4m37y2EFU07JMGdi5A
JczdjJGjOROThUCUAkyKTZKL+16ukb+6rEGUCUev+OT2Q3Cwp2QRC5kI/sznwa3R
rO0rwuyVdCx0oUxPueV74qRsS4oeihKiBFmjkKEIENtuftiH0auqasYwjt5/VsdA
EnoDl73BTaPK8egQShRTaswAmEOVY+F9yC7k/h/+M62jxJ07YmY0nRfC/YMPQS4S
7lyHO0fe65QlAwX3hzcIsvEskRxnGg==
=eAHY
-----END PGP SIGNATURE-----

--423kqso3xgjizgbr--

