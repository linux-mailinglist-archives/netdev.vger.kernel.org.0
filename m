Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CB366F43
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 14:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfGLMyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 08:54:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40935 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727317AbfGLMyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 08:54:13 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190712125410euoutp020b223d4e6eb1da3fe909d4ebd3ca803b~wqg6xegIr2436124361euoutp024
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 12:54:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190712125410euoutp020b223d4e6eb1da3fe909d4ebd3ca803b~wqg6xegIr2436124361euoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562936050;
        bh=SvNBqsasmMJ35pKfe52wEDcdzqVXxeLAO+14YQc5HjA=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=OriKHNe8UYzZneVkTvcpZv+t3OzcXzcmVNnPOI2m7DRKxa2BI4rJQ9sl38PxEHdJ/
         z9ZUHDm9Gl97K7j7IhjMBIn7vpm1JglfjPxOXhi8yL0erVZpWX4HsYsLGXjDGHwgEe
         +UvcA/OMfMSmTdvpJZdW+IbbInAkdpVzA415FVRU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190712125409eucas1p1366c6c3b34756b2e52d0491dc1246412~wqg50NMA31697116971eucas1p1H;
        Fri, 12 Jul 2019 12:54:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D0.42.04325.1F2882D5; Fri, 12
        Jul 2019 13:54:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190712125408eucas1p166fd03846592d11ffbea036072607dc4~wqg4_69BW2455424554eucas1p1g;
        Fri, 12 Jul 2019 12:54:08 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190712125408eusmtrp2e23ca1e107a35086ef09c865cf042369~wqg4wiEm00521605216eusmtrp29;
        Fri, 12 Jul 2019 12:54:08 +0000 (GMT)
X-AuditID: cbfec7f5-fbbf09c0000010e5-ef-5d2882f10e25
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 00.7C.04146.0F2882D5; Fri, 12
        Jul 2019 13:54:08 +0100 (BST)
