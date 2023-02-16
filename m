Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9286E699D5C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBPUGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBPUGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:06:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A884CCB4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:06:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pSkVz-0006B0-PE; Thu, 16 Feb 2023 21:05:59 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:607c:35c5:286c:4c04])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 43E3517B6B8;
        Thu, 16 Feb 2023 20:05:57 +0000 (UTC)
Date:   Thu, 16 Feb 2023 21:05:55 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pisa@cmp.felk.cvut.cz, ondrej.ille@gmail.com, wg@grandegger.com,
        pabeni@redhat.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] can: ctucanfd: Use devm_platform_ioremap_resource()
Message-ID: <20230216200555.5mpsoy2mwxumy352@pengutronix.de>
References: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zvcvcpouofvk2tqx"
Content-Disposition: inline
In-Reply-To: <20230216090610.130860-1-yang.lee@linux.alibaba.com>
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


--zvcvcpouofvk2tqx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.02.2023 17:06:10, Yang Li wrote:
> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to Use devm_platform_ioremap_resource(), as this is exactly
> what this function does.
>=20
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Applied to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zvcvcpouofvk2tqx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPujKEACgkQvlAcSiqK
BOjw+wgAsnc2VuTKjdqtG2G+OhdtxO+xJjB9fhsWiCxf/d4M0w4MjwmYwnE9iBZ3
9fzz9bKQ16i6QRHxztJuf9Cr58tpWntHJWSjr4HCOM34xUPsA8UJwL3dAKVwpBOf
2SwXuy7Hp/CMWhdtXQXPCjdYDKnlnrJhiHeJRnLa7rBO/hHQqG+OhIjLOCC8i+1D
ii+zf1FBrVpYTPRgpS0zpiI/YQ9iUEpBccZSwoXZrTC4PZuuA20xNWizkTHokVz5
cm4Qo6JsXo8/2aDPLfxqaeLrAZr5R8ofbdjgL+B7tS2hh0r/UWBA4OzSjAPlGImn
G9RQYp7c1T30x29CiFS1Nx/DoWw5NA==
=ZSrj
-----END PGP SIGNATURE-----

--zvcvcpouofvk2tqx--
