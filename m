Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E4424EA6D
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgHVXUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbgHVXUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:20:16 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE67CC061573;
        Sat, 22 Aug 2020 16:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=dQqjOIWCPu934+wIYtojwVYSS4Jg4qt14CP2WUE+w6o=; b=zbP4rpjxBXIHZxvdahRbaBoY6W
        TMuzrBxnCER7b0tWQO6UgHtPmrw01Mt/x/SiKFEwSCMi5ovvmAktPOuEXUUnqQIthPFYhX+7UGOT7
        d08D471+16pusDroRYoX9MZNTA8x2c1YQPiIZY52u5BLmz5EN/aoHxAztUu+m1iGD6JKS/S/UwRkp
        7xgv5BUhZjCplqmB/7sS449G4u4CJbHmtSfCjZEoMCegtr/3Gp+K+pMWCPdkXAPc2nCZO3lFa+kbE
        O2p/gl5kndn64zAntYBMVRw5U02WL4hu5zseab47RTW7CnGdHgOHKwQPO3nidSaHwdY82HuQyrmr3
        ZXDypRoQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9co1-0006fS-JM; Sat, 22 Aug 2020 23:20:14 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] net: wireless: wext_compat.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:19:53 -0700
Message-Id: <20200822231953.465-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "be".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/wext-compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/wireless/wext-compat.c
+++ linux-next-20200731/net/wireless/wext-compat.c
@@ -497,7 +497,7 @@ static int __cfg80211_set_encryption(str
 
 	/*
 	 * We only need to store WEP keys, since they're the only keys that
-	 * can be be set before a connection is established and persist after
+	 * can be set before a connection is established and persist after
 	 * disconnecting.
 	 */
 	if (!addr && (params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
