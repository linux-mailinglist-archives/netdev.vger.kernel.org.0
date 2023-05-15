Return-Path: <netdev+bounces-2780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9424703F02
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40952281419
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE731951B;
	Mon, 15 May 2023 20:58:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53887FBED
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:32 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A26011DAF
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:58:09 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pyfGe-0006bI-BS
	for netdev@vger.kernel.org; Mon, 15 May 2023 22:58:04 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id 6A4231C5CCC
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:58:03 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 3F84C1C5CB3;
	Mon, 15 May 2023 20:58:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a195ef3f;
	Mon, 15 May 2023 20:58:01 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next 0/22] pull-request: can-next 2023-05-15
Date: Mon, 15 May 2023 22:57:37 +0200
Message-Id: <20230515205759.1003118-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello netdev-team,

this is a pull request of 22 patches for net-next/master.

The 1st patch is by Ji-Ze Hong and adds support for the Fintek F81604
USB-CAN adapter.

Jiapeng Chong's patch removes unnecessary dev_err() functions from the
bxcan driver.

The next patch is by me an makes a CAN internal header file self
contained.

The remaining 19 patches are by Uwe Kleine-König, they all convert the
platform driver remove callback to return void.

regards,
Marc

---

The following changes since commit 0d9b41daa5907756a31772d8af8ac5ff25cf17c1:

  nfc: llcp: fix possible use of uninitialized variable in nfc_llcp_send_connect() (2023-05-15 13:03:34 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.5-20230515

for you to fetch changes up to 2a3e16360290642202450dad67847824157cccae:

  Merge patch series "can: Convert to platform remove callback returning void" (2023-05-15 22:54:22 +0200)

----------------------------------------------------------------
linux-can-next-for-6.5-20230515

----------------------------------------------------------------
Ji-Ze Hong (1):
      can: usb: f81604: add Fintek F81604 support

Jiapeng Chong (1):
      can: bxcan: Remove unnecessary print function dev_err()

Marc Kleine-Budde (2):
      can: length: make header self contained
      Merge patch series "can: Convert to platform remove callback returning void"

Uwe Kleine-König (19):
      can: at91_can: Convert to platform remove callback returning void
      can: bxcan: Convert to platform remove callback returning void
      can: c_can: Convert to platform remove callback returning void
      can: cc770_isa: Convert to platform remove callback returning void
      can: cc770_platform: Convert to platform remove callback returning void
      can: ctucanfd: Convert to platform remove callback returning void
      can: flexcan: Convert to platform remove callback returning void
      can: grcan: Convert to platform remove callback returning void
      can: ifi_canfd: Convert to platform remove callback returning void
      can: janz-ican3: Convert to platform remove callback returning void
      can: m_can: Convert to platform remove callback returning void
      can: mscan: mpc5xxx_can: Convert to platform remove callback returning void
      can: rcar: Convert to platform remove callback returning void
      can: sja1000_isa: Convert to platform remove callback returning void
      can: sja1000_platform: Convert to platform remove callback returning void
      can: softing: Convert to platform remove callback returning void
      can: sun4i_can: Convert to platform remove callback returning void
      can: ti_hecc: Convert to platform remove callback returning void
      can: xilinx: Convert to platform remove callback returning void

 MAINTAINERS                                  |    6 +
 drivers/net/can/at91_can.c                   |    6 +-
 drivers/net/can/bxcan.c                      |   17 +-
 drivers/net/can/c_can/c_can_platform.c       |    6 +-
 drivers/net/can/cc770/cc770_isa.c            |    6 +-
 drivers/net/can/cc770/cc770_platform.c       |    6 +-
 drivers/net/can/ctucanfd/ctucanfd_platform.c |    6 +-
 drivers/net/can/flexcan/flexcan-core.c       |    6 +-
 drivers/net/can/grcan.c                      |    6 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c        |    6 +-
 drivers/net/can/janz-ican3.c                 |    6 +-
 drivers/net/can/m_can/m_can_platform.c       |    6 +-
 drivers/net/can/mscan/mpc5xxx_can.c          |    6 +-
 drivers/net/can/rcar/rcar_can.c              |    5 +-
 drivers/net/can/rcar/rcar_canfd.c            |    6 +-
 drivers/net/can/sja1000/sja1000_isa.c        |    6 +-
 drivers/net/can/sja1000/sja1000_platform.c   |    6 +-
 drivers/net/can/softing/softing_main.c       |    5 +-
 drivers/net/can/sun4i_can.c                  |    6 +-
 drivers/net/can/ti_hecc.c                    |    6 +-
 drivers/net/can/usb/Kconfig                  |   12 +
 drivers/net/can/usb/Makefile                 |    1 +
 drivers/net/can/usb/f81604.c                 | 1201 ++++++++++++++++++++++++++
 drivers/net/can/xilinx_can.c                 |    6 +-
 include/linux/can/length.h                   |    3 +
 25 files changed, 1266 insertions(+), 86 deletions(-)
 create mode 100644 drivers/net/can/usb/f81604.c



