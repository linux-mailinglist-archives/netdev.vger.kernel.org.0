Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87F426B5E6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIOXx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgIOXxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 19:53:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E348A20809;
        Tue, 15 Sep 2020 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213981;
        bh=Z6lv7rGj6RRAUhAA0eR8FrsBXGgpmjKJA4K97EO5Ue0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+Q/oX/7WD3qoRlXOh1E5784umDwhoDxlAYDD9T8NI4RpbkObJomzxGwj8Itu9pjO
         bobzSYUEKUBCOAdXf3c4ZDkKpUJCEujr/9jtES06b1qRo4P3FtC9C9RwPfImJrAO7a
         GAPvS5QFT9TLPSQJvok3CE4MmkQS0ktlzQI0BSec=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 1/5] update UAPI header copies
Date:   Tue, 15 Sep 2020 16:52:55 -0700
Message-Id: <20200915235259.457050-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915235259.457050-1-kuba@kernel.org>
References: <20200915235259.457050-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 945c5704887e.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 uapi/linux/ethtool_netlink.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index cebdb52e6a05..8d3926c56769 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -91,9 +91,12 @@ enum {
 #define ETHTOOL_FLAG_COMPACT_BITSETS	(1 << 0)
 /* provide optional reply for SET or ACT requests */
 #define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
+/* request statistics, if supported by the driver */
+#define ETHTOOL_FLAG_STATS		(1 << 2)
 
 #define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
-			  ETHTOOL_FLAG_OMIT_REPLY)
+			  ETHTOOL_FLAG_OMIT_REPLY | \
+			  ETHTOOL_FLAG_STATS)
 
 enum {
 	ETHTOOL_A_HEADER_UNSPEC,
@@ -376,12 +379,25 @@ enum {
 	ETHTOOL_A_PAUSE_AUTONEG,			/* u8 */
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
+	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
 	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_PAUSE_STAT_UNSPEC,
+	ETHTOOL_A_PAUSE_STAT_PAD,
+
+	ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
+	ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
+
+	/* add new constants above here */
+	__ETHTOOL_A_PAUSE_STAT_CNT,
+	ETHTOOL_A_PAUSE_STAT_MAX = (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
+};
+
 /* EEE */
 
 enum {
-- 
2.26.2

