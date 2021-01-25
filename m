Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF69304B34
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAZEtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbhAYJUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:20:14 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC13C06178C
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:20:48 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g24so14081338edw.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FJyorqRdVcMr4H3CHmU331uPAEpW16yWV7e4SmBCjxw=;
        b=FEeWeXk+x+8IjDWcPJr1Q5JuO4PaLPPmgsa3YH/b3YPsEVHUpVbQRIiUlcdnCn98Cd
         1dMWXg8aE9ISYRMUzLfSh/a4/AQj3mAVwsSI2lED+yhujAQYei5N9eGu9J/jzBEwFMKc
         mYHg98230wURiRZojHyAaq4d6kNDpNbLRHyJmA+wSIzdORsIdcFSTwzo3eygZxs9bh7c
         Y0S9jucq/4jSnzl8LHznW+KWYZ6jnRCJ90gkdl9eDNSpFQMoPhyZ6ztuSmpBHHaR35wd
         tDPMsE3kqdmM25AP9m7gMn+7zqDGso8K19c6gbgxfQggvbd2VpGr6eHMAVq6GmQwoLXF
         Vl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FJyorqRdVcMr4H3CHmU331uPAEpW16yWV7e4SmBCjxw=;
        b=EIjbYcc0zDGdP3SalLlepm99HnzEBNj0we5G3ykvtBwD/M726XjfXmDPyS+bCC8Ztw
         nFUSV14qEgDYKh9yRH+3+swwCANfDgMLwuTeovFGjhehiA5LLIaXJwGO+v7Mw1yAReDZ
         fdJPMFXR+iApUAmemG5scqxCPQq8TRboxeZlSkglUajc+yaqSVHRhCHQcn+f/ZWZ7OAI
         FmAgO61A9RcnBNd3xKlzvjwBkIsJ2xOWgamrdaPA8gwhAAWU38im9IcosAexHghGAi9t
         1/Vki7GvhKFrqIJVKLH3Gkz2cpm0r7Grm1yJ+ArqgSXmSUdGJchHhojnvPPaJCG7yBvE
         SAFw==
X-Gm-Message-State: AOAM533dgf9mg6d6kmjSjmBTsEKIBLedFS3yAJ/9dy5g/tyUq9bAx7YT
        DUNj23panhI2GrBt9wKBspccCkhEf3+1IzBHHug=
X-Google-Smtp-Source: ABdhPJzJAacPAzWn1OwiClAz2ma95/PiCafeM04okbUjJlP1GUuLKHi5ATpXLFygT2Uk1LYQ9rYv4w==
X-Received: by 2002:a05:6402:22ba:: with SMTP id cx26mr157852edb.350.1611562847071;
        Mon, 25 Jan 2021 00:20:47 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d16sm2285802ejp.36.2021.01.25.00.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 00:20:46 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: bridge: multicast: fix br_multicast_eht_set_entry_lookup indentation
Date:   Mon, 25 Jan 2021 10:20:40 +0200
Message-Id: <20210125082040.13022-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <202101250327.48TBMqng-lkp@intel.com>
References: <202101250327.48TBMqng-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Fix the messed up indentation in br_multicast_eht_set_entry_lookup().

Fixes: baa74d39ca39 ("net: bridge: multicast: add EHT source set handling functions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast_eht.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index a4fa1760bc8a..ff9b3ba37cab 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -85,15 +85,15 @@ br_multicast_eht_set_entry_lookup(struct net_bridge_group_eht_set *eht_set,
 		struct net_bridge_group_eht_set_entry *this;
 		int result;
 
-	this = rb_entry(node, struct net_bridge_group_eht_set_entry,
-			rb_node);
-	result = memcmp(h_addr, &this->h_addr, sizeof(*h_addr));
-	if (result < 0)
-		node = node->rb_left;
-	else if (result > 0)
-		node = node->rb_right;
-	else
-		return this;
+		this = rb_entry(node, struct net_bridge_group_eht_set_entry,
+				rb_node);
+		result = memcmp(h_addr, &this->h_addr, sizeof(*h_addr));
+		if (result < 0)
+			node = node->rb_left;
+		else if (result > 0)
+			node = node->rb_right;
+		else
+			return this;
 	}
 
 	return NULL;
-- 
2.29.2

