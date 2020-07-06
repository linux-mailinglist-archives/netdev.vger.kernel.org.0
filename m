Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497FF215AE7
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgGFPjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:39:24 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1718 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729545AbgGFPjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:39:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066Fa5JD025539;
        Mon, 6 Jul 2020 08:39:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=1aKHepL4sFq5A51vSjz+J15c1lY+tL9GZ1uD3ZWM/aw=;
 b=h2GjFTZb+NBTZjKp+GTNyaBqYOc8eplLoRZxjfkkQNabFj6tj5HA5ZB6tMOnpRbXq/Y7
 z/VHzqRRsDua1vKqjFPP1iR/BQjABzZ6XMssav6dtCN0aVIUjk8y1QrJtXp3dmro/Z6i
 hawgAbqVsxicyI4bPpqBGYCNhNnFPXhpG6E3Pf2yhAzwLpDOPkwbYuifkwyamWnm93ws
 TGTlWsDdgPnuB+74AMgSLhfierbwg/tK6cMWWRB4TYZYV4pi+7q6iJG2w6kQtkA39iga
 EFtogWyQRsOl8BKwADf/2Sq4FC469eKMGGuwk/YbfJ4lPytrHXH7rm/pKofyhPmtWvLZ 6g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 322q4pqm8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 08:39:21 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 6 Jul
 2020 08:39:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 6 Jul 2020 08:39:20 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id EE55E3F7043;
        Mon,  6 Jul 2020 08:39:16 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 8/9] net: qede: fix kernel-doc for qede_ptp_adjfreq()
Date:   Mon, 6 Jul 2020 18:38:20 +0300
Message-ID: <20200706153821.786-9-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200706153821.786-1-alobakin@marvell.com>
References: <20200706153821.786-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the function arguments was renamed some time ago, but this
wasn't reflected in its kernel-doc comment.
Also add the description for return values.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/qlogic/qede/qede_ptp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 60a29a937a94..8c28fabb0ff6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -28,12 +28,12 @@ struct qede_ptp {
 };
 
 /**
- * qede_ptp_adjfreq
- * @ptp: the ptp clock structure
- * @ppb: parts per billion adjustment from base
+ * qede_ptp_adjfreq() - Adjust the frequency of the PTP cycle counter.
  *
- * Adjust the frequency of the ptp cycle counter by the
- * indicated ppb from the base frequency.
+ * @info: The PTP clock info structure.
+ * @ppb: Parts per billion adjustment from base.
+ *
+ * Return: Zero on success, negative errno otherwise.
  */
 static int qede_ptp_adjfreq(struct ptp_clock_info *info, s32 ppb)
 {
-- 
2.25.1

