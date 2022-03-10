Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EF54D49C8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbiCJOcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343948AbiCJOba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF681ADD54
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJms-0005nY-5E
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:06 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 930EA47D5E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0F7DB47D58;
        Thu, 10 Mar 2022 14:29:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ca65630f;
        Thu, 10 Mar 2022 14:29:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/29] pull-request: can-next 2022-03-10
Date:   Thu, 10 Mar 2022 15:28:34 +0100
Message-Id: <20220310142903.341658-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Hello Jakub, hello David,

this is a pull request of 29 patches for net-next/master.

The first 3 patches are by Oliver Hartkopp, target the CAN ISOTP
protocol and update the CAN frame sending behavior, and increases the
max PDU size to 64 kByte.

The next 2 patches are also by Oliver Hartkopp and update the virtual
VXCAN driver so that CAN frames send into the peer name space show up
as RX'ed CAN frames.

Vincent Mailhol contributes a patch for the etas_es58x driver to fix a
false positive dereference uninitialized variable warning.

2 patches by Ulrich Hecht add r8a779a0 SoC support to the rcar_canfd
driver.

The remaining 21 patches target the gs_usb driver and are by Peter
Fink, Ben Evans, Eric Evenchick and me. This series cleans up the
gs-usb driver, documents some bits of the USB ABI used by the widely
used open source firmware candleLight, adds support for up to 3 CAN
interfaces per USB device, adds CAN-FD support, adds quirks for some
hardware and software workarounds and finally adds support for 2 new
devices.

regards,
Marc

---

The following changes since commit 3126b731ceb168b3a780427873c417f2abdd5527:

  net: dsa: tag_rtl8_4: fix typo in modalias name (2022-03-09 20:36:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.18-20220310

for you to fetch changes up to 0691a4b55c89055c1efb61a7696f4bc6aa5cf630:

  can: gs_usb: add VID/PID for ABE CAN Debugger devices (2022-03-10 09:49:16 +0100)

----------------------------------------------------------------
linux-can-next-for-5.18-20220310

----------------------------------------------------------------
Ben Evans (1):
      can: gs_usb: add VID/PID for ABE CAN Debugger devices

Marc Kleine-Budde (14):
      can: gs_usb: use consistent one space indention
      can: gs_usb: fix checkpatch warning
      can: gs_usb: sort include files alphabetically
      can: gs_usb: GS_CAN_FLAG_OVERFLOW: make use of BIT()
      can: gs_usb: rewrap error messages
      can: gs_usb: rewrap usb_control_msg() and usb_fill_bulk_urb()
      can: gs_usb: gs_make_candev(): call SET_NETDEV_DEV() after handling all bt_const->feature
      can: gs_usb: add HW timestamp mode bit
      can: gs_usb: update GS_CAN_FEATURE_IDENTIFY documentation
      can: gs_usb: document the USER_ID feature
      can: gs_usb: document the PAD_PKTS_TO_MAX_PKT_SIZE feature
      can: gs_usb: gs_usb_probe(): introduce udev and make use of it
      can: gs_usb: support up to 3 channels per device
      can: gs_usb: add quirk for CANtact Pro overlapping GS_USB_BREQ value

Oliver Hartkopp (5):
      can: isotp: add local echo tx processing for consecutive frames
      can: isotp: set default value for N_As to 50 micro seconds
      can: isotp: set max PDU size to 64 kByte
      vxcan: remove sk reference in peer skb
      vxcan: enable local echo for sent CAN frames

Peter Fink (6):
      can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame
      can: gs_usb: add CAN-FD support
      can: gs_usb: add usb quirk for NXP LPC546xx controllers
      can: gs_usb: activate quirks for CANtact Pro unconditionally
      can: gs_usb: add extended bt_const feature
      can: gs_usb: add VID/PID for CES CANext FD devices

Ulrich Hecht (2):
      dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
      can: rcar_canfd: Add support for r8a779a0 SoC

Vincent Mailhol (1):
      can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()

 .../bindings/net/can/renesas,rcar-canfd.yaml       |   2 +
 drivers/net/can/rcar/rcar_canfd.c                  | 353 +++++++++-------
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |   3 +-
 drivers/net/can/usb/gs_usb.c                       | 446 +++++++++++++++------
 drivers/net/can/vxcan.c                            |  19 +-
 include/uapi/linux/can/isotp.h                     |  28 +-
 net/can/isotp.c                                    | 235 +++++++----
 7 files changed, 732 insertions(+), 354 deletions(-)


