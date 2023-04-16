Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9496E3BCC
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 22:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDPUHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 16:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjDPUHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 16:07:12 -0400
X-Greylist: delayed 456 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Apr 2023 13:07:11 PDT
Received: from qs51p00im-qukt01072101.me.com (qs51p00im-qukt01072101.me.com [17.57.155.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CA319BF
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 13:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1681675174; bh=IVKH4e5F12/aHSckhgJ+9Vou6vv8Z8xBAm/h26VKkak=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=TRMF70SlVzIW7G1ufFA1crD27DeMBXmjYIyqdOghnLy8JSdT2F779kJu+YHYgvBQ1
         Db7nYdpH6Mm1qGSMwz649N7FCP9JArk4wlTiDAqclZjzKwmgFQdmMIklXowPy4H5YF
         LbRUFOHfqwamjUQ+J1MZornk73uAlPpFDl4qRuUFqdVAtk9TFD8YOZtsSeaHBNvuWf
         geqaSgwySI0jdqgeanMU0ql6qZwloavEDXwBd5PmcVvigAThE+giJi6D+9Z183NsTO
         aPsqFJa0soiuLKiB6zniH/X0kZgEnsEMgL5ezYukIaHGnaMI8fbKDkfc8fhGMMow3n
         vqjyO8GCOt+eg==
Received: from localhost (qs51p00im-dlb-asmtp-mailmevip.me.com [17.57.155.28])
        by qs51p00im-qukt01072101.me.com (Postfix) with ESMTPSA id A53024152D;
        Sun, 16 Apr 2023 19:59:33 +0000 (UTC)
From:   Alain Volmat <avolmat@me.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     patrice.chotard@foss.st.com, Alain Volmat <avolmat@me.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: dwmac: sti: remove stih415/sti416/stid127
Date:   Sun, 16 Apr 2023 21:58:56 +0200
Message-Id: <20230416195857.61284-1-avolmat@me.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: VTkGdyk2TrNEdbva_m1b_pQNoH2gbW0Y
X-Proofpoint-ORIG-GUID: VTkGdyk2TrNEdbva_m1b_pQNoH2gbW0Y
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.790,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-12=5F02:2020-02-14=5F02,2022-01-12=5F02,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=776 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2304160189
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove compatible for stih415/stih416 and stid127 which are
no more supported.

Signed-off-by: Alain Volmat <avolmat@me.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
Patch previously sent as part of serie: https://lore.kernel.org/all/20230209091659.1409-9-avolmat@me.com/

 Documentation/devicetree/bindings/net/sti-dwmac.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/sti-dwmac.txt b/Documentation/devicetree/bindings/net/sti-dwmac.txt
index 062c5174add3..42cd075456ab 100644
--- a/Documentation/devicetree/bindings/net/sti-dwmac.txt
+++ b/Documentation/devicetree/bindings/net/sti-dwmac.txt
@@ -7,8 +7,7 @@ and what is needed on STi platforms to program the stmmac glue logic.
 The device node has following properties.
 
 Required properties:
- - compatible	: Can be "st,stih415-dwmac", "st,stih416-dwmac",
-   "st,stih407-dwmac", "st,stid127-dwmac".
+ - compatible	: "st,stih407-dwmac"
  - st,syscon : Should be phandle/offset pair. The phandle to the syscon node which
    encompases the glue register, and the offset of the control register.
  - st,gmac_en: this is to enable the gmac into a dedicated sysctl control
-- 
2.34.1

