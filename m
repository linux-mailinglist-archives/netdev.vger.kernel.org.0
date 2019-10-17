Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37ACDB5E7
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503256AbfJQSWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:18 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43158 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503219AbfJQSWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id i32so1810229pgl.10
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SfWTduOZgQlf+4/OVaL191bW8TZVC7mzl+M7vZww7Kg=;
        b=I0Em0kUABWuWzxwUhRw2AYZx6KG+ZIWbVVqmA8AwsCPPMtpq40+w8Hvtjhg9pAJ/wf
         nwePOEF0jlj5z+Jx83QJY46Gt1KyRdLY89eunjU7qDpKTYTc4tP1su/uoCiZPjYtgS8K
         Y0zIqxBXEb5tU5LRQZyO2BNjWvpMFMa3lKKQseQ4zY4mdqLgBY02nCyFO2DWuuF8nBhF
         neRgz8sQ9CD6OgiQxj/b78ub+9mHtzGQRFngLQ0A5NBnb6exGABgLyLYOdkBPxpC+7pt
         YC6QnzG+u0F8iEAwU+/5ymi+7GkgaI9RDuWga+5VaFGOjpWgnn1s+JQjevi459Uep9Bm
         hGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SfWTduOZgQlf+4/OVaL191bW8TZVC7mzl+M7vZww7Kg=;
        b=kCgIIqBHBHP+qbxMKquxmlCB0wRcPm3qjoW5vGM5/pkLbBkxP/YGxP+LwaoMPyKKs5
         H6L+07c3VAVlfRs+a4oRwiR4MVmpjmduaVOxTLgG6D5l03Gi7mI3csOekmYX3LObL/7l
         EOYfIUlS4v/QJD4wulP37p4B7W6VJm9JRtaSvSc65W88CeRAHUbplnlH8UdCbiOTyDGi
         saXP0E4usSuD00wiVFguyk672MBDP+NzafYG9wxmGY/XAB8T9wK8+oVUre9RR0AgVIH9
         AJNKdF746an6ufUeylRDi1LKoL55o91Qi3uMXCmBnl3Gm9JaAI/vm/bkY0Y4CSFTL5Qe
         vf0Q==
X-Gm-Message-State: APjAAAVLFlqvIrNnElEUqF81D5LZOTO2rZ6wZ8/e9w4tSYS1K17FEJCt
        hVWJqMfvwdKIL6u056TvEVs=
X-Google-Smtp-Source: APXvYqyonmwPgD2Tyv/CZhQueqKO4P9Jt6iZ8HooLTKk3mtoBuHPW2HvAex610M1I90Cm7o4eYqOLQ==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr6273751pjn.128.1571336536486;
        Thu, 17 Oct 2019 11:22:16 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:15 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 28/33] fix unused parameter warning in amd8111e_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:16 -0700
Message-Id: <20191017182121.103569-28-zenczykowski@gmail.com>
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
  external/ethtool/amd8111e.c:155:48: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int amd8111e_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I885d775f4b56f75b8f5bfa2abefb00af5abd9f95
---
 amd8111e.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/amd8111e.c b/amd8111e.c
index 23478f0..5a056b3 100644
--- a/amd8111e.c
+++ b/amd8111e.c
@@ -152,7 +152,8 @@ typedef enum {
 #define PHY_SPEED_100		0x3
 
 
-int amd8111e_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int amd8111e_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		       struct ethtool_regs *regs)
 {
 
 	u32 *reg_buff = (u32 *)regs->data;
-- 
2.23.0.866.gb869b98d4c-goog

