Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4232F582B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbhANCPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728915AbhAMVW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:22:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785A3C06179F
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:22:04 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kznad-0002wU-3p
        for netdev@vger.kernel.org; Wed, 13 Jan 2021 22:22:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 106B75C30E6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:22:01 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EC5BE5C30D7;
        Wed, 13 Jan 2021 21:21:59 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 506d9869;
        Wed, 13 Jan 2021 21:21:59 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-01-13
Date:   Wed, 13 Jan 2021 22:21:56 +0100
Message-Id: <20210113212158.925513-1-mkl@pengutronix.de>
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

this is a pull request of 2 patches for net/master.

The first patch is by Oliver Hartkopp for the CAn ISO-TP protocol and fixes a
kernel information leak to userspace.

The last patch is by Qinglang Miao for the mcp251xfd driver and fixes a NULL
pointer check to work on the correct variable.

regards,
Marc

---

The following changes since commit a95d25dd7b94a5ba18246da09b4218f132fed60e:

  rxrpc: Call state should be read with READ_ONCE() under some circumstances (2021-01-13 10:38:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.11-20210113

for you to fetch changes up to ca4c6ebeeb50112f5178f14bfb6d9e8ddf148545:

  can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check (2021-01-13 22:16:16 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.11-20210113

----------------------------------------------------------------
Oliver Hartkopp (1):
      can: isotp: isotp_getname(): fix kernel information leak

Qinglang Miao (1):
      can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check

 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 net/can/isotp.c                                | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


