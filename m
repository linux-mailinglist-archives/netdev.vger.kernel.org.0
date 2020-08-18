Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F04248EF7
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgHRTpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgHRTpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F4EC061347
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p138so23337896yba.12
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=x+hW0XPWV4Rr1CJkleVrxygZyNZ9WMb0OlI4EjLtoOc=;
        b=Rr+cfb+bz+znyMdX1n+QYWZemDZAN71taZ4H2hUj/xUW5HBxXtazEPY+1zZzO8fy6Y
         i9GiSrIHM0nZNV/fI9Nqt57WTezFiwt9rXjuHuBbFImdTSSLUHRXhoJtzCqesr5oZEoN
         /jHbe7uNJbHZIhI31UePtaUICVOyFza3V+wiMcSYfSc8AKXY43HXoWtbQhcbCicy2E5G
         i85t8CMG0rSRiBKmCVDC/BAbfryKx6nx2CU/W/0TzmKcHwn1TL+ddlP36VGs1+LwxtBZ
         SXtuwVQSH0cueLbXfg92Gczb0MB69al7n1jyRIDECKVIdpwygFPKyVIyHD+TpUhTATOc
         iMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x+hW0XPWV4Rr1CJkleVrxygZyNZ9WMb0OlI4EjLtoOc=;
        b=pogHJKbFTrSykmFhRGrN8s1v2DnGsqKCQkPYtkb13e3tNBr7El3AYEn4evnJ1lvSYR
         ItFn27swYRjXtut3KdhFdIqo5tVlF0q3UoFyQgvza05YUOcHIP8ey4ZmAR0NkOg8sLR7
         IEza7ccKX4GM4Hjc3gCZX2qJjFGrJuVZd5QtH07wQoVRHA4laSV6KBnxj8yEeHz8Ey92
         PvwtFtfaE59+eTFRf1aTQf1DRjwMwqjX1elVSF65RXpzjznLbvXejsOorlkf/sLcfNo8
         9jMcDN3SxPtF7Dx4TsVBySmgKJYNHHNLhE4LFwi6OT+Zt/Rl+L030bVGj1aTlaumEMHa
         HEow==
X-Gm-Message-State: AOAM530kZrCqZ8GCh/SDjJSm52hj8QaKRO1cOWXqE2hQ2QzL1fcQ5uLb
        Cq7tUG2zHi2YlBIBiJKoCkg/z+C1mWNGA+dCDft2+DVduRTBYc53At1sENw1ht4ngmM9zWdxSIi
        de0bGbrvEO2GrK6CkWbTPPQldO/I09RcUpnxeD6ngT3wffNgWhYL19qjToAoS1/H+EtjKRvep
X-Google-Smtp-Source: ABdhPJxHQh1qExXizSJA93JCq4RNBZ5ZzCNeqzRJMrigM1uNmEsXw48r7urT4iSbaLQK0ZadvHpO2CoDcb+DKOOK
X-Received: by 2002:a25:b196:: with SMTP id h22mr30344516ybj.350.1597779916010;
 Tue, 18 Aug 2020 12:45:16 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:17 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-19-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 18/18] gve: Bump version to 1.1.0.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the driver version reported to the device and ethtool.

Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 088e8517bb2b..944a595dbfef 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -20,7 +20,7 @@
 #define GVE_DEFAULT_RX_COPYBREAK	(256)
 
 #define DEFAULT_MSG_LEVEL	(NETIF_MSG_DRV | NETIF_MSG_LINK)
-#define GVE_VERSION		"1.0.0"
+#define GVE_VERSION		"1.1.0"
 #define GVE_VERSION_PREFIX	"GVE-"
 
 const char gve_version_str[] = GVE_VERSION;
-- 
2.28.0.220.ged08abb693-goog

