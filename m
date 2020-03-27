Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB5F195368
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgC0I46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:56:58 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51321 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgC0I45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:56:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ECB2B5C044F;
        Fri, 27 Mar 2020 04:56:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=PS/EtZARXKJZoXvVtJu/npLqP2bRxMSHD6LdGtVVL8o=; b=wvd5M2zr
        xDSPTmgLMEd+xgHY8PfA4ZdZmTbGpSoVeNg/QeutvTV2jVMBF7KZa4zRy4K+q7qe
        O4U1aH/ZV6VfhT1LqR8j+nDmqYEXCBIUmvTMxjhEJa+bF3PXb8jf31OF9ANEAy09
        2Mep4rXR8uSsEPdEZDZi1hclZxtFw0P0y9gn3pPkzT7pqq4IeZ59TUL7z9eVNeee
        2C6QNr8yzUBjxC35wW+p+Uaxly/ikq5BO7zFZzO7xR/cKRIcJwxJoTpnYKj589yo
        J5QboMQ9i1UhdK1AUihyQueZwk9rrOFVkHQAXvE6KCh0HkiUSC6LcRtVOWk0s2A7
        Zp9JToB2vlIv8A==
X-ME-Sender: <xms:1799XgkfrLq1k2KIV686WtXAcZ0Kj-gC6lvPLZ9LiQ9de_eVYY7Kqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:1799XqxrpxgjoCZAmNZ64Hk1A5iwzbRfGgi3OBrNEIhnFoldsEXXVQ>
    <xmx:1799XtrWnWKJMylHSTAp-AZ6njcK_rnt05VDOud4SmPL72Tyn55hiw>
    <xmx:1799Xh5bAujBVHuWBhJ6lobLcVOC9jbPr-3QnqOr3GFyEuaIXEzhmA>
    <xmx:1799XqZeUlcAr6Jig-u_HMhDoNEI3CK6Db1MZfDJwLeObbFzvuNVww>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id ABD7C306C15B;
        Fri, 27 Mar 2020 04:56:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/6] mlxsw: spectrum_router: Add proper function documentation
Date:   Fri, 27 Mar 2020 11:55:21 +0300
Message-Id: <20200327085525.1906170-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Suppress following warnings when compiling with W=1:

drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:1552: warning:
Function parameter or member 'mlxsw_sp' not described in
'__mlxsw_sp_ipip_entry_update_tunnel'
drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:1552: warning:
Function parameter or member 'ipip_entry' not described in
'__mlxsw_sp_ipip_entry_update_tunnel'
drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:1552: warning:
Function parameter or member 'extack' not described in
'__mlxsw_sp_ipip_entry_update_tunnel'

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b527387ccf80..85f80cac5fe0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1535,13 +1535,17 @@ static void mlxsw_sp_nexthop_rif_update(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_rif *rif);
 
 /**
- * Update the offload related to an IPIP entry. This always updates decap, and
- * in addition to that it also:
- * @recreate_loopback: recreates the associated loopback RIF
- * @keep_encap: updates next hops that use the tunnel netdevice. This is only
+ * __mlxsw_sp_ipip_entry_update_tunnel - Update offload related to IPIP entry.
+ * @mlxsw_sp: mlxsw_sp.
+ * @ipip_entry: IPIP entry.
+ * @recreate_loopback: Recreates the associated loopback RIF.
+ * @keep_encap: Updates next hops that use the tunnel netdevice. This is only
  *              relevant when recreate_loopback is true.
- * @update_nexthops: updates next hops, keeping the current loopback RIF. This
+ * @update_nexthops: Updates next hops, keeping the current loopback RIF. This
  *                   is only relevant when recreate_loopback is false.
+ * @extack: extack.
+ *
+ * Return: Non-zero value on failure.
  */
 int __mlxsw_sp_ipip_entry_update_tunnel(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_ipip_entry *ipip_entry,
-- 
2.24.1

