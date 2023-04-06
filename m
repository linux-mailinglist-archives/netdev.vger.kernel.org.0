Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFD26D9A96
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbjDFOiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbjDFOid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:38:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87284CC10;
        Thu,  6 Apr 2023 07:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCCE06478C;
        Thu,  6 Apr 2023 14:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A63C4339C;
        Thu,  6 Apr 2023 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680791494;
        bh=fS1epBKc6/LIuAlKccrK1+yZRgDIBGUB741ssPvpdOQ=;
        h=Date:From:To:Cc:Subject:From;
        b=SjiLsj18bWuofLs6hhWeLC/lLw/a3iNtZ9wlEueFZEmCpkNlYBNfrW2g/JfGJHGTi
         vet9hVGN3GV90yUx+3gAa/XNftBN0j39XOMRCSz2X9AIryTOjRKZkau8WazkdAVbKe
         7jo/OiVuhS8JxGUofx57NN8frKBM2tj4fn33MN5OokPIYjhPFpYfjxIVlje0uFnNYq
         o+keawWHSe/sdTrcyzxIyVKkwcke3vee+fUSrJSER8RnbtzoGn6X9DOk/pfIaR/jlM
         ZoF5CIu1w4YilJ9YwXKoTj0fnpznmfu4LCYmI1CVH3mBWnGcBheecAhLYWYKRmVcUM
         1CooyEc8vqBvg==
Date:   Thu, 6 Apr 2023 08:32:12 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: mt76: Replace zero-length array with
 flexible-array member
Message-ID: <ZC7X7KCb+JEkPe5D@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays are deprecated [1] and have to be replaced by C99
flexible-array members.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
on memcpy() and help to make progress towards globally enabling
-fstrict-flex-arrays=3 [2]

Link: https://github.com/KSPP/linux/issues/78 [1]
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index a5e6ee4daf92..9bf4b4199ee3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -127,7 +127,7 @@ struct mt76_connac2_mcu_rxd {
 	u8 rsv1[2];
 	u8 s2d_index;
 
-	u8 tlv[0];
+	u8 tlv[];
 };
 
 struct mt76_connac2_patch_hdr {
-- 
2.34.1

