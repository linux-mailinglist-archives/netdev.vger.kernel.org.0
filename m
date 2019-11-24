Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC37D1082A9
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfKXJnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 04:43:24 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38466 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKXJnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 04:43:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id o8so769340pls.5;
        Sun, 24 Nov 2019 01:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbURqT/hIwISYpnd7Ewfv41kiT2pdXc627ZF5Jq5I3E=;
        b=kaajpFwknkI67k2TzOc7jKFjJ8P7mC+73sOvyDGVqRHnvtgpYOk73BRc9gBsuZvPnI
         kS9cvvXU6hYyx6irmwTXohLutr5JbXQZTkf+kblZIqJ8As3E2ZbHHGJwaPvgWv8n4IKW
         eOvTuwc9XPu8bPx3y3goeaKPJJ6x45He20aH1bBfXprV7vPAB7wts3tDerb89EPma7RR
         FH0o9mVGnji1fGmgivLVyEc8feTzOW9jsncXw4TAYtleYySXjNARB9iitQo+kgNwls55
         D0abs1d4kX7nbO87Ivk+ARbF6SQAJZV8N7i4u9vGuvkY6G7U3dViS5qx7h4waCgqcIzR
         Ib9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbURqT/hIwISYpnd7Ewfv41kiT2pdXc627ZF5Jq5I3E=;
        b=QOg0go0phSpqKkrPN+BAKsuuZLkyJb2llfX2zVWV6XN/rp0RU+sDiOiye+XDf9h83z
         WKW2fFd32AsOm7LVz29jqjVRNLiXBRW32KAAZ8lP2E8NfV0AHhxQg4LxS83jzRKaZIw9
         kfAJSS4p8tdQwUdwacuR3FU/II3xRXAlYR5b0DEVUqCufLtol+NAIx/1LZyVKBWxeV9W
         ETIDtg8CmhrIi4snMekkLREQXKsK+/IOkchrvtpLGc+oiWGLkOg9/N/KBVELGcl5ZrjM
         IOJ2AP8SOm3CSG1E/d2yJO3hlM0/C+b9FshnZn+wbZiwPz42sLLmtjc771HWPTeIWdSO
         TYRA==
X-Gm-Message-State: APjAAAXfgyIGJr4AyJJJzNrTP9WrXLKPUoRLW4ef/zvD54BwI91MKsW7
        VRPbKQKCoJ0d+hQLVjcmjfP9DNM9
X-Google-Smtp-Source: APXvYqxywY5Zse9PkDjXWu8nk23uiy4DyBK5wQzT9H7FR/f5Yb9iOlOhfR6nc01VdGKJs2yb2SpCVw==
X-Received: by 2002:a17:902:8201:: with SMTP id x1mr23185856pln.193.1574588602407;
        Sun, 24 Nov 2019 01:43:22 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:550c:6dad:1b5f:afc6:7758])
        by smtp.gmail.com with ESMTPSA id c3sm4091213pfi.91.2019.11.24.01.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 01:43:21 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     davem@davemloft.net, keescook@chromium.org
Cc:     kvalo@codeaurora.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, luciano.coelho@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH 1/5] drivers: net: hso: Fix -Wcast-function-type
Date:   Sun, 24 Nov 2019 16:43:02 +0700
Message-Id: <20191124094306.21297-2-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191124094306.21297-1-tranmanphong@gmail.com>
References: <20191124094306.21297-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 drivers/net/usb/hso.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 74849da031fa..ca827802f291 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1214,8 +1214,9 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
  * This needs to be a tasklet otherwise we will
  * end up recursively calling this function.
  */
-static void hso_unthrottle_tasklet(struct hso_serial *serial)
+static void hso_unthrottle_tasklet(unsigned long data)
 {
+	struct hso_serial *serial = (struct hso_serial *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -1265,7 +1266,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
 		tasklet_init(&serial->unthrottle_tasklet,
-			     (void (*)(unsigned long))hso_unthrottle_tasklet,
+			     hso_unthrottle_tasklet,
 			     (unsigned long)serial);
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
-- 
2.20.1

