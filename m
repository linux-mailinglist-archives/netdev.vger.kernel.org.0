Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7320428B03B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgJLI1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgJLI1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:27:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B6EC0613CE
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 01:27:38 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kRtBA-0004Ow-Oc; Mon, 12 Oct 2020 10:27:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-10-12
Date:   Mon, 12 Oct 2020 10:27:25 +0200
Message-Id: <20201012082727.2338859-1-mkl@pengutronix.de>
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

Hello Jakub, hello David,

here's a pull request of two patches for net-next/master.

Both patches are by Oliver Hartkopp, the first one addresses Jakub's review
comments of the ISOTP protocol, the other one removes version strings from
various CAN protocols.

regrads,
Marc

---

The following changes since commit bc081a693a56061f68f736c5d596134ee3c87689:

  Merge branch 'Offload-tc-vlan-mangle-to-mscc_ocelot-switch' (2020-10-11 11:19:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.10-20201012

for you to fetch changes up to f726f3d37163f714034aa5fd1f92a1a73df4297f:

  can: remove obsolete version strings (2020-10-12 10:06:39 +0200)

----------------------------------------------------------------
linux-can-next-for-5.10-20201012

----------------------------------------------------------------
Oliver Hartkopp (2):
      can: isotp: implement cleanups / improvements from review
      can: remove obsolete version strings

 include/linux/can/core.h       |  7 -------
 include/net/netns/can.h        |  1 -
 include/uapi/linux/can/isotp.h |  1 -
 net/can/Kconfig                |  3 ++-
 net/can/af_can.c               |  2 +-
 net/can/bcm.c                  |  4 +---
 net/can/gw.c                   |  4 +---
 net/can/isotp.c                | 18 ++++++++----------
 net/can/proc.c                 | 12 ------------
 net/can/raw.c                  |  4 +---
 10 files changed, 14 insertions(+), 42 deletions(-)



