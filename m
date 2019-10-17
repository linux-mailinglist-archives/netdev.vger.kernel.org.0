Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC17DB5FF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438700AbfJQSWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:52 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44773 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438745AbfJQSWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id e10so1805325pgd.11
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fgQgMtCVV6cchTZgkFigKjnYjdMiSgMDX+XT7ZI1Z6o=;
        b=VLIDjCRbbcNLITuhw17/723rQdiNqE0p/0Q+nw3krhLNB/86JIPy29T0jcHc/h3iF/
         3JDVH/3/OmzJjAsC8W4Vlp6bGZcVHfgnXSeceXFwQzGywcETQW404A3m5zalCl8KNKsW
         PqyPrGWeQf9pk2GgRWUyvX25O5IrniKeDpTAGee8f/93AXvPfTvj0iONOLJjXDgJvFxC
         JLLNpRdk9VgVQgLooxN7jS1EkY1zKxg7CU1eyr7smQbQR+rHXVP9iVjh0I6yEkOx6jnk
         42PYPRGoFAJZR6vp4cH99s+vmd4/JKRlioVefTGC1QXW0m+EoRaV2Yeog5j2zp+KtXKY
         fkjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fgQgMtCVV6cchTZgkFigKjnYjdMiSgMDX+XT7ZI1Z6o=;
        b=K98Goh3foXphyL3+gpUYCUl10XIYdToeZQQ9fJCwjR8p9gBqxt2Xuwe/iCrAIkng5F
         yf4rqAxzc9/1OlO7elVm4BxhiWfeVuxPhOx3ehVcctQ2vQMtg3AAHwmeR1kPbVVuRyLg
         s47QgyZztZ7S83CnLVKmb/ylNWvK7GBAWUnBU2K1k0AVDXpFVNflF4AAp+YpsYNvHp7Q
         PPd0YpQ6VrjYehguewt1uCx4uh2Dff44Flm7xpvrupbOXkNHV1ps0lQFV/A8bEUDMzOy
         NslVUD75d5Ziy1NTyEfDhAmCeqDNuD1MRIvxdA+oNDjFYFkeKoBDpx/0Wbuhom71ROww
         J2gA==
X-Gm-Message-State: APjAAAVF2zOrHzZiKPuSvwCAvF4tEdBbAqsYc2KHvLdTTNwfTddBC2nh
        AB1wFtM0Ed254sl/k0pAXq4=
X-Google-Smtp-Source: APXvYqz/KkpFGyonkjGpjiJJEjU0u7q0/ctjlKQ8ArdHK7pS+k7O0hjaAJQMqPphkX1TJPyXF3Da5A==
X-Received: by 2002:a63:f904:: with SMTP id h4mr5631612pgi.80.1571336528818;
        Thu, 17 Oct 2019 11:22:08 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:07 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 23/33] fix unused parameter warning in igb_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:11 -0700
Message-Id: <20191017182121.103569-23-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/igb.c:92:39: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  igb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: If2e175d1b1bd3976d760dc359b52c304e8334f92
---
 igb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/igb.c b/igb.c
index cb24877..89b5cdb 100644
--- a/igb.c
+++ b/igb.c
@@ -88,8 +88,8 @@
 #define E1000_TCTL_RTLC   0x01000000    /* Re-transmit on late collision */
 #define E1000_TCTL_NRTU   0x02000000    /* No Re-transmit on underrun */
 
-int
-igb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int igb_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u32 reg;
-- 
2.23.0.866.gb869b98d4c-goog

