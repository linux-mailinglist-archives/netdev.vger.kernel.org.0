Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A726305742
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhA0Jqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:46:34 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38345 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbhA0JlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:41:21 -0500
X-Greylist: delayed 944 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2021 04:41:20 EST
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l4hJR-0002I5-GU
        for netdev@vger.kernel.org; Wed, 27 Jan 2021 10:40:33 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CB9E15CF836
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:40:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E50BE5CF82B;
        Wed, 27 Jan 2021 09:40:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f253ac90;
        Wed, 27 Jan 2021 09:40:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-01-27
Date:   Wed, 27 Jan 2021 10:40:27 +0100
Message-Id: <20210127094028.2778793-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 1 patch for net/master.

The patch is by Dan Carpenter and fixes a potential information leak in
can_fill_info().

Note: Sorry to say this again: This patch touches "drivers/net/can/dev.c". In
net-next/master this file has been moved to drivers/net/can/dev/dev.c [1] and
parts of it have been transfered into separate files. This may result in a
merge conflict. Please carry this patch forward, the change is rather simple.

[1] 3e77f70e7345 can: dev: move driver related infrastructure into separate subdir

regards,
Marc

---

The following changes since commit b491e6a7391e3ecdebdd7a097550195cc878924a:

  net: lapb: Add locking to the lapb module (2021-01-26 17:53:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.11-20210127

for you to fetch changes up to b552766c872f5b0d90323b24e4c9e8fa67486dd5:

  can: dev: prevent potential information leak in can_fill_info() (2021-01-27 10:25:01 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.11-20210127

----------------------------------------------------------------
Dan Carpenter (1):
      can: dev: prevent potential information leak in can_fill_info()

 drivers/net/can/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


