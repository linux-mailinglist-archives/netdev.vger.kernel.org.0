Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51969FC2E2
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKNJpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:45:52 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54351 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNJpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:45:52 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iVBhH-0003nz-9V; Thu, 14 Nov 2019 10:45:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-11-14
Date:   Thu, 14 Nov 2019 10:45:47 +0100
Message-Id: <20191114094548.4867-1-mkl@pengutronix.de>
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

here another pull request for net/master consisting of one patch (including my S-o-b).

Jouni Hogander's patch fixes a memory leak found by the syzbot in the slcan
driver's error path.

Marc

---

The following changes since commit a56dcc6b455830776899ce3686735f1172e12243:

  net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size() (2019-11-13 14:30:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.4-20191114

for you to fetch changes up to ed50e1600b4483c049ce76e6bd3b665a6a9300ed:

  slcan: Fix memory leak in error path (2019-11-14 10:38:30 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.4-20191114

----------------------------------------------------------------
Jouni Hogander (1):
      slcan: Fix memory leak in error path

 drivers/net/can/slcan.c | 1 +
 1 file changed, 1 insertion(+)



