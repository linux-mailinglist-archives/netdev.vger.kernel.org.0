Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554F36D1A1C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjCaIfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjCaIey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:34:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CD11A958
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e18so21583268wra.9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680251688;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pBKae7BMPgaOyblPkQRvXj+9HjHU1CqOuh/rr5LEg2Q=;
        b=AquKoo9qW/lfM7z5iGn0k1Tc7+InMtW/5I6poWfwMsS88rqwzcB/MQ5kQQkBmo0c+b
         wkPla8Y4iET1Fj1kYLGVvqL3TbQE5Apoq4NMq78ewldGH0tjQxzMsVvH0CaCS4Y6uqnv
         pY+ExvjAhRa2o6Pkj49iMnNTlwh7XB3eJBYOQxW0b+8uYOvQR07pIP8luJahBAMFvTsF
         MUHny+htmLQwlY75XWau9Nl26sOWJCwBOgey3Je21g/ZuzVtSxxf4tyZwaiCFE8HSXjv
         L0+H3MXP452/QuAU/yPxyU7guxH/89cFsr+rWPf2/IbC+Os88HkTCg6GaHsRIXEbuXRJ
         LEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680251688;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBKae7BMPgaOyblPkQRvXj+9HjHU1CqOuh/rr5LEg2Q=;
        b=Gahz9W9cIGlUUGTIKmu1WTJukDSOOwoNLET0rEAR0QzS0VbnSWbftvGhTMhkJYSqtj
         /PwnMeGHSi9h635i4ByXy/xq7334sDxkgsPIn2RBF1zjFec/NBBHF3K8X2pJUFA8LQcm
         czIkoGiuJDAnNupWaOzjLsrpNpT9Iw72SBhz6bL7vutL5QOjieaS5lfGw8miV5TVvEKc
         Ha+8vudJzOBrl3FxBZMvlluqN1ieoGOnj6r8ndHTFtAWtvZJQjQrfjsNrRUWMIYt1QFM
         s0QkTJPUn/hqPw0WBbU2tj2rmLRaBVV1uX8Q1orHPQ/Q4gcWlkh4b98+eJROAGw+Fmrk
         moyw==
X-Gm-Message-State: AAQBX9eVLRXvG6Bk4JcRruz36RyBeHuztwTYBbLPaMtuHrDQGKpclBks
        bbcB6s/KgcwRe4T+EiUv+MA8fg==
X-Google-Smtp-Source: AKy350aDqfbCwPtTrIaC1JmenS2NwBF1wy4mk9PU9AEFWXM6fMqoAjRCp4Qk1EV//Q894bPDiUkCGg==
X-Received: by 2002:adf:f089:0:b0:2cf:e849:e13c with SMTP id n9-20020adff089000000b002cfe849e13cmr20185096wro.61.1680251688308;
        Fri, 31 Mar 2023 01:34:48 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d4e8b000000b002cde626cd96sm1563153wru.65.2023.03.31.01.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:34:48 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Fri, 31 Mar 2023 10:34:41 +0200
Subject: [PATCH RFC 03/20] ARM: configs: remove oxnas_v6_defconfig
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-topic-oxnas-upstream-remove-v1-3-5bd58fd1dd1f@linaro.org>
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to lack of maintainance and stall of development for a few years now,
and since no new features will ever be added upstream, remove support
for OX820 specific defconfig.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 arch/arm/configs/oxnas_v6_defconfig | 92 -------------------------------------
 1 file changed, 92 deletions(-)

