Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC27E36B9
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503291AbfJXPb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:31:59 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:38440 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503276AbfJXPb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 11:31:58 -0400
Received: from ramsan ([84.195.182.253])
        by andre.telenet-ops.be with bizsmtp
        id HTXw2100G5USYZQ01TXwNd; Thu, 24 Oct 2019 17:31:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNf5g-00079E-Fx; Thu, 24 Oct 2019 17:31:56 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNf5g-00087N-Dm; Thu, 24 Oct 2019 17:31:56 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Karsten Keil <isdn@linux-pingi.de>,
        Jiri Kosina <trivial@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] isdn: hfcsusb: Spelling and grammar fixes
Date:   Thu, 24 Oct 2019 17:31:55 +0200
Message-Id: <20191024153155.31162-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix misspellings of "endpoints", "configuration", and "device's".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/isdn/hardware/mISDN/hfcsusb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.h b/drivers/isdn/hardware/mISDN/hfcsusb.h
index e4fa2a2824af067c..7e2bc5068019eb4b 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.h
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.h
@@ -173,8 +173,8 @@ symbolic(struct hfcusb_symbolic_list list[], const int num)
 
 
 /*
- * List of all supported enpoints configiration sets, used to find the
- * best matching endpoint configuration within a devices' USB descriptor.
+ * List of all supported endpoint configuration sets, used to find the
+ * best matching endpoint configuration within a device's USB descriptor.
  * We need at least 3 RX endpoints, and 3 TX endpoints, either
  * INT-in and ISO-out, or ISO-in and ISO-out)
  * with 4 RX endpoints even E-Channel logging is possible
-- 
2.17.1

