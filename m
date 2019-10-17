Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D16DB5E4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441364AbfJQSWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37617 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441354AbfJQSWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id p1so1825002pgi.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9tU3y9H0LtVtIZJy6MO193oDf1hI1oOe+Qi92cHZmX8=;
        b=rbFe67nkoC8tv2R2qx9Wr3+0YkDXOM344z7qMdkwyHzskkiWRgMyZwHIvt377rEc4H
         2iBKe0QlPYyFuOxxl8Go4N86Vmykt2oSF2dreDUWixL1AGiVe0ecp85NZ/LuPICSa2PV
         DObWiF4od1ZRW7AvoBcr8Eq8VReFLLoJbVvJ0wI2+JgzyxbPbijtksy4EHNSVZ7zRFAH
         JbhcbeMmFCf8Si2m7UkCXn0o5+7LV4pHd9Ma+5LD/2SaGkejAMnCslV8eAyQps4LAhLW
         NiCwo9vXpgM/DThahObw8FGboOpPUhgN1Hz+whnz/nPM8HNVAvbf4eCXqYV0UB0vu9iQ
         fpiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9tU3y9H0LtVtIZJy6MO193oDf1hI1oOe+Qi92cHZmX8=;
        b=JyRm3uaFC/bTZYMgon7Z4eL6nzGv3BeHOGg3f/xjbn9das1KEiucefqgxDPFMPUTS1
         HGQbPmLLwgILB8MQvpz3+4z9VS7ezk1tALfe8JKjL1iGAKNRkuVFbARKhQOYUWpRW2Pk
         1d/wVuGi2Sg+0c7x/NjXQx5a70od0M46o3efwf/MdyAuaBRB9QVKB3ZvhCTssAuR2H+b
         nJ5cVHvL669bU1Qn557YlfecqSiS5bnAasw9HIJ0hcJDk6/wYQS/bStgrVOCgkg9cXY/
         Bhu/q34aIYyXyuv5UT7RoJk1E1RI25zKSXzztsowJT5Jy67vKPxqxTeF9DoATHeOi+qz
         kRGQ==
X-Gm-Message-State: APjAAAUyKuV16vFLxuuLaK9DseROoanTWlSMvI3DuXmNly2HFGvbB4Yp
        LbruAO5EWzI2MUwbFheU0l2tKExE
X-Google-Smtp-Source: APXvYqyGs7J9/beU5RgNG0QpPgnfqDHmIy4fGNnQj+i2JBB4JdZJycgWn/kiDI8OjXc+ObuVJpK3ug==
X-Received: by 2002:a17:90a:a783:: with SMTP id f3mr5818703pjq.25.1571336530280;
        Thu, 17 Oct 2019 11:22:10 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:09 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 24/33] fix unused parameter warning in e1000_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:12 -0700
Message-Id: <20191017182121.103569-24-zenczykowski@gmail.com>
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
  external/ethtool/e1000.c:368:41: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  e1000_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ib0bf9e87137f256adf6e93f90d7f9426ab376a52
---
 e1000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e1000.c b/e1000.c
index afeb7f8..da057b7 100644
--- a/e1000.c
+++ b/e1000.c
@@ -364,8 +364,8 @@ e1000_get_mac_type(u16 device_id, u8 revision_id)
 	return mac_type;
 }
 
-int
-e1000_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int e1000_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		    struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u16 hw_device_id = (u16)regs->version;
-- 
2.23.0.866.gb869b98d4c-goog

