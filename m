Return-Path: <netdev+bounces-2812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9305B704139
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 00:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28232281171
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342CF19E54;
	Mon, 15 May 2023 22:59:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247DC2FB2
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:59:05 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C6ED851;
	Mon, 15 May 2023 15:59:02 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1pyh9V-0001yf-3C;
	Mon, 15 May 2023 22:58:50 +0000
Date: Tue, 16 May 2023 00:56:53 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt7601u: update firmware path
Message-ID: <fefcbf36f13873ae0d97438a0156b87e7e1ae64e.1684191377.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

mt7601u.bin was moved to mediatek/ folder in linux-wireless via commit
8451c2b1 ("mt76xx: Move the old Mediatek WiFi firmware to mediatek")
and linux-firmware release 20230515.

Update the firmware path requested by the mt7601u driver to follow up
with the move of the file.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/mediatek/mt7601u/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.h b/drivers/net/wireless/mediatek/mt7601u/usb.h
index 9fdf35970339..66481b7e3252 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.h
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.h
@@ -8,7 +8,7 @@
 
 #include "mt7601u.h"
 
-#define MT7601U_FIRMWARE	"mt7601u.bin"
+#define MT7601U_FIRMWARE	"mediatek/mt7601u.bin"
 
 #define MT_VEND_REQ_MAX_RETRY	10
 #define MT_VEND_REQ_TOUT_MS	300

base-commit: 0d9b41daa5907756a31772d8af8ac5ff25cf17c1
-- 
2.40.1


