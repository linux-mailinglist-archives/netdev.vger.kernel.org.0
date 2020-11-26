Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B42C55ED
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390552AbgKZNjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390368AbgKZNjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:39:07 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930A2C0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:07 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id s8so2163504wrw.10
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DTJOzm0gZUliIM1CJNEOWqPKlNYApXefDQfPPtC85HY=;
        b=MpLT1rTcOQFXj5o4p45U25gq5Wthd5hRlOe6Ee20BztH8fDINAFaP0ZGPZrw/fdu38
         SQDpyQIFeHvBMZPN84C6jFq3J/b9fMFZUIqyfyvASKnB4KKLD2TTzAPoMoOaBwcjGw0W
         Q/dLgkJXs8gJC3AhstDCm/oTI4DLuAkMXHGatvyRdaPI6XbX5O5rP642oQxh5iZCK86S
         gBKa8VwBXCPDpUt90nGEOfBD1oM7WZIuQofLaxEdI4/vzc2IhjdS4Y7G3j7IaZBOT7q2
         4ENAa5iQyd+BgkiP2sMF01e4mBpRVZiTs7Wn2xKv4duAzKRegKdJkcE929j47H1/FM7t
         Sh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DTJOzm0gZUliIM1CJNEOWqPKlNYApXefDQfPPtC85HY=;
        b=Yw2ZCYP0vOsq4CFgyzwygD14DWyVEO7T23J0bycMvDGl5saFpuUNFDSCN1xQ4wwor8
         r4vdIhpgqdpXAVrj8JmIe00g+6hVmXKXRKR5jRJRn/uTP1sNu3rdI2n38LbBBPyASqX2
         pgSenAzu4yvH4x8dQQjKCGi9TGVB9gze183C1OsMvzYweeeGtSWxLygI6cznSdUbGeCF
         zlsEkKOxJi7fPL9mTVRSP+SDpSowG+R+ibJGuIOrtdiT+vqiJZXwwO3qpt6Um1xIlxYW
         dISZFZwO0eGuUrq0afkmUs84nItXr1eMy7XJ1dLueUr/m+vX6hiklYr2oFc+N68aIHfY
         LCrA==
X-Gm-Message-State: AOAM531giokN1Iz84lSlCG46jSxeLrWjT7uylUpVi9eKDZv6aMOgmu+l
        BQTTNa0PWjUpNJBqVx/r8ULJ7w==
X-Google-Smtp-Source: ABdhPJy76iTnF7RZ2IDKEHoxBDI4A4RdHy3hLm2gVUChhl9eVgcpueWg4kEabKQmMRsE+zIvq6jEcQ==
X-Received: by 2002:adf:e551:: with SMTP id z17mr3940424wrm.374.1606397946311;
        Thu, 26 Nov 2020 05:39:06 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id s133sm7035825wmf.38.2020.11.26.05.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:39:05 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 6/8] net: ethernet: toshiba: ps3_gelic_net: Fix some kernel-doc misdemeanours
Date:   Thu, 26 Nov 2020 13:38:51 +0000
Message-Id: <20201126133853.3213268-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133853.3213268-1-lee.jones@linaro.org>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1107: warning: Function parameter or member 'irq' not described in 'gelic_card_interrupt'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1107: warning: Function parameter or member 'ptr' not described in 'gelic_card_interrupt'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1407: warning: Function parameter or member 'txqueue' not described in 'gelic_net_tx_timeout'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1439: warning: Function parameter or member 'napi' not described in 'gelic_ether_setup_netdev_ops'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1639: warning: Function parameter or member 'dev' not described in 'ps3_gelic_driver_probe'
 drivers/net/ethernet/toshiba/ps3_gelic_net.c:1795: warning: Function parameter or member 'dev' not described in 'ps3_gelic_driver_remove'

Cc: Geoff Levand <geoff@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/toshiba/ps3_gelic_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d9a5722f561b5..f886e23f8ed0a 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1100,7 +1100,7 @@ static int gelic_net_poll(struct napi_struct *napi, int budget)
 	return packets_done;
 }
 
-/**
+/*
  * gelic_card_interrupt - event handler for gelic_net
  */
 static irqreturn_t gelic_card_interrupt(int irq, void *ptr)
@@ -1400,6 +1400,7 @@ static void gelic_net_tx_timeout_task(struct work_struct *work)
 /**
  * gelic_net_tx_timeout - called when the tx timeout watchdog kicks in.
  * @netdev: interface device structure
+ * @txqueue: unused
  *
  * called, if tx hangs. Schedules a task that resets the interface
  */
@@ -1431,6 +1432,7 @@ static const struct net_device_ops gelic_netdevice_ops = {
 /**
  * gelic_ether_setup_netdev_ops - initialization of net_device operations
  * @netdev: net_device structure
+ * @napi: napi structure
  *
  * fills out function pointers in the net_device structure
  */
@@ -1632,7 +1634,7 @@ static void gelic_card_get_vlan_info(struct gelic_card *card)
 	dev_info(ctodev(card), "internal vlan %s\n",
 		 card->vlan_required? "enabled" : "disabled");
 }
-/**
+/*
  * ps3_gelic_driver_probe - add a device to the control of this driver
  */
 static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
@@ -1787,10 +1789,9 @@ static int ps3_gelic_driver_probe(struct ps3_system_bus_device *dev)
 	return result;
 }
 
-/**
+/*
  * ps3_gelic_driver_remove - remove a device from the control of this driver
  */
-
 static int ps3_gelic_driver_remove(struct ps3_system_bus_device *dev)
 {
 	struct gelic_card *card = ps3_system_bus_get_drvdata(dev);
-- 
2.25.1

