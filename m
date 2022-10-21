Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF0607701
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJUMiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJUMiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:38:09 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2F7266405
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:08 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221021123806epoutp0163023bad239d69511486a9ac2bc1ecda~gFdmbnMEb1343113431epoutp01h
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221021123806epoutp0163023bad239d69511486a9ac2bc1ecda~gFdmbnMEb1343113431epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355886;
        bh=wYzdlzB1VUH92bAi49JRyjlvkFCC7Q8FuepmJXNRrZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuJBryLmAc/gX/m06Bj5b1EHg8NLavHMpySqJgI86kU+ktUQLgq2YANl+Rh/jLCfw
         vnOgDzcZ2Uj+3E9mhPcPGKpGZKlAxyJUIeBgTZ3RSO+i2FkGctQEmI0Hz69WbpB6yQ
         ynIsEGiIPhR8YFv9ZCxm+GGRSvo3TgyT0a/ErcKE=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221021123805epcas5p43250d3ccd0affefb9cacc6fb9f41f0f1~gFdlxkPGm2985729857epcas5p4d;
        Fri, 21 Oct 2022 12:38:05 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Mv3sR3jfxz4x9Pw; Fri, 21 Oct
        2022 12:38:03 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.5F.56352.BA292536; Fri, 21 Oct 2022 21:38:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d~gDqnzpXFw0278002780epcas5p4q;
        Fri, 21 Oct 2022 10:26:25 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021102625epsmtrp13b1bcd957045dfe5823dcae5e0fbe106~gDqnyvBDA1811718117epsmtrp1m;
        Fri, 21 Oct 2022 10:26:25 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-62-635292abc382
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.30.18644.0D372536; Fri, 21 Oct 2022 19:26:25 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102623epsmtip112032568f9ef79388f276b8b1303d124~gDql0c6RI2573525735epsmtip1D;
        Fri, 21 Oct 2022 10:26:22 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH 2/7] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Date:   Fri, 21 Oct 2022 15:28:28 +0530
Message-Id: <20221021095833.62406-3-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTU3f1pKBkg7WfpC0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM54
        fGEza8E/zopJTw+wNTAu4uhi5OSQEDCR2HNmO0sXIxeHkMBuRomW35cZIZxPjBK7tx1ih3A+
        M0rcWrGJCaZl7+vzzBCJXYwSXxpPsUI4rUwSq1asYAGpYhPQknjcuQDMFhG4yyhxbXFmFyMH
        B7NAtcSBI3wgYWGBYIkNZ48ygtgsAqoSvy7cBlvAK2AtsejTImaIZfISqzccALM5BWwkXs3f
        AnaehEAvh8SSs0fZQWZKCLhIrH+pBFEvLPHq+BZ2CFtK4mV/G5SdLLHjXycrhJ0hsWDiHkYI
        217iwJU5LBCnaUqs36UPEZaVmHpqHdg5zAJ8Er2/n0D9ziuxYx6MrSLx4vMEVogLpCR6zwlD
        hD0kun9Nh4ZbP6PEqr2XGCcwys1C2LCAkXEVo2RqQXFuemqxaYFxXmo5PM6S83M3MYLTpZb3
        DsZHDz7oHWJk4mA8xCjBwawkwmtRF5QsxJuSWFmVWpQfX1Sak1p8iNEUGHwTmaVEk/OBCTuv
        JN7QxNLAxMzMzMTS2MxQSZx38QytZCGB9MSS1OzU1ILUIpg+Jg5OqQYmtVqv0KnbSnsmvOKv
        PNwXJC28yPLj3oTmbT0nhWb4+3JISh1vWhxvtlizd1P5aRWhD963Nho8vWfy6YGzyifLgOSj
        bNH2pQmlKc51LPFX/u7m68nTn3Fxv/27xGx+/ntfrz9fLZbgd/buI6OMT5/dy6ya7ns/NAjK
        y1517radw4TXE0+bvHzKFTwrcV/i+YBLYTfKLh66yuZaev9BHu/xLMsLEepv37j7bA2sv7hh
        29Si+BtS8r2pfTPUxZbHt77xzPyanF/1y6n+c8qXMxtMi/7FTSk9UVkjblTcd3JD6Y+DX8MX
        1qaterMzrKfyqLfx2rVHvZJn3LE9fOds9rN9ld7L9zx+vvjdo6cSsbeElViKMxINtZiLihMB
        zn63fSAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnO7F4qBkg9MTmS0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZTy+sJm14B9nxaSnB9gaGBdxdDFyckgImEjsfX2euYuRi0NIYAejxOUX
        n5ggElISU868ZIGwhSVW/nvODlHUzCTxrX83WBGbgJbE484FYEUiAi8ZJVrOsoHYzAL1Eu/O
        3GQHsYUFAiXmTl/GCmKzCKhK/LpwG6yXV8BaYtGnRcwQC+QlVm84AGZzCthIvJq/hRHEFgKq
        WfboJvsERr4FjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCg1pLawfjnlUf9A4x
        MnEwHmKU4GBWEuEteBeQLMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILU
        IpgsEwenVANTyuY3wZXXP02LEea33Pljvs0UFgWDn9fUvq4w3ml+ksNvQlpV5f6Nt05FFK0x
        P19tzRB+zJp1e+/8+uPq96NOSt99kuwTYZyaf51LSfANd+jaKR90XdwXqvnvc3tmEPLT7135
        LKfZQcnLbKcutVXJLHveVrCYT+XfmymB6du9l7y6UZL+zWXe7dIpicc3edUWb3iylH1H82/D
        J3PKhH/E2OX9ebWinZmZSXlz4+0VE/lO+h2t38doEHOqg5nf1WVx9PXPeXJ7wwpnl1y/eCA8
        8FRCQE6L19x3uiYf/+m7LreV+LfewMi7breJg6vB27RbcvOS7v2ebjhny1vtDSmWPZr5c1oK
        C3+GvI3/LbZTiaU4I9FQi7moOBEAUJeun9kCAAA=
X-CMS-MailID: 20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102625epcas5p4e1c5900b9425e41909e82072f2c1713d@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the data is transferred or stored on message ram, there are
inherent risks of it being lost or corruption known as single-bit errors.

ECC constantly scans data as it is processed to the message ram, using a
method known as parity checking and raise the error signals for corruption.

Add error correction code config property to enable/disable the
error correction code (ECC) functionality for Message RAM used to create
valid ECC checksums.

Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
index 26aa0830eea1..0ba3691863d7 100644
--- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
+++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
@@ -50,6 +50,10 @@ properties:
       - const: hclk
       - const: cclk
 
+  mram-ecc-cfg:
+    items:
+      - description: M_CAN ecc registers map with configuration register offset
+
   bosch,mram-cfg:
     description: |
       Message RAM configuration data.
-- 
2.17.1

