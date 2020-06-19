Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FFE2004D2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgFSJST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:18:19 -0400
Received: from smtp.asem.it ([151.1.184.197]:55382 "EHLO smtp.asem.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgFSJSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 05:18:17 -0400
Received: from webmail.asem.it
        by asem.it (smtp.asem.it)
        (SecurityGateway 6.5.2)
        with ESMTP id SG000329244.MSG 
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 11:18:15 +0200S
Received: from ASAS044.asem.intra (172.16.16.44) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 19
 Jun 2020 11:18:12 +0200
Received: from flavio-x.asem.intra (172.16.17.208) by ASAS044.asem.intra
 (172.16.16.44) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 19 Jun 2020 11:18:12 +0200
From:   Flavio Suligoi <f.suligoi@asem.it>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>
Subject: [PATCH 1/1] net: ethernet: oki-semi: pch_gbe: fix spelling mistake
Date:   Fri, 19 Jun 2020 11:18:11 +0200
Message-ID: <20200619091811.28651-1-f.suligoi@asem.it>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-SGHeloLookup-Result: pass smtp.helo=webmail.asem.it (ip=172.16.16.44)
X-SGSPF-Result: none (smtp.asem.it)
X-SGOP-RefID: str=0001.0A090210.5EEC82D6.003A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0 (_st=1 _vt=0 _iwf=0)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo: "Triger" --> "Trigger"

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
index 32b9d7705404..55cef5b16aa5 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
@@ -147,7 +147,7 @@ struct pch_gbe_regs {
 #define PCH_GBE_RH_ALM_FULL_8   0x00001000      /* 8 words */
 #define PCH_GBE_RH_ALM_FULL_16  0x00002000      /* 16 words */
 #define PCH_GBE_RH_ALM_FULL_32  0x00003000      /* 32 words */
-/* RX FIFO Read Triger Threshold */
+/* RX FIFO Read Trigger Threshold */
 #define PCH_GBE_RH_RD_TRG_4     0x00000000      /* 4 words */
 #define PCH_GBE_RH_RD_TRG_8     0x00000200      /* 8 words */
 #define PCH_GBE_RH_RD_TRG_16    0x00000400      /* 16 words */
-- 
2.17.1

