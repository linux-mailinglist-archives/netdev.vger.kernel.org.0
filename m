Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C94425E53
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhJGU7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:59:22 -0400
Received: from mout.perfora.net ([74.208.4.194]:47211 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233854AbhJGU7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:59:17 -0400
Received: from toolbox.toradex.int ([66.171.181.186]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0MXJY3-1mJxL73oFZ-00WGag;
 Thu, 07 Oct 2021 22:57:09 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v3 1/3] ARM: mvebu_v7_defconfig: enable mtd physmap
Date:   Thu,  7 Oct 2021 22:56:57 +0200
Message-Id: <20211007205659.702842-2-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211007205659.702842-1-marcel@ziswiler.com>
References: <20211007205659.702842-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7J79CBCm4Ub17mvx8y04o+pdYMQXg8VDelEeSJ91wmemrnHs9+s
 lX9AMF9cXhHNeyjr7d/L0o5SdDvRgjs+k2pjQJzLzt7OKD1IreyuvxudY5KRrahr7nfSlGC
 67xvJih5tg2nfJju4GMF43Ke2gXR884/T8D83t5RdlLX9d98qgKMOeJCjhBdaDALgzqthQj
 oxl+zfsLbDb257NwAXjbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7EHC90Wim3g=:eJqeEI8y6qzbTWsD1g/Ju/
 ifD9tj5LvDDNGldy3K7E/sZbA3Ie9vVO3VZU0ADxLjkvSauRP6iYR8LE/RigE565Pb7zREim8
 PI6uob8hJ0O4qDpuNryKYFT23uJrRiyNQ9bZ59MMCo4fYTp7PfnlVcwHzb/3mP/6ZzgwYKpit
 Xh+uwJblcU36JEkPa8aCe5DSRH1A8xybHp6Qa0A6DNinhc11JD5qn8SPyIO69B4nZEnmJZELg
 v4Ent8Ch5QxUcbCYLzJwRu7JDKXfVFM0EDYtuvkdq+ievGBpqfRDVGUjsqmMi6iX6KtSJMrsp
 79zwS7NDFDrGGyFNPTBEw5u0xxVreqgcKRC/XNTaYl/rXLGv9qdXCrtUE0+4kSfv0LdvcWr8Q
 G0G/xbokUB8IVeCTbOx737fk4DGmbuFwU118XS+2+dfQHH/hnwj/uTiUnCSGfccmb8a19qLc6
 41rWnvKshL1jYTYPf6JxWwZe2L4r45W4bIjEjEFMV3BFJEs7tpUH+ivnRKFIWQS1DbAsI9cU+
 AFMO3WpcmaJEKNH7WP0Qf/UK9GrFHkLAoUy8s6yd4xh39CGE9ZyBhfuVihwOZuyb7R6+zcrRf
 AlyEc6UofYhmnMYaOWtOoEhQmn48eUjqkBodSox2IdNG2fU+xXFgrFeqckifpmx0lz5WyRJj4
 +s6o2ENleKpB6ddSsxOJYKl3B9E4F0+iLvttrzBezm7lvRU3im6gLbDkUNkSup8oHrKT/Ujcf
 ZHY27MuLXF37ZnNsEda42EgzHns5U9MJF7W6Ww==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable CONFIG_MTD_PHYSMAP which is nowadays required for
CONFIG_MTD_PHYSMAP_OF.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

---

(no changes since v2)

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

