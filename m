Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E57CA19A9D5
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 12:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbgDAK6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 06:58:50 -0400
Received: from m12-13.163.com ([220.181.12.13]:55437 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgDAK6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 06:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=mba1+
        llejJ6cxD8XCX3+NwIRx765YLvlQ1o9Lrf4fWg=; b=SkO97ih8W7cpKZA3sZjiE
        e1OPFOMkO4tmi+20JDrKJGG6/OGWBbfrvVlvz+qAaE95ZTjJ2QNNAzYEMSijwOe+
        dAa4EL9U1v97pE+OByoiwkLMVd+i+OtoI+xeU3rDNIe0jkZ8NFl/9vlRL76wPMeJ
        SdXr3qpl3QsFp8cMOmii/k=
Received: from localhost.localdomain (unknown [125.82.11.8])
        by smtp9 (Coremail) with SMTP id DcCowADn95tjc4RefIC7Bw--.31484S4;
        Wed, 01 Apr 2020 18:56:37 +0800 (CST)
From:   Hu Haowen <xianfengting221@163.com>
To:     davem@davemloft.net, andrew@lunn.ch, mchehab+samsung@kernel.org,
        andrew@aj.id.au, corbet@lwn.net
Cc:     stfrench@microsoft.com, chris@chris-wilson.co.uk,
        xiubli@redhat.com, airlied@redhat.com, tglx@linutronix.de,
        benh@kernel.crashing.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hu Haowen <xianfengting221@163.com>
Subject: [PATCH] net/faraday: fix grammar in function ftgmac100_setup_clk() in ftgmac100.c
Date:   Wed,  1 Apr 2020 18:56:24 +0800
Message-Id: <20200401105624.17423-1-xianfengting221@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowADn95tjc4RefIC7Bw--.31484S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrur1rZw15XFWUAw1UKr43Awb_yoWfGwcEgF
        1UXF4fWrWUKFySy34j9rZ8ZFyYkrn5Wwn5GF10gayfAw4xZr13Jw1kuF97XF1Dur45GF9r
        GryayFW8Z34IqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbGXdUUUUUU==
X-Originating-IP: [125.82.11.8]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiFQX4AF5mI9XKZQAAsJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"its not" is wrong. The words should be "it's not".

Signed-off-by: Hu Haowen <xianfengting221@163.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 835b7816e372..87236206366f 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1731,7 +1731,7 @@ static int ftgmac100_setup_clk(struct ftgmac100 *priv)
 	if (rc)
 		goto cleanup_clk;
 
-	/* RCLK is for RMII, typically used for NCSI. Optional because its not
+	/* RCLK is for RMII, typically used for NCSI. Optional because it's not
 	 * necessary if it's the AST2400 MAC, or the MAC is configured for
 	 * RGMII, or the controller is not an ASPEED-based controller.
 	 */
-- 
2.20.1


