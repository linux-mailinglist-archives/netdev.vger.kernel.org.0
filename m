Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA2634B2C8
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhCZXTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbhCZXRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:55 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37881C0613B9;
        Fri, 26 Mar 2021 16:17:52 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x14so6949963qki.10;
        Fri, 26 Mar 2021 16:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnZft1bM0JMPpkTaiyM02YRpy0hlthAHrUT+3UG4R1Y=;
        b=bRXiu/pg16mBlD/2xrgDo1V/V2ZOok6C2ceC195uT+IU5UKI0gjBhxGx+foNj3Q29u
         EQ7vXeJIPi3LR1bPrNpBjKcGRoC62NwJvJLqlZZ8YH0PbKqbSOQv8e581FjcSe4zUMzK
         YitEpSEk/0l7Mgfu4NesVAofJ5ol3VAbUcHN/lo3AhabqM9JfWLyXc4RM+upius8wxUp
         4E+iWwvd4w8c0Q4Iw7erdA5YFn8218JuU9G/fdljHzil86d9z6jBySvSlDdlzilaHFsf
         CKxDA9iCenGyXMFRN974Nj/Xa5UDk8CYkH/DqApCu1kWhPK9q3vo5kqbsC9MV53iRMdk
         Mnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnZft1bM0JMPpkTaiyM02YRpy0hlthAHrUT+3UG4R1Y=;
        b=KODs2oST+wEZEJQgXDXWFbeuWbQw0gjTT+k4g/Zo5sE11/U92dOY25+SumBWO4iYCh
         oZym9Lcga0+mXg5899tsnsAb0ChNIVHicnC0RVSpYdikGwohOAy9zKIJnEdK1JQ87mgC
         1Cwe+DuA/g0Wax7h4KONgFmVE4EltMmAJ0b77iolhDzRafnVuAPJCb8viIBkzxqIgGCV
         nGXEXhJaLDx2WW3wo5BuAHOeImniFysiFuGN9gaUq+1k1CWTIOA0LGCUUQwoe4bwDldU
         hF7bbmVAFtg0E897F7pBr7UfImc6q/j6pWQgS2WaHNU1L75CO+6T+J0d9TvVLpo05SJH
         cYuA==
X-Gm-Message-State: AOAM530H2OUgQML4pDY4XdrqNxLmzde6oG0YmCLd8LM4C6dfeteNfE5e
        DvUTY8gXQnEp0UB+MXTUrFo=
X-Google-Smtp-Source: ABdhPJx5iOiy7ktC6EgzIyl8QJvBXa/U08naxVfPRUr+ahtitLgEsda0Zu5ADXP2I/5fCwdyjPXL4Q==
X-Received: by 2002:a05:620a:14ae:: with SMTP id x14mr15457909qkj.237.1616800671571;
        Fri, 26 Mar 2021 16:17:51 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:51 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 09/19] netfilter: nf_conntrack_acct.c: A typo fix
Date:   Sat, 27 Mar 2021 04:43:02 +0530
Message-Id: <0f547b474aa39eba3a21f67ea9d5632d5e25b919.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/Accouting/Accounting/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/netfilter/nf_conntrack_acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 2ccda8ace796..91bc8df3e4b0 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Accouting handling for netfilter. */
+/* Accounting handling for netfilter. */

 /*
  * (C) 2008 Krzysztof Piotr Oledzki <ole@ans.pl>
--
2.26.2

