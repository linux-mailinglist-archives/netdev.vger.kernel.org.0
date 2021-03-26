Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A5634B2AF
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhCZXRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhCZXRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:18 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78304C0613B1;
        Fri, 26 Mar 2021 16:17:18 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id i9so6982732qka.2;
        Fri, 26 Mar 2021 16:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9KCRpPDC2iAS2gYBg5DxIYDNhc1//uooALiBNEWsL64=;
        b=QFpFaxua8XZwmGEzP4lckNOgSDSsKv6E2ntHlDs4kqX0w2AlGmim/rhI+pIlaycX6l
         WqrUBBe1r3zxcfPYlvjUcYFgbF4uB8Pyti7+5+s3CfKnugdFAufKSUK8V5k6F1Mh1m7k
         e5LcDO40OQpW0i3/Z7CarlC7jOBUCOAEO5DWWll+MObEJoa5CglP6kdMYNpQfXlId6r+
         gbSUDJpvzW6lFaiNZaj415kck0mNnhMXWeqFi+H+W8E/u2ERTfJXkcys4Nqm2y9P2Ibj
         AH2Wo3Zc+rYAup6M3QWHI6odvz237vu5hPCts56+HNWMHQV36rj5GlWX9h2a9WdJIuYG
         gbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9KCRpPDC2iAS2gYBg5DxIYDNhc1//uooALiBNEWsL64=;
        b=prOrOnz7wzUPli0oBZYiUj6o0LLQKbYfJ1O5vn9ivaLY5Q2TSstRk6FFfQHv/7b8R3
         T6ic+AgfOa1ux/08UqFgUKE28PpvwI5wDokO4crFNnLDqBm6VbLmt0jSWqUz75p0w0W+
         MDD9ntiBXLzRW0EBc0L7DV63H3IEcxqO5y0n/g+WPMB8uYjo5LLOECW6m9o03WvS4YvJ
         W/d4d2Jbl5W35ucjmmpTmgGvfBkn10fGOl7/AGYqKdwsq+1VdYebHg3cg99od01TpHm9
         a6iUiEuVyOI06Hph4PktLmVHBUPBHzgGnKZf3clt60TLweWa18opG5Hdgpa7ys6CWdEt
         wp3g==
X-Gm-Message-State: AOAM530wuhNniT/+yq4Vrf5FkAYWcc6MN9ljQR8bT8ZAfaKh6fBwyaEe
        op1emHNsZvevRz0USFBDIu0=
X-Google-Smtp-Source: ABdhPJxTOWIZpLSyBYKNeej67gRJedNUvLEqSkPgWdQVv7NPww/v7ZCRGTijjKe2iAFdpyVYbjWJzg==
X-Received: by 2002:a37:a5c2:: with SMTP id o185mr16202710qke.428.1616800637826;
        Fri, 26 Mar 2021 16:17:17 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:17 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 01/19] xfrm_policy.c : Mundane typo fix
Date:   Sat, 27 Mar 2021 04:42:53 +0530
Message-Id: <6def1865e5485697e3c58e94ba8ef2de6349dbcf.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/sucessful/successful/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b74f28cabe24..156347fd7e2e 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -688,7 +688,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 }

 /* Make sure *pol can be inserted into fastbin.
- * Useful to check that later insert requests will be sucessful
+ * Useful to check that later insert requests will be successful
  * (provided xfrm_policy_lock is held throughout).
  */
 static struct xfrm_pol_inexact_bin *
--
2.26.2

