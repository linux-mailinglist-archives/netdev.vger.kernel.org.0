Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC6D68D45D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjBGKeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjBGKeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:34:01 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DD68689;
        Tue,  7 Feb 2023 02:33:26 -0800 (PST)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317ACmY9005432;
        Tue, 7 Feb 2023 10:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=U4UaDN2+Hiptbl3iTTBUP0LvxGlwg397EEWroovGeRU=;
 b=pELTgfgi/pSaykTHL3Hy1ySQ2USYi7Qulqyx9sa2RbCRxqPCYKieGpEepmOzNtjE9DgY
 HaOU4Q0sVrw1aPPuDPPqoylAps6ExgjMlxBc7FgGnXLZbmGOMiruDBxjECXwqxfvTrqH
 cREbU+7GQdhjg7mVsUTXdGA0unLzKkDdahCLFGIW99Jd2F/MNXS6myD8p7jNgtzk0INo
 61d1DzVcCwl9c9+PXMFfdQMLL4eSbWzF3bLlGuH8q0PVSQwuvpZmUwkwy85g4AsXQUcc
 V11qDYQsz1DONIV0iJToegUcIeBoloVQf0GzaKelRVF657O77t9W5ezGHqObuXzphv2e kA== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nkfes8t6s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 10:33:09 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 317AX6UX002635
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Feb 2023 10:33:06 GMT
Received: from youghand-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 7 Feb 2023 02:33:03 -0800
From:   Youghandhar Chintala <quic_youghand@quicinc.com>
To:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Youghandhar Chintala <quic_youghand@quicinc.com>
Subject: [PATCH v3 1/2] dt: bindings: net: ath11k: add dt entry for XO calibration support
Date:   Tue, 7 Feb 2023 16:02:06 +0530
Message-ID: <20230207103207.759-3-quic_youghand@quicinc.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230207103207.759-1-quic_youghand@quicinc.com>
References: <20230207103207.759-1-quic_youghand@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: vQNJQbGdhSLpeHCw9jg2Nxmnsaw3QGZ9
X-Proofpoint-ORIG-GUID: vQNJQbGdhSLpeHCw9jg2Nxmnsaw3QGZ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_02,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt binding to get XO calibration data support for Wi-Fi RF clock.

Retrieve the XO trim offset via system firmware (e.g., device tree),
especially in the case where the device doesn't have a useful EEPROM
on which to store the calibrated XO offset.
Calibrated XO offset is sent to firmware, which compensate the RF clock
drift by programing the XO trim register.

Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath11k.yaml         | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index f7cf135aa37f..4745251e70d4 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -41,6 +41,10 @@ properties:
         * reg
         * reg-names
 
+  xo-cal-data:
+    description:
+      XO frequency offset to program the XO trim register
+
   qcom,ath11k-calibration-variant:
     $ref: /schemas/types.yaml#/definitions/string
     description:
-- 
2.38.0

