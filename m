Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C524EA6A
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgHVXUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728730AbgHVXUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:20:14 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C477C061573;
        Sat, 22 Aug 2020 16:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0wXB/mgeIwbJYY2UNE96VGoeNw63NhFlkhHFN9WE9L8=; b=1Fu3DkI30QaUwOCvEEvpEYo0RF
        Y/GFySs0HzvPs5whIQGpIFcLtxMU3mzDU/KgdNvVgVaZ9RgDdSRZT1aVirQTHgVavFsy8fYId0p7B
        Iu7+ucN8+816Be9wpjXd97WlUlpJsyQj9/N1hkD/2vT/seGCnAzgs/xUhibagzGBCqTTS5fPKh90p
        2D7z52duToGKAClvbvSCTiWcQKb0FqVPYPaxkOgNepWwv7s1jxWXDeWz7hoF44KRGWD0S0uauC7j7
        D9gMRt/vhBw+cdxDLcuhlxpspnG3vQJu0tS+qvKDTQ2JKQ33dclOLSNp+W+ADpe6YM9ff5wEApvGh
        HfNmdjiw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9cnz-0006fS-8m; Sat, 22 Aug 2020 23:20:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] net: wireless: sme.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:19:52 -0700
Message-Id: <20200822231953.465-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231953.465-1-rdunlap@infradead.org>
References: <20200822231953.465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "is".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 net/wireless/sme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/wireless/sme.c
+++ linux-next-20200731/net/wireless/sme.c
@@ -24,7 +24,7 @@
 
 /*
  * Software SME in cfg80211, using auth/assoc/deauth calls to the
- * driver. This is is for implementing nl80211's connect/disconnect
+ * driver. This is for implementing nl80211's connect/disconnect
  * and wireless extensions (if configured.)
  */
 
