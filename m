Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE6715F818
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389097AbgBNUtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39623 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388437AbgBNUtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:49:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so12454255wrt.6;
        Fri, 14 Feb 2020 12:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KogAxpggl38aAtutnQH63h6HBVBEGF0LaJsnW/om7os=;
        b=cf97c66nvwYbeXUMwBWMSOxo/JJg9s6NYnvWoqG6IdGFi0U4bUw9lyK+ftMwB8yz/j
         9+RatTI7nAXmv8LQUaHETAD5NmtrK4+0TbXW5hN3Q4V5mukuVMczGK+XvlchbJ2c+RQC
         swdB16oH+rauFlhL5IzfFRt/R4JSiH+q9U17ayVbf5ZduEyl4QthM+wh6OOCpK9t2YFL
         vTD6Z82nAXw0DSCoFiRV3p3z68QwZHcsw+y0oVI9arKLFzbXJRs9kc+DSX9fXHUw9jHk
         g0RHpcxG1DfzCI4sGYZk5lLS3HmQS1HXVIC4XHZoCxCtEaY9l008VbA96KDss1M6519N
         AkzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KogAxpggl38aAtutnQH63h6HBVBEGF0LaJsnW/om7os=;
        b=CWqwUw5/4BAx3dA/iv+4m7TXTCzey2CsaT7T7s6gK8Zz9peQUHGSuYUV9V4uB3MBBT
         fb41fhvkpPoz9AYMlB4Frzx5EmwTIVxJvsR0SlowdCa72aUj2Mg7DTSdAZYhsleqjyzL
         NqtaW3NYFEW0y1VKkhYWU9uj2dUQ71B3o+7fQNr9gOgU+GrSwD77rBo1p+4HDe9DD464
         PLrQZMsb5N+2qIXpMddqCz22qwnuxWY2fhw5bkoWDgLuqdFJAfX4hjodP+yxOkr8JZ53
         Dif0rdEnnRKg3FAjsbsT9Oh8xdMg9BFPSTPeRw8ex31YMsgWDSDsX/HUu81smYH7K4P9
         +tlw==
X-Gm-Message-State: APjAAAVxcKD+0XDbuajdvXti8TlBVfrnxKfR+fbZxKJ9MldWJXCBaqgm
        INFP1dwLJiaJ2m4DxopPeo030yLS/h4d
X-Google-Smtp-Source: APXvYqzUD++4YsrGOO/Mxbs2o1LZaDwXxfCuRylkwoWJ19wJscy4Ia9h/ZQuyUf3n3OsRI0nBJGYzw==
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr5617115wrv.240.1581713343436;
        Fri, 14 Feb 2020 12:49:03 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:49:03 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TIPC NETWORK LAYER),
        tipc-discussion@lists.sourceforge.net (open list:TIPC NETWORK LAYER)
Subject: [PATCH 27/30] tipc: Add missing annotation for tipc_node_write_unlock_fast()
Date:   Fri, 14 Feb 2020 20:47:38 +0000
Message-Id: <20200214204741.94112-28-jbi.octave@gmail.com>
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

Sparse reports a warning at tipc_node_write_unlock_fast()

warning: context imbalance in tipc_node_write_unlock_fast
	 - unexpected unlock

The root cause is the missing annotation at tipc_node_write_unlock_fast()
Add the missing __releases(&n->lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/tipc/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index d8401789fa23..cc656b2205db 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -367,6 +367,7 @@ static void tipc_node_write_lock(struct tipc_node *n) __acquires(&n->lock)
 }
 
 static void tipc_node_write_unlock_fast(struct tipc_node *n)
+	__releases(&n->lock)
 {
 	write_unlock_bh(&n->lock);
 }
-- 
2.24.1

