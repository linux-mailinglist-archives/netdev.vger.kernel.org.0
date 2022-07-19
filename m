Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA457A7E6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbiGSUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240001AbiGSUAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:00:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2575E802
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:59:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oDtNT-00009d-MM; Tue, 19 Jul 2022 21:59:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9774DB44FB;
        Tue, 19 Jul 2022 19:59:27 +0000 (UTC)
Date:   Tue, 19 Jul 2022 21:59:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Max Staudt <max@enpas.org>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
Message-ID: <87cze0swkm.fsf@hardanger.blackshift.org>
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
 <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
 <20220717233842.1451e349.max@enpas.org>
 <6faf29c7-3e9d-bc21-9eac-710f901085d8@hartkopp.net>
 <20220718101507.eioy2bdcmjkgtacz@pengutronix.de>
 <1dbd95e8-e6d7-a611-32d0-ea974787ff5a@hartkopp.net>
 <20220719030326.49f204f6.max@enpas.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ysl3shm5z3qhsg5m"
Content-Disposition: inline
In-Reply-To: <20220719030326.49f204f6.max@enpas.org>
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


--ysl3shm5z3qhsg5m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.07.2022 03:03:26, Max Staudt wrote:
> On Mon, 18 Jul 2022 12:23:05 +0200
> Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>=20
> > IMO it does not break user space when slcan gets the common naming=20
> > schema for CAN interface names.
>=20
> For what it's worth, slcan provides a specific ioctl to resolve from
> (tty fd) to (netdev name). As far as I can see, any sane program should
> use this API to find whatever device it has created, irrespective of
> the netdev name.
>=20
>=20
> @ Marc: slcand and slcan_attach in can-utils do not depend on the
> slcanX name, as far as I can see. They are the main interfaces to
> slcan, and apart from that I can only think of scripts doing netlink
> stuff and scanning for slcanX. Does this change your opinion, or is
> breaking such scripts already a step too far?
>=20
> I'm thinking that in other circumstances, I've had cases where devices
> were numbered differently just because they enumerated faster or slower
> at different boots, or with other kernel versions, or because of media
> inserted, etc. - though renumbering is of course one step less than
> changing the prefix.

Convinced! Please change the patch to use standard canX interface
naming. Can you add a pointer to the ioctl() to get the network
interface name to the tty fd in the patch description.

> > We had the same thing with 'eth0' which is now named enblablabla or=20
> > 'wlan0' now named wlp2s0.
>=20
> Actually, the kernel still calls them ethX and wlanX. It's systemd+udev
> that renames them to the "unique" names afterwards. It's an extra step
> that happens in userspace.
>=20
> udev is immensely useful, but also great stuff for race conditions :)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ysl3shm5z3qhsg5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLXDRwACgkQrX5LkNig
010B1Af+MvShZt0Wg4q2B453izcpmEdgMAr5fhWuOO4qOKRAR02A9/N+0FH9g2n2
FvO47MwZn2SNH61WupsbmVmdBlMcA4UZtr9U6fECqhIQstVcISJ75HFitf9Ox+LN
s2xzH7Ksh5qSI09VG205JUENUx5ExcrEebZRkX66L5SVgh05KToDLUCCKOBPmdqQ
SHrL51XBl0Os0grerSsiW5RbZOHpNWrSXvlhCg8WwZKb6JBxxPRFjd76h7I9lnS9
dzD42/EK7H7Sks92QXcDoE6iawYnEF4+vpCuUBLVXg785G/H9Qco2rGu6R7xYrMf
Ijp/T4E8yOMi5r5poXrbUR2g+Y1BZA==
=CrK0
-----END PGP SIGNATURE-----

--ysl3shm5z3qhsg5m--
