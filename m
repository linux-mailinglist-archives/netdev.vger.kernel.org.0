Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4CD33065B
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhCHD0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhCHD0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:26:04 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8842C06174A;
        Sun,  7 Mar 2021 19:26:03 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h26so2209679qtm.5;
        Sun, 07 Mar 2021 19:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LziXrTIHxhFuAQv8fGFAIOjkYK0Uv1eKpTDXXFAhzj4=;
        b=oQnwL3XtyAv+xV0Nocjhh6j9yrhuVZ+y+TPYh/64X7nbxEI47o/yi40iDLHmRxTAOT
         t7bM06GTAMNjz6s7ut1QhyoaAnkfTVuog1e+/z1b4aEhBSkL2Oqv/vRqM80qfTZ5AEie
         BnzoemEUFuAqquw/bm6alTP7CHF2E9110aAJ/hAMTHP2/FQpFFMQiawlkSMDtynmfk7/
         qwJ5+Zetkr9gAP0WGx7PCgbMszHjUJb5BhptihLC8NTYMU5ZlQxhT0kIgCFd9Gsxloy1
         A+BipMHAmlRQJIFzV5f/EAllo+wpqPBMSYznDInrQAAHJi3BLTqUvyo2/Yf+iPcjD5cf
         nkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LziXrTIHxhFuAQv8fGFAIOjkYK0Uv1eKpTDXXFAhzj4=;
        b=L6dxuO3fjCJ38jPQCDk4rBcG8VV2rbyR0gBCgztRvZ/3cEFbbKxxpeBnRWnMGctiAF
         gaEtQWkULmdpMVQ3V9aEJ3JexjBA/k6ppiEj3+Zk+O5ThYCSxssskwvORz8F35UHuIHy
         EfB0q4qAVJhTmBh+H/F/ZxYQxpWawAdDuAzZyBMDjmIHqfBwFBAg3BVjvNzHkYkgIWAj
         U7IoDES7CxAC0a2Sg7eMe6UH1HVo+n9rgUQE7IX4jSg0QgYNLbalCO0qUa0fkVZGOmXV
         VJGHgr81zMCrVa0aKNjWW9O+5ojTD5diGrjP2EPg4aLDgaFVj0WKf7UzOdfK3WjEs2W7
         deyA==
X-Gm-Message-State: AOAM530YeqR7W2NoUyNZ/wi7YvilRB8hw7Ei5to0bYbBigtbD23ZXjT/
        tCTIX9V0zcPnmZnTptGUGRk=
X-Google-Smtp-Source: ABdhPJwxdQHRDuyKR8jdsZVJ9ZEESG4YJBnPBGUGBDoChfowFcC5XsIcEe2JYwJ7R9cqP8pwsMIoHQ==
X-Received: by 2002:ac8:1301:: with SMTP id e1mr10286963qtj.96.1615173963233;
        Sun, 07 Mar 2021 19:26:03 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:99a3:37aa:84df:4276])
        by smtp.googlemail.com with ESMTPSA id r7sm339725qtm.88.2021.03.07.19.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:26:02 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 1/3] atm: fix a typo in the struct description
Date:   Sun,  7 Mar 2021 22:25:28 -0500
Message-Id: <20210308032529.435224-2-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308032529.435224-1-ztong0001@gmail.com>
References: <20210308032529.435224-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_data means private PHY data not date

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 include/linux/atmdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index 60cd25c0461b..9b02961d65ee 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -151,7 +151,7 @@ struct atm_dev {
 	const char	*type;		/* device type name */
 	int		number;		/* device index */
 	void		*dev_data;	/* per-device data */
-	void		*phy_data;	/* private PHY date */
+	void		*phy_data;	/* private PHY data */
 	unsigned long	flags;		/* device flags (ATM_DF_*) */
 	struct list_head local;		/* local ATM addresses */
 	struct list_head lecs;		/* LECS ATM addresses learned via ILMI */
-- 
2.25.1

