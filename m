Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66AF06C8226
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjCXQJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCXQJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:09:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CCA193E3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:09:38 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfjyn-0005vS-8r; Fri, 24 Mar 2023 17:09:25 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8110119BA0E;
        Fri, 24 Mar 2023 16:09:22 +0000 (UTC)
Date:   Fri, 24 Mar 2023 17:09:21 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] can: c_can: Remove redundant pci_clear_master
Message-ID: <20230324160921.gwdgz6aaeulg4v23@pengutronix.de>
References: <20230323113318.9473-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3s7q65ici2ku7z3m"
Content-Disposition: inline
In-Reply-To: <20230323113318.9473-1-cai.huoqing@linux.dev>
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


--3s7q65ici2ku7z3m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.03.2023 19:33:15, Cai Huoqing wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:

Applied to can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3s7q65ici2ku7z3m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQdyy4ACgkQvlAcSiqK
BOiijwf+MH6I2+oDV1zLj7HUkGWiHzloVpIdVMxCoqESuEw+PtWIqhVjknDWbSr8
w/oFexAxGCR2mu3tBxXg/ZNa4sQd61jxEWJzOTkGIpor2y+whqnAQTHzWF/AEBpV
TXVpAr8sfniSvSLK9FQS0D9yq/8A94AI54FJJjMmbo04Jo87+V2GqI0lj5VWppeF
mgCRPtPL1K4NBmbD4x7VkEa2bKhjnj6CVduLaJJhUUeX1kcGccTiljaDZCvnO1XC
9wI+WxDWOE2ssIVIG4AzUlaDnJ7m0pZleflk+o4qQp1c+ltnHAOah6ZNQnUKPr9Q
P5fQD2Dxfqbn3V6/QON7foje0mO+GA==
=MpZo
-----END PGP SIGNATURE-----

--3s7q65ici2ku7z3m--
