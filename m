Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241BE6CA47F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 14:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjC0MsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 08:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjC0MsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 08:48:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA261173F
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 05:48:14 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pgmGj-0000ZH-3h
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 14:48:13 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4BD8219D3AF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 12:48:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CC43419D3A7;
        Mon, 27 Mar 2023 12:48:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7cc61e90;
        Mon, 27 Mar 2023 12:48:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/2] pull-request: can 2023-03-27
Date:   Mon, 27 Mar 2023 14:48:05 +0200
Message-Id: <20230327124807.1157134-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev-team,

this is a pull request of 2 patches for net/master.

Oleksij Rempel and Hillf Danton contribute a patch for the CAN J1939
protocol that prevents a potential deadlock in j1939_sk_errqueue().

Ivan Orlov fixes an uninit-value in the CAN BCM protocol in the
bcm_tx_setup() function.

regards,
Marc

---

The following changes since commit 45977e58ce65ed0459edc9a0466d9dfea09463f5:

  net: dsa: b53: mmap: add phy ops (2023-03-27 08:31:34 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.3-20230327

for you to fetch changes up to 2b4c99f7d9a57ecd644eda9b1fb0a1072414959f:

  can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write (2023-03-27 14:40:45 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.3-20230327

----------------------------------------------------------------
Ivan Orlov (1):
      can: bcm: bcm_tx_setup(): fix KMSAN uninit-value in vfs_write

Oleksij Rempel (1):
      can: j1939: prevent deadlock by moving j1939_sk_errqueue()

 net/can/bcm.c             | 16 ++++++++++------
 net/can/j1939/transport.c |  8 ++++++--
 2 files changed, 16 insertions(+), 8 deletions(-)


