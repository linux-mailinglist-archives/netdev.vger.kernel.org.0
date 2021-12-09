Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F19B46E048
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhLIBiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhLIBiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:38:12 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23508C061746;
        Wed,  8 Dec 2021 17:34:40 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id k26so3982055pfp.10;
        Wed, 08 Dec 2021 17:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KkK7nQxmGaV48pI97SoJ1i8VEs3J+ka4tCByYFUhf0A=;
        b=nUKeZQ/v26RfHoagFeils1sBokOZvuCB6ts1jgUdkl+mr/GxiWg3GbKLTzM26PSr3g
         uxOYb6ms7ace+zbuDGSEzINHgDPsZtKoKp/Rc5ZRbH4bS/HK3yus1zgSZNt/j2YOPZKj
         WSvZ96yAfZTbvfkFqdWr+XMnVUTD6oi6sAG8Tn41Kddm3gGaiIMK7ZRCwR/r1xwa1wjN
         vzKi+m52StZX7TslW8SP37ZLBw+6L50G1n9S+Bu+/qwkpNuEOMQISxTWXoNlLP1v2SVO
         JJfjj/BymKH5Z8NtJfO1HMnkYm4LzdGS8c0XbhGIdW5xSdYKV+pfb49C9nGn0KXxVy5o
         Zgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KkK7nQxmGaV48pI97SoJ1i8VEs3J+ka4tCByYFUhf0A=;
        b=iRV9NG69UfSEnwJxK0sg0Ans3nWfXnk0csNHkqd1/crDHyzdzuLptPNkdteeA/iHZr
         tciYk8y1E8mLAym6Zob9pkMFXrS9UAw9hahRg9ArF27ibr3Gkj41xa9Rh2ihknkj/0LW
         0Bi9acKT63ti/JMVdAnLlDP+eTHx00K2hWj8eGMCK1l73PRwML7sLxPl+HwBKoyiyMsF
         k1VFTsNFrGDM56l4Ub5ZBGeqplleHhaHBEk7TRuLT7F0VbbxeGESPjP4yEoRGNHqPsPY
         xRkaGsQYQUiUKpOQTezZDgUNw9hXZF+2++Sh08GAOGAQ9jwiS182oWmI558ihW60LpCk
         6BQg==
X-Gm-Message-State: AOAM533tJPgn5kcdspvpFxSwyCXysoFg5xwm5VDjMH5yOvIUWv399t7Z
        HVOwWB0CAJD+MC9xaLREZtSETf8dkFQ=
X-Google-Smtp-Source: ABdhPJyxAN+IiuXQa5r1o5HgQX7r3bnNOQsQvBfZbaqfzKU5xlXa1b73XmnutDFnAYf1wB+JmoKk0w==
X-Received: by 2002:a05:6a00:2d1:b0:4af:437c:5f50 with SMTP id b17-20020a056a0002d100b004af437c5f50mr8900570pft.32.1639013679693;
        Wed, 08 Dec 2021 17:34:39 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id nn4sm4080078pjb.38.2021.12.08.17.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 17:34:37 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chiminghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] net:ipv6:remove unneeded variable
Date:   Thu,  9 Dec 2021 01:34:30 +0000
Message-Id: <20211209013430.409338-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chiminghao <chi.minghao@zte.com.cn>

return value form directly instead of
taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
---
 net/ipv6/esp6.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ed2f061b8768..c234e028847b 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -413,7 +413,6 @@ static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
 						struct esp_info *esp)
 {
 	__be16 *lenp = (void *)esp->esph;
-	struct ip_esp_hdr *esph;
 	unsigned int len;
 	struct sock *sk;
 
@@ -429,9 +428,8 @@ static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
 		return ERR_CAST(sk);
 
 	*lenp = htons(len);
-	esph = (struct ip_esp_hdr *)(lenp + 1);
 
-	return esph;
+	return (struct ip_esp_hdr *)(lenp + 1);
 }
 #else
 static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
-- 
2.25.1

