Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9601335CC04
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244568AbhDLQ0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243509AbhDLQYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC466135F;
        Mon, 12 Apr 2021 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244671;
        bh=OBNez7pe5st2L7+wrpz8FhsHh9EY6cWit9Q/8CozrB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EehWKkbcscUNLN6gzgtHCorQre4mV8OdPuOYCRcIKNABPZvX7dfZ4JoQ7Zcm/hntE
         DoSLt6wcjRG/uSitrNkApVOab7twpziEvUt7ZLv2+8TY5EIT3JB04kiARSeeA/VHN2
         5ElKowH2NbIf1rgI5u5Xlrq+VTM7dc8dpSchv3fP/oeuf6mdfaVUSyESe17APBsFkI
         587vof2QTY7g2Qy4wjtCmzl9ilDqeya5B3/qHQebD8jBo2tCSaDuBQh+i1HWd4XZ99
         jZfzmj1XyAcPQPNjD40tp8MHZzsS4wLm+7z+WjP8guidf8Rud8KTE3CyVGK8+Chg+C
         o1TjHakaB/BtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/46] iwlwifi: add support for Qu with AX201 device
Date:   Mon, 12 Apr 2021 12:23:38 -0400
Message-Id: <20210412162401.314035-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Chen <matt.chen@intel.com>

[ Upstream commit 97195d3cad852063208a1cd4f4d073459547a415 ]

Add this specific Samsung AX201 sku to driver so it can be
detected and initialized successfully.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210326125611.30b622037714.Id9fd709cf1c8261c097bbfd7453f6476077dcafc@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fa32f9045c0c..500fdb0b6c42 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -684,6 +684,7 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x4DF0, 0x1652, killer1650i_2ax_cfg_qu_b0_hr_b0, NULL),
 	IWL_DEV_INFO(0x4DF0, 0x2074, iwl_ax201_cfg_qu_hr, NULL),
 	IWL_DEV_INFO(0x4DF0, 0x4070, iwl_ax201_cfg_qu_hr, NULL),
+	IWL_DEV_INFO(0x4DF0, 0x6074, iwl_ax201_cfg_qu_hr, NULL),
 
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_PU, IWL_CFG_ANY,
-- 
2.30.2

