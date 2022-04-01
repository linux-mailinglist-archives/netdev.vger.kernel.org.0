Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5355E4EF2EA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347754AbiDAOvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349207AbiDAOpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97D829A541;
        Fri,  1 Apr 2022 07:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E9A060AAF;
        Fri,  1 Apr 2022 14:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813BAC2BBE4;
        Fri,  1 Apr 2022 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823734;
        bh=sXYWVK0lthYG0YtqGswx+v1n0pnOJ5A9MyQ31rH2NdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsYy+QWjE19YYSBJPB3t2+p+l0G17D1VjgUK4PiC20bz89PERFeGc79+YQEuXOZtr
         U+O2gQqLNpXzp1Yfjsw9lmwjQJjo1VpqvdRI7Cnpw7N1QXsvk38EcEFNQlKUuKov8P
         V9FqN2t0L6xcG5wlJC3bCGq+pZ3U2q0gwRbY0LpMqfj9/FItYCF2wYR6quu3hTcr2R
         Slvud9CCogaiHoKr9C7pGaP/MxToy9yLogdUmgUfxL+onCM4uqCax0yzVWqzyZtPm9
         MGbyfpPXifJmvHlGqOB535OlaJyZn9pzmQu7Do5PtkjBGRBDfQGQZ8X50am5vhUuJg
         7BvQXjsTsQp6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        mukesh.sisodiya@intel.com, johannes.berg@intel.com,
        mordechay.goodstein@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 055/109] iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val
Date:   Fri,  1 Apr 2022 10:32:02 -0400
Message-Id: <20220401143256.1950537-55-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 3009c797c4b3840495e8f48d8d07f48d2ddfed80 ]

There was a small copy and paste mistake in the doc declaration of
iwl_fw_ini_addr_val.  Fix it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220205112029.aeec71c397b3.I0ba3234419eb8c8c7512a2ca531a6dbb55046cf7@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 3988f5fea33a..6b2a2828cb83 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2018-2021 Intel Corporation
+ * Copyright (C) 2018-2022 Intel Corporation
  */
 #ifndef __iwl_fw_dbg_tlv_h__
 #define __iwl_fw_dbg_tlv_h__
@@ -244,11 +244,10 @@ struct iwl_fw_ini_hcmd_tlv {
 } __packed; /* FW_TLV_DEBUG_HCMD_API_S_VER_1 */
 
 /**
-* struct iwl_fw_ini_conf_tlv - preset configuration TLV
+* struct iwl_fw_ini_addr_val - Address and value to set it to
 *
 * @address: the base address
 * @value: value to set at address
-
 */
 struct iwl_fw_ini_addr_val {
 	__le32 address;
-- 
2.34.1

