Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE26B2253F9
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgGSUP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 16:15:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726582AbgGSUP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 16:15:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06JKFgdm017938;
        Sun, 19 Jul 2020 13:15:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=mmPjUSFdMND1ZpSzT0MvJ8Gk26aDdePDNpVRUQly/Lo=;
 b=a4fJGorxs31JmIFwy8e0MtBJ68SrN6GU/15l7LktXows4Ej6/Mg0z3k/5JBkUYrTZOh5
 cYAEOsj8ssItk6RFJH+rU0PvzrGnIhpsvwCWkKxXhvogihFughgPl8vvP4Qw346cQhFY
 YUnhZ2XHzjwAEsKLz7rnb5BL6DM9T0+hgBFVmNRGEb+Z6VdMc22OchAqNJo2xyq4avk8
 Zj3HIm41vvjf0hlxoNYZp3Kq2jAdVT6U/dC+sF3gylRGJvXtD8y1rsz4HCmln7Wh7q6p
 fMSPrSNxPJHRkZiiI2fOuJ0SDql/e5cM75AznMDMg26QjYXj1yYQdDzQl+dL/xRGtz+o Mw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkbf4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 19 Jul 2020 13:15:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 19 Jul
 2020 13:15:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 19 Jul 2020 13:15:50 -0700
Received: from NN-LT0049.marvell.com (NN-LT0049.marvell.com [10.193.54.6])
        by maili.marvell.com (Postfix) with ESMTP id E64B23F703F;
        Sun, 19 Jul 2020 13:15:45 -0700 (PDT)
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
        <QLogic-Storage-Upstream@marvell.com>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net-next 07/14] qede: format qede{,_vf}_ethtool_ops
Date:   Sun, 19 Jul 2020 23:14:46 +0300
Message-ID: <20200719201453.3648-8-alobakin@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200719201453.3648-1-alobakin@marvell.com>
References: <20200719201453.3648-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-19_04:2020-07-17,2020-07-19 signatures=0
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

