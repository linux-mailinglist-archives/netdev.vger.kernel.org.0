Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4421A2A69
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgDHU2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:28:14 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:47637 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgDHU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:27:48 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MlwO3-1ivhhR25Ex-00j4la; Wed, 08 Apr 2020 22:27:22 +0200
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
Subject: [RFC 6/6] drm/rcar-du: fix lvds dependency
Date:   Wed,  8 Apr 2020 22:27:11 +0200
Message-Id: <20200408202711.1198966-7-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408202711.1198966-1-arnd@arndb.de>
References: <20200408202711.1198966-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:6joVxabJuDS2zN5PignIP9zyZK531/9BWLW8G6Y1kfoxuD26fpJ
 e9TjrS9eT9Ko/YwofV0uvqlzR39kV/5clC3e1cU1XtH9XiRMdS8pY8+PMidq93htFsYtGB+
 2rST/EfwV6XIEX89jrfzlrw1uiIeJ/U9vaNXBxNHd+ymwIvLks+L+zpkB/LFrnUO/RGvcku
 XhWxpOHWmXxopP4MjfpIw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V6Hg3hzNJgA=:jAW5mLgmVYFGsGDyp6JaXk
 Dlvd8CjREs2fojxU42iMYR3PHdV6NrT/CljWmBlPWkxQycRnbtkItT3lT8Odd6ggW9Uhfur5+
 4p1NaqMhG5UaFssj7+7RXYybsDS76nscqwnfSbHXrkweinjBnCc1pDvPFCEbA1A1uZrVJQRAT
 8IVxJk3frSPEODrMbDQ274Be//Ts5uVyiCNxRBAJzr35tO7HjuVN/YrOBhltazb5s/yD3+0Nu
 l+sY7m/m/GeCFgo4cwB3ibxhAzKW7WbXb4pAEITob4YbtEIxThVNhk4xlmhG5iFmH9qa0+9mk
 aWUDtLw+WN61FFGI5xT11PttDQHEFXL1momPLde43hFjHoC9XIObYaCjB9nGTEYpgsJwf2SPM
 RjdEuKC4Ld8pz/nJpsBluuGGkDVPzEiY91VDKxaN3l4uEiC4HHlaH29yh34+ANrRXwralZLmk
 7VtvAFvWjBrJUVLLbOgvOIQLZL+viu0bdJV2Xww5hjkbgefEGsEW0CijQ2v3qfeRUyZELKGHi
 3v8m3T83iUoZy8w4aKYoE8sPDzVhGOq/2FU6MVyyUMxAt1cbmMEhBJUl6SECbms/dR4kHOlhm
 jROLQPSHz52dxAsQHe9UKWPbn2PKDFiQ3gfcc7R0gXy22Ja46N0wWx0j6bGibiGYkbI9uLv6v
 F7KPxMoRJYjPHwTvdMOBc4qi1PLZwRUmXJ6eP0B1Yk4mTj9ORNrtvkxb2+y7GDHfvljYoufCk
 EiFB/wrLOG5bJPih2rNCsRbu4kYaFl8VnEW1ZuefobXZELHLEqUhKNzJyaktefLCrHSEd7bLY
 CPvoocEN7msNixrDQ9qyTSAYQnjNywPI+GL9PHTYP1XbKe0Ams=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_enable':
rcar_du_crtc.c:(.text+0xad4): undefined reference to `rcar_lvds_clk_enable'
arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_disable':
rcar_du_crtc.c:(.text+0xd7c): undefined reference to `rcar_lvds_clk_disable'
arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_drv.o: in function `rcar_du_init':
rcar_du_drv.c:(.init.text+0x4): undefined reference to `rcar_du_of_init'
arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_encoder.o: in function `rcar_du_encoder_init':
rcar_du_encoder.c:(.text+0x7a): undefined reference to `rcar_lvds_dual_link'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/rcar-du/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index 5e35f5934d62..4bb879f02633 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -4,7 +4,6 @@ config DRM_RCAR_DU
 	depends on DRM && OF
 	depends on ARM || ARM64
 	depends on ARCH_RENESAS || COMPILE_TEST
-	imply DRM_RCAR_LVDS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
@@ -27,7 +26,7 @@ config DRM_RCAR_DW_HDMI
 	  Enable support for R-Car Gen3 internal HDMI encoder.
 
 config DRM_RCAR_LVDS
-	tristate "R-Car DU LVDS Encoder Support"
+	def_tristate DRM_RCAR_DU
 	depends on DRM && DRM_BRIDGE && OF
 	select DRM_PANEL
 	select OF_FLATTREE
-- 
2.26.0

