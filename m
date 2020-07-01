Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76CC210E1E
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgGAOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:54:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51750 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731209AbgGAOy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:54:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 4D49F600D5;
        Wed,  1 Jul 2020 14:54:58 +0000 (UTC)
Received: from us4-mdac16-31.ut7.mdlocal (unknown [10.7.66.142])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 48F172009B;
        Wed,  1 Jul 2020 14:54:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B3CFD220059;
        Wed,  1 Jul 2020 14:54:57 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6584A8006C;
        Wed,  1 Jul 2020 14:54:57 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:54:52 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 11/15] sfc: initialise RSS context ID to 'no RSS
 context' in efx_init_struct()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <a9b74552-e991-1977-d06a-1e349b939fea@solarflare.com>
Date:   Wed, 1 Jul 2020 15:54:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-4.879400-8.000000-10
X-TMASE-MatchedRID: yZFdAOAQ4c72up/bgDqTK7sHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc4mQHxxqFX9+fBN2K/R+Xphx64UvlSkg3EKJM4okvH5Xou6fTXJM2TrQKt
        uC5RZzsGhbs7JB/QJ2spNnMYIlCQ4MaLWVF38C5R2GcWKGZufBV8b0UDxic9DS/Qdg3rj6HG+mF
        UWJD5GAoWcac0NmIsskhQWpGCYR9QM8jMXjBF+sDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0Z49aLkbM/dY4WY649yxXlu4j7UeAlUl485sPJUzGlGAeve4yuPGLgGx2tJk/gt87y9WS2
        cgq/Ljzi2CYMRSEH/fcT3S0Jg5gaGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtno6XmhFfKEURWXGv
        UUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.879400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615298-BrJG6MWOdxBK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously this was only happening in ef10-specific code.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 2 --
 drivers/net/ethernet/sfc/efx_common.c | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 788a562212b1..b29b5f34fe9b 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -552,8 +552,6 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	}
 	nic_data->warm_boot_count = rc;
 
-	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
-
 	/* In case we're recovering from a crash (kexec), we want to
 	 * cancel any outstanding request by the previous user of this
 	 * function.  We send a special message using the least
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index c84123456c01..5667694c6514 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1017,6 +1017,7 @@ int efx_init_struct(struct efx_nic *efx,
 	efx->rx_packet_ts_offset =
 		efx->type->rx_ts_offset - efx->type->rx_prefix_size;
 	INIT_LIST_HEAD(&efx->rss_context.list);
+	efx->rss_context.context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
 	mutex_init(&efx->rss_lock);
 	efx->vport_id = EVB_PORT_ID_ASSIGNED;
 	spin_lock_init(&efx->stats_lock);

