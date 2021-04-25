Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5989636A6CE
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 12:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhDYKzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 06:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhDYKzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 06:55:45 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A39CC061574;
        Sun, 25 Apr 2021 03:55:05 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y1so11777982plg.11;
        Sun, 25 Apr 2021 03:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8uNST6BHrCaJJiddSQkuIrWwpsSi7XWHQYiRIVP23V8=;
        b=c2Uv6NWpPeQoa8IZLobkE6CbRlY7DEvRTtZscWBoNsiytcyOjko5F8V7L4JwcKlvWO
         JueCkgOwXwXiqGtsKUoWZtXXcta8RPjrWi7RuOWdSpiCtpsJN2lcDmhuC9lX6KqMptiG
         8oBzBXOGzVPVDCm6AcSncG8255thxWAM90ZIMA5HnoxsSw4/qqK6rXlEIXa0c3nv3MLR
         H3bwn3MQlso+Tzj5mfvK1ST72RQGPRnkpPE2bxtf4/2+Ug6ezPsusOOqQ2ShIocMh61I
         ndiioqs830wK3bk+VnZr8d5b/aXQzONOg/Mg6wqTayofHIqN9DEfI59A5EEVg8rUVsbo
         kcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8uNST6BHrCaJJiddSQkuIrWwpsSi7XWHQYiRIVP23V8=;
        b=IrKDFmZ8QGsv4K+47nwa0QKNDb9E3G5vaH4sgDFK8SuFjmL/2PAHr8P3oYV7mmDPRY
         4pMjblkD7OyrTOZo7GzGvbOtQUUh18YpqlHC9uZcK54Kdcjft8cJjzShe5fvRu6ODDI0
         +IUNtp1ilK86WE6Af1JaRW+BHZfnhOZTq+669lw069btYXoMNvtAlBVCDdwFXRxifTc6
         TCcyTXEcZfs1KXj+J0G6dHkbkXEieD0p5KFCQRzHEAKpTVSRlzsw0Y8uEx17c0SCiBpa
         5vs94a7j1kFJQCJD5uB5wpokjmTH2i2NjRe1wtfkP495aspGQUi6hskk43gIAD8g2CJu
         tUeA==
X-Gm-Message-State: AOAM533WXASz2e48gg7Vfrhe6j2VztZK5QzvYT/FEYWxH9G2EvQQ5wgY
        ekc5XOdsp7LDQOpUzrTFTLo=
X-Google-Smtp-Source: ABdhPJyaw/z/hF428nIwctpnEi8Odqy/Hv19Oh8WaD8PPzgC/f4QsKNN7dI/472ryyPc5i42N7C2ng==
X-Received: by 2002:a17:90b:1bd0:: with SMTP id oa16mr14578554pjb.49.1619348104965;
        Sun, 25 Apr 2021 03:55:04 -0700 (PDT)
Received: from localhost.localdomain ([49.37.83.82])
        by smtp.gmail.com with ESMTPSA id o9sm9402821pfh.217.2021.04.25.03.55.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Apr 2021 03:55:04 -0700 (PDT)
From:   Souptick Joarder <jrdr.linux@gmail.com>
To:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2] ipw2x00: Minor documentation update
Date:   Sun, 25 Apr 2021 16:24:48 +0530
Message-Id: <1619348088-6887-1-git-send-email-jrdr.linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel test robot throws below warning ->

drivers/net/wireless/intel/ipw2x00/ipw2100.c:5359: warning: This comment
starts with '/**', but isn't a kernel-doc comment. Refer
Documentation/doc-guide/kernel-doc.rst

Minor update in documentation.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
v2:
	Updated docs.

 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 23fbddd..eeac9e3 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5356,7 +5356,7 @@ struct ipw2100_wep_key {
 #define WEP_STR_128(x) x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10]
 
 /**
- * Set a the wep key
+ * ipw2100_set_key() - Set the wep key
  *
  * @priv: struct to work on
  * @idx: index of the key we want to set
-- 
1.9.1

