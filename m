Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269B825CC61
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbgICVfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:35:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34466 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728037AbgICVfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:35:47 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 330D860089;
        Thu,  3 Sep 2020 21:35:47 +0000 (UTC)
Received: from us4-mdac16-11.ut7.mdlocal (unknown [10.7.65.208])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 304AA80094;
        Thu,  3 Sep 2020 21:35:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.176])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C083428004D;
        Thu,  3 Sep 2020 21:35:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7B45C68008A;
        Thu,  3 Sep 2020 21:35:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep 2020
 22:35:42 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 6/6] sfc: remove efx_tx_queue_partner
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Message-ID: <863040a8-002b-4afc-6db2-638eed7f292c@solarflare.com>
Date:   Thu, 3 Sep 2020 22:35:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25642.007
X-TM-AS-Result: No-1.764400-8.000000-10
X-TMASE-MatchedRID: QifGWEak2+NkukQunGNAEaiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrEAc
        6DyoS2rIj6kCfX0Edc7U1g4lO1dF7RXQZ3CP5OysMiMrbc70Pfcr9gVlOIN/6p+4ziUPq4LxwDS
        YCfpWO53i8zVgXoAltkWL4rBlm20vjaPj0W1qn0SujVRFkkVsm06jPCV3lQD12/8kgG7wqjZK/e
        jkZlThALKLwL/neQSOexBjPccZ1CTrTIWQzj4gcuWy4yH95JvdaY0lwVEsJaM7eLqX+4w4O5BEc
        rkRxYJ4UjKnO1KVKKwSkbDwum07zqq0MV8nSMBvkLxsYTGf9c0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.764400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25642.007
X-MDID: 1599168947-mRehQqujrnaX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All users of this function are now gone.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/nic_common.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index 3f88c6444fa1..82271f0b8627 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -75,16 +75,6 @@ static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue, unsigned i
 	return ((empty_read_count ^ write_count) & ~EFX_EMPTY_COUNT_VALID) == 0;
 }
 
-/* Get partner of a TX queue, seen as part of the same net core queue */
-/* XXX is this a thing on EF100? */
-static inline struct efx_tx_queue *efx_tx_queue_partner(struct efx_tx_queue *tx_queue)
-{
-	if (tx_queue->label & EFX_TXQ_TYPE_OFFLOAD)
-		return tx_queue - EFX_TXQ_TYPE_OFFLOAD;
-	else
-		return tx_queue + EFX_TXQ_TYPE_OFFLOAD;
-}
-
 int efx_enqueue_skb_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			bool *data_mapped);
 
