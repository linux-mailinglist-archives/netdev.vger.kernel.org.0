Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFE54BB498
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbiBRIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:50:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbiBRIut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:50:49 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4472B3575
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645174233; x=1676710233;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=bmvwOxQyORwipUrflOPCroTqQxeyivrF6UhT3KYG/Y8=;
  b=ihItt5rnfNcG1hcdcL1a3zzCJC0IFQiSNMjZ5g/ofrpyDLCyUnbgu/EO
   fVHYb4HBeFSNsj3TbO31CZa5V4wrTMJ2lYWmgs4PI64o49Nej8Qi70d3Y
   kAd+YySb+0kYmGzyvPeXkrEz5g/Lc7mWLrOU/JhR/Goa5WXghuDx4OOyi
   A=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 18 Feb 2022 00:50:33 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2022 00:50:33 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Feb 2022 00:50:32 -0800
Received: from subashab-lnx.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 18 Feb 2022 00:50:32 -0800
From:   Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        "Sean Tranchetti" <quic_stranche@quicinc.com>
Subject: [PATCH net] MAINTAINERS: rmnet: Update email addresses
Date:   Fri, 18 Feb 2022 01:50:18 -0700
Message-ID: <1645174218-32632-1-git-send-email-quic_subashab@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to the quicinc.com ids.

Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6db79f3..b57077b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16077,8 +16077,8 @@ F:	Documentation/devicetree/bindings/mtd/qcom,nandc.yaml
 F:	drivers/mtd/nand/raw/qcom_nandc.c
 
 QUALCOMM RMNET DRIVER
-M:	Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
-M:	Sean Tranchetti <stranche@codeaurora.org>
+M:	Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
+M:	Sean Tranchetti <quic_stranche@quicinc.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

