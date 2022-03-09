Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022544D3CFE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiCIWdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiCIWdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:33:49 -0500
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8268210CF3D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 14:32:45 -0800 (PST)
Received: (qmail 24349 invoked by uid 89); 9 Mar 2022 22:32:44 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 9 Mar 2022 22:32:44 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        kernel-team@fb.com
Subject: [PATCH net-next v1 04/10] ptp: ocp: Add GND and VCC output selectors
Date:   Wed,  9 Mar 2022 14:32:31 -0800
Message-Id: <20220309223237.34507-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309223237.34507-1-jonathan.lemon@gmail.com>
References: <20220309223237.34507-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These will provide constant outputs.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index c85ba3812b25..d2df28a52926 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -544,6 +544,8 @@ static struct ocp_selector ptp_ocp_sma_out[] = {
 	{ .name = "GNSS2",	.value = 0x08 },
 	{ .name = "IRIG",	.value = 0x10 },
 	{ .name = "DCF",	.value = 0x20 },
+	{ .name = "GND",        .value = 0x2000 },
+	{ .name = "VCC",        .value = 0x4000 },
 	{ }
 };
 
-- 
2.31.1

