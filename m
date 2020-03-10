Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D02180613
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCJSU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:20:57 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55113 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCJSU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:20:56 -0400
Received: by mail-pj1-f67.google.com with SMTP id np16so766020pjb.4
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow8rQWON+lM/GCE+L6c4OJn+hW/EZzdWTmlENgYOR8I=;
        b=c9OFRDr+L4jSXVLRQK213F5St8HwVyJ6BBv1SfX/pk5u3H6Vit88DV2q+J/1dPiMv+
         gkhi0+b6na7ahrlid3BJai2KBnPVQN+L5mt0D0z0RwJtOJGgltxD2XMH76rPmy/AlMpf
         FZ0PXP5OxMsNROpgQ59QfW9uI/OrJg+Ow+0j5QK8VdbbLfjBdon39ebpBeaIPfYp3klI
         Zhn1zi9syDlJ/it0RRjFXSYhIpCU6+HGbBQmoYz9quMflEyQh81sbOfUS01AzA3g8fid
         r1myaR5u9oxwXXxkf38yd/8eWGgfmGzuAvNaW6J2s9WrXGPK98aRNVpV3s1makRYP/Xp
         S9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ow8rQWON+lM/GCE+L6c4OJn+hW/EZzdWTmlENgYOR8I=;
        b=D1bqKPddG2lwM9PCQDCSObsXgtyhI5MzQ2C9qDBUo5Rf1akrlF2vo7biFHHmWFqeCb
         yJ+ufh72+zEdACzK930VOkXxahAYWddzBobsEE1DmQ6ou0GnErocl1hzglW2kVtB3ABG
         UPhAM6/8L344npi9MKRsqUByHLgwfJ1PPc/yNF/4Qf0dO1lXfBk5kAGyVLzH7876CABP
         PTWreeHOgLUw8ThGxDfQS78/GN4oujj4VxuOdBJIXsIQEqcUnwPuw+S3svDoUogjBCsq
         a7J5BQTEebDe3jgBO2MKkIdubzXd/9KOgnR0n3Hnl1w6dFF6fv3bHnIzvrdaPtW6m7KC
         Um9A==
X-Gm-Message-State: ANhLgQ1LUIQE7+g7kEVwArjdTa0nrVkD/bM0b6v67W0f6UiG0Zvf4tCk
        NYz5Dwer8hH6XZYYva/m6DRJjT/t
X-Google-Smtp-Source: ADFU+vu+dnsznjgT8LvkFTz/+D09LPVJ9wC8QErq+HebCeY4zPh1nwtymJvs7HK/Aq/XDyzWMic5OA==
X-Received: by 2002:a17:902:7244:: with SMTP id c4mr22231291pll.88.1583864454978;
        Tue, 10 Mar 2020 11:20:54 -0700 (PDT)
Received: from P65xSA.lan ([128.199.164.101])
        by smtp.gmail.com with ESMTPSA id u126sm48296461pfu.182.2020.03.10.11.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 11:20:54 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net
Subject: [PATCH] net: dsa: mt7530: fix macro MIRROR_PORT
Date:   Wed, 11 Mar 2020 02:20:50 +0800
Message-Id: <20200310182050.10170-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The inner pair of parentheses should be around the variable x
Fixes: 37feab6076aa ("net: dsa: mt7530: add support for port mirroring")

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 5e6c778..b7cfb3d 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -37,7 +37,7 @@ enum {
 #define  CPU_PORT(x)			((x) << 4)
 #define  CPU_MASK			(0xf << 4)
 #define  MIRROR_EN			BIT(3)
-#define  MIRROR_PORT(x)			((x & 0x7))
+#define  MIRROR_PORT(x)			((x) & 0x7)
 #define  MIRROR_MASK			0x7
 
 /* Registers for address table access */
-- 
2.25.1

