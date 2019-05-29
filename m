Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7CC2D973
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfE2Juy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:50:54 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:58580 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfE2Jux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559123452; x=1590659452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=o9T4Xy8t/6bsC4ZE+c2ccJU/pZf0N6PW5iCl+sp5XKk=;
  b=t0D0ti0Bdc72J3rAH66Q08cl7WsEAgPkU4xxENmJmRLOz9AaUVlPmJwO
   HGjRJud2DFOcaO3HhaYqBdaf1co+dE2Pkh3ofyD9AXGVfuB/N1KutL6sW
   wmlBgJT1k0MZoPSjzdYBZdx+T0LfhI+e4vqSBzOacXcqOceqSEIkoeAfM
   s=;
X-IronPort-AV: E=Sophos;i="5.60,526,1549929600"; 
   d="scan'208";a="404152449"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 29 May 2019 09:50:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 44BA3C07FB;
        Wed, 29 May 2019 09:50:51 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 May 2019 09:50:29 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 29 May 2019 09:50:26 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 04/11] net: ena: arrange ena_probe() function variables in reverse christmas tree
Date:   Wed, 29 May 2019 12:49:57 +0300
Message-ID: <20190529095004.13341-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190529095004.13341-1-sameehj@amazon.com>
References: <20190529095004.13341-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Reverse christmas tree arrangement is when variables are written from longer
to shorter with each line. Most of our functions are abiding this
arrangement but this function does not.

In this commit we arrange the variables of ena_probe() in reverse christmas
tree.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b80b5eddc..399bd5453 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3281,17 +3281,17 @@ static int ena_calc_queue_size(struct pci_dev *pdev,
 static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
-	static int version_printed;
-	struct net_device *netdev;
-	struct ena_adapter *adapter;
 	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
-	char *queue_type_str;
-	static int adapters_found;
+	struct ena_adapter *adapter;
+	static int version_printed;
 	int io_queue_num, bars, rc;
-	int queue_size;
+	struct net_device *netdev;
+	static int adapters_found;
+	char *queue_type_str;
 	u16 tx_sgl_size = 0;
 	u16 rx_sgl_size = 0;
+	int queue_size;
 	bool wd_state;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
-- 
2.17.1

