Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBD52212BC
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgGOQnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgGOQnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3305C08C5DB;
        Wed, 15 Jul 2020 09:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1H67JLa3OhCmCEiB5og4f4hrv4P2Ww7sFHHuQlDAnr0=; b=Xjs6qZ+ocfC1mJAAJ5VWFGbhXe
        ZlQo2Hp5aZL+/ybwm5zfjoGj2QK6JoXNx2Otk4UKbmQXci7knaRyLJBjkpU3JPLDjn502PARd2PqB
        mTwEwO2qq6UpI1wcp9jtoHj4v5ZaQOYf6pa8onrI/ycIsyxghjy3iKHiyF7zaQMdTTujDTiCwfF6F
        PENgiXLuwioxp7AqHdzWzr4hXQC5IcktguHDVGzey9W50z1HOf7btCRyvkiWuk7vMbDg6hpnNILvN
        PIeQnBy6jb2PmEmxQotvutw/71/00f6dOani96QSdCAoEdn/FuipoovFCOmrzoiXc2AH5EVW2efBn
        dZHznUMQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkVG-0000EP-7e; Wed, 15 Jul 2020 16:43:30 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/5 -next] net/wireless: wireless.h: drop duplicate word in comments
Date:   Wed, 15 Jul 2020 09:43:22 -0700
Message-Id: <20200715164325.9109-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164325.9109-1-rdunlap@infradead.org>
References: <20200715164325.9109-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "threshold" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 include/uapi/linux/wireless.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/uapi/linux/wireless.h
+++ linux-next-20200714/include/uapi/linux/wireless.h
@@ -914,7 +914,7 @@ union iwreq_data {
 	struct iw_param	sens;		/* signal level threshold */
 	struct iw_param	bitrate;	/* default bit rate */
 	struct iw_param	txpower;	/* default transmit power */
-	struct iw_param	rts;		/* RTS threshold threshold */
+	struct iw_param	rts;		/* RTS threshold */
 	struct iw_param	frag;		/* Fragmentation threshold */
 	__u32		mode;		/* Operation mode */
 	struct iw_param	retry;		/* Retry limits & lifetime */
