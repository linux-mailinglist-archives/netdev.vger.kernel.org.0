Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E066A4A6982
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243617AbiBBBNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiBBBNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1329BC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:10 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so4408985pjb.5
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jZQROXOP0pza6cD/HAg54T+BPrYK4YdGCqA3Sg45Jw8=;
        b=RDBf+s6K0tMlVJLHBBbFtWPd3Ign7mH8rambp7zJDwcbXOD6rGamKQFFtuHcbxhm2n
         pW9NXo6PLUOF/pDg1hkZW3mu4bx0pgE2Pqhf8CAVs4cuthu1ATOxxyL0UYORwEwQ1yX9
         gbr61c6OOy+OpmLXLeC+1rdr5Fuk7RYzpXGDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jZQROXOP0pza6cD/HAg54T+BPrYK4YdGCqA3Sg45Jw8=;
        b=cLl9Bui+kma9pJopBzcU9+kaTQI5aeUg8vchGovR7YY0hH2A7Rswdr2v2+0wn2Tm5z
         H+dQITweCU4BXznMZ96O6dxguLsBoynUIuNw+aMzljcnPkuRCFxNJ4qDM2bQIJE+QC8U
         JAc7/P23ziTCm69TSfcGYdC3/xdBh6tnOY56W0spGpvDUnePUf9BEMn+9N2XN4TPe76r
         TYfD3CT3m7Ut3EfveJnF9vPGlgVMruh+qVII5Nsdv0ihEXw1+2vJuq9RHoaLnBiDcRZQ
         6abtkStEpKb5qYhJ0n0s6EW9hPHLXZxTVJN5S6XHeICJuaY4ZwSYr1uLMLaKf35OvYEt
         WcTA==
X-Gm-Message-State: AOAM53325Z1bz84HdvawnxH5HFAdhiOrsd2RNZYjZYQuj/Rlf9t1m4Fd
        t2D9Ty9gylhl+C4MGH4mpvgAluwBVTpMLQrUV2Bu0Yfp2oKC9M8HwVlz7wSRipyCRJXOmADfv74
        3FPghwxim2uOtMltLXmJsG7bSADSOec7J6J00KlvqBRgjMthLdm0sGYK0LjEzdxAkW/Xd
X-Google-Smtp-Source: ABdhPJzKA0dPqkMZSKJbqrEcG9Jg5+e5DtqDgH/RgjjZ650Q5zL///I99kL3PLV1bX2WMAEzticJFw==
X-Received: by 2002:a17:902:8204:: with SMTP id x4mr28797680pln.18.1643764389130;
        Tue, 01 Feb 2022 17:13:09 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:08 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 01/10] page_pool: kconfig: Add flag for page pool stats
Date:   Tue,  1 Feb 2022 17:12:07 -0800
Message-Id: <1643764336-63864-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Control enabling / disabling page_pool_stats with a kernel config option.
Option is defaulted to N.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/Kconfig | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0..604b3eb 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -434,6 +434,18 @@ config NET_DEVLINK
 config PAGE_POOL
 	bool
 
+config PAGE_POOL_STATS
+	default n
+	bool "Page pool stats"
+	depends on PAGE_POOL
+	help
+	  Enable page pool statistics to track allocations. Stats are exported
+	  to the file /proc/net/page_pool_stat. Users can examine these
+	  stats to better understand how their drivers and the kernel's
+	  page allocator, and the page pool interact with each other.
+
+	  If unsure, say N.
+
 config FAILOVER
 	tristate "Generic failover module"
 	help
-- 
2.7.4

