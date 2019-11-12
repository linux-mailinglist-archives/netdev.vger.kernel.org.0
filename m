Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C4FF94DE
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKLP6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:58:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51105 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfKLP6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:58:11 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iUYYO-0003tt-Bg; Tue, 12 Nov 2019 16:58:04 +0100
Received: from [IPv6:2a03:f580:87bc:d400:fcf3:94db:a77f:e6a3] (unknown [IPv6:2a03:f580:87bc:d400:fcf3:94db:a77f:e6a3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8815A47B233;
        Tue, 12 Nov 2019 15:58:00 +0000 (UTC)
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
 mQINBFFVq30BEACtnSvtXHoeHJxG6nRULcvlkW6RuNwHKmrqoksispp43X8+nwqIFYgb8UaX
 zu8T6kZP2wEIpM9RjEL3jdBjZNCsjSS6x1qzpc2+2ivjdiJsqeaagIgvy2JWy7vUa4/PyGfx
 QyUeXOxdj59DvLwAx8I6hOgeHx2X/ntKAMUxwawYfPZpP3gwTNKc27dJWSomOLgp+gbmOmgc
 6U5KwhAxPTEb3CsT5RicsC+uQQFumdl5I6XS+pbeXZndXwnj5t84M+HEj7RN6bUfV2WZO/AB
 Xt5+qFkC/AVUcj/dcHvZwQJlGeZxoi4veCoOT2MYqfR0ax1MmN+LVRvKm29oSyD4Ts/97cbs
 XsZDRxnEG3z/7Winiv0ZanclA7v7CQwrzsbpCv+oj+zokGuKasofzKdpywkjAfSE1zTyF+8K
 nxBAmzwEqeQ3iKqBc3AcCseqSPX53mPqmwvNVS2GqBpnOfY7Mxr1AEmxdEcRYbhG6Xdn+ACq
 Dq0Db3A++3PhMSaOu125uIAIwMXRJIzCXYSqXo8NIeo9tobk0C/9w3fUfMTrBDtSviLHqlp8
 eQEP8+TDSmRP/CwmFHv36jd+XGmBHzW5I7qw0OORRwNFYBeEuiOIgxAfjjbLGHh9SRwEqXAL
 kw+WVTwh0MN1k7I9/CDVlGvc3yIKS0sA+wudYiselXzgLuP5cQARAQABtCZNYXJjIEtsZWlu
 ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPokCVAQTAQoAPgIbAwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBABYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUsSbBQkM366zAAoJECte4hHF
 iupUgkAP/2RdxKPZ3GMqag33jKwKAbn/fRqAFWqUH9TCsRH3h6+/uEPnZdzhkL4a9p/6OeJn
 Z6NXqgsyRAOTZsSFcwlfxLNHVxBWm8pMwrBecdt4lzrjSt/3ws2GqxPsmza1Gs61lEdYvLST
 Ix2vPbB4FAfE0kizKAjRZzlwOyuHOr2ilujDsKTpFtd8lV1nBNNn6HBIBR5ShvJnwyUdzuby
 tOsSt7qJEvF1x3y49bHCy3uy+MmYuoEyG6zo9udUzhVsKe3hHYC2kfB16ZOBjFC3lH2U5An+
 yQYIIPZrSWXUeKjeMaKGvbg6W9Oi4XEtrwpzUGhbewxCZZCIrzAH2hz0dUhacxB201Y/faY6
 BdTS75SPs+zjTYo8yE9Y9eG7x/lB60nQjJiZVNvZ88QDfVuLl/heuIq+fyNajBbqbtBT5CWf
 mOP4Dh4xjm3Vwlz8imWW/drEVJZJrPYqv0HdPbY8jVMpqoe5jDloyVn3prfLdXSbKPexlJaW
 5tnPd4lj8rqOFShRnLFCibpeHWIumqrIqIkiRA9kFW3XMgtU6JkIrQzhJb6Tc6mZg2wuYW0d
 Wo2qvdziMgPkMFiWJpsxM9xPk9BBVwR+uojNq5LzdCsXQ2seG0dhaOTaaIDWVS8U/V8Nqjrl
 6bGG2quo5YzJuXKjtKjZ4R6k762pHJ3tnzI/jnlc1sXzuQENBFxSzJYBCAC58uHRFEjVVE3J
 31eyEQT6H1zSFCccTMPO/ewwAnotQWo98Bc67ecmprcnjRjSUKTbyY/eFxS21JnC4ZB0pJKx
 MNwK6zq71wLmpseXOgjufuG3kvCgwHLGf/nkBHXmSINHvW00eFK/kJBakwHEbddq8Dr4ewmr
 G7yr8d6A3CSn/qhOYWhIxNORK3SVo4Io7ExNX/ljbisGsgRzsWvY1JlN4sabSNEr7a8YaqTd
 2CfFe/5fPcQRGsfhAbH2pVGigr7JddONJPXGE7XzOrx5KTwEv19H6xNe+D/W3FwjZdO4TKIo
 vcZveSDrFWOi4o2Te4O5OB/2zZbNWPEON8MaXi9zABEBAAGJA3IEGAEKACYWIQTBQAugs5ie
 b7x9W1wrXuIRxYrqVAUCXFLMlgIbAgUJAeKNmgFACRArXuIRxYrqVMB0IAQZAQoAHRYhBJrx
 JF84Dn3PPNRrhVrGIaOR5J0gBQJcUsyWAAoJEFrGIaOR5J0grw4H/itil/yryJCvzi6iuZHS
 suSHHOiEf+UQHib1MLP96LM7FmDabjVSmJDpH4TsMu17A0HTG+bPMAdeia0+q9FWSvSHYW8D
 wNhfkb8zojpa37qBpVpiNy7r6BKGSRSoFOv6m/iIoRJuJ041AEKao6djj/FdQF8OV1EtWKRO
 +nE2bNuDCcwHkhHP+FHExdzhKSmnIsMjGpGwIQKN6DxlJ7fN4W7UZFIQdSO21ei+akinBo4K
 O0uNCnVmePU1UzrwXKG2sS2f97A+sZE89vkc59NtfPHhofI3JkmYexIF6uqLA3PumTqLQ2Lu
 bywPAC3YNphlhmBrG589p+sdtwDQlpoH9O7NeBAAg/lyGOUUIONrheii/l/zR0xxr2TDE6tq
 6HZWdtjWoqcaky6MSyJQIeJ20AjzdV/PxMkd8zOijRVTnlK44bcfidqFM6yuT1bvXAO6NOPy
 pvBRnfP66L/xECnZe7s07rXpNFy72XGNZwhj89xfpK4a9E8HQcOD0mNtCJaz7TTugqBOsQx2
 45VPHosmhdtBQ6/gjlf2WY9FXb5RyceeSuK4lVrz9uZB+fUHBge/giOSsrqFo/9fWAZsE67k
 6Mkdbpc7ZQwxelcpP/giB9N+XAfBsffQ8q6kIyuFV4ILsIECCIA4nt1rYmzphv6t5J6PmlTq
 TzW9jNzbYANoOFAGnjzNRyc9i8UiLvjhTzaKPBOkQfhStEJaZrdSWuR/7Tt2wZBBoNTsgNAw
 A+cEu+SWCvdX7vNpsCHMiHtcEmVt5R0Tex1Ky87EfXdnGR2mDi6Iyxi3MQcHez3C61Ga3Baf
 P8UtXR6zrrrlX22xXtpNJf4I4Z6RaLpB/avIXTFXPbJ8CUUbVD2R2mZ/jyzaTzgiABDZspbS
 gw17QQUrKqUog0nHXuaGGA1uvreHTnyBWx5P8FP7rhtvYKhw6XdJ06ns+2SFcQv0Bv6PcSDK
 aRXmnW+OsDthn84x1YkfGIRJEPvvmiOKQsFEiB4OUtTX2pheYmZcZc81KFfJMmE8Z9+LT6Ry
 uSS5AQ0EXFLNDgEIAL14qAzTMCE1PwRrYJRI/RSQGAGF3HLdYvjbQd9Ozzg02K3mNCF2Phb1
 cjsbMk/V6WMxYoZCEtCh4X2GjQG2GDDW4KC9HOa8cTmr9Vcno+f+pUle09TMzWDgtnH92WKx
 d0FIQev1zDbxU7lk1dIqyOjjpyhmR8Put6vgunvuIjGJ/GapHL/O0yjVlpumtmow6eME2muc
 TeJjpapPWBGcy/8VU4LM8xMeMWv8DtQML5ogyJxZ0Smt+AntIzcF9miV2SeYXA3OFiojQstF
 vScN7owL1XiQ3UjJotCp6pUcSVgVv0SgJXbDo5Nv87M2itn68VPfTu2uBBxRYqXQovsR++kA
 EQEAAYkCPAQYAQoAJhYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUs0OAhsMBQkB4o0iAAoJ
 ECte4hHFiupUbioQAJ40bEJmMOF28vFcGvQrpI+lfHJGk9zSrh4F4SlJyOVWV1yWyUAINr8w
 v1aamg2nAppZ16z4nAnGU/47tWZ4P8blLVG8x4SWzz3D7MCy1FsQBTrWGLqWldPhkBAGp2VH
 xDOK4rLhuQWx3H5zd3kPXaIgvHI3EliWaQN+u2xmTQSJN75I/V47QsaPvkm4TVe3JlB7l1Fg
 OmSvYx31YC+3slh89ayjPWt8hFaTLnB9NaW9bLhs3E2ESF9Dei0FRXIt3qnFV/hnETsx3X4h
 KEnXxhSRDVeURP7V6P/z3+WIfddVKZk5ZLHi39fJpxvsg9YLSfStMJ/cJfiPXk1vKdoa+FjN
 7nGAZyF6NHTNhsI7aHnvZMDavmAD3lK6CY+UBGtGQA3QhrUc2cedp1V53lXwor/D/D3Wo9wY
 iSXKOl4fFCh2Peo7qYmFUaDdyiCxvFm+YcIeMZ8wO5udzkjDtP4lWKAn4tUcdcwMOT5d0I3q
 WATP4wFI8QktNBqF3VY47HFwF9PtNuOZIqeAquKezywUc5KqKdqEWCPx9pfLxBAh3GW2Zfjp
 lP6A5upKs2ktDZOC2HZXP4IJ1GTk8hnfS4ade8s9FNcwu9m3JlxcGKLPq5DnIbPVQI1UUR4F
 QyAqTtIdSpeFYbvH8D7pO4lxLSz2ZyBMk+aKKs6GL5MqEci8OcFW
Subject: pull-request: can-next 2019-10-07
Message-ID: <0d53fe03-50a4-8a96-5605-7f20bd3c17fa@pengutronix.de>
Date:   Tue, 12 Nov 2019 16:57:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Tur0mlMzoEotqOZnqK6s9RQIuuTKrLGcB"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tur0mlMzoEotqOZnqK6s9RQIuuTKrLGcB
Content-Type: multipart/mixed; boundary="zytl7yYg4fXNCkwHucDVISV29qWdpMEbc";
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
Message-ID: <0d53fe03-50a4-8a96-5605-7f20bd3c17fa@pengutronix.de>
Subject: pull-request: can-next 2019-10-07

--zytl7yYg4fXNCkwHucDVISV29qWdpMEbc
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hello David,

this is a pull request for net-next/master consisting of 32 patches.

The first patch is by Gustavo A. R. Silva and removes unused code in the
generic CAN infrastructure.

The next three patches target the mcp251x driver. The one by Andy
Shevchenko removes the legacy platform data support from the driver. The
other two are by Timo Schl=C3=BC=C3=9Fler and reset the device only when =
needed,
to prevent glitches on the output when GPIO support is added.

I'm contributing two patches fixing checkpatch warnings in the
c_can_platform and peak_canfd driver.

Stephane Grosjean's patch for the peak_canfd driver adds hw timestamps
support in rx skbs.

The next three patches target the xilinx_can driver. One patch by me to
fix checkpatch warnings, one patch by Anssi Hannula to avoid non
requested bus error frames, and a patch by YueHaibing that switches the
driver to devm_platform_ioremap_resource().

Pankaj Sharma contributes two patches for the m_can driver, the first
one adds support for one shot mode, the other support for handling
arbitration errors.

Followed by four patches by YueHaibing, switching the grcan, ifi, rcar,
and sun4i drivers to devm_platform_ioremap_resource()

I'm contributing cleanup patches for the rx-offload helper, while Joakim
Zhang's patch prepares the rx-offload helper for CAN-FD support. The rx
offload users flexcan and ti_hecc are converted accordingly.

The remaining twelve patches target the flexcan driver. First Joakim
Zhang switches the driver to devm_platform_ioremap_resource(). The
remaining eleven patch are by me and clean up the abstract the access of
the iflag1 and iflag2 register both for RX and TX mailboxes. This is a
preparation for the upcoming CAN-FD support.

regards,
Marc

---

The following changes since commit 228200179213bfc9b4d6097e1c26de30bd18c1=
e6:

  Support LAN743x PTP periodic output on any GPIO (2019-11-11 12:46:56 -0=
800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git ta=
gs/linux-can-next-for-5.5-20191111

for you to fetch changes up to b9468ad8ff65e6dcfeb69cab15deecafdb883643:

  can: flexcan: flexcan_mailbox_read() make use of flexcan_write64() to m=
ark the mailbox as read (2019-11-11 21:58:12 +0100)

----------------------------------------------------------------
linux-can-next-for-5.5-20191111

----------------------------------------------------------------
Andy Shevchenko (1):
      can: mcp251x: get rid of legacy platform data

Anssi Hannula (1):
      can: xilinx_can: avoid non-requested bus error frames

Gustavo A. R. Silva (1):
      can: dev: can_restart(): remove unused code

Joakim Zhang (2):
      can: rx-offload: Prepare for CAN FD support
      can: flexcan: use devm_platform_ioremap_resource() to simplify code=


Marc Kleine-Budde (17):
      can: c_can: c_can_plaform: fix checkpatch warnings
      can: peak_canfd: fix checkpatch warnings
      can: xilinx_can: fix checkpatch warnings
      can: rx-offload: fix long lines
      can: rx-offload: can_rx_offload_compare(): fix typo
      can: rx-offload: can_rx_offload_irq_offload_timestamp(): don't use =
assignment in if condition
      can: rx-offload: can_rx_offload_reset(): remove no-op function
      can: flexcan: flexcan_irq_state(): only read timestamp if needed
      can: flexcan: rename macro FLEXCAN_IFLAG_MB() -> FLEXCAN_IFLAG2_MB(=
)
      can: flexcan: flexcan_irq(): rename variable reg_iflag -> reg_iflag=
_rx
      can: flexcan: rename struct flexcan_priv::reg_imask{1,2}_default to=
 rx_mask{1,2}
      can: flexcan: remove TX mailbox bit from struct flexcan_priv::rx_ma=
sk{1,2}
      can: flexcan: convert struct flexcan_priv::rx_mask{1,2} to rx_mask
      can: flexcan: introduce struct flexcan_priv::tx_mask and make use o=
f it
      can: flexcan: flexcan_read_reg_iflag_rx(): optimize reading
      can: flexcan: flexcan_irq(): add support for TX mailbox in iflag1
      can: flexcan: flexcan_mailbox_read() make use of flexcan_write64() =
to mark the mailbox as read

Pankaj Sharma (2):
      can: m_can: add support for one shot mode
      can: m_can: add support for handling arbitration error

Stephane Grosjean (1):
      can: peak_canfd: provide hw timestamps in rx skbs

Timo Schl=C3=BC=C3=9Fler (2):
      can: mcp251x: add mcp251x_write_2regs() and make use of it
      can: mcp251x: only reset hardware as required

YueHaibing (5):
      can: xilinx_can: use devm_platform_ioremap_resource() to simplify c=
ode
      can: grcan: use devm_platform_ioremap_resource() to simplify code
      can: ifi: use devm_platform_ioremap_resource() to simplify code
      can: rcar: use devm_platform_ioremap_resource() to simplify code
      can: sun4i: use devm_platform_ioremap_resource() to simplify code

 arch/arm/mach-pxa/icontrol.c                  |   9 +-
 arch/arm/mach-pxa/zeus.c                      |   9 +-
 drivers/net/can/c_can/c_can_platform.c        |  21 +++--
 drivers/net/can/dev.c                         |   5 +-
 drivers/net/can/flexcan.c                     | 131 +++++++++++++++-----=
------
 drivers/net/can/grcan.c                       |   4 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c         |   4 +-
 drivers/net/can/m_can/m_can.c                 |  54 ++++++++++-
 drivers/net/can/peak_canfd/peak_canfd.c       |  25 +++--
 drivers/net/can/peak_canfd/peak_canfd_user.h  |   3 +-
 drivers/net/can/peak_canfd/peak_pciefd_main.c |   6 +-
 drivers/net/can/rcar/rcar_can.c               |   4 +-
 drivers/net/can/rcar/rcar_canfd.c             |   4 +-
 drivers/net/can/rx-offload.c                  | 122 +++++++++-----------=
----
 drivers/net/can/spi/mcp251x.c                 |  75 ++++++++++++---
 drivers/net/can/sun4i_can.c                   |   4 +-
 drivers/net/can/ti_hecc.c                     |  26 +++--
 drivers/net/can/xilinx_can.c                  | 102 ++++++++++----------=

 include/linux/can/platform/mcp251x.h          |  22 -----
 include/linux/can/rx-offload.h                |   7 +-
 20 files changed, 360 insertions(+), 277 deletions(-)
 delete mode 100644 include/linux/can/platform/mcp251x.h

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |-
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


















--zytl7yYg4fXNCkwHucDVISV29qWdpMEbc--

--Tur0mlMzoEotqOZnqK6s9RQIuuTKrLGcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl3K1oEACgkQWsYho5Hk
nSAs9wf+NGgI/0VY+lv3kBV3GQgNm901+GcIWV8y889DJCDNBEoDON0xZPvD0va1
yARBIhEjWfifOUWiRmd6ch6V1eLq1MKkVnKzb+83kunpK4qcXTkb/6x+zEdeEnUI
C4AjJt20Cn944r7ZkXKjo+bPdyC+Q8/MECjF/mZzbrMzl13B2htQO7mnHhFvtakd
2JvaA7XHTRHXx9BnGzN0J+d9MAfkOUhs207CyggEQDXRHBGx0fPquivM4dM8V7Ie
4zMc32h1JwM7xQipdOhCKQVGeH5Ms5haTJvW2FJnH9MtC8mqqgW3+73nc1t2AGNv
Dkr7vOx+akKz6+2FGztcorQam66Jxw==
=xdN5
-----END PGP SIGNATURE-----

--Tur0mlMzoEotqOZnqK6s9RQIuuTKrLGcB--
