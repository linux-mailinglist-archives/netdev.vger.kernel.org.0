Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB7F61DF25
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiKEWhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 18:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiKEWhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 18:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AD613E1C;
        Sat,  5 Nov 2022 15:37:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0C060B9E;
        Sat,  5 Nov 2022 22:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B3FC433C1;
        Sat,  5 Nov 2022 22:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667687823;
        bh=aekRNA0fmpdgo5jsqTiIl1w1VyTVSk/fDt6LH0NC+Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+EQiRh8VqWSAoT55EMiJO9TWGVIgkdg6T0N3K2j+9q6Z3pGBHyce41qCAWnbngf7
         vC3upkSEoU9D6Ja5wrpwSZOz/seUi26rdDLyc6UL6Ip5Tlxv0TIzeHnuKX8B1gE16U
         KWk5GKr9nJu/bXRFHo9BrUwXLacPfTC6D6F05H6t1iVZbilGhYOvJIqQ/vuOTwr126
         /Sc9OSdnrx13b/8w9RuR2lPe2LSwkyrZYhyhk9J4w1mywZeEkYMSDGR2PDjYyV1oDb
         iQ+MiipgLF06b9q+sJBeOExWp2i/29zIxMYYnkW0B94FvH5IzMlZcs2tZIANHkvJAl
         EUpXxR06kFwtA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
Subject: [PATCH v4 net-next 8/8] MAINTAINERS: update MEDIATEK ETHERNET entry
Date:   Sat,  5 Nov 2022 23:36:23 +0100
Message-Id: <d9d798bad6835d031ca0135ee29469c44ba73bf0.1667687249.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667687249.git.lorenzo@kernel.org>
References: <cover.1667687249.git.lorenzo@kernel.org>
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
index 95fc5e1b4548..51be68e90f6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12925,6 +12925,7 @@ M:	Felix Fietkau <nbd@nbd.name>
 M:	John Crispin <john@phrozen.org>
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Mark Lee <Mark-MC.Lee@mediatek.com>
+M:	Lorenzo Bianconi <lorenzo@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/mediatek/
-- 
2.38.1

