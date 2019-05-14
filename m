Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F08B21C595
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 11:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfENJDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 05:03:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40444 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENJDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 05:03:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hQTKz-0007GC-BY; Tue, 14 May 2019 11:03:05 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: Orphan the subsystem
Date:   Tue, 14 May 2019 11:02:31 +0200
Message-Id: <20190514090231.32414-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Samuel clearly hasn't been working on this in many years and
patches getting to the wireless list are just being ignored
entirely now. Mark the subsystem as orphan to reflect the
current state and revert back to the netdev list so at least
some fixes can be picked up by Dave.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 MAINTAINERS | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb9f9d71f7a2..b2659312e9ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11028,10 +11028,8 @@ S:	Supported
 F:	drivers/net/ethernet/qlogic/netxen/
 
 NFC SUBSYSTEM
-M:	Samuel Ortiz <sameo@linux.intel.com>
-L:	linux-wireless@vger.kernel.org
-L:	linux-nfc@lists.01.org (subscribers-only)
-S:	Supported
+L:	netdev@vger.kernel.org
+S:	Orphan
 F:	net/nfc/
 F:	include/net/nfc/
 F:	include/uapi/linux/nfc.h
-- 
2.17.2

