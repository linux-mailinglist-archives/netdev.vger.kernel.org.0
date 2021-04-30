Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072CC36FFF3
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhD3RvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 13:51:19 -0400
Received: from mail-qv1-f52.google.com ([209.85.219.52]:40694 "EHLO
        mail-qv1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3RvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 13:51:17 -0400
Received: by mail-qv1-f52.google.com with SMTP id l2so16917580qvb.7
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 10:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qc54FF43JqJaIGSgvPrj0BKlFrRLkNaveR9OaGdik7I=;
        b=LCXpyEi5uBzQRY+TwyWpUF/oOhdqVpavWvnr7dyYixVsVheO2hYu/NnPIi45QPq065
         91LHgqNKY4tJ3Am4egU2zinWzBeaRaYD7ox/aRcxa56nfLmxNlGQXHpSfvqQM7t2DojE
         rhaXBxUUj6bAJpTXA68bFNE21G9ybKnvEtedAcfA+npEf0lTjkH0nuNdu05PxhAP+XFm
         HQHP4+Sdipxh9Qexpx/TkcanZ7akpC2+94gf450aObk91rWlzO0FxLRzyMQhQXCNIfnD
         oZX0Oe6MSYf2NjQOSsKAqc5dg4lhnebXOC5pVZEno8xvUMhAhrjaZtk/ZKdBo7v877Cu
         nHIw==
X-Gm-Message-State: AOAM530wfHXuHuHqm1chvo25Yzy0qIrvmSIqb9KSQofBArvN0z6O80R+
        p0hGVLBtvmh+5YDQiMur6+M=
X-Google-Smtp-Source: ABdhPJx3H9pXK7rQuWhqfbesoFY3ofmhL6EVIpJn2d9lxXHLHUo+CPd21yTU+zyE4ulLqimNEP7e1A==
X-Received: by 2002:ad4:58a3:: with SMTP id ea3mr7113012qvb.22.1619805028251;
        Fri, 30 Apr 2021 10:50:28 -0700 (PDT)
Received: from birch.fiveisland.rocks ([2001:470:1d:225:ca5:faff:fe9f:a613])
        by smtp.gmail.com with ESMTPSA id e15sm1925540qkm.129.2021.04.30.10.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 10:50:27 -0700 (PDT)
From:   Marc Dionne <marc.dionne@auristor.com>
To:     David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH] afs, rxrpc: Add Marc Dionne as co-maintainer
Date:   Fri, 30 Apr 2021 14:50:09 -0300
Message-Id: <20210430175009.14795-1-marc.dionne@auristor.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Marc Dionne as a co-maintainer for kafs and rxrpc.

Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2c3af92d57c..b8b744c58b76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -624,6 +624,7 @@ F:	fs/affs/
 
 AFS FILESYSTEM
 M:	David Howells <dhowells@redhat.com>
+M:	Marc Dionne <marc.dionne@auristor.com>
 L:	linux-afs@lists.infradead.org
 S:	Supported
 W:	https://www.infradead.org/~dhowells/kafs/
@@ -15800,6 +15801,7 @@ F:	drivers/infiniband/ulp/rtrs/
 
 RXRPC SOCKETS (AF_RXRPC)
 M:	David Howells <dhowells@redhat.com>
+M:	Marc Dionne <marc.dionne@auristor.com>
 L:	linux-afs@lists.infradead.org
 S:	Supported
 W:	https://www.infradead.org/~dhowells/kafs/
-- 
2.31.1

