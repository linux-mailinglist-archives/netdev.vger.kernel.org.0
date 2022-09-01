Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2345A89B2
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 02:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiIAABN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 20:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiIAABH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 20:01:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C3E7B1DF
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 17:01:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 158EBB82149
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 00:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EF6C433D6;
        Thu,  1 Sep 2022 00:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661990461;
        bh=XvH9fxK83nQuknIO+cVIRTu4NZlLUbuZ0YSTsbg+GXM=;
        h=From:To:Cc:Subject:Date:From;
        b=WF260r5RnS2WK26laH1V/MLZCykCFAapEuhOv4rH+M/jqT4LMaMxN6zoAYkhowPHt
         gG7MDTgc/5rxjzQ9VaB4Jpz9mRbxGe75UbePvyMiHYaPyLamRZSQR40pHrJWB7TrJV
         MQYEQZbG8rZfNr7xvfUbwGYYG6EK10yCbfSesPGnJc1ttYMv8l1JjkPFehLs+FDt5/
         DMml8sIDp0ttRVPUBtChr4S+Bh6VUVbonq1wgvz4q/MyFxhhHZEZEEoZO+WkgSuU0y
         V/yVXJGMsy1nakPl84zeg5h8Iuagxv4l3y4qbN2Dq07sPbNz33TJPxJ//ExY6B0UHM
         9ioAzr1ziLAGQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: remove netif_tx_napi_add()
Date:   Wed, 31 Aug 2022 17:00:58 -0700
Message-Id: <20220901000058.2585507-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All callers are now gone.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eec35f9b6616..7143e31e365b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2569,8 +2569,6 @@ netif_napi_add_tx_weight(struct net_device *dev,
 	netif_napi_add_weight(dev, napi, poll, weight);
 }
 
-#define netif_tx_napi_add netif_napi_add_tx_weight
-
 /**
  * netif_napi_add_tx() - initialize a NAPI context to be used for Tx only
  * @dev:  network device
-- 
2.37.2

