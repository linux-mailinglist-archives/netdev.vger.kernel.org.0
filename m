Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8615850BB11
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244488AbiDVPFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449103AbiDVPFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:05:20 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFF105D1B3
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:01:44 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 059BE320133;
        Fri, 22 Apr 2022 16:01:44 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhun1-0007Cx-Pd; Fri, 22 Apr 2022 16:01:43 +0100
Subject: [PATCH net-next 22/28] siena: Make the (un)load message more
 specific
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:01:43 +0100
Message-ID: <165063970365.27138.5233605804039001113.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

We want to differentiate it from the sfc.ko messages.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index c0e7a919b608..18ba1d6ff16a 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1265,7 +1265,7 @@ static int __init efx_init_module(void)
 {
 	int rc;
 
-	printk(KERN_INFO "Solarflare NET driver\n");
+	pr_info("Solarflare Siena driver\n");
 
 	rc = register_netdevice_notifier(&efx_netdev_notifier);
 	if (rc)
@@ -1291,7 +1291,7 @@ static int __init efx_init_module(void)
 
 static void __exit efx_exit_module(void)
 {
-	printk(KERN_INFO "Solarflare NET driver unloading\n");
+	pr_info("Solarflare Siena driver unloading\n");
 
 	pci_unregister_driver(&efx_pci_driver);
 	efx_siena_destroy_reset_workqueue();
@@ -1304,6 +1304,6 @@ module_exit(efx_exit_module);
 
 MODULE_AUTHOR("Solarflare Communications and "
 	      "Michael Brown <mbrown@fensystems.co.uk>");
-MODULE_DESCRIPTION("Solarflare network driver");
+MODULE_DESCRIPTION("Solarflare Siena network driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, efx_pci_table);

