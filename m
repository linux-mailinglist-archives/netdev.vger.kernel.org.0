Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2A42902
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439752AbfFLO1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439746AbfFLO12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 10:27:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C25215EA;
        Wed, 12 Jun 2019 14:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560349647;
        bh=WWi37athFr25A4d11a9t1MYm4wJvHentMLgpj3xbWw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYUqqiVvVnJF6v9zPZNW1PaE2enoHTfXpgBNfB5yUDsu16O9FUJwDkqgw8kuGbvEo
         vexJ1Dgox5Tq16n7HVsaSu4p052NBCTinf3IBAyMwIgysczG46jqTnvqqjnTiAOMpD
         zA3qRR35awInvPZ08HXSl8CHVklTTmrtjMsNqR4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Erel Geron <erelx.geron@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/5] iwlwifi: mvm: remove unused .remove_sta_debugfs callback
Date:   Wed, 12 Jun 2019 16:26:57 +0200
Message-Id: <20190612142658.12792-4-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190612142658.12792-1-gregkh@linuxfoundation.org>
References: <20190612142658.12792-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .remove_sta_debugfs callback was not doing anything in this driver,
so remove it as it is not needed.

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sara Sharon <sara.sharon@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Erel Geron <erelx.geron@intel.com>
Cc: Avraham Stern <avraham.stern@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index c182821ab22b..15c1f825b749 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4108,10 +4108,6 @@ static void rs_drv_add_sta_debugfs(void *mvm, void *priv_sta,
 
 	MVM_DEBUGFS_ADD_FILE_RS(ss_force, dir, 0600);
 }
-
-void rs_remove_sta_debugfs(void *mvm, void *mvm_sta)
-{
-}
 #endif
 
 /*
@@ -4139,7 +4135,6 @@ static const struct rate_control_ops rs_mvm_ops_drv = {
 	.rate_update = rs_drv_rate_update,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.add_sta_debugfs = rs_drv_add_sta_debugfs,
-	.remove_sta_debugfs = rs_remove_sta_debugfs,
 #endif
 	.capa = RATE_CTRL_CAPA_VHT_EXT_NSS_BW,
 };
-- 
2.22.0

