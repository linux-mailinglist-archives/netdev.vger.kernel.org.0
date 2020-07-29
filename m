Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF93231D79
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgG2LjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:39:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14782 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbgG2LjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:39:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TBZoRc006457;
        Wed, 29 Jul 2020 04:39:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=W37gGC6U8eqDomCio5KEBu1Eudbm8qLqCdCzNIyzbVQ=;
 b=cww4njsg6keNaQbEwO+YehJGMlccjlLJsX0K6iP89ZiIyM4eAdkgVYYBX2wyEkjq7w5q
 r/l63XByjOpmE8wSlzZYAqMHWTKRdjncTJ88WoN/pHtLV4IumrUBzziCp4MIksKSj478
 CajVN0BaAwVqGPJxDKwOTFLjTbdaEPiJKSXh9hzrti785+W6zkbxhkUnX8ZwYE5nB7Qi
 cfSU5IOBWYZcPxG33fcKWte3vPGIjkF5O8pwGfVqWZXtST87o7XXS1u7MuYYqwzBd8Jh
 KLFR+q8FUIkcQm3aXU6yiGBNz2/AWWeYxom2rKe+q14Btk+1XTVBNL3VDJj9d7RfIP2l RQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3r0r6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 04:39:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 04:39:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 04:39:05 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id 7E40D3F703F;
        Wed, 29 Jul 2020 04:39:02 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v3 net-next 04/11] qed: fix kconfig help entries
Date:   Wed, 29 Jul 2020 14:38:39 +0300
Message-ID: <20200729113846.1551-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729113846.1551-1-irusskikh@marvell.com>
References: <20200729113846.1551-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_04:2020-07-29,2020-07-29 signatures=0
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

