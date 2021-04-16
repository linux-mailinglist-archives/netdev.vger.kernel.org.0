Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30702362710
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243430AbhDPRmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243342AbhDPRmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 13:42:50 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84993C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 10:42:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so16790130pjb.4
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=J/EB2LxyJxB7LHeDWNc0wSSLZQHQ75n2tQwgS5AXlME=;
        b=cZTHkpp448PuJREH9pfb6axfD9zOKFFs9I0L4IxuqETij0FTJLFnU51nPNltt+BdJ8
         K2q91bNT+mcHHmI0RI5qrBf8lH2moC31HRZwp6BvbFrJwUD5bqSBokMSqwi+FlD6q5iu
         7TsC2BHu2Cn2939EyLIxxQTn+XaXRzqagBdQDK8DSTMykKcbrK0ptwM575dMWo+9g14c
         VmD7GsO2AlrI92gw4RfXbkFISxTEa0gmtfLQSPbTqj7uDJwHaFsELyfKM0EmDzQO3L/4
         QDKvwC+zbkCi8ydt5kwCigowgUFNaqqC1scg5wlMEBEw+1ctXZ+C/MRu6oYZzH+KOPd1
         5fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=J/EB2LxyJxB7LHeDWNc0wSSLZQHQ75n2tQwgS5AXlME=;
        b=iuxYmCbZsy5ii1BG07XcNNk3JB0WHXLqZGV7p3Lz9Wxuplhrhr5/gzUslka5xIyyZ3
         oZLMd2CT18Wr8jEfcuglxbLFMcGrHb4l7An7Jkt6mHGs8cfvMPXuQF/QFCBXYH4UfX3J
         6iNRtRgnxy2LZxMMkgT5W96+pKnDCv4JnEa3Xty9Xb3W8G32bMDoC+eFNQQLjIh/j006
         yrWGbZpawoIFT1cEI8p2bfoOKycccdsa/yelpmuWlChcpKyIuGTi2U6NYnmwqNxr6TT4
         LAaoHOBTTD1QdMcR6477bQG/E70PtAsTJpg3MLChCctgPXWP5jtpjnyGYVh6so8yKapl
         rGLQ==
X-Gm-Message-State: AOAM530eaehR/7YYzO2NR57PsApFckfbmI23m+bDXfMQdsDahcFSQj5y
        5QM1qEDVxRn/RoPyXOjaMSs=
X-Google-Smtp-Source: ABdhPJweiyH3YPaGzs1OKST2Bvbl9q1mQEWGqXok0wo8oxbjOqfrrS6SKLwzfu9t8rWukOgwO2YEog==
X-Received: by 2002:a17:90a:b947:: with SMTP id f7mr10528163pjw.166.1618594945114;
        Fri, 16 Apr 2021 10:42:25 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id i66sm5181575pfg.206.2021.04.16.10.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 10:42:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] mld: remove unnecessary prototypes
Date:   Fri, 16 Apr 2021 17:41:48 +0000
Message-Id: <20210416174148.26589-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some prototypes are unnecessary, so delete it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/mcast.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index ff536a158b85..0d59efb6b49e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -75,9 +75,6 @@ static void igmp6_leave_group(struct ifmcaddr6 *ma);
 static void mld_mca_work(struct work_struct *work);
 
 static void mld_ifc_event(struct inet6_dev *idev);
-static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *pmc);
-static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *pmc);
-static void mld_clear_delrec(struct inet6_dev *idev);
 static bool mld_in_v1_mode(const struct inet6_dev *idev);
 static int sf_setstate(struct ifmcaddr6 *pmc);
 static void sf_markstate(struct ifmcaddr6 *pmc);
-- 
2.17.1