diff --git a/arch/arm/configs/oxnas_v6_defconfig b/arch/arm/configs/oxnas_v6_defconfig
deleted file mode 100644
index 70a67b3fc91b..000000000000
--- a/arch/arm/configs/oxnas_v6_defconfig
+++ /dev/null
@@ -1,92 +0,0 @@
-CONFIG_SYSVIPC=y
-CONFIG_NO_HZ_IDLE=y
-CONFIG_HIGH_RES_TIMERS=y
-CONFIG_CGROUPS=y
-CONFIG_BLK_DEV_INITRD=y
-CONFIG_EMBEDDED=y
-CONFIG_PERF_EVENTS=y
-CONFIG_STRICT_KERNEL_RWX=y
-CONFIG_STRICT_MODULE_RWX=y
-CONFIG_ARCH_MULTI_V6=y
-CONFIG_ARCH_OXNAS=y
-CONFIG_MACH_OX820=y
-CONFIG_SMP=y
-CONFIG_NR_CPUS=16
-CONFIG_ARCH_FORCE_MAX_ORDER=12
-CONFIG_SECCOMP=y
-CONFIG_ARM_APPENDED_DTB=y
-CONFIG_ARM_ATAG_DTB_COMPAT=y
-CONFIG_KEXEC=y
-CONFIG_EFI=y
-CONFIG_CPU_IDLE=y
-CONFIG_ARM_CPUIDLE=y
-CONFIG_VFP=y
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_CMDLINE_PARTITION=y
-CONFIG_CMA=y
-CONFIG_NET=y
-CONFIG_PACKET=y
-CONFIG_UNIX=y
-CONFIG_INET=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-CONFIG_IP_PNP_BOOTP=y
-CONFIG_IP_PNP_RARP=y
-CONFIG_IPV6_ROUTER_PREF=y
-CONFIG_IPV6_OPTIMISTIC_DAD=y
-CONFIG_INET6_AH=m
-CONFIG_INET6_ESP=m
-CONFIG_INET6_IPCOMP=m
-CONFIG_IPV6_MIP6=m
-CONFIG_IPV6_TUNNEL=m
-CONFIG_IPV6_MULTIPLE_TABLES=y
-CONFIG_DEVTMPFS=y
-CONFIG_DEVTMPFS_MOUNT=y
-CONFIG_MTD=y
-CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_BLOCK=y
-CONFIG_MTD_RAW_NAND=y
-CONFIG_MTD_NAND_OXNAS=y
-CONFIG_MTD_UBI=y
-CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=65536
-CONFIG_NETDEVICES=y
-CONFIG_STMMAC_ETH=y
-CONFIG_REALTEK_PHY=y
-CONFIG_INPUT_EVDEV=y
-CONFIG_SERIAL_8250=y
-CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_SERIAL_OF_PLATFORM=y
-CONFIG_GPIO_GENERIC_PLATFORM=y
-CONFIG_NEW_LEDS=y
-CONFIG_LEDS_CLASS=y
-CONFIG_LEDS_CLASS_FLASH=m
-CONFIG_LEDS_GPIO=y
-CONFIG_LEDS_TRIGGERS=y
-CONFIG_LEDS_TRIGGER_TIMER=y
-CONFIG_LEDS_TRIGGER_ONESHOT=y
-CONFIG_LEDS_TRIGGER_HEARTBEAT=y
-CONFIG_LEDS_TRIGGER_CPU=y
-CONFIG_LEDS_TRIGGER_GPIO=y
-CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
-CONFIG_ARM_TIMER_SP804=y
-CONFIG_EXT4_FS=y
-CONFIG_MSDOS_FS=y
-CONFIG_VFAT_FS=y
-CONFIG_TMPFS=y
-CONFIG_TMPFS_POSIX_ACL=y
-CONFIG_UBIFS_FS=y
-CONFIG_PSTORE=y
-CONFIG_PSTORE_CONSOLE=y
-CONFIG_PSTORE_PMSG=y
-CONFIG_PSTORE_RAM=y
-CONFIG_NLS_CODEPAGE_437=y
-CONFIG_NLS_ISO8859_1=y
-CONFIG_NLS_UTF8=y
-CONFIG_DMA_CMA=y
-CONFIG_CMA_SIZE_MBYTES=64
-CONFIG_PRINTK_TIME=y
-CONFIG_MAGIC_SYSRQ=y

-- 
2.34.1

