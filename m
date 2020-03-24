Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AD7191A01
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCXTeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:14 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:49345 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgCXTeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0ED405800D2;
        Tue, 24 Mar 2020 15:34:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Bq0KMzJ1Vt2AL6EEwOVG/4GtRouBK9N+EiUeyPwRnoo=; b=osySVZUk
        xXj+QX4icvqKmjZ0yYMxkmx1gdMgT3dMTqDaZYN40SIraQL92G3OjBSin/SBtw6V
        PWSuKJJQ/2pMFSIP2iwbLobFvRJ6fzH9sp1XMJG7G3VHXxXcwelbw2pQGL/sS/t8
        mvxi0+nHfQksYAcoWuNYQAtUuHGlU62SB6AKBr/VcOuLuIUkppUKNvnjTKIyUYYF
        piZeMxn5ui6Y6o+kbJeItiyVD8PBgcV+8RiMB/nbaNGELBJqXugkmnoT9kCA3s//
        DW+mIPqIcjittfiqvYH3tbIK966tOXVZKu2oC6Fk6lylXXtU9M8QRazh/N9XGFMS
        25Cf+CEqIPJE1g==
X-ME-Sender: <xms:tGB6XkKtn9rG3_TFH0a1kwZWBtsgAo3R2pW_Z-n_md5kVkX81y2mNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:tGB6XvR58cRZMrmtFkcmm2PlH9y_GJpjmYT0-i81lngamsQtK6uoIQ>
    <xmx:tGB6XrHL_2XcTWhTW0Xn6Xr6cAxE2GGoEQBCuB5L6elGYm8Q3SEcCg>
    <xmx:tGB6XsWwqcZYG-0_j4-1S5xpljCj64Uq0LeTH78UOt2phbhvF98JHA>
    <xmx:tWB6XuoG10ushVfZZH1iXLk7OQ5whOAdPnDf4f2TTvmb9op6Owlrag>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4472D306551D;
        Tue, 24 Mar 2020 15:34:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/15] Documentation: Add description of packet trap policers
Date:   Tue, 24 Mar 2020 21:32:37 +0200
Message-Id: <20200324193250.1322038-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
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

