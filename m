Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82853F312C
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhHTQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbhHTQIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:08:01 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9477AC061A2B
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:35 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id r6so9982227ilt.13
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=km5HTA1lJ06lwMWe1wHbp9c5fXiwpAFBR0/Mnk2gxRo=;
        b=kgsTgn/GrCesefHsYF+sQoLm3vG0pRckx9pecWzPr6sR0gM52x+NQA0tIVpr4aIHh4
         GYqRf1tVyE2KWCsQnmyF7jahzs5MsWTh5vfUfBZcPhBbtu+NDTh8fj449I4+pK0fhwiV
         NTMDd7Yb0K746VjVjNsK++aCCrajQvFxv58ucazpIpRyCr+Likt7IhUYn5OADgn9VZwS
         xB/asZyOw7TraLjPYdi969KSP0AsxVI80nq8/4SD0gXNEJWSeFHNaRTt9me+gL1L/OGX
         yPG+erJVpTcVG5YVzG7ZFnXhoYQvlDEcJaJorqaULYcaiWGz4S6za53Qhhth+l0XhhR+
         pH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=km5HTA1lJ06lwMWe1wHbp9c5fXiwpAFBR0/Mnk2gxRo=;
        b=OYezlF2DhwsH4gpjmPS7JUGmp9TDQEsrLWJjpXy6v4WAldGsP2Zz3jTSH/ku2rnW+J
         sLg5oHTyfYrwYLHSBjPrV/UkGfdqB5JKEpc/C6xKMFaPl9jjLNqr7FmSysWKui3kiimq
         8Ov3IOPb1YsVZ+8uPZ/h5ZOLxc41kXGWgDtGua6Sb/oWiwxJ8Q5JkJB+gaFkgMkFtnOU
         HmOivkbRr77GoABKgzDagrOtwbHe9NKaX+kt1hTmhBINRLTMSmtE59h+CTYoGJGvhZ63
         1FzWIvo2CxHFtUgRg/XkcGpf8TrxcXPTR23M/YhN+w0RMSVZOGt8Sxjvg4hldrW7drkV
         snmA==
X-Gm-Message-State: AOAM53296e0gicFbFSfACauySvw6kIn3/O5D9GP5T4V2tB/YDifVX44z
        aefRhvq7FrFmTme1xRBOtSye+w==
X-Google-Smtp-Source: ABdhPJzW8IUM7b6uVOAtiaPFS2vuiGXcLYlP9+RSCf6rO8ww1usYCw2+wvVtds5Axz0hM+nlDQV8IA==
X-Received: by 2002:a92:d4d1:: with SMTP id o17mr3368123ilm.43.1629475294670;
        Fri, 20 Aug 2021 09:01:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a8sm3521317ilq.63.2021.08.20.09.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:01:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ipa: rename ipa_clock_* symbols
Date:   Fri, 20 Aug 2021 11:01:28 -0500
Message-Id: <20210820160129.3473253-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210820160129.3473253-1-elder@linaro.org>
References: <20210820160129.3473253-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename a number of functions to clarify that there is no longer a
notion of an "IPA clock," but rather that the functions are more
generally related to IPA power management.

  ipa_clock_enable() -> ipa_power_enable()
  ipa_clock_disable() -> ipa_power_disable()
  ipa_clock_rate() -> ipa_core_clock_rate()
  ipa_clock_init() -> ipa_power_init()
  ipa_clock_exit() -> ipa_power_exit()

Rename the ipa_clock structure to be ipa_power.  Rename all
variables and fields using that structure type "power" rather
than "clock".

Rename the ipa_clock_data structure to be ipa_power_data, and more
broadly, just substitute "power" for "clock" in places that
previously represented things related to the "IPA clock".

Update comments throughout.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h             |  20 ++--
 drivers/net/ipa/ipa_clock.c       | 148 +++++++++++++++---------------
 drivers/net/ipa/ipa_clock.h       |  20 ++--
 drivers/net/ipa/ipa_data-v3.1.c   |   4 +-
 drivers/net/ipa/ipa_data-v3.5.1.c |   4 +-
 drivers/net/ipa/ipa_data-v4.11.c  |   4 +-
 drivers/net/ipa/ipa_data-v4.2.c   |   4 +-
 drivers/net/ipa/ipa_data-v4.5.c   |   4 +-
 drivers/net/ipa/ipa_data-v4.9.c   |   4 +-
 drivers/net/ipa/ipa_data.h        |  10 +-
 drivers/net/ipa/ipa_endpoint.c    |   2 +-
 drivers/net/ipa/ipa_main.c        |  32 +++----
 drivers/net/ipa/ipa_modem.c       |   2 +-
 drivers/net/ipa/ipa_smp2p.c       |  58 ++++++------
 drivers/net/ipa/ipa_smp2p.h       |   2 +-
 drivers/net/ipa/ipa_uc.c          |  16 ++--
 drivers/net/ipa/ipa_uc.h          |  10 +-
 17 files changed, 171 insertions(+), 173 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 34152fe02963d..9fc880eb7e3a6 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -23,7 +23,7 @@ struct icc_path;
 struct net_device;
 struct platform_device;
 
-struct ipa_clock;
+struct ipa_power;
 struct ipa_smp2p;
 struct ipa_interrupt;
 
@@ -36,11 +36,11 @@ struct ipa_interrupt;
  * @nb:			Notifier block used for remoteproc SSR
  * @notifier:		Remoteproc SSR notifier
  * @smp2p:		SMP2P information
- * @clock:		IPA clocking information
+ * @power:		IPA power information
  * @table_addr:		DMA address of filter/route table content
  * @table_virt:		Virtual address of filter/route table content
  * @interrupt:		IPA Interrupt information
