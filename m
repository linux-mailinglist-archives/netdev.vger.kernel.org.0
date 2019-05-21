Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0772466B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 05:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfEUDlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 23:41:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45626 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfEUDlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 23:41:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id a5so7685070pls.12;
        Mon, 20 May 2019 20:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oIMygyD3sInPQMcnYmQjxiYJQKnfeII4uM7qe57TIWY=;
        b=OAy03SuHPZvHf9eiWYtJiWyRxvX8P7yOnlWRu6A2YcGpkcPnBT9R7OQxiZVaQQMzxS
         jCmK/wyiIKgyihj7dSyKGNDijnO4DrhtWsFvimvIG1I88zQ6V2Jq4aAxSxeXMb/j7dPG
         VsJ93FYEiREdwlWLXGxhv/A5IXpFJE7P5WYYUP/RaVdXsjB8AbJi/jUaxs98p3mJFK9k
         UjB7v284fbm6dy1CKz7ktmXUNITj6pT8JzMNj1bh0jkcvCJjnFHTLpSvqTqWKjA14gnx
         gsmPbvLTBVNx78c/DZ4K/gMci9q2UataRghBaISrLDc8OMXfSFum3/o2CbIWu7OOx80T
         +ulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oIMygyD3sInPQMcnYmQjxiYJQKnfeII4uM7qe57TIWY=;
        b=oEUlCaGp0bccS4DrXYPP67+UUCHC73oYtxdBmwgL2Gbl4MjJzs79hwZMgmqBTFfd6G
         VgXK4L3d4dwo7aPaUR0qzFjGMZagghgzdwurTGXdgwFw73V7XuRbFBRYmvV84BnHA/rn
         HzwlGl3bEztn6fMfiS6AWBj1NkAa63HTLzrUbydvbfvrRKGJeFWuo1zYx91yZqRbNAst
         3K2AI/9N2ROCkzw3PizpxDn5cZkdUJVDRlJ8b2hwGg2wnV+x04ta5EQaJ4tUJe5IwcTi
         FbsAjeCoD/4pu4VW9GMCafT7Iannrk1PTkiHzz3Atzpgpp7ZbJbXjw+4UdIoOnFeO57b
         xLiA==
X-Gm-Message-State: APjAAAXgPhYgcVNKD8VRX83YMgcdzRwGz8JpxU3FVf4ElyZM5H3yi/Av
        ntyATBqBvSgvGyRL8BuXUWRrG5ZJAh8=
X-Google-Smtp-Source: APXvYqzWjyywKwMRH7ExnVj2HvsLeLCpGjAlErCfjtV2Jt82i9xkXMi9kB0QNpru7Ak/5phso1h3Gw==
X-Received: by 2002:a17:902:7202:: with SMTP id ba2mr25990766plb.177.1558410090897;
        Mon, 20 May 2019 20:41:30 -0700 (PDT)
Received: from masabert (150-66-66-201m5.mineo.jp. [150.66.66.201])
        by smtp.gmail.com with ESMTPSA id 19sm22635975pfz.84.2019.05.20.20.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 20:41:30 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id BC43F2011A2; Tue, 21 May 2019 12:41:16 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] net-next: net: Fix typos in ip-sysctl.txt
Date:   Tue, 21 May 2019 12:41:15 +0900
Message-Id: <20190521034115.18896-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.22.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes some spelling typos found in ip-sysctl.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/ip-sysctl.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 725b8bea58a7..14fe93049d28 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -560,10 +560,10 @@ tcp_comp_sack_delay_ns - LONG INTEGER
 	Default : 1,000,000 ns (1 ms)
 
 tcp_comp_sack_nr - INTEGER
-	Max numer of SACK that can be compressed.
+	Max number of SACK that can be compressed.
 	Using 0 disables SACK compression.
 
-	Detault : 44
+	Default : 44
 
 tcp_slow_start_after_idle - BOOLEAN
 	If set, provide RFC2861 behavior and time out the congestion
-- 
2.22.0.rc1

