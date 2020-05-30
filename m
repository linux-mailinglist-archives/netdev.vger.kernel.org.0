Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6958E1E9090
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 12:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgE3KaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 06:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgE3KaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 06:30:14 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C36C08C5CA
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:30:12 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id k11so4545515ejr.9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OkxntOjI2AHgdksGQnGC/WbJKAzbru0TQ5zLerpJ9jk=;
        b=iDFM97XsQcXYLp1op6yDgEjD0IBrn+ixcqQl7FxD2uQooO1hfv63OzG9b6u1FhH5Fb
         9ugKCA7WIDnnwk84RtJNV4Lz/040vP7UG7g9c/NAJEeY5bdmJDAcz2wpz2BChRdCZyh1
         DMK8g2ZoID9f4ISHUAueQFh36dJjczeIZMWd6+yeU75gyHTGPHrMhCSSeG9kXLyPv1CC
         xvt8qNJsFcPvK7zA25vnPwyYH4stw1bakRhetjVOGJq0fHymLdQb5tkbcYkSnHiGZQIl
         /gkHotcdcoOLUE7S0PlcvoPE+7aJSBb02+Tl6DhXX6x9i1Ic1Bsk4bMDEYGSKFoGBMgR
         8vgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OkxntOjI2AHgdksGQnGC/WbJKAzbru0TQ5zLerpJ9jk=;
        b=aLfHl7xmy/9w/F403r56c5CiXqWBHs48ZBrZZKFRtmvETXT8sT47zcR/0J+XZMBqNU
         t5vIKYeKRyxpSBcIARO2C6ANdmazZKHh/5sugAeMKf+w48P+QKdaLym9FCPK1Cg+19rS
         LP/y5Gsi4mfV397oTlr3baQKX2nn57yelE9jCDsMIr6CHhNKVRaPFFeHkxcUOEpjydqV
         l4lsLps7C7uLB8SvvCmyBWJVRv9PZLPz/1Kbj2XEPhyI1OwETKI+2ATnpEzai85gVfhH
         hqJToDtPCeKRwmVW+Kg+EUEPRkgPWIyE4Ydb2RZgfGHid9Kdl/8IVLNg8r0hBbApUlFb
         Zk9Q==
X-Gm-Message-State: AOAM5304odPqtg+ssDEPWi5egjx1jFsqZFNoruPqlI8nuPyLJGjtxXCv
        csQyM59S/ZRWXKBt4pu2eIo=
X-Google-Smtp-Source: ABdhPJwvneTbbLdl4LpZIMB0nr+bVb80Iza2DJZ6p3uzFhSVP2DLgDUDOfku+ur+Hs8xZrpsH8VF4A==
X-Received: by 2002:a17:906:90c1:: with SMTP id v1mr11211337ejw.322.1590834611322;
        Sat, 30 May 2020 03:30:11 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id g21sm9511204edw.9.2020.05.30.03.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 03:30:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: dsa: sja1105: suppress -Wmissing-prototypes in sja1105_static_config.c
Date:   Sat, 30 May 2020 13:29:52 +0300
Message-Id: <20200530102953.692780-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530102953.692780-1-olteanv@gmail.com>
References: <20200530102953.692780-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Newer compilers complain with W=1 builds that there are non-static
functions defined in sja1105_static_config.c that don't have a
prototype, because their prototype is defined in sja1105.h which this
translation unit does not include.

I don't entirely understand what is the point of these warnings, since
in principle there's nothing wrong with that. But let's move the
prototypes to a header file that _is_ included by
sja1105_static_config.c, since that will make these warnings go away.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h              | 18 ------------------
 .../net/dsa/sja1105/sja1105_static_config.h    | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index cb3c81a49fbc..29ed21687295 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -323,24 +323,6 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 			const unsigned char *addr, u16 vid);
 
-/* Common implementations for the static and dynamic configs */
-size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
-					   enum packing_op op);
-size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
-					   enum packing_op op);
-size_t sja1105et_l2_lookup_entry_packing(void *buf, void *entry_ptr,
-					 enum packing_op op);
-size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
-					 enum packing_op op);
-size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
-				       enum packing_op op);
-size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
-					    enum packing_op op);
-size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
-					    enum packing_op op);
-size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
-				       enum packing_op op);
-
 /* From sja1105_flower.c */
 int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
 			   struct flow_cls_offload *cls, bool ingress);
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 9b62b9b5549d..8279f4f31eff 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -430,4 +430,22 @@ void sja1105_unpack(const void *buf, u64 *val, int start, int end, size_t len);
 void sja1105_packing(void *buf, u64 *val, int start, int end,
 		     size_t len, enum packing_op op);
 
+/* Common implementations for the static and dynamic configs */
+size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
+					   enum packing_op op);
+size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+					   enum packing_op op);
+size_t sja1105et_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op);
+size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
+					 enum packing_op op);
+size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
+size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op);
+size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op);
+size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
+
 #endif
-- 
2.25.1

