Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170872EA8D6
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 11:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbhAEKdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 05:33:05 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14016 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbhAEKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 05:33:04 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff440360000>; Tue, 05 Jan 2021 02:32:23 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 10:32:21 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v3 1/6] vdpa_sim_net: Make mac address array static
Date:   Tue, 5 Jan 2021 12:31:58 +0200
Message-ID: <20210105103203.82508-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105103203.82508-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609842744; bh=jWwmgZDFERslTkegzqs6sCRdRaURErwyVVE3nMqjEcY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Y+MELtonfPOgcbBs+AIhIuMXl1fFF0q4RoIN2P6S9McN8xKaFobtXx7u0vHGpQAJy
         GXc5u46KzIsXN5vKk8ZFW60rgv6gY2xIeYaOCcYwZlBMEVaLMARuCYwTRPq+7s7ALa
         ui6BjbICvkVATeo8XHCvm9hPL2YjEZy+id5IRWASf21wLVWl07s75DuomiDcDvNVqK
         2VSjveO3oyaYqFVZkt674LwX8EUJZgF9sYE1o4OrqTYMcBlJFE5dOnupiX3inolhQ7
         FnWJoUiLQ4Ap/i744ZPj9D5/aIJ09GVelNsqgmnCJiL5+UOcLaplzsG0NQsAf3qVm6
         KPGcT2LWCsWBQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC address array is used only in vdpa_sim_net.c.
Hence, keep it static.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
Changelog:
v1->v2:
 - new patch
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim_net.c
index c10b6981fdab..f0482427186b 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -33,7 +33,7 @@ static char *macaddr;
 module_param(macaddr, charp, 0);
 MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
=20
-u8 macaddr_buf[ETH_ALEN];
+static u8 macaddr_buf[ETH_ALEN];
=20
 static struct vdpasim *vdpasim_net_dev;
=20
--=20
2.26.2

