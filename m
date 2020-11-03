Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE92A505F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgKCTsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:18 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7337 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729757AbgKCTsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b4030001>; Tue, 03 Nov 2020 11:48:19 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:15 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next 10/12] net/mlx4: Cleanup kernel-doc warnings
Date:   Tue, 3 Nov 2020 11:47:36 -0800
Message-ID: <20201103194738.64061-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432899; bh=ZYGOBZD+TNb+ul0jRAulgyd2QejbQe5CDfzyGjg7CzA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OAcQjwfSWSkwYKyj6W9IP4LOBIOmEJMKZmR4AbTcsM8hSJY7mQtYGb54aV0/mv2FL
         qgcjKRq35x6te4h+VMPE6SL2NFpQ1oZjdmhm3ccxzVUBQhjCwh8SKsm04qM4f0IAtd
         vmgil+p56qTc43qb1+rAdKAZZsY51WtnnJgvyQ1h7cbqITxh8MxJcQm5nYYldZRJHi
         5lq4g1YM39LNI3VKW75E6F2/cIa2/dhZFF9CNfRGKFRESM0+HcSNARdhKkTjDEjqxA
         2Y9BWPsBWJrzcrzfaXPYZa7xbElzFLlkkNxH5LaAGbRgdybnFtJ2MM/sVHh4DM43nS
         0IEhrDFNkQWqg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ git ls-files *.[ch] | egrep drivers/net/ethernet/mellanox/ | \
	xargs scripts/kernel-doc -none

drivers/net/ethernet/mellanox/mlx4/fw_qos.h:144:
warning: Function parameter or member 'in_param' not described ...
drivers/net/ethernet/mellanox/mlx4/fw_qos.h:144:
warning: Excess function parameter 'out_param' description ...

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/fw_qos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw_qos.h b/drivers/net/ethe=
rnet/mellanox/mlx4/fw_qos.h
index 582997577a04..954b86faac29 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw_qos.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw_qos.h
@@ -135,7 +135,7 @@ int mlx4_SET_VPORT_QOS_get(struct mlx4_dev *dev, u8 por=
t, u8 vport,
  * @dev: mlx4_dev.
  * @port: Physical port number.
  * @vport: Vport id.
- * @out_param: Array of mlx4_vport_qos_param which holds the requested val=
ues.
+ * @in_param: Array of mlx4_vport_qos_param which holds the requested valu=
es.
  *
  * Returns 0 on success or a negative mlx4_core errno code.
  **/
--=20
2.26.2

