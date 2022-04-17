Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC7F504834
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 17:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiDQPet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 11:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiDQPcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 11:32:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D201936E0D
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 08:29:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ng6qI-0007Lz-B1
        for netdev@vger.kernel.org; Sun, 17 Apr 2022 17:29:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CC7C264EB0
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 15:29:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5F49A64EAA;
        Sun, 17 Apr 2022 15:29:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 31ba7688;
        Sun, 17 Apr 2022 15:29:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/1] pull-request: can 2022-04-17
Date:   Sun, 17 Apr 2022 17:29:33 +0200
Message-Id: <20220417152934.2696539-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 1 patch for net/master.

The patch is by Oliver Hartkopp and fixes a timeout monitoring problem
in the ISO TP protocol found by the syzbot.

regards,
Marc

---

The following changes since commit 49aefd131739df552f83c566d0665744c30b1d70:

  bonding: do not discard lowest hash bit for non layer3+4 hashing (2022-04-17 13:34:01 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.18-20220417

for you to fetch changes up to d73497081710c876c3c61444445512989e102152:

  can: isotp: stop timeout monitoring when no first frame was sent (2022-04-17 17:21:22 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.18-20220417

----------------------------------------------------------------
Oliver Hartkopp (1):
      can: isotp: stop timeout monitoring when no first frame was sent

 net/can/isotp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


