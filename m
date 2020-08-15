Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C072453D6
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgHOWGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbgHOVuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:50:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847D0C03B3DB
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 02:21:23 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1k6sNN-000762-OZ; Sat, 15 Aug 2020 11:21:21 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-08-15
Date:   Sat, 15 Aug 2020 11:21:12 +0200
Message-Id: <20200815092116.424137-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
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

this is a pull request of 4 patches for net/master.

All patches are by Zhang Changzhong and fix broadcast related problems in the
j1939 CAN networking stack.

regards,
Marc

---

The following changes since commit 4ca0d9ac3fd8f9f90b72a15d8da2aca3ffb58418:

  bonding: show saner speed for broadcast mode (2020-08-14 20:39:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.9-20200815

for you to fetch changes up to 0ae18a82686f9b9965a8ce0dd81371871b306ffe:

  can: j1939: add rxtimer for multipacket broadcast session (2020-08-15 11:12:58 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.9-20200815

----------------------------------------------------------------
Zhang Changzhong (4):
      can: j1939: fix support for multipacket broadcast message
      can: j1939: cancel rxtimer on multipacket broadcast session complete
      can: j1939: abort multipacket broadcast session when timeout occurs
      can: j1939: add rxtimer for multipacket broadcast session

 net/can/j1939/transport.c | 48 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)



