Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C100015F81F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389700AbgBNUtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32913 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388816AbgBNUtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:49:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so12514062wrt.0;
        Fri, 14 Feb 2020 12:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GovDwGSGIzG2rCMfZqhL482njrRJvSxaatNaopkmVCo=;
        b=sz6ZBGi0oZSsy/wtLxkE8rOdKw1g2xsCm3CJe2becCd/G6DHi7qEQxt2zEROlGeet3
         k+iqhz2xbQglNhOr8OVbLvfx2JGA1qq6IvwmQ/3J4CaXSHaaKK1ENM2HcMb/6cmMGVC5
         ffW70Vr6sVt7fhMvDes0FeDZueSPyErRG/1nyhc6CkyPYqEGH6eE1lADHsLBZk1746Nv
         TrsjEZ8aD1TLZVe2jwRMZ/HobYZIXlB6ctBXE33DvWjmQnXtPYGEl2d+hdLmScjVbwXq
         vructeZzSjQQN2WiZxrcXu2tmHZLMIonSBIUBB2F64k35C59s1IttoCdRYi8JWNvFZpK
         CczA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GovDwGSGIzG2rCMfZqhL482njrRJvSxaatNaopkmVCo=;
        b=aBox9/j130Syl9ziNk7geHuFx5vEDMFAYE+eLShoRIeeAvF556huOIdxWWywEmjCbT
         9hZ+TP7xWRUcO2Mbg5PZfG0N4zkOjEh9Ogi+lPolsjaWTzIHubtwmHCxlxdbNpUNj1U9
         toS7p+M6Fq88RN8GvRMlEhUlqtl+GgNlBOIkfSQAAukDNFC7jV7iCSBkib1FUlxXrf6T
         EBVA2eQ04EhOihxq+rhL5i8c2od1YCuHZrwqxu7AAFufNqmedff62zGMnqn5cDMbGxge
         qISX6gMA33Au2//1MQAHFsGOHm0MvYxbWRVJkfFdIIg0zpQhZg1siZlxPzostWLp3YhN
         +TlQ==
X-Gm-Message-State: APjAAAVFPd1QVBE+bEgsDiNjamA25pzOIR4BWfJIB0H7CaD4Lk+uz4Jv
        P3jO3w2CYqMW6mjMWxqOjoHJonbAiSiL
X-Google-Smtp-Source: APXvYqzkZTTX1I0tfcJRFRihED2F7ASp6bhsjVA7Wp/W3bga4rVwcvjQCGVpauM8qIZXxS1MXlu5/w==
X-Received: by 2002:a5d:4709:: with SMTP id y9mr5814590wrq.412.1581713340279;
        Fri, 14 Feb 2020 12:49:00 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:48:59 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TIPC NETWORK LAYER),
        tipc-discussion@lists.sourceforge.net (open list:TIPC NETWORK LAYER)
Subject: [PATCH 24/30] tipc: Add missing annotation for tipc_node_read_lock()
Date:   Fri, 14 Feb 2020 20:47:35 +0000
Message-Id: <20200214204741.94112-25-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214204741.94112-1-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at tipc_node_read_lock()

warning: context imbalance in  tipc_node_read_lock - wrong count at exit

The root cause is the missing annotation at tipc_node_read_lock()
Add the missing __acquires(&n->lock) annotattion

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 99b28b69fc17..4e267ed94a2a 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -351,7 +351,7 @@ static struct tipc_node *tipc_node_find_by_id(struct net *net, u8 *id)
 	return found ? n : NULL;
 }
 
-static void tipc_node_read_lock(struct tipc_node *n)
+static void tipc_node_read_lock(struct tipc_node *n) __acquires(&n->lock)
 {
 	read_lock_bh(&n->lock);
 }
-- 
2.24.1

