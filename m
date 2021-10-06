Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF39B423805
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237226AbhJFGff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:35:35 -0400
Received: from mout.perfora.net ([74.208.4.197]:56627 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhJFGff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 02:35:35 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1McYbJ-1n3mPF0XfR-00cuvZ;
 Wed, 06 Oct 2021 08:33:28 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 1/3] ARM: mvebu_v7_defconfig: enable mtd physmap
Date:   Wed,  6 Oct 2021 08:33:19 +0200
Message-Id: <20211006063321.351882-2-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211006063321.351882-1-marcel@ziswiler.com>
References: <20211006063321.351882-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:aAgQVOnduZrnHN4Aq4qiP9Ody4gZDxwHpipogJ4hPaN+JXGuuVu
 1rvTb9ZADs8NAnPb3fWjZRzC8b0i5+JoA2FjiqZXSyofm1yjR8eLadrpdo809ihd/WpXB6C
 Kw5q5dxeYlsl+Ji10H8f+OaeBS6zTjIG+gR/iZ6yy0O6uz4QVQxNQeHC6y1baG5UrNGdVB/
 /pMqlmbM5wzqp2c2O4emA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LCiY+78POC8=:vSFFLDVfrK1jv0jMHAId2O
 lWcletuIPIJDlqgGKOqvVKqwcQ/Iq0qS635RPH4XNweGFP1ITPuRylXjYUnm/rfZW2iIESfy5
 P0N77Z3n7LVip0iIEroh2VkEu9ki/ej1nH9ndfkCSTQpOPVqWRGym//kFc2h0AvqgRJE/wu3M
 yA9XeFSZW8TTEg58RhsGIZ5cmBhOpP/JH9s7BrYsDS5uci8HNTOSUi7HClSpX3qwfXy3nZaNV
 LcYEloORT0ux0t3zFV0ic0/mBJTVjYwUmy3QxNUIPGKwf/D9TW1L/QB4a4Y5rySlifBmKETfZ
 cnE/rVf0AALIwxDCniuidSnNE6zmSrbIkQ8Xw/X2IiTGX/SQ+9zflzk9WURn6pFRjQwxC9zwT
 vY9crd0owtJXurxpnlvSC3MOch3ojy+9W823gn3g0SKQHViMrBahy1NMWYnraehURDXFDUPw6
 L+dL+eHoYYSwgQBHqUPGN2/vTl7mwlsPP9VsbxHjDhSxSvsN0GpRiTNSUnRtKypSNguu70d2y
 pykh0ig+bJAPrWXlrwX7k8YiuKhNSJI0QohvWClqYvV/1By17FxaEjgfeXfN4MfcJtka/bUuC
 21t6gIDD5DPIci9RBmzj6/3vaUfU2TKw4aqePY42KvB5VsWkU6HpNt0hAxvqnACJOHrHGxopC
 0+yYObZnKfyTRhyOhumyLU2itiyMUx1tYNXhfSzRu0Q0bTyOtNzwn+0ZN0E7WUR14IBBMX2o6
 XZrE8OPf+sArEe9xXvdfkvvoyPBydSVab3sRZA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable CONFIG_MTD_PHYSMAP which is nowadays required for
CONFIG_MTD_PHYSMAP_OF.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

Changes in v2:
- Add Andrew's reviewed-by tag.

 arch/arm/configs/mvebu_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/mvebu_v7_defconfig b/arch/arm/configs/mvebu_v7_defconfig
index cddce57fe4b9e..5e9a9474c93fb 100644
--- a/arch/arm/configs/mvebu_v7_defconfig
+++ b/arch/arm/configs/mvebu_v7_defconfig
@@ -49,6 +49,7 @@ CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
 CONFIG_MTD_CFI_STAA=y
+CONFIG_MTD_PHYSMAP=y
 CONFIG_MTD_PHYSMAP_OF=y
 CONFIG_MTD_M25P80=y
 CONFIG_MTD_RAW_NAND=y
-- 
2.26.2

