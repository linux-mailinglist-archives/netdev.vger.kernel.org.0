Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E1B34360F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 01:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCVAzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 20:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCVAyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 20:54:46 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527AFC061574;
        Sun, 21 Mar 2021 17:54:46 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id v70so9027126qkb.8;
        Sun, 21 Mar 2021 17:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IFO3ZmmHApJhUFvrdn88x5lFpaNnQPfLrvXIFZxyIfY=;
        b=HMaaQ2EwXNPzTjDinLvgNl2XGH03e6mT++sfIa8k+BNl9VLbfM635gNrH4XrSxZRJi
         B3/4SUjfZGQbsRqQkNl9zYsyYCb4k+BdJDRbzJ3Vi74uft9pLGo8/Nlcu2IEgfHT0TDB
         ymBUM5eRkvOMwcS7IGExanMTsYUyti+AQE4TeL989us/JOb1iV1jnfdI/XEnEjKft7PS
         D4UUFsa6mQ2Le16Y4uX/BVBpWOhjQlAl9ElWjIWhX3ClMRe35jugzuEU9Be+H81M5pbU
         awY1ILp6nEuFaH3speJY2ZUsRYT64aDKvGIE6xAXgkKqhRw42aAdMsHC1tlu7flws89J
         ZT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IFO3ZmmHApJhUFvrdn88x5lFpaNnQPfLrvXIFZxyIfY=;
        b=ARdHRLxF3a/MIvK9Lxur1PLvt+FL7ToI0GYzHiQ1pFzEJ9J2ODzh+WPsBfaodilF4W
         Aia9QK37BXHJ00PP+qhuUnh+J6g3GdhJu6xy+w71YzEJbK/zl23Fx45+INur3KkVCRcw
         LdIxcTiGb6untgFLQDICIbB/lhg1wInKT642/YtS/SunCXd8Q+BiQJxKq1ReTFrWaVib
         JrIbs05xwrE5cf3tVgOIpaR+Wcx2AVjMpMHpb/tryB3OZDrBHLk8Kgsnj9HkzIur3xYu
         w0OejEegn3Wme8R+kDfas/umnLBXdS6rrszI1oohRfGxtF0z44y7d+WROeeYXSUtesx1
         ejyg==
X-Gm-Message-State: AOAM533l6zm7gpDpwWr0chvd5ELovBXWWTwmHlNU6Q3PemJdhLgyu5im
        7M75AX4Cb/5bD1ykPZDUNAc=
X-Google-Smtp-Source: ABdhPJwQS2Lq57vCModtxZzm3rXvuzhszBafTEMkEzhZQjFu+85PuzUj0gR1y4+nf/gHLJyGjfsOOA==
X-Received: by 2002:a37:ef17:: with SMTP id j23mr8342728qkk.209.1616374485604;
        Sun, 21 Mar 2021 17:54:45 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id v35sm8336349qtd.56.2021.03.21.17.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 17:54:45 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, unixbhaskar@gmail.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] NFC: Fix a typo
Date:   Mon, 22 Mar 2021 06:24:30 +0530
Message-Id: <20210322005430.222748-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/packaet/packet/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/nfc/fdp/fdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 4dc7bd7e02b6..5d17f0a6c1bf 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -176,7 +176,7 @@ static void fdp_nci_set_data_pkt_counter(struct nci_dev *ndev,
  *
  * The firmware will be analyzed and applied when we send NCI_OP_PROP_PATCH_CMD
  * command with NCI_PATCH_TYPE_EOT parameter. The device will send a
- * NFCC_PATCH_NTF packaet and a NCI_OP_CORE_RESET_NTF packet.
+ * NFCC_PATCH_NTF packet and a NCI_OP_CORE_RESET_NTF packet.
  */
 static int fdp_nci_send_patch(struct nci_dev *ndev, u8 conn_id, u8 type)
 {
--
2.31.0

