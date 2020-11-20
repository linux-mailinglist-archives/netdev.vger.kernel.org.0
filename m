Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DFF2BB995
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgKTXEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1184 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgKTXEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0000>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:03:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Meir Lichtinger <meirl@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH mlx5-next 07/16] net/mlx5: Update the list of the PCI supported devices
Date:   Fri, 20 Nov 2020 15:03:30 -0800
Message-ID: <20201120230339.651609-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=jk2egcnsKlHDEDPsFQbMR+WG+6rVRdRXUH9kjvqYhN0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HG9v5ukDE+5IOUw53KZOLOsBIP7fa3RXfISPzvHtDK+zPdvtVXT3tMsvzK5uXUrIc
         6e42cOeL1NjphIaOq66U6ph4fOc34DqT3ZJ9NN1lr9KmoLRh8SGIfq3Xp6APVWPyWf
         YB8l4zV0gE1RWzhz31J7RSTliPxspiu3fy7l2NW7SbWZJ1HchHu7AaUM7TTTuz47WX
         Vdrqr0NfPQi8t6AbFHmb2dIO0aaVqCP+aNjJDzS5rQ+ATFhz2kfVnkYAFF7sUv2TfE
         5lboXEulnjPYQM0UMZ6EbBrU13h1ysvVN8ITQBao+//bojGQ98MQpPtMJkT7OV48WQ
         M7RIpGsBggi8w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@nvidia.com>

Add the upcoming BlueField-3 device ID.

Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 8ff207aa1479..a9757ccb9d16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1594,6 +1594,7 @@ static const struct pci_device_id mlx5_core_pci_table=
[] =3D {
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 n=
etwork controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integr=
ated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6=
 Dx network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7=
 network controller */
 	{ 0, }
 };
=20
--=20
2.26.2

