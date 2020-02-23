Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00BB169AAE
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgBWXSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:05 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54059 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgBWXSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so7189021wmh.3;
        Sun, 23 Feb 2020 15:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E9qoESjMSRYNcvQKoiebYJwkNHkC7X+DjeOLcXKDFb0=;
        b=kOHPuzo7yRvDL0CSR3L3FVOHcuUyS2HF7lfRacoZjsAC9U55y/H35V4Xz7TMjyCuB8
         SLlg1PzzD6caSS8mC40bWVphpHGUOAsvkGzkg/vv+YutF2pGfcKHsO610FniwwAoo9eq
         NhGPTN6Y4xW2Va/irlLAKt/IfMJ0SxswYZ/kQd482UtNlXhHNl9WoCpNZBSScltJLN42
         cdTV512+VDp6Tg/YzSg0YLBPgsE3K5uQb1UiGtUE6/xcwqxVXuU5eM/l23NHTBABnOXM
         1bGK/92rB65v3G1fRTVyoutXBSXF6EcboYFp3t+c24I8vn0oJfIMbxTOAe2iING4yBEF
         BtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E9qoESjMSRYNcvQKoiebYJwkNHkC7X+DjeOLcXKDFb0=;
        b=NLUHxWfUBcgT0TwMtaEVMItflb7FME8Z1H+CpIIYQheEr/swfW5xh9SFQVjD8ixNXY
         l4r4uaK1oZNkfWd8Tzoo/fTy3OZEq98x7FMYy9iaHzzzszlGYtS4YINGeoPqvvP7zKKa
         voYbbI1pV38A7900pmNvgK+t7XJjcm16zDq6DQkGDhIZh8fRfOE39XLIPVNhBCAv5fbD
         id/NUOpL9vPJTqpoor2btjuSpbvWyiRS9etsXy5SwD6AXwkapaZ2eGr9EWwbY5GsAFvR
         VfnBl9R73QLSLfbGRGZEdPb9RzQE3JRIfPFITJAzspttpLgs2OvHUWkToWIXljTzT85K
         jqRw==
X-Gm-Message-State: APjAAAXWtXpzFNgdxVvZZjHJ0865ppEMj2r4xdCzwlxd60775f7w2sRI
        +tXNtNrBwz0M5bjLJywOcQ==
X-Google-Smtp-Source: APXvYqwkgs56LmghiFd5vgbeFjZ5KlBwjNOKxFCiaACm218hRs56Op9pBLv1+bwyArnr/O1AlB2bRQ==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr19194918wmj.117.1582499881880;
        Sun, 23 Feb 2020 15:18:01 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:01 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:LLC (802.2))
Subject: [PATCH 07/30] net: Add missing annotation for llc_seq_start()
Date:   Sun, 23 Feb 2020 23:16:48 +0000
Message-Id: <20200223231711.157699-8-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at llc_seq_start()

warning: context imbalance in llc_seq_start() - wrong count at exit
The root cause is the msiing annotation at llc_seq_start()

Add the missing __acquires(RCU) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/llc/llc_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
index f3a36c16a5e7..a4eccb98220a 100644
--- a/net/llc/llc_proc.c
+++ b/net/llc/llc_proc.c
@@ -56,7 +56,7 @@ static struct sock *llc_get_sk_idx(loff_t pos)
 	return sk;
 }
 
-static void *llc_seq_start(struct seq_file *seq, loff_t *pos)
+static void *llc_seq_start(struct seq_file *seq, loff_t *pos) __acquires(RCU)
 {
 	loff_t l = *pos;
 
-- 
2.24.1

