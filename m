Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756D2DE97D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfJUKbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:31:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34509 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbfJUKbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:31:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6337D21540;
        Mon, 21 Oct 2019 06:31:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 21 Oct 2019 06:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=aOYIv+IkPgyenxtuY2RHGcqA6aB5LGsHRhMYwxPrPZ0=; b=I38D3eqI
        20B9hs0fSC7zm2lspuN3XRA1LitXDHwPG9RWojzWU4y92+KzDc2jWdWhv0fokyQZ
        GHi3dOc58QpiYUhWD51RK7nqve8E1Sk2asYGCVAoUI1y0eCk4U3n1oMn4TPC/zPx
        6vXaboQccE6Jz+1usaaBnX+MKolHRcBlDloGfMiFJmfF19zDd9v9cxmFZS0MfDpD
        Vrby7HvnIg5xdwtNdh7wZ4Lt72mVWMBKG/10CUC0xfhyUecVOSfjD0yEvgIqxP5x
        X4hQkUB4LcQwU6VwUCrvn5cokEV9C1EbxgWThtABVqmq8bSWvJtyjXWRwN6wemvD
        6LKzZFt7/c7lrg==
X-ME-Sender: <xms:CYmtXe3wpb635hhttEw0FZFLcIAsD3QbEhETwHcWLuYh5PKJoWab4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeehgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepuddtledrieehrddvtddrvdegieenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:CYmtXUChmfNu9hroLc1iE_RshpCLLXM9Qa_cc_Ki-MVeenSgbxUoYA>
    <xmx:CYmtXfF8EUP84R1aUQk8msJFHdGIV72Ae0w1ybv6TIpztnSHzTVlxA>
    <xmx:CYmtXepc2A3CkgjFTHaxAq304fjo_XoBfFpDCcZIN75mxkl9ScGCtQ>
    <xmx:CYmtXQGyboJLX3u14cPH8LHOJh0n2Jz9EqX57QvGZkbXYYum4B80gg>
Received: from localhost.localdomain (bzq-109-65-20-246.red.bezeqint.net [109.65.20.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id 423CBD60062;
        Mon, 21 Oct 2019 06:31:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] mlxsw: reg: Add macro for getting QSFP module EEPROM page number
Date:   Mon, 21 Oct 2019 13:30:30 +0300
Message-Id: <20191021103031.32163-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021103031.32163-1-idosch@idosch.org>
References: <20191021103031.32163-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Provide a macro for getting QSFP module EEPROM page number from the
optional upper page number row offset, specified in request.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f5e39758c6ac..adb63a266fc7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8412,6 +8412,7 @@ MLXSW_ITEM32(reg, mcia, device_address, 0x04, 0, 16);
 MLXSW_ITEM32(reg, mcia, size, 0x08, 0, 16);
 
 #define MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH	256
+#define MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH	128
 #define MLXSW_REG_MCIA_EEPROM_SIZE		48
 #define MLXSW_REG_MCIA_I2C_ADDR_LOW		0x50
 #define MLXSW_REG_MCIA_I2C_ADDR_HIGH		0x51
@@ -8447,6 +8448,14 @@ enum mlxsw_reg_mcia_eeprom_module_info {
  */
 MLXSW_ITEM_BUF(reg, mcia, eeprom, 0x10, MLXSW_REG_MCIA_EEPROM_SIZE);
 
+/* This is used to access the optional upper pages (1-3) in the QSFP+
+ * memory map. Page 1 is available on offset 256 through 383, page 2 -
+ * on offset 384 through 511, page 3 - on offset 512 through 639.
+ */
+#define MLXSW_REG_MCIA_PAGE_GET(off) (((off) - \
+				MLXSW_REG_MCIA_EEPROM_PAGE_LENGTH) / \
+				MLXSW_REG_MCIA_EEPROM_UP_PAGE_LENGTH + 1)
+
 static inline void mlxsw_reg_mcia_pack(char *payload, u8 module, u8 lock,
 				       u8 page_number, u16 device_addr,
 				       u8 size, u8 i2c_device_addr)
-- 
2.21.0

