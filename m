Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BDA169ADA
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgBWXTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:19:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35763 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgBWXSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:18:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id b17so7457774wmb.0;
        Sun, 23 Feb 2020 15:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DK0fVk7T3WgMmj7v3ZYkeDPV2tF/ZuuJFCw88aNzFqM=;
        b=e8nA0Wxonp+zTCZjgn2t/zpZFdtKtlLPDAr5rCVr5QpiUkqjORtDc13zzswFAdvr8p
         Tol12dMs8diVyJpebXw7ag+dd8tEQClzpWP8Uqboy+1eVvoHE0sBSxzRvrwgmuH1DCSc
         nl2lfcL/ZyyFqzGtaJLnYFJjWPGU3UDUmbKdxj/NYAQpEqdtAg16dsdWsiAIQHuS6Ps0
         hEts00G2RPIs/cAawLTHULkqVC2Odh1sviqFy8AkfUIvD2boKDeuedyfymE8P7mGVk79
         EtOAb5pYUjqMyeAT3LFo/r271os1dcrIxBEP1Hp4ZyrIyld2iA3Luh6m9ApHjtAqeqWG
         r72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DK0fVk7T3WgMmj7v3ZYkeDPV2tF/ZuuJFCw88aNzFqM=;
        b=RjYjNt9K4GCHDXrjlGym9ItHDdleocu1YYAiFanmukdAh/Tg3MK2bBTZM2fUHmGc8p
         WHtOMTduEbzd9gt8od2l11uoaMBnW66CKxloC4dHLgA5zw/n2WEqxFXfprqxLDP/go3W
         YX+KURSonylqleEVEAF3GTbDpRZKEmpxU4rm0u262YJ1hs0n0MHoPRiBaLoexGDC6Qwt
         Mjk4aDkvLMA0I6hIGfNVUnBen3c5GojiGhzO2hzfZYTP85j1//+b2pAIFy6AzXSJXIfn
         E5eSTf4SN2syWw4Hvb7S7Crzk9vO6PQa/25Kx3GNZsKGzPgnhx9hK2NLGMHnMcLUKHTN
         ZCtQ==
X-Gm-Message-State: APjAAAUV4oH5nTP9AImFKciDtS/IwwXEz2m0UnuY2Lzb2s6oUjbVz4BM
        0JTETiB2VtHuoyymxALn6g==
X-Google-Smtp-Source: APXvYqzFijwaaFkpAWFJq7bDloMJkagplNhkz2WKMU+TRrtKqtq05NIRT6bNofvt6cm9VNN5sZzYAQ==
X-Received: by 2002:a1c:e388:: with SMTP id a130mr17877186wmh.176.1582499885060;
        Sun, 23 Feb 2020 15:18:05 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:18:04 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-hams@vger.kernel.org (open list:NETROM NETWORK LAYER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 10/30] net: netrom: Add missing annotation for nr_node_start()
Date:   Sun, 23 Feb 2020 23:16:51 +0000
Message-Id: <20200223231711.157699-11-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at nr_node_start()
warning: context imbalance in nr_node_start() - wrong count at exit
The root cause is the missing annotation at nr_node_start()
Add the missing __acquires(&nr_node_list_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netrom/nr_route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index d41335bad1f8..fe278fc24153 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -838,6 +838,7 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 #ifdef CONFIG_PROC_FS
 
 static void *nr_node_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&nr_node_list_lock)
 {
 	spin_lock_bh(&nr_node_list_lock);
 	return seq_hlist_start_head(&nr_node_list, *pos);
-- 
2.24.1

