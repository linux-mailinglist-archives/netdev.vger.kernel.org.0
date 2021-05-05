Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE9D37342C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 06:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhEEERs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 00:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhEEERr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 00:17:47 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894D9C061574;
        Tue,  4 May 2021 21:16:51 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id b21so224500vkb.4;
        Tue, 04 May 2021 21:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YRrLwnOYEA84tmg2zHBHzNkOy+wKecAskKm67bwSwqE=;
        b=onQE3U91ERCuu3PL2OXGXlL2WKJzu8RQ7RBjzSnMEXkGcU1aFljk++MdE9mmcIkh5n
         4OlfDAQs3Qb3pFt5q42crM7KClRQIVBnxfYrhklKr5+FoOdCDjW3Mg6QocMmijF9KR+N
         ufRQ0DPii0LAcFs4Qpkedokt7DJ314Tv1F7POs8aAJexI0+eb+j+L8hLvTVtaKiMjZZ7
         p2yjtlsZXqDkUkmbQlCw2KO5RgCWb6LOGl5sHCiqkhEP3UTdp1FeDJfc3wJci7/ULSWw
         DRqpteiduVZ89tuDL0Aj5cSUoyA2cdBZaovu4c2hU6FSwIlmA+Z6Mi/HTrxUMu+qUZfs
         7cfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YRrLwnOYEA84tmg2zHBHzNkOy+wKecAskKm67bwSwqE=;
        b=YHIlIhF/J87uCzXaANcFxKumTxPJy8eWBLTgZIsERNJBJy2Ei3NxET1g2FlDeWnb7H
         Gwjlr6YLpTQ3LvG144HgVwdDRcl7x0XNq3CmBjZ2/hG62phX0o1AtrQewVq9uelX8dzY
         q4O18r0isxoxBSQkPf+lWHyuiK7nca0qnUbdkIc9hI3mGLr/+T+qfBZnjBd0EWpXZuPd
         2D2SYC3rEzuaqMbNXlEucJD0rH25BC7Alhi8JaW+RF7ciXRn+FzrxHnR4czT7Kg/yFwM
         bBqlUnnhMcnJUCXOqU7iv2tdFEYJaw9iBRl7CNgzxD6e6fPDeDyPoNe0FeCGEpovsJXA
         mEuw==
X-Gm-Message-State: AOAM533K1WTHbtQ89ERv9N8UIMOZ8Ng3bwyLPmaTumuDrjeeKOorDuRP
        o8ne3qhYdVRee6sxdGhc2Ds=
X-Google-Smtp-Source: ABdhPJxyjHnyitCFbIaJA/K2U3QKq5aKlqAn1MAZt3HqbNpkLwVyh7cZBKubVpqZUmutcK6wSDhaWg==
X-Received: by 2002:a1f:e746:: with SMTP id e67mr17487157vkh.3.1620188210808;
        Tue, 04 May 2021 21:16:50 -0700 (PDT)
Received: from localhost.localdomain ([65.48.163.91])
        by smtp.gmail.com with ESMTPSA id l1sm646405uao.20.2021.05.04.21.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 21:16:50 -0700 (PDT)
From:   Sean Gloumeau <sajgloumeau@gmail.com>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     kbingham@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>,
        Sean Gloumeau <sajgloumeau@gmail.com>
Subject: [PATCH 2/3] Fix spelling error from "elemination" to "elimination"
Date:   Wed,  5 May 2021 00:16:43 -0400
Message-Id: <f1220eaedbc71ee8d19e35b894c21c161e7a33fc.1620185393.git.sajgloumeau@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620185393.git.sajgloumeau@gmail.com>
References: <cover.1620185393.git.sajgloumeau@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling error "elemination" amended to "elimination".

Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
---
 fs/jffs2/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
index 9d26b1b9fc01..027e4f84df28 100644
--- a/fs/jffs2/debug.c
+++ b/fs/jffs2/debug.c
@@ -354,7 +354,7 @@ __jffs2_dbg_acct_paranoia_check_nolock(struct jffs2_sb_info *c,
 	}
 
 #if 0
-	/* This should work when we implement ref->__totlen elemination */
+	/* This should work when we implement ref->__totlen elimination */
 	if (my_dirty_size != jeb->dirty_size + jeb->wasted_size) {
 		JFFS2_ERROR("Calculated dirty+wasted size %#08x != stored dirty + wasted size %#08x\n",
 			my_dirty_size, jeb->dirty_size + jeb->wasted_size);
-- 
2.31.1

