Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9594A650F61
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiLSPyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbiLSPxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:53:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8F13F10
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 07:52:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p7IR4-0001wK-HZ
        for netdev@vger.kernel.org; Mon, 19 Dec 2022 16:52:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E0984143227
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 15:52:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0F14414320A;
        Mon, 19 Dec 2022 15:52:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 246c92f5;
        Mon, 19 Dec 2022 15:52:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/3] Documentation: devlink: add missing toc entry for etas_es58x devlink doc
Date:   Mon, 19 Dec 2022 16:52:08 +0100
Message-Id: <20221219155210.1143439-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221219155210.1143439-1-mkl@pengutronix.de>
References: <20221219155210.1143439-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

toc entry is missing for etas_es58x devlink doc and triggers this warning:

  Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree

Add the missing toc entry.

Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentation for the etas_es58x driver")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20221213051136.721887-1-mailhol.vincent@wanadoo.fr
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/devlink/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 4b653d040627..fee4d3968309 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -50,6 +50,7 @@ parameters, info versions, and other features it supports.
    :maxdepth: 1
 
    bnxt
+   etas_es58x
    hns3
    ionic
    ice

base-commit: 2856a62762c8409e360d4fd452194c8e57ba1058
-- 
2.35.1


