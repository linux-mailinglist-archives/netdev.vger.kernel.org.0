Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABFF58E3CC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 01:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiHIXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 19:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiHIXis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 19:38:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6925C7FE43
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 16:38:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0567C611EC
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 23:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C8CC433D6;
        Tue,  9 Aug 2022 23:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660088327;
        bh=hmSZ1mTbFEIjIbkim3gLt2QDIdCoqDesAV1Eg6+232k=;
        h=From:To:Cc:Subject:Date:From;
        b=rEOHhdy+GgRrkHW0af3IWRbUH3urmSNyynE/svu0/cAiRiSqe1B+U6i8puB313EXP
         aSuROIK0njEqEYTkb7r3Vw1WOwDUbsWqh1sA+dllbwvQmeUU7wlqp1RkgDOxUJYmEY
         u26GMC/KOXizQNae40/QIDsoVwRyThLvf8GidajERg+oEmKpVWFF44fUr3j1ovfTc8
         wVio1gl9hwtE5KCkDbDjwiYcH7q4Cbh0pit8FMEBEUklKkMIb93VGg2n6aH/HJMht5
         5ErPfolND/pTVLlmy0HqM80Z2toA2gjVIY/E2iUWi7WJZFG17YgZPV7fqcfND18EUm
         +V13zSnQvcydQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: use my korg address for mt7601u
Date:   Tue,  9 Aug 2022 16:38:43 -0700
Message-Id: <20220809233843.408004-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change my address for mt7601u to the main one.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b69b427ad2df..eef48858fc7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12744,7 +12744,7 @@ F:	Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
 F:	drivers/net/wireless/mediatek/mt76/
 
 MEDIATEK MT7601U WIRELESS LAN DRIVER
-M:	Jakub Kicinski <kubakici@wp.pl>
+M:	Jakub Kicinski <kuba@kernel.org>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/mediatek/mt7601u/
-- 
2.37.1

