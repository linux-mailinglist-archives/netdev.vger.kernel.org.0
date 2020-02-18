Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DE0162C35
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBRROv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:14:51 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41620 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgBRRNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:13:30 -0500
Received: by mail-ot1-f65.google.com with SMTP id r27so20205783otc.8;
        Tue, 18 Feb 2020 09:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1u4wUo3NLYAMgXHhQ1JWTN6DImeyb7sdgcLty9LTVA=;
        b=pfon4pEJFXFUO0/WW0e/mDSzqxwQbhkJdAEHT5a7xHkvoi1vlN8kOGS7GIGU829JOD
         +ygDH7eavAPibknYtWBXNd9jH0HwVIj0OyAHtrFUiXi6M0B7xVhslKavM/7uaebmLNOP
         iBSHcoPArr/kMcFRDT3gLBPcK9jqSCPaLMzQbTkcM8xGr1FPJvWGprIF60Q5dB++fMcc
         NaVSCHOxgrenzVyUx1tlr40ZkzHQNdOc6jamdBiMmNYip1kR0bQcpTYxIkbcpcJhWIUd
         kjAw+/zQyUzHoC7kYEBRf7QFNQbVlwIqhtkDt94woigkJhTa97CttC41Z9Brl4zceuTk
         EKHg==
X-Gm-Message-State: APjAAAUlzTSO2PKgoKuxg6frM8ruhq1NOg9pBCr4op2XQ3FY5qfCdHJ0
        Y2ib8BYyVGwd1mWOgM9YYg==
X-Google-Smtp-Source: APXvYqz9vN5O196Hv3RX5j5QhodRWeWR1h2DBkM3xAqkcK92U7nZEFBLzVra3Zyy0nvATVFM6CGklA==
X-Received: by 2002:a9d:7a89:: with SMTP id l9mr15588431otn.228.1582046008709;
        Tue, 18 Feb 2020 09:13:28 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id y25sm1545755oto.27.2020.02.18.09.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:13:28 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 03/11] cpuidle: Remove Calxeda driver
Date:   Tue, 18 Feb 2020 11:13:13 -0600
Message-Id: <20200218171321.30990-4-robh@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218171321.30990-1-robh@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
---
Do not apply yet.

 drivers/cpuidle/Kconfig.arm       |  7 ---
 drivers/cpuidle/Makefile          |  1 -
 drivers/cpuidle/cpuidle-calxeda.c | 72 -------------------------------
 3 files changed, 80 deletions(-)
 delete mode 100644 drivers/cpuidle/cpuidle-calxeda.c

diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index 62272ecfa771..c2830d2ed44a 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -42,13 +42,6 @@ config ARM_CLPS711X_CPUIDLE
 	help
 	  Select this to enable cpuidle on Cirrus Logic CLPS711X SOCs.

-config ARM_HIGHBANK_CPUIDLE
-	bool "CPU Idle Driver for Calxeda processors"
-	depends on ARM_PSCI && !ARM64
-	select ARM_CPU_SUSPEND
-	help
-	  Select this to enable cpuidle on Calxeda processors.
-
 config ARM_KIRKWOOD_CPUIDLE
 	bool "CPU Idle Driver for Marvell Kirkwood SoCs"
 	depends on (MACH_KIRKWOOD || COMPILE_TEST) && !ARM64
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index cc8c769d7fa9..eee5f276edf7 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 obj-$(CONFIG_ARM_MVEBU_V7_CPUIDLE) += cpuidle-mvebu-v7.o
 obj-$(CONFIG_ARM_BIG_LITTLE_CPUIDLE)	+= cpuidle-big_little.o
 obj-$(CONFIG_ARM_CLPS711X_CPUIDLE)	+= cpuidle-clps711x.o
-obj-$(CONFIG_ARM_HIGHBANK_CPUIDLE)	+= cpuidle-calxeda.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUIDLE)	+= cpuidle-kirkwood.o
 obj-$(CONFIG_ARM_ZYNQ_CPUIDLE)		+= cpuidle-zynq.o
 obj-$(CONFIG_ARM_U8500_CPUIDLE)         += cpuidle-ux500.o
diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
deleted file mode 100644
index b17d9a8418b0..000000000000
--- a/drivers/cpuidle/cpuidle-calxeda.c
+++ /dev/null
@@ -1,72 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Copyright 2012 Calxeda, Inc.
- *
- * Based on arch/arm/plat-mxc/cpuidle.c: #v3.7
- * Copyright 2012 Freescale Semiconductor, Inc.
- * Copyright 2012 Linaro Ltd.
- *
- * Maintainer: Rob Herring <rob.herring@calxeda.com>
- */
-
-#include <linux/cpuidle.h>
-#include <linux/cpu_pm.h>
-#include <linux/init.h>
-#include <linux/mm.h>
-#include <linux/platform_device.h>
-#include <linux/psci.h>
-
-#include <asm/cpuidle.h>
-#include <asm/suspend.h>
-
-#include <uapi/linux/psci.h>
-
-#define CALXEDA_IDLE_PARAM \
-	((0 << PSCI_0_2_POWER_STATE_ID_SHIFT) | \
-	 (0 << PSCI_0_2_POWER_STATE_AFFL_SHIFT) | \
-	 (PSCI_POWER_STATE_TYPE_POWER_DOWN << PSCI_0_2_POWER_STATE_TYPE_SHIFT))
-
-static int calxeda_idle_finish(unsigned long val)
-{
-	return psci_ops.cpu_suspend(CALXEDA_IDLE_PARAM, __pa(cpu_resume));
-}
-
-static int calxeda_pwrdown_idle(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv,
-				int index)
-{
-	cpu_pm_enter();
-	cpu_suspend(0, calxeda_idle_finish);
-	cpu_pm_exit();
-
-	return index;
-}
-
-static struct cpuidle_driver calxeda_idle_driver = {
-	.name = "calxeda_idle",
-	.states = {
-		ARM_CPUIDLE_WFI_STATE,
-		{
-			.name = "PG",
-			.desc = "Power Gate",
-			.exit_latency = 30,
-			.power_usage = 50,
-			.target_residency = 200,
-			.enter = calxeda_pwrdown_idle,
-		},
-	},
-	.state_count = 2,
-};
-
-static int calxeda_cpuidle_probe(struct platform_device *pdev)
-{
-	return cpuidle_register(&calxeda_idle_driver, NULL);
-}
-
-static struct platform_driver calxeda_cpuidle_plat_driver = {
-        .driver = {
-                .name = "cpuidle-calxeda",
-        },
-        .probe = calxeda_cpuidle_probe,
-};
-builtin_platform_driver(calxeda_cpuidle_plat_driver);
--
2.20.1
