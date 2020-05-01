Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00531C0FEE
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgEAIrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEAIrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:33 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ABBC035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:33 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id p25so1327397pfn.11
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wbL2dZSKN5X9HBKtfpy7Cjb9O/4dGiFBhtwslMEuPqU=;
        b=Kj4ZsnIsR61axdtHvJZH3piVeA7RtzYVzAujSGjnWhwa7rZk3LXA5tB7MnHkjpNmEX
         w3IJ0P43s2VOhyFHtXK72BobI4JELvE/I+6h8r9GzbMaOVCg3WOt2CtoxC6f6LNHTGCs
         xyV5RF2iRiOOt1ZJqsP3rjGZ4RuPXxojoBAjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wbL2dZSKN5X9HBKtfpy7Cjb9O/4dGiFBhtwslMEuPqU=;
        b=kMyDjjhvC7j1RgvkYwoLZBusa8yxrjGm5AAtLfDEyPMsVPNNsOFNKVF9jhVcBAFaAq
         7WXnHZgjoO+ffw8HnqQvx9CVas4H1ksZkUckxPnwDX6Vd8OCbak8wNLA5vfCbEdX4+8h
         9c7Vv+SDP/CQvA4zr8VIaal3yMvg+BcJ/DFntKhtv50Q1lBpoF5yzrizA3SlsJvZfLRM
         ZsBhBYx8nZQcxd4RLun3VvbV1HsigHn1Ba4KM2bIGkmT/51RkTWEdVWlsrKFSsnRuJYB
         tfLRVZtHo7l6Vl/qEQb3C4VKJpFZLjBAWkxLfdoqlDS8k/fpR8AiXN9BBopzT2lfQtUT
         FDFA==
X-Gm-Message-State: AGi0PuZeEPBT82twMVSIQ7wU2RxrV8qEgeJEnxpwWPJYX2if4D32bsnW
        X41+KwC0F6kGAHOAD7tb1332QS9BC/I=
X-Google-Smtp-Source: APiQypJp0c2urk25Y/65bdKG88mKnhXIqXDgD89ihKOSz0jiTo/VLnzAR5qY5ei4VNHaLcQyGa0HzQ==
X-Received: by 2002:a63:1961:: with SMTP id 33mr3289472pgz.282.1588322852401;
        Fri, 01 May 2020 01:47:32 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:31 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 1/6] bridge: Use consistent column names in vlan output
Date:   Fri,  1 May 2020 17:47:15 +0900
Message-Id: <20200501084720.138421-2-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix singular vs plural. Add a hyphen to clarify that each of those are
single fields.

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 205851e4..ac0796f6 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -538,9 +538,9 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		if (!is_json_context()) {
-			printf("port\tvlan ids");
+			printf("port\tvlan-id");
 			if (subject == VLAN_SHOW_TUNNELINFO)
-				printf("\ttunnel id");
+				printf("\ttunnel-id");
 			printf("\n");
 		}
 
@@ -559,7 +559,7 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		if (!is_json_context())
-			printf("%-16s vlan id\n", "port");
+			printf("%-16s vlan-id\n", "port");
 
 		if (rtnl_dump_filter(&rth, print_vlan_stats, stdout) < 0) {
 			fprintf(stderr, "Dump terminated\n");
-- 
2.26.0

