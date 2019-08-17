Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F1F91092
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 15:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfHQNa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 09:30:59 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:48849 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfHQNa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 09:30:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 54EF32054;
        Sat, 17 Aug 2019 09:30:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 17 Aug 2019 09:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=3e/LlZ5gXQ2uDHCIw0Ziavrqf5kSEuXp4gCd6yQo9eI=; b=W7Cdsy5e
        Vkq6bwa9dqDk/WCNE9WN0OJq0LDGq4QXw029R2dDmnomPKNzxHszTXzTHTEB8T+M
        XeYpi8Q5a+X9zQeoOaYqs8Koa5cLE/MysdJWmUdaCAaGd4feCYvEToIqHFre0BEd
        lYkqtkDxdqa6kQvxWLgo/IjBcu9xZzXihV1EJf5bKDRJMci0Id0SzC9VM3tYTahy
        ct+K5cDgbcpqkk6NgSkyoqrIccQHQXzsNyKuUrg+YcwdKcmGdtWL/Quxlob/nx9E
        wWYHv0SKIlnVLAZ20WkLiUy6dZCL7ASfJILfTPGj2fWSa5G3pcVlcLIR8byinA8y
        A0p3ELEn9FBp/g==
X-ME-Sender: <xms:kgFYXcFEsPyTI41t6WMU8Z1xBPDwUkibbiw5ZgpctB5H7bzOjtzICw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefhedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejjedrvddurddukedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeple
X-ME-Proxy: <xmx:kgFYXdJnD9P-cgJ0e2VQ0Ju9yKy2Ffqgoq66a4DsbrI5joAyKxkCQQ>
    <xmx:kgFYXRh5svDiW-LWK6FMweX1w-n9Ka6cML9DKNGjA9xWn9CFi5sWtQ>
    <xmx:kgFYXX53rXGNFV-jWoozzpoABOzp12DknRdxKzMWzsU42g2RkYAhQw>
    <xmx:kgFYXbdxSQ2Ii9W_H3qb-qjB_z30ZJWISz_hEx1uZwRGUCPXrvzORA>
Received: from splinter.mtl.com (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99F028005C;
        Sat, 17 Aug 2019 09:30:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 12/16] Documentation: Add description of netdevsim traps
Date:   Sat, 17 Aug 2019 16:28:21 +0300
Message-Id: <20190817132825.29790-13-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817132825.29790-1-idosch@idosch.org>
References: <20190817132825.29790-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../networking/devlink-trap-netdevsim.rst     | 20 +++++++++++++++++++
 Documentation/networking/devlink-trap.rst     | 11 ++++++++++
 Documentation/networking/index.rst            |  1 +
 drivers/net/netdevsim/dev.c                   |  3 +++
 4 files changed, 35 insertions(+)
 create mode 100644 Documentation/networking/devlink-trap-netdevsim.rst

diff --git a/Documentation/networking/devlink-trap-netdevsim.rst b/Documentation/networking/devlink-trap-netdevsim.rst
new file mode 100644
index 000000000000..b721c9415473
--- /dev/null
+++ b/Documentation/networking/devlink-trap-netdevsim.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+Devlink Trap netdevsim
+======================
+
+Driver-specific Traps
+=====================
+
+.. list-table:: List of Driver-specific Traps Registered by ``netdevsim``
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fid_miss``
+     - ``exception``
+     - When a packet enters the device it is classified to a filtering
+       indentifier (FID) based on the ingress port and VLAN. This trap is used
+       to trap packets for which a FID could not be found
diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index dbc7a3e00fd8..fe4f6e149623 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -162,6 +162,17 @@ be added to the following table:
      - Traps packets that the device decided to drop because they could not be
        enqueued to a transmission queue which is full
 
+Driver-specific Packet Traps
+============================
+
+Device drivers can register driver-specific packet traps, but these must be
+clearly documented. Such traps can correspond to device-specific exceptions and
+help debug packet drops caused by these exceptions. The following list includes
+links to the description of driver-specific traps registered by various device
+drivers:
+
+  * :doc:`/devlink-trap-netdevsim`
+
 Generic Packet Trap Groups
 ==========================
 
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 86a814e4d450..37eabc17894c 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -15,6 +15,7 @@ Contents:
    dsa/index
    devlink-info-versions
    devlink-trap
+   devlink-trap-netdevsim
    ieee802154
    kapi
    z8530book
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d07bbf0ab627..c217049552f7 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -323,6 +323,9 @@ struct nsim_trap_data {
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
 
+/* All driver-specific traps must be documented in
+ * Documentation/networking/devlink-trap-netdevsim.rst
+ */
 enum {
 	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
 	NSIM_TRAP_ID_FID_MISS,
-- 
2.21.0

