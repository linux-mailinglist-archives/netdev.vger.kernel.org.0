Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1064512980
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbiD1CeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241420AbiD1CeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:34:08 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E959581EEC
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 19:30:55 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 2457E32010B;
        Thu, 28 Apr 2022 03:30:55 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1njtvi-0005Vw-UV; Thu, 28 Apr 2022 03:30:54 +0100
Subject: [PATCH net-next v2 02/13] sfc: Move Siena specific files
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Thu, 28 Apr 2022 03:30:54 +0100
Message-ID: <165111305464.21042.10137726622840445796.stgit@palantir17.mph.net>
In-Reply-To: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
References: <165111298464.21042.9988060027860048966.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
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

