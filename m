Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6678FDB5E2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503244AbfJQSV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33193 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441275AbfJQSVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so2185244pfl.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fMq41bSv4sgF37OgAvgz74J3oYDyG0Klw5ACFSS7QoA=;
        b=QKcmlDud6UMNmfoDtSVdEmaQaIvgpmJiPyCY079ULld4VVq7cBUrQqDGMFVM6JNrUw
         5r9S0HdUYNzmF+hjWcs94IMaJ4zgI0X8NgTQUVrP71rwlkG5YNHIx9/zCW/7TMXSnTYy
         pNiuU6Mzf9lhq6sCbG9lQcrNtPR+8kdlOXITInTKY9b7gj2n/BRVh9L4n2zsSI3kZ7n9
         e6LT/RrA+lVMSonjh5DV4hN5ZL6EvGvVyF1WM0XXZX39VnVV9cKFUZLh8g/xrVtBorNi
         PA8sPV0lI96F0FTOKwbPGPgCmrC3zTiwuKgu08qrKQIWL80ehZth5sEx2YhiNsbn03Bs
         SiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fMq41bSv4sgF37OgAvgz74J3oYDyG0Klw5ACFSS7QoA=;
        b=IUBitw5HyEi8T+SJgfRe4CEZRiP0BAbSRIYDzJrOmCGpITfndr2jzfbNIO4N4VOqKa
         d1kNNLNJsQoobxlsVCVUHz2NiVLVJhO5O4hTz8XbVAwF1uLtr0GiocC4YpJ6H6Kc4w3l
         HABq/MadmMqzZki2ecY6Exyea89DdNpnmyySZuloyLJHAd2FdLwCOy7fqM67EQFPAnxi
         Xo+/hFkdXCx6K/nFMsmKBx7sk667Vkmdn9hcH7QegJTTsVksOmMI3iXZDvgI+tlJLqWG
         Rdk4LLNS+fmXc7wlpyjwTbKYECbwyOr2HPyx8c3/lSKjFhrCwKLE98d1FkIQDBGqDHGX
         T76g==
X-Gm-Message-State: APjAAAVCTFkqBbAUtHWs7x7ctEJou+HgZFVCj1ZbIe5ldOlp2xdf1T3C
        rWLNW/FEDY4Qy6KtF6BxUzo=
X-Google-Smtp-Source: APXvYqyOcbkc9k+L+3PI/l2Pece8zmeSj/3PqFB1sJq6sgO91SxBQpVWudRhQBBHlQgCkzIdW8+ryQ==
X-Received: by 2002:a65:6091:: with SMTP id t17mr5659075pgu.159.1571336514115;
        Thu, 17 Oct 2019 11:21:54 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:53 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 13/33] fix unused parameter warning in {skge,sky2}_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:01 -0700
Message-Id: <20191017182121.103569-13-zenczykowski@gmail.com>
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
  external/ethtool/marvell.c:262:44: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int skge_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

  external/ethtool/marvell.c:382:44: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int sky2_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Ic60f9596ac59f15d44ebb80f9438c4978f13b48c
---
 marvell.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/marvell.c b/marvell.c
index 27785be..9e5440d 100644
--- a/marvell.c
+++ b/marvell.c
@@ -259,7 +259,8 @@ static void dump_control(u8 *r)
 	printf("General Purpose  I/O             0x%08X\n", *(u32 *) (r + 0x15c));
 }
 
-int skge_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int skge_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		   struct ethtool_regs *regs)
 {
 	const u32 *r = (const u32 *) regs->data;
 	int dual = !(regs->data[0x11a] & 1);
@@ -379,7 +380,8 @@ static void dump_prefetch(const char *name, const void *r)
 	}
 }
 
-int sky2_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int sky2_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		   struct ethtool_regs *regs)
 {
 	const u16 *r16 = (const u16 *) regs->data;
 	const u32 *r32 = (const u32 *) regs->data;
-- 
2.23.0.866.gb869b98d4c-goog

