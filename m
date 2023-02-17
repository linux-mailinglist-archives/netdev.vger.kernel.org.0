Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED76C69ABA7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBQMjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBQMjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:39:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E89C64B23
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:39:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pT01j-00074U-Gz
        for netdev@vger.kernel.org; Fri, 17 Feb 2023 13:39:47 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 038E717C02D
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:39:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D803617C028;
        Fri, 17 Feb 2023 12:39:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bddbf01a;
        Fri, 17 Feb 2023 12:39:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/4] pull-request: can-next 2023-02-17
Date:   Fri, 17 Feb 2023 13:33:08 +0100
Message-Id: <20230217123311.3713766-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
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

Hello netdev-team,

this is a pull request of 4 patches for net-next/master.

---

The following changes since commit 40967f77dfa9fa728b7f36a5d2eb432f39de185c:

  Merge branch 'seg6-add-psp-flavor-support-for-srv6-end-behavior' (2023-02-16 13:30:06 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git 

for you to fetch changes up to 6ad172748db49deef0da9038d29019aedf991a7e:

  Merge patch series "can: esd_usb: Some more preparation for supporting esd CAN-USB/3" (2023-02-16 20:59:53 +0100)

----------------------------------------------------------------
Frank Jungclaus (3):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error
      can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL
      can: esd_usb: Improve readability on decoding ESD_EV_CAN_ERROR_EXT messages

Marc Kleine-Budde (1):
      Merge patch series "can: esd_usb: Some more preparation for supporting esd CAN-USB/3"

Yang Li (1):
      can: ctucanfd: ctucan_platform_probe(): use devm_platform_ioremap_resource()

 drivers/net/can/ctucanfd/ctucanfd_platform.c |  4 +-
 drivers/net/can/usb/esd_usb.c                | 70 ++++++++++++++++------------
 2 files changed, 41 insertions(+), 33 deletions(-)



