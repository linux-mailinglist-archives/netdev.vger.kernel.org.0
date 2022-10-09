Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0942F5F901F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiJIWU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiJIWTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:19:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5703433A20;
        Sun,  9 Oct 2022 15:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891B960D14;
        Sun,  9 Oct 2022 22:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C0EC433C1;
        Sun,  9 Oct 2022 22:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353584;
        bh=OgQjpOolkW7jauhX45LnxD4niW+zPKmRX1OZN/8owKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCca7TzqCxiDmo1SgHINfsnYSVqqKoAJkYvR0N174Lm6ClfI1hFGooTSS1fe8jy+X
         yt8CDSm/N9/xyidr/jF5Zkwhm3H6txlAVlnGySTTSOZB31PewHNZvGxlnzwwFdlHTn
         W89lnG2w2UKF2KcGfYU93yUyKuLM/89XriU79SD+sxr5EO0TwOkmMv9zZBcbnpZEYl
         EVSIZ+ZW2maM8AnH+u80k2vD7bSE9uIGRn2vsnlEFJLuh9dOTG2VJlOwQ+uNqMV9is
         i2QivTOz8LA+23HrSTGWoqdSVhIzNonYuGt33eZQGbsCZuyixhwTYpDjo0n2BUkbEX
         vgaW22Xkg6fCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 64/77] wifi: rt2x00: set VGC gain for both chains of MT7620
Date:   Sun,  9 Oct 2022 18:07:41 -0400
Message-Id: <20221009220754.1214186-64-sashal@kernel.org>
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

[ Upstream commit 0e09768c085709e10ece3b68f6ac921d3f6a9caa ]

Set bbp66 for all chains of the MT7620.

Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/29e161397e5c9d9399da0fe87d44458aa2b90a78.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5e7bca935dd4..fec85db7dbc7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5645,7 +5645,8 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
 	if (qual->vgc_level != vgc_level) {
 		if (rt2x00_rt(rt2x00dev, RT3572) ||
 		    rt2x00_rt(rt2x00dev, RT3593) ||
-		    rt2x00_rt(rt2x00dev, RT3883)) {
+		    rt2x00_rt(rt2x00dev, RT3883) ||
+		    rt2x00_rt(rt2x00dev, RT6352)) {
 			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66,
 						       vgc_level);
 		} else if (rt2x00_rt(rt2x00dev, RT5592)) {
-- 
2.35.1

