Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE07F3456E8
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 05:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCWEhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 00:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCWEhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 00:37:16 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FBFC061574;
        Mon, 22 Mar 2021 21:37:16 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id t16so9837801qvr.12;
        Mon, 22 Mar 2021 21:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eUZjvbWhG8mpAJ9oWPfDqQmrZ+U1xI4KjNvkjd4vAQ8=;
        b=LjdCpKKQcTWep3Uudz5wlBa4XTvLfZ99MIgawJQyuE3xD8KrfRmvaVMfwmiNlrQenB
         7j9rvPpNAQPrLiCuwJUqwfN3dU5V7qNt2YW0MJqYZyIDlyEo+Nm4xGKKszbjsTRqUhQ7
         3YIMZvI9nHlCrRo/2H4IvdCyhu8Kj8ckJIqkoPVDlGYTZp/PxzR3ykXB6NDTSQfYylfS
         P+TFubmv9memx5a7kTxk365NOxpl2fGn0XVHADzY5x+1NgnuD06GWLnkyH5aKC5sdjzH
         kv7Q3kpIuCTV+n0E4IKFLv3SGcWPFGRKq5UQvV9nZ/VKHdE1SMHkF0AVQZ+4/3BKe4K8
         wYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eUZjvbWhG8mpAJ9oWPfDqQmrZ+U1xI4KjNvkjd4vAQ8=;
        b=gIDsorxrBq0BEMOuzBytX68CAg0j3p6gPfCtG6Zcm6U/XQp1nUS5rH2NGDxHrWW4O+
         hqVzWYgGawjw6ZPh2xI09JTPLS/m5PSG94+1BtcGI4BfJYshevaArXtL6MZ42mwkMXwL
         4uZAVie1u8IvTlery1QbkMBfbpvnD2iVvzC31ozMSOtkjTQirVAv/+RvlnsO/hG7X+/K
         QCEsIRu0y+g/z3ooRu0FtdcJSwh0zlkzCmW/+GdePmefhA/U8AD+nJvZViQQ/DOALNA3
         /AvJ1IHeG9XBroc8C9vzK0bBnHgVikPXpAMnaLam9HhSRJG5wb/slaT8cI5pjlPKNUNR
         hXHQ==
X-Gm-Message-State: AOAM532QuLViheX1/Y5iMoyMOC2CaocJVkP5KLqnQFHSS1yvaBI0gvzw
        VC5g+YCcI9Eo+MLMj4tx/q4=
X-Google-Smtp-Source: ABdhPJzpn/qLE7mquJkm8VyguR63pGY+0OA+1ULU+mdB5ZlBroS9tRh9kZb3B44sjkBcdw4ZujIyxQ==
X-Received: by 2002:ad4:584d:: with SMTP id de13mr3046957qvb.17.1616474235825;
        Mon, 22 Mar 2021 21:37:15 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.208])
        by smtp.gmail.com with ESMTPSA id b1sm12790054qkk.117.2021.03.22.21.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 21:37:15 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        unixbhaskar@gmail.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] brcmfmac: A typo fix
Date:   Tue, 23 Mar 2021 10:06:57 +0530
Message-Id: <20210323043657.1466296-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/revsion/revision/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.h
index ee273e3bb101..e000ef78928c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.h
@@ -28,7 +28,7 @@ struct brcmf_usbdev {
 	int ntxq, nrxq, rxsize;
 	u32 bus_mtu;
 	int devid;
-	int chiprev; /* chip revsion number */
+	int chiprev; /* chip revision number */
 };

 /* IO Request Block (IRB) */
--
2.31.0

