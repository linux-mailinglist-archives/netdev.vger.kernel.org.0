Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DEE3FA961
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 07:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhH2Fhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 01:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhH2Fhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 01:37:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A80C061756;
        Sat, 28 Aug 2021 22:37:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so11656914pjb.0;
        Sat, 28 Aug 2021 22:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GigqQr4jZpg3pAe2RkzgaB2tw0Rbe327aEgOEyUQSVY=;
        b=tLNSisQ2Jiq2EL833cIUewmZ4de6YK51SLEz0zcgz5IRCdmFaCSKpXFkyciuGZ6E9x
         FuVYJ0wTN90qxXW20aGqxgnY0JE254CKeqaJY+9RbULwkPVMtnnOzBU3YGiyJgc/8Hed
         n80PwPOG7JUnjlSA/1IrI8uyw/FAI1fZLCS4limgypRE0sKo4KMvOgeSVzgOT5NVUQXV
         cPfzsZXG3LVFCUfUUZi2eL6MRXyZMLDyDkkfkmzNKHBoYgZY4xwLJpmuVnr3yvFBmza4
         QfgWMG3jULOpLPEj/+tI22873WMIvHoqi/G3lQUvPMzzxdGXXD2aiqz3HSaFHkmHJKFB
         d7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GigqQr4jZpg3pAe2RkzgaB2tw0Rbe327aEgOEyUQSVY=;
        b=O1rI56mwAUcy1qTXf9k7+10PBJCV0rAr9JskFt2BZ4YZhK+7c2A5oyjKT7+l6fbXf5
         LEY64SiCA7ffVsatHCHW0hHYwOww3fa/TXhcPC6ZuIusIIYBJ6HtsnM9Ot6Sq0zTY7RP
         a9MZTSCNnENQNmXm4MEhC+KHh/1JD+2ZNoGH4THJ/MD/K7Bm78DbWkPbpFmTi3Fihlve
         plxNLI+xtVMND2F5x+1JKLdCAG0rTl87CrF6olHaHLkHnVDuB+Vpl5q6rzUPdQueowcO
         D60bDCp1X2iIeRgoiB33dE7+8cA8OyFPH7mtErkUzCQKKDVfaWptJpJULldbB2O4fG4+
         cadw==
X-Gm-Message-State: AOAM530qB/yTMePgI3oKyrICRJk3JGjoabt82F8MrGfXAjN1MWyB+F7b
        K9726ymPU3pfuqmm8emrQuU=
X-Google-Smtp-Source: ABdhPJwIZQ+Uz9V6ByG8VZSXVtIBZ7i8VBr0WYrGDxdsq1kDrSUWcCazfHjN0Vmmn8z9rm4epief3A==
X-Received: by 2002:a17:90a:680c:: with SMTP id p12mr20110337pjj.33.1630215421132;
        Sat, 28 Aug 2021 22:37:01 -0700 (PDT)
Received: from localhost.localdomain ([222.238.85.219])
        by smtp.gmail.com with ESMTPSA id s16sm10517252pfu.108.2021.08.28.22.36.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 22:37:00 -0700 (PDT)
From:   jiwonaid0@gmail.com
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jiwon Kim <jiwonaid0@gmail.com>
Subject: [PATCH] ipv6: add spaces for accept_ra_min_hop_limit
Date:   Sun, 29 Aug 2021 14:35:44 +0900
Message-Id: <20210829053544.51149-1-jiwonaid0@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiwon Kim <jiwonaid0@gmail.com>

The checkpatch reported
ERROR: spaces required around that '=' (ctx:VxW)
from the net/ipv6/addrconf.c.

So, spaces are added for accept_ra_min_hop_limit.

Signed-off-by: Jiwon Kim <jiwonaid0@gmail.com>
---
 net/ipv6/addrconf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 17756f3ed33b..ce71480a92d9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -208,7 +208,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.accept_ra_defrtr	= 1,
 	.ra_defrtr_metric	= IP6_RT_PRIO_USER,
 	.accept_ra_from_local	= 0,
-	.accept_ra_min_hop_limit= 1,
+	.accept_ra_min_hop_limit = 1,
 	.accept_ra_pinfo	= 1,
 #ifdef CONFIG_IPV6_ROUTER_PREF
 	.accept_ra_rtr_pref	= 1,
@@ -267,7 +267,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.accept_ra_defrtr	= 1,
 	.ra_defrtr_metric	= IP6_RT_PRIO_USER,
 	.accept_ra_from_local	= 0,
-	.accept_ra_min_hop_limit= 1,
+	.accept_ra_min_hop_limit = 1,
 	.accept_ra_pinfo	= 1,
 #ifdef CONFIG_IPV6_ROUTER_PREF
 	.accept_ra_rtr_pref	= 1,
--
2.25.1

