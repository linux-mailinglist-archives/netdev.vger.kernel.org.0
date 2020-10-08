Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BDD287E1E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgJHVk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgJHVk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:40:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D23EC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:40:28 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQdeE-0001aU-Ur; Thu, 08 Oct 2020 23:40:27 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-10-08
Date:   Thu,  8 Oct 2020 23:40:19 +0200
Message-Id: <20201008214022.2044402-1-mkl@pengutronix.de>
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

Subject: pull-request: can 2020-10-08

Hello Jakub, hello David,

as Jakub pointed out, in case there is a last minute PR to Linux, please take
this pull request into net/master for 5.9.

The first patch is part of my pull request "linux-can-fixes-for-5.9-20201006",
so consider that one obsolete and take this instead.

The first patch is by Lucas Stach and fixes m_can driver by removing an
erroneous call to m_can_class_suspend() in runtime suspend. Which causes the
pinctrl state to get stuck on the "sleep" state, which breaks all CAN
functionality on SoCs where this state is defined.

The last two patches target the j1939 protocol: Cong Wang fixes a syzbot
finding of an uninitialized variable in the j1939 transport protocol. I
contribute a patch, that fixes the initialization of a same uninitialized
variable in a different function.

regards,
Marc

---

The following changes since commit d91dc434f2baa592e9793597421231174d57bbbf:

  Merge tag 'rxrpc-fixes-20201005' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2020-10-06 06:18:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.9-20201008

for you to fetch changes up to 13ba4c434422837d7c8c163f9c8d854e67bf3c99:

  net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt (2020-10-08 23:28:09 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.9-20201008

----------------------------------------------------------------
Cong Wang (1):
      can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbcnt

Lucas Stach (1):
      can: m_can_platform: don't call m_can_class_suspend in runtime suspend

Marc Kleine-Budde (1):
      net: j1939: j1939_session_fresh_new(): fix missing initialization of skbcnt

 drivers/net/can/m_can/m_can_platform.c | 2 --
 net/can/j1939/transport.c              | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)


