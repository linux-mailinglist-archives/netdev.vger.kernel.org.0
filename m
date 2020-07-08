Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6B218500
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgGHKfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:35:31 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:53340 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbgGHKfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 06:35:31 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id CABE1BC117;
        Wed,  8 Jul 2020 10:35:27 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Replace HTTP links with HTTPS ones: ATMEL MACB ETHERNET DRIVER
Date:   Wed,  8 Jul 2020 12:35:19 +0200
Message-Id: <20200708103519.13915-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 617b3b728dd0..cd7d0332cba3 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -2,7 +2,7 @@
 /**
  * Cadence GEM PCI wrapper.
  *
- * Copyright (C) 2016 Cadence Design Systems - http://www.cadence.com
+ * Copyright (C) 2016 Cadence Design Systems - https://www.cadence.com
  *
  * Authors: Rafal Ozieblo <rafalo@cadence.com>
  *	    Bartosz Folta <bfolta@cadence.com>
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 43a3f0dbf857..31ebf3ee7ec0 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -2,7 +2,7 @@
 /**
  * 1588 PTP support for Cadence GEM device.
  *
- * Copyright (C) 2017 Cadence Design Systems - http://www.cadence.com
+ * Copyright (C) 2017 Cadence Design Systems - https://www.cadence.com
  *
  * Authors: Rafal Ozieblo <rafalo@cadence.com>
  *          Bartosz Folta <bfolta@cadence.com>
-- 
2.27.0

