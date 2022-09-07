Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34BA5AFC6E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIGGd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGGdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:33:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240D71274A;
        Tue,  6 Sep 2022 23:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662532434; x=1694068434;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sQDxwxVVT82QYJAiXEmw8D3zEDzqA8h3WK0pzn79BCw=;
  b=qV8LqA08RbytlcoW/kc8lM4Q+HkiQZpslFX/QVk74Yins6YzXqQZIVqX
   fenJpXFpVsD/AF+B6p4pmvvC2pKtL2o3NYb2+m+ZH3/WxFnbYGK2ENhX3
   1VjBV0WU02exXY3/dqpvLeM7nhOAb1rFjkBZol7jUyDsBLyzxYTNECe9a
   DKRaC3Qt1Utmm7ZVfCKYojuyY2jeMe2o0HH55rTY9g+E15T5vXD5GuuCS
   xXM8Be57LaYIVRgLVh/Sr584hZFA3NVX7iXJQ9RF3m0Mtn7TIkT3u35FU
   lNv0Y/2nync+JoI+zK7G9c939wSGjShbpdxnTye6OWjXQ1oKCHle+Lai0
   A==;
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="189743848"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2022 23:33:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Sep 2022 23:33:54 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Sep 2022 23:33:51 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 0/2] net: lan743x: Fix to use multiqueue start/stop APIs 
Date:   Wed, 7 Sep 2022 11:51:25 +0530
Message-ID: <20220907062127.15473-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series address the fix to use multiqueue start/stop APIs and Add Rx IP and TCP checksum offload

Changes:
========
V0 -> V1:
 - Remove chip SKU check conditionals
 - Update the changes description

Raju Lakkaraju (2):
  net: lan743x: Fix to use multiqueue start/stop APIs
  net: lan743x: Add support for Rx IP & TCP checksum offload

 drivers/net/ethernet/microchip/lan743x_main.c | 64 +++++++++++--------
 drivers/net/ethernet/microchip/lan743x_main.h | 10 ++-
 2 files changed, 45 insertions(+), 29 deletions(-)

-- 
2.25.1

