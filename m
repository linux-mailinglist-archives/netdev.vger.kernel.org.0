Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9CA82CF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDMaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:30:16 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50487 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfIDMaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 08:30:16 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1i5UQL-0006wA-5r; Wed, 04 Sep 2019 14:30:09 +0200
Received: from [IPv6:2a03:f580:87bc:d400:746e:2448:cd8f:dc51] (unknown [IPv6:2a03:f580:87bc:d400:746e:2448:cd8f:dc51])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 016A045321C;
        Wed,  4 Sep 2019 12:30:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Bastian Stender <bst@pengutronix.de>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <ore@pengutronix.de>,
        David Jander <david@protonic.nl>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: pull-request: can-next 2019-09-04 j1939
Message-ID: <d56029d4-2d4c-3cb3-0e5b-e28866db87f1@pengutronix.de>
Date:   Wed, 4 Sep 2019 14:29:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="gxFURhHboClmdQqNh66DFNgv0T72J1UIn"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gxFURhHboClmdQqNh66DFNgv0T72J1UIn
Content-Type: multipart/mixed; boundary="7jhhL6AeQNjl7rWVrrLihX2llfScyTDCn";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, kernel@pengutronix.de, linux-can@vger.kernel.org,
 Oliver Hartkopp <socketcan@hartkopp.net>,
 Bastian Stender <bst@pengutronix.de>, Elenita Hinds <ecathinds@gmail.com>,
 Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
 Maxime Jayat <maxime.jayat@mobile-devices.fr>,
 Robin van der Gracht <robin@protonic.nl>, Oleksij Rempel
 <ore@pengutronix.de>, David Jander <david@protonic.nl>
Message-ID: <d56029d4-2d4c-3cb3-0e5b-e28866db87f1@pengutronix.de>
Subject: pull-request: can-next 2019-09-04 j1939

--7jhhL6AeQNjl7rWVrrLihX2llfScyTDCn
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello David,

this is a pull request for net-next/master consisting of 21 patches.

the first 12 patches are by me and target the CAN core infrastructure.
They clean up the names of variables , structs and struct members,
convert can_rx_register() to use max() instead of open coding it and
remove unneeded code from the can_pernet_exit() callback.

The next three patches are also by me and they introduce and make use of
the CAN midlayer private structure. It is used to hold protocol specific
per device data structures.

The next patch is by Oleksij Rempel, switches the
&net->can.rcvlists_lock from a spin_lock() to a spin_lock_bh(), so that
it can be used from NAPI (soft IRQ) context.

The next 4 patches are by Kurt Van Dijck, he first updates his email
address via mailmap and then extends sockaddr_can to include j1939
members.

The final patch is the collective effort of many entities (The j1939
authors: Oliver Hartkopp, Bastian Stender, Elenita Hinds, kbuild test
robot, Kurt Van Dijck, Maxime Jayat, Robin van der Gracht, Oleksij
Rempel, Marc Kleine-Budde). It adds support of SAE J1939 protocol to the
CAN networking stack.

SAE J1939 is the vehicle bus recommended practice used for communication
and diagnostics among vehicle components. Originating in the car and
heavy-duty truck industry in the United States, it is now widely used in
other parts of the world.

regards,
Marc

P.S.: This pull request doesn't invalidate my last pull request:
      "pull-request: can-next 2019-09-03".

---

