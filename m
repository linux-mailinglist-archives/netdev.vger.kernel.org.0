Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF069235632
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 12:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgHBKJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 06:09:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53872 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbgHBKJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 06:09:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 072A1AW0003222;
        Sun, 2 Aug 2020 03:09:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=W37gGC6U8eqDomCio5KEBu1Eudbm8qLqCdCzNIyzbVQ=;
 b=QZ+1gL1lkNo8ywScb89QQd0+L4yq9wWJIxynhkgZduSd3L5rcYvdAjxGtEUc70pRYwFl
 wD2M6uIdtedXiKa+7gc5uRUxa8euwFE5w2AtLUlDccXne7+J8M9gyynko2SEWaJnOPAz
 7k2C6gEzUqUl0LI5TiCcds0XRu0S/+Ab6kLoUW51X38q92IOiQmAIvRKUyao2dYAzceN
 gE9MwFZ//nXm6KqH9Jl3GkH25x581cZYLnh34dipky7V0mxXArZ0BO+O9lBpo7rYRIxg
 dTBQG6xxQ/s+x/mCStGXdywUHmIMnhPbQ9BtGnWPgvDXYrQ1CR6BG7IiuZGMUgu8JUbL kg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fejkvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 02 Aug 2020 03:09:00 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 2 Aug
 2020 03:08:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 2 Aug 2020 03:08:59 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 4046B3F7040;
        Sun,  2 Aug 2020 03:08:56 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v5 net-next 03/10] qed: fix kconfig help entries
Date:   Sun, 2 Aug 2020 13:08:27 +0300
Message-ID: <20200802100834.383-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200802100834.383-1-irusskikh@marvell.com>
References: <20200802100834.383-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_06:2020-07-31,2020-08-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces stubs in kconfig help entries with an actual description.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index 8f743d80760b..4366c7a8de95 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -80,7 +80,7 @@ config QED
 	select CRC8
 	select NET_DEVLINK
 	help
-	  This enables the support for ...
+	  This enables the support for Marvell FastLinQ adapters family.
 
 config QED_LL2
 	bool
@@ -100,7 +100,8 @@ config QEDE
 	depends on QED
 	imply PTP_1588_CLOCK
 	help
-	  This enables the support for ...
+	  This enables the support for Marvell FastLinQ adapters family,
+	  ethernet driver.
 
 config QED_RDMA
 	bool
-- 
2.17.1

