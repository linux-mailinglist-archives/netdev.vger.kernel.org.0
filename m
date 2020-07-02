Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05297212994
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgGBQcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:32:14 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58412 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726649AbgGBQcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:32:13 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3742C600DD;
        Thu,  2 Jul 2020 16:32:13 +0000 (UTC)
Received: from us4-mdac16-18.ut7.mdlocal (unknown [10.7.65.242])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 369252009A;
        Thu,  2 Jul 2020 16:32:13 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AD5081C0059;
        Thu,  2 Jul 2020 16:32:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5BADA4C0078;
        Thu,  2 Jul 2020 16:32:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:32:07 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 13/16] sfc_ef100: add EF100 to NIC-revision
 enumeration
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <7b27d23f-8b56-f8bc-017f-ebfc9f39ab46@solarflare.com>
Date:   Thu, 2 Jul 2020 17:32:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-1.629600-8.000000-10
X-TMASE-MatchedRID: W4G0h3GCi0mh9oPbMj7PPPCoOvLLtsMhS1zwNuiBtITny/syo1tPD+9Y
        Jb+A/hFwlpKpNiL4LlrqL6ZFxzlBV01+zyfzlN7ygxsfzkNRlfIRTILTyAA+ovoLR4+zsDTtjoc
        zmuoPCq3gcE/MxhgHdepUp6PCCxl0DzFQni5BLXSCFFLpMC9bKLw3iQnjhhxqYbfKpeYQnRWC+Z
        iF+tmLZFQznekpgwp/w7SgN8IAh3MXxY6mau8LG3IJh4dBcU42f4hpTpoBF9JqxGCSzFD9MrEvn
        lrhVRa7ZyMWcibO/JI=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.629600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707533-BV4RappIOD_G
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/nic_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index 813f288ab3fe..e04b6817cde3 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -21,6 +21,7 @@ enum {
 	 */
 	EFX_REV_SIENA_A0 = 3,
 	EFX_REV_HUNT_A0 = 4,
+	EFX_REV_EF100 = 5,
 };
 
 static inline int efx_nic_rev(struct efx_nic *efx)

