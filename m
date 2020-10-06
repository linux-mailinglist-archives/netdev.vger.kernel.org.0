Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1836A2853EF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgJFVhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJFVhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:37:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2252C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:37:34 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kPueL-0001We-5J; Tue, 06 Oct 2020 23:37:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-10-06
Date:   Tue,  6 Oct 2020 23:37:23 +0200
Message-Id: <20201006213723.1842481-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

if not too late, I have a pull request of one patch.

The patch is by Lucas Stach and fixes m_can driver by removing an erroneous
call to m_can_class_suspend() in runtime suspend. Which causes the pinctrl
state to get stuck on the "sleep" state, which breaks all CAN functionality on
SoCs where this state is defined.

regards,
Marc

---

The following changes since commit d91dc434f2baa592e9793597421231174d57bbbf:

  Merge tag 'rxrpc-fixes-20201005' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2020-10-06 06:18:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.9-20201006

for you to fetch changes up to 81f1f5ae8b3cbd54fdd994c9e9aacdb7b414a802:

  can: m_can_platform: don't call m_can_class_suspend in runtime suspend (2020-10-06 23:29:30 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.9-20201006

----------------------------------------------------------------
Lucas Stach (1):
      can: m_can_platform: don't call m_can_class_suspend in runtime suspend

 drivers/net/can/m_can/m_can_platform.c | 2 --
 1 file changed, 2 deletions(-)



