Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CBE24EA65
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgHVXUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgHVXUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:20:07 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA36FC061573;
        Sat, 22 Aug 2020 16:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=n0p5iGhWUSGOL3k2alvtEOGSryhOBqldrStK+lXELs4=; b=C5PhS7mKOgpo5YTQOrA5Ge7Y+k
        Qg0LFMnvGZOj7d7eNawuSbLmwbawTa0nzCjRWZEluF4wEx6laBDEYCe586vICghjmHAPv58yElYTi
        eBZQMVMluw6bxz4qctjT7gGoEVH5AyGuj5vEP7NuAKm5h33awcFaDat2nzRcL1IXrdJjNYcAyr/G0
        h1bxulU77MGw46WcPwVK6AIdSSgGLNgaQBtgieQgetwNhU0nXhEOdaUZjvE2S9wqfmYDh2d9aKngY
        D7S5gEEtXHpUFFnsASyDUUf0q+s9fhewCl7gMyWDwuIaWa4LBCq2M1Bpgd6XJrTtb+l4pnGXGvkL4
        9b0ZNH0Q==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cns-0006fS-BH; Sat, 22 Aug 2020 23:20:04 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] net: wireless: delete duplicated word + fix grammar
Date:   Sat, 22 Aug 2020 16:19:49 -0700
Message-Id: <20200822231953.465-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "Return" + fix verb.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/wireless/core.h
+++ linux-next-20200731/net/wireless/core.h
@@ -466,8 +466,8 @@ extern struct work_struct cfg80211_disco
  *
  * Checks if chandef is usable and we can/need start CAC on such channel.
  *
- * Return: Return true if all channels available and at least
- *	   one channel require CAC (NL80211_DFS_USABLE)
+ * Return: true if all channels available and at least
+ *	   one channel requires CAC (NL80211_DFS_USABLE)
  */
 bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
 				 const struct cfg80211_chan_def *chandef);
