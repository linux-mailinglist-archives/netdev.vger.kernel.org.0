Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60D52A29E4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgKBLsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbgKBLpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:44 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DA4C061A4B
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:37 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id g12so14189105wrp.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gvA8KxiiKQ/tWQ/ICepUyhKkRYtDSjo2P0kRgFq5FUE=;
        b=vliAKTVbQ+Yf7ljmfVfFDUTf2D3nyRlD0+GaBiWtYqpRwBwHvXFfqzq6ULSuP/x4kn
         RX/T16O7dd7RdiQhuCD9Is+VC57VLWEYXZtl7o86BvaY8QXpyBgFiYK4IKpQLTP4TY2s
         nakR3rV1TTp8ENtK2aAgc5QTgbY69T1lXMU9W9YkS0j5EhqV8gdPOVhEPFOHtUaGEsnI
         VpLwuA4wkZj3byCL4rx2FYT8d0M+0kjnV6bllUdYqSfqX5NKUwyPRJOfnaNBjNWoJxkU
         6K+eL3WHx6fb1cMTxdvR3OlfDO8MSjP7EXZxxpk+mqwX15VLpwVvD0pM7M5Xlpk2di5b
         MrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gvA8KxiiKQ/tWQ/ICepUyhKkRYtDSjo2P0kRgFq5FUE=;
        b=BM8wYPum6JfwvFK0FOcj4t+zWEaLU6SUGo+//PHS1eaiixDL7gcsmosjDioBgCzlJo
         +WLgyEYyuGBMtapiIJJuxXHY8Xa05p8980B4T3RLgHc6+n3jgROhtKKumLtCJ3Gb8Zv+
         D7G0dw8eQalcYyjE9u8XFN5z6GvDQfsivh3i/eDvoHifgAZTseEFnezWEO4UlWGY7jXo
         PEirH5vZVgt+MaRhl4FIxc6o5yPuvSeYxoap2Z14DLN0SNpPWeiax1Lv1NKBgsb37Fpw
         cfGvXi0vhG4Y7WwqN9LU7sbLw3nAqk7vhUHpkNsFTRJpwLtjGLsoVf3w+Bl7Zjpc34qL
         1fww==
X-Gm-Message-State: AOAM530ndlGZYHpmiESmNwQPUw5POtzTrRpYfB/RbX+MCRT+kYx0uh+P
        V+FkmzQQ7fvoWdl3dgNXvw64ZQ==
X-Google-Smtp-Source: ABdhPJwn2PIL/TRI53AK0L1yjYtUy6cS/IEs7jLyBnq5Cwz6OUogP+XNLa9v1e3/lZpck3SuAgQXzA==
X-Received: by 2002:a5d:4b92:: with SMTP id b18mr17505695wrt.281.1604317535871;
        Mon, 02 Nov 2020 03:45:35 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:35 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 13/30] net: wimax: i2400m: tx: Fix a few kernel-doc misdemeanours
Date:   Mon,  2 Nov 2020 11:44:55 +0000
Message-Id: <20201102114512.1062724-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/tx.c:715: warning: Function parameter or member 'i2400m' not described in 'i2400m_tx'
 drivers/net/wimax/i2400m/tx.c:964: warning: Function parameter or member 'i2400m' not described in 'i2400m_tx_setup'
 drivers/net/wimax/i2400m/tx.c:1005: warning: Function parameter or member 'i2400m' not described in 'i2400m_tx_release'

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wimax/i2400m/tx.c b/drivers/staging/wimax/i2400m/tx.c
index 1255302e251e4..e9436212fe54d 100644
--- a/drivers/staging/wimax/i2400m/tx.c
+++ b/drivers/staging/wimax/i2400m/tx.c
@@ -681,6 +681,8 @@ void i2400m_tx_close(struct i2400m *i2400m)
 /**
  * i2400m_tx - send the data in a buffer to the device
  *
+ * @i2400m: device descriptor
+ *
  * @buf: pointer to the buffer to transmit
  *
  * @buf_len: buffer size
@@ -955,6 +957,8 @@ EXPORT_SYMBOL_GPL(i2400m_tx_msg_sent);
 /**
  * i2400m_tx_setup - Initialize the TX queue and infrastructure
  *
+ * @i2400m: device descriptor
+ *
  * Make sure we reset the TX sequence to zero, as when this function
  * is called, the firmware has been just restarted. Same rational
  * for tx_in, tx_out, tx_msg_size and tx_msg. We reset them since
@@ -998,7 +1002,7 @@ int i2400m_tx_setup(struct i2400m *i2400m)
 }
 
 
-/**
+/*
  * i2400m_tx_release - Tear down the TX queue and infrastructure
  */
 void i2400m_tx_release(struct i2400m *i2400m)
-- 
2.25.1

