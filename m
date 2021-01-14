Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF72F6D39
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbhANVb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:31:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728419AbhANVaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:30:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610659766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q2P0vyfvm+lC2mrTYNPxI2NyRvXwdgTknWpZPQ4nBmo=;
        b=Mq4MpoROuNdPmmC9yZO/lDhJ9EykltMTOkthMRSDBjMNoAWbsUaOOEPsXSyxSg7flp48hJ
        TXoJ8/zZDXD/xzl1BArDCN25gjP/9nANtLAK5bpWBzCdvWJ437UIFLC8DrBmio/9nTMhY6
        V05/Gtd1hh/W9miDtlH6CJcCNvvBAgk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-bHq1f4MCNtag3TYJu7uq2Q-1; Thu, 14 Jan 2021 16:29:24 -0500
X-MC-Unique: bHq1f4MCNtag3TYJu7uq2Q-1
Received: by mail-qk1-f200.google.com with SMTP id g5so5854291qke.22
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 13:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q2P0vyfvm+lC2mrTYNPxI2NyRvXwdgTknWpZPQ4nBmo=;
        b=fRdMg5nibR+5Bdz9xpUeKIBGBKTNOLn48ZdRiFU17+ILqIaouqFwermJe1WV6sSbIc
         HBYR4TvMrJ6nkAj1AXLQEwtG/nPpjGXp2gzyy+gnM6kQRXdaYUqsRoAWFwJw5prnr6Na
         vuc7cShOK088QElsKpsd2m4uvgPw7TQOulIhAhgzLAmbtGKxngIuWtZ2ToYCOYEx1R5Q
         AiIDVZyaJvNVros6UaOaU2mNVA7kJkAtkafG15NoOtMqkubFzK/X1c2fwqtoYdr+Jj3q
         ZEkdQcPK0CO1fdWX437dYyZVFt6tyKStR2TfuDGBv8PMNY5/Llm+FHs2uq8EP8mFamg+
         BqSg==
X-Gm-Message-State: AOAM530LnyRAT43H53GWaR5vMlx4vTUshuN2TdBblQVn6GtM4p0cQHqR
        HqlesTxI98i+BadfJVJv5pjcsN7QjaNIYM2ww5UwSBFLxwTLuyQi87FVtNJPgD2abYaGSr8skhf
        dVEKj/Rf9N4yu4kSq
X-Received: by 2002:a37:aa15:: with SMTP id t21mr8790911qke.86.1610659764060;
        Thu, 14 Jan 2021 13:29:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy660NxlfmFC7YykhHaL7gpHQa4Mlrrf+1B0hrXr457WolnKxaoCBz0Ox7FHABSYo6DgKEeIw==
X-Received: by 2002:a37:aa15:: with SMTP id t21mr8790902qke.86.1610659763883;
        Thu, 14 Jan 2021 13:29:23 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id t184sm3722613qkd.100.2021.01.14.13.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 13:29:23 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        liuhangbin@gmail.com, viro@zeniv.linux.org.uk, jdike@akamai.com,
        mrv@mojatatu.com, lirongqing@baidu.com, roopa@cumulusnetworks.com,
        weichen.chen@linux.alibaba.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] neighbor: remove definition of DEBUG
Date:   Thu, 14 Jan 2021 13:29:17 -0800
Message-Id: <20210114212917.48174-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Defining DEBUG should only be done in development.
So remove DEBUG.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/core/neighbour.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 277ed854aef1..ff073581b5b1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -41,7 +41,6 @@
 
 #include <trace/events/neigh.h>
 
-#define DEBUG
 #define NEIGH_DEBUG 1
 #define neigh_dbg(level, fmt, ...)		\
 do {						\
-- 
2.27.0

