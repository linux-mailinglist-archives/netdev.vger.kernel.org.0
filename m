Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E175A5A3661
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 11:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiH0Jj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 05:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiH0Jj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 05:39:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3F78E9A5
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 02:39:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oRsHY-0002fm-VD; Sat, 27 Aug 2022 11:39:13 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 90DECD4E86;
        Sat, 27 Aug 2022 09:39:10 +0000 (UTC)
Date:   Sat, 27 Aug 2022 11:39:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <hmo@opensynergy.com>
Subject: Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
Message-ID: <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ieyz4olm27kc2bjr"
Content-Disposition: inline
In-Reply-To: <20220825134449.18803-1-harald.mommer@opensynergy.com>
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


--ieyz4olm27kc2bjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.08.2022 15:44:49, Harald Mommer wrote:
> - CAN Control
>=20
>   - "ip link set up can0" starts the virtual CAN controller,
>   - "ip link set up can0" stops the virtual CAN controller
>=20
> - CAN RX
>=20
>   Receive CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
>=20
> - CAN TX
>=20
>   Send CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
>=20
> - CAN Event indication (BusOff)
>=20
>   The bus off handling is considered code complete but until now bus off
>   handling is largely untested.

Is there an Open Source implementation of the host side of this
interface?

Please fix these checkpatch warnings:

| WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
| #65:=20
| new file mode 100644
|=20
| WARNING: Use #include <linux/atomic.h> instead of <asm/atomic.h>
| #105: FILE: drivers/net/can/virtio_can/virtio_can.c:7:
| +#include <asm/atomic.h>
|=20
| WARNING: __always_unused or __maybe_unused is preferred over __attribute_=
_((__unused__))
| #186: FILE: drivers/net/can/virtio_can/virtio_can.c:88:
| +static void __attribute__((unused))
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #263: FILE: drivers/net/can/virtio_can/virtio_can.c:165:
| +	BUG_ON(prio !=3D 0); /* Currently only 1 priority */
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #264: FILE: drivers/net/can/virtio_can/virtio_can.c:166:
| +	BUG_ON(atomic_read(&priv->tx_inflight[0]) >=3D priv->can.echo_skb_max);
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #279: FILE: drivers/net/can/virtio_can/virtio_can.c:181:
| +	BUG_ON(prio >=3D VIRTIO_CAN_PRIO_COUNT);
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #280: FILE: drivers/net/can/virtio_can/virtio_can.c:182:
| +	BUG_ON(idx >=3D priv->can.echo_skb_max);
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #281: FILE: drivers/net/can/virtio_can/virtio_can.c:183:
| +	BUG_ON(atomic_read(&priv->tx_inflight[prio]) =3D=3D 0);
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #288: FILE: drivers/net/can/virtio_can/virtio_can.c:190:
| +/*
| + * Create a scatter-gather list representing our input buffer and put
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #309: FILE: drivers/net/can/virtio_can/virtio_can.c:211:
| +/*
| + * Send a control message with message type either
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #332: FILE: drivers/net/can/virtio_can/virtio_can.c:234:
| +	/*
| +	 * The function may be serialized by rtnl lock. Not sure.
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #382: FILE: drivers/net/can/virtio_can/virtio_can.c:284:
| +/*
| + * See also m_can.c/m_can_set_mode()
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #408: FILE: drivers/net/can/virtio_can/virtio_can.c:310:
| +/*
| + * Called by issuing "ip link set up can0"
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #443: FILE: drivers/net/can/virtio_can/virtio_can.c:345:
| +	/*
| +	 * Keep RX napi active to allow dropping of pending RX CAN messages,
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #481: FILE: drivers/net/can/virtio_can/virtio_can.c:383:
| +	/*
| +	 * No local check for CAN_RTR_FLAG or FD frame against negotiated
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #521: FILE: drivers/net/can/virtio_can/virtio_can.c:423:
| +		/*
| +		 * May happen if
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #533: FILE: drivers/net/can/virtio_can/virtio_can.c:435:
| +	BUG_ON(can_tx_msg->putidx < 0);
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #613: FILE: drivers/net/can/virtio_can/virtio_can.c:515:
| +		/*
| +		 * Here also frames with result !=3D VIRTIO_CAN_RESULT_OK are
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #646: FILE: drivers/net/can/virtio_can/virtio_can.c:548:
| +/*
| + * Poll TX used queue for sent CAN messages
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #675: FILE: drivers/net/can/virtio_can/virtio_can.c:577:
| +/*
| + * This function is the NAPI RX poll function and NAPI guarantees that t=
his
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #698: FILE: drivers/net/can/virtio_can/virtio_can.c:600:
| +	BUG_ON(len < header_size);
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #813: FILE: drivers/net/can/virtio_can/virtio_can.c:715:
| +/*
| + * See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_cha=
nge().
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #855: FILE: drivers/net/can/virtio_can/virtio_can.c:757:
| +/*
| + * Poll RX used queue for received CAN messages
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #897: FILE: drivers/net/can/virtio_can/virtio_can.c:799:
| +		/*
| +		 * The interrupt function is not assumed to be interrupted by
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #904: FILE: drivers/net/can/virtio_can/virtio_can.c:806:
| +		BUG_ON(len < sizeof(struct virtio_can_event_ind));
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #966: FILE: drivers/net/can/virtio_can/virtio_can.c:868:
| +	/*
| +	 * The order of RX and TX is exactly the opposite as in console and
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #976: FILE: drivers/net/can/virtio_can/virtio_can.c:878:
| +	BUG_ON(!priv);
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #977: FILE: drivers/net/can/virtio_can/virtio_can.c:879:
| +	BUG_ON(!priv->vdev);
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #1004: FILE: drivers/net/can/virtio_can/virtio_can.c:906:
| +	/*
| +	 * From here we have dead silence from the device side so no locks
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #1025: FILE: drivers/net/can/virtio_can/virtio_can.c:927:
| +	/*
| +	 * Is keeping track of allocated elements by an own linked list
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #1060: FILE: drivers/net/can/virtio_can/virtio_can.c:962:
| +	BUG_ON(!vdev);
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #1063: FILE: drivers/net/can/virtio_can/virtio_can.c:965:
| +	/*
| +	 * CAN needs always access to the config space.
|=20
| WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code ra=
ther than BUG() or BUG_ON()
| #1090: FILE: drivers/net/can/virtio_can/virtio_can.c:992:
| +	BUG_ON(!vdev);
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #1144: FILE: drivers/net/can/virtio_can/virtio_can.c:1046:
| +	/*
| +	 * It is possible to consider the number of TX queue places to
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #1185: FILE: drivers/net/can/virtio_can/virtio_can.c:1087:
| +/*
| + * Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() a=
nd
|=20
| WARNING: networking block comments don't use an empty /* line, use /* Com=
ment...
| #1210: FILE: drivers/net/can/virtio_can/virtio_can.c:1112:
| +/*
| + * Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() a=
nd
|=20
| WARNING: Prefer "GPL" over "GPL v2" - see commit bf7fbeeae6db ("module: C=
ure the MODULE_LICENSE "GPL" vs. "GPL v2" bogosity")
| #1273: FILE: drivers/net/can/virtio_can/virtio_can.c:1175:
| +MODULE_LICENSE("GPL v2");
|=20
| WARNING: From:/Signed-off-by: email address mismatch: 'From: Harald Momme=
r <harald.mommer@opensynergy.com>' !=3D 'Signed-off-by: Harald Mommer <hmo@=
opensynergy.com>'
|=20
| total: 0 errors, 38 warnings, 1275 lines checked

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ieyz4olm27kc2bjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMJ5jkACgkQrX5LkNig
013IKwf/RPiDEx4DFsE7WOeFH67+0EDKByuackmB/TwczClnhN22zvAezavzFC35
dKs/xlC4tZ8k3yO8QMxIjb8EUQDPovXx8XKAVNztmMwdwimwYxeGjanCFyzFqz5m
qqcNOK1s/RqJ5mP4tHWzkbvZuf1mtrvk1cuDs53P6nbLkCVWp4AtYJihYRC+Ve2B
0o/5aHPMMQQ4qPEw2WNbKQcoNFwQ2UUzgXwwgrX00MXgfbUUS0h4Fs9R9FEiFLyN
sSEd3aK9ZJs8j98UuK/qvRxE6mjgBdXwUqk8QQ1eU27rtVOabBdMYQkaj34G4Zsd
WPlEdwBHmPrwnorafH/mrg3nG50/Aw==
=K4OV
-----END PGP SIGNATURE-----

--ieyz4olm27kc2bjr--
