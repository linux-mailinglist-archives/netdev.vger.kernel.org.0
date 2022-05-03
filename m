Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9BC518038
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 10:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiECI7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 04:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiECI7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 04:59:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38762B252
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 01:55:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nloJK-0007st-3e; Tue, 03 May 2022 10:55:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C97AA74A84;
        Tue,  3 May 2022 08:55:06 +0000 (UTC)
Date:   Tue, 3 May 2022 10:55:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Andrew Dennison <andrew.dennison@motec.com.au>,
        linux-can@vger.kernel.org,
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
        Matej Vasilevski <matej.vasilevski@gmail.com>
Subject: Re: [PATCH v1 0/4] can: ctucanfd: clenup acoording to the actual
 rules and documentation linking
Message-ID: <20220503085506.d5v4xtpumr7gm7hy@pengutronix.de>
References: <cover.1650816929.git.pisa@cmp.felk.cvut.cz>
 <CAHQrW0_bxDyTf7pNHgXwcO=-0YRWtsxscOSWWU4fDmNYo8d-9Q@mail.gmail.com>
 <20220503064626.lcc7nl3rze5txive@pengutronix.de>
 <202205030927.15558.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ec4ogvkdtzy55sz6"
Content-Disposition: inline
In-Reply-To: <202205030927.15558.pisa@cmp.felk.cvut.cz>
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


--ec4ogvkdtzy55sz6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.05.2022 09:27:15, Pavel Pisa wrote:
> Hello Marc and Andrew,
>=20
> On Tuesday 03 of May 2022 08:46:26 Marc Kleine-Budde wrote:
> > On 03.05.2022 16:32:32, Andrew Dennison wrote:
> > > > > When value is configurable then for (uncommon) number
> > > > > of buffers which is not power of two, there will be likely
> > > > > a problem with way how buffers queue is implemented
> > >
> > > Only power of 2 makes sense to me: I didn't consider those corner
> > > cases but the driver could just round down to the next power of 2 and
> > > warn about a misconfiguration of the IP core.
> >
> > +1
>=20
> Then (n-1) mask be used instead of modulo which is what I used for these
> kind of queues.
>=20
> https://sourceforge.net/p/ulan/ulut/ci/master/tree/ulut/ul_dqfifo.h

ACK

> > > I added the dynamic detection because the IP core default had changed
> > > to 2 TX buffers and this broke some hard coded assumptions in the
> > > driver in a rather obscure way that had me debugging for a bit...
> >
> > The mainline driver uses a hard coded default of 4 still... Can you
> > provide that patch soonish?
>=20
> We discuss with Ondrej Ille final location of the bits with queue
> length information etc... The version 3.0 of the core is in
> development still. So I do not like to introduce something which would
> break compatability with future revisions.

Makes sense. I'm a bit nervous, as Andrew said the default number of TX
buffers changed to 2 in the hardware.

> Yes, we can check for version reported by IP core but when it is
> possible I would not introduce such logic... So if it gets to 5.19 it
> would be great but if we should risk incompatible changes or too
> cluttered logic then it will be 5.20 material. Other option is to add
> Kconfig option to specify maximal number of TX buffers used by the
> driver for now.

No Kconfig option please! The hardware should be introspectable,
preferred a register holds the number of TX buffers. If this is not
available use a version register and hard code the number per version.

> > > > You can make use of more TX buffers, if you implement (fully
> > > > hardware based) TX IRQ coalescing (=3D=3D handle more than one TX
> > > > complete interrupt at a time) like in the mcp251xfd driver, or BQL
> > > > support (=3D=3D send more than one TX CAN frame at a time). I've pl=
ayed
> > > > a bit with BQL support on the mcp251xfd driver (which is attached by
> > > > SPI), but with mixed results. Probably an issue with proper
> > > > configuration.
> > >
> > > Reducing CAN IRQ load would be good.
> >
> > IRQ coalescing comes at the price of increased latency, but if you have
> > a timeout in hardware you can configure the latencies precisely.
>=20
> HW coalescing not considered yet. Generally my intention for CAN use
> is usually robotic and motion control and there is CAN and even CAN FD
> on edge with its latencies already and SocketCAN layer adds yet
> another level due common tasklets and threads with other often dense
> and complex protocols on ETHERNET so to lover CPU load by IRQ
> coalescing is not my priority.

