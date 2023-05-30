Return-Path: <netdev+bounces-6402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AA47162A5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 242271C20C0B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F013D209B9;
	Tue, 30 May 2023 13:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF28E1993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:51:43 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E5211A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:51:20 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q3zkW-0001PG-Iu; Tue, 30 May 2023 15:50:56 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q3zkQ-003tB5-4p; Tue, 30 May 2023 15:50:50 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q3zkP-009W9H-Ah; Tue, 30 May 2023 15:50:49 +0200
Date: Tue, 30 May 2023 15:50:46 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Li Yang <leoyang.li@nxp.com>
Cc: Stuart Yoder <stuyoder@gmail.com>, Gaurav Jain <gaurav.jain@nxp.com>,
	Roy Pledge <roy.pledge@nxp.com>,
	"Diana Madalina Craciun (OSS)" <diana.craciun@oss.nxp.com>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Horia Geanta <horia.geanta@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Laurentiu Tudor <laurentiu.tudor@nxp.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	"Y.B. Lu" <yangbo.lu@nxp.com>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Message-ID: <20230530135046.oovq5gxzbjfqgzos@pengutronix.de>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
 <20230412171056.xcluewbuyytm77yp@pengutronix.de>
 <AM0PR04MB6289BB9BA4BC0B398F2989108F9B9@AM0PR04MB6289.eurprd04.prod.outlook.com>
 <20230413060004.t55sqmfxqtnejvkc@pengutronix.de>
 <20230508134300.s36d6k4e25f6ubg4@pengutronix.de>
 <CADRPPNQ0QiLzzKhHon62haPJCanDoN=B4QsWCxunJTc4wXwMaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4dpyuum7f6cyucl4"
Content-Disposition: inline
In-Reply-To: <CADRPPNQ0QiLzzKhHon62haPJCanDoN=B4QsWCxunJTc4wXwMaA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--4dpyuum7f6cyucl4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, May 08, 2023 at 04:57:00PM -0500, Li Yang wrote:
> On Mon, May 8, 2023 at 8:44=E2=80=AFAM Uwe Kleine-K=C3=B6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > On Thu, Apr 13, 2023 at 08:00:04AM +0200, Uwe Kleine-K=C3=B6nig wrote:
> > > On Wed, Apr 12, 2023 at 09:30:05PM +0000, Leo Li wrote:
> > > > > On Fri, Mar 10, 2023 at 11:41:22PM +0100, Uwe Kleine-K=C3=B6nig w=
rote:
> > > > > > Hello,
> > > > > >
> > > > > > many bus remove functions return an integer which is a historic
> > > > > > misdesign that makes driver authors assume that there is some k=
ind of
> > > > > > error handling in the upper layers. This is wrong however and
> > > > > > returning and error code only yields an error message.
> > > > > >
> > > > > > This series improves the fsl-mc bus by changing the remove call=
back to
> > > > > > return no value instead. As a preparation all drivers are chang=
ed to
> > > > > > return zero before so that they don't trigger the error message.
> > > > >
> > > > > Who is supposed to pick up this patch series (or point out a good=
 reason for
> > > > > not taking it)?
> > > >
> > > > Previously Greg KH picked up MC bus patches.
> > > >
> > > > If no one is picking up them this time, I probably can take it thro=
ugh
> > > > the fsl soc tree.
> > >
> > > I guess Greg won't pick up this series as he didn't get a copy of it =
:-)
> > >
> > > Browsing through the history of drivers/bus/fsl-mc there is no
> > > consistent maintainer to see. So if you can take it, that's very
> > > appreciated.
> >
> > My mail was meant encouraging, maybe it was too subtile? I'll try again:
> >
> > Yes, please apply, that would be wonderful!
>=20
> Sorry for missing your previous email.  I will do that.  Thanks.

Either you didn't apply this patch set yet, or your tree isn't in next.
Both variants would be great to be fixed.

I have another change pending for drivers/bus/fsl-mc/fsl-mc-bus.c, would
be great to see these base patches in next first.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig         =
   |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--4dpyuum7f6cyucl4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmR1/zUACgkQj4D7WH0S
/k6wYwf/aFknTYegOQsYhfPj+VXVEPLkfLFdy+0HcdoIWviyACOPr3L1s4X6BPqq
sTJMW1RtfiDybFhNCMN1eH2tx0+vSuLIzI3rpU+vrob5w86uWd6UzbIMR8uxXPCn
JN5+JDgQsZd0CZKYyCQOw7b+5KpzPhEHKUbUlyxocvtyBE6HFXoQtjsWQnrrCmHl
gvroNfuqjlh3zmsw8ELv/tyZj207mMkvap8BWsKhMtbhRXg132eMBIFJ+XMB//he
A7iG3AkhiRNNdYGFh/KKiRv2l1vHd+6+YmPEM4zRxDCtidaBJTbRL5SSs3AVeYK0
+gXDgOa2Lsf8VzCxRpTavmjQhdDkcA==
=eJpM
-----END PGP SIGNATURE-----

--4dpyuum7f6cyucl4--

