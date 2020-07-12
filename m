Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6393521CC0D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgGLXPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:15:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728547AbgGLXPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBu-004mRA-Qz; Mon, 13 Jul 2020 01:15:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH net-next 19/20] net: wireless: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:15 +0200
Message-Id: <20200712231516.1139335-20-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/wireless/reg.c         | 4 +++-
 net/wireless/wext-compat.c | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0d74a31ef0ab..35b8847a2f6d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2384,7 +2384,7 @@ static void reg_set_request_processed(void)
 
 /**
  * reg_process_hint_core - process core regulatory requests
- * @pending_request: a pending core regulatory request
+ * @core_request: a pending core regulatory request
  *
  * The wireless subsystem can use this function to process
  * a regulatory request issued by the regulatory core.
@@ -2493,6 +2493,7 @@ __reg_process_hint_driver(struct regulatory_request *driver_request)
 
 /**
  * reg_process_hint_driver - process driver regulatory requests
+ * @wiphy: the wireless device for the regulatory request
  * @driver_request: a pending driver regulatory request
  *
  * The wireless subsystem can use this function to process
@@ -2593,6 +2594,7 @@ __reg_process_hint_country_ie(struct wiphy *wiphy,
 
 /**
  * reg_process_hint_country_ie - process regulatory requests from country IEs
+ * @wiphy: the wireless device for the regulatory request
  * @country_ie_request: a regulatory request from a country IE
  *
  * The wireless subsystem can use this function to process
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index cac9e28d852b..aa918d7ff6bd 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -220,7 +220,6 @@ EXPORT_WEXT_HANDLER(cfg80211_wext_giwrange);
 
 /**
  * cfg80211_wext_freq - get wext frequency for non-"auto"
- * @dev: the net device
  * @freq: the wext freq encoding
  *
  * Returns a frequency, or a negative error code, or 0 for auto.
-- 
2.27.0.rc2

