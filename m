Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF1432F1D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhJSHRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbhJSHRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:17:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85857C061745
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 00:15:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcjLO-0006DQ-0Q
        for netdev@vger.kernel.org; Tue, 19 Oct 2021 09:15:30 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0809569776C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 07:15:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2FC82697763;
        Tue, 19 Oct 2021 07:15:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7d701007;
        Tue, 19 Oct 2021 07:15:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-10-19
Date:   Tue, 19 Oct 2021 09:15:17 +0200
Message-Id: <20211019071518.2346320-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
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

this is a pull request of a single patch for net/master.

The patch is by me and fixes the error handling in case of a FC
timeout in the TX path of the ISOTOP CAN protocol.

regards,
Marc

---

The following changes since commit 8a64ef042eab8a6cec04a6c79d44d1af79b628ca:

  nfp: bpf: silence bitwise vs. logical OR warning (2021-10-18 14:50:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.15-20211019

for you to fetch changes up to d674a8f123b4096d85955c7eaabec688f29724c9:

  can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path (2021-10-19 09:10:30 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.15-20211019

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path

 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)


