Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61A550510
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 15:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiFRNVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 09:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRNVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 09:21:48 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6F413E10;
        Sat, 18 Jun 2022 06:21:44 -0700 (PDT)
X-QQ-mid: bizesmtp88t1655558035t2d2npd2
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 18 Jun 2022 21:13:22 +0800 (CST)
X-QQ-SSF: 01000000002000D0I000B00A0000000
X-QQ-FEAT: JRmPfD6HWhzzhcQGa5FG78WF84TTgnni7Vxnw8KsHzw7v2xYfmP1s26AOZUXu
        41jutDIyeo1tAj+gv5QGVzL8jau9mrcoFEFM/g/L11XwaTZGvXzBPzcCMpwMtATwsKryNsJ
        cGYEY9XG3zcqmlmlAHE6duE0z6SS+ozoUaYI3DUKlV0Gk2r/fKsqVEih26Z9cTW95yEqWeE
        w8FGMPL3Gfr9PiEIq3kOOJhtSC9nv6IFNONRK3rR6i+8pl1cHV6iZ4t1D8/m1ORV1UpKuYZ
        a/UPxnjOKo/MitrpFUOWqbNvrQQkj5lkrdMRfYisOvF0M9cZJOlt4ZaM2Kvqtrdmcb/b0IK
        qqALDoaQvw48XQEO8Mmr6U8mPN2DA==
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     kvalo@kernel.org
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] brcmfmac: sdio: Fix typo in comment
Date:   Sat, 18 Jun 2022 21:13:05 +0800
Message-Id: <20220618131305.13101-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'and'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

