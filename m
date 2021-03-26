Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202FD34B2BB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhCZXSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhCZXRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:17:37 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CABC0613AA;
        Fri, 26 Mar 2021 16:17:36 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id j17so3766340qvo.13;
        Fri, 26 Mar 2021 16:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=952+y4uMf0/pVptF5Wduqg9Re4XUWCLAGYqO1h4oDAo=;
        b=Vs1JqIZ1w/0AAZ7X4cAx5+9NqtkED0lfSUTub7NiINrBhBo8CrcRBR8Woj0r712fU+
         RI0OtUd9gi7biJH2xjaQjv6Q4bpushGpRpCPif5bMCiGaexpInMopodkSlsv/zqzaDsa
         wrVE6Kzi2tuGOZxoXW7q12CEqSIH9G1+3wjrA025dXKEiVbzWDvD5A5CvXaBBqD262IE
         FsFvYk/fusy/MmnyYslBbSGa72lRmBFMyty0Ow8HIE4vVX8AkJ+4V7aKJWWqTS7BxS2r
         ikrbakGxwbrt65LGsck2vp20FmYCvb4KbVVdw6Cfo8lHFUCfRjgXYly3TwJl37LcZBXL
         J8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=952+y4uMf0/pVptF5Wduqg9Re4XUWCLAGYqO1h4oDAo=;
        b=ZiFn/t9kadD/E4Uql3bav+alqv2FngSytMeVz27wERud3SDlF3II+eilxibBRFrhwb
         EpsLnstPLyo6UbSf+wRovgxRds7VIk9KGKA86kfh80C1gKTfebgiTTCFYuu4JJdHPOVX
         SrKt3oqtnrBYlkD+lv+zPLMojae2pciWVpTLPHGJgeCYqfGTLeggEaQYbbpBOSDS0iiD
         YytZ5wTj/n7CkXMwc4CU/8zuQgSfHAWMVgyDaI6lfVGDxVpnKB83Z1k0RCgHC/ZJzvFX
         9Awbqj69bmmfr9XgN7+lC7k7mHJ1c9E3qUYSaKbVHD/sSjvJpDSO8TMN3n7CiY7CJT/u
         wM4w==
X-Gm-Message-State: AOAM533Otz3C70bvOkIC+XYm3oq6N3HCsBpZzT9r1nNPozlzcgurebtr
        BYj14lKwqBmz6Q6Eeh4EC6itNAjOJEX3tEKv
X-Google-Smtp-Source: ABdhPJwu8CLkEpIHht8cmIPlMBevNUCjacS+hIpBMq2zKbvYNOSGdKlrXHgM+6wFWC8lvPjQwFBj5A==
X-Received: by 2002:a05:6214:223:: with SMTP id j3mr15395149qvt.9.1616800656341;
        Fri, 26 Mar 2021 16:17:36 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:17:35 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 05/19] node.c: A typo fix
Date:   Sat, 27 Mar 2021 04:42:58 +0530
Message-Id: <5192c69b9fe79421de8f40b6e348191a240e6280.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1616797633.git.unixbhaskar@gmail.com>
References: <cover.1616797633.git.unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/synching/syncing/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 008670d1f43e..713550c16eba 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2009,7 +2009,7 @@ static bool tipc_node_check_state(struct tipc_node *n, struct sk_buff *skb,
 		return true;
 	}

-	/* No synching needed if only one link */
+	/* No syncing needed if only one link */
 	if (!pl || !tipc_link_is_up(pl))
 		return true;

--
2.26.2

