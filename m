Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8520F43B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387516AbgF3MN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:13:57 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54944 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387472AbgF3MN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:13:56 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A983920095;
        Tue, 30 Jun 2020 12:13:55 +0000 (UTC)
Received: from us4-mdac16-5.at1.mdlocal (unknown [10.110.49.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A7A87600A1;
        Tue, 30 Jun 2020 12:13:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 59C72220054;
        Tue, 30 Jun 2020 12:13:55 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 20E6BB80069;
        Tue, 30 Jun 2020 12:13:55 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:13:50 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 10/14] sfc: move definition of
 EFX_MC_STATS_GENERATION_INVALID
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <3a9b1a37-5d8e-e961-69a6-ab95391a5cdc@solarflare.com>
Date:   Tue, 30 Jun 2020 13:13:47 +0100
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
X-TM-AS-Result: No-3.355200-8.000000-10
X-TMASE-MatchedRID: ST7yNXgihVeh9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKCzy
        bVqWyY2NBEh1ZoXZblD8b3magyi4tvvlwQ3r+q9MydRP56yRRA9n+sA9+u1YLazk9k6NqjPurW4
        1+BBqq+8AyjWkMgOFnZGTpe1iiCJq71zr0FZRMbALbigRnpKlKZvjAepGmdoO5AGmTNaKEjSg2T
        M46Fm3CTo10eJ1/JkLU/Wb/JzFk+Q/otwdKkADAxyN+Qsm6+/g42Kr9vVjcVgdPys4MZ8PC6coU
        aly6B6o7X0NUj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+XDa0xNKDTHvg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.355200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519235-Dsu328GgnKpf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saves a whole #include from nic.c.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_port_common.h | 2 --
 drivers/net/ethernet/sfc/nic.c              | 1 -
 drivers/net/ethernet/sfc/nic_common.h       | 2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.h b/drivers/net/ethernet/sfc/mcdi_port_common.h
index f6f81cbeb07e..9dbeee83266f 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.h
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.h
@@ -28,8 +28,6 @@ struct efx_mcdi_phy_data {
 	u32 forced_cap;
 };
 
-#define EFX_MC_STATS_GENERATION_INVALID ((__force __le64)(-1))
-
 int efx_mcdi_get_phy_cfg(struct efx_nic *efx, struct efx_mcdi_phy_data *cfg);
 void efx_link_set_advertising(struct efx_nic *efx,
 			      const unsigned long *advertising);
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index ac6630510324..d994d136bb03 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -20,7 +20,6 @@
 #include "farch_regs.h"
 #include "io.h"
 #include "workarounds.h"
-#include "mcdi_port_common.h"
 #include "mcdi_pcol.h"
 
 /**************************************************************************
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index 8d0d163afc0d..197ecac5e005 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -263,6 +263,8 @@ void efx_nic_free_buffer(struct efx_nic *efx, struct efx_buffer *buffer);
 size_t efx_nic_get_regs_len(struct efx_nic *efx);
 void efx_nic_get_regs(struct efx_nic *efx, void *buf);
 
+#define EFX_MC_STATS_GENERATION_INVALID ((__force __le64)(-1))
+
 size_t efx_nic_describe_stats(const struct efx_hw_stat_desc *desc, size_t count,
 			      const unsigned long *mask, u8 *names);
 int efx_nic_copy_stats(struct efx_nic *efx, __le64 *dest);

