Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8522129E0D1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgJ1WDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:03:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57174 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729488AbgJ1WBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:01:49 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0559E2288E4
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:44:37 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9652A20089;
        Wed, 28 Oct 2020 20:44:36 +0000 (UTC)
Received: from us4-mdac16-10.at1.mdlocal (unknown [10.110.49.192])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 92AC0800A7;
        Wed, 28 Oct 2020 20:44:36 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.6])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2E1FF10007B;
        Wed, 28 Oct 2020 20:44:36 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E8FDDB00060;
        Wed, 28 Oct 2020 20:44:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct
 2020 20:44:30 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 4/4] sfc: advertise our vlan features
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Message-ID: <8540750f-8f45-4da3-dfff-20c9f2aa462b@solarflare.com>
Date:   Wed, 28 Oct 2020 20:44:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25752.003
X-TM-AS-Result: No-0.624900-8.000000-10
X-TMASE-MatchedRID: y1CwnZAYecWioKUtUDGXZbsHVDDM5xAP1JP9NndNOkUHZBaLwEXlKGlF
        7OhYLlct4Bf6QB/uLAvGa98vmkaV6aPaD2n4RUYdx5sgyUhLCNtSs5A6KXpn7K//6X0io9HxqXA
        FsS+trPLi8zVgXoAltkWL4rBlm20vZiFQvkZhFu1q8/xv2Um1avoLR4+zsDTtHtexZ1+/9PlqpJ
        xMo61PmaCu9qJ8Vgmxetr7T+1dPyW5XSMT7d8Gn8v+HOftVjBFJSw+AW7He+Muiuh2UtqTyFC2R
        4+gRM4buBlYF8GOBed85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwvJjiAfi1XK9tOD+u6c
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.624900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25752.003
X-MDID: 1603917876-79yKmYccOE5M
X-PPE-DISP: 1603917876;79yKmYccOE5M
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8a187a16ac89..cd93c5ffd45c 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1110,6 +1110,8 @@ static int ef100_probe_main(struct efx_nic *efx)
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
+	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
+				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
