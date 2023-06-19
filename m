Return-Path: <netdev+bounces-12010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7D5735AA0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F4691C20B81
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35BB3125B9;
	Mon, 19 Jun 2023 15:03:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293638BE5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:03:49 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285011717;
	Mon, 19 Jun 2023 08:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=jtZn+Odo3SVbWns3tC4PPQ3Za5Lh9ZzWlfEhD3PwZng=; t=1687187000; x=1688396600; 
	b=dhsjdpXlOizvwL4LUj4G39MWkuX0faI+covurjwTWxQo6Eyv6jhdpY971onHUQFDopn73D3ziOA
	2Wf2xWAoLJqELib8dob5eUXk0ZtfUioVnjN7ou5KzK8p8e8KhOiWuNFndUWitZZ7KUjf909+ZN/qT
	dIG9v96W4pJ2ahWCSF1n4F22bW8hjmnf4ZUos8JHrL3nL1zcBzK+HULJ5j0dUsweS4r4S0s16R8jM
	wK2CMV0VGvreXcbxEpwqptuNPsZApV0eHEi9KhuySml87wBjotePXe1WcEvEQ9r6blTzTzlx+pGnJ
	ArXWifdLagO+IcGs8sfNsJBxlBpqvnJhCkDA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1qBGOw-00BPC2-35;
	Mon, 19 Jun 2023 17:02:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Subject: [PATCH net] wifi: iwlwifi: pcie: Handle SO-F device for PCI id 0x7AF0
Date: Mon, 19 Jun 2023 17:02:34 +0200
Message-ID: <20230619150233.461290-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

Add support for AX1690i and AX1690s devices with
PCIE id 0x7AF0.

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Can you please apply this directly to net? Simple new device
ID that even should go to stable, but we're not going to send
another pull request.
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index dba112394838..79115eb1c285 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -548,6 +548,8 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x54F0, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 	IWL_DEV_INFO(0x7A70, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
 	IWL_DEV_INFO(0x7A70, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
+	IWL_DEV_INFO(0x7AF0, 0x1691, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690s_name),
+	IWL_DEV_INFO(0x7AF0, 0x1692, iwlax411_2ax_cfg_so_gf4_a0, iwl_ax411_killer_1690i_name),
 
 	IWL_DEV_INFO(0x271C, 0x0214, iwl9260_2ac_cfg, iwl9260_1_name),
 	IWL_DEV_INFO(0x7E40, 0x1691, iwl_cfg_ma_a0_gf4_a0, iwl_ax411_killer_1690s_name),
-- 
2.41.0


