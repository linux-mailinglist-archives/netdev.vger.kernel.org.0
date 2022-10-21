Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1306560770F
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiJUMjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiJUMiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:38:55 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E462681CE
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:38:39 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221021123837epoutp02a069f0f5742449dfa295f9dccd616ce9~gFeC8kfMA0141801418epoutp02I
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:38:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221021123837epoutp02a069f0f5742449dfa295f9dccd616ce9~gFeC8kfMA0141801418epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666355917;
        bh=biFlnjuZ8k7mTMxR0OX0eBniKYxMuKThwFDjh9fvDPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fM/6QpP77QqhvdyX4IMUTsW3Snw5E3jfZMJqCOnubcf3zz4RNNnjUgM1XrqG77+BB
         gDPtEitKhaZOqkx6qiKvoZlHlakFTj2jKeU2vSVV7NcjD+2/k++gdIzHqS1DhEQbYH
         Nk1vS30dxzgPLCswBzRzzbVhOotPRDCGRbgvoeYU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221021123836epcas5p26af5b3a891b3f64ace2e9353297721d1~gFeCVtaPu1049710497epcas5p2R;
        Fri, 21 Oct 2022 12:38:36 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Mv3t15TyZz4x9Pw; Fri, 21 Oct
        2022 12:38:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.EB.20812.9C292536; Fri, 21 Oct 2022 21:38:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221021102642epcas5p24fec1e1e90632f6d9e768f7d25dc5480~gDq4NHe3l0419604196epcas5p2Z;
        Fri, 21 Oct 2022 10:26:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221021102642epsmtrp28fea699862896241631581e17642ead7~gDq4MJMPm0776407764epsmtrp2P;
        Fri, 21 Oct 2022 10:26:42 +0000 (GMT)
X-AuditID: b6c32a49-b09f97000001514c-61-635292c956f6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        56.26.14392.2E372536; Fri, 21 Oct 2022 19:26:42 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021102640epsmtip1194c12f5c871cadc8caa52e6fb12ce21~gDq2Ud8bo2758127581epsmtip1B;
        Fri, 21 Oct 2022 10:26:40 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH 7/7] arm64: dts: fsd: Add support for error correction code
 for message RAM
