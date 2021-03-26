Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1946334B293
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCZXQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhCZXQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:19 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3A3C0613AA;
        Fri, 26 Mar 2021 16:16:18 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 7so6967560qka.7;
        Fri, 26 Mar 2021 16:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IiQ4bh1rkaAouzyfz3uw3onrQANu0iOL55nVNupQhFk=;
        b=eMLnUSmYV+1pMNDRaOvPxFOf64kcnv3QhDQujQGbn/uB3LA3IhZOmAxrhLtFbXMqgt
         8rJC3Dxd45l2lomutOnoxf/5mz3DB6CzEIrZoG9i9wLEfmHBfHfWL7c9DhxrTO4LBNig
         LWvr9mGOXBH6fXIdQqjW6ZhvbjIOiCpwDOUOuOxDiO68/r7/A4i+KwKKfo1MFfCr3Tvr
         utjR/vQG3T0kiX/3cfEhGKJViyfkfd/v0Cyvvv9r1tB2KoBtkGthCt24tGawwnxg27W0
         /sckKgz0f2Y+DuHSh68uuznmYv/FUjOR6QAzJ6ybalnr+l2G60ZnoLsshU3hzKMQxI1X
         r/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IiQ4bh1rkaAouzyfz3uw3onrQANu0iOL55nVNupQhFk=;
        b=B7CfBGFxKtbIeiqE1qVcSYfVrheOgg9jeilEnv5fLfLEIi8ZbJZnAsU+GWGxl3iQGv
         nxyjVlWciH6LP6LzOVRVc/fIcCwx76u22lfN1hON1Tfq8IyyqD7Aj0dfyqVdZCoC6XEz
         7b+jn2w3hOVu853l1vD/M2KG5vt9bVwNmOXMIGUXUpS5eQv8gGCTezSQ3zAeWpRSLnh2
         YiP89u5It9FN+O95yS8B3/qCryt7diEK66kLX7zFBwpvb3T/trMAlvP+y67G1ORqMmv+
         Nm+slVz+48J2U+or+JDGba5pbIuawrv4fRpJGtd1JwERRnlXSWJCJCwRFnfuWdcuJ1GX
         P/4w==
X-Gm-Message-State: AOAM531+9QXgI7IV4Tbm7YcVvpA8nTQL3iiyAQ2G59yPcLMDwNkAa/KZ
        5TPddeYg/erMRmKH/BT+BwM=
X-Google-Smtp-Source: ABdhPJyutmfKxmzk3/OyR5b9/8ab4ml49JS/CH3IevrYoEcD+dpD0mG5nCEFreQgm6ONV9fZ21Bpqw==
X-Received: by 2002:a05:620a:12ae:: with SMTP id x14mr15680634qki.25.1616800578208;
        Fri, 26 Mar 2021 16:16:18 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:17 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH] bearer.h: Spellos fixed
Date:   Sat, 27 Mar 2021 04:42:37 +0530
Message-Id: <20210326231608.24407-2-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/initalized/initialized/ ...three different places

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

