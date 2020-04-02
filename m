Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF2519BE67
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 11:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbgDBJKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 05:10:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34710 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgDBJKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 05:10:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id 23so1489266pfj.1;
        Thu, 02 Apr 2020 02:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lyeZTvUdEO08q5cYNk+mvRstQFpcEQbu5+5Lc8L3CO4=;
        b=Sj9DyXa0Fu1r1eUcNACjYWM5FYKBqJkd0peGKUD6heoPM4JE3ks646BR7INqOIVkzn
         n7W/oQW3TkKszyO3DpbgnrCQkqLRQXCGGmDzkBDcjaNbMuzTsmMPYOtGuL/t4URasxte
         WMwJOJumT5iDeVLvZ1IMBNxNwstseWTQ1kx5IkhAOLLSZykkkJ7hYx+N7CO4vQ/RUR2g
         N+H0tgjnar+mwK9bTTBTGrlBpOhrza8VRcZyh8Z+8ts92jRtcmMYnvly4qr7ur/dSaVn
         RdwuWhYPpJYs8/9YiXDItsr2P5DeA6sg/o3HvZQgBQcmPjQ935IM4tWSZTWNjjyXAuCM
         l5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lyeZTvUdEO08q5cYNk+mvRstQFpcEQbu5+5Lc8L3CO4=;
        b=NoGeJFz0TxW1A1ty756fg0YUQj4dci4APaiwIhN98s5Sb0J0JRZzJFajk60IQU6PYT
         YJsW0m9f0yanV1xExz/GB1LRAxyPKEKUfFqaYpVl6jUBHlgq9bcq0Q90vtaFUl0bhZgV
         +m/gAkZElWG37PARAReWYZLLdwyYkiAcskE9hEqkEgnLvvSagCgLYi1MO5cCSUXkvlVZ
         0KmGUMANrRPPiwP09MWqevWHufJOcbjbmdH9BFP18p1ZQ/uxYWCqBigU/aciDq+0YU3d
         0pa/1nO3zFUFHTctw8+9i2Mh94XB8gCExq8dWDXW6SwH7ec28UHydpo+nvx7g4hLvfTT
         HWtA==
X-Gm-Message-State: AGi0PuYe+hL0Ulv7ch1GSiSQ12dm4O9ekV9XL2j4ot7Iycnr0kRw+0xn
        fzrZpxYFf46sHQhf7R1/DYk=
X-Google-Smtp-Source: APiQypJbjLepPHtz3d5RSCznavAALcW1Hr49x+tOcSl02fzCkZGs3DhIvUfn8+x/g7hiUfWEn4y2Jg==
X-Received: by 2002:aa7:962d:: with SMTP id r13mr2301739pfg.244.1585818599370;
        Thu, 02 Apr 2020 02:09:59 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id d21sm3241749pfo.49.2020.04.02.02.09.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 02:09:58 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, songliubraving@fb.com
Cc:     akpm@linux-foundation.org, skhan@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] lib/Kconfig.debug: fix a typo "capabilitiy" -> "capability"
Date:   Thu,  2 Apr 2020 17:09:54 +0800
Message-Id: <1585818594-27373-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/capabilitiy/capability

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 69def4a..20bf1ee 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1628,7 +1628,7 @@ config FAILSLAB
 	  Provide fault-injection capability for kmalloc.
 
 config FAIL_PAGE_ALLOC
-	bool "Fault-injection capabilitiy for alloc_pages()"
+	bool "Fault-injection capability for alloc_pages()"
 	depends on FAULT_INJECTION
 	help
 	  Provide fault-injection capability for alloc_pages().
-- 
1.8.3.1

