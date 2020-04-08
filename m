Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF2881A2A56
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgDHU1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:27:51 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51203 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730438AbgDHU1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:27:50 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M1HqM-1jJXCV1zju-002p3H; Wed, 08 Apr 2020 22:27:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [RFC 4/6] drm/bridge/sii8620: fix extcon dependency
Date:   Wed,  8 Apr 2020 22:27:09 +0200
Message-Id: <20200408202711.1198966-5-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408202711.1198966-1-arnd@arndb.de>
References: <20200408202711.1198966-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vV8vEqFFzBxDwbCUpevBksXzEnRG+4YylcxGZKW7vX+9eMNUg1m
 GTSrbKOi6FlzzBUHGBDpQR3uJHzbcRVL29ejotroODkZe9OPHSlxi90k/mXcQ4EwBxDqz+S
 fwAOPMaKXUvZqrRoIeRpqd1CCyTHjbL5K4harE/L5KNprHiRjOcSxfYcjG43V5CQGDOrMdP
 0Zvp6NP7uN5f0uBgGxXEA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MptYX3yueAQ=:b885v6hNqw1kQDiue/weO6
 uP+3VRcZwHepB7aNKzqTfmN4RuwxLKcd3Ykn79jFhPBxl2wZfHWApXes3mbeDb/x1w+Vf3eXo
 q9YEc9yKSSVlxROHdqCSWcymhLpZ2EDGCdvQbKoMGTtFXTirZiv2DAe3FnAWFufrzLccql5PD
 EHa10ti3QaaWQoWarrhnR+u9A33uYjAF35zBqi6jQol9OPXkKAlO5yJcEcD0jpkfo6GS81i5y
 kH+gPTPYH30Wr9WocW6L91lXSvOaqKNE3BzcyPFgUPkKZdEFM+dMi8tZl2HxIwzJA1XqcwFfi
 XrfEV0cIYSe2KcZozeoabmYbdGj6q/22WC5AsKTZZgalFOuOBF8wVGKu/2wC6RLZ9COX/CFeu
 6W+gTiE6JSfyRpDVXLFq+HnzULwdyNoAEb9aJf3iXX2AjYYvaqyB/lzs4IWSfLtkGFp9HDRzt
 AqgANzoPqYHUQkhSHCS2jpi3VNEU1z3mj98JfTwXmrM5v9LhzBIuTMdDAgqLXUSCEdq7RhW3T
 XvOf7th7/rXNolz9+AOIiILyM7J3arHbaIfZhe23PnMVjW1r8ySVflQqck+e0e0zycDo0T/Bx
 YtLQLGldhMoefh+6y6apc8rGbDJpRnerakstMgLD3Xg4C3JBpOoFEMmWSTc0KwSjScvTdVbFZ
 N2d5HtbEJry0CQNPtNudp2FRAzOMVvxY6G+Tz19wbIEno35Y6FxB+s2evGed0xWIVvhi7fdjc
 QFRA5cQBDSRwNMPrqLXlIjX5+A+SX8eaXTCT/FampsaxQeRsv7tSnCQm+OMw67CNp7QNJOZOs
 HS8WJIHYn7I0p4NzUPVc9S0+juW29sTv81JFrBTxLetf8xRiNA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using 'imply' does not work here, it still cause the same build
failure:

arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_remove':
sil-sii8620.c:(.text+0x1b8): undefined reference to `extcon_unregister_notifier'
arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_probe':
sil-sii8620.c:(.text+0x27e8): undefined reference to `extcon_find_edev_by_node'
arm-linux-gnueabi-ld: sil-sii8620.c:(.text+0x2870): undefined reference to `extcon_register_notifier'
arm-linux-gnueabi-ld: drivers/gpu/drm/bridge/sil-sii8620.o: in function `sii8620_extcon_work':
sil-sii8620.c:(.text+0x2908): undefined reference to `extcon_get_state'

I tried the usual 'depends on EXTCON || !EXTCON' logic, but that caused
a circular Kconfig dependency. Using IS_REACHABLE() is ugly but works.

Fixes: 7a109673899b ("drm/bridge/sii8620: add Kconfig dependency on extcon")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/bridge/Kconfig       | 1 -
 drivers/gpu/drm/bridge/sil-sii8620.c | 5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index aaed2347ace9..78e5ba06acff 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -90,7 +90,6 @@ config DRM_SIL_SII8620
 	tristate "Silicon Image SII8620 HDMI/MHL bridge"
 	depends on OF
 	select DRM_KMS_HELPER
-	imply EXTCON
 	depends on RC_CORE || !RC_CORE
 	help
 	  Silicon Image SII8620 HDMI/MHL bridge chip driver.
diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
index 92acd336aa89..94b6c38e6855 100644
--- a/drivers/gpu/drm/bridge/sil-sii8620.c
+++ b/drivers/gpu/drm/bridge/sil-sii8620.c
@@ -2330,7 +2330,8 @@ static int sii8620_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
-	ret = sii8620_extcon_init(ctx);
+	if (IS_REACHABLE(CONFIG_EXTCON))
+		ret = sii8620_extcon_init(ctx);
 	if (ret < 0) {
 		dev_err(ctx->dev, "failed to initialize EXTCON\n");
 		return ret;
@@ -2352,7 +2353,7 @@ static int sii8620_remove(struct i2c_client *client)
 {
 	struct sii8620 *ctx = i2c_get_clientdata(client);
 
-	if (ctx->extcon) {
+	if (IS_REACHABLE(CONFIG_EXTCON) && ctx->extcon) {
 		extcon_unregister_notifier(ctx->extcon, EXTCON_DISP_MHL,
 					   &ctx->extcon_nb);
 		flush_work(&ctx->extcon_wq);
-- 
2.26.0

