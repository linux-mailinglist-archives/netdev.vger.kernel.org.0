Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8BC2F2879
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388017AbhALGo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbhALGo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:44:28 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E355C0617A5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:13 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id s2so1341531oij.2
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 22:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QqIzdhe3bhm33+yVgUH0Jf6yGbzv8srwAYIGVy2K0RE=;
        b=Quk4cQ9RkrI7Oe1veKtD8KL/u7IPowIPAVoh//UYxMd2oSIgLSzEHRQRrhFRVoC5nb
         FaUM8PYZbTuASMHa2jeBf4rYMrjhxoWdQyhJ13Ucg9rDnoet8yQHdpiz3GCislZ4uBYc
         Cky1SoMbUgXjZF2dY07cr0QqmGnhWxWSbKwiADUFTerqwQyWs8Lefw85LY8sBD7DJeu0
         XRshf44dqOaf+UMKIarbnkO7ZdK4gIZM0MaH6LSrfCTbPoTWjz+c3tEdh4d0rJp9J1zF
         zQuAwWzUSEaNoy3VbjQ4I3Fbm3EJhYW6CY/iqS7SxDCXGAoPPGC4XMc3JZgNmsOCDK0Q
         RPdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QqIzdhe3bhm33+yVgUH0Jf6yGbzv8srwAYIGVy2K0RE=;
        b=gFr/rCi9zBouCZ1PEiVefmlIzPEwnoSRlyeMjyk/y+PZ1lOZ/QD1wlAK6uoJ7/MHSs
         CnowT/zNWdQ6SkYam0kabhZsQeR3JwueBrmGd3eAGQhfVGDpBgMcj5FcFOYnNAKtNxzV
         gCFA2qNwRgSSOc2kSGdE95fNtlrEG8SVUMGFVSEJpQNHNaRGz1isP8WG/lf4MwWas8nz
         fpOlj5bDdykLSbYmr6k0ekMUWeydaVD3kpAL8oMhkUfdYJybFoKijnYpmo7JRIT7SE6F
         KauQGJ2v8tdkPl1hpevhDaBo0rosRG3LvI/A8HODJPSJbAvv1e9kSq3DA7ideplz3P2c
         0IHA==
X-Gm-Message-State: AOAM532y9YetK+kS8IJpVInG8oXNXlaG+5pq0hxrO+FTvX39L/8Hmj4Y
        hFdNoOqKhnO5iPwKBNwo+AiDg4/Ii6NN4w==
X-Google-Smtp-Source: ABdhPJwBKOl24shC3HQkEbCwmwAgibP4bIaCWZxrHzKkFSDOI87dGiA491igDbaHdg/+cuKVl2vhlg==
X-Received: by 2002:a05:6808:352:: with SMTP id j18mr1566175oie.78.1610433792383;
        Mon, 11 Jan 2021 22:43:12 -0800 (PST)
Received: from pear.attlocal.net ([2600:1700:271:1a80:ddc5:e91b:d3cf:e2ba])
        by smtp.gmail.com with ESMTPSA id 94sm482271otw.41.2021.01.11.22.43.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:43:12 -0800 (PST)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next 7/7] ibmvnic: remove unused spinlock_t stats_lock definition
Date:   Tue, 12 Jan 2021 00:43:05 -0600
Message-Id: <20210112064305.31606-8-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stats_lock is no longer used. So remove it.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 --
 drivers/net/ethernet/ibm/ibmvnic.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index f9db139f652b..d76d9934c7c3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5284,8 +5284,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->ethtool_ops = &ibmvnic_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
 
-	spin_lock_init(&adapter->stats_lock);
-
 	INIT_WORK(&adapter->ibmvnic_reset, __ibmvnic_reset);
 	INIT_DELAYED_WORK(&adapter->ibmvnic_delayed_reset,
 			  __ibmvnic_delayed_reset);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 8f73a30a7593..270d1cac86a4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -987,7 +987,6 @@ struct ibmvnic_adapter {
 	struct ibmvnic_statistics stats;
 	dma_addr_t stats_token;
 	struct completion stats_done;
-	spinlock_t stats_lock;
 	int replenish_no_mem;
 	int replenish_add_buff_success;
 	int replenish_add_buff_failure;
-- 
2.23.0

