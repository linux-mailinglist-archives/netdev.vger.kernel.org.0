Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6C13EDFC0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhHPWOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:14:30 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:40711 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbhHPWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 18:14:18 -0400
Received: (qmail 50400 invoked by uid 89); 16 Aug 2021 22:13:42 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 16 Aug 2021 22:13:42 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/4] MAINTAINERS: Update for ptp_ocp driver.
Date:   Mon, 16 Aug 2021 15:13:37 -0700
Message-Id: <20210816221337.390645-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816221337.390645-1-jonathan.lemon@gmail.com>
References: <20210816221337.390645-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maintainer info for the OpenCompute PTP driver.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2da75be3fb3f..43ec27b32ee5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13885,6 +13885,12 @@ F:	Documentation/devicetree/
 F:	arch/*/boot/dts/
 F:	include/dt-bindings/
 
+OPENCOMPUTE PTP CLOCK DRIVER
+M:	Jonathan Lemon <jonathan.lemon@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/ptp/ptp_ocp.c
+
 OPENCORES I2C BUS DRIVER
 M:	Peter Korsgaard <peter@korsgaard.com>
 M:	Andrew Lunn <andrew@lunn.ch>
-- 
2.31.1

