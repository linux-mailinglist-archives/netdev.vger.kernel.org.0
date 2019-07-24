Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4355272AEF
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfGXJAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:00:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39237 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfGXJAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:00:34 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqD8Q-00052Q-Uu; Wed, 24 Jul 2019 11:00:31 +0200
Received: from [IPv6:2003:c7:729:c703:c9d4:83d5:b99:4f4d] (unknown [IPv6:2003:c7:729:c703:c9d4:83d5:b99:4f4d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F20BD437B37;
        Wed, 24 Jul 2019 09:00:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: pull-request: can-next 2019-07-24
Message-ID: <93540cba-184a-a9c5-f9d2-b1779a69a36f@pengutronix.de>
Date:   Wed, 24 Jul 2019 11:00:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="mcwcQRZcymoRCEPFj9qin1ccxdXCla9Fm"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mcwcQRZcymoRCEPFj9qin1ccxdXCla9Fm
Content-Type: multipart/mixed; boundary="Ny076OquJ5tQUUcfzJ1ODEqRkRFUVdKW8";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, kernel@pengutronix.de, linux-can@vger.kernel.org
Message-ID: <93540cba-184a-a9c5-f9d2-b1779a69a36f@pengutronix.de>
Subject: pull-request: can-next 2019-07-24

--Ny076OquJ5tQUUcfzJ1ODEqRkRFUVdKW8
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello David,

this is a pull request for net-next/master consisting of 26 patches.

The first two patches are by me. One adds missing files of the CAN
subsystem to the MAINTAINERS file, while the other sorts the
Makefile/Kconfig of the sja1000 drivers sub directory. In the next patch
Ji-Ze Hong (Peter Hong) provides a driver for the "Fintek PCIE to 2 CAN"
controller, based on the the sja1000 IP core.

Gustavo A. R. Silva's patch for the kvaser_usb driver introduces the use
of struct_size() instead of open coding it. Henning Colliander's patch
adds a driver for the "Kvaser PCIEcan" devices.

Another patch by Gustavo A. R. Silva marks expected switch fall-throughs
properly.

Dan Murphy provides 5 patches for the m_can. After cleanups a framework
is introduced so that the driver can be used from memory mapped IO as
well as SPI attached devices. Finally he adds a driver for the tcan4x5x
which uses this framework.

A series of 5 patches by Appana Durga Kedareswara rao for the xilinx_can
driver, first clean up,then add support for CANFD. Colin Ian King
contributes another cleanup for the xilinx_can driver.

Robert P. J. Day's patch corrects the brief history of the CAN protocol
given in the Kconfig menu entry.

2 patches by Dong Aisheng for the flexcan driver provide PE clock source
select support and dt-bindings description.
2 patches by Sean Nyekjaer for the flexcan driver provide add CAN
wakeup-source property and dt-bindings description.

Jeroen Hofstee's patch converts the ti_hecc driver to make use of the
rx-offload helper fixing a number of outstanding bugs.

The first patch of Oliver Hartkopp removes the now obsolete empty
ioctl() handler for the CAN protocols. The second patch adds SPDX
license identifiers for CAN subsystem.

regards,
Marc

---

The following changes since commit 3e3bb69589e482e0783f28d4cd1d8e56fda0bc=
bb:

  tc-testing: added tdc tests for [b|p]fifo qdisc (2019-07-23 14:08:15 -0=
700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git ta=
gs/linux-can-next-for-5.4-20190724

for you to fetch changes up to fba76a58452694b9b13c07e48839fa84c75f57af:

  can: Add SPDX license identifiers for CAN subsystem (2019-07-24 10:31:5=
5 +0200)

----------------------------------------------------------------
linux-can-next-for-5.4-20190724

----------------------------------------------------------------
Aisheng Dong (1):
      can: flexcan: implement can Runtime PM

Appana Durga Kedareswara rao (5):
      can: xilinx_can: Fix style issues
      can: xilinx_can: Fix kernel doc warnings
      can: xilinx_can: Fix flags field initialization for axi can and can=
ps
      can: xilinx_can: Add cantype parameter in xcan_devtype_data struct
      can: xilinx_can: Add support for CANFD FD frames

Colin Ian King (1):
      can: xilinx_can: clean up indentation issue

Dan Murphy (5):
      can: m_can: Fix checkpatch issues on existing code
      can: m_can: Create a m_can platform framework
      can: m_can: Rename m_can_priv to m_can_classdev
      dt-bindings: can: tcan4x5x: Add DT bindings for TCAN4x5X driver
      can: tcan4x5x: Add tcan4x5x driver to the kernel

Dong Aisheng (2):
      dt-bindings: can: flexcan: add PE clock source property to device t=
ree
      can: flexcan: add support for PE clock source select

Gustavo A. R. Silva (2):
      can: kvaser_usb: Use struct_size() in alloc_candev()
      can: mark expected switch fall-throughs

Henning Colliander (1):
      can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices

Jeroen Hofstee (1):
      can: ti_hecc: use timestamp based rx-offloading

Ji-Ze Hong (Peter Hong) (1):
      can: sja1000: f81601: add Fintek F81601 support

Marc Kleine-Budde (2):
      MAINTAINERS: can: add missing files to CAN NETWORK DRIVERS and CAN =
NETWORK LAYER
      can: sja1000: Makefile/Kconfig: sort alphabetically

Oliver Hartkopp (2):
      can: remove obsolete empty ioctl() handler
      can: Add SPDX license identifiers for CAN subsystem

Robert P. J. Day (1):
      can: Kconfig: correct history of the CAN protocol

Sean Nyekjaer (2):
      dt-bindings: can: flexcan: add can wakeup property
      can: flexcan: add support for DT property 'wakeup-source'

 .../devicetree/bindings/net/can/fsl-flexcan.txt    |   10 +
 .../devicetree/bindings/net/can/tcan4x5x.txt       |   37 +
 MAINTAINERS                                        |    5 +
 drivers/net/can/Kconfig                            |   13 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/at91_can.c                         |    6 +-
 drivers/net/can/flexcan.c                          |  136 +-
 drivers/net/can/kvaser_pciefd.c                    | 1912 ++++++++++++++=
++++++
 drivers/net/can/m_can/Kconfig                      |   22 +-
 drivers/net/can/m_can/Makefile                     |    2 +
 drivers/net/can/m_can/m_can.c                      | 1079 +++++------
 drivers/net/can/m_can/m_can.h                      |  110 ++
 drivers/net/can/m_can/m_can_platform.c             |  202 +++
 drivers/net/can/m_can/tcan4x5x.c                   |  532 ++++++
 drivers/net/can/peak_canfd/peak_pciefd_main.c      |    2 +-
 drivers/net/can/sja1000/Kconfig                    |   79 +-
 drivers/net/can/sja1000/Makefile                   |   11 +-
 drivers/net/can/sja1000/f81601.c                   |  212 +++
 drivers/net/can/spi/mcp251x.c                      |    3 +-
 drivers/net/can/ti_hecc.c                          |  191 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |    3 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |    2 +-
 drivers/net/can/xilinx_can.c                       |  293 ++-
 include/linux/can/core.h                           |    3 +-
 include/linux/can/skb.h                            |    2 +-
 net/can/Kconfig                                    |   11 +-
 net/can/af_can.c                                   |   10 +-
 net/can/af_can.h                                   |    1 +
 net/can/bcm.c                                      |    3 +-
 net/can/gw.c                                       |    1 +
 net/can/proc.c                                     |    1 +
 net/can/raw.c                                      |    3 +-
 32 files changed, 4098 insertions(+), 800 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/tcan4x5x.tx=
t
 create mode 100644 drivers/net/can/kvaser_pciefd.c
 create mode 100644 drivers/net/can/m_can/m_can.h
 create mode 100644 drivers/net/can/m_can/m_can_platform.c
 create mode 100644 drivers/net/can/m_can/tcan4x5x.c
 create mode 100644 drivers/net/can/sja1000/f81601.c

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |-
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |






--Ny076OquJ5tQUUcfzJ1ODEqRkRFUVdKW8--

--mcwcQRZcymoRCEPFj9qin1ccxdXCla9Fm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl04HigACgkQWsYho5Hk
nSBEdQf/f1itwIrD0OxlTvEXBspSy9dVCFphyt2sWUe3VU5wOd8HD65QzEGJde7I
Ny/BBbyNpeXcyUKtBcCsDGH0IRodm+kxXhdFEb0QiT5UTLXgMvYQSqnIvqx8CwWb
Ux5fGMwv77vqtdVfwGYTpj55gIuB2ufWRZylioq9TEp0AYqE+YWKA3OEAYb0D6MT
FVxorSCqEXi6FxNlslc+OeeyjIP/7NqiIG8bxfxonheZUbkp9uoJo1wzq4cEOgb2
yaOTGb+w3RA5tud5Kj+Rm7rYys6DER5T9z2s/L6R3+DuR3T53iqNRddxZid0M5jo
CYfK5OpmfCetszPH9Pdl7bKo7mn9Mw==
=Wgs/
-----END PGP SIGNATURE-----

--mcwcQRZcymoRCEPFj9qin1ccxdXCla9Fm--
