Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B2713ED08
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394905AbgAPSAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:00:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46167 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387575AbgAPSAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:00:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F36A222223;
        Thu, 16 Jan 2020 13:00:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 16 Jan 2020 13:00:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jNaf1EZH4Om7p95KA
        u9VG7jRy8FX1bfhkUyfys6+QMI=; b=NmfKX6/fP+tNHANhkBMNu7eHwAWfrTax/
        oltTDZVaWpBdIrXGzBSZDjBcueWOXLYEV429h0RKapSlURo9UGhcvKv50+6C1w5L
        eJVHrxkAAYf7SHsP5RwpDCRI3GIlLSmbmy+W1j4pA48Abg++5PQRAkwI1dcVsiLw
        EbejHCZiOh1VIJ/75W8hrnIA8uVq+HXXWjrad25fvDJOvHykMcln78dxNfV2P5bu
        JsjcxucBGvL0ounp5pgrsDGVp4E9xeifAdo3Y7hQJ/aJTqNkTEPxodSE1mY8whXh
        i/NbR4hIx6EQ13b66SzMP9O75lEuOobkZfE9TAjwv8m7gIBBtjZ9A==
X-ME-Sender: <xms:waQgXrhb7tpy8XNUH1DR6FdHTrH7j28ZbkuiFdErKOqoZchXbpzP-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdehgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:waQgXp462WOwmQPHkgz2_Mw17U7ElO0lV5J4XssYlDzWK4OAhCoXuQ>
    <xmx:waQgXkfv9BoMuqMJK3U6AKImPO2595jGl1wD97ZkQ-oudFX0T1DysQ>
    <xmx:waQgXhyDVHkWa3Twmb1jy-f9RSe2VYv04Moo1Jr7O6ySh67halo2cg>
    <xmx:waQgXovkGIdJuHWZeZEuu7oiM3wa3v5kitz9tk6TVp-Z-6TzSKl7wA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F4768005A;
        Thu, 16 Jan 2020 13:00:32 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jacob.e.keller@intel.com, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] Documentation: Fix typo in devlink documentation
Date:   Thu, 16 Jan 2020 19:59:44 +0200
Message-Id: <20200116175944.1958052-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver is named "mlxsw", not "mlx5".

Fixes: d4255d75856f ("devlink: document info versions for each driver")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/devlink/mlxsw.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index ccba9769c651..5f9bb0a0616a 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -40,7 +40,7 @@ The ``mlxsw`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
 Info versions
 =============
 
-The ``mlx5`` driver reports the following versions
+The ``mlxsw`` driver reports the following versions
 
 .. list-table:: devlink info versions implemented
    :widths: 5 5 90
-- 
2.24.1

