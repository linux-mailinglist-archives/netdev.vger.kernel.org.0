Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D032F3E97AF
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhHKScF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:32:05 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:27716 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhHKScC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:32:02 -0400
Received: (qmail 30693 invoked by uid 89); 11 Aug 2021 18:31:37 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 11 Aug 2021 18:31:37 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 3/3] MAINTAINERS: Update for ptp_ocp driver.
Date:   Wed, 11 Aug 2021 11:31:33 -0700
Message-Id: <20210811183133.186721-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811183133.186721-1-jonathan.lemon@gmail.com>
References: <20210811183133.186721-1-jonathan.lemon@gmail.com>
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
index 41fcfdb24a81..01632d3ca1f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13890,6 +13890,12 @@ F:	Documentation/devicetree/
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

