Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58113DB5D7
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503236AbfJQSVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39381 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503222AbfJQSVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id v4so2166480pff.6
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PmgNyGkoGEVdTCOZY2MyyHmw0BW2tuOUF02ixYBVnCA=;
        b=S6Z6+BerrFU16sZoSfoOFchIm/zHQIZGpx1XPb60/3CEcgd1M7G8xSx0E0R2q+Q3+i
         Q9Ph+c7kPVlhuf1/XOjYFvtGCxoYnGigE0IzNYGP24aM62zlkqp0m8X2mAxwW8wVFwko
         GY07+0tATtCYt1veQdvZHEa1ouGh2S2/9kIlGmj7znW4d1hIYNa/mNOzMoIjsj0i8CPj
         2XHU3bS3Ie1PWY8d6+4imD/L4vMgnS2roj0a7Ik8+dtrPezxhIpUaeZGdlSjCRRR9nFh
         MxNh1hGGymVA9Yd9l65/qtuToEhgBl6jtvz+eUOG6E/IPg49QS+1DmHDoBuxaZxC9Rkv
         YH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PmgNyGkoGEVdTCOZY2MyyHmw0BW2tuOUF02ixYBVnCA=;
        b=XFec2hZiQ1lCrgIs/7M7udVafy7I2DuhOuKwjrjaBAl4d+TkNGJ5Zdf/s634l/NUEA
         61bKhexKWcgGfFDlHgAK/nBJJv9aKFEXiKgr2br2D+stOR0nhYLaYFwWPSxD0VmZaMN+
         X5uw6AVW58nZIYxj0ZXn+fv/smIsIIl75P656Y5b36WfPknLke9ptd9+HwPj8f4asVli
         sU+9lUPNguD2PApXmBbyWRs4069URh5I7nsP42SPHu6XLxhJkrpbPvxIQvLTX/Sgh0ym
         9uVeNwfdVR6OVAIurKqYSwM9s1oFHMmigP01t5enu+4x0gld8dY7IkK7Z4LH7yTw2lU0
         gVYA==
X-Gm-Message-State: APjAAAXRiaRbE1EzwofiWN7yHL4BLe5BQywkByXE8sH5cd+fUUDt9l6W
        iTVr179u6l0uwlYuR6I1/Jw=
X-Google-Smtp-Source: APXvYqx7MiJcmz3Z//3YxXJICVwWluPC0lSvj+4Vn7pXWdlnHmnVggPjNto+PCu8CqoTt/JTBsZwBQ==
X-Received: by 2002:a17:90a:db12:: with SMTP id g18mr6037329pjv.32.1571336507444;
        Thu, 17 Oct 2019 11:21:47 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:46 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 08/33] fix unused parameter warning in natsemi_dump_regs()
Date:   Thu, 17 Oct 2019 11:20:56 -0700
Message-Id: <20191017182121.103569-8-zenczykowski@gmail.com>
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
  external/ethtool/natsemi.c:326:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  natsemi_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ib45adc15c39be9886fdc77ee488aba6b67726096
---
 natsemi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/natsemi.c b/natsemi.c
index ac29be5..e6e94b0 100644
--- a/natsemi.c
+++ b/natsemi.c
@@ -323,7 +323,8 @@ static void __print_intr(int d, int intr, const char *name,
 } while (0)
 
 int
-natsemi_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+natsemi_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	u32 *data = (u32 *)regs->data;
 	u32 tmp;
-- 
2.23.0.866.gb869b98d4c-goog

