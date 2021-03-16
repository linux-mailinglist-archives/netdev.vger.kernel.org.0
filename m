Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C26D33D2E6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbhCPLYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhCPLYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8542DC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id p8so71461653ejb.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5sg2Nx8Fg6/wBx/cLi5Zi9NgorSY7gPt+6/GGb4CrKg=;
        b=LpeF1eakGdXed9Fa8+B/9xYrHHl1Twjf1LCuQVWb6s1STxZmlROjpELPpmLWmg+Ytq
         CEHnHfATKJW7CN3aZokEjHb88m51m0ueaxlCdsKoK6PA4PQnDPExotr3y/E+pBHD/VdH
         qLJP6QrkvA9jDT6Em7iu7Q+Vjvet0/BgpLvV13eT9G2RxsZhEc3AglpkYhY58PoXyInL
         bbE/FU+hx4LNd4As0hCKCiRjrqysY61/7Wl7EePIpTkxvJbyZk5egTLhERfjJyk2gBin
         OCNTCJZupt75mgrinL7TS5UFcWMMiTIps6Mg4baMjx/842c7ZEfzlpeqIMNQf9VxRy/C
         Fi9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5sg2Nx8Fg6/wBx/cLi5Zi9NgorSY7gPt+6/GGb4CrKg=;
        b=TFTv20T+9yfhXs6BTncHO1w9EiTq7ro/45Fb2pLEP9Wr6BAYW//LTJt0LJTHOqOJSl
         JXrV0sm6wDpkCWVtuXAVd7msZ7BpcuU2WVWe8HVhwqSbXHuGZiGN/HgeWL8nkPkM1XFp
         QENt58d4fFhLgeVv+ArKMw+MYTD6A8cW1hF/GjylPK3PsTZmOiY6HwTgf5oBDPi57gWy
         Y1Rv8+ueSH7QjxzqoJ6S+f+PzxoKtiLyv68iCGfPKxQIPNbe6KutfIvryHQdZ1Rgr9y4
         yolFYvm03XuAmrzJBieVSNBIgmvmR7RDEZd2sL2k3lGVQoRELhxgvkhasJQh9n3CNZGD
         w5zA==
X-Gm-Message-State: AOAM530m31H1K1q3KwUl1B1usPAJ+4jCECXP21htCxebb6fjZaL0DTGM
        un7AuNv5ReD8gmBq/VOaSAAvMADoLe4=
X-Google-Smtp-Source: ABdhPJxwUhRyUOyaoMkkTcC7gLh7RYNXDe1pilJbKndT4Z+nEOWnn/a7ZSxUn2sRXxP7kXQ/8pm6sw==
X-Received: by 2002:a17:906:fcc7:: with SMTP id qx7mr29089541ejb.486.1615893870977;
        Tue, 16 Mar 2021 04:24:30 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 04/12] Documentation: networking: dsa: remove references to switchdev prepare/commit
Date:   Tue, 16 Mar 2021 13:24:11 +0200
Message-Id: <20210316112419.1304230-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/dsa/dsa.rst | 30 ++++++++--------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 3bca80a53a86..ced2eb6d647a 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -452,14 +452,8 @@ SWITCHDEV
 
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
@@ -638,14 +632,10 @@ Bridge VLAN filtering
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
@@ -673,14 +663,10 @@ Bridge VLAN filtering
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

