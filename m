Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9268A604E69
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiJSRQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 13:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiJSRQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 13:16:25 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61C9164BD7;
        Wed, 19 Oct 2022 10:16:11 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGX4Gk023937;
        Wed, 19 Oct 2022 13:13:51 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3k7pq7hsfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 13:13:49 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 29JHDbVn029360
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Oct 2022 13:13:37 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Wed, 19 Oct
 2022 13:13:36 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Wed, 19 Oct 2022 13:13:36 -0400
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29JHDISJ014873;
        Wed, 19 Oct 2022 13:13:32 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>
Subject: [net-next 2/2] dt-bindings: net: adin1110: Document reset
Date:   Wed, 19 Oct 2022 20:13:14 +0300
Message-ID: <20221019171314.86325-2-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221019171314.86325-1-alexandru.tachici@analog.com>
References: <20221019171314.86325-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: dWqPzCWkd-YKdZYSVb1Iue9ZHgxGo52c
X-Proofpoint-GUID: dWqPzCWkd-YKdZYSVb1Iue9ZHgxGo52c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_10,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190098
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document GPIO for HW reset.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 Documentation/devicetree/bindings/net/adi,adin1110.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
index b6bd8ee38a18..9de865295d7a 100644
--- a/Documentation/devicetree/bindings/net/adi,adin1110.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
@@ -46,6 +46,10 @@ properties:
   interrupts:
     maxItems: 1
 
+  reset-gpios:
+    maxItems: 1
+    description: GPIO connected to active low reset
+
 required:
   - compatible
   - reg
-- 
2.34.1

