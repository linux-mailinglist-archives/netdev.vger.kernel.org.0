Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD5439747
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhJYNPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbhJYNPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:15:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0E4C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 06:12:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mezlf-0000lR-Oi; Mon, 25 Oct 2021 15:11:59 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-d7c8-7df6-a4ac-55f0.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d7c8:7df6:a4ac:55f0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 51E3C69D67D;
        Mon, 25 Oct 2021 13:11:50 +0000 (UTC)
Date:   Mon, 25 Oct 2021 15:11:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, amitc@mellanox.com, idosch@idosch.org,
        danieller@nvidia.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V4 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211025131149.ya42sw64vkh7zrcr@pengutronix.de>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-5-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ntrls4rhrigaspck"
Content-Disposition: inline
In-Reply-To: <20211014113943.16231-5-huangguangbin2@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ntrls4rhrigaspck
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2021 19:39:41, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
>=20
> Add two new parameters ringparam_ext and extack for
> .get_ringparam and .set_ringparam to extend more ring params
> through netlink.
>=20
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>

While discussing a different ethtool ring param extension, Andrew Lunn
suggested a different approach to extend the get/set_ringparam
callbacks. See:

https://lore.kernel.org/all/YXaimhlXkpBKRQin@lunn.ch/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ntrls4rhrigaspck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmF2rRIACgkQqclaivrt
76n5tgf/TDqh5rLwE8ioUgOIyWQQ89IWZEELsdebvOV3prQCQ5JwbHhDeYuRawkk
uReapAiNI0n6rb2CRf2hO85ngwPMrJcWbWoMK0pkn6ih/YRgeamEMASs7EYaB6xT
YE7SUWnEfbQYxmJUNPqizL+0hJqAOaMqQ1Bcb73b1vT1UVT3Yafla0rbqRmoqBLm
ZVwefAkU+eKMhxUt4eAo4XvB52ui9ahLoug8M19u1h6aMlOCak+y9LLDwO1/lItE
0osicrwTmbL4DNPjiZBF9Nhp5vd26ni1j/Npjv4kWQQ2rU443aw2FEKe++dGaGC7
0iF42Hq4PtTVLmlxdzTxi/JKiGK40A==
=gUwe
-----END PGP SIGNATURE-----

--ntrls4rhrigaspck--
