Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E993934B2C1
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhCZXSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbhCZXRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:41 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B7EC0613B5;
        Fri, 26 Mar 2021 16:17:40 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id q26so6979281qkm.6;
        Fri, 26 Mar 2021 16:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0UT0eAc/WxN20uAGGH7iwWrQljfB+fwRzyKl/S7QILw=;
        b=usNBCw+4Kth79cqiW422ZBerZtyKTSRsfhJ/UxpIqlQkn2e59oP94/hvl4nscqv12R
         0vgCha380mYyX1iyhRK8TidR+4yZ2Dq/vXCeUCRvaUSWJ+N1ioJxhpLbdWXIBaaeT6Fz
         6WAsr7df4hoyPxHSuzPn0PhMa8oFPdN5ilBuxAkAPif3DNfIIsINIV/Vk+MnzMFP+IDE
         UtL7qTsLZ5BYgDpKv+DsH1ys1vRfxMSITncuQKEHLFqJQHcCM6AYCxO86tZlx6PKx+jG
         Fz7N42DQlm9x+sLX1WIFRxQ+kXK77WKMnYcHu9JLFdXVXYwBi7fY92G4Kzyale4QuJ9t
         vlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0UT0eAc/WxN20uAGGH7iwWrQljfB+fwRzyKl/S7QILw=;
        b=HnTSaGdydTpMbQrKPUSB3w9QEUcnU84J7iMaX4fGgMNOs9gnFXPc2IETEkyD9+Pi4Q
         El7YVVaQ9uNbxebY6qahSxCssQVkdSmz5BCnEOgxTcKQFGWndAgiA1uokJ8qgjbdS5MD
         jeX6+Ngn/fQB1dLniLxuSWNGViRLlSqLsw0xFe1E8T29sd4n+nZyd1Z3k/ZSjaLIT65l
         EJsuQr+Hmf0CknAOgJjPnVHCDY7L9UFkFt5N+3CD6+mXWId3J/oOYJx/rnJbfJrb/n+b
         uMGq5kVQXZ3N5kOQYzTqr4MhiR5qZ8GcEDaYhwFQGF71RhbkDtVoQUpiqiljfZ605bFU
         guAQ==
X-Gm-Message-State: AOAM531JrzL7/M9p5pyJ47wIeZQh3Tf1xD9jKYcFVaAlbQignLsHRhB0
        d+FFnfrw7i3/EWljWByshQU=
X-Google-Smtp-Source: ABdhPJwKE3OKcWlRTgW2P9vLBsoV5qbbDf5LHSLFNF6s7Hj6LAuOQNzTy4HYUiUuhZpuyzwOhUwVpA==
X-Received: by 2002:a05:620a:120d:: with SMTP id u13mr15233040qkj.248.1616800660011;
        Fri, 26 Mar 2021 16:17:40 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:39 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 06/19] bearer.h: Spellos fixed
Date:   Sat, 27 Mar 2021 04:42:59 +0530
Message-Id: <b2e0f89c6bf1c931e597c26e046b36cdc62c2d56.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/initalized/initialized/ ....three different places.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/tipc/bearer.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 6bf4550aa1ac..57c6a1a719e2 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -154,9 +154,9 @@ struct tipc_media {
  * care of initializing all other fields.
  */
 struct tipc_bearer {
-	void __rcu *media_ptr;			/* initalized by media */
-	u32 mtu;				/* initalized by media */
-	struct tipc_media_addr addr;		/* initalized by media */
+	void __rcu *media_ptr;			/* initialized by media */
+	u32 mtu;				/* initialized by media */
+	struct tipc_media_addr addr;		/* initialized by media */
 	char name[TIPC_MAX_BEARER_NAME];
 	struct tipc_media *media;
 	struct tipc_media_addr bcast_addr;
--
2.26.2

