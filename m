Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE82F6EA75C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjDUJnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjDUJnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:43:37 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1C4AF00;
        Fri, 21 Apr 2023 02:43:31 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L9YXQW011214;
        Fri, 21 Apr 2023 09:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=4jr5yrLucktb45hL8zakgFj6AedY561gZkDUZHmfI6E=;
 b=bw99ggVLtgxlWk+jaTZZc0SeRyNTbEiGk84VD787XRZUUyeqngOypxCRrEPEobzIsJAr
 uYJxoW+J0kiNKy3sTsg9m89OHhx9KWPAl+DQwyQfgeGidsPnRF9GSG1o4CbAE1GE7qDb
 7HNgVyz8+ae0h09U7g9s5echwukFE3KjFKixmdSk8snBi+vIaMmsq5S7Lt4a4wXHiOjI
 DIHm6MmdMUZ5lRSftmNpLRF3Py8RTmrcOSMmAnPpke7EEUfg765/wNvjDlnwu0cnFQ0y
 1d3XX0VshY9/bVY8PdWAy3lgrwXeurVa3Nf7errzoJOcG6Yn3hhYkQjjId5lXPC6NfNK FQ== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q3f3ts3ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 09:43:27 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 33L9hNIE025453;
        Fri, 21 Apr 2023 09:43:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3pyn0kpscm-1;
        Fri, 21 Apr 2023 09:43:23 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33L9hNsc025426;
        Fri, 21 Apr 2023 09:43:23 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 33L9hMjc025417;
        Fri, 21 Apr 2023 09:43:23 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
        id 46F975072; Fri, 21 Apr 2023 15:13:22 +0530 (+0530)
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v2 0/2] Add pinctrl support for SDX75
Date:   Fri, 21 Apr 2023 15:13:14 +0530
Message-Id: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: stsxsMkoo7uHUySPXY8hLI1yQCoFjnfP
X-Proofpoint-ORIG-GUID: stsxsMkoo7uHUySPXY8hLI1yQCoFjnfP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_03,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=614
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210083
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes in v2:
 - Updated the bindings to clear the bindings check.

This patch series adds pinctrl bindings and tlmm support for SDX75.

Thanks,
Rohit.

Rohit Agarwal (2):
  dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
  pinctrl: qcom: Add SDX75 pincontrol driver

 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  177 +++
 drivers/pinctrl/qcom/Kconfig                       |   30 +-
 drivers/pinctrl/qcom/Makefile                      |    3 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1536 ++++++++++++++++++++
 4 files changed, 1735 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c

-- 
2.7.4