For MMIO attached hardware IRQ load is a far less problem than slow
busses like SPI.

> We have done latencies evaluation of SocketCAN, LinCAN and RTEMS years
> ago on Oliver Hartkopp's requests on standard and fully-preemptive
> kernels on more targets (x86, PowerPC, ...) and I hope that we revive
> CAN Bench project on Xilinx Zynq based MZ_APO again, see Martin
> Jerabek's theses FPGA Based CAN Bus Channels Mutual Latency Tester and
> Evaluation, 2016
>=20
> https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/wikis/uploads=
/56b4d27d8f81ae390fc98bdce803398f/F3-BP-2016-Jerabek-Martin-Jerabek-thesis-=
2016.pdf

Meanwhile you can configure the NAPI to be handled in per interface
kernel thread, which can be prioritized. This should reduce latencies
introduced by NAPI of other network cards using the global soft IRQ.

> It is actual work of Matej Vasilevski. So I hope to have again more
> insight into latencies on CAN. By the way, I plan to speak with
> Carsten Emde on Embedded World if these is interrest to add
> continuous HW timestamping based CAN latencies testing into OSADL
> QA Farm
>=20
> https://www.osadl.org/OSADL-QA-Farm-Real-time.linux-real-time.0.html
>=20
> Other option is to setup system and run it locally at CTU
> as we run complete CI on CTU CAN FD.
>=20
> > > > > We need 2 * priv->ntxbufs range to distinguish empty and full
> > > > > queue... But modulo is not nice either so I probably come with
> > > > > some other solution in a longer term. In the long term, I want to
> > > > > implement virtual queues to allow multiqueue to use dynamic Tx
> > > > > priority of up to 8 the buffers...
> > > >
> > > > ACK, multiqueue TX support would be nice for things like the
> > > > Earliest TX Time First scheduler (ETF). 1 TX queue for ETF, the
> > > > other for bulk messages.
> > >
> > > Would be nice, I have multi-queue in the CAN layer I wrote for a
> > > little RTOS (predates socketcan) and have used for a while.
> >
> > Out of interest:
> > What are the use cases? How did you decide which queue to use?
>=20
> For example for CAN open there should be at least three queues
> to prevent CAN Tx priority inversion. one for NMT (network
> management), one for PDO (process data objects) and least priority
> for SDO (service data objects). That such applications works
> somehow with single queue is only matter of luck and low
> level of the link bandwidth utilization.
>=20
> We have done research how to use Linux networking infrastructure
> to route application send CAN messages into multiple queues
> according to the CAN ID priorities. There are some results in mainline
> from that work
>=20
> Rostislav Lisovy 2014: can: Propagate SO_PRIORITY of raw sockets to skbs
> Rostislav Lisovy 2012: net: em_canid: Ematch rule to match CAN frames=20
> according to their identifiers
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/n=
et/sched/em_canid.c
>=20
> So some enhancements and testing in this direction belongs
> between my long horizon goals. But low priority now because
> my company and even studnets at university are paid from
> other projects (silicon-heaven, ESA, Bluetooth-monitoring,
> NuttX etc.) so Linux CAN is hobby only at this moment.
> But others have contracts for CTU CAN FD, Skoda Auto
> testers etc. there...

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ec4ogvkdtzy55sz6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJw7ecACgkQrX5LkNig
011wggf9GDMsb66itcciOLFHd0+MqYRA8A21qlVvPRAiiBNxjeBGA4x6ZqPy7Vps
XZ7TvSHspYnaRyTvWHfJV762vr6teMVozTxV6hPoSfmHQqHVGwiCAU5Ia1bigcCb
1OuuKnOw5BUGqUkRHJUVi4ZEGp9TnhuTGLdCd6HpeIZNtAgxtye38y21c34qQ3jm
yfVxHUfCvI3Vo8UMeixV8ug4pEJo/KWYisZchO3VPVjj5Aiqyrvuroap9LEPXSHv
Ffj9LLtN3DSYWW6ERe8SAN2UjSBDnFThtJlNUn9TMYDRNOEV6/T5YVrJKkK0Yu0A
/IhLsR1TfiSFnWAKjwBAIM6z0miHZQ==
=zLxL
-----END PGP SIGNATURE-----

--ec4ogvkdtzy55sz6--
