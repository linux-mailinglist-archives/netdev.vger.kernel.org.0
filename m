Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54B56C98C
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 15:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiGINhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 09:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGINhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 09:37:41 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5505E1087;
        Sat,  9 Jul 2022 06:37:36 -0700 (PDT)
X-QQ-mid: bizesmtp75t1657373787t5zi2kgl
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:36:24 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: cy+SGFpNa8dRbvKBGOigE9Qv6M5v4XKCxsuw/zff+2dY8OMUw7vxUR25JlzMY
        L9s6OWmy5lN4F4L8t1QSaIRxiln0Njy+sMatMkMACsE5KDRf/CiO89zaX/NaYDSBwP+6UVY
        8VGkEueNx7vFFfft9RNHQqWa/fwUgG2fne6AFm+sl65h+eOIfmEAGRFTkUdXxv93sUqAVfc
        qBd9JFNIq1R1dxvEF3QDLqFSWb8aocitglPuifvWJPnLBjcWQeu2ti9Hrn46hXXa61+F09y
        BVDAbnkMTDUrBVWSdhae22WnQ7zajN4E2CZzuIkHE04D+SYP2Sp+S4F7JBcGuszG5ZORNyY
        wDdS5/YrJEoxLnuBqyOlnSYrjMbgMrv/Cu/UMpOHDxgarKx53/yxjbQpJWI6QeGYN3IEqPQ
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        angus@akkea.ca, jiaqing.zhao@intel.com, mike.rudenko@gmail.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: brcmfmac: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:36:18 +0800
Message-Id: <20220709133618.25958-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'this'.
 Delete the redundant word 'and'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 3f5da3bb6aa5..ae5af76e2568 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -89,7 +89,7 @@ struct brcmf_bus_ops {
  *
  * @commonrings: commonrings which are always there.
  * @flowrings: commonrings which are dynamically created and destroyed for data.
- * @rx_dataoffset: if set then all rx data has this this offset.
+ * @rx_dataoffset: if set then all rx data has this offset.
  * @max_rxbufpost: maximum number of buffers to post for rx.
  * @max_flowrings: maximum number of tx flow rings supported.
  * @max_submissionrings: maximum number of submission rings(h2d) supported.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 212fbbe1cd7e..2136c3c434ae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1617,7 +1617,7 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		/* Do an SDIO read for the superframe.  Configurable iovar to
 		 * read directly into the chained packet, or allocate a large
-		 * packet and and copy into the chain.
+		 * packet and copy into the chain.
 		 */
 		sdio_claim_host(bus->sdiodev->func1);
 		errcode = brcmf_sdiod_recv_chain(bus->sdiodev,
-- 
2.36.1

