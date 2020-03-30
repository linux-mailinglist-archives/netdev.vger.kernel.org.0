Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB381984A6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgC3TjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:12 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:35969 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728500AbgC3TjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3C5BA580546;
        Mon, 30 Mar 2020 15:39:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Bq0KMzJ1Vt2AL6EEwOVG/4GtRouBK9N+EiUeyPwRnoo=; b=lwH0Ozjt
        zWjx9LSnHVOzMWR2ymt2NkUJtB2j0LbFrwlNmLePohXbxxiTZfUGsHcaVUZonaH7
        lzavj4PmaX6rbaP3Q9fzeQFbjwlug8U4kxAbyPSZBWdFt6VXLWMZ7maEbWsRTszS
        +VRURmnw37dofjJdY2aBImKanyWpxlM1ZBQnEu7YnlJ4FslRDjQqTPhbd3eHCCuQ
        +2JsVXdfU9aX9yk8MEPwKe3w+7SKwhjO8Vi1VQs7WuYFmzYPkY+18Iw96R44GcLh
        jzkHz7BL8KTqKrThpwbdQEZD8sKCY8cxqsv8W9a1+VyHHIuP5apxs4hY05fxHuMD
        VGcciWwIqA/BlA==
X-ME-Sender: <xms:3kqCXnHfoG6zXkGqNoisJ5RnsoQCklCMxHTU0s2ohWQB3IaAyYli_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:3kqCXjEOTvExWCBBeZ5PVFtctD-0q4_Tx1FeVNZ9pn50uWeDsvCUYQ>
    <xmx:3kqCXtsHqMhrxNxsDABg_5lvzo9giaGXfanQFYCPWebjJTDqs2qSog>
    <xmx:3kqCXhIPYGNiDOQypOdx9E4btGcHNFRTvKe1F25AJhspmhJVZbe4ng>
    <xmx:3kqCXlopRWBlLGsypWXBI_YFhzb885hJ6VIDOHUJ2aqdiTbd9ReM3Q>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10839306CA25;
        Mon, 30 Mar 2020 15:39:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 02/15] Documentation: Add description of packet trap policers
Date:   Mon, 30 Mar 2020 22:38:19 +0300
Message-Id: <20200330193832.2359876-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Extend devlink-trap documentation with information about packet trap
policers.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../networking/devlink/devlink-trap.rst       | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 63350e7332ce..a09971c2115c 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -287,6 +287,32 @@ narrow. The description of these groups must be added to the following table:
      - Contains packet traps for packets that were dropped by the device during
        ACL processing
 
+Packet Trap Policers
+====================
+
+As previously explained, the underlying device can trap certain packets to the
+CPU for processing. In most cases, the underlying device is capable of handling
+packet rates that are several orders of magnitude higher compared to those that
+can be handled by the CPU.
+
+Therefore, in order to prevent the underlying device from overwhelming the CPU,
+devices usually include packet trap policers that are able to police the
+trapped packets to rates that can be handled by the CPU.
+
+The ``devlink-trap`` mechanism allows capable device drivers to register their
+supported packet trap policers with ``devlink``. The device driver can choose
+to associate these policers with supported packet trap groups (see
+:ref:`Generic-Packet-Trap-Groups`) during its initialization, thereby exposing
+its default control plane policy to user space.
+
+Device drivers should allow user space to change the parameters of the policers
+(e.g., rate, burst size) as well as the association between the policers and
+trap groups by implementing the relevant callbacks.
+
+If possible, device drivers should implement a callback that allows user space
+to retrieve the number of packets that were dropped by the policer because its
+configured policy was violated.
+
 Testing
 =======
 
-- 
2.24.1

