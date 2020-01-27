Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898B514A2E5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgA0LT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:19:27 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:57542 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729043AbgA0LT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:19:27 -0500
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 728922E3A4E
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 11:12:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 89A5D100059;
        Mon, 27 Jan 2020 11:12:09 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 27 Jan 2020 11:12:03 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH v3 net-next 0/3] sfc: refactor mcdi filtering code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
Message-ID: <62445381-c3f7-1f10-897f-4990da13aa0b@solarflare.com>
Date:   Mon, 27 Jan 2020 11:12:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25192.003
X-TM-AS-Result: No-4.747700-8.000000-10
X-TMASE-MatchedRID: IvJ9QewkpYA5NXlWWXBFjpxVZzZr7+O7DmTV5r5yWnp+SLLtNOiBhma9
        C4ZFZ5AaEWMioiewS9fPz/ErJpwBWN4bgXBxaoBLA9lly13c/gF/7iVTXtdMVQfxTM57BPHDocM
        xOHJmdvPxdUjf0kJGdKN80BVgAlEC8jVhulLX5q+eAiCmPx4NwLTrdaH1ZWqC3TrdyO4a2u36C0
        ePs7A07QkL5VmLaBARZFDJ03kSPGLxz8wx4LHiF4ybqhebtPQj6zEzE9kKdtC7PbtheoUwxbEt5
        k7OorqDJ/efAmyTTxSY/m/oeUo3c/l9sNoiJHCXfObqGK9JplminaV/dK0aEhK3Vty8oXtkps2Y
        VnJpfNg=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.747700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25192.003
X-MDID: 1580123530-iS0rEGgMU7Yt
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Splitting final bits of the driver code into different files, which
will later be used in another driver for a new product.

This is a continuation to my previous patch series. (three of them)
Refactoring will be concluded with this series, for now.

As instructed, split the renaming and moving into different patches.
Removed stray spaces before tabs... twice.
Minor refactoring was done with the renaming, as explained in the
first patch.

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

