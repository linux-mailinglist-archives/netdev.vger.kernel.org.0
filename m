Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDCB4DB9BC
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358068AbiCPUvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358064AbiCPUvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:51:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEB96E57B
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:49:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUaaL-0003rM-Hs; Wed, 16 Mar 2022 21:49:33 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-0549-f74e-91ef-4d7d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:549:f74e:91ef:4d7d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A094A4CBBD;
        Wed, 16 Mar 2022 20:48:20 +0000 (UTC)
Date:   Wed, 16 Mar 2022 21:48:20 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, appana.durga.rao@xilinx.com, git@xilinx.com,
        michal.simek@xilinx.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        akumarma@xilinx.com
Subject: Re: [PATCH v4] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Message-ID: <20220316204820.j3l4ltr3wihmlrop@pengutronix.de>
References: <20220316171105.17654-1-amit.kumar-mahapatra@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a5b6yhozna6aet3p"
Content-Disposition: inline
In-Reply-To: <20220316171105.17654-1-amit.kumar-mahapatra@xilinx.com>
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


--a5b6yhozna6aet3p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.03.2022 22:41:05, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
>=20
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

Added to linux-can-next/testing

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--a5b6yhozna6aet3p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIyTREACgkQrX5LkNig
013Piwf/e5VTDTzBS0Dh8q/NqJaCXA3U43tW8E/puSKudGMfRUawcd9s4Rn8yrDU
F+T953TYsHC4AaZJvCVGs43K9zOi2hsN3vvk0q1gQKCtVifXPqAZlZACTnaN2C3P
gzYvbVcrDnx95IFWi0/EJa1qpKBa1AtSY41cs2v+yjc4931ZIGWVlCsbwfxZ3ySC
ENwf5RYqW4EdmwRLUuLQCPY+BaJX+w0BYSB/a6qT0L/N8RLjoIDPpZgHERi44PtP
YHWg5rlcGAg3xhCHUzTJWzox/Je8IzzdLKrqydm8qlOFRT8trDROGaoMG7lFBh9Q
KTh5Fs5El+8/8BwFYkp6NE/QipPfJg==
=rasR
-----END PGP SIGNATURE-----

--a5b6yhozna6aet3p--
