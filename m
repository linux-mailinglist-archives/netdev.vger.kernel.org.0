Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06B56E06A2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 08:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDMGAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 02:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMGA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 02:00:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C995F4C19
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 23:00:28 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pmq08-0006Ev-7l; Thu, 13 Apr 2023 08:00:08 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pmq05-00Atqo-4l; Thu, 13 Apr 2023 08:00:05 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pmq04-00CnQS-Az; Thu, 13 Apr 2023 08:00:04 +0200
Date:   Thu, 13 Apr 2023 08:00:04 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Leo Li <leoyang.li@nxp.com>
Cc:     Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vinod Koul <vkoul@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, "Y.B. Lu" <yangbo.lu@nxp.com>,
        "Diana Madalina Craciun (OSS)" <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/6] bus: fsl-mc: Make remove function return void
Message-ID: <20230413060004.t55sqmfxqtnejvkc@pengutronix.de>
References: <20230310224128.2638078-1-u.kleine-koenig@pengutronix.de>
 <20230412171056.xcluewbuyytm77yp@pengutronix.de>
 <AM0PR04MB6289BB9BA4BC0B398F2989108F9B9@AM0PR04MB6289.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dipxl4niloq7i3xa"
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6289BB9BA4BC0B398F2989108F9B9@AM0PR04MB6289.eurprd04.prod.outlook.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dipxl4niloq7i3xa
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Leo,

On Wed, Apr 12, 2023 at 09:30:05PM +0000, Leo Li wrote:
> > On Fri, Mar 10, 2023 at 11:41:22PM +0100, Uwe Kleine-K=F6nig wrote:
> > > Hello,
> > >
> > > many bus remove functions return an integer which is a historic
> > > misdesign that makes driver authors assume that there is some kind of
> > > error handling in the upper layers. This is wrong however and
> > > returning and error code only yields an error message.
> > >
> > > This series improves the fsl-mc bus by changing the remove callback to
> > > return no value instead. As a preparation all drivers are changed to
> > > return zero before so that they don't trigger the error message.
> >=20
> > Who is supposed to pick up this patch series (or point out a good reaso=
n for
> > not taking it)?
>=20
> Previously Greg KH picked up MC bus patches.
>=20
> If no one is picking up them this time, I probably can take it through
> the fsl soc tree.

I guess Greg won't pick up this series as he didn't get a copy of it :-)

Browsing through the history of drivers/bus/fsl-mc there is no
consistent maintainer to see. So if you can take it, that's very
appreciated.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--dipxl4niloq7i3xa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmQ3mmMACgkQj4D7WH0S
/k5nNwf/ScXPEzfZ09aQk2Q2m2lyI5GB0AuO3Y2J4NAHIWgAoR/6wit1ruKkfvFq
uejLhBvkfGFlVytm4oo946r8RzazbFffixp6Yiu9rh2Mi4ieF8/jqmGA+rWMomRF
36k+LsVG7UvSLjpeYby2OHiMR/+fNc61mRb8vgTq7SMe8Un5o7Lz6vZw7z1vmCWC
KsPwmDvkh3glY1HIqf+fTJoB9EtfGMoQy5umRsLYXWDL5sZYASpBLsHiSOc4KatF
NCT6j5R0wItmhG83LAurRC5NcG8aZ1Jt7kU/Qp6kWMEw2bmgxfWOGhCA2hh5efsh
Leq++vvq24OB1Bd9sVbvuYSkpixT7A==
=v4Gk
-----END PGP SIGNATURE-----

--dipxl4niloq7i3xa--