- * @uc_clocked:		true if clock is active by proxy for microcontroller
+ * @uc_powered:		true if power is active by proxy for microcontroller
  * @uc_loaded:		true after microcontroller has reported it's ready
  * @reg_addr:		DMA address used for IPA register access
  * @reg_virt:		Virtual address used for IPA register access
@@ -78,13 +78,13 @@ struct ipa {
 	struct notifier_block nb;
 	void *notifier;
 	struct ipa_smp2p *smp2p;
-	struct ipa_clock *clock;
+	struct ipa_power *power;
 
 	dma_addr_t table_addr;
 	__le64 *table_virt;
 
 	struct ipa_interrupt *interrupt;
-	bool uc_clocked;
+	bool uc_powered;
 	bool uc_loaded;
 
 	dma_addr_t reg_addr;
@@ -134,11 +134,11 @@ struct ipa {
  *
  * Activities performed at the init stage can be done without requiring
  * any access to IPA hardware.  Activities performed at the config stage
- * require the IPA clock to be running, because they involve access
- * to IPA registers.  The setup stage is performed only after the GSI
- * hardware is ready (more on this below).  The setup stage allows
- * the AP to perform more complex initialization by issuing "immediate
- * commands" using a special interface to the IPA.
+ * require IPA power, because they involve access to IPA registers.
+ * The setup stage is performed only after the GSI hardware is ready
+ * (more on this below).  The setup stage allows the AP to perform
+ * more complex initialization by issuing "immediate commands" using
+ * a special interface to the IPA.
  *
  * This function, @ipa_setup(), starts the setup stage.
  *
diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 54d684945a7f8..3ebc44ea7f3c8 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -18,18 +18,16 @@
 #include "ipa_data.h"
 
 /**
- * DOC: IPA Clocking
+ * DOC: IPA Power Management
  *
- * The "IPA Clock" manages both the IPA core clock and the interconnects
- * (buses) the IPA depends on as a single logical entity.  A reference count
- * is incremented by "get" operations and decremented by "put" operations.
- * Transitions of that count from 0 to 1 result in the clock and interconnects
- * being enabled, and transitions of the count from 1 to 0 cause them to be
- * disabled.  We currently operate the core clock at a fixed clock rate, and
- * all buses at a fixed average and peak bandwidth.  As more advanced IPA
- * features are enabled, we can make better use of clock and bus scaling.
+ * The IPA hardware is enabled when the IPA core clock and all the
+ * interconnects (buses) it depends on are enabled.  Runtime power
+ * management is used to determine whether the core clock and
+ * interconnects are enabled, and if not in use to be suspended
+ * automatically.
  *
- * An IPA clock reference must be held for any access to IPA hardware.
+ * The core clock currently runs at a fixed clock rate when enabled,
+ * an all interconnects use a fixed average and peak bandwidth.
  */
 
 #define IPA_AUTOSUSPEND_DELAY	500	/* milliseconds */
@@ -63,7 +61,7 @@ enum ipa_power_flag {
 };
 
 /**
- * struct ipa_clock - IPA clocking information
+ * struct ipa_power - IPA power management information
  * @dev:		IPA device pointer
  * @core:		IPA core clock
  * @spinlock:		Protects modem TX queue enable/disable
@@ -71,7 +69,7 @@ enum ipa_power_flag {
  * @interconnect_count:	Number of elements in interconnect[]
  * @interconnect:	Interconnect array
  */
-struct ipa_clock {
+struct ipa_power {
 	struct device *dev;
 	struct clk *core;
 	spinlock_t spinlock;	/* used with STOPPED/STARTED power flags */
@@ -110,18 +108,18 @@ static void ipa_interconnect_exit_one(struct ipa_interconnect *interconnect)
 }
 
 /* Initialize interconnects required for IPA operation */
-static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
+static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 				 const struct ipa_interconnect_data *data)
 {
 	struct ipa_interconnect *interconnect;
 	u32 count;
 	int ret;
 
-	count = clock->interconnect_count;
+	count = power->interconnect_count;
 	interconnect = kcalloc(count, sizeof(*interconnect), GFP_KERNEL);
 	if (!interconnect)
 		return -ENOMEM;
-	clock->interconnect = interconnect;
+	power->interconnect = interconnect;
 
 	while (count--) {
 		ret = ipa_interconnect_init_one(dev, interconnect, data++);
@@ -133,36 +131,36 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
 	return 0;
 
 out_unwind:
-	while (interconnect-- > clock->interconnect)
+	while (interconnect-- > power->interconnect)
 		ipa_interconnect_exit_one(interconnect);
-	kfree(clock->interconnect);
-	clock->interconnect = NULL;
+	kfree(power->interconnect);
+	power->interconnect = NULL;
 
 	return ret;
 }
 
 /* Inverse of ipa_interconnect_init() */
-static void ipa_interconnect_exit(struct ipa_clock *clock)
+static void ipa_interconnect_exit(struct ipa_power *power)
 {
 	struct ipa_interconnect *interconnect;
 
-	interconnect = clock->interconnect + clock->interconnect_count;
-	while (interconnect-- > clock->interconnect)
+	interconnect = power->interconnect + power->interconnect_count;
+	while (interconnect-- > power->interconnect)
 		ipa_interconnect_exit_one(interconnect);
-	kfree(clock->interconnect);
-	clock->interconnect = NULL;
+	kfree(power->interconnect);
+	power->interconnect = NULL;
 }
 
 /* Currently we only use one bandwidth level, so just "enable" interconnects */
 static int ipa_interconnect_enable(struct ipa *ipa)
 {
 	struct ipa_interconnect *interconnect;
-	struct ipa_clock *clock = ipa->clock;
+	struct ipa_power *power = ipa->power;
 	int ret;
 	u32 i;
 
-	interconnect = clock->interconnect;
-	for (i = 0; i < clock->interconnect_count; i++) {
+	interconnect = power->interconnect;
+	for (i = 0; i < power->interconnect_count; i++) {
 		ret = icc_set_bw(interconnect->path,
 				 interconnect->average_bandwidth,
 				 interconnect->peak_bandwidth);
@@ -178,7 +176,7 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 	return 0;
 
 out_unwind:
-	while (interconnect-- > clock->interconnect)
+	while (interconnect-- > power->interconnect)
 		(void)icc_set_bw(interconnect->path, 0, 0);
 
 	return ret;
@@ -188,14 +186,14 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 static int ipa_interconnect_disable(struct ipa *ipa)
 {
 	struct ipa_interconnect *interconnect;
-	struct ipa_clock *clock = ipa->clock;
+	struct ipa_power *power = ipa->power;
 	struct device *dev = &ipa->pdev->dev;
 	int result = 0;
 	u32 count;
 	int ret;
 
-	count = clock->interconnect_count;
-	interconnect = clock->interconnect + count;
+	count = power->interconnect_count;
+	interconnect = power->interconnect + count;
 	while (count--) {
 		interconnect--;
 		ret = icc_set_bw(interconnect->path, 0, 0);
@@ -211,8 +209,8 @@ static int ipa_interconnect_disable(struct ipa *ipa)
 	return result;
 }
 
-/* Turn on IPA clocks, including interconnects */
-static int ipa_clock_enable(struct ipa *ipa)
+/* Enable IPA power, enabling interconnects and the core clock */
+static int ipa_power_enable(struct ipa *ipa)
 {
 	int ret;
 
@@ -220,7 +218,7 @@ static int ipa_clock_enable(struct ipa *ipa)
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(ipa->clock->core);
+	ret = clk_prepare_enable(ipa->power->core);
 	if (ret) {
 		dev_err(&ipa->pdev->dev, "error %d enabling core clock\n", ret);
 		(void)ipa_interconnect_disable(ipa);
@@ -229,10 +227,10 @@ static int ipa_clock_enable(struct ipa *ipa)
 	return ret;
 }
 
-/* Inverse of ipa_clock_enable() */
-static int ipa_clock_disable(struct ipa *ipa)
+/* Inverse of ipa_power_enable() */
+static int ipa_power_disable(struct ipa *ipa)
 {
-	clk_disable_unprepare(ipa->clock->core);
+	clk_disable_unprepare(ipa->power->core);
 
 	return ipa_interconnect_disable(ipa);
 }
@@ -243,12 +241,12 @@ static int ipa_runtime_suspend(struct device *dev)
 
 	/* Endpoints aren't usable until setup is complete */
 	if (ipa->setup_complete) {
-		__clear_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags);
+		__clear_bit(IPA_POWER_FLAG_RESUMED, ipa->power->flags);
 		ipa_endpoint_suspend(ipa);
 		gsi_suspend(&ipa->gsi);
 	}
 
-	return ipa_clock_disable(ipa);
+	return ipa_power_disable(ipa);
 }
 
 static int ipa_runtime_resume(struct device *dev)
@@ -256,7 +254,7 @@ static int ipa_runtime_resume(struct device *dev)
 	struct ipa *ipa = dev_get_drvdata(dev);
 	int ret;
 
-	ret = ipa_clock_enable(ipa);
+	ret = ipa_power_enable(ipa);
 	if (WARN_ON(ret < 0))
 		return ret;
 
@@ -273,7 +271,7 @@ static int ipa_suspend(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
 
-	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->clock->flags);
+	__set_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
 	return pm_runtime_force_suspend(dev);
 }
@@ -285,15 +283,15 @@ static int ipa_resume(struct device *dev)
 
 	ret = pm_runtime_force_resume(dev);
 
-	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->clock->flags);
+	__clear_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags);
 
 	return ret;
 }
 
 /* Return the current IPA core clock rate */
-u32 ipa_clock_rate(struct ipa *ipa)
+u32 ipa_core_clock_rate(struct ipa *ipa)
 {
-	return ipa->clock ? (u32)clk_get_rate(ipa->clock->core) : 0;
+	return ipa->power ? (u32)clk_get_rate(ipa->power->core) : 0;
 }
 
 /**
@@ -312,8 +310,8 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * just to handle the interrupt, so we're done.  If we are in a
 	 * system suspend, trigger a system resume.
 	 */
-	if (!__test_and_set_bit(IPA_POWER_FLAG_RESUMED, ipa->clock->flags))
-		if (test_bit(IPA_POWER_FLAG_SYSTEM, ipa->clock->flags))
+	if (!__test_and_set_bit(IPA_POWER_FLAG_RESUMED, ipa->power->flags))
+		if (test_bit(IPA_POWER_FLAG_SYSTEM, ipa->power->flags))
 			pm_wakeup_dev_event(&ipa->pdev->dev, 0, true);
 
 	/* Acknowledge/clear the suspend interrupt on all endpoints */
@@ -345,17 +343,17 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
  */
 void ipa_power_modem_queue_stop(struct ipa *ipa)
 {
-	struct ipa_clock *clock = ipa->clock;
+	struct ipa_power *power = ipa->power;
 	unsigned long flags;
 
-	spin_lock_irqsave(&clock->spinlock, flags);
+	spin_lock_irqsave(&power->spinlock, flags);
 
-	if (!__test_and_clear_bit(IPA_POWER_FLAG_STARTED, clock->flags)) {
+	if (!__test_and_clear_bit(IPA_POWER_FLAG_STARTED, power->flags)) {
 		netif_stop_queue(ipa->modem_netdev);
-		__set_bit(IPA_POWER_FLAG_STOPPED, clock->flags);
+		__set_bit(IPA_POWER_FLAG_STOPPED, power->flags);
 	}
 
-	spin_unlock_irqrestore(&clock->spinlock, flags);
+	spin_unlock_irqrestore(&power->spinlock, flags);
 }
 
 /* This function starts the modem netdev transmit queue, but only if the
@@ -365,23 +363,23 @@ void ipa_power_modem_queue_stop(struct ipa *ipa)
  */
 void ipa_power_modem_queue_wake(struct ipa *ipa)
 {
-	struct ipa_clock *clock = ipa->clock;
+	struct ipa_power *power = ipa->power;
 	unsigned long flags;
 
-	spin_lock_irqsave(&clock->spinlock, flags);
+	spin_lock_irqsave(&power->spinlock, flags);
 
-	if (__test_and_clear_bit(IPA_POWER_FLAG_STOPPED, clock->flags)) {
-		__set_bit(IPA_POWER_FLAG_STARTED, clock->flags);
+	if (__test_and_clear_bit(IPA_POWER_FLAG_STOPPED, power->flags)) {
+		__set_bit(IPA_POWER_FLAG_STARTED, power->flags);
 		netif_wake_queue(ipa->modem_netdev);
 	}
 
-	spin_unlock_irqrestore(&clock->spinlock, flags);
+	spin_unlock_irqrestore(&power->spinlock, flags);
 }
 
 /* This function clears the STARTED flag once the TX queue is operating */
 void ipa_power_modem_queue_active(struct ipa *ipa)
 {
-	clear_bit(IPA_POWER_FLAG_STARTED, ipa->clock->flags);
+	clear_bit(IPA_POWER_FLAG_STARTED, ipa->power->flags);
 }
 
 int ipa_power_setup(struct ipa *ipa)
@@ -404,11 +402,11 @@ void ipa_power_teardown(struct ipa *ipa)
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_TX_SUSPEND);
 }
 
-/* Initialize IPA clocking */
-struct ipa_clock *
-ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
+/* Initialize IPA power management */
+struct ipa_power *
+ipa_power_init(struct device *dev, const struct ipa_power_data *data)
 {
-	struct ipa_clock *clock;
+	struct ipa_power *power;
 	struct clk *clk;
 	int ret;
 
@@ -426,17 +424,17 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 		goto err_clk_put;
 	}
 
-	clock = kzalloc(sizeof(*clock), GFP_KERNEL);
-	if (!clock) {
+	power = kzalloc(sizeof(*power), GFP_KERNEL);
+	if (!power) {
 		ret = -ENOMEM;
 		goto err_clk_put;
 	}
-	clock->dev = dev;
-	clock->core = clk;
-	spin_lock_init(&clock->spinlock);
-	clock->interconnect_count = data->interconnect_count;
+	power->dev = dev;
+	power->core = clk;
+	spin_lock_init(&power->spinlock);
+	power->interconnect_count = data->interconnect_count;
 
-	ret = ipa_interconnect_init(clock, dev, data->interconnect_data);
+	ret = ipa_interconnect_init(power, dev, data->interconnect_data);
 	if (ret)
 		goto err_kfree;
 
@@ -444,26 +442,26 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
-	return clock;
+	return power;
 
 err_kfree:
-	kfree(clock);
+	kfree(power);
 err_clk_put:
 	clk_put(clk);
 
 	return ERR_PTR(ret);
 }
 
-/* Inverse of ipa_clock_init() */
-void ipa_clock_exit(struct ipa_clock *clock)
+/* Inverse of ipa_power_init() */
+void ipa_power_exit(struct ipa_power *power)
 {
-	struct device *dev = clock->dev;
-	struct clk *clk = clock->core;
+	struct device *dev = power->dev;
+	struct clk *clk = power->core;
 
 	pm_runtime_disable(dev);
 	pm_runtime_dont_use_autosuspend(dev);
-	ipa_interconnect_exit(clock);
-	kfree(clock);
+	ipa_interconnect_exit(power);
+	kfree(power);
 	clk_put(clk);
 }
 
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_clock.h
index 7b7864f3029b6..7a6a910241c1f 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_clock.h
@@ -9,18 +9,18 @@
 struct device;
 
 struct ipa;
-struct ipa_clock_data;
+struct ipa_power_data;
 
 /* IPA device power management function block */
 extern const struct dev_pm_ops ipa_pm_ops;
 
 /**
- * ipa_clock_rate() - Return the current IPA core clock rate
+ * ipa_core_clock_rate() - Return the current IPA core clock rate
  * @ipa:	IPA structure
  *
  * Return: The current clock rate (in Hz), or 0.
  */
-u32 ipa_clock_rate(struct ipa *ipa);
+u32 ipa_core_clock_rate(struct ipa *ipa);
 
 /**
  * ipa_power_modem_queue_stop() - Possibly stop the modem netdev TX queue
@@ -55,19 +55,19 @@ int ipa_power_setup(struct ipa *ipa);
 void ipa_power_teardown(struct ipa *ipa);
 
 /**
- * ipa_clock_init() - Initialize IPA clocking
+ * ipa_power_init() - Initialize IPA power management
  * @dev:	IPA device
  * @data:	Clock configuration data
  *
- * Return:	A pointer to an ipa_clock structure, or a pointer-coded error
+ * Return:	A pointer to an ipa_power structure, or a pointer-coded error
  */
-struct ipa_clock *ipa_clock_init(struct device *dev,
-				 const struct ipa_clock_data *data);
+struct ipa_power *ipa_power_init(struct device *dev,
+				 const struct ipa_power_data *data);
 
 /**
- * ipa_clock_exit() - Inverse of ipa_clock_init()
- * @clock:	IPA clock pointer
+ * ipa_power_exit() - Inverse of ipa_power_init()
+ * @power:	IPA power pointer
  */
-void ipa_clock_exit(struct ipa_clock *clock);
+void ipa_power_exit(struct ipa_power *power);
 
 #endif /* _IPA_CLOCK_H_ */
diff --git a/drivers/net/ipa/ipa_data-v3.1.c b/drivers/net/ipa/ipa_data-v3.1.c
index 4c28189462a70..06ddb85f39b27 100644
--- a/drivers/net/ipa/ipa_data-v3.1.c
+++ b/drivers/net/ipa/ipa_data-v3.1.c
@@ -513,7 +513,7 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 };
 
 /* Clock and interconnect configuration data for an SoC having IPA v3.1 */
-static const struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_power_data ipa_power_data = {
 	.core_clock_rate	= 16 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
@@ -529,5 +529,5 @@ const struct ipa_data ipa_data_v3_1 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
-	.clock_data	= &ipa_clock_data,
+	.power_data	= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa_data-v3.5.1.c b/drivers/net/ipa/ipa_data-v3.5.1.c
index af536ef8c1209..760c22bbdf70f 100644
--- a/drivers/net/ipa/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/ipa_data-v3.5.1.c
@@ -394,7 +394,7 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 };
 
 /* Clock and interconnect configuration data for an SoC having IPA v3.5.1 */
-static const struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_power_data ipa_power_data = {
 	.core_clock_rate	= 75 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
@@ -414,5 +414,5 @@ const struct ipa_data ipa_data_v3_5_1 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
-	.clock_data	= &ipa_clock_data,
+	.power_data	= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 782f67e3e079f..fea91451a0c34 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -382,7 +382,7 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 };
 
 /* Clock and interconnect configuration data for an SoC having IPA v4.11 */
-static const struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_power_data ipa_power_data = {
 	.core_clock_rate	= 60 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
@@ -397,5 +397,5 @@ const struct ipa_data ipa_data_v4_11 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
-	.clock_data	= &ipa_clock_data,
+	.power_data	= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa_data-v4.2.c b/drivers/net/ipa/ipa_data-v4.2.c
index 3b09b7baa95f4..2a231e79d5e11 100644
--- a/drivers/net/ipa/ipa_data-v4.2.c
+++ b/drivers/net/ipa/ipa_data-v4.2.c
@@ -360,7 +360,7 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 };
 
 /* Clock and interconnect configuration data for an SoC having IPA v4.2 */
-static const struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_power_data ipa_power_data = {
 	.core_clock_rate	= 100 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
@@ -376,5 +376,5 @@ const struct ipa_data ipa_data_v4_2 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
-	.clock_data	= &ipa_clock_data,
+	.power_data	= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index db6fda2fe43da..e62ab9c3ac672 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -443,7 +443,7 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 };
 
 /* Clock and interconnect configuration data for an SoC having IPA v4.5 */
-static const struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_power_data ipa_power_data = {
 	.core_clock_rate	= 150 * 1000 * 1000,	/* Hz (150?  60?) */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
@@ -458,5 +458,5 @@ const struct ipa_data ipa_data_v4_5 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
-	.clock_data	= &ipa_clock_data,
+	.power_data	= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 8d83e14819e29..2421b5abb5d44 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -432,7 +432,7 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 };
 
 /* Clock and interconnect configuration data for an SoC having IPA v4.9 */
-static const struct ipa_clock_data ipa_clock_data = {
+static const struct ipa_power_data ipa_power_data = {
 	.core_clock_rate	= 60 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
@@ -447,5 +447,5 @@ const struct ipa_data ipa_data_v4_9 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
-	.clock_data	= &ipa_clock_data,
+	.power_data	= &ipa_power_data,
 };
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 5bc244c8f94e7..6d329e9ce5d29 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -19,7 +19,7 @@
  * IPA and GSI resources to use for a given platform.  This data is supplied
  * via the Device Tree match table, associated with a particular compatible
  * string.  The data defines information about how resources, endpoints and
- * channels, memory, clocking and so on are allocated and used for the
+ * channels, memory, power and so on are allocated and used for the
  * platform.
  *
  * Resources are data structures used internally by the IPA hardware.  The
@@ -265,12 +265,12 @@ struct ipa_interconnect_data {
 };
 
 /**
- * struct ipa_clock_data - description of IPA clock and interconnect rates
+ * struct ipa_power_data - description of IPA power configuration data
  * @core_clock_rate:	Core clock rate (Hz)
  * @interconnect_count:	Number of entries in the interconnect_data array
  * @interconnect_data:	IPA interconnect configuration data
  */
-struct ipa_clock_data {
+struct ipa_power_data {
 	u32 core_clock_rate;
 	u32 interconnect_count;		/* # entries in interconnect_data[] */
 	const struct ipa_interconnect_data *interconnect_data;
@@ -286,7 +286,7 @@ struct ipa_clock_data {
  * @endpoint_data:	IPA endpoint/GSI channel data
  * @resource_data:	IPA resource configuration data
  * @mem_data:		IPA memory region data
- * @clock_data:		IPA clock and interconnect data
+ * @power_data:		IPA power data
  */
 struct ipa_data {
 	enum ipa_version version;
@@ -297,7 +297,7 @@ struct ipa_data {
 	const struct ipa_gsi_endpoint_data *endpoint_data;
 	const struct ipa_resource_data *resource_data;
 	const struct ipa_mem_data *mem_data;
-	const struct ipa_clock_data *clock_data;
+	const struct ipa_power_data *power_data;
 };
 
 extern const struct ipa_data ipa_data_v3_1;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 08ee37ae28813..f88b43d44ba10 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -810,7 +810,7 @@ static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 		return hol_block_timer_qtime_val(ipa, microseconds);
 
 	/* Use 64 bit arithmetic to avoid overflow... */
-	rate = ipa_clock_rate(ipa);
+	rate = ipa_core_clock_rate(ipa);
 	ticks = DIV_ROUND_CLOSEST(microseconds * rate, 128 * USEC_PER_SEC);
 	/* ...but we still need to fit into a 32-bit register */
 	WARN_ON(ticks > U32_MAX);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index b4d7534045a1c..c8d9c6db0b7ed 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -326,8 +326,8 @@ static void ipa_idle_indication_cfg(struct ipa *ipa,
  * @ipa:	IPA pointer
  *
  * Configures when the IPA signals it is idle to the global clock
- * controller, which can respond by scalling down the clock to
- * save power.
+ * controller, which can respond by scaling down the clock to save
+ * power.
  */
 static void ipa_hardware_dcd_config(struct ipa *ipa)
 {
@@ -417,7 +417,7 @@ static void ipa_hardware_deconfig(struct ipa *ipa)
  * @ipa:	IPA pointer
  * @data:	IPA configuration data
  *
- * Perform initialization requiring IPA clock to be enabled.
+ * Perform initialization requiring IPA power to be enabled.
  */
 static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 {
@@ -647,7 +647,7 @@ static bool ipa_version_valid(enum ipa_version version)
  * in several stages:
  *   - The "init" stage involves activities that can be initialized without
  *     access to the IPA hardware.
- *   - The "config" stage requires the IPA clock to be active so IPA registers
+ *   - The "config" stage requires IPA power to be active so IPA registers
  *     can be accessed, but does not require the use of IPA immediate commands.
  *   - The "setup" stage uses IPA immediate commands, and so requires the GSI
  *     layer to be initialized.
@@ -663,14 +663,14 @@ static int ipa_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	const struct ipa_data *data;
-	struct ipa_clock *clock;
+	struct ipa_power *power;
 	bool modem_init;
 	struct ipa *ipa;
 	int ret;
 
 	ipa_validate_build();
 
-	/* Get configuration data early; needed for clock initialization */
+	/* Get configuration data early; needed for power initialization */
 	data = of_device_get_match_data(dev);
 	if (!data) {
 		dev_err(dev, "matched hardware not supported\n");
@@ -691,20 +691,20 @@ static int ipa_probe(struct platform_device *pdev)
 	/* The clock and interconnects might not be ready when we're
 	 * probed, so might return -EPROBE_DEFER.
 	 */
-	clock = ipa_clock_init(dev, data->clock_data);
-	if (IS_ERR(clock))
-		return PTR_ERR(clock);
+	power = ipa_power_init(dev, data->power_data);
+	if (IS_ERR(power))
+		return PTR_ERR(power);
 
 	/* No more EPROBE_DEFER.  Allocate and initialize the IPA structure */
 	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
 	if (!ipa) {
 		ret = -ENOMEM;
-		goto err_clock_exit;
+		goto err_power_exit;
 	}
 
 	ipa->pdev = pdev;
 	dev_set_drvdata(dev, ipa);
-	ipa->clock = clock;
+	ipa->power = power;
 	ipa->version = data->version;
 	init_completion(&ipa->completion);
 
@@ -737,7 +737,7 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_table_exit;
 
-	/* The clock needs to be active for config and setup */
+	/* Power needs to be active for config and setup */
 	ret = pm_runtime_get_sync(dev);
 	if (WARN_ON(ret < 0))
 		goto err_power_put;
@@ -788,8 +788,8 @@ static int ipa_probe(struct platform_device *pdev)
 	ipa_reg_exit(ipa);
 err_kfree_ipa:
 	kfree(ipa);
-err_clock_exit:
-	ipa_clock_exit(clock);
+err_power_exit:
+	ipa_power_exit(power);
 
 	return ret;
 }
@@ -797,7 +797,7 @@ static int ipa_probe(struct platform_device *pdev)
 static int ipa_remove(struct platform_device *pdev)
 {
 	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
-	struct ipa_clock *clock = ipa->clock;
+	struct ipa_power *power = ipa->power;
 	struct device *dev = &pdev->dev;
 	int ret;
 
@@ -828,7 +828,7 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_mem_exit(ipa);
 	ipa_reg_exit(ipa);
 	kfree(ipa);
-	ipa_clock_exit(clock);
+	ipa_power_exit(power);
 
 	return 0;
 }
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 18b1f8d6d729a..2ed80855f7cf1 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -415,7 +415,7 @@ static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case QCOM_SSR_BEFORE_POWERUP:
 		dev_info(dev, "received modem starting event\n");
-		ipa_uc_clock(ipa);
+		ipa_uc_power(ipa);
 		ipa_smp2p_notify_reset(ipa);
 		break;
 
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 7e1cef0fc67cb..df7639c39d716 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -23,19 +23,19 @@
  * SMP2P is a primitive communication mechanism available between the AP and
  * the modem.  The IPA driver uses this for two purposes:  to enable the modem
  * to state that the GSI hardware is ready to use; and to communicate the
- * state of the IPA clock in the event of a crash.
+ * state of IPA power in the event of a crash.
  *
  * GSI needs to have early initialization completed before it can be used.
  * This initialization is done either by Trust Zone or by the modem.  In the
  * latter case, the modem uses an SMP2P interrupt to tell the AP IPA driver
  * when the GSI is ready to use.
  *
- * The modem is also able to inquire about the current state of the IPA
- * clock by trigging another SMP2P interrupt to the AP.  We communicate
- * whether the clock is enabled using two SMP2P state bits--one to
- * indicate the clock state (on or off), and a second to indicate the
- * clock state bit is valid.  The modem will poll the valid bit until it
- * is set, and at that time records whether the AP has the IPA clock enabled.
+ * The modem is also able to inquire about the current state of IPA
+ * power by trigging another SMP2P interrupt to the AP.  We communicate
+ * whether power is enabled using two SMP2P state bits--one to indicate
+ * the power state (on or off), and a second to indicate the power state
+ * bit is valid.  The modem will poll the valid bit until it is set, and
+ * at that time records whether the AP has IPA power enabled.
  *
  * Finally, if the AP kernel panics, we update the SMP2P state bits even if
  * we never receive an interrupt from the modem requesting this.
@@ -45,14 +45,14 @@
  * struct ipa_smp2p - IPA SMP2P information
  * @ipa:		IPA pointer
  * @valid_state:	SMEM state indicating enabled state is valid
- * @enabled_state:	SMEM state to indicate clock is enabled
+ * @enabled_state:	SMEM state to indicate power is enabled
  * @valid_bit:		Valid bit in 32-bit SMEM state mask
  * @enabled_bit:	Enabled bit in 32-bit SMEM state mask
  * @enabled_bit:	Enabled bit in 32-bit SMEM state mask
- * @clock_query_irq:	IPA interrupt triggered by modem for clock query
+ * @clock_query_irq:	IPA interrupt triggered by modem for power query
  * @setup_ready_irq:	IPA interrupt triggered by modem to signal GSI ready
- * @clock_on:		Whether IPA clock is on
- * @notified:		Whether modem has been notified of clock state
+ * @power_on:		Whether IPA power is on
+ * @notified:		Whether modem has been notified of power state
  * @disabled:		Whether setup ready interrupt handling is disabled
  * @mutex:		Mutex protecting ready-interrupt/shutdown interlock
  * @panic_notifier:	Panic notifier structure
@@ -65,7 +65,7 @@ struct ipa_smp2p {
 	u32 enabled_bit;
 	u32 clock_query_irq;
 	u32 setup_ready_irq;
-	bool clock_on;
+	bool power_on;
 	bool notified;
 	bool disabled;
 	struct mutex mutex;
@@ -73,13 +73,13 @@ struct ipa_smp2p {
 };
 
 /**
- * ipa_smp2p_notify() - use SMP2P to tell modem about IPA clock state
+ * ipa_smp2p_notify() - use SMP2P to tell modem about IPA power state
  * @smp2p:	SMP2P information
  *
  * This is called either when the modem has requested it (by triggering
- * the modem clock query IPA interrupt) or whenever the AP is shutting down
+ * the modem power query IPA interrupt) or whenever the AP is shutting down
  * (via a panic notifier).  It sets the two SMP2P state bits--one saying
- * whether the IPA clock is running, and the other indicating the first bit
+ * whether the IPA power is on, and the other indicating the first bit
  * is valid.
  */
 static void ipa_smp2p_notify(struct ipa_smp2p *smp2p)
@@ -92,11 +92,11 @@ static void ipa_smp2p_notify(struct ipa_smp2p *smp2p)
 		return;
 
 	dev = &smp2p->ipa->pdev->dev;
-	smp2p->clock_on = pm_runtime_get_if_active(dev, true) > 0;
+	smp2p->power_on = pm_runtime_get_if_active(dev, true) > 0;
 
-	/* Signal whether the clock is enabled */
+	/* Signal whether the IPA power is enabled */
 	mask = BIT(smp2p->enabled_bit);
-	value = smp2p->clock_on ? mask : 0;
+	value = smp2p->power_on ? mask : 0;
 	qcom_smem_state_update_bits(smp2p->enabled_state, mask, value);
 
 	/* Now indicate that the enabled flag is valid */
@@ -126,7 +126,7 @@ static int ipa_smp2p_panic_notifier(struct notifier_block *nb,
 
 	ipa_smp2p_notify(smp2p);
 
-	if (smp2p->clock_on)
+	if (smp2p->power_on)
 		ipa_uc_panic_notifier(smp2p->ipa);
 
 	return NOTIFY_DONE;
@@ -209,17 +209,17 @@ static void ipa_smp2p_irq_exit(struct ipa_smp2p *smp2p, u32 irq)
 	free_irq(irq, smp2p);
 }
 
-/* Drop the clock reference if it was taken in ipa_smp2p_notify() */
-static void ipa_smp2p_clock_release(struct ipa *ipa)
+/* Drop the power reference if it was taken in ipa_smp2p_notify() */
+static void ipa_smp2p_power_release(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 
-	if (!ipa->smp2p->clock_on)
+	if (!ipa->smp2p->power_on)
 		return;
 
 	pm_runtime_mark_last_busy(dev);
 	(void)pm_runtime_put_autosuspend(dev);
-	ipa->smp2p->clock_on = false;
+	ipa->smp2p->power_on = false;
 }
 
 /* Initialize the IPA SMP2P subsystem */
@@ -253,7 +253,7 @@ int ipa_smp2p_init(struct ipa *ipa, bool modem_init)
 
 	smp2p->ipa = ipa;
 
-	/* These fields are needed by the clock query interrupt
+	/* These fields are needed by the power query interrupt
 	 * handler, so initialize them now.
 	 */
 	mutex_init(&smp2p->mutex);
@@ -306,8 +306,8 @@ void ipa_smp2p_exit(struct ipa *ipa)
 		ipa_smp2p_irq_exit(smp2p, smp2p->setup_ready_irq);
 	ipa_smp2p_panic_notifier_unregister(smp2p);
 	ipa_smp2p_irq_exit(smp2p, smp2p->clock_query_irq);
-	/* We won't get notified any more; drop clock reference (if any) */
-	ipa_smp2p_clock_release(ipa);
+	/* We won't get notified any more; drop power reference (if any) */
+	ipa_smp2p_power_release(ipa);
 	ipa->smp2p = NULL;
 	mutex_destroy(&smp2p->mutex);
 	kfree(smp2p);
@@ -336,13 +336,13 @@ void ipa_smp2p_notify_reset(struct ipa *ipa)
 	if (!smp2p->notified)
 		return;
 
-	ipa_smp2p_clock_release(ipa);
+	ipa_smp2p_power_release(ipa);
 
-	/* Reset the clock enabled valid flag */
+	/* Reset the power enabled valid flag */
 	mask = BIT(smp2p->valid_bit);
 	qcom_smem_state_update_bits(smp2p->valid_state, mask, 0);
 
-	/* Mark the clock disabled for good measure... */
+	/* Mark the power disabled for good measure... */
 	mask = BIT(smp2p->enabled_bit);
 	qcom_smem_state_update_bits(smp2p->enabled_state, mask, 0);
 
diff --git a/drivers/net/ipa/ipa_smp2p.h b/drivers/net/ipa/ipa_smp2p.h
index 20319438a8419..99a9567896388 100644
--- a/drivers/net/ipa/ipa_smp2p.h
+++ b/drivers/net/ipa/ipa_smp2p.h
@@ -39,7 +39,7 @@ void ipa_smp2p_disable(struct ipa *ipa);
  * ipa_smp2p_notify_reset() - Reset modem notification state
  * @ipa:	IPA pointer
  *
- * If the modem crashes it queries the IPA clock state.  In cleaning
+ * If the modem crashes it queries the IPA power state.  In cleaning
  * up after such a crash this is used to reset some state maintained
  * for managing this notification.
  */
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index de04385270195..856e55a080a7f 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -147,16 +147,16 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	 * should only receive responses from the microcontroller when it has
 	 * sent it a request message.
 	 *
-	 * We can drop the clock reference taken in ipa_uc_clock() once we
+	 * We can drop the power reference taken in ipa_uc_power() once we
 	 * know the microcontroller has finished its initialization.
 	 */
 	switch (shared->response) {
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
-		if (ipa->uc_clocked) {
+		if (ipa->uc_powered) {
 			ipa->uc_loaded = true;
 			pm_runtime_mark_last_busy(dev);
 			(void)pm_runtime_put_autosuspend(dev);
-			ipa->uc_clocked = false;
+			ipa->uc_powered = false;
 		} else {
 			dev_warn(dev, "unexpected init_completed response\n");
 		}
@@ -171,7 +171,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 /* Configure the IPA microcontroller subsystem */
 void ipa_uc_config(struct ipa *ipa)
 {
-	ipa->uc_clocked = false;
+	ipa->uc_powered = false;
 	ipa->uc_loaded = false;
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_0, ipa_uc_event_handler);
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_1, ipa_uc_response_hdlr);
@@ -184,15 +184,15 @@ void ipa_uc_deconfig(struct ipa *ipa)
 
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
-	if (!ipa->uc_clocked)
+	if (!ipa->uc_powered)
 		return;
 
 	pm_runtime_mark_last_busy(dev);
 	(void)pm_runtime_put_autosuspend(dev);
 }
 
-/* Take a proxy clock reference for the microcontroller */
-void ipa_uc_clock(struct ipa *ipa)
+/* Take a proxy power reference for the microcontroller */
+void ipa_uc_power(struct ipa *ipa)
 {
 	static bool already;
 	struct device *dev;
@@ -209,7 +209,7 @@ void ipa_uc_clock(struct ipa *ipa)
 		pm_runtime_put_noidle(dev);
 		dev_err(dev, "error %d getting proxy power\n", ret);
 	} else {
-		ipa->uc_clocked = true;
+		ipa->uc_powered = true;
 	}
 }
 
diff --git a/drivers/net/ipa/ipa_uc.h b/drivers/net/ipa/ipa_uc.h
index 14e4e1115aa79..23847f934d64e 100644
--- a/drivers/net/ipa/ipa_uc.h
+++ b/drivers/net/ipa/ipa_uc.h
@@ -21,18 +21,18 @@ void ipa_uc_config(struct ipa *ipa);
 void ipa_uc_deconfig(struct ipa *ipa);
 
 /**
- * ipa_uc_clock() - Take a proxy clock reference for the microcontroller
+ * ipa_uc_power() - Take a proxy power reference for the microcontroller
  * @ipa:	IPA pointer
  *
  * The first time the modem boots, it loads firmware for and starts the
  * IPA-resident microcontroller.  The microcontroller signals that it
  * has completed its initialization by sending an INIT_COMPLETED response
- * message to the AP.  The AP must ensure the IPA core clock is operating
- * until it receives this message, and to do so we take a "proxy" clock
+ * message to the AP.  The AP must ensure the IPA is powered until
+ * it receives this message, and to do so we take a "proxy" clock
  * reference on its behalf here.  Once we receive the INIT_COMPLETED
- * message (in ipa_uc_response_hdlr()) we drop this clock reference.
+ * message (in ipa_uc_response_hdlr()) we drop this power reference.
  */
-void ipa_uc_clock(struct ipa *ipa);
+void ipa_uc_power(struct ipa *ipa);
 
 /**
  * ipa_uc_panic_notifier()
-- 
2.27.0

