Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3204A20F41B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733303AbgF3MDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:03:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45124 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729647AbgF3MDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:03:32 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6A1F46006F;
        Tue, 30 Jun 2020 12:03:31 +0000 (UTC)
Received: from us4-mdac16-62.ut7.mdlocal (unknown [10.7.66.61])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 68860800A4;
        Tue, 30 Jun 2020 12:03:31 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 086BF8005B;
        Tue, 30 Jun 2020 12:03:31 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A242FB40060;
        Tue, 30 Jun 2020 12:03:30 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:03:25 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 03/14] sfc: add missing licence info to
 mcdi_filters.c
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <e7068e0f-e0e4-3abb-3de1-ecb1ee874d51@solarflare.com>
Date:   Tue, 30 Jun 2020 13:03:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-7.718200-8.000000-10
X-TMASE-MatchedRID: QvGus8ISmXNsr21evzoLzeQoIU4rAATMeouvej40T4gd0WOKRkwsh3lo
        OvA4aBJJrdoLblq9S5oZhhkmdi0+GYH/9PEJqVb6yZHnIMmQ+Dh5ybkwtj/jvu+uPZ9E4AOJhGG
        v93k4VVJksaYFr1elzgTM3L6p7JLEoYAeIqRSPipNo8Hgr5FnYX0tCKdnhB58vqq8s2MNhPCZMP
        CnTMzfOiq2rl3dzGQ1cYLo134C0x0/sxWzYog+LQQ74tCT6bqDMK2U2Tn3MQov7aSy4fORGA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.718200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593518611-b9FUEDmTig06
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the licence notice and the SPDX tag were missing from this file.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 7b39a3aa3a1a..74ee06fe0996 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1,3 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2005-2018 Solarflare Communications Inc.
+ * Copyright 2019-2020 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
 #include "mcdi_filters.h"
 #include "mcdi.h"
 #include "nic.h"

