Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021915F9000
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiJIWT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiJIWSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBFA1262D;
        Sun,  9 Oct 2022 15:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5B360C91;
        Sun,  9 Oct 2022 22:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB43AC433D6;
        Sun,  9 Oct 2022 22:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353589;
        bh=rfhGV7N9C6ZVl3JruPAcA6LKfJ3cyhGgcnuyB098JMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owkfe16OXvg5CApnG1iXdLuCwscpAqRTDKAsWQsTsGTwM9UgEBijeFplrm9Aa09/p
         bAMbo6ltgHrhiC3t0x/QCdt1RksEKAt1A4EVwKRS4GDd8quh3ZslA7Fv4/soSeFBuX
         IyAGETvlo7QpWKvwiJdEwmSvKOlslZPTkXM/PHpg5kbMqITg5LadORjwhBNzdSgpR3
         CGBu+CvmZOdzecWbzptTvmDpF9vY5MBbeVlr5XkT9k8AXe5AXuj81UwUFyogBB700O
         W2t9j7azDynHSkoMMYiXGZBoEkaX/KMcqkhBbX6VRrWmYGB31u9w8fXnYuVuDEKo5r
         Jxufls86G6VvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 66/77] wifi: rt2x00: correctly set BBP register 86 for MT7620
Date:   Sun,  9 Oct 2022 18:07:43 -0400
Message-Id: <20221009220754.1214186-66-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

[ Upstream commit c9aada64fe6493461127f1522d7e2f01792d2424 ]

Instead of 0 set the correct value for BBP register 86 for MT7620.

Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/257267247ee4fa7ebc6a5d0c4948b3f8119c0d77.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index b30b062243bb..1a9e27a6d636 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4164,7 +4164,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
-		rt2800_bbp_write(rt2x00dev, 86, 0);
+		if (rt2x00_rt(rt2x00dev, RT6352))
+			rt2800_bbp_write(rt2x00dev, 86, 0x38);
+		else
+			rt2800_bbp_write(rt2x00dev, 86, 0);
 	}
 
 	if (rf->channel <= 14) {
-- 
2.35.1

