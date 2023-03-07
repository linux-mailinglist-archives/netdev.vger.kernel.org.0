Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E336AEFD1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbjCGS0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbjCGSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:25:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166719E06E;
        Tue,  7 Mar 2023 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6A4B61547;
        Tue,  7 Mar 2023 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6101C433D2;
        Tue,  7 Mar 2023 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213219;
        bh=3XOqJB30BJgwfczGzN1h2VGhOkqWll+o8F8lUQkfxtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiduEHmuL9TPEds9Mi8QibiWXzCXEUKMMF9zyTW3XO3CfudMIl54AZZU0VhAT+ISb
         TWj5afUVPz02pDsz+D0SAKkfL0RGJiTUFFiuwIPp/HiL00X3VaZwEWO27gLWg3Mk1w
         cnNDPGkNhTjqSgZwYnr1aQDZZnrn0m8vS8zeZgJyidDryghzga9r74FLRywivZjnBy
         UzCJi8B+yo3A2XGnurGSF/CL+sNl7I2qIv0X18ruED+rBCBS1D7T9cofuiNC4nZYsa
         Gnv5pLvyOFr85+42aoiHLAWb8EgISKifXwWQYw0CIrZADMa5fX1s/Bazh7X3cM6Bi0
         4xvfLxeEaiikA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>
Subject: [PATCH 12/28] net: qede: Remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:23 -0600
Message-Id: <20230307181940.868828-13-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

<linux/aer.h> is unused, so remove it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 261f982ca40d..4c6c685820e3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -35,7 +35,6 @@
 #include <net/ip6_checksum.h>
 #include <linux/bitops.h>
 #include <linux/vmalloc.h>
-#include <linux/aer.h>
 #include "qede.h"
 #include "qede_ptp.h"
 
-- 
2.25.1

