Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A43621DEB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiKHUpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiKHUoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:44:23 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6CE1F2D2;
        Tue,  8 Nov 2022 12:43:57 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8H0aan008598;
        Tue, 8 Nov 2022 12:43:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=BIWGptJV6hpQpDjuFqfbYZMqkWijG7x7ilqLthRxdaM=;
 b=DTJUwfUdWKvXnzX6eEluz1+K89Exr3EXF2g9SFrIsVETq08NhEVUbDVrlxyQHSDm1Qqh
 ApUHpqZTvwNX0gAW+r4L8AqZareZzMa/5lB1gFDThBF6qYpR0IY2/pG1R0dI6jn+ALm4
 Vu69PjJE4t4QMBdrI5e70rBWIMv6/XvHYle+VDE6/GFc3zTx5ysJgP2mF+JMQubGS5fu
 WKOBzZepNsOqPvq1D51vZHRPUbykAc3inR7kEAT7KKikXIDPPADRpan/Xv5EPfeOKjq0
 y3B2YeQ1JJgHg3+dGI6igAVxNT6575ba86BF78EKWSCDaVam4X2OYBPM6WW6/xTCIOv3 7g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kqu4vh09m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:43:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Nov
 2022 12:43:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 8 Nov 2022 12:43:45 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 30B6B3F7089;
        Tue,  8 Nov 2022 12:43:45 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 8/8] octeon_ep_vf: update MAINTAINERS
Date:   Tue, 8 Nov 2022 12:41:59 -0800
Message-ID: <20221108204209.23071-9-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221108204209.23071-1-vburru@marvell.com>
References: <20221108204209.23071-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ulaC-OHdZRrqKDts9suiXF-3D5J9OPok
X-Proofpoint-GUID: ulaC-OHdZRrqKDts9suiXF-3D5J9OPok
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add MAINTAINERS for octeon_ep_vf driver.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95fc5e1b4548..25c7bc579620 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12397,6 +12397,15 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/marvell/octeon_ep
 
+MARVELL OCTEON ENDPOINT VF DRIVER
+M:	Veerasenareddy Burru <vburru@marvell.com>
+M:	Abhijit Ayarekar <aayarekar@marvell.com>
+M:	Sathesh Edara <sedara@marvell.com>
+M:	Satananda Burla <sburla@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/marvell/octeon_ep_vf
+
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
-- 
2.36.0

