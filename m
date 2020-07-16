Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D592221F9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgGPL5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:57:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34820 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728225AbgGPL43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:56:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GBpeZ4032230;
        Thu, 16 Jul 2020 04:56:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=mmPjUSFdMND1ZpSzT0MvJ8Gk26aDdePDNpVRUQly/Lo=;
 b=yBc0snixXMqINNH0ZDN81OIn2hfgT2QI6vSxMkURlMVrUf+IWuHXMS8qZJeYZNrprwsu
 61D8VsT2oYirdRgme+/e9Rcw/ovrDFlJeIqH8sfQN1RkTfJ4KPSNc8yU8zkT9eILAsED
 I5DkT8xCcVHqgiAax1We0kIof0Cqv7DvYDo5VXZ2967cIXXb7y+jzzSnj4H6qtSVzhdD
 CpSktkLNY408mDQCNAPbQmCYT5WhdQLqxz3bE7CGUudPDfbFThoNmf3KWlYOOGMNJbol
 cJUAVuilmkKo33pNLcEti7D0EpkHMcIVjceBb/zM7NJLpHxfK3bdt4eCIIBFDohnpKiH cA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32ap7v81qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 16 Jul 2020 04:56:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 04:56:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 16 Jul 2020 04:56:07 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id AB0803F7041;
        Thu, 16 Jul 2020 04:56:03 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 07/13] qede: format qede{,_vf}_ethtool_ops
Date:   Thu, 16 Jul 2020 14:54:40 +0300
Message-ID: <20200716115446.994-8-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716115446.994-1-alobakin@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_05:2020-07-16,2020-07-16 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to adding new callbacks, format qede ethtool_ops structs to make
declarations more fancy and readable.

Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/qlogic/qede/qede_ethtool.c   | 137 +++++++++---------
 1 file changed, 68 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index f47167cfa382..f5851a6ae729 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -2059,78 +2059,77 @@ static int qede_get_dump_data(struct net_device *dev,
 }
 
 static const struct ethtool_ops qede_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
-	.get_link_ksettings = qede_get_link_ksettings,
-	.set_link_ksettings = qede_set_link_ksettings,
-	.get_drvinfo = qede_get_drvinfo,
-	.get_regs_len = qede_get_regs_len,
-	.get_regs = qede_get_regs,
-	.get_wol = qede_get_wol,
-	.set_wol = qede_set_wol,
-	.get_msglevel = qede_get_msglevel,
-	.set_msglevel = qede_set_msglevel,
-	.nway_reset = qede_nway_reset,
-	.get_link = qede_get_link,
-	.get_coalesce = qede_get_coalesce,
-	.set_coalesce = qede_set_coalesce,
-	.get_ringparam = qede_get_ringparam,
-	.set_ringparam = qede_set_ringparam,
-	.get_pauseparam = qede_get_pauseparam,
-	.set_pauseparam = qede_set_pauseparam,
-	.get_strings = qede_get_strings,
-	.set_phys_id = qede_set_phys_id,
-	.get_ethtool_stats = qede_get_ethtool_stats,
-	.get_priv_flags = qede_get_priv_flags,
-	.set_priv_flags = qede_set_priv_flags,
-	.get_sset_count = qede_get_sset_count,
-	.get_rxnfc = qede_get_rxnfc,
-	.set_rxnfc = qede_set_rxnfc,
-	.get_rxfh_indir_size = qede_get_rxfh_indir_size,
-	.get_rxfh_key_size = qede_get_rxfh_key_size,
-	.get_rxfh = qede_get_rxfh,
-	.set_rxfh = qede_set_rxfh,
-	.get_ts_info = qede_get_ts_info,
-	.get_channels = qede_get_channels,
-	.set_channels = qede_set_channels,
-	.self_test = qede_self_test,
-	.get_module_info = qede_get_module_info,
-	.get_module_eeprom = qede_get_module_eeprom,
-	.get_eee = qede_get_eee,
-	.set_eee = qede_set_eee,
-
-	.get_tunable = qede_get_tunable,
-	.set_tunable = qede_set_tunable,
-	.flash_device = qede_flash_device,
-	.get_dump_flag = qede_get_dump_flag,
-	.get_dump_data = qede_get_dump_data,
-	.set_dump = qede_set_dump,
+	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS,
+	.get_link_ksettings		= qede_get_link_ksettings,
+	.set_link_ksettings		= qede_set_link_ksettings,
+	.get_drvinfo			= qede_get_drvinfo,
+	.get_regs_len			= qede_get_regs_len,
+	.get_regs			= qede_get_regs,
+	.get_wol			= qede_get_wol,
+	.set_wol			= qede_set_wol,
+	.get_msglevel			= qede_get_msglevel,
+	.set_msglevel			= qede_set_msglevel,
+	.nway_reset			= qede_nway_reset,
+	.get_link			= qede_get_link,
+	.get_coalesce			= qede_get_coalesce,
+	.set_coalesce			= qede_set_coalesce,
+	.get_ringparam			= qede_get_ringparam,
+	.set_ringparam			= qede_set_ringparam,
+	.get_pauseparam			= qede_get_pauseparam,
+	.set_pauseparam			= qede_set_pauseparam,
+	.get_strings			= qede_get_strings,
+	.set_phys_id			= qede_set_phys_id,
+	.get_ethtool_stats		= qede_get_ethtool_stats,
+	.get_priv_flags			= qede_get_priv_flags,
+	.set_priv_flags			= qede_set_priv_flags,
+	.get_sset_count			= qede_get_sset_count,
+	.get_rxnfc			= qede_get_rxnfc,
+	.set_rxnfc			= qede_set_rxnfc,
+	.get_rxfh_indir_size		= qede_get_rxfh_indir_size,
+	.get_rxfh_key_size		= qede_get_rxfh_key_size,
+	.get_rxfh			= qede_get_rxfh,
+	.set_rxfh			= qede_set_rxfh,
+	.get_ts_info			= qede_get_ts_info,
+	.get_channels			= qede_get_channels,
+	.set_channels			= qede_set_channels,
+	.self_test			= qede_self_test,
+	.get_module_info		= qede_get_module_info,
+	.get_module_eeprom		= qede_get_module_eeprom,
+	.get_eee			= qede_get_eee,
+	.set_eee			= qede_set_eee,
+	.get_tunable			= qede_get_tunable,
+	.set_tunable			= qede_set_tunable,
+	.flash_device			= qede_flash_device,
+	.get_dump_flag			= qede_get_dump_flag,
+	.get_dump_data			= qede_get_dump_data,
+	.set_dump			= qede_set_dump,
 };
 
 static const struct ethtool_ops qede_vf_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
