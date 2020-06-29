Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B479B20E09A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbgF2Urt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:49 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42809 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389821AbgF2Urr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E86A85800BF;
        Mon, 29 Jun 2020 16:47:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ukNorG3dbVqKAOV91fmh8pDqM9jyXNN9vwibN+MqD7A=; b=B/a/hRSK
        gF75nIwFRTsT2Oxhen1edNODTbJR7ZIHAOAifF7W1upSbkxIMhVicE4JkjpGlS++
        aLAv90EyvXLTO9WUTPGXzaq9dlre9BLB6s4THoAuGMclU/mAFuvNnLHve0PVgxD7
        4BxmNB+X0XQ+vrYGkbKaqpb0hukSOe7pSs+gobybWgBaim75qd7owU7M/BHuwU8G
        F9sZMy/eT0ly7Joy6X8M+K/4VQ0tHRip70VnUyuVqoHnuLGtlQURjWZUpoDNOi+5
        bfZgnNZ9axXPwttpfB5VbpI0JH8/AF6OxUs2NmO52rS0L41mbc/JdapD+rIf7Qg0
        XSeMoq3B9TZ3gQ==
X-ME-Sender: <xms:cVP6XgR6IogyZH9vXZOP9O9y9WkEN9FjjxxsDYBGLP9dkaFmK7ap7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:cVP6Xtyn8yulAagdGxtsaOwrJ_VzrWYJT6Iw7Yf9j1JUNe2B969C1Q>
    <xmx:cVP6Xt14vh0JMgIB-2JsDHyubDW3zkkCW5z4hDwvzzvZma1WPz-uOw>
    <xmx:cVP6XkBwTyHUIhHiBR5mjvoYQLyYlnWRKO2htabR9-1wyZhFHwk7IQ>
    <xmx:cVP6XqVSIebilC7rt8XKZ2zSeRZuiU82bxs5DYpStCtKgAgAwEDwIg>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id C0659328005A;
        Mon, 29 Jun 2020 16:47:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 09/10] selftests: forwarding: forwarding.config.sample: Add port with no cable connected
Date:   Mon, 29 Jun 2020 23:46:20 +0300
Message-Id: <20200629204621.377239-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
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