Received: from [106.120.51.74] (unknown [106.120.51.74]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190712125407eusmtip1755535a5147b6e9225a0e62a4bb7f407~wqg36aWav0388503885eusmtip1e;
        Fri, 12 Jul 2019 12:54:07 +0000 (GMT)
Subject: Re: [PATCH 00/12] treewide: Fix GENMASK misuses
To:     Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Andrew Jeffery <andrew@aj.id.au>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org, linux-media@vger.kernel.org
Cc:     linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
From:   Andrzej Hajda <a.hajda@samsung.com>
Message-ID: <469b0d3d-9466-b287-5ca3-27f3d01ff3cd@samsung.com>
Date:   Fri, 12 Jul 2019 14:54:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
        Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <cover.1562734889.git.joe@perches.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHfXfOzo7a6rjUPVhkza5CmhT1RiEmYQciqC/WEqmVB4vcis1Z
        5gfFe9oNDbVNdIWlmalpq1zOahPtouYtsTJX6gepLEJHqaXtdIz89nv+z+3/vLw0Icui/Ojj
        mnhOq1HFKSgP8n7LZMf676lrozcUji7FxTVVFO7tsomwpYfGRdYPBG5sm5LgXuc3ChsdwyQ2
        GT1x3XCfGKfd7iBwSfNXEvdYiil8vtYsxj1pXQg3z15COKdvRIy/VAxIcIvJF79IHyWx9cld
        EmdO3aTCfNjXWRYJWzueSrGDTXaSNdXp2WdF0yTryG0VsfVlyeyromuInajsI9inTSHseN2y
        vZ4HPbbHcHHHEzhtcOhhj2OPhx3EqdzVZ26V7EpBNv8cRNPAbILyehd60DKmAkHHzCwlBBMI
        hiyPiBzk7grGEVhfB/LMN5g/j0qEonIE6VNFcx1jCB7+zBLxVYsZDGb7R5JPeDM1JAzk5BN8
        QDAFCDqHL/6dSzHr4Hf9G4pnKRMKF57lSXgmmVVgGbGLefZhImHSdG6uxgueXx0heePuzEZo
        cy7nZYLxhzSzkRBYDm9HSkX8LmCaaejLqEKC752Qm/eOFHgxfGq9JxF4Kcw2lIoETgZHRToh
        NGcjMNc2EEJiG9hbu8T8YsJlusYSLMg74O1Tq0h4yIXQP+YleFgIefcLCUGWQnamTKheAY52
        89xAOdzodFKXkcIw7zDDvGsM864x/N9rQmQlknN6nTqW023UcKeDdCq1Tq+JDTp6Ul2HXN/z
        5Uyr8yFq+nXEhhgaKRZI+7euiZaJVQm6RLUNAU0ovKWVsy5JGqNKPMtpTx7S6uM4nQ0toUmF
        XJrk9iFKxsSq4rkTHHeK0/7Limh3vxR0YOX76qmhPb4VsjBlZ1R7bUto150DARJnRPd1ercn
        HPFKqQ7Ux1jRWGjs4KFuL3l/5nSEttnXe8wncrBEtD8lo1eZOGmPLMtvLG9veBBo2qL8QU/8
        XHvFLSY+nKXCjWL1vtJGzUDA5uBFSv8CY9VN/e6LjfiHmyEyVSlJT8pUkLpjqpBAQqtT/QH2
        QnULmgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t/xu7ofmjRiDa4uVrCYs34Nm8WVi4eY
        LHZd5rCYsfcBs8WeM7/YLa58fc9mMfv+YxaLBbO5LTY9vsZq0bz6HLPFvCPvWCwu75rDZtGz
        YSurxeXmi4wWR/73M1p0XXvCavFmxR12i2MLxCxOtbxgsdh7YCOLRduvZWwOoh5X23exe2z4
        3MTmcW/fYRaPBZtKPU7M+M3icb/7OJPH5iX1HudnLGT0+LLqGrPHwX2GHp83yQVwR+nZFOWX
        lqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehl7H98n7mgW61i
        5Tz3BsZD8l2MnBwSAiYSW1+/YO9i5OIQEljKKHHweTcTREJcYvf8t8wQtrDEn2tdbCC2kMBr
        RonZ90xBbGEBC4mthx+ygDSLCKxnkXi3s4cZxGEWmMYoMeX1OSaIsW2MEt1H1rGCtLAJaEr8
        3XwTbBSvgJ1E74lJ7CA2i4CqxK4nh4FqODhEBcIkjp7IgygRlDg58wkLSJhTwFjizFcFkDCz
        gLrEn3mXmCFseYnmrbOhbHGJW0/mM01gFJqFpHsWkpZZSFpmIWlZwMiyilEktbQ4Nz232FCv
        ODG3uDQvXS85P3cTIzBdbDv2c/MOxksbgw8xCnAwKvHw3rBUjxViTSwrrsw9xCjBwawkwrvq
        P1CINyWxsiq1KD++qDQntfgQoynQaxOZpUST84GpLK8k3tDU0NzC0tDc2NzYzEJJnLdD4GCM
        kEB6YklqdmpqQWoRTB8TB6dUA6Ob0u0C22WmNaeeTtq1bteBOQGX5jl2LlJ9vsfuNc+PpSWN
        DG9370iKnTd/97uCkh0rvP7O4U9ht+s2WZ+WFuPVZfJF40+opO0DE5WA5ByBypJfyw7O/mB/
        e6H2IoaZnRYOy3z+v6//2zEl6wjXBZ16dcfumb6NL5PemQo5Bz97Kly2PsT++BMlluKMREMt
        5qLiRAAlheMYLQMAAA==
X-CMS-MailID: 20190712125408eucas1p166fd03846592d11ffbea036072607dc4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190710050444epcas1p250f7aa0f8798a7757df51d66f5970c2a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190710050444epcas1p250f7aa0f8798a7757df51d66f5970c2a
References: <CGME20190710050444epcas1p250f7aa0f8798a7757df51d66f5970c2a@epcas1p2.samsung.com>
        <cover.1562734889.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

On 10.07.2019 07:04, Joe Perches wrote:
> These GENMASK uses are inverted argument order and the
> actual masks produced are incorrect.  Fix them.
>
> Add checkpatch tests to help avoid more misuses too.
>
> Joe Perches (12):
>   checkpatch: Add GENMASK tests
>   clocksource/drivers/npcm: Fix misuse of GENMASK macro
>   drm: aspeed_gfx: Fix misuse of GENMASK macro
>   iio: adc: max9611: Fix misuse of GENMASK macro
>   irqchip/gic-v3-its: Fix misuse of GENMASK macro
>   mmc: meson-mx-sdio: Fix misuse of GENMASK macro
>   net: ethernet: mediatek: Fix misuses of GENMASK macro
>   net: stmmac: Fix misuses of GENMASK macro
>   rtw88: Fix misuse of GENMASK macro
>   phy: amlogic: G12A: Fix misuse of GENMASK macro
>   staging: media: cedrus: Fix misuse of GENMASK macro
>   ASoC: wcd9335: Fix misuse of GENMASK macro
>
>  drivers/clocksource/timer-npcm7xx.c               |  2 +-
>  drivers/gpu/drm/aspeed/aspeed_gfx.h               |  2 +-
>  drivers/iio/adc/max9611.c                         |  2 +-
>  drivers/irqchip/irq-gic-v3-its.c                  |  2 +-
>  drivers/mmc/host/meson-mx-sdio.c                  |  2 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h       |  2 +-
>  drivers/net/ethernet/mediatek/mtk_sgmii.c         |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/descs.h       |  2 +-
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  4 ++--
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c     |  2 +-
>  drivers/phy/amlogic/phy-meson-g12a-usb2.c         |  2 +-
>  drivers/staging/media/sunxi/cedrus/cedrus_regs.h  |  2 +-
>  scripts/checkpatch.pl                             | 15 +++++++++++++++
>  sound/soc/codecs/wcd-clsh-v2.c                    |  2 +-
>  14 files changed, 29 insertions(+), 14 deletions(-)
>
After adding following compile time check:

------

diff --git a/Makefile b/Makefile
index 5102b2bbd224..ac4ea5f443a9 100644
--- a/Makefile
+++ b/Makefile
@@ -457,7 +457,7 @@ KBUILD_AFLAGS   := -D__ASSEMBLY__ -fno-PIE
 KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
                   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
                   -Werror=implicit-function-declaration
-Werror=implicit-int \
-                  -Wno-format-security \
+                  -Wno-format-security -Werror=div-by-zero \
                   -std=gnu89
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_AFLAGS_KERNEL :=
diff --git a/include/linux/bits.h b/include/linux/bits.h
index 669d69441a62..61d74b103055 100644
--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -19,11 +19,11 @@
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #define GENMASK(h, l) \
-       (((~UL(0)) - (UL(1) << (l)) + 1) & \
+       (((~UL(0)) - (UL(1) << (l)) + 1 + 0/((h) >= (l))) & \
         (~UL(0) >> (BITS_PER_LONG - 1 - (h))))
 
 #define GENMASK_ULL(h, l) \
-       (((~ULL(0)) - (ULL(1) << (l)) + 1) & \
+       (((~ULL(0)) - (ULL(1) << (l)) + 1 + 0/((h) >= (l))) & \
         (~ULL(0) >> (BITS_PER_LONG_LONG - 1 - (h))))
 
 #endif /* __LINUX_BITS_H */

-------

I was able to detect one more GENMASK misue (AARCH64, allyesconfig):

  CC      drivers/phy/rockchip/phy-rockchip-inno-hdmi.o
In file included from ../include/linux/bitops.h:5:0,
                 from ../include/linux/kernel.h:12,
                 from ../include/linux/clk.h:13,
                 from ../drivers/phy/rockchip/phy-rockchip-inno-hdmi.c:9:
../drivers/phy/rockchip/phy-rockchip-inno-hdmi.c: In function
‘inno_hdmi_phy_rk3328_power_on’:
../include/linux/bits.h:22:37: error: division by zero [-Werror=div-by-zero]
  (((~UL(0)) - (UL(1) << (l)) + 1 + 0/((h) >= (l))) & \
                                     ^
../drivers/phy/rockchip/phy-rockchip-inno-hdmi.c:24:42: note: in
expansion of macro ‘GENMASK’
 #define UPDATE(x, h, l)  (((x) << (l)) & GENMASK((h), (l)))
                                          ^~~~~~~
../drivers/phy/rockchip/phy-rockchip-inno-hdmi.c:201:50: note: in
expansion of macro ‘UPDATE’
 #define RK3328_TERM_RESISTOR_CALIB_SPEED_7_0(x)  UPDATE(x, 7, 9)
                                                  ^~~~~~
../drivers/phy/rockchip/phy-rockchip-inno-hdmi.c:1046:26: note: in
expansion of macro ‘RK3328_TERM_RESISTOR_CALIB_SPEED_7_0’
   inno_write(inno, 0xc6, RK3328_TERM_RESISTOR_CALIB_SPEED_7_0(v));


Of course I do not advise to add the check as is to Kernel - it is
undefined behavior area AFAIK.


Regards

Andrzej

