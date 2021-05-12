Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2847437B69E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELHME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhELHMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:12:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4035FC06174A
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 00:10:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lgj1C-0005yU-TN
        for netdev@vger.kernel.org; Wed, 12 May 2021 09:10:54 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 27A39622BE6
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:10:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7D76B622BDD;
        Wed, 12 May 2021 07:10:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1ec6b43b;
        Wed, 12 May 2021 07:10:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-05-12
Date:   Wed, 12 May 2021 09:10:49 +0200
Message-Id: <20210512071050.1760001-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

The patch is by Norbert Slusarek and it fixes a race condition in the
CAN ISO-TP socket between isotp_bind() and isotp_setsockopt().

regards,
Marc

---

The following changes since commit 440c3247cba3d9433ac435d371dd7927d68772a7:

  net: ipa: memory region array is variable size (2021-05-11 16:22:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.13-20210512

for you to fetch changes up to 2b17c400aeb44daf041627722581ade527bb3c1d:

  can: isotp: prevent race between isotp_bind() and isotp_setsockopt() (2021-05-12 08:52:47 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.13-20210512

----------------------------------------------------------------
Norbert Slusarek (1):
      can: isotp: prevent race between isotp_bind() and isotp_setsockopt()

 net/can/isotp.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)


