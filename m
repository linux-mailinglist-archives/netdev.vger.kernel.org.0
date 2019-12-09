Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38FA117007
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLIPNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:13:12 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:43849 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfLIPNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:13:11 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M42fG-1ieKid0LRY-000151; Mon, 09 Dec 2019 16:13:03 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] [net-next] wan: remove stale Kconfig entries
Date:   Mon,  9 Dec 2019 16:12:53 +0100
Message-Id: <20191209151256.2497534-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CkrStfIYTzF8e0ZsmC4BTh+wVolul/QnLLzXa343jmnTeqwbqXb
 LsR93n5bWNb02++P6oufU6SKVuU5KdLPlFk+yzjXmriasdpR0ZgMaS9T8iFXzhooaEPI5Lq
 kRJOXUmecRs60oPAGVp4YirW5D5iMLEUdLKey9SWT/TK0HdtUrzvLPtu+VIjpPmrRbdWYsM
 LXf0J0p37numsUlcpjfZA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tAUF8ezFrwI=:bl56+izRKy+3f9CTteVDbv
 HtyUE+9Ku643CIb7YkbgurYRC5w2Nq+MbUAU96hvigGUtORIbErK3U+KpWrzyBrTTNrxMQC8v
 XDoJ4j1ZNwzq/G9SDLW2FfoiJDwnlMNFgkD18aGCNp6xG0MV6geCMVQcaskTiSGj9qe31LGCz
 X/x9V0BvlvakhqM5/Q6C5mnO3uDJMwBRGhlAZ1YsTowqJ8axPHwnLMNBWtmBrmpG+7it3zIjf
 8ZuXQRKC84p/QRgxfGDdlY0aKBwzv9wO8hYEK93YPwdAwu4R3t8SiMgV5y0heUNprmDkKS7Hx
 RevH18Yo4NvCUD30pZXkGnOGFg7MTUEz89Hh9NxxAAat3MUTayvHZj6Kau44stcVK6LdrFYoX
 z3gSInuJUfrHeLqTAU7dxU0cnCtgRpmRqUUacBFXrod10VqBITm2kxLUUsVaWxkU0NbdmcSaS
 f304SV4RAp4R6ayIs1Yu5NgxXLkdSGLnukfnvamEMcOcicKioUT3l/zEvL2+hoeUxCtrrgXI+
 sGZmz11d2tBX9cqVyV3eso9Wi0nwOVAGgFpjcDidcgZHk0Ro1eEFlX4oHXJ5Y1/nYi16qOoIm
 66gu0XQeOVj4Ww81PzHlYflK5jrNyeggbyNndU8FZ1MvDVSJQjVRY5z+igAIMLXlfCy2kt5D3
 7HhmxVaXXV5sFZqeOtdUAZNkQYH6XljAtg8vu9TjtakK/LHIzgsAJeQsonOOHt8T7Wze6jMKU
 wjy2OOjYLaapoVR9TqzJt31hGXaXq4IKD5vLlEZHsggwwDe8pj5PN3z2Q2uKwyV4Z3Iq3lDHE
 3cYl+SbLn+kOYCW+E+8SWkrvJRFJoKxIKa8FNhwVNwbc7P0Dy2ntQVi7AFp7F7hLHFrkRbnXY
 GyoUWUZslReNdef1A0IQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dscc4 driver was recently removed, but these
Kconfig entries remain, so remove them as well.

Fixes: 28c9eb9042a9 ("net/wan: dscc4: remove broken dscc4 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/Kconfig | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index bf2fe1d602ea..59b25d7e13e8 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -289,30 +289,6 @@ config SLIC_DS26522
 	  To compile this driver as a module, choose M here: the
 	  module will be called slic_ds26522.
 
-config DSCC4_PCISYNC
-	bool "Etinc PCISYNC features"
-	depends on DSCC4
-	help
-	  Due to Etinc's design choice for its PCISYNC cards, some operations
-	  are only allowed on specific ports of the DSCC4. This option is the
-	  only way for the driver to know that it shouldn't return a success
-	  code for these operations.
-
-	  Please say Y if your card is an Etinc's PCISYNC.
-
-config DSCC4_PCI_RST
-	bool "Hard reset support"
-	depends on DSCC4
-	help
-	  Various DSCC4 bugs forbid any reliable software reset of the ASIC.
-	  As a replacement, some vendors provide a way to assert the PCI #RST
-	  pin of DSCC4 through the GPIO port of the card. If you choose Y,
-	  the driver will make use of this feature before module removal
-	  (i.e. rmmod). The feature is known to be available on Commtech's
-	  cards. Contact your manufacturer for details.
-
-	  Say Y if your card supports this feature.
-
 config IXP4XX_HSS
 	tristate "Intel IXP4xx HSS (synchronous serial port) support"
 	depends on HDLC && IXP4XX_NPE && IXP4XX_QMGR
-- 
2.20.0

