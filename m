Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442A56E8E50
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbjDTJhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbjDTJg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:36:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092BA4234
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 02:36:49 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ppQi7-0007zh-Cf; Thu, 20 Apr 2023 11:36:15 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D72831B3CD1;
        Thu, 20 Apr 2023 09:36:12 +0000 (UTC)
Date:   Thu, 20 Apr 2023 11:36:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Mendez, Judith" <jm@ti.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Andrew Davis <afd@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Message-ID: <20230420-scarf-landscape-86202cc821ca-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230414-tubular-service-3404c64c6c62-mkl@pengutronix.de>
 <6eb588ef-ab12-186d-b0d3-35fc505a225a@ti.com>
 <20230419-stretch-tarantula-e0d21d067483-mkl@pengutronix.de>
 <52a37e51-4143-9017-42ee-8d17c67028e3@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4xgtlkkfta6kixje"
Content-Disposition: inline
In-Reply-To: <52a37e51-4143-9017-42ee-8d17c67028e3@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--4xgtlkkfta6kixje
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.04.2023 15:40:24, Mendez, Judith wrote:
> Hello Marc,
>=20
> On 4/19/2023 1:10 AM, Marc Kleine-Budde wrote:
> > On 18.04.2023 11:15:35, Mendez, Judith wrote:
> > > Hello Marc,
> > >=20
> > > On 4/14/2023 12:49 PM, Marc Kleine-Budde wrote:
> > > > On 13.04.2023 17:30:46, Judith Mendez wrote:
> > > > > On AM62x there is one MCAN in MAIN domain and two in MCU domain.
> > > > > The MCANs in MCU domain were not enabled since there is no
> > > > > hardware interrupt routed to A53 GIC interrupt controller.
> > > > > Therefore A53 Linux cannot be interrupted by MCU MCANs.
> > > >=20
> > > > Is this a general hardware limitation, that effects all MCU domain
> > > > peripherals? Is there a mailbox mechanism between the MCU and the M=
AIN
> > > > domain, would it be possible to pass the IRQ with a small firmware =
on
> > > > the MCU? Anyways, that's future optimization.
> > >=20
> > > This is a hardware limitation that affects AM62x SoC and has been car=
ried
> > > over to at least 1 other SoC. Using the MCU is an idea that we have j=
uggled
> > > around for a while, we will definitely keep it in mind for future
> > > optimization. Thanks for your feedback.
> >=20
> > Once you have a proper IRQ de-multiplexer, you can integrate it into the
> > system with a DT change only. No need for changes in the m_can driver.
> >=20
>=20
> Is this a recommendation for the current patch?

It is a recommendation on how to get around the hardware limitation,
instead of falling back to polling.

> The reason I am asking is because adding firmware for the M4 to forward
> a mailbox with the IRQ to the A53 sounds like a good idea and we have been
> juggling the idea, but it is not an ideal solution if customers are
> using the M4 for other purposes like safety.

Of course, the feasibility of this approach depends on your system
design.

> > > > > This solution instantiates a hrtimer with 1 ms polling interval
> > > > > for a MCAN when there is no hardware interrupt. This hrtimer
> > > > > generates a recurring software interrupt which allows to call the
> > > > > isr. The isr will check if there is pending transaction by reading
> > > > > a register and proceed normally if there is.
> > > > >=20
> > > > > On AM62x this series enables two MCU MCAN which will use the hrti=
mer
> > > > > implementation. MCANs with hardware interrupt routed to A53 Linux
> > > > > will continue to use the hardware interrupt as expected.
> > > > >=20
> > > > > Timer polling method was tested on both classic CAN and CAN-FD
> > > > > at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
> > > > > switching.
> > > > >=20
> > > > > Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
> > > > > 1 MBPS timer polling interval is the better timer polling interval
> > > > > since it has comparable latency to hardware interrupt with the wo=
rse
> > > > > case being 1ms + CAN frame propagation time and CPU load is not
> > > > > substantial. Latency can be improved further with less than 1 ms
> > > > > polling intervals, howerver it is at the cost of CPU usage since =
CPU
> > > > > load increases at 0.5 ms and lower polling periods than 1ms.
> >=20
> > Have you seen my suggestion of the poll-interval?
> >=20
> > Some Linux input drivers have the property poll-interval, would it make
> > sense to ass this here too?
>=20
> Looking at some examples, I do think we could implement this poll-interval
> attribute, then read in the driver and initialize the hrtimer based on th=
is.
> I like the idea to submit as a future optimization patch, thanks!

I would like to have the DT bindings in place, as handling legacy DT
without poll interval adds unnecessary complexity.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--4xgtlkkfta6kixje
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRBB4kACgkQvlAcSiqK
BOi3tQgAncJzwRYQqm5rHunLZQBQJZ76dTGRYf7AFrYVzqwbbW1wO2e2uv8H4Drg
hCSh+DaPGLyBBi0ZCUtvO0dql90ZD0wLvX/Eis8q2R/qkWdor3VTNiWBhwGcuTIa
WITJE1rmdTBbpRXZ6M6KMyJi4MFaM8mKr11VXsHK2HJIRVDcL3nMy6DM5/mMhjzf
n8JgumGKM5+VxTNSdyQVWpZxe9GSQC3yYrSTYvIw/VGcrITBdnSn92Svpc6jE+PF
DNLcCOMBYU3cNtdqEsNsej7TCKEJQIYY+ImhaQ8ya9bE3coIwdVqq2BPJW19q5TN
BgEwQXsNBy+Eq9WSPE4QKLyWvKxHRA==
=JDN9
-----END PGP SIGNATURE-----

--4xgtlkkfta6kixje--
