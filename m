Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94231CF5A1
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgELNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:25:08 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59680 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729519AbgELNZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:25:08 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0642B20086;
        Tue, 12 May 2020 13:25:07 +0000 (UTC)
Received: from us4-mdac16-41.at1.mdlocal (unknown [10.110.48.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0361D800A3;
        Tue, 12 May 2020 13:25:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.106])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 703D6100076;
        Tue, 12 May 2020 13:25:06 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2EE19B40066;
        Tue, 12 May 2020 13:25:06 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 May
 2020 14:25:01 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/2] sfc: siena_check_caps() can be static
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
Message-ID: <76c9c4b6-2473-ebd5-6430-ff65289efbe5@solarflare.com>
Date:   Tue, 12 May 2020 14:24:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fccfbce7-d9d8-97ad-991a-95f9333121d6@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25414.003
X-TM-AS-Result: No-1.048000-8.000000-10
X-TMASE-MatchedRID: dydEoroocbOB/JMJRMiHSsl1v6OaRGskHem4B9zINcksfhDEe5y3Hlsl
        /aNichJzmlH+e8xTf5SE4RYTsVwIF6H2g9syPs888Kg68su2wyHuo8ooMQqOsgdkFovAReUoaUX
        s6FguVy3gF/pAH+4sC4dYfXjkc9hokrMo37I6x/40OtJVkKBtK30tCKdnhB58vqq8s2MNhPAir3
        kOMJmHTBQabjOuIvShC24oEZ6SpSlR8RAUGq/SZ8RJQkrbu2AvCHt1+3/6eOvEAeOaG8SgQHWLc
        mn5doeaOyvwnhbA9HlJKkOqF3gCljOdL7NwJqZGGIKjMlBToug/wV/BL75dLO19DVI++epMmpVd
        ReMayPPYX68FmWzgr7JqpzuBzRvl6HGh23KtyVHAvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.048000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25414.003
X-MDID: 1589289906-2FWci5tj6tBD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/siena.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index d8b052979b1b..891e9fb6abec 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -948,8 +948,8 @@ static int siena_mtd_probe(struct efx_nic *efx)
 
 #endif /* CONFIG_SFC_MTD */
 
-unsigned int siena_check_caps(const struct efx_nic *efx,
-			      u8 flag, u32 offset)
+static unsigned int siena_check_caps(const struct efx_nic *efx,
+				     u8 flag, u32 offset)
 {
 	/* Siena did not support MC_CMD_GET_CAPABILITIES */
 	return 0;
