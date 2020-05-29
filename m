Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACED1E7BAB
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgE2LXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2LXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 07:23:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617F6C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 04:23:33 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n15so1271059pfd.0
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 04:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0qbFgn8ADftWrZz2rF9sjxFYt47afDQAIrSpN+uMsvc=;
        b=ryUMUPBvQqYwD5nfhn/YYVZMqqfKYC5iNA8l9kUAxM/zT1PvFk0VqZjVZMHxZ6eAwG
         fBb47kGpK4WFThRRK6jDHHSoTxqJnFW9/+kncGy8TbvJlw8T955uX86SQibkeBpWpguN
         GdI7CwxMFp+FUIDiXEv/eBOcnjupqQzAZgLD9Js4Xkk31h14enyd04F757lcXBcwxQqC
         pnDBIg8SXN6OvQfGzE4+ZsJmmY2p9/QSwVSQ0DUvmUEfXQYpGyd4l5toPABt5BV7jnrl
         mUH0zBdlfqcA6fLt+KslJLLyz21KGw1zUZF7wt9UE7Sc9ukUPN7BUKBSkcSTQcRbJlk3
         X44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0qbFgn8ADftWrZz2rF9sjxFYt47afDQAIrSpN+uMsvc=;
        b=RfWZ3VLw6OHjOqYzO6buyFgI55vOv+T+UvcK6i7F2RpidbMW8z4okyaPa/37Zr+/e7
         ExscUhZic+fvO17yfturtR/Z31IK1e+t2hkz4U65AxiELXa3bTxQoBNuXVPYr68vo1FF
         2QG5Gs0VOUcrqAVpMvk/whZMWCkmVJ7VcqIBJax9B4A3zOO0BN9/kbhy9c+4OVsPPhtA
         3LVroyQJh13TS6JxgJfqYgUf//nQDnjBXiABf4MlYY2JIIZ9Qq6pdJyQIc2YuAPXGKs0
         XWYAKTiwH2WIqhtRj5OZ59JeExIoMnjzucso8NWEC5GMFUhUp76jJK2mZMyqmZsh829T
         sLVQ==
X-Gm-Message-State: AOAM532bbDm+7Eet/QT8QTGjMdZatBuaY09p4/BQKBk1JMIMNksCOjCB
        +iM5L7spdtW1jAhMIEQSvgRNrLK/
X-Google-Smtp-Source: ABdhPJy01D0CYwV8A7cStPnMp1T201yuLOEL5wLARFmK6i6BgudSz3sN+d/4GZmqFdq9we2F4+03CA==
X-Received: by 2002:a62:ed10:: with SMTP id u16mr8337705pfh.0.1590751412751;
        Fri, 29 May 2020 04:23:32 -0700 (PDT)
Received: from localhost.localdomain ([45.192.173.250])
        by smtp.gmail.com with ESMTPSA id 65sm7195151pfy.219.2020.05.29.04.23.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 May 2020 04:23:32 -0700 (PDT)
From:   Wang Li <wangli8850@gmail.com>
X-Google-Original-From: Wang Li <wangli09@kuaishou.com>
To:     netdev@vger.kernel.org
Cc:     Wang Li <wangli09@kuaishou.com>
Subject: [PATCH] net: udp: remove the redundant assignment
Date:   Fri, 29 May 2020 19:23:21 +0800
Message-Id: <20200529112321.18606-1-wangli09@kuaishou.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Wang Li <wangli09@kuaishou.com>
---
 net/ipv4/udp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 32564b350823..54db5182c884 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -798,7 +798,6 @@ void udp_set_csum(bool nocheck, struct sk_buff *skb,
 	} else if (skb_is_gso(skb)) {
 		uh->check = ~udp_v4_check(len, saddr, daddr, 0);
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		uh->check = 0;
 		uh->check = udp_v4_check(len, saddr, daddr, lco_csum(skb));
 		if (uh->check == 0)
 			uh->check = CSUM_MANGLED_0;
-- 
2.20.1 (Apple Git-117)

