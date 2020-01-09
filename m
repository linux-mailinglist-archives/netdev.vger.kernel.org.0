Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA1135CF8
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgAIPl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:41:57 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57274 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbgAIPl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:41:57 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E272640051;
        Thu,  9 Jan 2020 15:41:55 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:41:46 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 0/9] sfc: more code refactoring
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
Message-ID: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Date:   Thu, 9 Jan 2020 15:41:43 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25156.003
X-TM-AS-Result: No-9.657200-8.000000-10
X-TMASE-MatchedRID: w6IpHgwggqcIoZsIlwjKBrdHEv7sR/OwWw/S0HB7eoOOzyCsYRwNaXv6
        cG7t9uXqugV/3O5rmoIN1izHZ6vquDXfM+vmulo5Dko+EYiDQxG6hgVvSdGKo3S7//lqxurTNDU
        gttty4FUeEV8OSZueLZXxnaui/I3DofaD2zI+zzzwqDryy7bDIap2m4S4J4Zomvnco5r4a3OjxY
        yRBa/qJX3mXSdV7KK4mVLlQk0G3GcgBwKKRHe+r60JRtsLDRq0tE5HVvwA4csoxK/gHJ9/AO1mc
        lMkIERFS99Y/esFLZQ=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.657200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584516-1e3BlEEu2enY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Splitting more of the driver code into different files, which will
later be used in another driver for a new product.

This is a continuation to my previous patch series.
There will be another series and a stand-alone patch as well
after this.

This series in particular covers MCDI (management controller
driver interface) code.

Alexandru-Mihai Maftei (9):
  sfc: move some port link state/caps code
  sfc: move some MCDI port utility functions
  sfc: move more MCDI port code
  sfc: move MCDI VI alloc/free code
  sfc: move MCDI event queue management code
  sfc: move MCDI transmit queue management code
  sfc: move MCDI receive queue management code
  sfc: conditioned some functionality
  sfc: move MCDI logging device attribute

 drivers/net/ethernet/sfc/Makefile           |   4 +-
 drivers/net/ethernet/sfc/ef10.c             | 355 ++------------
 drivers/net/ethernet/sfc/efx.c              |  55 +--
 drivers/net/ethernet/sfc/efx_channels.c     |   6 +-
 drivers/net/ethernet/sfc/efx_common.c       |  86 +++-
 drivers/net/ethernet/sfc/efx_common.h       |   8 +
 drivers/net/ethernet/sfc/mcdi_functions.c   | 349 ++++++++++++++
 drivers/net/ethernet/sfc/mcdi_functions.h   |   2 +-
 drivers/net/ethernet/sfc/mcdi_port.c        | 464 -------------------
 drivers/net/ethernet/sfc/mcdi_port_common.c | 489 ++++++++++++++++++++
 10 files changed, 958 insertions(+), 860 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_functions.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_port_common.c

-- 
2.20.1

