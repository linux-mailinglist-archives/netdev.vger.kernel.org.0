Return-Path: <netdev+bounces-12121-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8CB57363F0
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 446B0281035
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 07:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E29046A5;
	Tue, 20 Jun 2023 07:02:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D041FDD
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:02:46 +0000 (UTC)
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1126810F4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 00:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687244562; x=1718780562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E9KczBmzs1Jeeoqo0xWyHaoD2fZxC2UQWAALYibp6XE=;
  b=tZs42VM2Tn8Fi5AtNmXUZKWJZKboKlA4ONU81h43jOPfoKON1mtnPKnB
   l2G2wR61a6N+ilkSV8PSSjwiuuRO5ev1uiIsOmIEkqpth34NZgtHD4wMc
   IKydwQGiP5gqOaPTpO4ISxbOg/SauHByBrDI4cGye33hvpirJFXkXlFHp
   I=;
X-IronPort-AV: E=Sophos;i="6.00,256,1681171200"; 
   d="scan'208";a="655138340"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 07:02:36 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id B09E640D6A;
	Tue, 20 Jun 2023 07:02:35 +0000 (UTC)
Received: from EX19D021UWC001.ant.amazon.com (10.13.139.226) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 07:02:31 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D021UWC001.ant.amazon.com (10.13.139.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 07:02:31 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server id 15.2.1118.26 via Frontend Transport; Tue, 20 Jun 2023 07:02:28
 +0000
From: <darinzon@amazon.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	<netdev@vger.kernel.org>
CC: David Arinzon <darinzon@amazon.com>, "Woodhouse, David" <dwmw@amazon.com>,
	"Machulsky, Zorik" <zorik@amazon.com>, "Matushevsky, Alexander"
	<matua@amazon.com>, Saeed Bshara <saeedb@amazon.com>, "Wilson, Matt"
	<msw@amazon.com>, "Liguori, Anthony" <aliguori@amazon.com>, "Bshara, Nafea"
	<nafea@amazon.com>, "Saidi, Ali" <alisaidi@amazon.com>, "Herrenschmidt,
 Benjamin" <benh@amazon.com>, "Kiyanovski, Arthur" <akiyano@amazon.com>,
	"Dagan, Noam" <ndagan@amazon.com>, "Agroskin, Shay" <shayagr@amazon.com>,
	"Itzko, Shahar" <itzko@amazon.com>, "Abboud, Osama" <osamaabb@amazon.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v1 net-next] net: ena: Add missing newline after markup
Date: Tue, 20 Jun 2023 07:02:06 +0000
Message-ID: <20230620070206.1320-1-darinzon@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: Bulk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Arinzon <darinzon@amazon.com>

This patch fixes a warning in the ena documentation
file identified by the kernel automatic tools.

Signed-off-by: David Arinzon <darinzon@amazon.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306171804.U7E92zoE-lkp@intel.com/
---
 Documentation/networking/device_drivers/ethernet/amazon/ena.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 491492677632..00851ec7b4ec 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -206,6 +206,7 @@ More information about Adaptive Interrupt Moderation (DIM) can be found in
 Documentation/networking/net_dim.rst
 
 .. _`RX copybreak`:
+
 RX copybreak
 ============
 The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK
-- 
2.40.1


