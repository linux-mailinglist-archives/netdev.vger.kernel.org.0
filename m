Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A2F320DFC
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhBUVfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhBUVfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:08 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9210C061793
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:10 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id t11so26067660ejx.6
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kXuZvLLvx0TuGzlM0GmcZEDK9pas+V35vr/sayO3ytE=;
        b=fmyMjyqZGiB3ByBNLHA+c5u7w3imcfzP07C45EKaVJxIY3gNtNgNIDNMjAm0543nhM
         dr7sAFn4EiWcJfYR9hQ0yoZr+6DQWSBBY9ucmosQIpJT9qc9qpqoMQhHD9gYsH8u9Wvb
         uBPiY0nXzpONJ7TOaFUFgb0GlKpmUhez2ULG6IYqGxfZ8oJlTdB5qqAt9MwwXMlF8Q5I
         nNZPKajjBG70GVYZpLCBp52jo5Wscbhf4ytez5nFnjHPWv8r2STXUpKFTX2hRkjwU8JJ
         Tr2VSfFtZQysqAanFGcRPjsepAGKq9jMyMpyOUKdRpwXyrkQAs7Xtp12SXI0oZGYpMtD
         TiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kXuZvLLvx0TuGzlM0GmcZEDK9pas+V35vr/sayO3ytE=;
        b=hPem9E0cVKQ1MNZ0Y3gx43KLhSxzUOW2U3jkKxoEz4n28Hn9s6V3K1eOMalNi3zJ7w
         NaYlXCK1dgnQdA+aNKPnwdRbBN1aQBk4yadWXizrqo0bjTexFeg09WEtxnJhW7zN2GFe
         bd3+cXLsJcosxYY0RTnAwvyFe2m5OOOskAoPWvJt4/iAuw+PleG+I8Diu9CU4U4Xpboq
         yMXssv3pJzwj/VeACnV5hYrdexuuMLY7rGsxjyQLDVocIh70qRSIxoYW4C9s+LtGdwQn
         W6So3r2d8nNSe7OS5ax9MqeZ8DuLNNuWIlxOzrsbhPi3fvT5iaSsqSwddk94M5AzzaWa
         Cu0w==
X-Gm-Message-State: AOAM532x6xnYMum3fs0hZ2v7rSNGnmt9mP0988M8tduJyzLe03L8xN1I
        EMrkRkR5+b+8o/Rw8EGaBfcsqqHaNew=
X-Google-Smtp-Source: ABdhPJzvj1NNhVQyW52au1lYhRxjgP/EsUdtQ0+1bg5HWyKWijLgTlLA31Te1IGE7l2U98DqCHTKyA==
X-Received: by 2002:a17:906:3801:: with SMTP id v1mr18467064ejc.353.1613943249423;
        Sun, 21 Feb 2021 13:34:09 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 04/12] Documentation: networking: dsa: remove references to switchdev prepare/commit
Date:   Sun, 21 Feb 2021 23:33:47 +0200
Message-Id: <20210221213355.1241450-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After the recent series containing commit bae33f2b5afe ("net: switchdev:
remove the transaction structure from port attributes"), there aren't
prepare/commit transactional phases anymore in most of the switchdev
objects/attributes, and as a result, there aren't any in the DSA driver
API either. So remove this piece.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 30 ++++++++--------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index cb59df6e80f4..8fb0ceff3418 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -430,14 +430,8 @@ SWITCHDEV
 
 DSA directly utilizes SWITCHDEV when interfacing with the bridge layer, and
 more specifically with its VLAN filtering portion when configuring VLANs on top
-of per-port slave network devices. Since DSA primarily deals with
-MDIO-connected switches, although not exclusively, SWITCHDEV's
-prepare/abort/commit phases are often simplified into a prepare phase which
-checks whether the operation is supported by the DSA switch driver, and a commit
-phase which applies the changes.
-
-As of today, the only SWITCHDEV objects supported by DSA are the FDB and VLAN
-objects.
+of per-port slave network devices. As of today, the only SWITCHDEV objects
+supported by DSA are the FDB and VLAN objects.
 
 Device Tree
 -----------
@@ -616,14 +610,10 @@ Bridge VLAN filtering
   accept any 802.1Q frames irrespective of their VLAN ID, and untagged frames are
   allowed.
 
-- ``port_vlan_prepare``: bridge layer function invoked when the bridge prepares the
-  configuration of a VLAN on the given port. If the operation is not supported
-  by the hardware, this function should return ``-EOPNOTSUPP`` to inform the bridge
-  code to fallback to a software implementation. No hardware setup must be done
-  in this function. See port_vlan_add for this and details.
-
 - ``port_vlan_add``: bridge layer function invoked when a VLAN is configured
-  (tagged or untagged) for the given switch port
+  (tagged or untagged) for the given switch port. If the operation is not
+  supported by the hardware, this function should return ``-EOPNOTSUPP`` to
+  inform the bridge code to fallback to a software implementation.
 
 - ``port_vlan_del``: bridge layer function invoked when a VLAN is removed from the
   given switch port
@@ -651,14 +641,10 @@ Bridge VLAN filtering
   function that the driver has to call for each MAC address known to be behind
   the given port. A switchdev object is used to carry the VID and FDB info.
 
-- ``port_mdb_prepare``: bridge layer function invoked when the bridge prepares the
-  installation of a multicast database entry. If the operation is not supported,
-  this function should return ``-EOPNOTSUPP`` to inform the bridge code to fallback
-  to a software implementation. No hardware setup must be done in this function.
-  See ``port_fdb_add`` for this and details.
-
 - ``port_mdb_add``: bridge layer function invoked when the bridge wants to install
-  a multicast database entry, the switch hardware should be programmed with the
+  a multicast database entry. If the operation is not supported, this function
+  should return ``-EOPNOTSUPP`` to inform the bridge code to fallback to a
+  software implementation. The switch hardware should be programmed with the
   specified address in the specified VLAN ID in the forwarding database
   associated with this VLAN ID.
 
-- 
2.25.1

