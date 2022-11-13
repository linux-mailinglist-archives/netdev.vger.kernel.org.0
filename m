Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B7662728B
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 21:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiKMUe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 15:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbiKMUeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 15:34:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0353C13DC8;
        Sun, 13 Nov 2022 12:34:05 -0800 (PST)
Message-ID: <20221113202428.635404684@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668371644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=atAQsYlS7ilqmYpHpwQVDqstkBeBHvQ3lUro0dnXaTo=;
        b=1GYe36+GwaYtcXgv4hmVrPjynqsVlt3gGIq3jZ5EeW0sspbpBlBE6u7z82/brMbiFdSaDU
        PVxjHHTlMzOnENO3R6fLLsuMGsIr2n6DTGShp/vQacFom++DUcOtu37YsHwYb1/OvCEKFN
        Qme6BPjO4QuTGzipPANUbMIRkKo0hsYv7T5VX0Jl/7hmDIiKiydrJCsTd4Ko1NOZAR+sSl
        cIqb28AWlAM6F+ld6Jc80k9FnRBReBcEmHrUhGP3vYh5K0lrPSWRl+D/tg1i4KpKukc6Gp
        n/RHI6XnQ++3fL3M3QtGsmdKmxKwWUyRqv1ptpGIiLiWKM9Z+N1AmQVnduFF8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668371644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=atAQsYlS7ilqmYpHpwQVDqstkBeBHvQ3lUro0dnXaTo=;
        b=Nzwm9nRGeReygfMg+qKvRuIqMN10TEVRwDYioCICrZ5A13bNo0Lerx2bgPQqpIV9bpA1w9
        xRj9X5paoLs2fpDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [patch 06/10] net: dpaa2: Remove linux/msi.h includes
References: <20221113201935.776707081@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 13 Nov 2022 21:34:04 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing in these file needs anything from linux/msi.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    |    1 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c    |    1 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c |    1 -
 3 files changed, 3 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -8,7 +8,6 @@
 #include <linux/etherdevice.h>
 #include <linux/of_net.h>
 #include <linux/interrupt.h>
-#include <linux/msi.h>
 #include <linux/kthread.h>
 #include <linux/iommu.h>
 #include <linux/fsl/mc.h>
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/msi.h>
 #include <linux/fsl/mc.h>
 
 #include "dpaa2-ptp.h"
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 
 #include <linux/interrupt.h>
-#include <linux/msi.h>
 #include <linux/kthread.h>
 #include <linux/workqueue.h>
 #include <linux/iommu.h>

