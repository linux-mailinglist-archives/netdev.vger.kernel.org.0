Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6BB2F5E60
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbhANKKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:10:42 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41138 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbhANKKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:10:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10E9xcu6022344;
        Thu, 14 Jan 2021 02:07:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=m+tFsZKOYcGsOTGuLUNgIFE8wJfrCWRqRgX6jzo46W4=;
 b=cHGFlhaSBDQeFhHpUT62+3tpcK/QnSMoiOES5yWOtp8g55wQtH0XGJGkzwiy+ijGRne9
 5vwSof4Ns61xTpdVTChLRtn4ElE0IEfRUMVQSqocPtSckG2JCgsYTIRb24/FI6/tV8k2
 irqRodlMwf+gbljZY2IIiPzQ+2nqZAaZzUfmiQf4Fl7sUuD7p5MW27ivEvx0eo7KRzDx
 vBc1+22RTuqSAwpHNxDQrHR/0EnLfUGaNsbbhMKE+UqjJROysS8YMPe4qDsCV+35TdhC
 QRkxc9IpREoOdQx8mpAo7MxdhJ1zOxOXdBOUxIeLq3wK1o7dTdhHnxXKlzWBe/OPgqB/ wA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsxucf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 Jan 2021 02:07:49 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jan
 2021 02:07:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 Jan
 2021 02:07:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 Jan 2021 02:07:48 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 0490A3F7040;
        Thu, 14 Jan 2021 02:07:44 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH net-next] net: mvpp2: extend mib-fragments name to mib-fragments-err
Date:   Thu, 14 Jan 2021 12:07:38 +0200
Message-ID: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-14_03:2021-01-13,2021-01-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch doesn't change any functionality, but just extend
MIB counter register and ethtool-statistic names with "err".

The counter MVPP2_MIB_FRAGMENTS_RCVD in fact is Error counter.
Extend REG name and appropriated ethtool statistic reg-name
with the ERR/err.

Change-Id: Ic32b9779b90ba99789e83e85cfaddb5da9e7fda9
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..6c9b7c9 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -899,7 +899,7 @@ enum mvpp22_ptp_packet_format {
 #define MVPP2_MIB_FC_RCVD			0x58
 #define MVPP2_MIB_RX_FIFO_OVERRUN		0x5c
 #define MVPP2_MIB_UNDERSIZE_RCVD		0x60
-#define MVPP2_MIB_FRAGMENTS_RCVD		0x64
+#define MVPP2_MIB_FRAGMENTS_ERR_RCVD		0x64
 #define MVPP2_MIB_OVERSIZE_RCVD			0x68
 #define MVPP2_MIB_JABBER_RCVD			0x6c
 #define MVPP2_MIB_MAC_RCV_ERROR			0x70
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3982956..85fcdd6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1566,7 +1566,7 @@ static u32 mvpp2_read_index(struct mvpp2 *priv, u32 index, u32 reg)
 	{ MVPP2_MIB_FC_RCVD, "fc_received" },
 	{ MVPP2_MIB_RX_FIFO_OVERRUN, "rx_fifo_overrun" },
 	{ MVPP2_MIB_UNDERSIZE_RCVD, "undersize_received" },
-	{ MVPP2_MIB_FRAGMENTS_RCVD, "fragments_received" },
+	{ MVPP2_MIB_FRAGMENTS_ERR_RCVD, "fragments_err_received" },
 	{ MVPP2_MIB_OVERSIZE_RCVD, "oversize_received" },
 	{ MVPP2_MIB_JABBER_RCVD, "jabber_received" },
 	{ MVPP2_MIB_MAC_RCV_ERROR, "mac_receive_error" },
-- 
1.9.1

