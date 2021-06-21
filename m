Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE96F3AE461
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFUHxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:53:55 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60289 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhFUHxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:53:52 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id BBA415C0101;
        Mon, 21 Jun 2021 03:51:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 21 Jun 2021 03:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fuwD0fnrr3CLqwCCqp9aqMr0cIWDh5vpE52onKNjqqA=; b=uCJc6xzA
        M2nzCjmN3TzOTDhVZthefG/SULppMMYL4WUf0CTnqkYmlJWflC1rthUtIjNCg7/e
        d3sGpmvPZC/W9QYIkHKMv+Ea6BBma3Snqbz69/fTAbgbXGnJw/LUMqawdBJTvb4f
        c0uv0w2TLBYU9sWpDzb1B/DuyD6gjdMHa42Rnh8CNQbTJDl5Y35jyRjHTst7YAOJ
        mNNXvbVv/bopwSyA7hSCrTy743pO/WUPjoym2YHEAiFgu0GYzdwyf77bGEINNSnk
        g+UuOY70IsuC8ukIg+zC1z25zXM5U85t8jXZHMsxrVj215YDDJkk572yXAtnIO1a
        /mIc/BE1GlFcXQ==
X-ME-Sender: <xms:CkXQYAhJOFYcVnSXsdbSbEh1YbBjQivRhdnG6uN7c27XHll_AXaLWw>
    <xme:CkXQYJBk6tJakFgSgpn8m9I6QThHkv1YOzV2SOlOnRWvBkkfURVPqhNydS03xt1j5
    GBzkGCLGPVwock>
X-ME-Received: <xmr:CkXQYIGJRvCB8EGfHsGD_zVRZM1e2hFx2jGKhy307nPWbKH4N8nWR_byuht5N5n6IDtkI88DvV-rzVqDggLWR69gUY7MqDPOeAcNqhYr3U_D8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefkedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CkXQYBTeYZN24gSW2I8YV1Wu4dRlPYvG7eQMaOLIlgefIhbvYiz8VQ>
    <xmx:CkXQYNxK5fy6RDEj5x973fS2sIrfn79xXv3tY0ul8UIAnFjnowePTQ>
    <xmx:CkXQYP4jmfrLPa8-OjY5kxwwHtRnlvrL2McqEexGkvgsluMBHJ-jsA>
    <xmx:CkXQYPuQc3FDI52QQijl2Se_icEYZn-CqmiAfZNcTKWMgZAtUeotBA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 03:51:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: reg: Document possible MCIA status values
Date:   Mon, 21 Jun 2021 10:50:40 +0300
Message-Id: <20210621075041.2502416-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210621075041.2502416-1-idosch@idosch.org>
References: <20210621075041.2502416-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Will be used to emit meaningful messages to user space via extack in a
subsequent patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index cd60a0f91933..6fbda6ebd590 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9690,6 +9690,20 @@ MLXSW_ITEM32(reg, mcia, l, 0x00, 31, 1);
  */
 MLXSW_ITEM32(reg, mcia, module, 0x00, 16, 8);
 
+enum {
+	MLXSW_REG_MCIA_STATUS_GOOD = 0,
+	/* No response from module's EEPROM. */
+	MLXSW_REG_MCIA_STATUS_NO_EEPROM_MODULE = 1,
+	/* Module type not supported by the device. */
+	MLXSW_REG_MCIA_STATUS_MODULE_NOT_SUPPORTED = 2,
+	/* No module present indication. */
+	MLXSW_REG_MCIA_STATUS_MODULE_NOT_CONNECTED = 3,
+	/* Error occurred while trying to access module's EEPROM using I2C. */
+	MLXSW_REG_MCIA_STATUS_I2C_ERROR = 9,
+	/* Module is disabled. */
+	MLXSW_REG_MCIA_STATUS_MODULE_DISABLED = 16,
+};
+
 /* reg_mcia_status
  * Module status.
  * Access: RO
-- 
2.31.1

