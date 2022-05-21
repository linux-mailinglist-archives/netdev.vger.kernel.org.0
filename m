Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC48B52FAE4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbiEULMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242268AbiEULMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:01 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB3529811;
        Sat, 21 May 2022 04:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5pT7SmjBZKxLkStBQeBDaiKecDUisYvWJKwj5GVAl+c=;
  b=IpqXPC53WYbZOBkzzbFNGfYd4rm+wP02BwuDi9Z/yr0mGdJXtHodWjyk
   ajryAMDOK5tCtijhhaTZA5v2oiZWQVZWA1xUfovFcGu5SUReD/Wvg+woQ
   tSyYyL7WwyUG6pslK/7La9h+nFOgYesZ0dNTgFR225T5q0iSCh+P9W48y
   4=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727904"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:53 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kernel-janitors@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: sparx5: switchdev: fix typo in comment
Date:   Sat, 21 May 2022 13:10:20 +0200
Message-Id: <20220521111145.81697-10-Julia.Lawall@inria.fr>
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
 drivers/net/ethernet/microchip/sparx5/sparx5_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 189a6a0a2e08..32709d21ab2f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -742,7 +742,7 @@ static int sparx5_port_pcs_low_set(struct sparx5 *sparx5,
 		if (err)
 			return -EINVAL;
 	} else {
-		sgmii = true; /* Phy is connnected to the MAC */
+		sgmii = true; /* Phy is connected to the MAC */
 	}
 
 	/* Choose SGMII or 1000BaseX/2500BaseX PCS mode */

