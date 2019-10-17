Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3BDB5D8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503241AbfJQSVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35197 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503219AbfJQSVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id p30so1835367pgl.2
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4nSNyM2AtfrZi12U+hkUFf9xOCHGDC7XH92ZPAbwdGE=;
        b=QBkr9H3PmNoSHCvkwPFpcTK564gLbs7lEhYX9dG3hB16WgtaJ8Ew5k8lP+A4E+Z6rE
         htdQ06w9/MudL2M3mE012n+eI4TS76piCOsfcl+h6G8eF5WgL3FhBRU2CQdoZ8bR6mNd
         X5vnHHuHXnrUkq0HwT3LH27D3B/JrFG+SUVv3RNo/oJxNVnbgNJLcQudd+QN58lRlIVq
         9uDhUCiRjSCFz3CqSaqF2igPhaNBoT7/mVKQxn7dGJQfjDYxU3+iXX+SJIqC1oOD8TgX
         bfeh0S+LwNAbQiZTmqxX2Hl6Y2uf8GXhND9flkfgUbE/91a9O6g1ettl7o49mJiAOZFW
         86pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4nSNyM2AtfrZi12U+hkUFf9xOCHGDC7XH92ZPAbwdGE=;
        b=Hdly8ItBfReNsi2QErjR3gpiVh91mRcZgXq78FP01/ugXtLdMx51iLMmrIm9BX+2LE
         SbWhc1waU1aVy6GKaMtmzNuf3gToJe+z4I+dAjfAuFD29Idf32WoSWEgtPaE/xbB1nYx
         A/eT/y7o0GA/kiEUlVP7itqdgmNe2weRJAmZwis1tnffBOJ4rwPNSjkFmtts8jqT+NOD
         wvCVeOv1F5GQsH4dekcOIGm3rB6PBOUHFimzJeOuSlb4pKChPkEuLWN7WP4noquEm4QD
         GfMgwVVSDnfdLNvmKcHt4bHSsMpkgSVq+4j+yMwcmNCE2k0dh5FsFmZQVRW6WixSEH09
         r/cQ==
X-Gm-Message-State: APjAAAUOrUdo6duG72IWjkB135wqX9aaWiJJ1nYrFGI32dRcftP/RrBZ
        kSCT9NqINxl3oBXXjqNOlXg=
X-Google-Smtp-Source: APXvYqzGMaCv+ZWbJlsombbJ/wxv/XDjmXAEk+zV80HjoUZoL4X17Zs9o7C3Ei0CDQevrr3ecngtJA==
X-Received: by 2002:a65:4c8b:: with SMTP id m11mr5821513pgt.25.1571336511236;
        Thu, 17 Oct 2019 11:21:51 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:50 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 11/33] fix unused parameter warning in realtek_dump_regs()
Date:   Thu, 17 Oct 2019 11:20:59 -0700
Message-Id: <20191017182121.103569-11-zenczykowski@gmail.com>
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
  external/ethtool/realtek.c:244:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  realtek_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I62fa7dbb66d5ae545272b41538198787dbbfbe25
---
 realtek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/realtek.c b/realtek.c
index e437466..d10cfd4 100644
--- a/realtek.c
+++ b/realtek.c
@@ -241,7 +241,8 @@ print_intr_bits(u16 mask)
 }
 
 int
-realtek_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+realtek_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	u32 *data = (u32 *) regs->data;
 	u8 *data8 = (u8 *) regs->data;
-- 
2.23.0.866.gb869b98d4c-goog

