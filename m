Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7122AD047
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 08:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgKJHSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 02:18:42 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56438 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgKJHSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 02:18:42 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604992719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1iFuz01GoKN17OphrVPg/1m+RVnZekyWdaY0+/9C/Gw=;
        b=RxZfp2w5JBLOIaLBStU2mESv32U/viQ32AdOfAMcEYTvUdUauvq+UeQO/4LXTYApaWTuSy
        2DYRz6SArn5iaxutYRA+sDRRwluUky9HmmGS07Ym4vQL3yldOvBvR9AfXJkB6IIE5aBE8b
        DoE1TnnHFEXrc1XELZxoq9vH0/OiP/FZNrEtQIwEaY4pmQUCzfYNDgxeue42OtJm+7yjIx
        Xqrz8kHT3VYWlT4hL29T9GzdfISAsZV2ywe3fLA99Jo7Q80AbZErEUev8zY9TgE3YioTNY
        DBtcHG8Ii4gaVt9Yg6qZR8IM60A1YZVF0SoyIhcGAW0Nk6ixBrlc60QsQwNXqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604992719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1iFuz01GoKN17OphrVPg/1m+RVnZekyWdaY0+/9C/Gw=;
        b=0zTgecuqiamKpuCgOvRV0JzcqO2lJDUtZoQu186CttQRutTsOaiIFMBYiZi5II3PKbwESS
        hXiFsHadVC7bsDBQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] MAINTAINERS: Add entry for Hirschmann Hellcreek Switch Driver
Date:   Tue, 10 Nov 2020 08:18:29 +0100
Message-Id: <20201110071829.7467-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself to cover the Hirschmann Hellcreek TSN Ethernet Switch Driver.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a0fde12b650..7fe936fc7e76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7897,6 +7897,15 @@ F:	include/linux/hippidevice.h
 F:	include/uapi/linux/if_hippi.h
 F:	net/802/hippi.c
 
+HIRSCHMANN HELLCREEK ETHERNET SWITCH DRIVER
+M:	Kurt Kanzenbach <kurt@linutronix.de>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+F:	drivers/net/dsa/hirschmann/*
+F:	include/linux/platform_data/hirschmann-hellcreek.h
+F:	net/dsa/tag_hellcreek.c
+
 HISILICON DMA DRIVER
 M:	Zhou Wang <wangzhou1@hisilicon.com>
 L:	dmaengine@vger.kernel.org
-- 
2.20.1

