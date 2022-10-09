Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA435F93BB
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiJIXoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJIXnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:43:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E20E6A4AE;
        Sun,  9 Oct 2022 16:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE91DB80DD4;
        Sun,  9 Oct 2022 22:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4DAC433C1;
        Sun,  9 Oct 2022 22:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354416;
        bh=vjYXcM4d6U4y24O7mT2Q36DVyLJAZZU64TsfuVOvQ4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZ13J7zEvlNhAuQxQYECLeUn5uqMph87Nk0JmC5OACLZB1W4NcGbUZzM6dotK1azB
         /8ZWBqWbenbIV9rGVGhubuHCejqk0Fow/7R2NV5LK9eSzVEjTMeaUGoV/AKHnTri75
         cpsVGjEuoI9BNnj2NC4PsomTMLVxKbwwHK877xzIsywCMCPfieZ/q7iv1ht6xXEHz1
         GmngKTkgHj3dyAzHUQ9o7TG91lMQD8G3BILwP7Q9wGwZX2LEX68negy3K54R0qH4UP
         VxtK7YSVHfqMZX9aTEyk6B9cxsWmJtY6WGxrVBColsnSSUhuDTTzG8Si+MpuToc9R0
         WuGxyTTkDQqTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/23] wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
Date:   Sun,  9 Oct 2022 18:25:48 -0400
Message-Id: <20221009222557.1219968-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit eeb50acf15762b61921f9df18663f839f387c054 ]

Set correct TX_SW_CFG1 MAC register as it is done also in v3 of the
vendor driver[1].

[1]: https://gitlab.com/dm38/padavan-ng/-/blob/master/trunk/proprietary/rt_wifi/rtpci/3.0.X.X/mt76x2/chips/rt6352.c#L531
Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/4be38975ce600a34249e12d09a3cb758c6e71071.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 1309c136f7f3..0c90bf0540b9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5315,7 +5315,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 	} else if (rt2x00_rt(rt2x00dev, RT6352)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0001);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
 		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
 		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
-- 
2.35.1

