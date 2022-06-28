Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8206655E93F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347127AbiF1OAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346506AbiF1OAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:00:37 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9891E369E2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 07:00:36 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id D7B43320102;
        Tue, 28 Jun 2022 15:00:35 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o6Bla-0008Ia-VE;
        Tue, 28 Jun 2022 15:00:34 +0100
Subject: [PATCH net-next v2 09/10] sfc: replace function name in string with
 __func__
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jonathan.s.cooper@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Tue, 28 Jun 2022 15:00:34 +0100
Message-ID: <165642483484.31669.11292363129265370240.stgit@palantir17.mph.net>
In-Reply-To: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
References: <165642465886.31669.17429834766693417246.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

Minor fix to existing code to make later patch checkpatch clean.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mcdi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index a3425b6be3f7..b53fb01dcbad 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1472,7 +1472,8 @@ static int efx_mcdi_drv_attach(struct efx_nic *efx, bool driver_operating,
 	 */
 	if (rc == -EPERM) {
 		netif_dbg(efx, probe, efx->net_dev,
-			  "efx_mcdi_drv_attach with fw-variant setting failed EPERM, trying without it\n");
+			  "%s with fw-variant setting failed EPERM, trying without it\n",
+			  __func__);
 		MCDI_SET_DWORD(inbuf, DRV_ATTACH_IN_FIRMWARE_ID,
 			       MC_CMD_FW_DONT_CARE);
 		rc = efx_mcdi_rpc_quiet(efx, MC_CMD_DRV_ATTACH, inbuf,