The following changes since commit 2c1f9e26344483e2c74e80ef708d9c7fd2e543=
f4:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/=
jkirsher/next-queue (2019-09-03 21:51:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git ta=
gs/linux-can-next-for-5.4-20190904

for you to fetch changes up to 9d71dd0c70099914fcd063135da3c580865e924c:

  can: add support of SAE J1939 protocol (2019-09-04 14:22:33 +0200)

----------------------------------------------------------------
linux-can-next-for-5.4-20190904

----------------------------------------------------------------
Kurt Van Dijck (4):
      mailmap: update email address
      can: introduce CAN_REQUIRED_SIZE macro
      can: add socket type for CAN_J1939
      can: extend sockaddr_can to include j1939 members

Marc Kleine-Budde (15):
      can: netns: give structs holding the CAN statistics a sensible name=

      can: netns: give members of struct netns_can holding the statistics=
 a sensible name
      can: af_can: give variables holding CAN statistics a sensible name
      can: proc: give variables holding CAN statistics a sensible name
      can: netns: remove "can_" prefix from members struct netns_can
      can: af_can: give variable holding the CAN per device receive lists=
 a sensible name
      can: proc: give variable holding the CAN per device receive lists a=
 sensible name
      can: af_can: rename find_rcv_list() to can_rcv_list_find()
      can: af_can: rename find_dev_rcv_lists() to can_dev_rcv_lists_find(=
)
      can: af_can: give variable holding the CAN receiver and the receive=
r list a sensible name
      can: af_can: can_rx_register(): use max() instead of open coding it=

      can: af_can: can_pernet_exit(): no need to iterate over and cleanup=
 registered CAN devices
      can: introduce CAN midlayer private and allocate it automatically
      can: make use of preallocated can_ml_priv for per device struct can=
_dev_rcv_lists
      can: af_can: remove NULL-ptr checks from users of can_dev_rcv_lists=
_find()

Oleksij Rempel (1):
      can: af_can: use spin_lock_bh() for &net->can.rcvlists_lock

The j1939 authors (1):
      can: add support of SAE J1939 protocol

 .mailmap                           |    1 +
 Documentation/networking/index.rst |    1 +
 Documentation/networking/j1939.rst |  422 ++++++++
 MAINTAINERS                        |   10 +
 drivers/net/can/dev.c              |   24 +-
 drivers/net/can/slcan.c            |    6 +-
 drivers/net/can/vcan.c             |    7 +-
 drivers/net/can/vxcan.c            |    4 +-
 include/linux/can/can-ml.h         |   68 ++
 include/linux/can/core.h           |    8 +
 include/net/netns/can.h            |   14 +-
 include/uapi/linux/can.h           |   20 +-
 include/uapi/linux/can/j1939.h     |   99 ++
 net/can/Kconfig                    |    2 +
 net/can/Makefile                   |    2 +
 net/can/af_can.c                   |  302 +++---
 net/can/af_can.h                   |   19 +-
 net/can/bcm.c                      |    4 +-
 net/can/j1939/Kconfig              |   15 +
 net/can/j1939/Makefile             |   10 +
 net/can/j1939/address-claim.c      |  230 ++++
 net/can/j1939/bus.c                |  333 ++++++
 net/can/j1939/j1939-priv.h         |  338 ++++++
 net/can/j1939/main.c               |  403 +++++++
 net/can/j1939/socket.c             | 1160 +++++++++++++++++++++
 net/can/j1939/transport.c          | 2027 ++++++++++++++++++++++++++++++=
++++++
 net/can/proc.c                     |  163 +--
 net/can/raw.c                      |    4 +-
 28 files changed, 5398 insertions(+), 298 deletions(-)
 create mode 100644 Documentation/networking/j1939.rst
 create mode 100644 include/linux/can/can-ml.h
 create mode 100644 include/uapi/linux/can/j1939.h
 create mode 100644 net/can/j1939/Kconfig
 create mode 100644 net/can/j1939/Makefile
 create mode 100644 net/can/j1939/address-claim.c
 create mode 100644 net/can/j1939/bus.c
 create mode 100644 net/can/j1939/j1939-priv.h
 create mode 100644 net/can/j1939/main.c
 create mode 100644 net/can/j1939/socket.c
 create mode 100644 net/can/j1939/transport.c

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |-
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |














--7jhhL6AeQNjl7rWVrrLihX2llfScyTDCn--

--gxFURhHboClmdQqNh66DFNgv0T72J1UIn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl1vrkQACgkQWsYho5Hk
nSBcfwf+Lj+UN6ZZKihUPvDBcRvcC3awc2ad/h7wkYuWvNuMJ0o6OdDjWve+IujB
RD+VpaF68tOiDkKLiaPoLvTM3+/7y/p3yJTcl73FbVDskMZcpKMphLx9S0bOLmp1
PCsU1DUq8qXdHeD8zJutOTu/iIeJWWi5M8z5B39cz8LW5WuiglJHbGhwKoJjWBXz
fL7eNcxxD4UI48hOtGQEl11UYN3JfemCID8xKkuN001I6vnk0py9Rxl4xBZ6+30R
0r4qOTwzq12EJ/hmCjck8sxYvDiEws2zsN7NloBiBrTQJUtyJWVlp6BdA7Wk+CDF
M0O0jhUIpER/T0uIlQ1ubM29L8vUvQ==
=9kyu
-----END PGP SIGNATURE-----

--gxFURhHboClmdQqNh66DFNgv0T72J1UIn--
