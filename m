Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6D5F9268
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbiJIWtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiJIWrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:47:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8083345054;
        Sun,  9 Oct 2022 15:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A28F3B80DE0;
        Sun,  9 Oct 2022 22:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC00FC433D7;
        Sun,  9 Oct 2022 22:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354249;
        bh=4tiZo8G5eXP4COk8VAfglXey3elPrZGGdqNUfwvzuq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzAVYb4+AYKaMm35vxXmGvKOKRO1om1zg7dUiSdne1uDjHH4OUo/tDHFoQC0gi7of
         cKXbHFXPxXBX5EXEKXk2lGXcHMBZH3XgAT6FAmtlVvLMJKstPsyyrG0ERiMIqI4J84
         LQw4SsHvwnPHkJCH0GP1rQOM0zq51ZsYUnYXLPhULViyPehAZR3SnDFbb4eh85zHRa
         KBjEgSS8c5CdCxIZ+5wrj6JveZkqkNWl2iHJBP6jL3GaWL469KVS1SoJNdzdD82sJX
         cbzS8bbwCQgtRzd9Zt7d94jcMfWhr0z5YQ09IPzuRfYGF+tb/6V8AaVW9FDTj86xyY
         n/iU+VfFMUkFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/29] wifi: rt2x00: set VGC gain for both chains of MT7620
Date:   Sun,  9 Oct 2022 18:22:58 -0400
Message-Id: <20221009222304.1218873-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
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
index 20491ff6bb76..ab0d673253f0 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5629,7 +5629,8 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
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

