Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D7D38300A
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 16:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhEQOXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 10:23:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41948 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbhEQOVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 10:21:16 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lie6B-000656-4h
        for netdev@vger.kernel.org; Mon, 17 May 2021 14:19:59 +0000
Received: by mail-qk1-f199.google.com with SMTP id p133-20020a37428b0000b02902de31dd8da3so4849715qka.1
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 07:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=82OOlAIwP64xR04S/8tMzMB9vmbp2NYrxxBlohwxFY8=;
        b=iyiQxJVd8MyXWhOybfLpUxWOvVScRaTtOxP684TaG3bcDcvJRyPU5+yq4Vi64y8fPd
         kv+2qBzUDo/QiJ+ZDxgyzz8AR9SlNdfh//1J0a6PwyUiPBGhrRoQ2FNO7Qd75SVfvO4e
         nMVWsQnAxgHONKNyQeJqP0JqsRlHpSyu47HFNtjDGN55O2G5eLNPZNbvzQNfUvQ4BEFY
         Di67GBXgDUgAKrMn8WioIM0SMs4Tt7FuIdP8+FvWiup/dYjavE8LalQGF3oyOA9CT9za
         chmDOn7+ZsH4pJs3EJPVO1IJ6ZoOD8elK1hcW03iyBPofyJm5YAxkuBeToGklr0naI+q
         QdgQ==
X-Gm-Message-State: AOAM533dpQLVj3OrdP6xb6HiiH42/xPg/q+kHE+4LMiztEELj56gqad3
        nTbDZ+3q61AH7SljWa3rUolJBnAUhGlQzLjA4SjZk9wu/yPmgCjkknwwXiV869zDfJLHCglL5PD
        Zw+l2QHTUhAIjBb1XzazgAJ2o1tidsaj2Sg==
X-Received: by 2002:aed:316b:: with SMTP id 98mr55629461qtg.48.1621261198322;
        Mon, 17 May 2021 07:19:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5KGTkQ34wEiZg9VPj3fQHAHEsyoCggN6kbglzVZGLr5+gp9JI6Id5dZHTJJc1NrkhyZjkIg==
X-Received: by 2002:aed:316b:: with SMTP id 98mr55629445qtg.48.1621261198150;
        Mon, 17 May 2021 07:19:58 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.5])
        by smtp.gmail.com with ESMTPSA id v66sm10252247qkd.113.2021.05.17.07.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:19:57 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH] MAINTAINERS: net: remove stale website link
Date:   Mon, 17 May 2021 10:19:54 -0400
Message-Id: <20210517141954.56906-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The http://www.linuxfoundation.org/en/Net does not contain networking
subsystem description ("Nothing found").

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6582d19cdf7a..2104f05ded66 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12744,7 +12744,6 @@ M:	"David S. Miller" <davem@davemloft.net>
 M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-W:	http://www.linuxfoundation.org/en/Net
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
@@ -12789,7 +12788,6 @@ M:	"David S. Miller" <davem@davemloft.net>
 M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-W:	http://www.linuxfoundation.org/en/Net
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 B:	mailto:netdev@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
-- 
2.27.0

