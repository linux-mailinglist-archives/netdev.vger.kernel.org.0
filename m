Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8FF206EE5
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390422AbgFXIUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:51 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44025 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390404AbgFXIUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5A91158051A;
        Wed, 24 Jun 2020 04:20:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ukNorG3dbVqKAOV91fmh8pDqM9jyXNN9vwibN+MqD7A=; b=fPhEZvVF
        SctqVKPvQI6vA0FptL5bPuMAOfHH93VqNnaYViW4coAHQMP+R/8gR1QCwnN6740D
        qb+/KKr8oJceTOgV2xFRDIo9CdpQ7qBcgS/mOXPPJfhu3Ms2Nxc+767sMalYMXTu
        5IlaBGxq6TYCZRwIHytVbT63TUpV65z6T4pz3TjaUz/Sq75HGJYSPu/4IH4i1J64
        5c/45r5LN6TWlXT5jR47XlnbtVTXuywHvTeH7A7XxeAjBEuqZqS8KJrarcva9k+a
        h92S92six2Ruwry+OWEN9eZQTtIlb8Hmy1+POVmCHQqOgj/XT0buH9QXjkfNXGVF
        jfZlUFHE+094Lw==
X-ME-Sender: <xms:3QzzXqjIGV_bTwjCSvy1CZhW3XDe4G0qGqS6c4AW0d1wlSesjv_XaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3QzzXrB7F5s8mioG-fAxC2AZugWRUTPE-KcqZJw6zn4gxBJOsM-X0Q>
    <xmx:3QzzXiEiwL9T3zHU1x0HdZiqoHiuSdvhQrSLTyfR1NSZCXits4KRZQ>
    <xmx:3QzzXjSax5xgfIL9_IMCtHISV1AZPv52mMawb4cV6LcsnnWUkRg24w>
    <xmx:3QzzXunUrz5mxllBiwYrcdjbWUV3NefvGyMRnFtyxhIC9wJH7ykbmw>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8209D30675F9;
        Wed, 24 Jun 2020 04:20:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/10] selftests: forwarding: forwarding.config.sample: Add port with no cable connected
Date:   Wed, 24 Jun 2020 11:19:22 +0300
Message-Id: <20200624081923.89483-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add NETIF_NO_CABLE port to tests topology.

The port can also be declared as an environment variable and tests can be
run like that:
NETIF_NO_CABLE=eth9 ./test.sh eth{1..8}

The NETIF_NO_CABLE port will be used by ethtool_extended_state test.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../testing/selftests/net/forwarding/forwarding.config.sample  | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index e2adb533c8fc..b802c14d2950 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -14,6 +14,9 @@ NETIFS[p6]=veth5
 NETIFS[p7]=veth6
 NETIFS[p8]=veth7
 
+# Port that does not have a cable connected.
+NETIF_NO_CABLE=eth8
+
 ##############################################################################
 # Defines
 
-- 
2.26.2

