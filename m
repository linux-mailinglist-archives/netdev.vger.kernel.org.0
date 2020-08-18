Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38F9248318
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgHRKeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgHRKdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1023BC061345
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:33:32 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fA9IzUR7zlcVZjQJDhbU8/ytjoHt5gHLiwUBKGjW9aQ=;
        b=fdS94GWEwpsrpRpFxlH3Y9nITNeeXNIPaPFnj+/BAZjFlnO4gnXf0e95jPKtY+vcNVz1rU
        dsP5Zrgm/oUVx53+VX/SfPkLvfR9QY34XpoQ6jthZ1Yx9yi7lPckTmxZrlFQIByKG9+N0x
        /MIH/DgQXvyCz27w5xUPhYfsrqHWgtzjIwBIEZhUFNMPojn2X6e68r96MOwlATgnFo5R5o
        DGPq2q9KXYG7cc2QlyXo0ejSkmff0kMm8mS8ytzMM0F9OqXA6DwDE7JgpGy1eR6U10sG43
        ib1unpsNFA2TCpt+7iux0csruZJ8maudkfBdEThh3S/jJhl/mZNwFnYIhFjmYg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fA9IzUR7zlcVZjQJDhbU8/ytjoHt5gHLiwUBKGjW9aQ=;
        b=IxgnmWZWOuHh6oXy/UFAbDQRXUyPWC+Pdy634QYuGg0vvLT2xFzeOmSCljUMmTbT72WHl4
        6M3eFeCsebJENaAg==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v4 9/9] ptp: Remove unused macro
Date:   Tue, 18 Aug 2020 12:32:51 +0200
Message-Id: <20200818103251.20421-10-kurt@linutronix.de>
In-Reply-To: <20200818103251.20421-1-kurt@linutronix.de>
References: <20200818103251.20421-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offset for the control field is not needed anymore. Remove it.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/ptp_classify.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 39bad015d1d6..cf13c7b15c0c 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -36,7 +36,6 @@
 
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
 #define OFF_PTP_SEQUENCE_ID	30
-#define OFF_PTP_CONTROL		32 /* PTPv1 only */
 
 /* Below defines should actually be removed at some point in time. */
 #define IP6_HLEN	40
-- 
2.20.1

