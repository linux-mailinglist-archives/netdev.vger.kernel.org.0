Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA416148C33
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 17:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbgAXQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 11:33:31 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35008 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387551AbgAXQdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 11:33:31 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 626B37800CA;
        Fri, 24 Jan 2020 16:33:29 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 24 Jan 2020 16:33:24 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH v2 net-next 0/3] sfc: refactor mcdi filtering code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
Message-ID: <bd446796-af44-148d-5cc2-23b0cd770494@solarflare.com>
Date:   Fri, 24 Jan 2020 16:33:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25186.003
X-TM-AS-Result: No-4.332400-8.000000-10
X-TMASE-MatchedRID: MLP7otFihIY5NXlWWXBFjpxVZzZr7+O7DmTV5r5yWnp+SLLtNOiBhma9
        C4ZFZ5AaEWMioiewS9fPz/ErJpwBWKJ7FHB/koSEP0HVIeixJdAweLVh3LZYSGMunwKby/AXCh5
        FGEJlYgHiutOUh/OzeuxsL9XDoOGTTX7PJ/OU3vK9oxGQAU8pjd0H8LFZNFG76sBnwpOylLPtg4
        6hlQzOx0gGShmGcifozuBmWFrJUAZ9VOYso45z3/Ug3lKQ8hk+/Ss+k+rK6r2QODeQS5UqfCk5v
        P8ZV6U/3N/YAgpV+7hazAigVxdXeiNlTYIDFiQj+C4IK5rEYL08DQfgROz55X7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.332400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25186.003
X-MDID: 1579883610-3r-E0YkfSGyo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Splitting final bits of the driver code into different files, which
will later be used in another driver for a new product.

This is a continuation to my previous patch series. (three of them)
Refactoring will be concluded with this series, for now.

As instructed, split the renaming and moving into different patches.
Minor refactoring was done with the renaming, as explained in the
patch.

Alexandru-Mihai Maftei (3):
  sfc: rename mcdi filtering functions/structs
  sfc: create header for mcdi filtering code
  sfc: move mcdi filtering code

 drivers/net/ethernet/sfc/Makefile       |    2 +-
 drivers/net/ethernet/sfc/ef10.c         | 2476 +----------------------
 drivers/net/ethernet/sfc/mcdi_filters.c | 2270 +++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi_filters.h |  159 ++
 4 files changed, 2505 insertions(+), 2402 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_filters.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_filters.h

-- 
2.20.1

