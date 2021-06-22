Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC593B071D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhFVOOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhFVOOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:14:32 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E438C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:12:16 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p8-20020a7bcc880000b02901dbb595a9f1so2359215wma.2
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=RuFI+v8WYck7x4OpSOuBZ+EbGIC+RAiiyv2KzvT5jfc=;
        b=G+Zf9+8i1jIdgmnTTSbvMNgSMITpTo8LgEt/WXGYSFrpiKGpTyajhdAVJ869U22gDL
         Ceh279ck7kuOkaqU0qSDECBp+0b8nIdVtBQOLzcpyl1AOlyBwkd8hi+ENO5Pd8O62iy7
         ah0tRo9zJbXwBhnaC9VbVkKzfTVsMspg0xiBc2rTwNSGr7+5CoMMye0Xh7f48m/2fbi8
         OljUVmjGbsWoBf8bDKrL+4uzQxUOUuErIeeu5ODopgUHDef/iu7mkwyVfhWRRM94axjS
         zy9EgDepF31aTY5lkDe2MDuREsE0fTRxbnIUxoqhxaXsPanizfBwfMh9hPR1LwznuYEz
         gJgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RuFI+v8WYck7x4OpSOuBZ+EbGIC+RAiiyv2KzvT5jfc=;
        b=oXFb8gIyhFEkkV2epEFuFwHnNSN91JmYvfU0/5pl5KmoMh3utkmheHhQGj/lJBAC6f
         M3HkiLDCBDpIv3WgNh4e/t8ClgiobAhuVz/KuB2Pw/7QiLu5v7r1NBTgYgNNn+zyoNsv
         p2ZfP4xnJAtg6QHtzyJRHd8lNj45ktcA4HbmsPRFifBPGDxTtZ8DDwneu5NxzSgPXlfG
         7OiR5Gyp8IRxLPlbtZ2qChbdTabFq5UDZ6yIsqjhqaHZqxFjZRPkU7rIOpWX383hVkKh
         epz/UCQC7Etn2HTLDLoUsUgbhQ2SpcqQy9hsd2Zf07S3nJmsGXutzWEmUhtAFes1Jt4N
         zu4g==
X-Gm-Message-State: AOAM532pB4WLEd8xXEQpqqNgzkur/LlkJtYS6qKDhH65nEe1L7eBmV9T
        KqSQjqiMUAIUU8JenFlKkXQoZQ==
X-Google-Smtp-Source: ABdhPJztKAqJ75hrczwdf4hC9Zmr3SHb0eGA/dDaIw0ucmYmXqG7wPmkWiR2UN5hlZSuPaq0Pj3E+g==
X-Received: by 2002:a05:600c:2e53:: with SMTP id q19mr4904295wmf.39.1624371134874;
        Tue, 22 Jun 2021 07:12:14 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id e11sm610351wrs.64.2021.06.22.07.12.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 07:12:13 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] MAINTAINERS: network: add entry for WWAN
Date:   Tue, 22 Jun 2021 16:21:40 +0200
Message-Id: <1624371700-13571-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds maintainer info for drivers/net/wwan subdir, including
WWAN core and drivers. Adding Sergey and myself as maintainers and
Johannes as reviewer.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 395b052..cc375fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19803,6 +19803,16 @@ F:	Documentation/core-api/workqueue.rst
 F:	include/linux/workqueue.h
 F:	kernel/workqueue.c
 
+WWAN DRIVERS
+M:	Loic Poulain <loic.poulain@linaro.org>
+M:	Sergey Ryazanov <ryazanov.s.a@gmail.com>
+R:	Johannes Berg <johannes@sipsolutions.net>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wwan/
+F:	include/linux/wwan.h
+F:	include/uapi/linux/wwan.h
+
 X-POWERS AXP288 PMIC DRIVERS
 M:	Hans de Goede <hdegoede@redhat.com>
 S:	Maintained
-- 
2.7.4

