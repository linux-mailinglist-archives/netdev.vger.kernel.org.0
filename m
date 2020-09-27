Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10C827A0B9
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 14:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgI0MHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 08:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgI0MHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 08:07:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B497BC0613CE;
        Sun, 27 Sep 2020 05:07:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l15so2520922wmh.1;
        Sun, 27 Sep 2020 05:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDmKV7013veZvVuahc4G29gqLknkysXOsrMcq3LEcO4=;
        b=DaiRw7sfVvtpjqCofuLmOcd9mW/ja1GwGWcdVoDNY00SrxCueRKCYGUVoG5XzuK7TR
         ObwPrtO4RnyJwfxkUFzYfIqR6VUmJ/Fpkm447FMcy/fKbH30qNEOjSLy4C3Bjv2DaJcc
         QvBG+UKMxcNBq05mCQTCCdAmvdR2qBiPy887yXzK04TTY8uX5sa9RpQS3C6F/UTL89PU
         LAx9juT8QgxVmuSpPGbrGl9KWateH5ggZEfhf8hSLoPmZ7BFVEKiFZlqD5ziK5peKMnI
         1TILycdReqV+a/JxZDCP3f6Ps2wmaH4AJcfqyEdECjXvrKtXfrqQHu0L/iIWIM4M3JCf
         Adtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nDmKV7013veZvVuahc4G29gqLknkysXOsrMcq3LEcO4=;
        b=r6lnCNqpCOrBfLOLXHviLwNtM2DavwQsi9ZPALD0FgXVKdEzpfgRFl/W+3hd7CwyQp
         bbijeUGDMm0gYdMj//MqQ/ZoxZ/fqVAuLNHZuMPC8quTPrBiw6pRLZKDTMkurACY/Vuq
         OgpScoi+Bp+MEJz8WW82tGI5IVc06Ml6r1IUom4JEXD/Pdpw+dLrvwAZDy4ay9wNNMgL
         GSnz5HBrv4RhPMdL316pvpKfO/ISy3kxLh7vpPCe0SNfdeeXs5rATGNx39wWAj+kSE0v
         czRza4ViCpIOyDgbim1alH3YCEf3ybDh7cXiq0XU52ugO0LORqGpf60hIK3dkSs3zqrI
         3LtA==
X-Gm-Message-State: AOAM532+LMctp2liZhNWm5EkUpgnrV+qvEa0AKIcQIAFVmeyjw7VEkxH
        2OGbp4CuiaVADAwjLXzapK4+eGrmHMI=
X-Google-Smtp-Source: ABdhPJx+0c+7xc9iH6P5KTzPn7Prp4NdWYRXn7bPUs0+KBTopBABS5EW9y6fFoUEjWye3VIMO5xDdw==
X-Received: by 2002:a1c:2cc4:: with SMTP id s187mr6647108wms.36.1601208431360;
        Sun, 27 Sep 2020 05:07:11 -0700 (PDT)
Received: from kheib-workstation.redhat.com ([2a00:a040:19b:e02f:5cc2:9fa6:fc6d:771d])
        by smtp.gmail.com with ESMTPSA id m10sm5263279wmi.9.2020.09.27.05.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 05:07:10 -0700 (PDT)
From:   Kamal Heib <kamalheib1@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Kamal Heib <kamalheib1@gmail.com>
Subject: [PATCH iproute2-next] ip: iplink_ipoib.c: Remove extra spaces
Date:   Sun, 27 Sep 2020 15:06:56 +0300
Message-Id: <20200927120656.21488-1-kamalheib1@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the extra space between the reported ipoib attrs - use only one
space instead of two.

Fixes: de0389935f8c ("iplink: Added support for the kernel IPoIB RTNL ops")
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
---
 ip/iplink_ipoib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/iplink_ipoib.c b/ip/iplink_ipoib.c
index 05dba3503373..b730c5335020 100644
--- a/ip/iplink_ipoib.c
+++ b/ip/iplink_ipoib.c
@@ -99,7 +99,7 @@ static void ipoib_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		snprintf(b1, sizeof(b1), "%#.4x", pkey);
 		print_string(PRINT_JSON, "key", NULL, b1);
 	} else {
-		fprintf(f, "pkey  %#.4x ", pkey);
+		fprintf(f, "pkey %#.4x ", pkey);
 	}
 
 	if (!tb[IFLA_IPOIB_MODE] ||
@@ -112,7 +112,7 @@ static void ipoib_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		mode == IPOIB_MODE_DATAGRAM ? "datagram" :
 		mode == IPOIB_MODE_CONNECTED ? "connected" : "unknown";
 
-	print_string(PRINT_ANY, "mode", "mode  %s ", mode_str);
+	print_string(PRINT_ANY, "mode", "mode %s ", mode_str);
 
 	if (!tb[IFLA_IPOIB_UMCAST] ||
 	    RTA_PAYLOAD(tb[IFLA_IPOIB_UMCAST]) < sizeof(__u16))
@@ -126,7 +126,7 @@ static void ipoib_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		snprintf(b1, sizeof(b1), "%.4x", umcast);
 		print_string(PRINT_JSON, "umcast", NULL, b1);
 	} else {
-		fprintf(f, "umcast  %.4x ", umcast);
+		fprintf(f, "umcast %.4x ", umcast);
 	}
 }
 
-- 
2.26.2

