Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC838168D
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 09:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhEOH0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 03:26:42 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:59986 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231330AbhEOH0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 03:26:37 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id B9B403894D;
        Sat, 15 May 2021 00:25:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com B9B403894D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1621063521;
        bh=TXvDbuc4kCjMwfKSh+8FOA/L1Q81uM1fQzOe/I8mhG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaJAJaDr8gNxileJK+BZQpxETCok9DDUm0SLbw4L4SZkVDY9qYXHAuQA5svYOJZAm
         Z67FE5OsrSHdNfL/Qp4u4qwi8n2n+BRftMUGb+mLJwigEX2ioJgduyZ9eB4eD/TI1V
         hGXH309Y4rnyrKz4YgaEYzkKJWK4dffTSbxWmhwI=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 1/2] bnxt_en: Include new P5 HV definition in VF check.
Date:   Sat, 15 May 2021 03:25:18 -0400
Message-Id: <1621063519-7764-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
References: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Gospodarek <gospo@broadcom.com>

Otherwise, some of the recently added HyperV VF IDs would not be
recognized as VF devices and they would not initialize properly.

Fixes: 7fbf359bb2c1 ("bnxt_en: Add PCI IDs for Hyper-V VF devices.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 46be4046ee51..4e57041b4775 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -282,7 +282,8 @@ static bool bnxt_vf_pciid(enum board_idx idx)
 {
 	return (idx == NETXTREME_C_VF || idx == NETXTREME_E_VF ||
 		idx == NETXTREME_S_VF || idx == NETXTREME_C_VF_HV ||
-		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF);
+		idx == NETXTREME_E_VF_HV || idx == NETXTREME_E_P5_VF ||
+		idx == NETXTREME_E_P5_VF_HV);
 }
 
 #define DB_CP_REARM_FLAGS	(DB_KEY_CP | DB_IDX_VALID)
-- 
2.18.1

