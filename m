Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E752498774
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244831AbiAXSAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbiAXSAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:00:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9897CC061748
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:00:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nC3dH-0005AQ-TR
        for netdev@vger.kernel.org; Mon, 24 Jan 2022 18:59:59 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9910C210A4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 485A521085;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7a0f92b9;
        Mon, 24 Jan 2022 17:59:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Brian Silverman <bsilver16384@gmail.com>
Subject: [PATCH net 1/5] mailmap: update email address of Brian Silverman
Date:   Mon, 24 Jan 2022 18:59:51 +0100
Message-Id: <20220124175955.3464134-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124175955.3464134-1-mkl@pengutronix.de>
References: <20220124175955.3464134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Silverman's address at bluerivertech.com is not valid anymore,
use Brian's private email address instead.

Link: https://lore.kernel.org/all/20220110082359.2019735-1-mkl@pengutronix.de
Cc: Brian Silverman <bsilver16384@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index b157f88ce26a..b76e520809d0 100644
--- a/.mailmap
+++ b/.mailmap
@@ -70,6 +70,7 @@ Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
 Brian Avery <b.avery@hp.com>
 Brian King <brking@us.ibm.com>
+Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
 Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>

base-commit: c0bf3d8a943b6f2e912b7c1de03e2ef28e76f760
-- 
2.34.1


