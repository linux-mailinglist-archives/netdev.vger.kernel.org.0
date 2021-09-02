Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B233FF229
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346542AbhIBRSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346521AbhIBRSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:18:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B0DC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 10:17:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso1958450pjb.3
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JCQLtIvAZ2LIUN8s6wB15FfFm/gvbEZ3cdo8q/QciGM=;
        b=DEXc8c22/gOqmAo3Af4Qv2mFjFpb7Ob0RZ2lIZ8X88LP4+meAMh5aqN4AUANT6NrsN
         GsIVlEW371HLySsqhWRDVXv1T2WfPwUOeGwZt7ZZWIvjNIMzQxN0oYJwc9lugd4GVPZn
         vS110btRYFC4xM+mOMunHb8ZZABsgkDR/ZDLFFzrm0saXHf/d5Anr+uJ8Bq1QmvfxZcu
         0a97ZAnYcJZ74Fz9xhp/uw18XIiLRq8WzZFc2G9jNHsyLGdLD8mdDoCh+SHx3Uoavy6h
         N6AygkinZUZHpfFGKLPEUb02YEC87Ixo7lPdP11FFPtH5gtKYpBbX97ICh2gYReuRbSM
         niOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JCQLtIvAZ2LIUN8s6wB15FfFm/gvbEZ3cdo8q/QciGM=;
        b=df65wy2WnA+ncbcJrNYmfKRBjKb0cnLaqYHqtDvBCnlW6DhqJ9YCo/XsL36od0qKjz
         UQUiBWQBUT2FqYmww+Pl4irJMwCwYPx/ZLyVj6LCJitaOeFu8uvlCsxp6XIsMU2f6srj
         +P3//wnzTjCCdMZK+zQay5tTC9JXe2z3N+SnYv+kRaaDvmX/EeYCD5hNlUggmieQsoec
         nL46E0LYaBStzGgi8eggmNOngVYYmlOMqkt3qSt2chtGiUn3RhyE0HjAVaUCHl4VI4N3
         imdPmtoRUiuWwAsB/UQsmfGfM7sCx1ft7If2xbzmB5X3LLsuw2JuXLdxLqiIYgcO89js
         OLxw==
X-Gm-Message-State: AOAM531nZFkagH9zkl6R7hr7awNK3oKxGV+ADYgdr4Lu0go21x1XjmHR
        gXTzKeZ4OXwyNSvq3ltrZHnC7pPoRho=
X-Google-Smtp-Source: ABdhPJxLMohl98sWOSMtl/TmdxItmH3OLrmobf8vfKUeGrVYSvzdPSobNSWcYwD1BUkiB1RhVWgmig==
X-Received: by 2002:a17:90a:5583:: with SMTP id c3mr4840407pji.133.1630603033248;
        Thu, 02 Sep 2021 10:17:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9bb5:cedf:a62f:92ff])
        by smtp.gmail.com with ESMTPSA id v9sm3419214pga.82.2021.09.02.10.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 10:17:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net] pktgen: remove unused variable
Date:   Thu,  2 Sep 2021 10:17:09 -0700
Message-Id: <20210902171709.1965320-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

pktgen_thread_worker() no longer needs wait variable, delete it.

Fixes: ef87979c273a ("pktgen: better scheduler friendliness")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
---
 net/core/pktgen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 9e5a3249373c239f0d3ba2088f79a09cf4085403..a3d74e2704c42e3bec1aa502b911c1b952a56cf1 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3602,7 +3602,6 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 
 static int pktgen_thread_worker(void *arg)
 {
-	DEFINE_WAIT(wait);
 	struct pktgen_thread *t = arg;
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
-- 
2.33.0.153.gba50c8fa24-goog

