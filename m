Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561678B1B8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfHMH4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:56:38 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39225 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbfHMH4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:56:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 31EF11C82;
        Tue, 13 Aug 2019 03:56:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 03:56:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8KtP9h71YYQWCyuCRZs0dvnAhsmoc1EEgrrHB1ntmHA=; b=ziB1DRyI
        A8lgLTIJcUWQk/zx7/KN2dI8TxYIkBsgXDDsgnlZIDiQOxH5Gwpbhx2qLIaSrvA7
        64eTJSwq+NrYfae9GT5CvFqM9irk07QYq2XW1sMmS8sfqAh3KfXoz52AWa9OqT38
        3LlMiGFVvgTGLadBU9rTIyo/A9mJRurUetnqcvxwm9rmaufz95Laza1e02ZyQ8cA
        8NGB8voa8e99WcHD6H5lISNO7j2ysvvCb3cyFvjDqGys/fldlhIPm2c+UjEsgo/f
        gVnzRVs0fTQiuX4kWvi7DPF6iBonBXgAecZXPoc1M0mKmj/f82a5AtfR3a6HgL5z
        xoKylMBQExRqGw==
X-ME-Sender: <xms:M21SXXYk0sK31K3H-YLoMQwgX30o5PuNOHl_M2X2JtW3JGb4JJRg-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddvhedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgepfe
X-ME-Proxy: <xmx:NG1SXbGa0sFX-lLOMQ2y9rDuirlOrVAEQ_O9M-7dJy5AG-6NfwcJjw>
    <xmx:NG1SXXfz21nf59zzuRCQGoyKy9f6x71nL3nIYS4QRd7_kJKshNOvSg>
    <xmx:NG1SXSEAU1GTBDp3T8uf4Rs6wGaDGaQ3Yk5sMQbtUnBvPvOMNgySmw>
    <xmx:NG1SXZ6j3_tVgqG23PG4GlHRQJAptoqbj7Lbx4_MmjX4GX-pYt4Wjw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3DACB8005B;
        Tue, 13 Aug 2019 03:56:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 14/14] Documentation: Add a section for devlink-trap testing
Date:   Tue, 13 Aug 2019 10:54:00 +0300
Message-Id: <20190813075400.11841-15-idosch@idosch.org>
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
 Documentation/networking/devlink-trap.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/networking/devlink-trap.rst b/Documentation/networking/devlink-trap.rst
index fe4f6e149623..7b07442b3ec3 100644
--- a/Documentation/networking/devlink-trap.rst
+++ b/Documentation/networking/devlink-trap.rst
@@ -196,3 +196,12 @@ narrow. The description of these groups must be added to the following table:
    * - ``buffer_drops``
      - Contains packet traps for packets that were dropped by the device due to
        an enqueue decision
+
+Testing
+=======
+
+See ``tools/testing/selftests/net/devlink_trap.sh`` for a test covering the
+core infrastructure. Test cases should be added for any new functionality.
+
+Device drivers should focus their tests on device-specific functionality, such
+as the triggering of supported packet traps.
-- 
2.21.0

