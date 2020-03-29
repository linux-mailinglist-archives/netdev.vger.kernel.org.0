Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB65196F32
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgC2SWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:05 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38901 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgC2SWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 72BDA580907;
        Sun, 29 Mar 2020 14:22:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Bq0KMzJ1Vt2AL6EEwOVG/4GtRouBK9N+EiUeyPwRnoo=; b=wByQiTVf
        kz0ScBTVMIAFZYi9Aa4v8ApYvwQMojyc4EUGUF1pFbNiMc/wdVOZOqx3J5BTXKDp
        DbJ7hbAtN723ebyjvJRaLYg1AAUbGLZ5UH/JxcsTu51QMnLS76JntmX/iTcbAudM
        0pbipGxWZiQlBZlbdvo1CoiUyyxuxhNZzFzVmMmiDcjp8wEie1UQxZmVUwwgFLn/
        /MlTBGzrby6/OnMcSE1S9Ir8uJVOvqhXNP4RV4V8MO0ySe3JAXcAAB+FwN9uRpMq
        ZOCKGW22PlvCgqEc8f2x4C4QZt/BBZPDLa27zaZ92PuaeHtcJ3HDaO3sZXe/M0KL
        jB526qhbE7UUXw==
X-ME-Sender: <xms:S-eAXvlhhDS5v3BZBn8LoWpoGPQHNTD686RhgtoIW87z0Frn8a7lWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:S-eAXomyFXfvmQVF4iYFsJdXwZ38UduS4lxdvVeKq-hBu21LiOAVHA>
    <xmx:S-eAXse7HgwHxiFTyIh8ppAWOY8VtAISxkHgbLi_-eG0XJQo2_h7Ww>
    <xmx:S-eAXuxUzy75rxDpNnTvxhh7ZrXPCGj4AL7zEt2nIkSeGfxJAuRNcQ>
    <xmx:S-eAXmUVe_vGLvaJWoLE9a_8-9YAAFsR1mj4t3uWa8ebq6R0HqFJyQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 016703280059;
        Sun, 29 Mar 2020 14:22:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/15] Documentation: Add description of packet trap policers
Date:   Sun, 29 Mar 2020 21:21:06 +0300
Message-Id: <20200329182119.2207630-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
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

