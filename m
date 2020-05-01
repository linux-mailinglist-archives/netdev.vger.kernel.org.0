Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF2E1C0FF0
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgEAIrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEAIrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0445FC035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id hi11so2078243pjb.3
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A72zlJXZh8GNMGbJxHIhbtjJ7aH6fTROfmnkv/7KOXg=;
        b=O4tUIYab+WSCp/sZaYrHBK3VGXJSrDFetp02o8DkPZmgU1K4vmPivPHZotxQ43xGZT
         msulSDUZSA5CKk2ErCxzV/TSjLIICYS6RafvpNLQ3zO7SDfeeeLe8lTcQuIReGvmF7ks
         bGSAPO9UsMaddx0v0KPKQBYqqGs5XLOOkScA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A72zlJXZh8GNMGbJxHIhbtjJ7aH6fTROfmnkv/7KOXg=;
        b=OXHt8/PpRq4CopTlWVk7R0EwoCImvEVqZ/Xl+n+1Orou6wwjujXRPPzPSWJnwBLbuM
         pevKQorjvv5AjMSX5PMCkCBl5V5wJz/PrW4SxFd1e+x4xjQNM4kT5gdGBNYcbksEGUkF
         Aw5/JSeIAwmpYnlnQ/FA9B74R/zAxZaAGOfqga/L2FnkE9nZP9ZWVk6qCDiXiFaI83lO
         scjdLivZjzmhZMM3OZJVj7a2fFIs6Q5AcFVahSGmd9U+M73vdcG4IjRUeorWANxvWQJC
         9ULwyKKdvZXrCymUeR1nm23pEATcYoWHhZzZ9gtIR52Xpw4npflhG9PHlXBu4lb6CQxk
         cTow==
X-Gm-Message-State: AGi0PubhuqeC5hqxSnLFQjfBmxBh03dNtomcA10fjC6bzdYniGW0deZg
        AkSh5PKbX2Z0cAoGc+VwhEujmGmrPzA=
X-Google-Smtp-Source: APiQypJ5P2VHeGH1bJAXjUCYxkUacmT0WYr2ltDNYh2tpFQgqll7iPA9TyEMiek8N5R+JtEKbFYByA==
X-Received: by 2002:a17:90a:210b:: with SMTP id a11mr3550745pje.31.1588322854267;
        Fri, 01 May 2020 01:47:34 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:33 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 2/6] bridge: Fix typo
Date:   Fri,  1 May 2020 17:47:16 +0900
Message-Id: <20200501084720.138421-3-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 7abf5de677e3 ("bridge: vlan: add support to display per-vlan statistics")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index ac0796f6..37ff2973 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -546,7 +546,7 @@ static int vlan_show(int argc, char **argv, int subject)
 
 		ret = rtnl_dump_filter(&rth, print_vlan, &subject);
 		if (ret < 0) {
-			fprintf(stderr, "Dump ternminated\n");
+			fprintf(stderr, "Dump terminated\n");
 			exit(1);
 		}
 	} else {
-- 
2.26.0

