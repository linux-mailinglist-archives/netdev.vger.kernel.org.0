Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE02239A5E6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFCQlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:41:47 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:42941 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFCQlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:41:47 -0400
Received: by mail-lj1-f174.google.com with SMTP id a4so7916130ljq.9;
        Thu, 03 Jun 2021 09:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GtCPxP0lPvrT9tJ+M3sA6gONSBsSe+vnuidKP6YRQa8=;
        b=Li0wZbaVcRzZd0WkoeT/7oYvQPgKHlbfqgRd6v68EbjXePmp8a9T0eBWubriESk7G9
         HLqGT1cxhXWwb8FhnBWh/RjNek3gkgIoEywvEvGZFCMqBExa+kdau4eUNRWMQqAgyWdS
         U10JuXD9R3a71nGx1ZE5yHyFsCKtx0m4exfPSgDT9vqPtRCo9BPeBT+tSZ1rOSJcN0km
         iSC1J7LDi9fqr/FljHfci9hmC6S2PcUfJcBUXhURR4oqme2/Q/4suibG9d9cuBr4HGfy
         SMydqIi+rgwAFM0b6OSZ8QFXGWfUMsuJJcSv6seiTR/nPOfrWDGhfzaIQAbBCIbLwc3k
         B1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GtCPxP0lPvrT9tJ+M3sA6gONSBsSe+vnuidKP6YRQa8=;
        b=NVDLJKYGUY3FCwKuzWm/US8mKA2sk8KAwGCZE0uWh5vk/Je13762LMw1EBbjG6i6lw
         qrPiuDHdAuIHco66eoHHLmTtjhdR7LwUG1XpJSR/tJYs5TjnkkUYc2Y6sThJYCYf6bRk
         MhR/uHm3Xgi2BKGFsNPW8maIGDuIyENXKphGBFN4t9Z3Dxx4Be+rD0ou9OD1oX9/JDW2
         BGEuPywoDCDqY26Hrkg9J+JwOYnAMTFKRGyjHJ4RomJEAVGLMBi0XeYuodUk2GhvPOqX
         4rTr7SqKW61TuV00+aNXmlg+HZwV9hPPeka6jsn6w2VReDa/nPbKSdnaEitCy13X4gcL
         uqQQ==
X-Gm-Message-State: AOAM531HNDfhmcizYtAWJ8ki7qj5nhDVs1WrY3NmGh/ck7qoNz5pAzDQ
        7qC4IFk0+Km6t1F53bAQcH8=
X-Google-Smtp-Source: ABdhPJz3LMpgEbt0Qcqe6W/p6dKpJTGBtnZblxXx5uInT8cHdd0M7UyM4m6Oeb1+xEHpcP0t3t2Whg==
X-Received: by 2002:a2e:6c1a:: with SMTP id h26mr210990ljc.34.1622738325305;
        Thu, 03 Jun 2021 09:38:45 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id v24sm365798lfp.37.2021.06.03.09.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:38:44 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/4] net: caif: added cfserl_release function
Date:   Thu,  3 Jun 2021 19:38:12 +0300
Message-Id: <0a34ac711f54b97d7041f4fe580dc14fb33177fd.1622737854.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622737854.git.paskripkin@gmail.com>
References: <cover.1622737854.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added cfserl_release() function.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 include/net/caif/cfserl.h | 1 +
 net/caif/cfserl.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/caif/cfserl.h b/include/net/caif/cfserl.h
index 14a55e03bb3c..67cce8757175 100644
--- a/include/net/caif/cfserl.h
+++ b/include/net/caif/cfserl.h
@@ -9,4 +9,5 @@
 #include <net/caif/caif_layer.h>
 
 struct cflayer *cfserl_create(int instance, bool use_stx);
+void cfserl_release(struct cflayer *layer);
 #endif
diff --git a/net/caif/cfserl.c b/net/caif/cfserl.c
index e11725a4bb0e..40cd57ad0a0f 100644
--- a/net/caif/cfserl.c
+++ b/net/caif/cfserl.c
@@ -31,6 +31,11 @@ static int cfserl_transmit(struct cflayer *layr, struct cfpkt *pkt);
 static void cfserl_ctrlcmd(struct cflayer *layr, enum caif_ctrlcmd ctrl,
 			   int phyid);
 
+void cfserl_release(struct cflayer *layer)
+{
+	kfree(layer);
+}
+
 struct cflayer *cfserl_create(int instance, bool use_stx)
 {
 	struct cfserl *this = kzalloc(sizeof(struct cfserl), GFP_ATOMIC);
-- 
2.31.1

