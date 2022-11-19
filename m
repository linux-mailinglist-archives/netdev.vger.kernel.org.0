Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6436311B2
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiKSXFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiKSXFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:05:12 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F12D193C8;
        Sat, 19 Nov 2022 15:05:11 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:05:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899107; x=1669158307;
        bh=qtJUwxO1gU/9fogSlSe7LmUizU2SKQNHgO3ln3wm+PE=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=pSRcJSOlcTylSXarISf52/2BAmUavEpID44NiT/wMnPrAYn3+VBP0sKkLkA9wKzqd
         y9N1Ckan+Hd/mP3sXhritgwwaPVD6jtn+aEeqUXubi6Z6f43iMemZ2a+qLYu8wFYGi
         Y5dbWF3YSDzlhnxRzIiGQWWRcvSaK3uf/7LGOlcq6X+oEiIWM/mPgSScCv19nDtchu
         y5If6PZ5lYfhLEM7Xl/kwGiHWN9BY53dvTU1zKE7gyOAy4UgTI0NK4QKTde6CIiJam
         N4smsEoa/BdSCoji/tjSdksz6HghrKdHHxS0FMGwHs/JnQvHDyNGBvZ0CGv7dF9pJb
         gJgGETOYJrGSA==
To:     linux-kbuild@vger.kernel.org
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] drm/bridge: imx: turn imx8{qm,qxp}-ldb into single-object modules
Message-ID: <20221119225650.1044591-4-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

With the previous fix, these modules are built from a single C file.

Rename the source files so they match the module names.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-and-tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/gpu/drm/bridge/imx/Makefile                           | 4 ----
 drivers/gpu/drm/bridge/imx/{imx8qm-ldb-drv.c =3D> imx8qm-ldb.c} | 0
 .../gpu/drm/bridge/imx/{imx8qxp-ldb-drv.c =3D> imx8qxp-ldb.c}   | 0
 3 files changed, 4 deletions(-)
 rename drivers/gpu/drm/bridge/imx/{imx8qm-ldb-drv.c =3D> imx8qm-ldb.c} (10=
0%)
 rename drivers/gpu/drm/bridge/imx/{imx8qxp-ldb-drv.c =3D> imx8qxp-ldb.c} (=
100%)

diff --git a/drivers/gpu/drm/bridge/imx/Makefile b/drivers/gpu/drm/bridge/i=
mx/Makefile
index 64b93009376a..c102443f7286 100644
--- a/drivers/gpu/drm/bridge/imx/Makefile
+++ b/drivers/gpu/drm/bridge/imx/Makefile
@@ -1,9 +1,5 @@
-imx8qm-ldb-objs :=3D imx8qm-ldb-drv.o
 obj-$(CONFIG_DRM_IMX8QM_LDB) +=3D imx8qm-ldb.o
-
-imx8qxp-ldb-objs :=3D imx8qxp-ldb-drv.o
 obj-$(CONFIG_DRM_IMX8QXP_LDB) +=3D imx8qxp-ldb.o
-
 obj-$(CONFIG_DRM_IMX8QXP_PIXEL_COMBINER) +=3D imx8qxp-pixel-combiner.o
 obj-$(CONFIG_DRM_IMX8QXP_PIXEL_LINK) +=3D imx8qxp-pixel-link.o
 obj-$(CONFIG_DRM_IMX8QXP_PIXEL_LINK_TO_DPI) +=3D imx8qxp-pxl2dpi.o
diff --git a/drivers/gpu/drm/bridge/imx/imx8qm-ldb-drv.c b/drivers/gpu/drm/=
bridge/imx/imx8qm-ldb.c
similarity index 100%
rename from drivers/gpu/drm/bridge/imx/imx8qm-ldb-drv.c
rename to drivers/gpu/drm/bridge/imx/imx8qm-ldb.c
diff --git a/drivers/gpu/drm/bridge/imx/imx8qxp-ldb-drv.c b/drivers/gpu/drm=
/bridge/imx/imx8qxp-ldb.c
similarity index 100%
rename from drivers/gpu/drm/bridge/imx/imx8qxp-ldb-drv.c
rename to drivers/gpu/drm/bridge/imx/imx8qxp-ldb.c
--
2.38.1


