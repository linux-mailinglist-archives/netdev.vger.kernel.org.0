Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CF4231CED
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2Kv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgG2Kv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:51:57 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71662C061794;
        Wed, 29 Jul 2020 03:51:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x5so2296446wmi.2;
        Wed, 29 Jul 2020 03:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MfydqwIyqBHYbsx5YX+ht7t/yzaaahxnXqOFDuf3JO4=;
        b=d/wwpZmeZ+/LMdotSSAcC7Ni3EYCBWqFxvTfazuOMQ9rwsGTnG8Lz1+adN1ve0+0L2
         ZCklyYkB5bjphiJLJQW/kOUwBCwCizXZpZtr3DPK1q7u7M1njgB6JKAAXKjsD/vdyvdO
         ft77u9FQvWvO2bEMvoixTKiVOfK9iPwlr1ItQdDSe1fYnteeY31GmRwRKNScou0WouvB
         eOBjyin8iwGZfBhdKJEBTLL7yGRfVFh3jL/rsa36h/zPsseiuSphB89h48elDApKQW0g
         vXXDk/sIBOHxVi/n9re+PswQxEk5AYMsuOlIp5glig8AzQGn5EqmZGivUePVDwGnsy8h
         mujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MfydqwIyqBHYbsx5YX+ht7t/yzaaahxnXqOFDuf3JO4=;
        b=HtJLo/yt0reGT+VOvdsAmPmdBobYhAvZnS3evEXz3ZG1M9i+Qj8STbqulkOOpIUtsM
         cJ96wLhiYlOpGGId+VgoJuvtjYkT6HGXcLvmA7yI38cqWBTe4UG9qEdqEhLMe3z/OP3r
         Me8P+QsVwuPMS4xaFLR+2NthMYWmSHCW2hR14feerbgJrBqF0hHj57b1Pjg8R1JuUkZ9
         /Y0EoOfzVQParbz08KrgXalXb/wkw2uRnHe8FKao9Q229FN1A9Np6jh/SAXAdjnGhb0O
         pdvCVqSMGtKvqhuN1fS+X6FqG6EVpmh9cDWxjpYt9qGWC4QCo0f/d3WBz1cv2mlHdwwL
         aUGg==
X-Gm-Message-State: AOAM531FmMESGGFGFAn7kPm2CTEpaufZxL6XIr72FKiucJT/UYkcEgCz
        0zFWd9pWVPgXwSFJgrVs+6s=
X-Google-Smtp-Source: ABdhPJxFD5dqpPgkq3nn8KnWDfcUuF3QzF/XcP2WVwa+ah/rtsjppFnQ0SlZgVGBx/quaeHZekwOpw==
X-Received: by 2002:a1c:5f41:: with SMTP id t62mr8572734wmb.134.1596019916177;
        Wed, 29 Jul 2020 03:51:56 -0700 (PDT)
Received: from stancioi.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id z15sm3955697wrn.89.2020.07.29.03.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 03:51:55 -0700 (PDT)
From:   Ioana-Ruxandra Stancioi <ioanaruxandra.stancioi@gmail.com>
To:     david.lebrun@uclouvain.be, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     elver@google.com, glider@google.com,
        =?UTF-8?q?Ioana-Ruxandra=20St=C4=83ncioi?= <stancioi@google.com>
Subject: [PATCH] uapi, seg6_iptunnel: Add missing include in seg6_iptunnel.h
Date:   Wed, 29 Jul 2020 10:49:03 +0000
Message-Id: <20200729104903.3586064-1-ioanaruxandra.stancioi@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana-Ruxandra Stăncioi <stancioi@google.com>

Include <linux/ipv6.h> in uapi/linux/seg6_iptunnel.h to fix the
following linux/seg6_iptunnel.h compilation error:

   invalid application of 'sizeof' to incomplete type 'struct ipv6hdr'
       head = sizeof(struct ipv6hdr);
                     ^~~~~~

This is to allow including this header in places where <linux/ipv6.h>
has not been included but __KERNEL__ is defined. In the kernel the easy
workaround is including <linux/ipv6.h>, but the header may also be used
by code analysis tools.

Signed-off-by: Ioana-Ruxandra Stăncioi <stancioi@google.com>
---
 include/uapi/linux/seg6_iptunnel.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index 09fb608a35ec..b904228f463c 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -38,6 +38,7 @@ enum {
 };
 
 #ifdef __KERNEL__
+#include <linux/ipv6.h>
 
 static inline size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 {
-- 
2.28.0.rc0.142.g3c755180ce-goog

