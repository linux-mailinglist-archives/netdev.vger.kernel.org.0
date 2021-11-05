Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A66445D47
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhKEBaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhKEBaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 21:30:02 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28271C061714;
        Thu,  4 Nov 2021 18:27:24 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id br39so7494929qkb.8;
        Thu, 04 Nov 2021 18:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Xui+a3EK1z61jNsJQ3T/3ku4mEgu4IIsatnBZ3fDKI=;
        b=ep3kE/QqVjku8S9jr4faGMxo5NY5EK0sraapLwJZ2iDKsdAVm68MsRqS+pt0R8tPt0
         /UtFhr7KdkmJyJcki7Z5ZIeA5DE0srfJjKswjWj+rGXF6ka2oEejPWzzHxgOcazlEmy0
         oR470nidjZIYyxzvQtmspCsrp5R9/VqppQa+jacixFvXvnynEK+ouy85rG1Cab9imBN3
         Vg9lNnknO5ZWAW4rozoC8Cg3btHIwfSbM3YoqSNQxSpwJcaMIFvDn/mLwhH3GcLyRoCP
         EsWL5A2mAGBEP7pfqeSL1lBcJ4hCHBDXn5RbQDctQLhDmq9TOOz3SwmU6wLUggMdXlM5
         FRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Xui+a3EK1z61jNsJQ3T/3ku4mEgu4IIsatnBZ3fDKI=;
        b=BWSRiWo5XELCOB3fgmWKJ0S7sShnN0/XbFXM6WgEMJ0fU0i8lQ1Z6CMvxLzsn2Ytm/
         zPDjjZxiThY301AgKI7jQRhgzpdZtn3ijdgegFMU9EPwV595ulJvnxIJ6fLGNuvOAPhR
         gIIlWAcgslc4LVu0A++hEZkKvnYG2XPTw7uva69GlQcSVGRFtgftLxtdMoDbjPpe/x+6
         MjAck6JjofTkTkLq4EJ8m3B6ko/UGbjG6fIB3UNHkYgHhRuJ7bsphplqndQdETof5SjN
         xPwYCU7Lh2w4uq6DdLyaZhOq3lWfq5MEj+wAQNLaVQLT7vSuFAvE2D5DOBRMb9dP73pG
         mR6A==
X-Gm-Message-State: AOAM5310zSDSy9HfIbjESN5t7g2KiC3/kuzzI+wmL8u6lr42KvemitcG
        S2R3sfBoRHypNB1p9iOwIAE=
X-Google-Smtp-Source: ABdhPJyG4C/5R5B0RsbWnMSZWgdQiX29aJ/NvZVoNCSGsIiaNowti/AnRbTDjoTJq87DJDO5e3OJBA==
X-Received: by 2002:a05:620a:40c3:: with SMTP id g3mr7498570qko.435.1636075643405;
        Thu, 04 Nov 2021 18:27:23 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id bj32sm4803423qkb.58.2021.11.04.18.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:27:23 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     ap420073@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] amt: remove duplicate include in amt.c
Date:   Fri,  5 Nov 2021 01:27:17 +0000
Message-Id: <20211105012717.74249-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

'net/protocol.h' included in 'drivers/net/amt.c' is duplicated.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
---
 drivers/net/amt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 60a7053a9cf7..fc75aded1b6f 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -23,7 +23,6 @@
 #include <linux/security.h>
 #include <net/gro_cells.h>
 #include <net/ipv6.h>
-#include <net/protocol.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/addrconf.h>
-- 
2.25.1

