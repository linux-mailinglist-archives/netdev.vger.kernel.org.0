Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A1F6E8962
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 07:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjDTFCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 01:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjDTFCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 01:02:09 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DC346AA;
        Wed, 19 Apr 2023 22:02:07 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33K4IMP3008259;
        Thu, 20 Apr 2023 05:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=OUKcqgLLRZu+mRglayh8RrtSYtaRSrSs1j7C5KOCgaw=;
 b=DvwTKl8ojhAk8xSjVseSfbBM94R9aiMlZl+kSVCEwOEmxKjT4Pa64PmsSWFaBqFqqg5k
 L3IDdvZumQfl26eWsw1uTCQ/t9U8GbIkwWqPacLDR+k2z7krAJNuXt0B7p87ZJFDlGsF
 tAjQakzn8m6p55HETNrcfBQZhyb49C3YJcbpM3HRkVZchF4r0rqK3jKear0mjMszYEwc
 avGVgWflpq3DycWukLYlb6oWEF20w7c8HA6mDTHLyrKYYFTXwDJqURRpvyZnP9wtsivo
 Ik3stAWYdldIxpfBrIqLyv5zQ4O0YHoMYTfAeY0UnhHlvT10CF6TMmuWu/g5AMqOLc18 Nw== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q2dy7tccy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 05:02:03 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 33K51xXO014274;
        Thu, 20 Apr 2023 05:01:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3pyn0kj5tw-1;
        Thu, 20 Apr 2023 05:01:59 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33K51xGP014261;
        Thu, 20 Apr 2023 05:01:59 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 33K51wZ2014258;
        Thu, 20 Apr 2023 05:01:59 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
        id 12FDB509B; Thu, 20 Apr 2023 10:31:58 +0530 (+0530)
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH 0/2] Add pinctrl support for SDX75
Date:   Thu, 20 Apr 2023 10:31:53 +0530
Message-Id: <1681966915-15720-1-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: MojemxC3dIIWsLN7hYr4hXN2hz6vBTag
X-Proofpoint-GUID: MojemxC3dIIWsLN7hYr4hXN2hz6vBTag
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_02,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=635 clxscore=1011
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200039
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds pinctrl bindings and tlmm support for SDX75.

Thanks,
Rohit.


Rohit Agarwal (2):
  dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
  pinctrl: qcom: Add SDX75 pincontrol driver

 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  195 +++
 drivers/pinctrl/qcom/Kconfig                       |   30 +-
 drivers/pinctrl/qcom/Makefile                      |    3 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1536 ++++++++++++++++++++
 4 files changed, 1753 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c

-- 
2.7.4

