Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6181E26685E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgIKSpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:45:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57074 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725803AbgIKSpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:45:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6821320100;
        Fri, 11 Sep 2020 18:45:04 +0000 (UTC)
Received: from us4-mdac16-18.at1.mdlocal (unknown [10.110.49.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 43573600CE;
        Fri, 11 Sep 2020 18:45:04 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.102])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CC2BD22007B;
        Fri, 11 Sep 2020 18:45:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 75FB06C0082;
        Fri, 11 Sep 2020 18:45:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 19:44:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/3] sfc: remove spurious unreachable return
 statement
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Message-ID: <e0ecaa35-5ddc-b38e-90f5-30a21a619d8e@solarflare.com>
Date:   Fri, 11 Sep 2020 19:44:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-3.827100-8.000000-10
X-TMASE-MatchedRID: Fppbnv0BOyiD/sxA0J0W+uIfK/Jd5eHmyeUl7aCTy8hjLp8Cm8vwFwoe
        RRhCZWIBI5Skl4cZDuybHAuQ1dUnuWJZXQNDzktSCWlWR223da5vV3/OnMClWg6QlBHhBZuwk0O
        Apl176jfi8zVgXoAltkWL4rBlm20vZiFQvkZhFu1q8/xv2Um1avoLR4+zsDTtKJvqFwff1PMiQ8
        QtuhtQ/bwJ4TOyoyqDjelCPx+043ftaH3MOrIWMGxgz80fmj1vABclduDpwx5umejYK1WQtu1dG
        BbvLXzc2MSEKn68xqx85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwvJjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.827100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599849904-z7OIWAWmvSZr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The statement above it already returns, so there is no way to get here.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 078c7ec2a70e..ef9c2e879499 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -27,7 +27,6 @@ int ef100_tx_probe(struct efx_tx_queue *tx_queue)
 				    (tx_queue->ptr_mask + 2) *
 				    sizeof(efx_oword_t),
 				    GFP_KERNEL);
-	return 0;
 }
 
 void ef100_tx_init(struct efx_tx_queue *tx_queue)

