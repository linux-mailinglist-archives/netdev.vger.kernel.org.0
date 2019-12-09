Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7441178D7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 22:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLIVu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 16:50:58 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34669 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIVu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 16:50:58 -0500
Received: by mail-ot1-f66.google.com with SMTP id a15so13675676otf.1;
        Mon, 09 Dec 2019 13:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O/NLa7LG87/2ajh4S2U01kITyWo4HMhACFw0A24HFMA=;
        b=N7T9TU6wfpVeEE9xx36zwVSppTMWw2e8gt5XhphUSf5cKJiGbOcV+7mbD5Yco3EbA6
         qlSqFlwyLi/vXaNjFgj4+GjgRQNmHTDFNwDe1o5Yh7kUxFDgmL+kgF4PGT+7uqtHzlLs
         w9W1CzutB1TFH3t0W4UsP0nTN3M6HavAFKY3h3iq/dMaJoyN7TBprJSzSs1I8HcGFNOW
         9itE6ES5s1heBuEUf/0BvjgWWos1HQ0ZBgZpHo4Lp9rYW5QfkhvjJqtXhcZe3JlcBG4g
         cyQnty7/gMQA6ot73DECnWSvI6TXTJGKkMUE2PLAg+RQBh4IKWB/Zf3hu2swAl8tZC7K
         nuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O/NLa7LG87/2ajh4S2U01kITyWo4HMhACFw0A24HFMA=;
        b=ArRLwmY5qP3o9K9CJevL3Ne1VeirjxbnQ6dDoa5A5wV3N6ya76F/1hWPF6BccojSeD
         iL4mmXWwsSZHtsCRAbcTifB2emItuOCvMu70lF9GsA+NsaciZC4sT3lw3VMOwwpjj13H
         zYZkNFIrRjFn5uxbTcQ4QV6LJc7mA1t0oWMjnIdeYK0TKvIVb++3AdqpFMCs11Eezsv3
         l5SdLzXDbhjbBhFK+seYCotraZ49cvvQeCnWLfOxKWi/YcKSyRLicrnA9FBlK54a7p8S
         Wq7Y8s2SbxizAwplkyhtlUUkeRlqo/8zqGIyK2RC/szcrAAu9lhmUI2zocHIudZ63SCz
         maCA==
X-Gm-Message-State: APjAAAUxCiDivesEnXUYyN8T3cQKSUo8yTGBbZoAavbczpGJYXErSsrc
        t3VhseEURDOerYg4DA7W5fG8FWazmsE=
X-Google-Smtp-Source: APXvYqzIwTCJYyE3QPvIhgxJ4d2HxrbZsul1UcQgKJpJiopoXeZ60p2+m7cgoOCNdwxxjt/MqERwjQ==
X-Received: by 2002:a05:6830:18e6:: with SMTP id d6mr24252454otf.170.1575928257168;
        Mon, 09 Dec 2019 13:50:57 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 16sm469424otc.73.2019.12.09.13.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 13:50:56 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] net: smc911x: Adjust indentation in smc911x_phy_configure
Date:   Mon,  9 Dec 2019 14:50:27 -0700
Message-Id: <20191209215027.10222-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

../drivers/net/ethernet/smsc/smc911x.c:939:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         if (!lp->ctl_rfduplx)
         ^
../drivers/net/ethernet/smsc/smc911x.c:936:2: note: previous statement
is here
        if (lp->ctl_rspeed != 100)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 0a0c72c9118c ("[PATCH] RE: [PATCH 1/1] net driver: Add support for SMSC LAN911x line of ethernet chips")
Link: https://github.com/ClangBuiltLinux/linux/issues/796
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/smsc/smc911x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 4cc679376c9a..186c0bddbe5f 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -936,7 +936,7 @@ static void smc911x_phy_configure(struct work_struct *work)
 	if (lp->ctl_rspeed != 100)
 		my_ad_caps &= ~(ADVERTISE_100BASE4|ADVERTISE_100FULL|ADVERTISE_100HALF);
 
-	 if (!lp->ctl_rfduplx)
+	if (!lp->ctl_rfduplx)
 		my_ad_caps &= ~(ADVERTISE_100FULL|ADVERTISE_10FULL);
 
 	/* Update our Auto-Neg Advertisement Register */
-- 
2.24.0

