Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0C4F107444
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 15:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKVOwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 09:52:55 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57315 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVOwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 09:52:55 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iYAIn-0006w3-LJ; Fri, 22 Nov 2019 15:52:53 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-11-22
Date:   Fri, 22 Nov 2019 15:52:49 +0100
Message-Id: <20191122145251.9775-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 2 patches for net/master, if possible for the
current release cycle. Otherwise these patches should hit v5.4 via the
stable tree.

Both patches of this pull request target the m_can driver. Pankaj Sharma
fixes the fallout in the m_can_platform part, which appeared with the
introduction of the m_can platform framework.

regards,
Marc

---

The following changes since commit d814b67e50dc53c3c83932d7020d1719af1e68dc:

  Merge branch 'hv_netvsc-Fix-send-indirection-table-offset' (2019-11-21 19:32:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.4-20191122

for you to fetch changes up to 0704c57436947c9f9f6472fd1a5ade41fc4c19d8:

  can: m_can_platform: remove unnecessary m_can_class_resume() call (2019-11-22 15:34:37 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.4-20191122

----------------------------------------------------------------
Pankaj Sharma (2):
      can: m_can_platform: set net_device structure as driver data
      can: m_can_platform: remove unnecessary m_can_class_resume() call

 drivers/net/can/m_can/m_can_platform.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


