Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9232C683
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfE1MbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:24 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52569 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727149AbfE1MbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 03A2A2279;
        Tue, 28 May 2019 08:22:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=LHpeJf9QYfFsy9Af/wWimyB89KQ3jUvyzNv+udin13Q=; b=SurLkd+g
        tYBRF3KmlGMDhPrFQW/smKBzqxd/tRYb87hmwJjWfIdoILXaM5/REFVhptxqRqZ3
        4JMzdz+y9k1he+WLCF4v+wwCwvr8iWoXw+YDg5NtbhDkch43gQAWXA6BEEs74JuA
        SOg9iKoPaqjleBk7mr4MWooq3BmmQBu6wePQKhQ+q99oPTgvHeijE/V2yF/zvzxV
        B9sa2O8Ng3iW44s99HbsqttEO4UTqfos5iqBdf5BUP6Rq9HbryAEU0R95VWtzc1J
        8JY62LLfWbdvNufmPCDg0rY1BSKgL9VJAHQo6p+qkxZJhSy9X+n9WcQhD2JUQpbx
        91YA2aD3e3B3Vw==
X-ME-Sender: <xms:GCjtXPRxbURf0It9w-9-4F-klo-NVV8sU-c7yPq6fkRSimiNvkehTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeg
X-ME-Proxy: <xmx:GCjtXOrCv5TgxFBk4QLjrxoWWWM55Ae_P0MmOczd0EhnKBJF0R1LbQ>
    <xmx:GCjtXN6tUeaq2tqyi3qCu5Qg2RgqaGQ_l9Re1oaLzO0iLEeJLqmsaw>
    <xmx:GCjtXATZttoTJ8mci1lYIZ7tOVSbmDBc4xTzqyUb3iERLanPbezC2g>
    <xmx:GCjtXBjM5qJSSI8dsUzUrT-B9bNP129CxGIkmcBq8oPJ7nYVnzA95w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 544BB38008A;
        Tue, 28 May 2019 08:22:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 06/12] Documentation: Add description of netdevsim traps
Date:   Tue, 28 May 2019 15:21:30 +0300
Message-Id: <20190528122136.30476-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../networking/devlink-trap-netdevsim.rst     | 20 +++++++++++++++++++
 Documentation/networking/devlink-trap.rst     | 11 ++++++++++
 Documentation/networking/index.rst            |  1 +
 drivers/net/netdevsim/dev.c                   |  3 +++
 4 files changed, 35 insertions(+)
 create mode 100644 Documentation/networking/devlink-trap-netdevsim.rst

diff --git a/Documentation/networking/devlink-trap-netdevsim.rst b/Documentation/networking/devlink-trap-netdevsim.rst
new file mode 100644
index 000000000000..06bb93caa22d
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
+   * - ``fid_miss_exception``
+     - ``exception``
+     - When a packet enters the device it is classified to a filtering
+       indentifier (FID) based on the ingress port and VLAN. This trap is used
+       to trap packets for which a FID could not be found
diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index 4b3045bc76d1..a015f82421b8 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -163,6 +163,17 @@ be added to the following table:
        Random Early Detection (RED) queueing discipline to earlydrop the
        packet
 
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
index c09bf85ec050..50fe7f9346ab 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -27,6 +27,7 @@ Contents:
    dsa/index
    devlink-info-versions
    devlink-trap
+   devlink-trap-netdevsim
    ieee802154
    kapi
    z8530book
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 0115a1ef1ca3..952764d1f6e6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -216,6 +216,9 @@ struct nsim_trap_data {
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
 
+/* All driver-specific traps must be documented in
+ * Documentation/networking/devlink-trap-netdevsim.rst
+ */
 enum {
 	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
 	NSIM_TRAP_ID_FID_MISS_EXCEPTION,
-- 
2.20.1

