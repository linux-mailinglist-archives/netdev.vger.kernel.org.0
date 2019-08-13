Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411908B1B6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfHMH4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:34 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:46633 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbfHMH43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D6F4B3047;
        Tue, 13 Aug 2019 03:56:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=9NRfCJOb9XeUKCqXBQn+CXCEcHhDKSuuPlU6/ZDs2zc=; b=niTGgfSj
        tGyKNDYJrJz0ZyOvcYo4Wh3kP32QzGgy7B6sNtoQnQr/85OQlcz0y1ENp4uB+q4m
        XmryJTbOa8dbahsgpLhFA9Yt4jGkOFTEb9PpWekflCjwR4JwtvHyn1Vd5rmO1Ryw
        j6xX3/RcjoZvbcIgrJ15WVreGRHjl8TFi4VTLSkMbV5SIHvJ4Ilib/fW2uF2NU1X
        FM68Cje1/e7FiRVCuOdoxd3gLx8BEsDlevd3rqhNDY0apYg+mMjeSsXFtapv3OF8
        GBraoH8R15DbHEpbT4v1aZ3puuTfnzX01kYXvPB1W6SKa7YcxoLg72UkQA22f33z
        w+zbUxoSOGeAYA==
X-ME-Sender: <xms:LG1SXdKr0DcMRGLvJW7B2zk4z7RBPVkm7kVIirl10MunZTDU_7FtYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepvd
X-ME-Proxy: <xmx:LG1SXWCp7UbEpXN_RJPiF-J-JMsgXSj_nQd1EbmylFjnRHA9OxMyxg>
    <xmx:LG1SXVcTais_hxVQilzdB9XWtTmCf5VzNCDcOPr2R61-wF1Tzfv2pg>
    <xmx:LG1SXd2VPpGo6fOQPAgbhBIA587x5fEZu2-Zw9pfieajkL4CZWIv_Q>
    <xmx:LG1SXetQIRGWJ6qOMjlfW5_Va4fkskXpEyW73svCly8Frv-EJqSx-Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E41F8005B;
        Tue, 13 Aug 2019 03:56:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 12/14] Documentation: Add description of netdevsim traps
Date:   Tue, 13 Aug 2019 10:53:58 +0300
Message-Id: <20190813075400.11841-13-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813075400.11841-1-idosch@idosch.org>
References: <20190813075400.11841-1-idosch@idosch.org>
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
index 2758d95c8d18..6691eeb039ae 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -270,6 +270,9 @@ struct nsim_trap_data {
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

