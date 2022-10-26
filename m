Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222CC60DD33
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbiJZIkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiJZIkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:40:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB45C2ED45
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxL-0006Zy-71
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6E6BE10A070
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 168A910A063;
        Wed, 26 Oct 2022 08:40:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 311bc9bd;
        Wed, 26 Oct 2022 08:40:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/29] pull-request: can-next 2022-10-26
Date:   Wed, 26 Oct 2022 10:39:38 +0200
Message-Id: <20221026084007.1583333-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 29 patches for net-next/master.

The first patch is by Daniel S. Trevitz and adds documentation for
switchable termination resistors.

Zhang Changzhong's patch fixes a debug output in the j13939 stack.

Oliver Hartkopp finally removes the pch_can driver, which is
superseded by the generic c_can driver.

Gustavo A. R. Silva replaces a zero-length array with
DECLARE_FLEX_ARRAY() in the ucan driver.

Kees Cook's patch removes a no longer needed silencing of
"-Warray-bounds" warnings for the kvaser_usb driver.

The next 2 patches target the m_can driver. The first is by me cleans
up the LEC error handling, the second is by Vivek Yadav and extends
the LEC error handling to the data phase of CAN-FD frames.

The next 9 patches all target the gs_usb driver. The first 5 patches
are by me and improve the Kconfig prompt and help text, set
netdev->dev_id to distinguish multi CAN channel devices, allow
loopback and listen only at the same time, and clean up the
gs_can_open() function a bit. The remaining 4 patches are by Jeroen
Hofstee and add support for 2 new features: Bus Error Reporting and
Get State.

Jimmy Assarsson and Anssi Hannula contribute 10 patches for the
kvaser_usb driver. They first add Listen Only and Bus Error Reporting
support, handle CMD_ERROR_EVENT errors, improve CAN state handling,
restart events, and configuration of the bit timing parameters.

Another patch by me which fixes the indention in the m_can driver.

A patch by Dongliang Mu cleans up the ucan_disconnect() function in
the ucan driver.

The last patch by Biju Das is for the rcan_canfd driver and cleans up
the reset handling.

regards,
Marc

---

The following changes since commit a526a3cc9c8d426713f8bebc18ebbe39a8495d82:

  net: ethernet: adi: adin1110: Fix SPI transfers (2022-10-19 14:20:37 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git 

for you to fetch changes up to 68399ff574e4faf42b8d85da9339ca3ee2892cc7:

  can: rcar_canfd: Use devm_reset_control_get_optional_exclusive (2022-10-26 10:24:08 +0200)

----------------------------------------------------------------
Anssi Hannula (5):
      can: kvaser_usb_leaf: Set Warning state even without bus errors
      can: kvaser_usb_leaf: Fix improved state not being reported
      can: kvaser_usb_leaf: Fix wrong CAN state after stopping
      can: kvaser_usb_leaf: Ignore stale bus-off after start
      can: kvaser_usb_leaf: Fix bogus restart events

Biju Das (1):
      can: rcar_canfd: Use devm_reset_control_get_optional_exclusive

Daniel S. Trevitz (1):
      can: add termination resistor documentation

Dongliang Mu (1):
      can: ucan: ucan_disconnect(): change unregister_netdev() to unregister_candev()

Gustavo A. R. Silva (1):
      can: ucan: Replace zero-length array with DECLARE_FLEX_ARRAY() helper

Jeroen Hofstee (4):
      can: gs_usb: document GS_CAN_FEATURE_BERR_REPORTING
      can: gs_usb: add ability to enable / disable berr reporting
      can: gs_usb: document GS_CAN_FEATURE_GET_STATE
      can: gs_usb: add support for reading error counters

Jimmy Assarsson (5):
      can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
      can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
      can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
      can: kvaser_usb: Add struct kvaser_usb_busparams
      can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Kees Cook (1):
      can: kvaser_usb: Remove -Warray-bounds exception

Marc Kleine-Budde (9):
      can: m_can: is_lec_err(): clean up LEC error handling
      can: gs_usb: mention candleLight as supported device
      can: gs_usb: gs_make_candev(): set netdev->dev_id
      can: gs_usb: gs_can_open(): allow loopback and listen only at the same time
      can: gs_usb: gs_can_open(): sort checks for ctrlmode
      can: gs_usb: gs_can_open(): merge setting of timestamp flags and init
      Merge patch series "can: gs_usb: new features: GS_CAN_FEATURE_GET_STATE, GS_CAN_FEATURE_BERR_REPORTING"
      Merge patch series "can: kvaser_usb: Fixes and improvements"
      can: m_can: use consistent indention

Oliver Hartkopp (1):
      can: remove obsolete PCH CAN driver

Vivek Yadav (1):
      can: m_can: m_can_handle_bus_errors(): add support for handling DLEC error on CAN-FD frames

Zhang Changzhong (1):
      can: j1939: j1939_session_tx_eoma(): fix debug info

 Documentation/networking/can.rst                  |   33 +
 drivers/net/can/Kconfig                           |    8 -
 drivers/net/can/Makefile                          |    1 -
 drivers/net/can/c_can/Kconfig                     |    3 +-
 drivers/net/can/m_can/m_can.c                     |   26 +-
 drivers/net/can/m_can/m_can.h                     |    2 +-
 drivers/net/can/pch_can.c                         | 1249 ---------------------
 drivers/net/can/rcar/rcar_canfd.c                 |   22 +-
 drivers/net/can/usb/Kconfig                       |    9 +-
 drivers/net/can/usb/gs_usb.c                      |   74 +-
 drivers/net/can/usb/kvaser_usb/Makefile           |    5 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |   30 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |  115 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  160 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |  464 +++++++-
 drivers/net/can/usb/ucan.c                        |    5 +-
 net/can/j1939/transport.c                         |    2 +-
 17 files changed, 815 insertions(+), 1393 deletions(-)
 delete mode 100644 drivers/net/can/pch_can.c


