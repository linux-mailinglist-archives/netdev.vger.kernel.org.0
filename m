Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D5F2A171C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 12:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgJaLvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 07:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727288AbgJaLkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 07:40:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678B0C0613D7
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 04:40:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kYpEx-0007mN-Le; Sat, 31 Oct 2020 12:40:11 +0100
Received: from [IPv6:2a03:f580:87bc:d400:dcc0:5662:7742:3902] (unknown [IPv6:2a03:f580:87bc:d400:dcc0:5662:7742:3902])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6B8B9587083;
        Sat, 31 Oct 2020 11:40:09 +0000 (UTC)
Subject: Re: [PATCH v7 0/6] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
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
References: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <babcc2a2-8051-b542-3748-18324f2778df@pengutronix.de>
Date:   Sat, 31 Oct 2020 12:40:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="pHGK3qOT5AE1di0F7vN1s8WmJCRRlr4tV"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pHGK3qOT5AE1di0F7vN1s8WmJCRRlr4tV
Content-Type: multipart/mixed; boundary="W5s4VrYBHK1Vx9qcNDS91wyxP3zRIfMeR";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
 devicetree@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
 David Miller <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
 mark.rutland@arm.com, Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Marin Jerabek <martin.jerabek01@gmail.com>,
 Ondrej Ille <ondrej.ille@gmail.com>, Jiri Novak <jnovak@fel.cvut.cz>,
 Jaroslav Beran <jara.beran@gmail.com>, Petr Porazil <porazil@pikron.com>,
 Pavel Machek <pavel@ucw.cz>, Drew Fustini <pdp7pdp7@gmail.com>
Message-ID: <babcc2a2-8051-b542-3748-18324f2778df@pengutronix.de>
Subject: Re: [PATCH v7 0/6] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
References: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1604095004.git.pisa@cmp.felk.cvut.cz>

--W5s4VrYBHK1Vx9qcNDS91wyxP3zRIfMeR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/30/20 11:19 PM, Pavel Pisa wrote:
> This driver adds support for the CTU CAN FD open-source IP core.

Please fix the following spelling mistakes:

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -752,7 +752,7 @@ static void ctucan_tx_interrupt(struct net_device *nd=
ev)
 /**
  * ctucan_interrupt - CAN Isr
  * @irq:       irq number
- * @dev_id:    device id poniter
+ * @dev_id:    device id pointer
  *
  * This is the CTU CAN FD ISR. It checks for the type of interrupt
  * and invokes the corresponding ISR.
diff --git a/drivers/net/can/ctucanfd/ctucanfd_hw.h b/drivers/net/can/ctu=
canfd/ctucanfd_hw.h
index 7d562f41ca52..2fd2416de46d 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_hw.h
+++ b/drivers/net/can/ctucanfd/ctucanfd_hw.h
@@ -211,7 +211,7 @@ bool ctucan_hw_set_ret_limit(struct ctucan_hw_priv *p=
riv, bool enable,
  *     CAN_CTRLMODE_LISTENONLY - No frame is transmitted, no dominant bi=
t is
  *                               sent on the bus.
  *
- *     CAN_CTRLMODE_3_SAMPLES  - Tripple sampling mode
+ *     CAN_CTRLMODE_3_SAMPLES  - Triple sampling mode
  *
  *     CAN_CTRLMODE_FD         - Flexible data-rate support. When not se=
t, Core
  *                               does not accept CAN FD Frames and inter=
prets,
@@ -680,7 +680,7 @@ void ctucan_hw_set_rx_tsop(struct ctucan_hw_priv *pri=
v,
  *
  * @priv: Private info
  *
- * Return: The firts word of received frame
+ * Return: The first word of received frame
  */
 static inline union ctu_can_fd_frame_format_w
        ctu_can_fd_read_rx_ffw(struct ctucan_hw_priv *priv)
@@ -908,7 +908,7 @@ static inline union ctu_can_fd_debug_register
  * ctucan_hw_read_timestamp - Read timestamp value which is used interna=
lly
  *                             by CTU CAN FD Core.
  *
- * Reads timestamp twice and checks consistency betwen upper and
+ * Reads timestamp twice and checks consistency between upper and
  * lower timestamp word.
  *
  * @priv: Private info

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--W5s4VrYBHK1Vx9qcNDS91wyxP3zRIfMeR--

--pHGK3qOT5AE1di0F7vN1s8WmJCRRlr4tV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+dTRUACgkQqclaivrt
76n8EAf/TvrWWEtWu2fn+uGQPhIZWbXSNVwShThRvcx+pwMvUMtvTcHsmfbpUQND
EH902MlE/MS35htwyCZBxn5XoqW2wDkFXViabNtliLEqlLz9RLGCSD2MQzGZ1sZX
fAds1hZpADf7e12ucZRI82zJn+ynRxHX7ClVvgxX/ozNR+tjvBMBi8PHfXCYRPCR
jX4oNBPNYE275/BUjouEFuqGmL2jlbnN8e7tMw9rNw410tcL8eXFdGg6KjiG+TVw
FVfJrGfUTNj7K53Q0hgYrardmXRLrPN+fOBOIrhHZVHVRH6FogykJzWrp2l/5rHm
/ONaoQeNyHCWfRy8aWf6g53WLYa5IQ==
=W6Nr
-----END PGP SIGNATURE-----

--pHGK3qOT5AE1di0F7vN1s8WmJCRRlr4tV--
