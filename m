Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E381AA06B0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfH1PzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:55:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46291 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbfH1PzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:55:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C209A21FE9;
        Wed, 28 Aug 2019 11:55:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 28 Aug 2019 11:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DngmjaDK/DxBAWviScAtPgD4o+8RDW/lwT9sStZEWxY=; b=Rt74HLCo
        4U1E+Rp+WYKqMa3PNt16wEidU7OCdASU/JVbkFkSYrS6qK5k6X/yu6yzH5IktI++
        /ZqY9u3YRUZOhlUd6Ez88vfEoEtPvPSdEG279rqVWLAwEZppY6AY1V8Tz7aKCaax
        QBm3M8BtXrUGLMz1oqgYTFVfLj4QYCGVNV8WaxnzZSXxq7gxspqEQ6fGiEoQvK8+
        wl+ZP0t+cSkFFizJg3gD1NvKgwX4EOKA1h4mTqCSLRgJ5y5NxL0DOvr0owUhXjx4
        qxQ+yBLhE4oAj8fwOPXSXkQLo4g6DNrvLRfPJw+gyp9QXjKjNzMjkhao8kXgQM8g
        iFnpE05eE9K2gw==
X-ME-Sender: <xms:26NmXYPPb9qSGp4TYMrX2Oaz3ZFadKBISceZMCA08T8O-dSRCd56fQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:26NmXbu2Gfp4pyPRlt-0nFUJqNYh-EJ_KtRrEzAXRgf-2kFbSwBYUA>
    <xmx:26NmXZ1PF5B_dNTFd_1mPX2Drz0J5gRbZxX8BR2ZOH_e60MBOGimZA>
    <xmx:26NmXT-uLeJ7dYMZn7k3rdXMFCNoL0TlIOCcWeJ6Q-iKqjY_127frg>
    <xmx:26NmXTk1V8twE7HQXaIMBG7eKJTLFTeBjVi6qaSQp7fKwSD-A9-sTg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAB77D60057;
        Wed, 28 Aug 2019 11:55:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/4] mlxsw: Bump firmware version to 13.2000.1886
Date:   Wed, 28 Aug 2019 18:54:36 +0300
Message-Id: <20190828155437.9852-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828155437.9852-1-idosch@idosch.org>
References: <20190828155437.9852-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The new version supports extended error reporting from firmware via a
new TLV in the EMAD packet. Similar to netlink extended ack.

It also fixes an issue in the PCI code that can result in false AER
errors under high Tx rate.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d4e7971e525d..dd3ae46e5eca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -48,7 +48,7 @@
 
 #define MLXSW_SP1_FWREV_MAJOR 13
 #define MLXSW_SP1_FWREV_MINOR 2000
-#define MLXSW_SP1_FWREV_SUBMINOR 1122
+#define MLXSW_SP1_FWREV_SUBMINOR 1886
 #define MLXSW_SP1_FWREV_CAN_RESET_MINOR 1702
 
 static const struct mlxsw_fw_rev mlxsw_sp1_fw_rev = {
-- 
2.21.0

