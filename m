Return-Path: <netdev+bounces-3621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EA770818D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E44E2818E1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB36423C75;
	Thu, 18 May 2023 12:41:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F3823C73
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:41:22 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732D10E3;
	Thu, 18 May 2023 05:41:21 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ICUmQ5007852;
	Thu, 18 May 2023 12:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=tSjRr0Hx0FwSJ3yVXqizkgmb+v2ekmbHt/n/R2Drs9s=;
 b=SXoAOUyqD68YOmTvClgjYtFRjS4QX7bUAXHcEXwjvYKMGzh8WQOcTSPNgSp6SQLYse+M
 pX1a7TSGwgZeDiKndDEUcHgjR/C4EvDbsq9RbPtK5j4/bT7Z2wjj6/jlAaxJJmUKhJjV
 8qIYXmfeoIb5E1QW1gbXKrCReNNilJ2422XSN/anG2iPOC0Qd9rt7y8bYvDBargxpKEI
 8BwTWqaI8WUnklQB8k1Z3/nmvXlv9aBu+ib4uTmxlkCRJT/wr0EtvCvWBcpRuTJUuHIO
 ECKb5OUNUabxO2ZV/9C0gPXsFt7NwVJejFfL6Kzm373ARJ13o6QHxGAjzBfCFlOZccpq AA== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qnbxqh041-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 May 2023 12:41:17 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34ICfD5D019479;
	Thu, 18 May 2023 12:41:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3qj3mkyxd7-1;
	Thu, 18 May 2023 12:41:13 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ICfDwR019466;
	Thu, 18 May 2023 12:41:13 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 34ICfDK2019477;
	Thu, 18 May 2023 12:41:13 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id C04FB5EBE; Thu, 18 May 2023 18:11:12 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        richardcochran@gmail.com, manivannan.sadhasivam@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v2 2/3] MAINTAINERS: Update the entry for pinctrl maintainers
Date: Thu, 18 May 2023 18:11:09 +0530
Message-Id: <1684413670-12901-3-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1684413670-12901-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1684413670-12901-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: gs-3jFwhmPqzFXXA2V0oSoNDrWlwiTEn
X-Proofpoint-GUID: gs-3jFwhmPqzFXXA2V0oSoNDrWlwiTEn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_09,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=530 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180100
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Update the entry for pinctrl bindings maintainer as the
current one checks only in the .txt files.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e0ad886..c030984 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16672,7 +16672,7 @@ PIN CONTROLLER - QUALCOMM
 M:	Bjorn Andersson <andersson@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/pinctrl/qcom,*.txt
+F:	Documentation/devicetree/bindings/pinctrl/qcom,*
 F:	drivers/pinctrl/qcom/
 
 PIN CONTROLLER - RENESAS
-- 
2.7.4


