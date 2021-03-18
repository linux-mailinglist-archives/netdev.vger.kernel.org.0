Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627C23404F8
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCRLwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhCRLwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 07:52:19 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A358C06174A;
        Thu, 18 Mar 2021 04:52:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x184so3308436pfd.6;
        Thu, 18 Mar 2021 04:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uvsR6rY1bwfBzZDL0MMowZ/svepC0HCxpC7Ki4GHewc=;
        b=mi35mNkSZdJCt36jOGVHyupnZHUYO00OjmmXr9ddY6IyspeoYN317YuszSnbo55gnR
         bteYf4J5Dp1YlrgBP/qMCXL+3bp4mmYDY0XiEiyIG6ej9A1py6H1/Hi2SO9Oq7CQrDdx
         HKVZDhEta30IRvCOhkkFRMDcz1gliy1XYJQUblybp/bW5YMEqvl60e+z9u+oWatxwyzp
         pPlY9z6Ye2thgL6rvaWVZMTETVvjBUlcKtHQ9+L7DT4DREcF4fzXosPNs7lKVQlFIPUa
         i4dlqFIK3Z9makaJS4kmR1IwRGbNPV+nMOpFt5C+tSYVhGOK4VD0Fs+wRBl8RbFJPyaO
         cvOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uvsR6rY1bwfBzZDL0MMowZ/svepC0HCxpC7Ki4GHewc=;
        b=IkhiVlsLJM8k6T0hUCFS/wavCwUMOHMMpnYP29AWrdJO1EB6Z2FES5wfIOA79FCgjF
         p5UE4Wc44qPGSv6azz6phGFqo7+NT4Xu07YmlrZ/pOjY/GfEvox4hk6ng6aPmrSgUqBJ
         qv63/v/rfq4D65ZnfPUIu6l5v19oc0zE4pHxkSnwckBbtJTu6KGsKwar0jvzt2Z4Soaw
         msSrlxILG6HeDAmPHJkFCtx2Nkh+mDxZsVo/XFRKGoYO0CXganPpczRvAn+HnWQzdZ3i
         o4qNUp5P+aDYqj7vgAgTkSrFgFAtxziO6yBuIGeTV7UHgPcL78ivF918O/ygARLh8+lc
         BrkA==
X-Gm-Message-State: AOAM533xdQ4NJHWqFHmcJeJQyaNLkvwLjQIO2cxk9vbIkxtVU2/BZkpV
        S/wEKosr0FY0TE79SIE+LvQ=
X-Google-Smtp-Source: ABdhPJy+emOdWBmcgN8wc+mDXhLOYQ5opI806bS2nJvRVL4DEADS6dUxGxtoPmZ2BXWRjWTpJVz8Yg==
X-Received: by 2002:a63:f11:: with SMTP id e17mr6759436pgl.296.1616068339166;
        Thu, 18 Mar 2021 04:52:19 -0700 (PDT)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id j20sm2198812pjn.27.2021.03.18.04.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 04:52:18 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: xiong.zhenwu@zte.com.cn
To:     nhorman@tuxdriver.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
Subject: [PATCH net-next] /net/core/: fix misspellings using codespell tool
Date:   Thu, 18 Mar 2021 04:52:13 -0700
Message-Id: <20210318115213.474322-1-xiong.zhenwu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>

A typo is found out by codespell tool in 1734th line of drop_monitor.c:

$ codespell ./net/core/
./net/core/drop_monitor.c:1734: guarnateed  ==> guaranteed

Fix a typo found by codespell.

Signed-off-by: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
---
 net/core/drop_monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 571f191c06d9..1eb02c2236f2 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1731,7 +1731,7 @@ static void exit_net_drop_monitor(void)
 
 	/*
 	 * Because of the module_get/put we do in the trace state change path
-	 * we are guarnateed not to have any current users when we get here
+	 * we are guaranteed not to have any current users when we get here
 	 */
 
 	for_each_possible_cpu(cpu) {
-- 
2.25.1

