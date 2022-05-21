Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC6452FB64
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354924AbiEULOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354912AbiEULM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:57 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B5158E7D;
        Sat, 21 May 2022 04:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pu1drDPJcuRzcx4hdCBsCPeAOUcFnWUW89aYshD8b18=;
  b=fGafI63a/j5PKe/dI1MdqJwKz9GGIBOcyCfTyp9leoSQqbct5i6ET123
   HUtS5LyLWXPR3yZUIdW+SfAY3t+Nlj1Luq2VlwZwsnz2L+N/lR825C/tM
   vabeS87n78mSY0oFPRtBf8N1K5n8STl4Lp4TNU88rjDxZKwWfMB5xcFgq
   U=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727977"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:04 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kernel-janitors@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: fix typo in comment
Date:   Sat, 21 May 2022 13:11:20 +0200
Message-Id: <20220521111145.81697-70-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/staging/qlge/qlge_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 113a3efd12e9..8c35d4c4b851 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1976,7 +1976,7 @@ static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
 					 vlan_id);
 	} else {
 		/* Non-TCP/UDP large frames that span multiple buffers
-		 * can be processed corrrectly by the split frame logic.
+		 * can be processed correctly by the split frame logic.
 		 */
 		qlge_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
 					       vlan_id);

