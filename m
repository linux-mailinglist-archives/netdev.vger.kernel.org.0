Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10815198B6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345644AbiEDHxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345753AbiEDHxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:53:42 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8167F13F6D
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:50:07 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 89FCE3200C7;
        Wed,  4 May 2022 08:50:06 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nm9lu-0003S5-Ar; Wed, 04 May 2022 08:50:06 +0100
Subject: [PATCH net-next v3 02/13] sfc: Move Siena specific files
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 04 May 2022 08:50:06 +0100
Message-ID: <165165060603.13116.4143066060368758669.stgit@palantir17.mph.net>
In-Reply-To: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Habets <martinh@xilinx.com>

Files are only moved, no changes are made.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/farch.c       |    0 
 drivers/net/ethernet/sfc/siena/siena.c       |    0 
 drivers/net/ethernet/sfc/siena/siena_sriov.c |    0 
 drivers/net/ethernet/sfc/siena/siena_sriov.h |    0 
 4 files changed, 0 insertions(+), 0 deletions(-)
 rename drivers/net/ethernet/sfc/{farch.c => siena/farch.c} (100%)
 rename drivers/net/ethernet/sfc/{siena.c => siena/siena.c} (100%)
 rename drivers/net/ethernet/sfc/{siena_sriov.c => siena/siena_sriov.c} (100%)
 rename drivers/net/ethernet/sfc/{siena_sriov.h => siena/siena_sriov.h} (100%)

diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
similarity index 100%
rename from drivers/net/ethernet/sfc/farch.c
rename to drivers/net/ethernet/sfc/siena/farch.c
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
similarity index 100%
rename from drivers/net/ethernet/sfc/siena.c
rename to drivers/net/ethernet/sfc/siena/siena.c
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena/siena_sriov.c
similarity index 100%
rename from drivers/net/ethernet/sfc/siena_sriov.c
rename to drivers/net/ethernet/sfc/siena/siena_sriov.c
diff --git a/drivers/net/ethernet/sfc/siena_sriov.h b/drivers/net/ethernet/sfc/siena/siena_sriov.h
similarity index 100%
rename from drivers/net/ethernet/sfc/siena_sriov.h
rename to drivers/net/ethernet/sfc/siena/siena_sriov.h

