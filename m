Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C63404D0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhCRLjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhCRLjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 07:39:48 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EC2C06174A;
        Thu, 18 Mar 2021 04:39:48 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v3so1245210pgq.2;
        Thu, 18 Mar 2021 04:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S0Ej3lKCPVzBM8qM04CRJBvn+9chI3S3W7mTusbdHCA=;
        b=kqfQ+6DNf3bayt+ixltd4Y8KDyeu6CVHcWpj7bpL0ZbEjzLMSNup0l7v7j9n6x5iu5
         7IoDS5Xcg9VFds5QjDlV5yK7yeVovM3d8ki+1OIbHf/ej/GKxxBT8yLG/Chki9v60zw2
         ahkwa5GOTqxvzPKmi8rkR4TCfolCZuKrMeTDatSgZqbzZjE1vZsoy0po6MtVmq4vc1FR
         H+5/VIQ7zRxAF7UGQ+63W4rNpfaEZ8+Z4m/vHDwHugVlEbHJhR38fZur2kJnjSxxQTo4
         yzGnPPChTWMGIzIizcm6WV9Tkfg41CUTbM0f1B8QbRYg+MEZPcm59ggN9aQyg4pOxYLN
         /dIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S0Ej3lKCPVzBM8qM04CRJBvn+9chI3S3W7mTusbdHCA=;
        b=T8ol+Whc07NKx2PyD+oqe9KWHkVfLyQzkBmoEreYxju3RxpJNs5GPOlX8sHcgGkm5Q
         DWvxq+OaJbVsgXyjgD6TxYKDhyBUBUW9KCa0zTbb/ggpTykjfEz3P36JngXZVbf0O49K
         YkntpmnSFYyyR5kiXeXvqKT0qYJqrrK1sH0WfxPw6Aaa36Dc7hEkn8J07jmQsd8M5LG/
         W4bG4d5pYL8/SBW7axbMUnWpCVEe5ZRuMdMkgsg0Aga3kpxI8ZGIbcWeWByc2wjDcqyd
         5cOCzn5AKXKkKyUIbqN0xRbhwU2CJZrrPwWA+q4qdixizo7IO+IKMc9Jyd5pAbewHuMm
         UlzQ==
X-Gm-Message-State: AOAM531XQgvh2LG+ZhZC2U9M2/KA09ExBlQDWQ8DJ9JGrGd/wsOjGeLg
        q5tPG+No2UC5r5RGhFofdA5kVDhHWTU=
X-Google-Smtp-Source: ABdhPJxp6OKR+TNoFQTfxvVLQ0KzBZpdpPz042/J3USeyYYzDqiVoM6TNWBFrHgz8dSrxS9DB3tnyg==
X-Received: by 2002:a63:2213:: with SMTP id i19mr6584102pgi.242.1616067587983;
        Thu, 18 Mar 2021 04:39:47 -0700 (PDT)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id kk6sm2194996pjb.51.2021.03.18.04.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 04:39:47 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: xiong.zhenwu@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, m-karicheri2@ti.com,
        andriy.shevchenko@linux.intel.com, xiong.zhenwu@zte.com.cn,
        miaoqinglang@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] /net/hsr: fix misspellings using codespell tool
Date:   Thu, 18 Mar 2021 04:39:41 -0700
Message-Id: <20210318113941.473650-1-xiong.zhenwu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>

A typo is found out by codespell tool in 111th line of hsr_debugfs.c:

$ codespell ./net/hsr/

net/hsr/hsr_debugfs.c:111: Debufs  ==> Debugfs

Fix typos found by codespell.

Signed-off-by: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
---
 net/hsr/hsr_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 4cfd9e829c7b..99f3af1a9d4d 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -108,7 +108,7 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 /* hsr_debugfs_term - Tear down debugfs intrastructure
  *
  * Description:
- * When Debufs is configured this routine removes debugfs file system
+ * When Debugfs is configured this routine removes debugfs file system
  * elements that are specific to hsr
  */
 void
-- 
2.25.1

