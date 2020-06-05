Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBDD1EFADC
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 16:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgFEOVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 10:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgFEOVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 10:21:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A1DC08C5C3
        for <netdev@vger.kernel.org>; Fri,  5 Jun 2020 07:21:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 64so4964893pfg.8
        for <netdev@vger.kernel.org>; Fri, 05 Jun 2020 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=yGP/Kfk+N8F8iZAeQuKesLiAArFiMOYLOk6KSc6Id+U=;
        b=mM0dkv5fgPUEDI5+Ig/8tYdMEQmoq5Dzw8QTDcSds5R0+fQNHXb4dUYu1nC+79LLo5
         AASqF7MxiF78fW0sLSHZTi7h9+wBVO8sWFHgviQ/Eb398TEPl1k94wIUW4Oxz2pozRcS
         qXcKXSCrV1kTgEZCQM4OOzAsC2tk6MzytRuZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=yGP/Kfk+N8F8iZAeQuKesLiAArFiMOYLOk6KSc6Id+U=;
        b=h6aThlID7x1zuWaAD0P7G5N7nJWyEE4m8+xCXxL9iK31Rv/gDnH9hPa83aAWBV7Civ
         qtPjSHy0PfPTsXBY2EixlSZ/28CW+osNNJTXZX8tl+2f6y1kwjHcUEenGDko38nMsBOP
         iRwB1E9pttGhOKPJudkIjSOe5srOw1G4LAqh+yUBw0mPO8zXuoKALbb9YYqRucq7k+e1
         0yeb4XJgJ+1oaL3glJkqCSwGDsuUIyJ9kGF2yl93BbfmxCjYMz+U7pUFbg08jEirVw4K
         hJC/oVKw98jcVKXggxu1jurnBuvbRrb9wccomL7YtkEoq8qjRt2LtyScIUNGy1ba3ZrT
         gHZA==
X-Gm-Message-State: AOAM533r/In+t86E3ztWAgsirPlBQbOToTlHY5GlpQP1iLVMCwuD6YO0
        TuvWvbeEH6FC0HprNhI+Qvao6oOik9/9Nw==
X-Google-Smtp-Source: ABdhPJwKFbHKpewYCO4uc2+sCQtwLv9h6tPVlXqTY10U5LySFMOcXvTJZbnlv1WBth8q9WueJjPOZw==
X-Received: by 2002:a63:3347:: with SMTP id z68mr10089302pgz.61.1591366883923;
        Fri, 05 Jun 2020 07:21:23 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x191sm7750890pfd.37.2020.06.05.07.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 07:21:23 -0700 (PDT)
Date:   Fri, 5 Jun 2020 07:21:22 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethtool: Fix comment mentioning typo in IS_ENABLED()
Message-ID: <202006050720.D741B4C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This has no code changes, but it's a typo noticed in other clean-ups,
so we might as well fix it. IS_ENABLED() takes full names, and should
have the "CONFIG_" prefix.

Reported-by: Joe Perches <joe@perches.com>
Link: https://lore.kernel.org/lkml/b08611018fdb6d88757c6008a5c02fa0e07b32fb.camel@perches.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/ethtool_netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 8fbe4f97ffad..1e7bf78cb382 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -67,5 +67,5 @@ static inline int ethnl_cable_test_step(struct phy_device *phydev, u32 first,
 {
 	return -EOPNOTSUPP;
 }
-#endif /* IS_ENABLED(ETHTOOL_NETLINK) */
+#endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
-- 
2.25.1


-- 
Kees Cook
