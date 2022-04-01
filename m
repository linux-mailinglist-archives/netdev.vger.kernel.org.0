Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366324EF143
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245027AbiDAOhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347599AbiDAOdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B982527A4;
        Fri,  1 Apr 2022 07:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6263EB8250F;
        Fri,  1 Apr 2022 14:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C6CC340EE;
        Fri,  1 Apr 2022 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823404;
        bh=2gEPtOAuUfvGBEqF0VRavifXUyCfId4Cs7T3tsXowZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngPkhhR0cutA9L+7z4RS946R89Jh0Jn5bThT249f9JMaSJ7jKH+tYiPGv5j/DH1+t
         hRWRsto1mGuneMUwSHRmiVaBoRhGqVW5nhrPlzI4iuYoR+4xcs8uzk2w0hHQimIKdB
         pIXr52EXmRrmp/Wead3/GjBm8fIc8k4xfss21mFzRptUP6Hr1o+MH+R2xyroBgqzDU
         2oM+IO3o0eIZmKyyCALxEFRvBqpiAYPRDle6C/dCz3LhIfSSNJjxfuwAyoJsaHSZZy
         5hpyw1B2XJ7ELmtTYKD/kE3qll3LvUYq9/9x7NpbxyRDJtW6IEuFSbibUtMIYpPJIl
         Wfpc+h2EZ6JiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        mukesh.sisodiya@intel.com, johannes.berg@intel.com,
        mordechay.goodstein@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 080/149] iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val
Date:   Fri,  1 Apr 2022 10:24:27 -0400
Message-Id: <20220401142536.1948161-80-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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
index 456b7eaac570..061fe6cc6cf5 100644
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
@@ -249,11 +249,10 @@ struct iwl_fw_ini_hcmd_tlv {
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

