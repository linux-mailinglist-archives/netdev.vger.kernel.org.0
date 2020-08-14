Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE92448F3
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgHNLkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgHNLk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5F3C061386
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r2so8075854wrs.8
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jf/h0xGTx4mpZcVBL2eVQ18732vxKkSbgbH3BUucf5M=;
        b=cy7nHqzIvq0wnNuENxd5Y9IJY69qjarY/BmFqukoFAcDqsWc+en9MQgxUT2RtCUHBq
         ACbrCgua82jSK9AkVyMdXbs4qjdXH8yrvTVxm2hVWVtU27SeKr7epWd6N0I4MhVpa1X3
         8pOqzGd5rm8rZoqHy2PYUWi1fGK5THyhalMgVwSZwQO15p86Eo0efiKHDpvV8V7BTMo5
         P1G6HbbdwfWBtqNzTjmc/Tl2k4BjqQrMVFtSweOieoe29nVoYUcGOaqxskLPCJ609ylV
         x6hZzedmfaXM8fA2c44FyCnESqqyrA/v/ybo5i/UhBjuavSk8sGCfrJ5U2KCoE93yt+A
         lqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jf/h0xGTx4mpZcVBL2eVQ18732vxKkSbgbH3BUucf5M=;
        b=hOnlbz5pDU78eRSKTNtzegr5BKO8Q9EJvrp2KJIcWLNM1i5NBPDaTMD7KJFrnOYuwn
         WZe6a/G5Rfl3jtRaOqf/G57mORsQwvqfrBu+YdZySEG7nA/2ne/qFqYYzJWSv7lR70Hw
         YtSmHspA9k7lkAOZvJmDX+OxWnEFJd3U8E53legpQgY3qsTgfuw/GOEq7CP7OvUpl3dj
         7/x2Ok8BD09u7YAocbKkAosXhu/p4fUV2Kap8S0w7D6Jc4Bga0eQ05V/q6QuBYzaIHda
         xS/ggSTJOUe9NxKa6oSPDiS9ezVKVmVNmY1fSL/x09YeZGJs+c5SQt8+An/q7DLfThLb
         rcxQ==
X-Gm-Message-State: AOAM533/io6GOrJc32FNRdoVJ+WUB4sd50qB8x7PtErprHj4jy+sVlg8
        gB7BaENpSo4jS35MNSLLmWKDow==
X-Google-Smtp-Source: ABdhPJxz0kJNTMRg+DEd79XtboLvi2BDUMerrPdgfPEO4OpbwtS9WSNMfJ61LuO3kEwk1OkaXnSCVA==
X-Received: by 2002:adf:82d5:: with SMTP id 79mr2306897wrc.282.1597405224944;
        Fri, 14 Aug 2020 04:40:24 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH 29/30] net: fddi: skfp: cfm: Remove seemingly unused variable 'ID_sccs'
Date:   Fri, 14 Aug 2020 12:39:32 +0100
Message-Id: <20200814113933.1903438-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This variable is present in many source files and has not been used
anywhere (at least internally) since it was introduced.

Fixes the following W=1 kernel build warning(s):

 drivers/net/fddi/skfp/cfm.c: In function ‘cfm’:
 drivers/net/fddi/skfp/cfm.c:211:6: warning: variable ‘oldstate’ set but not used [-Wunused-but-set-variable]
 drivers/net/fddi/skfp/cfm.c:40:19: warning: ‘ID_sccs’ defined but not used [-Wunused-const-variable=]

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/fddi/skfp/cfm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/cfm.c b/drivers/net/fddi/skfp/cfm.c
index 668b1d7be6e23..4eea3408034be 100644
--- a/drivers/net/fddi/skfp/cfm.c
+++ b/drivers/net/fddi/skfp/cfm.c
@@ -36,10 +36,6 @@
 #define KERNEL
 #include "h/smtstate.h"
 
-#ifndef	lint
-static const char ID_sccs[] = "@(#)cfm.c	2.18 98/10/06 (C) SK " ;
-#endif
-
 /*
  * FSM Macros
  */
-- 
2.25.1

