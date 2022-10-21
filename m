Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153FF607705
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJUMiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJUMig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:38:36 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046F726643E
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:20 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221021123818epoutp02d10e7a09f9f45a8bae834c83c06038bd~gFdx81HOq0141801418epoutp02B
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221021123818epoutp02d10e7a09f9f45a8bae834c83c06038bd~gFdx81HOq0141801418epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355898;
        bh=uhm3YP377q8y/51dTZVXOc3UJK/fzE1R7v2Hm2TpC8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SE5lNSb7xrWxSmwduN5zFkvuztmY3EfFR5a9EztKJvZN5++eCxdcXU3k4eRfIbWU7
         xQ2wxE0HzlfIesN3N9djSE3YW8/rtkZTE4yRm3FNAL/8pdvZjBV0phjAHTFqg137SH
         lEpK3FswWCqJMSWrDZ17u4jFpuTT0cUy4OBQgdB8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20221021123818epcas5p4d5214f70e266a0fe2bc7dfb70191bfba~gFdxZrQZI2985729857epcas5p4z;
        Fri, 21 Oct 2022 12:38:18 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mv3sg4myNz4x9Pp; Fri, 21 Oct
        2022 12:38:15 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.BB.39477.7B292536; Fri, 21 Oct 2022 21:38:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102628epcas5p1ecf91523d9db65b066bc4f2cb693ea45~gDqq_jsnF1244112441epcas5p1D;
        Fri, 21 Oct 2022 10:26:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221021102628epsmtrp21ecebb48a77631b0359d8e2b3e5b18e7~gDqq9olma0776407764epsmtrp2D;
        Fri, 21 Oct 2022 10:26:28 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-45-635292b7890e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.40.18644.4D372536; Fri, 21 Oct 2022 19:26:28 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102626epsmtip100eca027f7beccd9cbe9cd799aa5e567~gDqpAuNVZ2573525735epsmtip1E;
        Fri, 21 Oct 2022 10:26:26 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sriranjani P <sriranjani.p@samsung.com>
Subject: [PATCH 3/7] arm64: dts: fsd: add sysreg device node
Date:   Fri, 21 Oct 2022 15:28:29 +0530
Message-Id: <20221021095833.62406-4-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTU3f7pKBkg8NP5C0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFrc
        frOO1WLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74
        dmgra8ETjop9F7uZGhiXs3cxcnBICJhItHyx7WLk4hAS2M0o8ffcFJYuRk4g5xOjxKwNgRCJ
        z4wST64uYQJJgDQ8+tnGBJHYxSixcccnJoiOViaJXz8tQWw2AS2Jx50LwCaJCNxllLi2OBNk
        G7NAncTFMwYgYWEBG4nz5/6xg9gsAqoSm2+9ZQSxeQWsJbqOTGeG2CUvsXrDATCbE6j+1fwt
        jCB7JQR6OSTauqaxQRS5SDw6cArKFpZ4dXwLO4QtJfH53V6oeLLEjn+drBB2hsSCiXsYIWx7
        iQNX5rBA3KYpsX6XPkRYVmLqqXVgbzEL8En0/n4C9TuvxI55MLaKxIvPE1ghgSgl0XtOGCLs
        IdE/eRIjJET6GSWmdkdOYJSbhbBgASPjKkbJ1ILi3PTUYtMCo7zUcniEJefnbmIEJ0otrx2M
        Dx980DvEyMTBeIhRgoNZSYTXoi4oWYg3JbGyKrUoP76oNCe1+BCjKTD4JjJLiSbnA1N1Xkm8
        oYmlgYmZmZmJpbGZoZI47+IZWslCAumJJanZqakFqUUwfUwcnFINTCaufAl1E66uFmP4bqPh
        G3xd3vjOQ472t+JT1R9cddxc4NBhrXw79kigdcfx5eVBD2ybF0y1ezrvq4HE/bCA3GbN7c4q
        GaqSlmx+Ft+/KN1PMbtrmSGb+f1qB6/ZXfGwZg3vZRYveI+6zW0Lf75t2aYLHvzN1/peTo27
        c/7h3BdqPNuz22cpc1Q3M5Rxc99KumE0JYybp2ff6zjNzkWvP09UPHyQ1UlukueuX+Z/WwSv
        V8Zr9oV9b/3iZvjUdkb0xpcePi6iHtGXHzj0vztlkKMr1KfUe1rGTVfJb8KcTEa3iwa15/+p
        TLGKeWzQFv1DZGntJ6Vp9tfiGW1ni7aLr3OXcj43L7fgXWGQZrQSS3FGoqEWc1FxIgAqK2CG
        HQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnO6V4qBkg6cHZCwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFrc
        frOO1WLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZXw7tJW14AlHxb6L3UwNjMvZuxg5OSQETCQe/Wxj6mLk4hAS2MEocfDW
        f0aIhJTElDMvWSBsYYmV/56zQxQ1M0nMXbKcFSTBJqAl8bhzAViRiMBLRomWs2wgNrNAE6PE
        3uYcEFtYwEbi/Ll/YNtYBFQlNt96C7aAV8BaouvIdGaIBfISqzccALM5gepfzd8CViMEVLPs
        0U32CYx8CxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBAe1ltYOxj2rPugdYmTi
        YDzEKMHBrCTCW/AuIFmINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUw
        WSYOTqkGptbI8Iz5Z//Omrlk5/dnE4s2xTR0lnmdLj407Zrmdp5DN8OXT97ruezGIrbaqFmP
        HrFrf9C45mx+Jq/c75SURnvf2lkN+esYzWtZcz5+MhBe0Ma5rXtSQehUFuvqnFbnGXpvpq6J
        en8zSmrCTnXPjV4vnmZ8q17p17tLRchq9uPYh42iK4uqAteGTK7K6J639sGDqlvnjuWXqaxr
        u1O/dO3+n3cdNZT+nEgoe39pvqjIiRM1GZ5vGgL2CUZN/Zy4LfrqhJoAtp2NRh9Wcars0pv7
        IuXQ2fZ2rcDU1T91nJmXdad1Vf0K0oiaezK9Ybpox8ZNbu//r8s9LRda/2+1Ovcqgeir6oE2
        SzwfrWKO8lZiKc5INNRiLipOBAAx5ZwP2QIAAA==
X-CMS-MailID: 20221021102628epcas5p1ecf91523d9db65b066bc4f2cb693ea45
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102628epcas5p1ecf91523d9db65b066bc4f2cb693ea45
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102628epcas5p1ecf91523d9db65b066bc4f2cb693ea45@epcas5p1.samsung.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriranjani P <sriranjani.p@samsung.com>

Add SYSREG controller device node, which is available in PERIC and FSYS0
block of FSD SoC.

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index f35bc5a288c2..3d8ebbfc27f4 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -518,6 +518,16 @@
 				"dout_cmu_fsys1_shared0div4";
 		};
 
+		sysreg_peric: system-controller@14030000 {
+			compatible = "tesla,sysreg_peric", "syscon";
+			reg = <0x0 0x14030000 0x0 0x1000>;
+		};
+
+		sysreg_fsys0: system-controller@15030000 {
+			compatible = "tesla,sysreg_fsys0", "syscon";
+			reg = <0x0 0x15030000 0x0 0x1000>;
+		};
+
 		mdma0: dma-controller@10100000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0x0 0x10100000 0x0 0x1000>;
-- 
2.17.1

