Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995158CBCE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 08:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfHNGQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 02:16:43 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49239 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfHNGQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 02:16:43 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hxmaN-0005zq-Vd; Wed, 14 Aug 2019 08:16:40 +0200
Received: from [IPv6:2001:67c:670:202:595f:209f:a34b:fbc1] (unknown [IPv6:2001:67c:670:202:595f:209f:a34b:fbc1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 17427444EE2;
        Wed, 14 Aug 2019 06:16:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: pull-request: can-next 2019-08-14
Message-ID: <f0658ccd-389f-fc60-7538-c512112b9978@pengutronix.de>
Date:   Wed, 14 Aug 2019 08:16:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tT6upIpksf70DqJYx4HU3tzNJSTM4Bj7e"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tT6upIpksf70DqJYx4HU3tzNJSTM4Bj7e
Content-Type: multipart/mixed; boundary="fzRiYf3JlkZf0FPiKDHpQZU25i5AIWrq9";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, kernel@pengutronix.de, linux-can@vger.kernel.org
Message-ID: <f0658ccd-389f-fc60-7538-c512112b9978@pengutronix.de>
Subject: pull-request: can-next 2019-08-14

--fzRiYf3JlkZf0FPiKDHpQZU25i5AIWrq9
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello David,

this is a pull request for net-next/master consisting of 41 patches.

The first two patches are for the kvaser_pciefd driver: Christer Beskow
removes unnecessary code in the kvaser_pciefd_pwm_stop() function,
YueHaibing removes the unused including of <linux/version.h>.

In the next patch YueHaibing also removes the unused including of
<linux/version.h> in the f81601 driver.

In the ti_hecc driver the next 6 patches are by me and fix checkpatch
warnings. YueHaibing's patch removes an unused variable in the
ti_hecc_mailbox_read() function.

The next 6 patches all target the xilinx_can driver. Anssi Hannula's
patch fixes a chip start failure with an invalid bus. The patch by
Venkatesh Yadav Abbarapu skips an error message in case of a deferred
probe. The 3 patches by Appana Durga Kedareswara rao fix the RX and TX
path for CAN-FD frames. Srinivas Neeli's patch fixes the bit timing
calculations for CAN-FD.

The next 12 patches are by me and several checkpatch warnings in the
af_can, raw and bcm components.

Thomas Gleixner provides a patch for the bcm, which switches the timer
to HRTIMER_MODE_SOFT and removes the hrtimer_tasklet.

Then 6 more patches by me for the gw component, which fix checkpatch
warnings, followed by 2 patches by Oliver Hartkopp to add CAN-FD
support.

The vcan driver gets 3 patches by me, fixing checkpatch warnings.

And finally a patch by Andre Hartmann to fix typos in CAN's netlink
header.

regards,
Marc

---

The following changes since commit 53f6f391786e01bf2050c03d8a36d9defdcc28=
31:

  caif: no need to check return value of debugfs_create functions (2019-0=
8-11 21:31:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git ta=
gs/linux-can-next-for-5.4-20190814

for you to fetch changes up to 3ca3c4aad2efa2931b663acc4ece7a38b31071d1:

  can: netlink: fix documentation typos (2019-08-13 17:32:21 +0200)

----------------------------------------------------------------
linux-can-next-for-5.4-20190814

----------------------------------------------------------------
Andre Hartmann (1):
      can: netlink: fix documentation typos

Anssi Hannula (1):
      can: xilinx_can: xcan_chip_start(): fix failure with invalid bus

Appana Durga Kedareswara rao (3):
      can: xilinx_can: xcanfd_rx(): fix FSR register handling in the RX p=
ath
      can: xilinx_can: fix the data update logic for CANFD FD frames
      can: xilinx_can: xcan_rx_fifo_get_next_frame(): fix FSR register FL=
 and RI mask values for canfd 2.0

Christer Beskow (1):
      can: kvaser_pciefd: kvaser_pciefd_pwm_stop(): remove unnecessary co=
de when setting pwm duty cycle to zero

Marc Kleine-Budde (27):
      can: ti_hecc: convert block comments to network style comments
      can: ti_hecc: fix indention
      can: ti_hecc: avoid long lines
      can: ti_hecc: fix print formating strings
      can: ti_hecc: ti_hecc_start(): avoid multiple assignments
      can: ti_hecc: ti_hecc_mailbox_read(): add blank lines to improve re=
adability
      can: af_can: convert block comments to network style comments
      can: af_can: balance braces around else statements
      can: af_can: fix alignment
      can: af_can: avoid splitting quoted string across lines
      can: af_can: can_pernet_init(): Use preferred style kzalloc(sizeof(=
)) usage
      can: af_can: add missing identifiers to struct receiver::func
      can: raw: convert block comments to network style comments
      can: raw: remove unnecessary blank lines, add suggested blank lines=

      can: raw: balance braces around else statements
      can: raw: raw_module_init(): use pr_err() instead of printk(KERN_ER=
R, ...)
      can: raw: raw_sock_no_ioctlcmd(): mark function as static
      can: bcm: bcm_sock_no_ioctlcmd(): mark function as static
      can: gw: convert block comments to network style comments
      can: gw: remove unnecessary blank lines, add suggested blank lines
      can: gw: add missing spaces around operators
      can: gw: can_can_gw_rcv(): remove return at end of void function
      can: gw: cgw_dump_jobs(): avoid long lines
      can: gw: cgw_parse_attr(): remove unnecessary braces for single sta=
tement block
      can: vcan: convert block comments to network style comments
      can: vcan: remove unnecessary blank lines
      can: vcan: introduce pr_fmt and make use of it

Oliver Hartkopp (2):
      can: gw: use struct canfd_frame as internal data structure
      can: gw: add support for CAN FD frames

Srinivas Neeli (1):
      can: xilinx_can: xcan_set_bittiming(): fix the data phase btr1 calc=
ulation

Thomas Gleixner (1):
      can: bcm: switch timer to HRTIMER_MODE_SOFT and remove hrtimer_task=
let

Venkatesh Yadav Abbarapu (1):
      can: xilinx_can: xcan_probe(): skip error message on deferred probe=


YueHaibing (3):
      can: kvaser_pciefd: Remove unused including <linux/version.h>
      can: sja1000: f81601: remove unused including <linux/version.h>
      can: ti_hecc: ti_hecc_mailbox_read(): remove set but not used varia=
ble 'mbx_mask'

 drivers/net/can/kvaser_pciefd.c  |  11 +-
 drivers/net/can/sja1000/f81601.c |   1 -
 drivers/net/can/ti_hecc.c        |  85 ++++---
 drivers/net/can/vcan.c           |  19 +-
 drivers/net/can/xilinx_can.c     | 175 ++++++--------
 include/uapi/linux/can/gw.h      |  17 +-
 include/uapi/linux/can/netlink.h |   6 +-
 net/can/af_can.c                 |  89 +++----
 net/can/af_can.h                 |   5 +-
 net/can/bcm.c                    | 160 +++++-------
 net/can/gw.c                     | 510 +++++++++++++++++++++++++--------=
------
 net/can/raw.c                    |  34 ++-
 12 files changed, 579 insertions(+), 533 deletions(-)

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |-
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |








--fzRiYf3JlkZf0FPiKDHpQZU25i5AIWrq9--

--tT6upIpksf70DqJYx4HU3tzNJSTM4Bj7e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl1TpzgACgkQWsYho5Hk
nSA51Qf/ZNawLD88769eVybOvf28da4wye9OwAvplgBDGZCuNN0bFyBEOwVeSVgY
jjLPhs3enYDyLHoNTrxuPD0/w1jlc9AbIDtm6qWJSy2VkRvq79s0pXgSXCOxAogT
4mVsry61S59rcJLhj9BGsAxSbBSruAW0VDtl3n7PU3bijft3YkW9tbOPp7ajYcsB
85uaBEjFupR3Zf8ILvb8khZUemc7bV7PiulBdDiFv6VFFLUuKptzcv1WQgyJcixN
PKche9NAmqdjpwVYBMSQ4I9jEFl9kjwJB9AMof36QCUu/FcZZamD9J1EPN6Rwpu9
zrb4qi7HA/rSpc2H6JsSQqdBSlZYvA==
=Jm2o
-----END PGP SIGNATURE-----

--tT6upIpksf70DqJYx4HU3tzNJSTM4Bj7e--
