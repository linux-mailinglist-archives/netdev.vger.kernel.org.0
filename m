Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E14F52FAE2
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352516AbiEULMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242534AbiEULME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:04 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DE22B18F;
        Sat, 21 May 2022 04:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3UaOzrLyIjLJqZf30WYCfLNr8NfhcXsa64VWPyp4lxo=;
  b=RcoKOe+pAJd+QkDHDzafHtKJWPu0D+ZUg7bRjsqm8jfrzU3gkRmPSmnj
   RPGV6IKBDmvnNCJg63ErJcPmxv4JPXkYL6p9qI9fCXiSW/nuJlq+EboXL
   08PCttZJMaYqm7qg8xmaAML6CeaY9hQNAA+QXOLMk28nmKSMdrIJye7zl
   8=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727914"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:55 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     kernel-janitors@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mvpp2: fix typo in comment
Date:   Sat, 21 May 2022 13:10:29 +0200
Message-Id: <20220521111145.81697-19-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2b7eade373be..b84128b549b4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1869,7 +1869,7 @@ static u32 mvpp2_read_index(struct mvpp2 *priv, u32 index, u32 reg)
  * design, incremented at different moments in the chain of packet processing,
  * it is very likely that incoming packets could have been dropped after being
  * counted by hardware but before reaching software statistics (most probably
- * multicast packets), and in the oppposite way, during transmission, FCS bytes
+ * multicast packets), and in the opposite way, during transmission, FCS bytes
  * are added in between as well as TSO skb will be split and header bytes added.
  * Hence, statistics gathered from userspace with ifconfig (software) and
  * ethtool (hardware) cannot be compared.

