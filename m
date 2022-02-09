Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C674AF0E9
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiBIMHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiBIMGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:06:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3C6C094CBB
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 03:27:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHl7J-0007ep-T9; Wed, 09 Feb 2022 12:26:33 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 144702F207;
        Wed,  9 Feb 2022 11:26:21 +0000 (UTC)
Date:   Wed, 9 Feb 2022 12:26:17 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Wang <weiwan@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@nxp.com, Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net-next 1/2] net: napi: wake up ksoftirqd if needed
 after scheduling NAPI
Message-ID: <20220209112617.mx5scslk2zbwqlq5@pengutronix.de>
References: <20220203184031.1074008-1-yannick.vignon@oss.nxp.com>
 <CANn89iKn20yuortKnqKV99s=Pb9HHXbX8e0=58f_szkTWnQbCQ@mail.gmail.com>
 <0ad1a438-8e29-4613-df46-f913e76a1770@oss.nxp.com>
 <20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YfzhioY0Mj3M1v4S@linutronix.de>
 <20220204074317.4a8be6d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <078bffa8-6feb-9637-e874-254b6d4b188e@oss.nxp.com>
 <20220204094522.4a233a2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Yf1qc7R5rFoALsCo@linutronix.de>
 <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bp5rpkdrxtbu77ma"
Content-Disposition: inline
In-Reply-To: <20220204105035.4e207e9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bp5rpkdrxtbu77ma
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.02.2022 10:50:35, Jakub Kicinski wrote:
> > Wouldn't it work to utilize the threaded-IRQ API and use that instead
> > the custom thread? Basically the primary handler would what it already
> > does (disable the interrupt) and the threaded handler would feed packets
> > into the stack. In the overload case one would need to lower the
> > thread-priority.
>=20
> Sounds like an interesting direction if you ask me! That said I have
> not been able to make threaded NAPI useful in my experiments / with my
> workloads so I'd defer to Wei for confirmation.

FWIW: We have a threaded NAPI use case. On a PREEMPT_RT enabled imx6 (4
core 32 bit ARM) the NAPI of the CAN controller (flexcan) is running in
threaded mode with raised priorities. This reduces latency spikes and
jitter of RX'ed CAN frames, which are part of a closed control loop.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bp5rpkdrxtbu77ma
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDpNcACgkQrX5LkNig
011TXgf9GnStV2H486VhVb7IKmiCq/IG51H+d5VPtw72NUInmqDiVX69Sgk2fcuI
tKwPOib7dBI52Ia7zkaWdRQS+PmJzwS+rLUWLbgZf3PpYKeyyA3EFFF4/BEUn6vc
J343dkIRK/AMUC5mvXAYz7slr6N/Lmy0iyXsqeFGvjGOZgWSBShRvUdsB+uJhb+R
xRblZJhsnsbzLPteVXWAqPndnbJZwYVVUiCz7E33kP6tzqwP6+RgtObUqQU3fMC6
yJLorz+kBkhP6SXspXCA3EqOhTXV3WTDf/kfVALsWuclvIu4o1mPHip80U8BJG6+
aAnGhadxtcmXmetAaQhvv9+xb710MA==
=2ul/
-----END PGP SIGNATURE-----

--bp5rpkdrxtbu77ma--
