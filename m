Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D16301331
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 06:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbhAWFMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 00:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAWFL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 00:11:58 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A441C06174A;
        Fri, 22 Jan 2021 21:11:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id m5so5158985pjv.5;
        Fri, 22 Jan 2021 21:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BgyIeh58D93pJvM3haaFS5xnKvaiUdCpe+YJAVdakLQ=;
        b=bFdHJ27IhGNVLvmyN7ew8pAZGxWjXBtPFmfo7ptvfCZw6K5RMXA9fL+qKm0aLCB2W5
         1xaGw2Zz5RfOPfoyfU2zPK7aK2oclqFb5wbvrF3v433/I3Hz5JY8ZQjEuQrnXxZMTSI0
         0cC3u74hDYyusIMYuTUzqy9hCuEv34TuaMwivVc8NQjPiRxuDwCZ9Pkexq4h3tUd+iEM
         KGSCpx6QicH8KQgkzkAK0AwPO5/F94bDTXHBgJA7iimDuhKdz6qCSOLRyXDvcMuyYQR0
         HqoFngNyNpOIelzl8t7GfFIS4d9slZL1iFTNZSBwcXEsbJY/vJtH4OsF0XGfUPp5lngY
         iOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BgyIeh58D93pJvM3haaFS5xnKvaiUdCpe+YJAVdakLQ=;
        b=RphAEv8ab6/t7aFpBn4Wt6oOu4n6RJ1eqrP3zk7I8ROfmT3/VQQ/39SWnjqM1HK2Qp
         fVqy9FUsDxFy791IHW3jrRDWf/f69ZFVfrX/2Cl3cUfakv4cjOFP9vjms+llLA9Db9OU
         eeo/TjRIboDKe5cBxJOqa+37hwkxrvFVEyFVTVkB6n4rXN3/6YGXqRj+bCcWZDxTekMx
         cixFrTU/oD5LX8qpzLvyRvV+jNOeD5EV27NTf70bOklhx3Mn8mib1ceh0h26bsRdOCDn
         ArAaQOonGOUMIwuksM+ep5z4O5j4HNl5R9gtuh4a46J662D0OT18HSnSSqnwd2X7VEci
         pEOg==
X-Gm-Message-State: AOAM533KWVUMS3hDpu9NQ4bLhHWq7RzDuAk7HdCyJCmjQo/5j5jVrg3X
        sKOxaZq3WtP+cXPcf09Gw9g=
X-Google-Smtp-Source: ABdhPJwtP0WP4mmJVtoCC8zK1lggz413w13RIGL4R0CuHAbwCbDf/dPIYt+cQpA3gnCEUbPLKozogg==
X-Received: by 2002:a17:90a:380c:: with SMTP id w12mr9165252pjb.117.1611378678042;
        Fri, 22 Jan 2021 21:11:18 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.76])
        by smtp.gmail.com with ESMTPSA id q9sm10155791pgb.82.2021.01.22.21.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 21:11:17 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] usbnet: fix the indentation of one code snippet
Date:   Sat, 23 Jan 2021 13:11:02 +0800
Message-Id: <20210123051102.1091541-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every line of code should start with tab (8 characters)

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/usb/usbnet.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 1447da1d5729..305c5f7b9a9b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1964,12 +1964,12 @@ static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 			      cmd, reqtype, value, index, buf, size,
 			      USB_CTRL_GET_TIMEOUT);
 	if (err > 0 && err <= size) {
-        if (data)
-            memcpy(data, buf, err);
-        else
-            netdev_dbg(dev->net,
-                "Huh? Data requested but thrown away.\n");
-    }
+		if (data)
+			memcpy(data, buf, err);
+		else
+			netdev_dbg(dev->net,
+				   "Huh? Data requested but thrown away.\n");
+	}
 	kfree(buf);
 out:
 	return err;
-- 
2.25.1

