Return-Path: <netdev+bounces-3520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B141707AF0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C1EC1C21066
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06182A9E0;
	Thu, 18 May 2023 07:33:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923661843
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:33:11 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5A126A1
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:32:49 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1pzY7y-0000zy-15
	for netdev@vger.kernel.org; Thu, 18 May 2023 09:32:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
	by bjornoya.blackshift.org (Postfix) with SMTP id D0C121C7A14
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:32:44 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bjornoya.blackshift.org (Postfix) with ESMTPS id 859FC1C79F8;
	Thu, 18 May 2023 07:32:43 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
	by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bdffd252;
	Thu, 18 May 2023 07:32:42 +0000 (UTC)
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	linux-can@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net 0/7] pull-request: can 2023-05-18
Date: Thu, 18 May 2023 09:32:34 +0200
Message-Id: <20230518073241.1110453-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello netdev-team,

this is a pull request of 7 patches for net/master.

The first 6 patches are by Jimmy Assarsson and fix several bugs in the
kvaser_pciefd driver.

The latest patch is from me and reverts a change in stm32f746.dtsi
that causes build errors due to a missing dependent patch.

regards,
Marc

---

The following changes since commit 6ad85ed0ebf7ece0f376950a6b3b3c6048093d35:

  Merge tag 'ipsec-2023-05-16' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec (2023-05-16 20:52:35 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.4-20230518

for you to fetch changes up to 36a6418bb125944838b91a33eddca4064a5eb610:

  Revert "ARM: dts: stm32: add CAN support on stm32f746" (2023-05-17 20:20:12 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.4-20230518

----------------------------------------------------------------
Jimmy Assarsson (6):
      can: kvaser_pciefd: Set CAN_STATE_STOPPED in kvaser_pciefd_stop()
      can: kvaser_pciefd: Clear listen-only bit if not explicitly requested
      can: kvaser_pciefd: Call request_irq() before enabling interrupts
      can: kvaser_pciefd: Empty SRB buffer in probe
      can: kvaser_pciefd: Do not send EFLUSH command on TFD interrupt
      can: kvaser_pciefd: Disable interrupts in probe error path

Marc Kleine-Budde (2):
      Merge patch series "can: kvaser_pciefd: Bug fixes"
      Revert "ARM: dts: stm32: add CAN support on stm32f746"

 arch/arm/boot/dts/stm32f746.dtsi | 47 ------------------------------------
 drivers/net/can/kvaser_pciefd.c  | 51 +++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 69 deletions(-)



