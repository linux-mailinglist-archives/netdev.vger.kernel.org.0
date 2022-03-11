Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E5B4D5C8E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244083AbiCKHlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiCKHlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137881B756B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC59161DFF
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00A4C340F4;
        Fri, 11 Mar 2022 07:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984441;
        bh=VZay7ixNWtSsQ2ZJxkRQKwejFn7VXcdeFjuZHrr/7q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IP5Zh3EOxuku1ktmcyD4JKFBOf/9ytFTAE4mWuI8oIaOJQD9Gg0p/bITJeITJ8V2s
         t29ZmoIVGMed5XQqKA9IPfttY0Pgn/WdNaw9qDpk06V2lIwc9feCl4zYr+U4epeuDq
         xbcRUefm88cm4OLCOhPX14bnET9eVDQoxqudTz4nVYGrOMCd55O8IIyf178Qbi5pN9
         jGN0cJqmbBiYgvI1JbHfi1KXU52wvFSD/nqYHwLUW5WBwV+RmV5IwIRpw7TggfR+Vw
         8BaEremlFgPEtDRjOTWk0mpKv5tDExowEWI8Rwp14orjtw1h/0adJ1lAluMxOeaje2
         Nc/1fFSAXdOUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx4: Delete useless moduleparam include
Date:   Thu, 10 Mar 2022 23:40:17 -0800
Message-Id: <20220311074031.645168-2-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove inclusion of not used moduleparam.h.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 817f4154b86d..f777151d226f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -42,7 +42,6 @@
 #include <linux/tcp.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/moduleparam.h>
 #include <linux/indirect_call_wrapper.h>
 
 #include "mlx4_en.h"
-- 
2.35.1

