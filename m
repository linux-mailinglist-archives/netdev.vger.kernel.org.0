Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3033A96F
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 02:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCOByP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 21:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCOBxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 21:53:39 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC7EC061574;
        Sun, 14 Mar 2021 18:53:39 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id f12so8131098qtq.4;
        Sun, 14 Mar 2021 18:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NjOSr9VN+TZ+xvY692RA2Rk4/8SWTbRIdGmK6sBVnI=;
        b=XZqSVVmLbYt44JaCLhSlY1xv6p7EQ/7T07cVNA8uSS/YrRtnBKsrhIlaxsP2G9JkNe
         okwBK4nJuh0LGx9hBvAb6z9qjnZOajC/K6OWfDk3rwZk3oNus32//RxlHUukilqVNK42
         9WQtT6etr9KSts3028oYwaY08X8RHBj4dvG1hheUGrr4oZjCRhu6okfd1RKrc3LrPhQZ
         V+2B8IS7MahaUHJbFTjzoWaTfcz6dHh5JJHEdZToDtwkzMgeCArwCOAvUCBGnnMzxPff
         CRH4IKOghi4RW4ZQ8mszlIn7sUp3tkbDeb9VN1tmt+v+Lae6v4udXbnMFo5ZYQp5vhyp
         ge9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NjOSr9VN+TZ+xvY692RA2Rk4/8SWTbRIdGmK6sBVnI=;
        b=RHgO7PqTRaVSqf0qmDbY3yHmlJS2Lw+29Av+icTrPhyjTg5nhfRwwqdGH9wmM0T3Pu
         TPzlCZKSVvKnq/YYZrkn+RJnrzBqPwJE8m8h/74tDJynRCdFV0ygbKNgLQV5waQZ9dxG
         jAsrCwNAtGkBpAdJEdgJET6qsMasQyl8DaRwinI2f1dT9erfGAnqn8b4TZ77SVooj/or
         ouslIbcWIpjbJCK/hg2j1RwYelCT7pz+iIGhig0mvD/MOGd1DDeydVzhCwvsw3lYnvCg
         ww8nnXAVS5ntZjEiz3jYfsp4Yo0RSLl+uwsrOSa4fYFB0zuGAhIlNre1DrSahAbPXcma
         laAA==
X-Gm-Message-State: AOAM531e41Z6gfnAM5QEwo9/X+Woke/D+kqf8MRSca3hGy8G7Ank0pEF
        2Km34F91DH5or+WZV26bpVR759HJi3A4azjG
X-Google-Smtp-Source: ABdhPJx6BICvmZ8ukaK6Eju/42JG7Dm8kbGUg4b/ZrtAqrW0y/mMBxBkIiOonCtVIMf7JYcdWYYGsg==
X-Received: by 2002:ac8:5bd1:: with SMTP id b17mr21053346qtb.53.1615773217760;
        Sun, 14 Mar 2021 18:53:37 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.69])
        by smtp.gmail.com with ESMTPSA id x17sm4604638qtw.91.2021.03.14.18.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 18:53:36 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ethernet: neterion: Fix a typo in the file s2io.c
Date:   Mon, 15 Mar 2021 07:23:22 +0530
Message-Id: <20210315015322.1207647-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/structue/structure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/neterion/s2io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 8f2f091bce89..9cfcd5500462 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6657,7 +6657,7 @@ static int s2io_change_mtu(struct net_device *dev, int new_mtu)

 /**
  * s2io_set_link - Set the LInk status
- * @work: work struct containing a pointer to device private structue
+ * @work: work struct containing a pointer to device private structure
  * Description: Sets the link status for the adapter
  */

--
2.30.2

