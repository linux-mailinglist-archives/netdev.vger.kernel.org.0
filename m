Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7ADB5DA
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503248AbfJQSV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40574 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503229AbfJQSVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id e13so1814469pga.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8KHskF1t3MekkCBhBhFIrVsgjGAzz+ldAM8ovB627Ck=;
        b=m9/TRNS5Pexpj9M0amlYmHSg9TzC5f6xPF+MoRg2/DUWMzwrU7+jJmj1sfouDhQjeR
         wEzwiagqy9u45G24hXEBgqxvHHTGWGv6ChnQzS0c2sehj5OEJPhyatufd7hnTZIiebB8
         W72PDuL4wcoJwO2117r16qDK8u5uRUAjIJtOxvFpYaZmaHMOXfmhiCfBuRPZg6ZKe7cQ
         BC78SPayGsQltuvH0dCNE1wjZBF7/1SF4oNxRFpffe4I7nkxpfoeOngMvle9vpwcQxAm
         Imk4tzZLW44AxZdOdG5426NJVii6gkXrYZOWcRzn5OyTsNhws8wwMnSRO9zNmGaCkb30
         U+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8KHskF1t3MekkCBhBhFIrVsgjGAzz+ldAM8ovB627Ck=;
        b=WBBERM0im8eiTh0wdUR7QFCF0jnEzk3p7wU0fFIbTxW7+27Zt3lAVLLkBAp8w4SdC1
         IH8GPPY2sC160RMDzzgYz2XJjyhjmxcLDXB3bMan/YAN2noaNeBOoyON+X6ucAAEi8JO
         cugGPWNN41Kfa7SiA99yUY7wPqUKGNcbc9/0d0jMdw4egAyKXxYHaEp4jJ8SFPBobXfj
         y18HHPPs6KSC/wxB9ntCOh324WENlKt/+xisIju5cSL8Kn8dGYZoCjf7aZeDor9pbQfS
         rDDsOFT0A3BG53tPYg25JLnlMZbSI64ugTEga1nQf7ihmr5LQehxFGbEma2C4Yw9bv4Q
         NqKg==
X-Gm-Message-State: APjAAAW8/wf0x4oKeJ370tLxvqoZOIkC4wiuc29NkFdy+9sJ7oqKZSNp
        JwgPw1qyBX4kjnodje+v0ag=
X-Google-Smtp-Source: APXvYqyPn6Xw4o8LrMysz6f2848RxoMjCxOKN3H0dRRh8sOJvwWIxvXVjuQQhyhsbBFvRKM22zg7rA==
X-Received: by 2002:a63:1316:: with SMTP id i22mr5890386pgl.238.1571336509824;
        Thu, 17 Oct 2019 11:21:49 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:48 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 10/33] fix unused parameter warning in ixgbe_dump_regs()
Date:   Thu, 17 Oct 2019 11:20:58 -0700
Message-Id: <20191017182121.103569-10-zenczykowski@gmail.com>
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
  external/ethtool/ixgbe.c:171:41: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  ixgbe_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I745f6b9582bc176eafdce9e292a4bf2a951c0c69
---
 ixgbe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ixgbe.c b/ixgbe.c
index 6779402..9754b2a 100644
--- a/ixgbe.c
+++ b/ixgbe.c
@@ -168,7 +168,8 @@ ixgbe_get_mac_type(u16 device_id)
 }
 
 int
-ixgbe_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+ixgbe_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u32 regs_buff_len = regs->len / sizeof(*regs_buff);
-- 
2.23.0.866.gb869b98d4c-goog

