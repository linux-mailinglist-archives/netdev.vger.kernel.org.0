Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5760CEACB3
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfJaJmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55733 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726897AbfJaJmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 353B0210AF;
        Thu, 31 Oct 2019 05:42:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=sMoh8wHC2z7Ozg2/EPVXFEHF9dTv7TyaJAXB3wDDOB0=; b=huHhJose
        G3pocrHbxKEXnyXR+IfQke0pTM0pQ3FNqF7V4UdYCcn/0jaVtWm4tdjUcW0+3ou1
        YCdBYibOx81ykF2uZe0dfk0NawDiVrod4PcWDnQfhv61FGf0gPeml8i4MrUvyQYK
        6sfNSw9T+i9U/VRm25I1A7Ne3VOI+ZVNBTuox2bo6Gvhd7mlLHnzY6CW2iLBK/FK
        UBb103mgEyuZ2C8ryOja4JIAFI+z8XecSdXeyf7nBLZJXXMDGsi9/mywwTE1ZWC6
        AmS/frzNk1pY7Lt9lt+64O6TX5ULUB+UjAzzjgNB6GIGq1vBfY2RGXiEGb3WStKe
        xneACLVzGn5jKw==
X-ME-Sender: <xms:k6y6Xf7pO1qGJ2jpZW-VfYoVa0pn8xWkf2CWO05jRybII7kaXIO_vg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:k6y6XbC4bzeByE64MvmFQO81kOMtshuFCT6mK6LsqmhAw-5VQDH-Bg>
    <xmx:k6y6Xc908aa9S8F44j1n5UQZlaMMSVPHhAIYzahkeZu9Y3Y6AbCEBA>
    <xmx:k6y6XaJLLQUFGPX52ejjdv-AZxvtFKnVEfZHNC7hmaILil0DuhrHeg>
    <xmx:lKy6XYlCXN71ZKyWNaZo2Ij3sfmTQWNtsiVL9ZDC75eWARozor2bYw>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7DF058005A;
        Thu, 31 Oct 2019 05:42:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/16] mlxsw: reg: Extend PMLP tx/rx lane value size to 4 bits
Date:   Thu, 31 Oct 2019 11:42:06 +0200
Message-Id: <20191031094221.17526-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The tx/rx lane fields got extended to 4 bits, update the reg field
description accordingly.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7f7f1b95290f..7fd6fd9c5244 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3969,6 +3969,7 @@ MLXSW_ITEM32(reg, pmlp, local_port, 0x00, 16, 8);
  * 1 - Lane 0 is used.
  * 2 - Lanes 0 and 1 are used.
  * 4 - Lanes 0, 1, 2 and 3 are used.
+ * 8 - Lanes 0-7 are used.
  * Access: RW
  */
 MLXSW_ITEM32(reg, pmlp, width, 0x00, 0, 8);
@@ -3983,14 +3984,14 @@ MLXSW_ITEM32_INDEXED(reg, pmlp, module, 0x04, 0, 8, 0x04, 0x00, false);
  * Tx Lane. When rxtx field is cleared, this field is used for Rx as well.
  * Access: RW
  */
-MLXSW_ITEM32_INDEXED(reg, pmlp, tx_lane, 0x04, 16, 2, 0x04, 0x00, false);
+MLXSW_ITEM32_INDEXED(reg, pmlp, tx_lane, 0x04, 16, 4, 0x04, 0x00, false);
 
 /* reg_pmlp_rx_lane
  * Rx Lane. When rxtx field is cleared, this field is ignored and Rx lane is
  * equal to Tx lane.
  * Access: RW
  */
-MLXSW_ITEM32_INDEXED(reg, pmlp, rx_lane, 0x04, 24, 2, 0x04, 0x00, false);
+MLXSW_ITEM32_INDEXED(reg, pmlp, rx_lane, 0x04, 24, 4, 0x04, 0x00, false);
 
 static inline void mlxsw_reg_pmlp_pack(char *payload, u8 local_port)
 {
-- 
2.21.0

