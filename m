Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9B68D471
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjBGKh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjBGKhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:37:15 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4218F4EFD;
        Tue,  7 Feb 2023 02:36:51 -0800 (PST)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317ARnIE009568;
        Tue, 7 Feb 2023 10:36:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=XYWGTMx8nkY55fjz80XdD7trT0iRpLykxSOelem5Nkw=;
 b=E/ow4Q+RLHhQWJqQxOigljLOgSZ4QffWnUxs4FQiFaK8oGJo68A3CY317g9wc5AL72YI
 +tt8bTyTLaGTdhI7nhNvCGo795wsIy8tPKf6pkVfSBr5JpLQDM+t8uVCuMAZMVsxHQGD
 2C6GCENQUygPoWGuj7oZFGNZKAdES2Krgp2KUO/BLX/qzrUV9VMm/iR4vMAuk8OmcRFp
 nytTD9LpNHJNV3riVHeShVDUB/S635yqFir4hs+v4nVHFSYrJPSA31ipVdSbl77Bukbx
 U3P4kZK8//+gZlAR/elp8LvHXzubd5yOEMkWBsovbazErGL6UIiUzz5iCAW9k6TlZNlW Aw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3nkmwqg0hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 10:36:44 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 317Aaia3012321
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Feb 2023 10:36:44 GMT
Received: from youghand-linux.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 7 Feb 2023 02:36:39 -0800
From:   Youghandhar Chintala <quic_youghand@quicinc.com>
To:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Youghandhar Chintala <quic_youghand@quicinc.com>
Subject: [PATCH v3 0/2] dt: bindings: net: ath11k: add dt entry for XO calibration support
Date:   Tue, 7 Feb 2023 16:06:05 +0530
Message-ID: <20230207103607.12213-1-quic_youghand@quicinc.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: tzH8HSU3lxFs2OnRu3Ma8DxIwWdNdJDq
X-Proofpoint-GUID: tzH8HSU3lxFs2OnRu3Ma8DxIwWdNdJDq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_02,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070095
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Changes from v2:
 - Added proper commit text

Changes from v1:
 - Sending the series to right list

Youghandhar Chintala (2):
  dt: bindings: net: ath11k: add dt entry for XO calibration support
  wifi: ath11k: PMIC XO cal data support

 .../bindings/net/wireless/qcom,ath11k.yaml    |  4 ++++
 drivers/net/wireless/ath/ath11k/ahb.c         |  8 +++++++
 drivers/net/wireless/ath/ath11k/core.h        |  3 +++
 drivers/net/wireless/ath/ath11k/qmi.c         | 24 +++++++++++++++++++
 drivers/net/wireless/ath/ath11k/qmi.h         |  4 +++-
 5 files changed, 42 insertions(+), 1 deletion(-)

-- 
2.38.0

