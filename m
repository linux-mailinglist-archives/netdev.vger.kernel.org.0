Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7514296BF8
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 11:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461345AbgJWJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 05:21:22 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:49876 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S461338AbgJWJVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 05:21:22 -0400
Received: from localhost.localdomain (unknown [124.16.141.242])
        by APP-01 (Coremail) with SMTP id qwCowACHjuaGoJJfbPJ1Aw--.34707S2;
        Fri, 23 Oct 2020 17:21:10 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] net: microchip: Remove unneeded variable ret
Date:   Fri, 23 Oct 2020 09:21:07 +0000
Message-Id: <20201023092107.28065-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowACHjuaGoJJfbPJ1Aw--.34707S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy7ZryrCFW7Xr48AF1xuFg_yoWDWFg_Cr
        1Fqw1xtr1DJw4q9r4qkw4DJ34v9FWDXw1kAa1kKrWfAwn8Ja109r97ZFnxAF18XrW5KF4D
        urnaqF1UA3WxtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xYjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GFWl42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0x
        vE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxT5dDUUUU
X-Originating-IP: [124.16.141.242]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQUSA102ZqG+cAAAs-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unneeded variable ret used to store return value.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index a1938842f828..8ea0b4eec19c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -834,14 +834,13 @@ static int lan743x_mac_init(struct lan743x_adapter *adapter)
 
 static int lan743x_mac_open(struct lan743x_adapter *adapter)
 {
-	int ret = 0;
 	u32 temp;
 
 	temp = lan743x_csr_read(adapter, MAC_RX);
 	lan743x_csr_write(adapter, MAC_RX, temp | MAC_RX_RXEN_);
 	temp = lan743x_csr_read(adapter, MAC_TX);
 	lan743x_csr_write(adapter, MAC_TX, temp | MAC_TX_TXEN_);
-	return ret;
+	return 0;
 }
 
 static void lan743x_mac_close(struct lan743x_adapter *adapter)
-- 
2.17.1

