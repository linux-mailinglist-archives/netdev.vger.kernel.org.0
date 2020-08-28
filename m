Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8963256004
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgH1Rut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 13:50:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40476 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgH1Rus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 13:50:48 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9D6FC200CE;
        Fri, 28 Aug 2020 17:50:47 +0000 (UTC)
Received: from us4-mdac16-56.at1.mdlocal (unknown [10.110.48.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9A7C2600A1;
        Fri, 28 Aug 2020 17:50:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.109])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 32BC322004D;
        Fri, 28 Aug 2020 17:50:47 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F08E8B4006C;
        Fri, 28 Aug 2020 17:50:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 18:50:42 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/4] sfc: fix kernel-doc on struct efx_loopback_state
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Message-ID: <241f853e-18b2-dd05-0014-da85dca96161@solarflare.com>
Date:   Fri, 28 Aug 2020 18:50:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25630.005
X-TM-AS-Result: No-0.502300-8.000000-10
X-TMASE-MatchedRID: hCyiMYGLLbQi0EZLhSHnBnYZxYoZm58FNqXrpjqTY7TIPbn2oQhptciT
        Wug2C4DNl1M7KT9/aqDtvB9G5xyZ8CxppiUy9o4cA9lly13c/gHYuVu0X/rOkFeIuu+Gkot8WxL
        E1np6YzWcKXDDjW+FLNQf9nCQysJtDPIzF4wRfrA5f9Xw/xqKXXJnzNw42kCx2bNx1HEv7HAqtq
        5d3cxkNdq4vodbUC7Q6GPZ+lh2DDJ1zmBkdQJaqAyYgFpPKxWCo1aSUwZwQHdj2XEzmcWO0rGAM
        bNqQzlN491LYNxxeMVr3rvkJfdIntn/gt2Uwj9TQ4MNjn8G4SyjGuTpDaYh5In7C/ugmOEZV005
        2cEvC/nvdCUIFuasqw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.502300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25630.005
X-MDID: 1598637047-zQt25EetQjVG
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Missing 'struct' keyword caused "cannot understand function prototype"
 warnings.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index e71d6d37a317..34b9c7d50c4e 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -67,7 +67,7 @@ static const char *const efx_interrupt_mode_names[] = {
 	STRING_TABLE_LOOKUP(efx->interrupt_mode, efx_interrupt_mode)
 
 /**
- * efx_loopback_state - persistent state during a loopback selftest
+ * struct efx_loopback_state - persistent state during a loopback selftest
  * @flush:		Drop all packets in efx_loopback_rx_packet
  * @packet_count:	Number of packets being used in this test
  * @skbs:		An array of skbs transmitted

