Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A05260BD3B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiJXWR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiJXWRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:17:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBC017EF1C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 13:34:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1on1r1-0004Wv-Bo; Mon, 24 Oct 2022 20:07:15 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2AD24108BF7;
        Mon, 24 Oct 2022 18:07:10 +0000 (UTC)
Date:   Mon, 24 Oct 2022 20:07:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo receive
Message-ID: <20221024180708.5zfti5whtpfowk5c@pengutronix.de>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
 <20221024155342.bz2opygr62253646@pengutronix.de>
 <OS0PR01MB5922B66F44AEF91CDCED8374862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="whv77qosu2tvjdil"
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922B66F44AEF91CDCED8374862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--whv77qosu2tvjdil
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.10.2022 16:55:56, Biju Das wrote:
> Hi Marc,
> > Subject: Re: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo
> > receive
> >=20
> > On 24.10.2022 17:37:35, Marc Kleine-Budde wrote:
> > > On 22.10.2022 09:15:01, Biju Das wrote:
> > > > We are seeing IRQ storm on global receive IRQ line under heavy CAN
> > > > bus load conditions with both CAN channels are enabled.
> > > >
> > > > Conditions:
> > > >   The global receive IRQ line is shared between can0 and can1,
> > either
> > > >   of the channels can trigger interrupt while the other channel
> > irq
> > > >   line is disabled(rfie).
> > > >   When global receive IRQ interrupt occurs, we mask the interrupt
> > in
> > > >   irqhandler. Clearing and unmasking of the interrupt is happening
> > in
> > > >   rx_poll(). There is a race condition where rx_poll unmask the
> > > >   interrupt, but the next irq handler does not mask the irq due to
> > > >   NAPIF_STATE_MISSED flag.
> > >
> > > Why does this happen? Is it a problem that you call
> > > rcar_canfd_handle_global_receive() for a channel that has the IRQs
> > > actually disabled in hardware?
> >=20
> > Can you check if the IRQ is active _and_ enabled before handling the
> > IRQ on a particular channel?
>=20
> You mean IRQ handler or rx_poll()??

I mean the IRQ handler.

Consider the IRQ for channel0 is disabled but active and the IRQ for
channel1 is enabled and active. The
rcar_canfd_global_receive_fifo_interrupt() will iterate over both
channels, and rcar_canfd_handle_global_receive() will serve the channel0
IRQ, even if the IRQ is _not_ enabled. So I suggested to only handle a
channel's RX IRQ if that IRQ is actually enabled.

Assuming "cc & RCANFD_RFCC_RFI" checks if IRQ is enabled:

index 567620d215f8..ea828c1bd3a1 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1157,11 +1157,13 @@ static void rcar_canfd_handle_global_receive(struct=
 rcar_canfd_global *gpriv, u3
 {
        struct rcar_canfd_channel *priv =3D gpriv->ch[ch];
        u32 ridx =3D ch + RCANFD_RFFIFO_IDX;
-       u32 sts;
+       u32 sts, cc;
=20
        /* Handle Rx interrupts */
        sts =3D rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv, ridx));
-       if (likely(sts & RCANFD_RFSTS_RFIF)) {
+       cc =3D rcar_canfd_read(priv->base, RCANFD_RFCC(gpriv, ridx));
+       if (likely(sts & RCANFD_RFSTS_RFIF &&
+                  cc & RCANFD_RFCC_RFIE)) {
                if (napi_schedule_prep(&priv->napi)) {
                        /* Disable Rx FIFO interrupts */
                        rcar_canfd_clear_bit(priv->base,

Please check if that fixes your issue.

> IRQ handler check the status and disable(mask) the IRQ line.
> rx_poll() clears the status and enable(unmask) the IRQ line.
>=20
> Status flag is set by HW while line is in disabled/enabled state.
>=20
> Channel0 and channel1 has 2 IRQ lines within the IP which is ored together
> to provide global receive interrupt(shared line).

> > A more clearer approach would be to get rid of the global interrupt
> > handlers at all. If the hardware only given 1 IRQ line for more than 1
> > channel, the driver would register an IRQ handler for each channel
> > (with the shared attribute). The IRQ handler must check, if the IRQ is
                     ^^^^^^^^^
That should be "flag".

> > pending and enabled. If not return IRQ_NONE, otherwise handle and
> > return IRQ_HANDLED.
>=20
> That involves restructuring the IRQ handler altogether.

ACK

> RZ/G2L has shared line for rx fifos {ch0 and ch1} -> 2 IRQ routine
> with shared attributes.

It's the same IRQ handler (or IRQ routine), but called 1x for each
channel, so 2x in total. The SHARED is actually a IRQ flag in the 4th
argument in the devm_request_irq() function.

| devm_request_irq(..., ..., ..., IRQF_SHARED, ..., ...);

> R-Car SoCs has shared line for rx fifos {ch0 and ch1} and error
> interrupts->3 IRQ routines with shared attributes.

> R-CarV3U SoCs has shared line for rx fifos {ch0 to ch8} and error
> interrupts->9 IRQ routines with shared attributes.

I think you got the point, I just wanted to point out the usual way they
are called.

> Yes, I can send follow up patches for migrating to shared interrupt
> handlers as enhancement. Please let me know.

Please check if my patch snippet from above works. To fix the IRQ storm
problem I'd like to have a simple and short solution that can go into
stable before restructuring the IRQ handlers.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--whv77qosu2tvjdil
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNW1EoACgkQrX5LkNig
0121FAf/UGwWyYVDjSFI0sfvgyXV53K9yXA0bZcVyt1DjoNuNycmQ6c+gcmQXLO/
VYpQrHOkX0voEgtoFT+/jnAS5yqAB+MvT77jk9U3lsz75TSzl+JCTQS9weTRB4/t
8lKQoRLwmo3i10n7c50qQbcaRbHnpTvw93s4JS3izMhRPtQw56XNZmy9ffka9ub2
32kJu8Uq7HOQJ54AC9GkK23B9IujKRNIxk7K0fTAJ9fnDFHSeuIRVvoJEnYVrmsg
OuI5pZcOg92jzvpd9l2OhwM41gveTiPq7rjfzcTLGIVAVVnBjV7ev3W6CSNB1Jmn
N22KiYMJL+lqFWid+Ox/hfHzW5Y5Mg==
=Yip9
-----END PGP SIGNATURE-----

--whv77qosu2tvjdil--
