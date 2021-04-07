Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991BC356040
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347659AbhDGAYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236387AbhDGAYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFC46128D;
        Wed,  7 Apr 2021 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617755042;
        bh=l02fQtZslOfLQckk54FKs0twciBkXe1YUtQZOxaKqjg=;
        h=From:To:Cc:Subject:Date:From;
        b=SztRns4UUFmWarpHGNTHqH4sQmhiYAniOKTC5B3zSbqHEUJ/dXW8UTEBdhSWcX8Qa
         CEaugvfubYaZJU6MC0Mmpm5S9hNRhUrSdEiaHY9Jybraohy9h3Ti1jMI7aYd3c7nf3
         IO2506ZS4MRga9AioBgFDPTMuQ3m24Bd0uiSdSmseVJBCY3g4z/f8uoQ6TMEbL/x4n
         oxozAIforqpDCaBw+ysVhmMGx7YQ5SyqHRCoRsn7l6iPFzZB88qBjnbrucququpF61
         wVSb6khq3bTsJfmXCKhnboK7JoaFvw79n4YqJ5NzOtpUE/O9SooT29wd8/jGtppMup
         /vrxVuNuSmpkw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethtool: document PHY tunable callbacks
Date:   Tue,  6 Apr 2021 17:23:59 -0700
Message-Id: <20210407002359.1860770-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing kdoc for phy tunable callbacks.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Targetting net-next to avoid conflict with upcoming patches.
Should apply cleanly to both trees.

 include/linux/ethtool.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 3583f7fc075c..5c631a298994 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -410,6 +410,8 @@ struct ethtool_pause_stats {
  * @get_ethtool_phy_stats: Return extended statistics about the PHY device.
  *	This is only useful if the device maintains PHY statistics and
  *	cannot use the standard PHY library helpers.
+ * @get_phy_tunable: Read the value of a PHY tunable.
+ * @set_phy_tunable: Set the value of a PHY tunable.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
-- 
2.30.2

