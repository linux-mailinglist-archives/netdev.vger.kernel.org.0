Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CD26D5F0A
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbjDDLej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbjDDLeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:34:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1261B2D43
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:34:36 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pjevq-0004n5-G9
        for netdev@vger.kernel.org; Tue, 04 Apr 2023 13:34:34 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A1D4D1A631C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 11:34:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1E4731A6314;
        Tue,  4 Apr 2023 11:34:32 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id da66ab63;
        Tue, 4 Apr 2023 11:34:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/10] pull-request: can-next 2023-04-04
Date:   Tue,  4 Apr 2023 13:34:19 +0200
Message-Id: <20230404113429.1590300-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev-team,

this is a pull request of 10 patches for net-next/master.

The first patch is by Oliver Hartkopp and makes the maximum pdu size
of the CAN ISOTP protocol configurable.

The following 5 patches are by Dario Binacchi and add support for the
bxCAN controller by ST.

Geert Uytterhoeven's patch for the rcar_canfd driver fixes a sparse
warning.

Peng Fan's patch adds an optional power-domains property to the
flexcan device tree binding.

Frank Jungclaus adds support for CAN_CTRLMODE_BERR_REPORTING to the
esd_usb driver.

The last patch is by Oliver Hartkopp and converts the USB IDs of the
kvaser_usb driver to hexadecimal values.

regards,
Marc

---

The following changes since commit 4cee0fb9cc4b5477637fdeb2e965f5fc7d624622:

  Merge tag 'linux-can-next-for-6.4-20230327' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next (2023-03-27 19:55:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.4-20230404

for you to fetch changes up to 14575e3b5f3ece74e9143d7f7f195f3e5ff085f5:

  kvaser_usb: convert USB IDs to hexadecimal values (2023-04-04 08:17:54 +0200)

----------------------------------------------------------------
linux-can-next-for-6.4-20230404

----------------------------------------------------------------
Dario Binacchi (5):
      dt-bindings: arm: stm32: add compatible for syscon gcan node
      dt-bindings: net: can: add STM32 bxcan DT bindings
      ARM: dts: stm32: add CAN support on stm32f429
      ARM: dts: stm32: add pin map for CAN controller on stm32f4
      can: bxcan: add support for ST bxCAN controller

Frank Jungclaus (1):
      can: esd_usb: Add support for CAN_CTRLMODE_BERR_REPORTING

Geert Uytterhoeven (1):
      can: rcar_canfd: ircar_canfd_probe(): fix plain integer in transceivers[] init

Marc Kleine-Budde (1):
      Merge patch series "can: bxcan: add support for ST bxCAN controller"

Oliver Hartkopp (2):
      can: isotp: add module parameter for maximum pdu size
      kvaser_usb: convert USB IDs to hexadecimal values

Peng Fan (1):
      dt-bindings: can: fsl,flexcan: add optional power-domains property

 .../bindings/arm/stm32/st,stm32-syscon.yaml        |    2 +
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |    3 +
 .../bindings/net/can/st,stm32-bxcan.yaml           |   85 ++
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/stm32f4-pinctrl.dtsi             |   30 +
 arch/arm/boot/dts/stm32f429.dtsi                   |   29 +
 drivers/net/can/Kconfig                            |   12 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/bxcan.c                            | 1098 ++++++++++++++++++++
 drivers/net/can/rcar/rcar_canfd.c                  |    2 +-
 drivers/net/can/usb/esd_usb.c                      |   35 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |  102 +-
 net/can/isotp.c                                    |   65 +-
 13 files changed, 1395 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
 create mode 100644 drivers/net/can/bxcan.c


