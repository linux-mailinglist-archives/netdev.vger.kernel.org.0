Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124EE3D163F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238615AbhGURlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 13:41:03 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:55574 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238632AbhGURk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 13:40:56 -0400
X-IronPort-AV: E=Sophos;i="5.84,258,1620658800"; 
   d="scan'208";a="88346631"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 03:21:32 +0900
Received: from localhost.localdomain (unknown [10.226.92.105])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 719CF40078AD;
        Thu, 22 Jul 2021 03:21:29 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] ravb: Remove extra TAB
Date:   Wed, 21 Jul 2021 19:21:26 +0100
Message-Id: <20210721182126.18861-1-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align the member description comments for struct ravb_desc by
removing the extra TAB.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 86a1eb0634e8..80e62ca2e3d3 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -864,7 +864,7 @@ enum GECMR_BIT {
 
 /* The Ethernet AVB descriptor definitions. */
 struct ravb_desc {
-	__le16 ds;		/* Descriptor size */
+	__le16 ds;	/* Descriptor size */
 	u8 cc;		/* Content control MSBs (reserved) */
 	u8 die_dt;	/* Descriptor interrupt enable and type */
 	__le32 dptr;	/* Descriptor pointer */
-- 
2.17.1

