Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D4617A00
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiKCJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiKCJ3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:29:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2213E01D;
        Thu,  3 Nov 2022 02:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86388B826A5;
        Thu,  3 Nov 2022 09:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE06C433D6;
        Thu,  3 Nov 2022 09:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667467750;
        bh=B/U8fjOrOcTUs3/L5mJw71YthuNrt+CD4lE1Aj11sjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhfiIxFYdDykFSJ90KjtBljy2e64lIDURT0tgo9hQ7R7T5drWE5JE2SClyC9GcFB0
         pXbJdEuYTj70LUwNQHd/90Xdq2et8FB4W/NuIHqtnjNd7RRky9IYGjHRzXd52gZinu
         uXsnr0iWh+ayVACGhtxwnINMm+wEwqjW/n91IVOI/kwrVtzGxEcZIozYJzmLwmW3Zk
         WMySFEGUuoGKeSQM54txRCGHsLn3lIWMTDeUFuuQ3slnXbp9CBkcybwj7738prM+1S
         Dwb8w8EDTi2r6YJWlerMH0Na7jWw5VdXwcJeF/GCBQ35xVvZK0af5W/okS1gPVY1P3
         JETVU3WQrXcjg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
Subject: [PATCH v3 net-next 8/8] MAINTAINERS: update MEDIATEK ETHERNET entry
Date:   Thu,  3 Nov 2022 10:28:07 +0100
Message-Id: <a13a62d87d37b98d3c8d93a63ee30dc2508ef75c.1667466887.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667466887.git.lorenzo@kernel.org>
References: <cover.1667466887.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update MEDIATEK ETHERNET driver maintainer file enty adding myself to
maintainers list

Acked-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7d44c5a6607d..b277dbde70ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12920,6 +12920,7 @@ M:	Felix Fietkau <nbd@nbd.name>
 M:	John Crispin <john@phrozen.org>
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Mark Lee <Mark-MC.Lee@mediatek.com>
+M:	Lorenzo Bianconi <lorenzo@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/mediatek/
-- 
2.38.1

