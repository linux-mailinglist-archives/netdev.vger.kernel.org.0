Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6FD33A7D4
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhCNUS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbhCNUSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:18:34 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8D5C061574;
        Sun, 14 Mar 2021 13:18:33 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso10987626pjb.4;
        Sun, 14 Mar 2021 13:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YrpQBSr3kmqQ05MMAiX8qxeVEUbScERimugGDOEtrfU=;
        b=FUPCX3YGCDqysk8JERy1dE/s9n94COU7vOLJgoZpY4/5PswdZXkz9AShO4t9xuIKgt
         83rouZaINUwdZ/wDpufz1x1usekK0QJI1ia4WbDf/TCGRdzsOCt0KUCe99/PnqS9osCH
         3dRiXQuOpyd4Nq7re1Hb19Hcl4b/q4D7Gz385dHQCwhqnLCMJHIrMgo3PrNb9yNnDav+
         7Pi5S+nkO/MYqKjqe9JdBzuhFLIFDLrE/zS9Q0mBrnCtuc+cSRT0xSzhFTKHKqPqDcP6
         zem3CDhdgrM7nC8U7XY4cAHOBXyF+inQBA2cY2cx0aRn32ealfZN41P4WYBAtfNfZGj/
         JcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YrpQBSr3kmqQ05MMAiX8qxeVEUbScERimugGDOEtrfU=;
        b=VzUxjZp++uqXQSwz0bTUnDYX3A+hKX5c4b4bPeWMQgNVMm2O+uVYkydqsQtXCpUw2e
         Y2zoH8QBa0wlYb+Xh+TFS4+CxRZ55PXnwFaf6Y32dGxdfmgzz/r0pIm7E1DcMFR/KuKX
         Zpg1/AqFu+acWoGLzlOc+FVJdwgLtxk1j5hg9Ir/jdIIKAVB5Lznpi2cAwMD7XIWH3sr
         WRoqA8Vb29KRyAQj9Fj3YQvltKDNcbg93CIWnHkBumrbBcGwuKyExdYL/TLLldM6Yo/u
         J83godknUK6PeJNw//Rg+vTyjZZhZBfPzSjgThTzy3zR6ir5JgwcwmV1/KEk0+0FsU0y
         wrQg==
X-Gm-Message-State: AOAM530dIkwtYb2bxeppemQPgK0xrgZ8rHDv1w9KcUd9Z50ogHRs3qg0
        syHtACsSAhFtXsVOyAHIx+0=
X-Google-Smtp-Source: ABdhPJx+7SRyE/cHoNhgRUBi7/YwXDg+veeI3kf8cxZGinWvggxJ7eLjp2NkQ3wbZFa5TbOrTuChXw==
X-Received: by 2002:a17:902:f702:b029:e3:5e25:85bb with SMTP id h2-20020a170902f702b02900e35e2585bbmr8849848plo.56.1615753112944;
        Sun, 14 Mar 2021 13:18:32 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:32 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] rsi: rsi_boot_params: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:09 +0530
Message-Id: <20210314201818.27380-2-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_boot_params.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2014 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing these

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_boot_params.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_boot_params.h b/drivers/net/wireless/rsi/rsi_boot_params.h
index c1cf19d1e376..30e03aa6a529 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

