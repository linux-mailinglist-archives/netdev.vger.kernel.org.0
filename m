Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B561516B4C
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 09:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358397AbiEBHgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 03:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358356AbiEBHgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 03:36:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F1B1167
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 00:33:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlQYD-0000Ba-Kj; Mon, 02 May 2022 09:32:57 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-dbb7-8e81-d7fe-7589.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:dbb7:8e81:d7fe:7589])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2C3F472DCA;
        Mon,  2 May 2022 07:21:52 +0000 (UTC)
Date:   Mon, 2 May 2022 09:21:51 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Carsten Emde <c.emde@osadl.org>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Matej Vasilevski <matej.vasilevski@gmail.com>,
        Andrew Dennison <andrew.dennison@motec.com.au>
Subject: Re: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual
 rules and documentation linking
Message-ID: <20220502072151.j6nx5kddqxeyfy3h@pengutronix.de>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
 <20220428072239.kfgtu2bfcud6tetc@pengutronix.de>
 <202204292331.28980.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5ismfath4mcya56n"
Content-Disposition: inline
In-Reply-To: <202204292331.28980.pisa@cmp.felk.cvut.cz>
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


--5ismfath4mcya56n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.04.2022 23:31:28, Pavel Pisa wrote:
> > Split into separate patches and applied.
>=20
> Excuse me for late reply and thanks much for split to preferred
> form. Matej Vasilevski has tested updated linux-can-next testing
> on Xilinx Zynq 7000 based MZ_APO board and used it with his
> patches to do proceed next round of testing of Jan Charvat's NuttX
> TWAI (CAN) driver on ESP32C3. We plan that CTU CAN FD timestamping
> will be send for RFC/discussion soon.

Sounds good!

> I would like to thank to Andrew Dennison who implemented, tested
> and shares integration with LiteX and RISC-V
>=20
>   https://github.com/litex-hub/linux-on-litex-vexriscv
>=20
> He uses development version of the CTU CAN FD IP core with configurable
> number of Tx buffers (2 to 8) for which will be required
> automatic setup logic in the driver.
>=20
> I need to discuss with Ondrej Ille actual state and his plans.
> But basically ntxbufs in the ctucan_probe_common() has to be assigned
> from TXTB_INFO TXT_BUFFER_COUNT field. For older core version
> the TXT_BUFFER_COUNT field bits should be equal to zero so when
> value is zero, the original version with fixed 4 buffers will
> be recognized.

Makes sense

> When value is configurable then for (uncommon) number
> of buffers which is not power of two, there will be likely
> a problem with way how buffers queue is implemented
>=20
>   txtb_id =3D priv->txb_head % priv->ntxbufs;
>   ...
>   priv->txb_head++;
>   ...
>   priv->txb_tail++;
>=20
> When I have provided example for this type of queue many years
> ago I have probably shown example with power of 2 masking,
> but modulo by arbitrary number does not work with sequence
> overflow. Which means to add there two "if"s unfortunately
>=20
>   if (++priv->txb_tail =3D=3D 2 * priv->ntxbufs)
>       priv->txb_tail =3D 0;

There's another way to implement this, here for ring->obj_num being
power of 2:

| static inline u8 mcp251xfd_get_tx_head(const struct mcp251xfd_tx_ring *ri=
ng)
| {
| 	return ring->head & (ring->obj_num - 1);
| }
|=20
| static inline u8 mcp251xfd_get_tx_tail(const struct mcp251xfd_tx_ring *ri=
ng)
| {
| 	return ring->tail & (ring->obj_num - 1);
| }
|=20
| static inline u8 mcp251xfd_get_tx_free(const struct mcp251xfd_tx_ring *ri=
ng)
| {
| 	return ring->obj_num - (ring->head - ring->tail);
| }

If you want to allow not power of 2 ring->obj_num, use "% ring->obj_num"
instead of "& (ring->obj_num - 1)".

I'm not sure of there is a real world benefit (only gut feeling, should
be measured) of using more than 4, but less than 8 TX buffers.

You can make use of more TX buffers, if you implement (fully hardware
based) TX IRQ coalescing (=3D=3D handle more than one TX complete interrupt
at a time) like in the mcp251xfd driver, or BQL support (=3D=3D send more
than one TX CAN frame at a time). I've played a bit with BQL support on
the mcp251xfd driver (which is attached by SPI), but with mixed results.
Probably an issue with proper configuration.

> We need 2 * priv->ntxbufs range to distinguish empty and full queue...
> But modulo is not nice either so I probably come with some other
> solution in a longer term. In the long term, I want to implement
> virtual queues to allow multiqueue to use dynamic Tx priority
> of up to 8 the buffers...

ACK, multiqueue TX support would be nice for things like the Earliest TX
Time First scheduler (ETF). 1 TX queue for ETF, the other for bulk
messages.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5ismfath4mcya56n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJvho0ACgkQrX5LkNig
010Hkwf6A8bgCG87/ZYn+IPQ9zbcdC9eFU7Wh4zwRZp4t9GdlRsGQuXgoedNNEqZ
J4VIqclzempUmrpRQ6vYNuRH4odK4req4/SinmQmDA7G6hZfTcb6L9cXxXeSYm1E
mKtGPQxv3TgpwCSqkPv3vKUIX79oX7lfBpvh6nT65VTS0JKETBDWdhibAFDCnxUx
0xAvmJGW0NPq6cORN1ocid3aktt4WF7NNTkTbnAOWhqtFI9u6Am3S/A32i4EjhEZ
/TU0/IVS8HxXQZ7pGT4rqbsWDDXucJzuFWUUtGKyxDw8oZUswBcqeFNnH+Y3as7n
ROqn9YnlYjpWvuISuJvyuuvq2EoKCA==
=qNE2
-----END PGP SIGNATURE-----

--5ismfath4mcya56n--
