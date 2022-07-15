Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477F15782F4
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbiGRNBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiGRNAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:00:55 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A6763C1;
        Mon, 18 Jul 2022 06:00:31 -0700 (PDT)
X-QQ-mid: bizesmtp70t1658149198t7ceka2r
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 20:59:56 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: PeTlvEY0Q2AdbaOvoZKlNHaSh1t3QMepFH5yxova2us4zx+1PlLAdEG0u/0ZB
        xDKBNuGu+wP34OI++NzxzOOmkbCBVjnucy7I5RgrygYo6imMDEq3gUoCRbmoFWVNk4cUlE7
        h1QxnYHjt3uu3IxrgIAiaD+cPb84+beCi4ccFxjYxmXk4rFyXkOZZgJhtOn40VsQOxq6wZq
        GonwcJLDpV3+slj8SwtKrZkv4IoePQzLeoHw0zVinoMqV0Jco69uT9fGQaF5/m2HZUl2JA8
        4XHYLkXX4GeSoSvF5mk/GpF51WUFWEgje1IC9i+yVUptZ0xmRsyTosSjgpX7Xb17qYGDeJC
        rZPcqJIPe6RmQFgsAsUFShBjf7zKSJlibWAUtCewj80G1lt4SViDPs11iXeDGGvbebtq0kH
        vPJBCQLwnKw=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: cxgb3: Fix comment typo
Date:   Fri, 15 Jul 2022 12:57:59 +0800
Message-Id: <20220715045759.23308-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in line 246, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
index 84604aff53ce..89256b866840 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -243,7 +243,7 @@ static int cxgb_ulp_iscsi_ctl(struct adapter *adapter, unsigned int req,
 
 		/*
 		 * on rx, the iscsi pdu has to be < rx page size and the
-		 * the max rx data length programmed in TP
+		 * max rx data length programmed in TP
 		 */
 		val = min(adapter->params.tp.rx_pg_size,
 			  ((t3_read_reg(adapter, A_TP_PARA_REG2)) >>
-- 
2.35.1


