Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FFA3A5A0B
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhFMSin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 14:38:43 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:44797 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhFMSim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 14:38:42 -0400
Received: by mail-lf1-f52.google.com with SMTP id r198so17191927lff.11
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 11:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f9hctqrMSqIha3ZKHMtzDyMGNIbR3Ixgz4KlWzWlWOg=;
        b=mzmjIBp+lxMz6Dtk6NDYmJ10qhlBWdSQ1+wc0DHFyaKpM5qw1LqUADjP4+hBAygOt6
         8oI1gUCQ3dYB70FSwRPlYPtXO+oAZk8T+eVajuzVbZMaypUx+oORW0AEGQRjh0qlbqCI
         gfAApUuCD8amT1WLio5DETbrcj3zEulRuhj15RgWb8jX3orviYYLU9Lz9OjVQIoMAWh7
         F5VYfhlFeF3moGyM+9IUrNVDNVviV3sQ8Jj2QZDZ4n88XVReok6ai7M5c4+JFAOWOrFK
         W+KpkTDuokG8ohc4WCqPKNJ+iZIGIZ+g+cSz4x/+HlN4WkQRL0H6J3UcTYkDUapC8DAf
         HwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f9hctqrMSqIha3ZKHMtzDyMGNIbR3Ixgz4KlWzWlWOg=;
        b=kLEku7UIbNWRP2aIHuYs4vrAXqOSjt/DZn5ANNuJy1JiRQv+hPqW83yxcVOeOa2UU7
         O/fSG0zM2anNJTQiSLkCUF8R0/HKTL/1d63cCi4caU9fgMrR/vIxUa5ULGbrUZarogtO
         lV1hd3MIkixq/WFfeqps0hF8wzSZp6cxLhkWZr0MVyEUO/QVc3tJdvblMoxYtlt317/K
         VzQennyzGSdNPfhJdFR1GvDILq8VJsnEFvL9tO2EQezqyKU5L6R25Byt0uEhJ+z09Fmt
         WkJ7gMXliWOUs5GbYATHBN1gmZBiRHp9G2fQ6Zluj/9cPh2noSlwe0TcENg8QD+8FgON
         3m/g==
X-Gm-Message-State: AOAM533GXoz01F8Wb06ssogoI2v2qmmHkNWvkFXKDyTiS1vBJuK65YpU
        fdCbn6fv7aI/quQ8YGUL69/HjQ==
X-Google-Smtp-Source: ABdhPJzS7H/tNvsCe0/darfMH9xo7jB3uQfLNNWbuc1ZOHYIKQwRsfx3mEDL37rOj8fynJSCIvI31A==
X-Received: by 2002:a19:dc02:: with SMTP id t2mr9560004lfg.261.1623609340068;
        Sun, 13 Jun 2021 11:35:40 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e12sm904984lfs.157.2021.06.13.11.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 11:35:39 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com,
        Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH 3/3] net: mvpp2: remove unused 'has_phy' field
Date:   Sun, 13 Jun 2021 20:35:20 +0200
Message-Id: <20210613183520.2247415-4-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210613183520.2247415-1-mw@semihalf.com>
References: <20210613183520.2247415-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'has_phy' field from struct mvpp2_port is no longer used.
Remove it.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 3 ---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4a61c90003b5..b9fbc9f000f2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1197,9 +1197,6 @@ struct mvpp2_port {
 	/* Firmware node associated to the port */
 	struct fwnode_handle *fwnode;
 
-	/* Is a PHY always connected to the port */
-	bool has_phy;
-
 	/* Per-port registers' base address */
 	void __iomem *base;
 	void __iomem *stats_base;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ca1f0464e746..c87752999485 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6790,7 +6790,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	port = netdev_priv(dev);
 	port->dev = dev;
 	port->fwnode = port_fwnode;
-	port->has_phy = !!of_find_property(port_node, "phy", NULL);
 	port->ntxqs = ntxqs;
 	port->nrxqs = nrxqs;
 	port->priv = priv;
-- 
2.29.0

