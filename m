Return-Path: <netdev+bounces-4594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF76070D795
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6264B2812A6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36471B90F;
	Tue, 23 May 2023 08:35:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E37BE7D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:35:30 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF35BE47;
	Tue, 23 May 2023 01:35:28 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N7N4gp000432;
	Tue, 23 May 2023 07:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=C5RCb3DBpPeqbo3fxtcAA8qIzXb1DW+88OYyPdACG+k=;
 b=LlQdxRPXVqxk3S1A/t6oMcSKeWPg4k5hqxgSj88j2Rjl+yQqZZt2vAyD4hPLVUf+fJ/G
 rZE/7r48FJJUi20LRS4E/6dcDb9OkVDFqPJjeP0BkaRjSN/EvgJpuUbE+SZkFAAqkbQJ
 cCytlziB/6tgQ58DOb9dHPgDuao7kcm76ck/WDwFhuhjnfgvglViQigmDzYp+zlbdTZZ
 A0rzEetE8HZwqYyGnjnZVTG9iJgojE++V13H6/OOjIzA8F3GX7o8tmr9ZpO3Szk4BcW/
 PIMAeRn0/CVBwXXhtfz1CQX6ccSofy2K8P6q71asuhVAO3Csyv4FACESShETxxzFrdx4 UQ== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qr8qra0yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 07:49:22 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 34N7nAvw012078
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 07:49:10 GMT
Received: from nalasex01b.na.qualcomm.com (10.47.209.197) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 23 May 2023 00:49:09 -0700
Received: from nalasex01b.na.qualcomm.com ([fe80::a057:7d2:b40d:81d6]) by
 nalasex01b.na.qualcomm.com ([fe80::a057:7d2:b40d:81d6%12]) with mapi id
 15.02.0986.042; Tue, 23 May 2023 00:49:09 -0700
From: "Tim Jiang (QUIC)" <quic_tjiang@quicinc.com>
To: "krzk@kernel.org" <krzk@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balakrishna
 Godavarthi (QUIC)" <quic_bgodavar@quicinc.com>,
        "Hemant Gupta (QUIC)"
	<quic_hemantg@quicinc.com>
Subject: RE: [PATCH v2] dt-bindings: net: Add QCA2066 Bluetooth
Thread-Topic: [PATCH v2] dt-bindings: net: Add QCA2066 Bluetooth
Thread-Index: AQHZiWr4KiB/3yzZPk+lfwSX6G7z5K9ngxfQ
Date: Tue, 23 May 2023 07:49:09 +0000
Message-ID: <fb3678d67fd4428eaec98365288384ed@quicinc.com>
References: <20230518092719.11308-1-quic_tjiang@quicinc.com>
In-Reply-To: <20230518092719.11308-1-quic_tjiang@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.109.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 684AyIU3oWLYxBl2Web_ePKl21SATIze
X-Proofpoint-ORIG-GUID: 684AyIU3oWLYxBl2Web_ePKl21SATIze
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_04,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=907 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230064
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi krzk:
  Could you help review this patch ?

Regards.
Tim


-----Original Message-----
From: Tim Jiang (QUIC) <quic_tjiang@quicinc.com>=20
Sent: Thursday, May 18, 2023 5:27 PM
To: krzk@kernel.org
Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-kernel@vger.k=
ernel.org; Balakrishna Godavarthi (QUIC) <quic_bgodavar@quicinc.com>; Heman=
t Gupta (QUIC) <quic_hemantg@quicinc.com>; Tim Jiang (QUIC) <quic_tjiang@qu=
icinc.com>
Subject: [PATCH v2] dt-bindings: net: Add QCA2066 Bluetooth

Add bindings for the QCA2066 chipset.

Signed-off-by: Tim Jiang <quic_tjiang@quicinc.com>
---
 .../devicetree/bindings/net/bluetooth/qualcomm-bluetooth.yaml   | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluet=
ooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-blueto=
oth.yaml
index 68f78b90d23a..28296b6d35b2 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.ya=
ml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qualcomm-bluetooth.ya=
ml
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
--=20
2.17.1


