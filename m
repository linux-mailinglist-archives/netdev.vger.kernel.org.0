Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9401BB227
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgD0XvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgD0XvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:51:00 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8140DC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f7so9779391pfa.9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=IoGenYLfCZ3pWi6rFFSwwtnAryzI7YDsgGy0c5Iae2A=;
        b=dyQl4RPmlYRNkCND5+Q1MIeSGpzU51yMUTmQEcMUkZfbnIbFUnqIP2vAJunU9zbO/y
         8XKRMT/CwlC8hXNEss0asOtzefk8zr3l2avUZfjGG0iLwPAXiKuSekLuww/My9jLacwN
         +Ft1RyvFKp5TE4n96P1aWqnD/t29JclpO0/80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IoGenYLfCZ3pWi6rFFSwwtnAryzI7YDsgGy0c5Iae2A=;
        b=PwHorDU46uHI+2iJA/+da4w9n9O8Ifm+6PmdR44cMBxGbneujThFpGTTaXElQqXRQx
         6pxbClWRbkCDLQBou0aM3JSM/CKhNnw2ZCofqWowAkfFYyT74KOISzu0UMIldwwJMMfv
         4nYEsdSCLegRBOGptj22k/6v7M6JhMNqdHbjUJ2Y3PFrBUGv9PGaHYB8CN9+15xczh+s
         MZqeqkmH4Dckcae8Gy2cul4k0jFSaLBDbgaZSuaMn3zEeyisR1Y7wUcZJ7nWdI9pf6R0
         q2gpaMsu4NL7iTrDSIBAOW4YbnLkSkym58S7EToYurKr9zQdU87PfnmAhgGLX9bnzUZ+
         wMjw==
X-Gm-Message-State: AGi0PubIKjTUFWMFxyNXZvb9LP3IN3Av3xJ2Z4rqXOp/83m1fA3A832k
        27kWzvEtzucb+UHIgRg2HEIATAnvyCs=
X-Google-Smtp-Source: APiQypL/f3zPnC5p48ir0HtMltJD6ogiNf31Oekklw44CZ7COESaGoVUYvLTKbvLQGYqpNA4n8bpug==
X-Received: by 2002:a62:144c:: with SMTP id 73mr27595763pfu.37.1588031459781;
        Mon, 27 Apr 2020 16:50:59 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 128sm13058106pfy.5.2020.04.27.16.50.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:50:59 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 1/7] bridge: Use the same flag names in input and output
Date:   Tue, 28 Apr 2020 08:50:45 +0900
Message-Id: <20200427235051.250058-2-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Output the same names for vlan flags as the ones accepted in command input.

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 205851e4..08b19897 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -398,10 +398,10 @@ static void print_vlan_flags(__u16 flags)
 
 	open_json_array(PRINT_JSON, "flags");
 	if (flags & BRIDGE_VLAN_INFO_PVID)
-		print_string(PRINT_ANY, NULL, " %s", "PVID");
+		print_string(PRINT_ANY, NULL, " %s", "pvid");
 
 	if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
-		print_string(PRINT_ANY, NULL, " %s", "Egress Untagged");
+		print_string(PRINT_ANY, NULL, " %s", "untagged");
 	close_json_array(PRINT_JSON, NULL);
 }
 
-- 
2.26.0

