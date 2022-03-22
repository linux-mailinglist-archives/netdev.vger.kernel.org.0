Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353884E3BAC
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiCVJX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiCVJX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:23:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314D176648
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:22:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nWaiU-0004ha-Pd; Tue, 22 Mar 2022 10:22:14 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-7c76-e54b-1dbb-9ff1.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7c76:e54b:1dbb:9ff1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8B471513DE;
        Tue, 22 Mar 2022 09:22:12 +0000 (UTC)
Date:   Tue, 22 Mar 2022 10:22:12 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
Message-ID: <20220322092212.f5eaxm5k45j5khra@pengutronix.de>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
 <20220322074622.5gkjhs25epurecvx@pengutronix.de>
 <202203220918.33033.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wz3c3pbms7s7war2"
Content-Disposition: inline
In-Reply-To: <202203220918.33033.pisa@cmp.felk.cvut.cz>
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


--wz3c3pbms7s7war2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.03.2022 09:18:32, Pavel Pisa wrote:
> > The driver looks much better now. Good work. Please have a look at the
> > TX path of the mcp251xfd driver, especially the tx_stop_queue and
> > tx_wake_queue in mcp251xfd_start_xmit() and mcp251xfd_handle_tefif(). A
> > lockless implementation should work in your hardware, too.
>=20
> Is this blocker for now? I would like to start with years tested base.

Makes sense.

> We have HW timestamping implemented for actual stable CTU CAN FD IP core=
=20
> version, support for variable number of TX buffers which count can be=20
> parameterized up to 8 in the prepared version and long term desire to=20
> configurable-SW defined multi-queue which our HW interface allows to=20
> dynamically server by =C3=A1 TX buffers. But plan is to keep combinations
> of the design and driver compatible from the actual revision.

Is the number of RX and TX buffers and TX queues auto detectable by
software, or do we need DT bindings for this?

> I would be happy if we can agree on some base/minimal support and get
> it into mainline and use it as base for the followup patch series.
>=20
> I understand that I have sent code late for actual merge window,
> but I am really loaded by teaching, related RISC-V simulator
> https://github.com/cvut/qtrvsim , ESA and robotic projects
> at company. So I would prefer to go step by step and cooperate
> on updates and testing with my diploma students.

The net-next merge window closed with Monday evening, so this driver
will go into net-next for v5.19.

> > BTW: The PROP_SEG/PHASE_SEG1 issue is known:
> > > +A curious reader will notice that the durations of the segments PROP=
_SEG
> > > +and PHASE_SEG1 are not determined separately but rather combined and
> > > +then, by default, the resulting TSEG1 is evenly divided between PROP=
_SEG
> > > +and PHASE_SEG1.
> >
> > and the flexcan IP core in CAN-FD mode has the same problem. When
> > working on the bit timing parameter, I'll plan to have separate
> > PROP_SEG/PHASE_SEG1 min/max in the kernel, so that the bit timing
> > algorithm can take care of this.
>=20
> Hmm, when I have thought about that years ago I have not noticed real
> difference when time quanta is move between PROP_SEG and PHASE_SEG1.
> So for me it had no influence on the algorithm computation and
> could be done on the chip level when minimal and maximal sum is
> respected. But may it be I have overlooked something and there is
> difference for CAN FD.  May it be my colleagues Jiri Novak and=20
> Ondrej Ille are more knowable.

Jiri, Ondrej, I'm interested in details :)

> As for the optimal timequantas per bit value, I agree that it
> is not so simple. In the fact SJW and even tipple-sampling
> should be defined in percentage of bit time

I thought of specifying SJW in a relative value, too.

> and then all should be optimized together

SJW has no influence on the bit rate and sample point. Although SJW is
max phase seg 2, so it's maximum is influenced by the sample point.

> and even combination with slight bitrate error should be preferred
> against other exact matching when there is significant difference in
> the other parameters values.

Since linux-4.8, i.e.

| 7da29f97d6c8 can: dev: can-calc-bit-timing(): better sample point calcula=
tion

the algorithm optimizes for best bit minimal absolute bit rate error
first and then for minimal sample point error. The sample point must be
<=3D the nominal sample point. I have some experiments where the algorithm
optimizes the absolute sample point error.

For more complicated bit timing optimization you need to combine the
bitrate error and the sample point error into a function that needs to
be minimized.

> But I am not ready to dive into it till our ESA space NanoXplore
> FPGA project passes final stage...=20

Ok

> By the way we have received report from Andrew Dennison about
> successful integration of CTU CAN FD into Litex based RISC-V
> system. Tested with the Linux our Linux kernel driver.

That sounds interesting!

> The first iteration there, but he reported that some corrections
> from his actual development needs to be added to the public
> repo still to be usable out of the box
>=20
>   https://github.com/AndrewD/litecan

Nice!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wz3c3pbms7s7war2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmI5lUEACgkQrX5LkNig
013s3AgAiI2/IBnSVWKDKiirvit6BOUskBFzxN/zqF0p+ydquBA3ebQ6z9kbKbjb
pPc8Ic8qgxg7dFhW3a7XrwdzCoe7ShCnjqsR2wgYibExjrizLCfFJ/K1vO4dE4Df
VRKbw5+cQDsT6+tZHnIqjzVRglmQIgG0WnXFc349DdrWoQXTP2ugd9p0cylVjNBu
suwfT8LBtgNM6swYeEkq3otP72+Ksw0WAeIPHUlBaMA+dAxNYubX3EqRN9VyCpe5
VXnaEh3vSnGrMRn8DYIwFYplA7wLoA0AjfKEL8ZjlUixopJWWPGbIGN+beAKW2jq
aNKQ+pn/RpnswF+EtDGMcREGmm83lA==
=fe3N
-----END PGP SIGNATURE-----

--wz3c3pbms7s7war2--
