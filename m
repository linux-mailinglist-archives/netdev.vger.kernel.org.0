Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A5424EA66
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHVXUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgHVXUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:20:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031FEC061573;
        Sat, 22 Aug 2020 16:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8sDcbx6ET5LsLHs28DzlqTG03lhMvq/QOg1sev/yQ9o=; b=cB/+VEXEnv7glpnFNNkH6jCMi5
        MXWa46Bpq41c+maCXRpVSYfNzdF7MRNInS/GZWcE6zLqssfegCzKwfvmiCvBPTe7XhvPNHdaBVnGe
        LjRBPOkk2Ts3BaLM9I5y5bbtjkdde4bkuX/E+ftYfJFFBMHNxbSGn16rNM1hPD3IO7GcWqhq8Lvtd
        ASSOEjGHER7ytH/MIeRitQMaGVZaaNk2sRXQwW0z4RIr2oG8+zeN40CoGcXAG4xYaDNrMsNapCelP
        plCirbKUSDtILSB/wvQ02nVJL+rBe8KZQDapHCbyse8legEp1ETMxqWqWXGKOifQX4k1ptCzoBy1G
        XvUp1ClA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cnu-0006fS-Ka; Sat, 22 Aug 2020 23:20:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 4/7] net: wireless: reg.c: delete duplicated words + fix punctuation
Date:   Sat, 22 Aug 2020 16:19:50 -0700
Message-Id: <20200822231953.465-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop duplicated words "was" and "does".
Fix "let's" apostrophe.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/reg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/wireless/reg.c
+++ linux-next-20200731/net/wireless/reg.c
@@ -1594,7 +1594,7 @@ freq_reg_info_regd(u32 center_freq,
 
 		/*
 		 * We only need to know if one frequency rule was
-		 * was in center_freq's band, that's enough, so lets
+		 * in center_freq's band, that's enough, so let's
 		 * not overwrite it once found
 		 */
 		if (!band_rule_found)
@@ -3167,7 +3167,7 @@ static void restore_custom_reg_settings(
  *   - send a user regulatory hint if applicable
  *
  * Device drivers that send a regulatory hint for a specific country
- * keep their own regulatory domain on wiphy->regd so that does does
+ * keep their own regulatory domain on wiphy->regd so that does
  * not need to be remembered.
  */
 static void restore_regulatory_settings(bool reset_user, bool cached)
