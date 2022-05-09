Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97BE520136
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbiEIPfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiEIPfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:35:15 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84699631B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:31:19 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 088F43200F2;
        Mon,  9 May 2022 16:31:19 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1no5Ly-0001PU-PN; Mon, 09 May 2022 16:31:18 +0100
Subject: [PATCH net-next v4 01/11] sfc: Move Siena specific files
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 09 May 2022 16:31:18 +0100
Message-ID: <165211027846.5289.5797037308376337970.stgit@palantir17.mph.net>
In-Reply-To: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
References: <165211018297.5289.9658523545298485394.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
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

