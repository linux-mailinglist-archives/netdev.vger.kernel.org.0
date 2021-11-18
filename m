Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CC4455DF7
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhKROa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhKROa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:30:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC41561452;
        Thu, 18 Nov 2021 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245648;
        bh=1fYhL2/dwOHU+DAYurDA2pq8Nt+JCeUbaAUtKDU5Z4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7uXg3a9FtB9yBZcviAEyAR5LNkWYm7aHywJ9/9zA0fH6Wwqe2Cyzi+9IhboZ7A5C
         fqV8RpjheEEME4BFfxLo7ZlyCCotHx7A0rsbKOosy3I/kNQTB1IU18G/1LgAi79Adm
         EWop1XgW426TepSyK0DV739eZB3JAP5j2VEbSHgoPsdffGIoJ+bVAm9MsqDatU8CVm
         5hPGf51NBM0X3TQ+XsKovwILHteKPKl8xT8pz6IUThaFBc9zktXglb/9Y764vrKw9v
         BVNq4USVtuG21i4UeM+hUQVXWhnXabwJKoRD6cPODUPpkWLv4CBWMhRm3Ozr0fM8Fs
         ptnAAB1gr6Vig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] mlxsw: constify address in mlxsw_sp_port_dev_addr_set
Date:   Thu, 18 Nov 2021 06:27:18 -0800
Message-Id: <20211118142720.3176980-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118142720.3176980-1-kuba@kernel.org>
References: <20211118142720.3176980-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Argument comes from netdev->dev_addr directly, it needs a const.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5925db386b1b..4ce07f9905f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -303,7 +303,7 @@ int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_dev_addr_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				      unsigned char *addr)
+				      const unsigned char *addr)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char ppad_pl[MLXSW_REG_PPAD_LEN];
-- 
2.31.1

