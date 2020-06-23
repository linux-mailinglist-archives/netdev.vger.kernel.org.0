Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD32068AE
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387900AbgFWXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387850AbgFWXxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:53:19 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D6C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:19 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s14so183317plq.6
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dP5k/r9w3jlzmTndtnmcpS5dbCt0BobrXyjxWIQuuWU=;
        b=v3nxufkjqjC/SpkNw49gQTcHHYYdlqv2EmwSdmcdc1O8B77ICdFn7pmGJWFPjWocZv
         Z+eJz1hWCqe5sPCfcJuiDbl8QbHAYzLdqAwU6pKQUkvq4DzigQ/3RoXWZRc2scmBQYcl
         kZFMUndnOhdvDADUt/w7N1z3W+w5rKiY2f//e20xtA0R9Pk7Ha/Dt4zo3AsFdpVx31G3
         EzwvGKQ/22IyeumEj+cK5hTXgNnkUT/Slid7IlESGB7JMkM7gJGtecdd38JlTWuxGb5y
         HzfsojAIE3zXveaBPaSH/HDR4a8mZcG6lYt1/CTanmOGRxBnz2OhYDJjFKNu3XhE0WO/
         0h/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dP5k/r9w3jlzmTndtnmcpS5dbCt0BobrXyjxWIQuuWU=;
        b=esrjq7E4PVLi7IXVKyY6YQHJEqw/xhOL4BVgawLC/JBupxLbD1eng9fRkMNXXap6se
         6IR5M8YbOssf3T4N3A2q5yYg3VkUxLInHDfE4JjpNDuhRKUOEZ/s56pOtmzzmeDBtzEJ
         vIsIS3bZp9LieCtPnr2sMiJJcMmNsj2tmDXpuf+6AJnFS7rDz/sip01XWcYTWGUGGJa3
         gJQZnUU1S3u73TOqgE2wN67YzqWDXV0p8MhH5NmatFhN+STgB3dx78Ijp40lLpE3wdc8
         PwVUHUkg2abl9rXHkPdMiLEYjs9fV8PyPECz9rdSPMWiCjSO2FMDrg3Ns/EteIGoJlr9
         4V8g==
X-Gm-Message-State: AOAM531jtVUlKl2iYlrrjPZC258bfdEuGL9ZU5EyO0xVLo9JD0sTbMCc
        4oMV7564IUnL/9pGp+MyA/px14rdhX8=
X-Google-Smtp-Source: ABdhPJwFOrWDETEQMzXYQrFBStogZxyIhow/mL+UMJNZfTeEXawESq+xsj4ae2WgvAR8GtXKdMdgcw==
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr26457335pjq.228.1592956398453;
        Tue, 23 Jun 2020 16:53:18 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 23sm18096521pfy.199.2020.06.23.16.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:53:17 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/5] bridge: remove slave from comments and message
Date:   Tue, 23 Jun 2020 16:53:04 -0700
Message-Id: <20200623235307.9216-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No need for slave in comment and message.
Can't change API (yet) since part of Linux uapi.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 bridge/vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 0d142bc9055d..9128769eaf3d 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -469,7 +469,7 @@ static void print_vlan_stats_attr(struct rtattr *attr, int ifindex)
 		if (filter_vlan && filter_vlan != vstats->vid)
 			continue;
 
-		/* skip pure port entries, they'll be dumped via the slave stats call */
+		/* skip pure port entries, they'll be dumped via the port stats call */
 		if ((vstats->flags & BRIDGE_VLAN_INFO_MASTER) &&
 		    !(vstats->flags & BRIDGE_VLAN_INFO_BRENTRY))
 			continue;
@@ -592,7 +592,7 @@ static int vlan_show(int argc, char **argv, int subject)
 
 		filt_mask = IFLA_STATS_FILTER_BIT(IFLA_STATS_LINK_XSTATS_SLAVE);
 		if (rtnl_statsdump_req_filter(&rth, AF_UNSPEC, filt_mask) < 0) {
-			perror("Cannot send slave dump request");
+			perror("Cannot send port stats dump request");
 			exit(1);
 		}
 
-- 
2.26.2

