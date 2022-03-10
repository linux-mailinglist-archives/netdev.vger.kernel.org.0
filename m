Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9568F4D42DA
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 09:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbiCJIvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 03:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiCJIva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 03:51:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3A4137586
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 00:50:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSEUv-0003Nm-OH; Thu, 10 Mar 2022 09:50:13 +0100
Received: from pengutronix.de (unknown [IPv6:2a02:908:393:af61:c649:5786:706c:cc3e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8CACC477AF;
        Thu, 10 Mar 2022 08:50:10 +0000 (UTC)
Date:   Thu, 10 Mar 2022 09:50:09 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Ulrich Hecht <uli+renesas@fpond.eu>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v4 0/4] can: rcar_canfd: Add support for V3U flavor
Message-ID: <20220310085009.nmefzy26ysas4omw@pengutronix.de>
References: <20220309162609.3726306-1-uli+renesas@fpond.eu>
 <20220310082545.rt6yp3wqsig52qoi@pengutronix.de>
 <CAMuHMdVoEm+0MZS-wMChS45YfPamfnBdM0CH5Rv-F_C4uAx0Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="l2g5ja6pauf6zk4d"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVoEm+0MZS-wMChS45YfPamfnBdM0CH5Rv-F_C4uAx0Kw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l2g5ja6pauf6zk4d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.03.2022 09:45:50, Geert Uytterhoeven wrote:
> Hi Marc,
>=20
> On Thu, Mar 10, 2022 at 9:26 AM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> > On 09.03.2022 17:26:05, Ulrich Hecht wrote:
> > > This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP support=
s up
> > > to eight channels and has some other minor differences to the Gen3 va=
riety:
> > >
> > > - changes to some register offsets and layouts
> > > - absence of "classic CAN" registers, both modes are handled through =
the
> > >   CANFD register set
> > >
> > > This patch set tries to accommodate these changes in a minimally intr=
usive
> > > way.
> > >
> > > This revision tries to address the remaining style issues raised by
> > > reviewers. Thanks to Vincent, Marc and Simon for their reviews and
> > > suggestions.
> > >
> > > It has been successfully tested remotely on a V3U Falcon board, but o=
nly
> > > with channels 0 and 1. We were not able to get higher channels to wor=
k in
> > > both directions yet. It is not currently clear if this is an issue wi=
th the
> > > driver, the board or the silicon, but the BSP vendor driver only work=
s with
> > > channels 0 and 1 as well, so my bet is on one of the latter. For this
> > > reason, this series only enables known-working channels 0 and 1 on Fa=
lcon.
> >
> > Should I take the whole series via linux-can/next?
>=20
> Please don't take the DTS changes.

Ok, I'm taking the yaml update and the driver changes.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--l2g5ja6pauf6zk4d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIpu78ACgkQrX5LkNig
01344wf/WU1UCUnCKnDtywgbjr2rOeFialQhdjwOoqMDI56+z3oygZc53uFnf2A+
r5JzAOhLJw16iQjKoMLcJey3mMagqvxzOhUW+itpfD1V0AafHtsThIJxUtLswlv/
ne+TA2HMlXcjN+DH1zYoypg/C4+8zcUc+XuQ+qvi4y9wVyDTdxGBQdwZJco4IwLF
LgYy9f3KT2rkKIHtPRcRUde2Mgywa3ZGEFr24A1e+Szbb0GOZ6eWFQV1sB0+R5h1
p/Jbp/zNjmmvg2VKLKWzcu3kQnWR+Gd2yyIi47uYgCzUcbLbG3Bl1BSQTxeScEDs
dcAOUZhC015rQMX2B2ZdUXtd/QwmCA==
=tbFR
-----END PGP SIGNATURE-----

--l2g5ja6pauf6zk4d--
