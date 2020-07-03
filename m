Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D556213C97
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGCPc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:32:26 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:34378 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbgGCPcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:32:25 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BDF5120081;
        Fri,  3 Jul 2020 15:32:24 +0000 (UTC)
Received: from us4-mdac16-13.at1.mdlocal (unknown [10.110.49.195])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BC6C98009B;
        Fri,  3 Jul 2020 15:32:24 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5733840072;
        Fri,  3 Jul 2020 15:32:24 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1F4E814006D;
        Fri,  3 Jul 2020 15:32:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:32:18 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 05/15] sfc_ef100: PHY probe stub
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Message-ID: <eadbeeca-d25f-d50a-54e3-720e30ca3dfa@solarflare.com>
Date:   Fri, 3 Jul 2020 16:32:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-3.356300-8.000000-10
X-TMASE-MatchedRID: pm5esiOnALUczEPrqnY8wqOknopQLzTu9oVAKMBioqdpsnGGIgWMmer1
        /diGd3x+QOaAfcvrs37++3i1gpyN4kASN/wlEVscuwdUMMznEA/Uk/02d006RQdkFovAReUoaUX
        s6FguVy384sEICMMV1ZKcg2CYAgIT/MSiuOz98mXIFawn8e0/q5UQEUT9GpKNmyiLZetSf8nJ4y
        0wP1A6AEl4W8WVUOR/joczmuoPCq096pAK7wX9Q61B1ZtfcxHZeIWjnTZKGg9ZaGnZUO2gXJb7d
        cx+c8bP8awp7Rel+Cti/+9Hf9JLrPWd8Slk6V389mJh7JBakrsXxY6mau8LG3IJh4dBcU42f4hp
        TpoBF9JqxGCSzFD9Mq9DVtyhkQKh
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.356300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790344-AfxN7zR4ko9M
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't actually do the MCDI to probe it fully until we have working
 MCDI, which comes later, but we need efx->phy_data to be allocated so
 that when we get MCDI events the link-state change handler doesn't
 NULL-dereference.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 772cde009472..27e00b003039 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -80,6 +80,16 @@ static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int ef100_phy_probe(struct efx_nic *efx)
+{
+	/* stub: allocate the phy_data */
+	efx->phy_data = kzalloc(sizeof(struct efx_mcdi_phy_data), GFP_KERNEL);
+	if (!efx->phy_data)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*	Other
  */
 
@@ -196,6 +206,10 @@ static int ef100_probe_main(struct efx_nic *efx)
 
 	efx->max_vis = EF100_MAX_VIS;
 
+	rc = ef100_phy_probe(efx);
+	if (rc)
+		goto fail;
+
 	rc = efx_init_channels(efx);
 	if (rc)
 		goto fail;

