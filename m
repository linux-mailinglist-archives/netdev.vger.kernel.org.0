Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB9482C28
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiABQ4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:56:02 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:48561 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiABQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:56:02 -0500
Received: from localhost.localdomain ([88.152.184.187]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MeDYt-1mW6yT055z-00bICq; Sun, 02 Jan 2022 17:55:54 +0100
From:   Markus Koch <markus@notsyncing.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Markus Koch <markus@notsyncing.net>
Subject: [PATCH] net/fsl: Remove leftover definition in xgmac_mdio
Date:   Sun,  2 Jan 2022 17:54:08 +0100
Message-Id: <20220102165406.136860-1-markus@notsyncing.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:e0Ra41rzTo/PSXIi8J7gbQVRHkWtzninq55+zAKIo4A8BdC5oa7
 2ptwJQfY6LyUuwrc/9vN82XuQ/zg+5uvFrbg9shjsL7miIRVSQ6uii6MjNEtqE+/BNFe+Mw
 u+LStQ0Q7uvAzuTMkTA8RuEsbH9QCsro4U069aS8XfcvLLTjorGp3RBcxOZaQ0P+nR1Oq1M
 jYUGAEqLm+r3fUO7fmBSQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hzqwXEgBuQk=:FzlDBBAtHKxUVJqSqBF9dC
 0V+5UvndL5U637Dh3Xu2lHInrFyov13kJvYEWnYCcOFjhIX04O1XPp2EFEc89twFbkeWViuBV
 8Q4TjIhWCuegJdMSsk01pIpCjjeJgzdo41nR0457t284gUwvXqK++jQQMSU9YVhC//P16U32p
 Fhkg70Afp+mbfWPQljyaFkPVnNmqSzlUnTSinhuoghb7lFfcRIxAS0UF5WTBHx5mBBDyZDqpk
 FCWxTNRdhgG6V5uTXaMFYPkCnsEW7Pu1cEXv480OQHkpvHrEY2Ra0SM0u7MykArlyps7aXZ3a
 aREz/cNUmKbElxn2v9CRmiq+SxCCi9L4ALeQ5Usa6FUoo+E8xcHiAc82m0Op/G91Qo+surLv6
 dEb3rkZn+VLdcKGpQl0l0GzqWF1ArgJ8DV/mTa/TYDMh86lKFCMn4ODLH49eRVD31/APazavH
 qYHWyYBoYeRE8nVJNaHaC2H5HUnzTrvF+tYF/kB5XT5ZFQUJ4hLs2dCUZUUZ3UfLFQWDkODu0
 cBZhu7rn75vh2vJwkWjmIAAwQbDebzCjDM3aC5YYY4xlRD3Ajh5OHWXMjAG77RycE7Jf0pCIr
 b/TnqitZXYkZ3BopnQ3bLJoniykqscRfS6Isr7P39rHPdl+hrI+B/IWzdQuyw0D9fvkihexCv
 Qn4jdV+wMVApy6e63lLq2CMOWIz3dcP1M6CljrdJ82NrSrP+Nk4QAGfIO1CvRH8me6n6ej025
 MGDAH6+kiuRHNLw6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 26eee0210ad7 ("net/fsl: fix a bug in xgmac_mdio") fixed a bug in
the QorIQ mdio driver but left the (now unused) incorrect bit definition
for MDIO_DATA_BSY in the code. This commit removes it.

Signed-off-by: Markus Koch <markus@notsyncing.net>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 0b68852379da..5b8b9bcf41a2 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -47,7 +47,6 @@ struct tgec_mdio_controller {
 #define MDIO_CTL_READ		BIT(15)
 
 #define MDIO_DATA(x)		(x & 0xffff)
-#define MDIO_DATA_BSY		BIT(31)
 
 struct mdio_fsl_priv {
 	struct	tgec_mdio_controller __iomem *mdio_base;
-- 
2.34.1

