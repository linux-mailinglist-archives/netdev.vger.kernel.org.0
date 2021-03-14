Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC333A7DA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhCNUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbhCNUSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:18:43 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FC7C061574;
        Sun, 14 Mar 2021 13:18:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso10987731pjb.4;
        Sun, 14 Mar 2021 13:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Mcp3lGwsje4BIAmwaCNDjojfjxVqF6Fpw51fexYvzs=;
        b=LsPZwegU/t0LrKDfgLr+3fKERTqg4zWV0Lt/qbnTOqsa979WeKDkGhQU5NeGVQwf0R
         ND9ALduupYj9apmK8vOhkBcLYBLfKrS6WxhslWasCRHW78/yTRlOJezihhVPirTr+6Wd
         cErsvsc4dydjRZxnk1Vum26yPPzDt/PjCjAgWyG8E0Ocah1Z8bVgVFT6K/DJ9AICY0E4
         lCTdFC+k2UUtlUoN7qH3Laxvqg9KmErvJQBTWN0lBNCJiTwmRVy56Wr5yWOv1urxarAm
         GEf99JAD+14SVyejsvRjM66FSISsg8PgdgPdrkAC/afJzIarTkdDt+AHZtqSYZQo7zBi
         c3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Mcp3lGwsje4BIAmwaCNDjojfjxVqF6Fpw51fexYvzs=;
        b=oM8yLQkbJnNTHFquN4Zwu//ASAmgTgUjEK70/iA3nzMiwONK8UW676kkFKquI/k9zB
         pcIELNO2CxsySN9G73p/5rK3PUQvRTpJLzXUXRYjkrNAhQq+GEfOQxV40s9XU6BYD74r
         ABxZYEEJiUyWBzikci51uTrpAnVlb/dAtJGoq/GtsgwuKIr0fkTfh27bZZlIeg6rpWgC
         cTtHtZwq4UYm/yHxhDPtLoDnv8vjvAdoHYspf2Oc1kW6TaE9PHMLOTZjhmRakZKHKfwG
         6WIb19hT0Ae+F/DR8JPT1P5CiX5onq6sxXk6nC312wmUqQ+f0uuSwpvxkFrLBHomhl7C
         CuoQ==
X-Gm-Message-State: AOAM5326iU8RUKT773p3rXi66bv3X2IoNmGLCPw02jJ59GfZVUQRy+Cd
        kOKx+oCabkgO3snK6Z1aP9uoDfkprRUEIQ==
X-Google-Smtp-Source: ABdhPJyuy+NdTPsePblREl8s565VknNmj+s2lIm5V3Ul4GnzfVHdqAfSaYb0aPjovqQKjZXIJPBoEw==
X-Received: by 2002:a17:902:344:b029:e4:a7ab:2e55 with SMTP id 62-20020a1709020344b02900e4a7ab2e55mr8318891pld.63.1615753122835;
        Sun, 14 Mar 2021 13:18:42 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:18:42 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] rsi: rsi_ps: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:11 +0530
Message-Id: <20210314201818.27380-4-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_ps.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2017 Redpine Signals Inc."

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_ps.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_ps.h b/drivers/net/wireless/rsi/rsi_ps.h
index 98ff6a4ced57..0be2f1e201e5 100644
--- a/drivers/net/wireless/rsi/rsi_ps.h
+++ b/drivers/net/wireless/rsi/rsi_ps.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2017 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.17.1

