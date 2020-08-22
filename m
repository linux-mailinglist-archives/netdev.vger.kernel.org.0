Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB63124E9AA
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgHVULn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgHVULi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:11:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB2C061575;
        Sat, 22 Aug 2020 13:11:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 17so2776532pfw.9;
        Sat, 22 Aug 2020 13:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hvu+4Lrza6VgDX2+CcgIuESZtTh5r+mVjuNUUQvK758=;
        b=FDneKlyEPNpgHZCy3OVxB+PSkXo5U998VHfiRCti4jyID8qIQtLmg2vBkZVlpC2RiX
         HA0Gv3C8h43JBfO9Oh4S/dn4z0SsJkNE9Ho6wHoML1iynh7vwF+e1A5cta99AqmgBqLd
         wwFRzQuWwrcUZ7gmQdLGxv+9OSzsISW+seW1oADGZWC7tF2zbRKTtQyqYv0+ELLlQY/b
         lNqfAGob/HO7GUNAvJSLyRv5qLzmT+0nnkfdYlko9nm31DKW84gcRZjtRa4tN6PRkgX/
         ou8ksQQgRz80NhhUCBpQfYSPs+MBehIL9QZlN+WtTXO3KDaUQyogQwxskmo5SbuJ9Wfb
         n53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hvu+4Lrza6VgDX2+CcgIuESZtTh5r+mVjuNUUQvK758=;
        b=bFDz8omOylVPt6KRB0TdBeV68BgibpbS4Ib2ZBjR93u7GQErJZFTKoUMM2LJH6AVBW
         lIntRSXUzh1WXEe/WpX4TV7xJH+7VftQJF1CUOXUklIWx0WQteWKKydqQXC9FUmWkj/t
         0grrcwgspvGspRVTDIvQ+qgxWnfzUQuETSUJfu3T/T5U24t3OuQmgR8rBUThh0McGXOA
         /wKS84ZrYE8PRRI3N/HRu3tP8bbw8amiQqrgpKogch4eeMVBgksbn1YK2N+BuZef8FT/
         AeptS/XuEqGOLxCYFljkB5mSn00cmgPdUpnFfxD0R3nezsOWdfoe8cxkZKup1DF6PUuE
         PJ6w==
X-Gm-Message-State: AOAM533yF5anHhOFh5NEiziLqLgngkKYqE1hOpVgVhwI5r9uI0dOdI6j
        b8HOO8BQsyBiSDfei2jldulx/6pn7Ec=
X-Google-Smtp-Source: ABdhPJxqbv3Fz4dgbxLO7B/biSJiOWD1PFm4cp2g4mr15c5RvaOg4u0MybhQReGbP41To/7abJZj9A==
X-Received: by 2002:a63:6e01:: with SMTP id j1mr6140352pgc.147.1598127096787;
        Sat, 22 Aug 2020 13:11:36 -0700 (PDT)
Received: from 1G5JKC2.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id na16sm4678779pjb.30.2020.08.22.13.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 13:11:36 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 2/6] MAINTAINERS: B53: Add DT binding file
Date:   Sat, 22 Aug 2020 13:11:22 -0700
Message-Id: <20200822201126.8253-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822201126.8253-1-f.fainelli@gmail.com>
References: <20200822201126.8253-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the binding was added with 967dd82ffc52 ("net: dsa: b53: Add
support for Broadcom RoboSwitch"), it was not explicitly added to the
B53 MAINTAINERS file section, add it now.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c081a21a3e9..cd80f641f9fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3388,6 +3388,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 L:	netdev@vger.kernel.org
 L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
+F:	Documentation/devicetree/bindings/net/dsa/b53.txt
 F:	drivers/net/dsa/b53/*
 F:	include/linux/platform_data/b53.h
 
-- 
2.17.1

