Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F0D27B02E
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgI1Ooo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:44:44 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42758 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgI1Oon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:44:43 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08SEievR051794;
        Mon, 28 Sep 2020 09:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601304280;
        bh=hTbtMNy8Tou5IPtxmFl85d6SkHKUMcm3ml1cJkzweeY=;
        h=From:To:CC:Subject:Date;
        b=eiDj92NQnlKgBKacbHmqKBdTEdJ1FQfzeNe5r8bHevC6CEosCizwO7gX8Em/6RKyk
         swXvJvAHRLd8DaA7DhccTIiv4JQd2AgNK1KwUh31EekGoet0K4xFtpPBHtpA1Vw2G+
         9GkJeOpTpq1g+zZSYVL42VMr5Dlm1CvHFkVdcvKQ=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08SEiexV025164
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 09:44:40 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 28
 Sep 2020 09:44:39 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 28 Sep 2020 09:44:39 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08SEidSL093173;
        Mon, 28 Sep 2020 09:44:39 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH ethtool v3 1/3] Add missing 400000base modes for dump_link_caps
Date:   Mon, 28 Sep 2020 09:44:01 -0500
Message-ID: <20200928144403.19484-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 63130d0b00040 ("update link mode tables") missed adding in the
400000base link_caps to the array.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 ethtool.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 4f93c0f96985..974b14063de2 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -659,6 +659,16 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
 		  "200000baseDR4/Full" },
 		{ 0, ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
 		  "200000baseCR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_400000baseKR4_Full_BIT,
+		  "400000baseKR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_400000baseSR4_Full_BIT,
+		  "400000baseSR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT,
+		  "400000baseLR4_ER4_FR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT,
+		  "400000baseDR4/Full" },
+		{ 0, ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
+		  "400000baseCR4/Full" },
 	};
 	int indent;
 	int did1, new_line_pend;
-- 
2.28.0.585.ge1cfff676549

