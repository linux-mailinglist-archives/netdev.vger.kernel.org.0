Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786CE2A87CB
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbgKEUNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:13:15 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6026 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbgKEUNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:13:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45cce0001>; Thu, 05 Nov 2020 12:13:02 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:13:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next v2 10/12] net/mlx4: Cleanup kernel-doc warnings
Date:   Thu, 5 Nov 2020 12:12:40 -0800
Message-ID: <20201105201242.21716-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105201242.21716-1-saeedm@nvidia.com>
References: <20201105201242.21716-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607182; bh=ZYGOBZD+TNb+ul0jRAulgyd2QejbQe5CDfzyGjg7CzA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=k17kcXfg1LqjfFKI9OzP7yYxwjDsUNBIsyuYUkIgBUhMi0rlvK/7suddMvMuWbCUb
         f89tZiTwQjYnlFBgSYiLxHyBvcKs7J2T5OI2LO3gQWjTiyaRE0I1SiGELOMraUo83H
         8N8lBI3ixcg+TnvSUvM/LPr+P5LL1XHUAYa0RBGTmfNzA7E5K8kBKiv5qbdN8UJAg+
         fC6ZhfBXodcDXREt8dS76mSzTr/e9XchI7UHHreO8L6Sd9nNxiJb+w3UDWfCq2n88t
         wxi3b+5mDv9qA0Q3KHNhsD7PCNeEkAM5+unRguMhy/QOvCN3rMOKh6kSRlMw8wgMr8
         kRt4ip3xOGuvg==
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

