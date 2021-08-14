Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E573EC49D
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhHNSuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbhHNSuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:50:35 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AA7C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:50:06 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso25830195pjb.2
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YiG0yf/5wgs/7bW0GtAApT1I94eSGtteWf/SCyGxK60=;
        b=ZSBKAY5SVXsDirai8GbkoELklBKSaQxsN2MoKBhKbmGtANukS+lSl2lxrGEQ7umxBt
         m3/q8tgw+m++M21nLbpGtm3a8K1f5uSswEz3iaIJA7FQBUUNExAyixF+mXd4NK3v6M4x
         bv+aUOpIzTUpJsM3XBZB3dZk49COqhAELzzr5lW0CE+337xBfod6u3dUd8iZk841rvhm
         7GWSXhYgfWcMjHs8lZcz9cW11I9HBhOYr33fZ4OyeN+RsQMY/sgCLROUqdIk5D5ozHVP
         Y4+web+26EZmITUPObalP1KZEIkngNVjMjbvmGM1OAhn4AP1D9CtRYukyMaNXAVi1qGi
         Welw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YiG0yf/5wgs/7bW0GtAApT1I94eSGtteWf/SCyGxK60=;
        b=cjYirlgQ4gadJ8hDtMrB/2Y+zf4fGwKtGPrLuxwxF0xGOjL2ld4asn8xPTLHQoEsJN
         DV1mIsZv4uwLcUJaihSR3qUs5R+eg1Kk5IIJrFdvGUSBBk8Nuez7KFcXqBDRDda2PRSh
         yOKWE1ocOX6NTEDnUkOzfbxISO/ir7f6eNZrsIEgNFWV8a3ZUxiUGI+V3xuyEfXsnJCE
         k52yjg2c2BwWoqDfByUB9yG80RRJNs80hMFN6zIm+b8WM/8kf+fKf4GJP+7jRxPp5Pj/
         kHl/frEtUXr/PyMzjL1Zkg8/xdFspNNSLCy78XqplIysRCDaG+rmPNl4uMoiiGd0hGzr
         83eA==
X-Gm-Message-State: AOAM533nziTkHNUhN0CJVZGxCSKNhXkGwovI9m+aDFxyO3Ekd/pYPBr1
        oqEbR5lRsQecSwYwhTqLV2GWRPyyP5YpJCaC
X-Google-Smtp-Source: ABdhPJyci/Yp9Y6kH3/UOND2m7+oVMVKzMOYPl/Xg9zroHIm9Wb4n6krX0dxeH4RoAe9ZpQi5cRz9A==
X-Received: by 2002:a17:90b:3794:: with SMTP id mz20mr4071219pjb.63.1628967006150;
        Sat, 14 Aug 2021 11:50:06 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id r16sm5294736pje.10.2021.08.14.11.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:50:05 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next v2 3/3] man: bridge: fix the typo to change "-c[lor]" into "-c[olor]" in man page
Date:   Sun, 15 Aug 2021 00:17:27 +0530
Message-Id: <20210814184727.2405108-4-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814184727.2405108-1-gokulkumar792@gmail.com>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 3a1ca9a5b ("bridge: update man page for new color and json changes")
Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 man/man8/bridge.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index eec7df43..db83a2a6 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -22,7 +22,7 @@ bridge \- show / manipulate bridge addresses and devices
 \fB\-s\fR[\fItatistics\fR] |
 \fB\-n\fR[\fIetns\fR] name |
 \fB\-b\fR[\fIatch\fR] filename |
-\fB\-c\fR[\folor\fR] |
+\fB\-c\fR[\fIolor\fR] |
 \fB\-p\fR[\fIretty\fR] |
 \fB\-j\fR[\fIson\fR] |
 \fB\-o\fR[\fIneline\fr] }
-- 
2.25.1

