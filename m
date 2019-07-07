Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D0561451
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfGGIAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:07 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:42245 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 51CD02813;
        Sun,  7 Jul 2019 04:00:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=uLCdbSSGO3BXKqvOIY+yol8eeam27K2jkeCDzuxhBKU=; b=IqiqQhZW
        dGUcn3vNTabKy7TUHsD6aCIgKo0jReTrxMfsygv9YhkdLVCYsgJv69+L6W9VZLC8
        2XSc1oHffyPzORXeHmzWyOCcFZWQbB33zAu8E/rWeKZbTiobM2UVHpfYTO81X/WM
        pHkW7cmP2//0AU65P+xN7IJE/K9dMlWy+TRmdIUC3AJI/xNLiy/8L8q/1tt89AAG
        a5/z5MJuYElrY10NLlhsvbTix7nESo+JcDu5MlXfE5lpT31467KlRrMSiSxRwODH
        2P3aB43NoR43pZahlKbFfJ+z7fhLU+tXwJAtCzV2BQHTxkMsnsIpBt6rnuNTW6G/
        zLxnOAfUHAdFSw==
X-ME-Sender: <xms:hqYhXWDKRBm1ZBCjL33iaRnSw0m4VqGWdKNLeDn2l2pvrV5h3qMFmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:hqYhXbKaHOLYLntdvfVx7TJGSFXgzQ4-hPWw-25W_GuHxyAA_B-2qQ>
    <xmx:hqYhXfl_4wLrPjKmo5PKUPELmTUerWY11OCfN2Uc3V_oAa-g_DObWw>
    <xmx:hqYhXUYvalBQ8cZ6dbi65YROUn0UXGHbdVgba1QiR476tSgJveC9fA>
    <xmx:hqYhXWabGjFmUP4J-vJiax94XzrR5a_VQWwHefJtJ_UPiwzaY_Ejmw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B63E5380083;
        Sun,  7 Jul 2019 04:00:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/11] Documentation: Add description of netdevsim traps
Date:   Sun,  7 Jul 2019 10:58:23 +0300
Message-Id: <20190707075828.3315-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
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
index 4a4fd42f5372..906cdeb0d1f3 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -153,6 +153,17 @@ be added to the following table:
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
index 2d8c60c3326c..2892b3154940 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -218,6 +218,9 @@ struct nsim_trap_data {
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
 
+/* All driver-specific traps must be documented in
+ * Documentation/networking/devlink-trap-netdevsim.rst
+ */
 enum {
 	NSIM_TRAP_ID_BASE = DEVLINK_TRAP_GENERIC_ID_MAX,
 	NSIM_TRAP_ID_FID_MISS,
-- 
2.20.1

