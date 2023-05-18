Return-Path: <netdev+bounces-3690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BEA70856C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D767428195D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88702109A;
	Thu, 18 May 2023 15:57:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB3853A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:57:24 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0EEF7;
	Thu, 18 May 2023 08:57:23 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IAFkkp009866;
	Thu, 18 May 2023 15:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=+tCLz5FSXrJNwmOm35IsT9l61ejUoWghqwHx9aBHloA=;
 b=dsEjqK5Ja7urz67MudwK5DByqdgHnp4PwQafcamhdVHO8M8aqYLlQ18Hkxo29UUfP17O
 Wf48vdytreGG7KTNdsQGeuYFS7LfVA8Q42kBRtmVSm84FysmoMH4TCDUtNvvdhDs7/QF
 T5xS34O+PaetpYW0VCCMrOG935XXMyr3CkVr0ZjpXi29F0zh13bT/h5KnJYxm3mu0uht
 5HXr1wMoAIFxZvjfS/YMAJUNkMTwKk+JWy4R8Gi8XmtCfv1HdOdLkbt9DD1p1AiJPtV2
 nqEFBZONPZAjbPpsBxZANEnBNA0N17MEOHAp7XAww3L69DHaZBT+nFXHArRAJItcsUXW 7g== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qncbhsgme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 May 2023 15:57:19 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34IFvFtH010718;
	Thu, 18 May 2023 15:57:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3qj3mkaaen-1;
	Thu, 18 May 2023 15:57:15 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IFvFv6010713;
	Thu, 18 May 2023 15:57:15 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 34IFvFvn010701;
	Thu, 18 May 2023 15:57:15 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id BC3615EC0; Thu, 18 May 2023 21:27:14 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        richardcochran@gmail.com, manivannan.sadhasivam@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v3 2/3] MAINTAINERS: Update the entry for pinctrl maintainers
Date: Thu, 18 May 2023 21:27:11 +0530
Message-Id: <1684425432-10072-3-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1684425432-10072-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1684425432-10072-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 5Z38EE5szbSPvjjZc86S0EN0Yb2wETYJ
X-Proofpoint-ORIG-GUID: 5Z38EE5szbSPvjjZc86S0EN0Yb2wETYJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_12,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=561 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305180129
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
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
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
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


