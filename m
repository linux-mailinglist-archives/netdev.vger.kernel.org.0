Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B4164307
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfGJHqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:46:06 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41064 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfGJHqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:46:06 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so782373pls.8;
        Wed, 10 Jul 2019 00:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rV8XY23YcgGtmJ7pWfTCdKdGdKOHA29Wd8XEtkDo6dw=;
        b=rk0yxVoRI1NSXQaTxJGnXTVDTyoh73Qr15nBHk581jpDGshkxfpn3RztceSyQs+tHe
         ti7BzzdaHXnGOAGg6mqaBJ1SAJHD3e6CdgRxUu5ixvnbeMoOmTLMD9XC6iTWrjA6F+08
         WKInMtFYRWZALcgK61SSZxrpio9iP4ILgs+n8XyfIl4/ijmVe2vKFVBz1EhdmKo7KRMx
         genAn4wRFNkS02wbrK1nV8BTUxA/GLNMlgzTkAJyRvlOY05RHzqBLzUZl5A8vk4jqgvz
         q4QPtcHkt2xMb3JPCE4OfqRs1uXAXn3kU5N3dvXfNh3+iHcvizhBiRoXII9PboSmzdrW
         +bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rV8XY23YcgGtmJ7pWfTCdKdGdKOHA29Wd8XEtkDo6dw=;
        b=tAtthZ/iazOow0jrm2CubXuUQaZ9nvi8EfaIT5a7aNFZ0EfgQnhDhX99kNIryooEH/
         LAzBUad1DsfDAcfQQ/96IEgazuoJioScKvzuB8ITtxWN5jecZqR/D7ZBRc7k/s9qXQTM
         I/zVf5673zQKfIYbN2wc9P5kxhYihc/r57kY1ZSWKAsLl9E4hNz7DBk0KQ6beIHLBzi9
         Ut+BesFrU7Dc0Pbmh56KR1/ad6RdPMzHm9rcOLzjBoemfBjz+mlfwamO+Nf+rJfJZKbw
         tp8DAdU7ON9l8y/9smGZeAIlJf0Bk8BJVyZAzc9reaaDZfa3K2GKASQwjQZfn6ZwPIiU
         Amng==
X-Gm-Message-State: APjAAAUdD8Ppq7xwXZAnf3+kVmpebaUsJkkx+SLYIjl7PJ1dz/lRC0xS
        BnZVfzcBxEIdnepbJfT+Hd4=
X-Google-Smtp-Source: APXvYqzTEtpXtNGzqCh1iEYjwJr8rhP0UH3QyDiHyaS+gj3onEv9axgpOacn/2/6w5KIyiizT1khyA==
X-Received: by 2002:a17:902:20c8:: with SMTP id v8mr37589553plg.284.1562744765212;
        Wed, 10 Jul 2019 00:46:05 -0700 (PDT)
Received: from localhost.localdomain ([116.66.213.65])
        by smtp.gmail.com with ESMTPSA id g14sm1252903pgn.8.2019.07.10.00.46.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 00:46:04 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     wensong@linux-vs.org
Cc:     horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yangxingwu <xingwu.yang@gmail.com>
Subject: [PATCH] ipvs: remove unnecessary space
Date:   Wed, 10 Jul 2019 15:45:52 +0800
Message-Id: <20190710074552.74394-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this patch removes the extra space.

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 net/netfilter/ipvs/ip_vs_mh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
index 94d9d34..98e358e 100644
--- a/net/netfilter/ipvs/ip_vs_mh.c
+++ b/net/netfilter/ipvs/ip_vs_mh.c
@@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
 		return 0;
 	}
 
-	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
-			 sizeof(unsigned long), GFP_KERNEL);
+	table =	kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
+			sizeof(unsigned long), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
-- 
1.8.3.1

