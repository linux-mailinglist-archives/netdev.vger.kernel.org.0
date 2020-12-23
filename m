Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3EC2E2103
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgLWTpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:45:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728017AbgLWTpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 14:45:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608752634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1tSt3whC+pNrHXspGsGwLhL+moczjxAETXg7Fs0e2fI=;
        b=K0lRaUH7yIUXJ2R/81m3G5Ec1ChhvCMRx+em2L+RF6okkJihCGw281nuDY+tU3ReGbLQ/F
        AkS2cRTyZiG/WuPFjWo9OZGL9D6QPsDKFkAcO5fkVePcuxk6svOmpuLwDZGZdviG4qVHgh
        kYMAONoF/DXQ7N5qAzt3NPQscdaPUyk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-kmZIr7hFMH-o75ztIIINkg-1; Wed, 23 Dec 2020 14:43:52 -0500
X-MC-Unique: kmZIr7hFMH-o75ztIIINkg-1
Received: by mail-qt1-f200.google.com with SMTP id j1so36552qtd.13
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 11:43:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tSt3whC+pNrHXspGsGwLhL+moczjxAETXg7Fs0e2fI=;
        b=L5t+ZwXOZGsehI2/EG41If2+LkcBL9p2T7OtzcOu8Ycu9/24D7htZsvI6d4Di0j5Kr
         p9h7bnakUaR5URKze1p8GSEiZy2s+U27y6bZ9twUsvthE4HaL2NVx7VjfdRieHpUlIkf
         oYzEkAJf0qKedDD6BiFG1OjIneOSCbKdpu3VVcw10fvm/V4mZjx0/Qk0l3W8MEz3hcvm
         YywjvzPrdY+HUcGg3eVEOGgEdCm8ZlfORYRhQTLLRdR54vIwz2Vy7fxvUhk6GPFIIYwx
         lCFl3twXD4vnLop+nCYPRGqXL6ID8+m90ILi8Ej+ZgtSDWB7jqeej85z20rzKz7iM5/2
         4mmA==
X-Gm-Message-State: AOAM530MOk3i+YFHtV0Js3HXbEqDOBEJ0d7wldpxNVlUBIWxWB5kgvmI
        6F14Weogm3ZM+HTc3OqU4fa7Zzgmy9levEF9ADo1hQLxHcNLLoAvL/1lwaLRqBwPVS7vIbJ2Nzw
        hwMdjLnrq0kQBehOu
X-Received: by 2002:a05:6214:1467:: with SMTP id c7mr28700346qvy.51.1608752631916;
        Wed, 23 Dec 2020 11:43:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWTpxaUv/+45wNbn238HBDRXPC42C8L5QiUn9XSKQSH6LLeUQ9tgOLLPUsAAegMuOtSYkSeA==
X-Received: by 2002:a05:6214:1467:: with SMTP id c7mr28700328qvy.51.1608752631742;
        Wed, 23 Dec 2020 11:43:51 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id n3sm14748100qtp.72.2020.12.23.11.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 11:43:51 -0800 (PST)
From:   trix@redhat.com
To:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] amd-xgbe: remove h from printk format specifier
Date:   Wed, 23 Dec 2020 11:43:45 -0800
Message-Id: <20201223194345.125205-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 61f39a0e04f9..3c18f26bf2a5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -339,14 +339,14 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
 	speed = cmd->base.speed;
 
 	if (cmd->base.phy_address != pdata->phy.address) {
-		netdev_err(netdev, "invalid phy address %hhu\n",
+		netdev_err(netdev, "invalid phy address %u\n",
 			   cmd->base.phy_address);
 		return -EINVAL;
 	}
 
 	if ((cmd->base.autoneg != AUTONEG_ENABLE) &&
 	    (cmd->base.autoneg != AUTONEG_DISABLE)) {
-		netdev_err(netdev, "unsupported autoneg %hhu\n",
+		netdev_err(netdev, "unsupported autoneg %u\n",
 			   cmd->base.autoneg);
 		return -EINVAL;
 	}
@@ -358,7 +358,7 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
 		}
 
 		if (cmd->base.duplex != DUPLEX_FULL) {
-			netdev_err(netdev, "unsupported duplex %hhu\n",
+			netdev_err(netdev, "unsupported duplex %u\n",
 				   cmd->base.duplex);
 			return -EINVAL;
 		}
-- 
2.27.0

