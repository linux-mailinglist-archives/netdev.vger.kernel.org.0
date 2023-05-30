Return-Path: <netdev+bounces-6283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C91C8715884
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:29:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81C6A280F3C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE95912B77;
	Tue, 30 May 2023 08:29:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307212B62
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:29:47 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D166A1;
	Tue, 30 May 2023 01:29:44 -0700 (PDT)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U7RvcM022664;
	Tue, 30 May 2023 08:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=J6ZRgZCTa3hC+H6Maw8K9aW1d2MfIdeGlfQUcJff9S4=;
 b=aUO3rNGP72Z0gY7vzPjK8dBazOiQ2eHeerPMJ4VkL7dCPrhfVvBfzYYXpwaDIUDWowJP
 50MLZevup2noAWLhgPzQvAhnWnDo+9HgtNk0fsj2lVSBDHh5F3QmRlRjgDiJAyK2VjwN
 HjRQkBj47LEyQCYSkbUCRV7jjmxtrVOu19hwCumc486RDfenBuEoc/8A/8TTYW2Q+Jsf
 7yC/6hxD3cMwqqq5Vkz+SAFO2yNnzYXoHVWGqBy8NKc7pC6k0c3PSZYpnxTizqx5NO10
 5d9+WY2VDFWhHcuWNU7wAgl0eUJ1i9yKIuFDKGlLbBPsQ0pOZry4ISRYkBJbQ5N1jLKO Iw== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qvws8hd7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 08:29:35 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34U8TYTT026280
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 08:29:34 GMT
Received: from tjiang-gv.qualcomm.com (10.80.80.8) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 30 May 2023 01:29:31 -0700
From: Tim Jiang <quic_tjiang@quicinc.com>
To: <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>
CC: <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <quic_bgodavar@quicinc.com>,
        <quic_hemantg@quicinc.com>, Tim Jiang <quic_tjiang@quicinc.com>
Subject: [PATCH v2] dt-bindings: net: Add QCA2066 Bluetooth
Date: Tue, 30 May 2023 16:29:22 +0800
Message-ID: <20230530082922.2208-1-quic_tjiang@quicinc.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: hPgNw92--PY-uI2aho5NGB4nAwr1O1Y4
X-Proofpoint-GUID: hPgNw92--PY-uI2aho5NGB4nAwr1O1Y4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_04,2023-05-29_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=934
 suspectscore=0 mlxscore=0 adultscore=0 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305300069
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add bindings for the QCA2066 chipset.

Signed-off-by: Tim Jiang <quic_tjiang@quicinc.com>
---
 .../devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml   | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
index 68f78b90d23a..28296b6d35b2 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml
@@ -16,6 +16,7 @@ description:
 properties:
   compatible:
     enum:
+      - qcom,qca2066-bt
       - qcom,qca6174-bt
       - qcom,qca9377-bt
       - qcom,wcn3990-bt
@@ -95,6 +96,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,qca2066-bt
               - qcom,qca6174-bt
     then:
       required:
-- 
2.17.1


