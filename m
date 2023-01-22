Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F59D67716E
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 19:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjAVSS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 13:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjAVSS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 13:18:58 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BAE1CAE5;
        Sun, 22 Jan 2023 10:18:56 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 1AB3260007;
        Sun, 22 Jan 2023 18:18:53 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org (open list:ISDN/mISDN SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc:     Diederik de Haas <didi.debian@cknow.org>
Subject: [PATCH] mISDN: Fix full name of the GPL
Date:   Sun, 22 Jan 2023 19:18:36 +0100
Message-Id: <20230122181836.54498-1-didi.debian@cknow.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
---
 drivers/isdn/mISDN/dsp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 386084530c2f..593bdb2a7373 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -3,7 +3,7 @@
  * Based on source code structure by
  *		Karsten Keil (keil@isdn4linux.de)
  *
- *		This file is (c) under GNU PUBLIC LICENSE
+ *		This file is (c) under GNU GENERAL PUBLIC LICENSE
  *
  * Thanks to    Karsten Keil (great drivers)
  *              Cologne Chip (great chips)
-- 
2.39.0