Date:   Fri, 21 Oct 2022 15:28:33 +0530
Message-Id: <20221021095833.62406-8-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221021095833.62406-1-vivek.2311@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdlhTQ/fkpKBkgw87NC0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74
        2PmRqWAHb8XfK/NZGhjvcHUxcnJICJhItM57wNTFyMUhJLCbUeLqpQ/MEM4nRomzG9+zgVQJ
        CXxjlLjSHAHT0fXpBCtE0V5GiW0NE9ggnFYmiVtvm1lBqtgEtCQedy5gAbFFBO4ySlxbnNnF
        yMHBLFAtceAIH0hYWCBW4sKlXWALWARUJb48OcAIYvMKWEs8aZnMBLFMXmL1hgPMIDangI3E
        q/lbGEF2SQhM5JDYuPMzM0SRi8Tyn5OgGoQlXh3fwg5hS0l8freXDcJOltjxr5MVws6QWDBx
        DyOEbS9x4MocFojbNCXW79KHCMtKTD21DmwkswCfRO/vJ1DjeSV2zIOxVSRefJ7ACtIKsqr3
        nDBE2EPi8qP/0PDpZ5SYNPk02wRGuVkIGxYwMq5ilEwtKM5NTy02LTDMSy2Hx1lyfu4mRnC6
        1PLcwXj3wQe9Q4xMHIyHGCU4mJVEeC3qgpKFeFMSK6tSi/Lji0pzUosPMZoCw28is5Rocj4w
        YeeVxBuaWBqYmJmZmVgamxkqifMunqGVLCSQnliSmp2aWpBaBNPHxMEp1cCksYnryO7uRxfD
        onYcUurYJP6w6dHHZga5r1ovY65r/xcu0Xq49dqknyXTbtYl3n2axl9X7VM+VXNN/a/Htmsc
        05O6y76e8Ct88a2FY9rxJI9HN+bFOUg9aMvq8Aq6H3+o47mLvURl5ZI1M/3/fwv3srW4eX9R
        nahmZ/mdCXO/P5cQvNJrLiT7yqf2WOHtjB9qGerB0oFtvYHWZ/9MFv6Yasbs0nuorHe+7B1u
        vunOrF+E10r3XFqynmWP6N0rWqumqLvf3n7JWGoxT43NrgOJXu9mfA7ZIHOWU/NwR7PzjBW5
        u+/89mQ7k519aHlsoxxvhubch3qOCnvD+6VLfglPn/rZjC2nSvPFL5UAO3MlluKMREMt5qLi
        RADlduDdIAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnO6j4qBkg3NL9CwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZXzs/MhUsIO34u+V+SwNjHe4uhg5OSQETCS6Pp1g7WLk4hAS2M0oMfvN
        XkaIhJTElDMvWSBsYYmV/56zQxQ1M0nsXHqICSTBJqAl8bhzAViRiMBLRomWs2wgNrNAvcS7
        MzfZQWxhgWiJfx+Pgg1lEVCV+PLkAJjNK2At8aRlMhPEAnmJ1RsOMIPYnAI2Eq/mbwGrEQKq
        WfboJvsERr4FjAyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCg1pLcwfj9lUf9A4x
        MnEwHmKU4GBWEuEteBeQLMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILU
        IpgsEwenVAPTfK03/yMiLobMV/hzY9Mpo9LbTB8dJFlsrwktuSm+S797dnZ2fdSW2RLHZrTN
        O9hz+MNaNa8tfFMf7HC4KvkjrPyuYseBY17f7kfEJHjHWNx1OnHxV4n2w+qA7fMv7ktlXFK6
        6EZq9RfDiT8mr+k5Oq218ccaM5fLYcs8zh2UfGKWJuO2eWbpU1U1+xk2qj+WXn9zSi3B/Hht
        vcNiP6aK52F7N23cHaMwLyrhxpfQrxe2797mkVP+5HaPyOXP0dEz0i0NGaM0JS0XRP/euvpo
        b9j/ikNJkwu+di1NiltuX/9cfZK95Wbf6x9OzlVa7dBlNHv3wwUlLLr7TqprNh9PflLRdP5i
        TG5s6N6MDc8z9imxFGckGmoxFxUnAgBdRuRs2QIAAA==
X-CMS-MailID: 20221021102642epcas5p24fec1e1e90632f6d9e768f7d25dc5480
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021102642epcas5p24fec1e1e90632f6d9e768f7d25dc5480
References: <20221021095833.62406-1-vivek.2311@samsung.com>
        <CGME20221021102642epcas5p24fec1e1e90632f6d9e768f7d25dc5480@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mram-ecc-cfg property which indicates the error correction code config
and enable the same for FSD platform.

In FSD, error correction code (ECC) is configured via PERIC SYSREG registers.

Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 arch/arm64/boot/dts/tesla/fsd.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
index 154fd3fc5895..03d46a113612 100644
--- a/arch/arm64/boot/dts/tesla/fsd.dtsi
+++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
@@ -778,6 +778,7 @@
 			clocks = <&clock_peric PERIC_MCAN0_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN0_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			mram-ecc-cfg = <&sysreg_peric 0x700>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
@@ -795,6 +796,7 @@
 			clocks = <&clock_peric PERIC_MCAN1_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN1_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			mram-ecc-cfg = <&sysreg_peric 0x704>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
@@ -812,6 +814,7 @@
 			clocks = <&clock_peric PERIC_MCAN2_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN2_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			mram-ecc-cfg = <&sysreg_peric 0x708>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
@@ -829,6 +832,7 @@
 			clocks = <&clock_peric PERIC_MCAN3_IPCLKPORT_PCLK>,
 				<&clock_peric PERIC_MCAN3_IPCLKPORT_CCLK>;
 			clock-names = "hclk", "cclk";
+			mram-ecc-cfg = <&sysreg_peric 0x70c>;
 			bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
 			status = "disabled";
 		};
-- 
2.17.1

