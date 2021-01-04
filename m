Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A50D2E8F97
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 04:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbhADDc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 22:32:59 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12055 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbhADDc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 22:32:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff28c420000>; Sun, 03 Jan 2021 19:32:18 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 03:32:17 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH linux-next v2 1/7] vdpa_sim_net: Make mac address array static
Date:   Mon, 4 Jan 2021 05:31:35 +0200
Message-ID: <20210104033141.105876-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104033141.105876-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609731138; bh=IOLgtQ8wjhNIKDKoZd+WM4eBiMFNdcNz29O7F2JDlb0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=cwJP/sM3XEWinIjH34eV2QdYSaiWvmW/QM/0N/Pia64VC7jFc//UoX0nXwe8a/KWZ
         NM1qMCDmbBNDf+Ay2o96+G3pQXeIURq8abvjooPLb+B3gmzRk5Nhumbm1u4QnFFD/E
         IJsZtmBDGgpV8GjDuYIlz11E2QS/GYAgfWrXnSYoTgUOvwjth352o0dPJDrkZw4/aQ
         eAmtKwTE+gtGNI1ww7NoInR6fTEtiszPJl3rlXnjK00auxbgUAE0xgP2FwpBN5bXgj
         Js4OGfAW3xE87Jhk4vQ23IyUb57faWoSWIqmfIdYfOI47X+7ScTtoMl9COwB5MHkLq
         gML/R6ZK6vQ+g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC address array is used only in vdpa_sim_net.c.
Hence, keep it static.

Signed-off-by: Parav Pandit <parav@nvidia.com>
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