-	.get_link_ksettings = qede_get_link_ksettings,
-	.get_drvinfo = qede_get_drvinfo,
-	.get_msglevel = qede_get_msglevel,
-	.set_msglevel = qede_set_msglevel,
-	.get_link = qede_get_link,
-	.get_coalesce = qede_get_coalesce,
-	.set_coalesce = qede_set_coalesce,
-	.get_ringparam = qede_get_ringparam,
-	.set_ringparam = qede_set_ringparam,
-	.get_strings = qede_get_strings,
-	.get_ethtool_stats = qede_get_ethtool_stats,
-	.get_priv_flags = qede_get_priv_flags,
-	.get_sset_count = qede_get_sset_count,
-	.get_rxnfc = qede_get_rxnfc,
-	.set_rxnfc = qede_set_rxnfc,
-	.get_rxfh_indir_size = qede_get_rxfh_indir_size,
-	.get_rxfh_key_size = qede_get_rxfh_key_size,
-	.get_rxfh = qede_get_rxfh,
-	.set_rxfh = qede_set_rxfh,
-	.get_channels = qede_get_channels,
-	.set_channels = qede_set_channels,
-	.get_tunable = qede_get_tunable,
-	.set_tunable = qede_set_tunable,
+	.supported_coalesce_params	= ETHTOOL_COALESCE_USECS,
+	.get_link_ksettings		= qede_get_link_ksettings,
+	.get_drvinfo			= qede_get_drvinfo,
+	.get_msglevel			= qede_get_msglevel,
+	.set_msglevel			= qede_set_msglevel,
+	.get_link			= qede_get_link,
+	.get_coalesce			= qede_get_coalesce,
+	.set_coalesce			= qede_set_coalesce,
+	.get_ringparam			= qede_get_ringparam,
+	.set_ringparam			= qede_set_ringparam,
+	.get_strings			= qede_get_strings,
+	.get_ethtool_stats		= qede_get_ethtool_stats,
+	.get_priv_flags			= qede_get_priv_flags,
+	.get_sset_count			= qede_get_sset_count,
+	.get_rxnfc			= qede_get_rxnfc,
+	.set_rxnfc			= qede_set_rxnfc,
+	.get_rxfh_indir_size		= qede_get_rxfh_indir_size,
+	.get_rxfh_key_size		= qede_get_rxfh_key_size,
+	.get_rxfh			= qede_get_rxfh,
+	.set_rxfh			= qede_set_rxfh,
+	.get_channels			= qede_get_channels,
+	.set_channels			= qede_set_channels,
+	.get_tunable			= qede_get_tunable,
+	.set_tunable			= qede_set_tunable,
 };
 
 void qede_set_ethtool_ops(struct net_device *dev)
-- 
2.25.1

