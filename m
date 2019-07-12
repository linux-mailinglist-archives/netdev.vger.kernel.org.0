Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE8766F95
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfGLNHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:07:43 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45743 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfGLNHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:07:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so4751439plr.12;
        Fri, 12 Jul 2019 06:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M8wX1u1AyY8aIZh85CrgBQrNgkI4YoDiE4Y/ARBtWTI=;
        b=rHEVvDNmjPN89MNTOPTSN3d/nJEc78QJ8AYNecX5Bs+ZA/Q004H178HvUmWoI/vgA0
         GBEfWvjsCj4aGjGBm8uyQ7jsVLTdZcXbZUvRU5P8sruoji9Sb4qg/Z7NiJICtnpclT7W
         T8YAR54AWq1g+hvk0GeXSi/hhtl+XsJbZaWhS1tCw0dW2OKqEbmpGIVCIpW5FNs/7KJY
         WdsDRHhxgOJmLtwUYPAM1HBtYXaB8l66Nvsn7Eghe8itAoGMM65i37/Kc1bLc2bsCK5h
         9+DvE7ZXQJV0sV5bDMAG2Su6TPAKs7tXjIWm8F0dvrWMsL4kudNNmddXsFWMrxcI/ajg
         NKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M8wX1u1AyY8aIZh85CrgBQrNgkI4YoDiE4Y/ARBtWTI=;
        b=c7Cn1jEgYzcUgXnPa9J8zL6SW9hyvni4jktfMG7cZEsWQmrG7Fk+UBPeK+Q6fEsDO9
         xeh0PBvbO+COi2uuu3zHDQ5YGE2RHG1ErPXFMGrZvcL+8EzcvsrPajUnwN9h4pXYic0j
         LEOfNVhx/8I9rJ0/CmVzh3dUt0tSYOODx6VK638cVBt9z15Chd1DVW9VJAZu7xUblgu/
         qnfkP6bmnceNz7wCqE9RUIZOqdhPrJEGxg/+MLEYeY38KamxMUys9EcVfWPPkcsNmk2x
         G67nwXAi4A+W+uiEDpEt7JTNwh2d//8XyDLmUZ0P8x4SjuTVBzp8FMQN9Xe5B1EWcBkY
         cAzg==
X-Gm-Message-State: APjAAAWQlW9KspLvJvJYd3eXzwapLGKpb8Fli+2U9e8DzXBNk4Bi1wDc
        Y9mnfDvBETE+L/RXIwmuwMXN20yEK71VRQ==
X-Google-Smtp-Source: APXvYqwI08yHxLj+rqHZ2SOoSwsAdYzhFDnXgc+bU4NS5ufbC623hYguS3v9WWJuXnXHwyrM1JlkFg==
X-Received: by 2002:a17:902:7c90:: with SMTP id y16mr11585166pll.238.1562936862121;
        Fri, 12 Jul 2019 06:07:42 -0700 (PDT)
Received: from localhost.localdomain ([116.66.213.65])
        by smtp.gmail.com with ESMTPSA id z4sm15853303pfg.166.2019.07.12.06.07.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 06:07:41 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     wensong@linux-vs.org
Cc:     horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        yangxingwu <xingwu.yang@gmail.com>
Subject: [PATCH] ipvs: remove unnecessary space
Date:   Fri, 12 Jul 2019 21:07:21 +0800
Message-Id: <20190712130721.7168-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <80a4e132f3be48899904eccdc023f5c53229840b.camel@perches.com>
References: <80a4e132f3be48899904eccdc023f5c53229840b.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this patch removes the extra space and use bitmap_zalloc instead

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 net/netfilter/ipvs/ip_vs_mh.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
index 94d9d34..3229867 100644
--- a/net/netfilter/ipvs/ip_vs_mh.c
+++ b/net/netfilter/ipvs/ip_vs_mh.c
@@ -174,8 +174,7 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
 		return 0;
 	}
 
-	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
-			 sizeof(unsigned long), GFP_KERNEL);
+	table = bitmap_zalloc(IP_VS_MH_TAB_SIZE, GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
-- 
1.8.3.1

