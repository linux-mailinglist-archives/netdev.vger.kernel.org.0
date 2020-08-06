Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA3923DF79
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgHFRsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgHFQfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:35:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4ABC00216B
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 09:10:54 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3iTS-00046v-3l; Thu, 06 Aug 2020 18:10:34 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1k3iTL-0002vh-8h; Thu, 06 Aug 2020 18:10:27 +0200
Date:   Thu, 6 Aug 2020 18:10:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH net 0/4] support multipacket broadcast message
Message-ID: <20200806161027.py5ged3a23xpmxgi@pengutronix.de>
References: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q2ffmggcds5tcngt"
Content-Disposition: inline
In-Reply-To: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:56:06 up 265 days,  7:14, 243 users,  load average: 0.06, 0.07,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q2ffmggcds5tcngt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

Thank you for your patches! Currently I'm busy, but I'll take a look at it =
as
soon possible.

btw. can you tell me about more of your use case/work. I would like to
have some feedback about this stack. You can write a personal message,
if it is not for public.

On Wed, Aug 05, 2020 at 11:50:21AM +0800, Zhang Changzhong wrote:
> Zhang Changzhong (4):
>   can: j1939: fix support for multipacket broadcast message
>   can: j1939: cancel rxtimer on multipacket broadcast session complete
>   can: j1939: abort multipacket broadcast session when timeout occurs
>   can: j1939: add rxtimer for multipacket broadcast session
>=20
>  net/can/j1939/transport.c | 48 +++++++++++++++++++++++++++++++++++------=
------
>  1 file changed, 36 insertions(+), 12 deletions(-)

Regards,
Oleksij

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--q2ffmggcds5tcngt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl8sK24ACgkQ4omh9DUa
UbNKXw//YcVYtmARpdPi2H/KsMzVUNKAtJAJv/VLjfu4gMt7LKyUfwSAoTNQMgBF
rY5RMh3hoRlSY0lZnuGf+L1IRdfioOOzN1ljiUHW49t2oJdbE3KvOQjAHRd7HkdD
8THLbi2QZtP6bl6VtJP4kX6dUV1Y9mkQNlAClA24WbntnHJ3UmTE9200ZyAFf1zQ
bmo7j/TtQCcYZla4rewSh8/nwEySFkMV0+9afm2ihD9M6Vqly9nCGx8LKbbZJXHt
yAW4N82ZZcLmEz7tDf/kUemY5TVogSCZc8XxzZb8iaO+vlhdkpZpa/+WzHR78t4A
2wHHB8jLq5M8te3DzEZ0e+lnGE7nLOeTB8Xk0TAifArMkj+8JLTeFuopuvYaNGQh
L5BSG8iml24+WndixVtA7R4Fax4lvnUCgBTni3SJiwz55dBzKTOB/ZmJcyshMPKG
91bP/sUZ9nGROlWVw+Ehhi8rJSZAKhG1qdBkfxmxQCVxK4TS7AsuHMUOwHp3jVMb
1dMlDZ30AjTf9ITcFsLW0stGAUjJQJ/TR2vqCdn/ubTPzV7yAOFxCPAyz0dIx79w
0bPnOmapDKSYViCGxyJ0oSmDqpm1GjWtKnw0gueQLprQ1ObMJyN4R5Io0kdJ0dGS
4WBfpecsE9CN0fuAwBAt/nKCOUPWSPN6r3+lbQWYOa8PQonF6Cg=
=IVdX
-----END PGP SIGNATURE-----

--q2ffmggcds5tcngt--
