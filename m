Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2518E421E9F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhJEGFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:05:50 -0400
Received: from mout.perfora.net ([74.208.4.196]:36155 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230403AbhJEGFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:05:48 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M7ZMv-1mkvNk3rGx-00xLUA;
 Tue, 05 Oct 2021 08:03:48 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v1 2/4] ARM: mvebu_v7_defconfig: enable mtd physmap
Date:   Tue,  5 Oct 2021 08:03:32 +0200
Message-Id: <20211005060334.203818-3-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211005060334.203818-1-marcel@ziswiler.com>
References: <20211005060334.203818-1-marcel@ziswiler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:UQgW7rn+FLVzVxnPlTkTzwySuz1L5BVoMSP1hsYgZf1pHgpuDZn
 bWDVCkWotbFcvzgdgixJbPcPuIKy6QPnvDnimHm3s4XSltrS44WQrnH/DrZ+waFX7RD+5v2
 aVtxlZZ0BZUipwDdQ4y08oPj6E25OyBnnOTNAfJI1M+U2h3v+mYhZ89TAz9DaFSjIqviBUL
 j52Te8mgXiIrz0d4xEUyA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qagffJlrOwk=:B2R2yWyNhI1KoQJrTKpduZ
 dP8hpTFfoxYMaKZ377cpIHJkEQO0kcASyMxSYghv3akKkMeIMzSru9kj3SKU6i0hZchdWC7cI
 L7CJvqT9C1YkAkPUu3Koqs3PBoZ1SwUkUVLM6nm4r/zitcgpvWrXpgJknZOep2FieGlHEhUVI
 cVhYLvsa2cXjs31zJguYJeXRsYAbbGC8Htqqm2LQvBV7anMiJo2SDeRYg1uHDZfeJMScQMwAE
 NhLRMTnYFr6ANKjSR3Z+kTXbbaA+rNiqupwjLMSHUZFV4gbB6MDuxqHev/0nXAghlxfbEYb2N
 z/k1hh8+eJGVIB9zmixBTGPsqL+7mCJyUp3Op4qn2Ko9cfJGdfbdpNXWx1FikAs5WyzVbbkix
 lhvcAGKjyZwwMk3+6Dv1giqowrMNpZXrjxKMdHbnw11/a5DZonxqByqXIbc0cO5Sl5ZMuimD1
 jUSep1GMP+rvii2IJ8VsfysO40O/oYZmPF3bvQe3QaszkOBs9D3jabcGioHkKQ0i2oXcQCaqJ
 DqBN7tQPEg1jTA/RKj/FqU9aTMM6+iFSQHRoJTRg6XYeUd3jPJLasmpUHaHWWgrcA9TKq52q+
 1Cs6XKQzxKNJDO87R+RVhBISI3ntu1Kqgu3OiZ5eCF18twoDba/S7mCg7w1uzyzQVcsOBx7Qd
 J22ue2NdEAwprWxey2macl4AxD1NNdtB3Ezeoh2U39VS+W4u3tAlKHVbyuZPMsLOh2Wnujgbr
 U1LEv3FgwOifTuOy2KbGFFP1N9gulVhnnMSvJw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable CONFIG_MTD_PHYSMAP which is nowadays required for
CONFIG_MTD_PHYSMAP_OF.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
---

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

