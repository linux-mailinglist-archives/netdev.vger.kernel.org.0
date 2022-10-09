Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B700E5F90FA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiJIW2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiJIW0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:26:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC522F399;
        Sun,  9 Oct 2022 15:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64E9EB80DDC;
        Sun,  9 Oct 2022 22:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ED2C433D7;
        Sun,  9 Oct 2022 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353833;
        bh=E1F+wTxUctKlO50lFhxjS45ZVUAfVVMgWA23Evn7SwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCzBklt4pIHmte8DOtVJpeoR9zzPSpkXQdIjOVhyRJX4jR9Y2rtVprN8bm68GtVLz
         XUHzbxRJ3Z9KguyVIyJ0UDdQxG8SK2X5+NJEBJ+2+I+dMpxoJ425bjZadt3jc/3sqE
         GdF1BAsLhKxhfgUYvRU3SDEa5i3yPpUkMNB7HJcfeR/UaF4kptFYGeL7KkajKdyTOA
         W70Cun4zNPzteX/kXU/mVtTmz3NH5kpr9EAneyf/fIcIaxgjGnEYRcXRbw0dJ7RKZd
         QdBZVqqt8+ngJ9Q9oaQvC65No/NK6RQA07tjujYiic3d6kpbogEVPGr+njcy+MF7kd
         BW+H1KxLMnC7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Casper Andersson <casper.casan@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, horatiu.vultur@microchip.com,
        nhuck@google.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 33/73] net: sparx5: fix function return type to match actual type
Date:   Sun,  9 Oct 2022 18:14:11 -0400
Message-Id: <20221009221453.1216158-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit 75554fe00f941c3c3d9344e88708093a14d2b4b8 ]

Function returns error integer, not bool.

Does not have any impact on functionality.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220906065815.3856323-1-casper.casan@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c | 4 ++--
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index a5837dbe0c7e..4af285918ea2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -186,8 +186,8 @@ bool sparx5_mact_getnext(struct sparx5 *sparx5,
 	return ret == 0;
 }
 
-bool sparx5_mact_find(struct sparx5 *sparx5,
-		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
+int sparx5_mact_find(struct sparx5 *sparx5,
+		     const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2)
 {
 	int ret;
 	u32 cfg2;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index b197129044b5..d071ac3b7106 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -307,8 +307,8 @@ int sparx5_mact_learn(struct sparx5 *sparx5, int port,
 		      const unsigned char mac[ETH_ALEN], u16 vid);
 bool sparx5_mact_getnext(struct sparx5 *sparx5,
 			 unsigned char mac[ETH_ALEN], u16 *vid, u32 *pcfg2);
-bool sparx5_mact_find(struct sparx5 *sparx5,
-		      const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2);
+int sparx5_mact_find(struct sparx5 *sparx5,
+		     const unsigned char mac[ETH_ALEN], u16 vid, u32 *pcfg2);
 int sparx5_mact_forget(struct sparx5 *sparx5,
 		       const unsigned char mac[ETH_ALEN], u16 vid);
 int sparx5_add_mact_entry(struct sparx5 *sparx5,
-- 
2.35.1

