Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B335682F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346021AbhDGJkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:40:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35064 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345760AbhDGJjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:39:44 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lU4eg-0001zG-So; Wed, 07 Apr 2021 09:39:22 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xircom: remove redundant error check on variable err
Date:   Wed,  7 Apr 2021 10:39:22 +0100
Message-Id: <20210407093922.484571-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error check on err is always false as err is always 0 at the
port_found label. The code is redundant and can be removed.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 3e337142b516..2049d76a0e68 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -798,8 +798,6 @@ xirc2ps_config(struct pcmcia_device * link)
 	    goto config_error;
     }
   port_found:
-    if (err)
-	 goto config_error;
 
     /****************
      * Now allocate an interrupt line.	Note that this does not
-- 
2.30.2

