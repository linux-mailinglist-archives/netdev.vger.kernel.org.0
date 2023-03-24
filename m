Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D6A6C81F5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjCXP4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjCXP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:56:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C2722A29
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:56:49 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfjmN-0004MT-Sc; Fri, 24 Mar 2023 16:56:35 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 884E219B9F1;
        Fri, 24 Mar 2023 15:56:33 +0000 (UTC)
Date:   Fri, 24 Mar 2023 16:56:32 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        michael@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v7 0/5] can: bxcan: add support for ST bxCAN
 controller
Message-ID: <20230324155632.24chi5ndo23awhhp@pengutronix.de>
References: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
 <CABGWkvpHHLNzZHDMzWveoHtApmR3czVvoCOnuWBZt-UoLVU-6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cnvdke4jgm2e3ndt"
Content-Disposition: inline
In-Reply-To: <CABGWkvpHHLNzZHDMzWveoHtApmR3czVvoCOnuWBZt-UoLVU-6g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cnvdke4jgm2e3ndt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.03.2023 12:25:15, Dario Binacchi wrote:
> A gentle ping to remind you of this series.
> I have no idea why it hasn't deserved any response for quite some
> time.
> Is there anything I am still missing?

I wonder if we want to do a s/master/primary/ in the DT bindings and
driver?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cnvdke4jgm2e3ndt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQdyC0ACgkQvlAcSiqK
BOjDgggAgzBxnVVNE5XscW/qYXMVblL8TcW+JtgR2e6p+TtN0u7OioDJmlfvtl9q
IlRl7/cJkB9uAyVo4dUILKfekHx18vxAqc0txekYY2KQRHAjv5jtuVzaIJylaJEA
9EyCMp8t1jMBHK0irZ4q8xfzaON5deaFT2/rKyuWGfQA5650ZaTjoZYL9dHCSEiB
I9KBbbOxVS2ILDPyMcmj5ESg/rbig4VhoDObjz1VeFwd3mrCTg4N74lCO9jvphiB
tz0r/IX5oLQcwK++eafeLnPUywTnBL6nu09zhn9pz5EFSDScpmvasXZ0uSZigy26
PE1s/CCS31M48DSu1689rSXu7SSI3A==
=dNbz
-----END PGP SIGNATURE-----

--cnvdke4jgm2e3ndt--
