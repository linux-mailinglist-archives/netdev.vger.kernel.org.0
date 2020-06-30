Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6FB20F410
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbgF3MAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:00:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34086 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732746AbgF3MAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:00:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5F08E600E7;
        Tue, 30 Jun 2020 12:00:33 +0000 (UTC)
Received: from us4-mdac16-67.ut7.mdlocal (unknown [10.7.64.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5D6138009E;
        Tue, 30 Jun 2020 12:00:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E3EEE280059;
        Tue, 30 Jun 2020 12:00:32 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 87412BC006D;
        Tue, 30 Jun 2020 12:00:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:00:22 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 00/14] sfc: prerequisites for EF100 driver, part 2
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Date:   Tue, 30 Jun 2020 13:00:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-0.066300-8.000000-10
X-TMASE-MatchedRID: ppRRWZU6Jcbhp80oBol0K2IBiNkQ/Ahv5GNdGhmNEOER34ro7k23ndGV
        QrnZJqIelcQYMjrsDFnGFyG6HjDZHvwfXc9ZWlYMO3qZlHiAPOAisyg/lfGoZypnHGSoRylA9Vl
        GBjCDnciG51uVDiWaVfKUE7cNDqUoZSU6HajahM4zn/LxI9LW3ffjx7YIT/BiRyr1KrkGuzI68L
        1PbgnmJiH6jxfQvhjouQrgQ+Mbuksl1ruS1vtrJfChiQolft/yeouvej40T4jzzRxeLr/OGwGRV
        Ppr3xmq5RngtX2fL50G2+Zz5ETsOJH0YXYnbGozOX/V8P8ail1yZ8zcONpAscRB0bsfrpPInxMy
        eYT53RkABs5G477E+2QcBuHxxesUCtjP6Ha82MrTbc3rRWd1E+kw2NVp7YWpTBwNIGgJvtKskX5
        csPXfyIuu1wIlFhabbLtJBiy7uM0aEFYXAylB9SUSM5mwacGkICQpusqRi2ejpeaEV8oRRFZca9
        RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.066300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593518433-Z0f_0huXiBKX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continuing on from [1], this series further prepares the sfc codebase
 for the introduction of the EF100 driver.

[1]: https://lore.kernel.org/netdev/20200629.173812.1532344417590172093.davem@davemloft.net/T/

Edward Cree (14):
  sfc: move NIC-specific mcdi_port declarations out of common header
  sfc: commonise MCDI MAC stats handling
  sfc: add missing licence info to mcdi_filters.c
  sfc: commonise miscellaneous efx functions
  sfc: commonise some MAC configuration code
  sfc: commonise efx_sync_rx_buffer()
  sfc: commonise TSO fallback code
  sfc: remove duplicate declaration of efx_enqueue_skb_tso()
  sfc: factor out efx_tx_tso_header_length() and understand
    encapsulation
  sfc: move definition of EFX_MC_STATS_GENERATION_INVALID
  sfc: initialise max_[tx_]channels in efx_init_channels()
  sfc: commonise efx->[rt]xq_entries initialisation
  sfc: commonise initialisation of efx->vport_id
  sfc: don't call tx_remove if there isn't one

 drivers/net/ethernet/sfc/ef10.c             |   3 +-
 drivers/net/ethernet/sfc/efx.c              | 104 ---------------
 drivers/net/ethernet/sfc/efx.h              |  26 ----
 drivers/net/ethernet/sfc/efx_channels.c     |   3 +
 drivers/net/ethernet/sfc/efx_common.c       | 106 +++++++++++++++
 drivers/net/ethernet/sfc/efx_common.h       |  36 +++++
 drivers/net/ethernet/sfc/mcdi.h             |   4 -
 drivers/net/ethernet/sfc/mcdi_filters.c     |  11 ++
 drivers/net/ethernet/sfc/mcdi_port.c        | 105 +--------------
 drivers/net/ethernet/sfc/mcdi_port.h        |  18 +++
 drivers/net/ethernet/sfc/mcdi_port_common.c | 141 +++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi_port_common.h |   5 +-
 drivers/net/ethernet/sfc/nic.c              |   1 -
 drivers/net/ethernet/sfc/nic.h              |   3 -
 drivers/net/ethernet/sfc/nic_common.h       |   8 +-
 drivers/net/ethernet/sfc/rx.c               |   8 --
 drivers/net/ethernet/sfc/rx_common.h        |   9 ++
 drivers/net/ethernet/sfc/siena.c            |   1 +
 drivers/net/ethernet/sfc/tx.c               |  28 ----
 drivers/net/ethernet/sfc/tx.h               |   3 -
 drivers/net/ethernet/sfc/tx_common.c        |  46 ++++++-
 drivers/net/ethernet/sfc/tx_common.h        |   3 +-
 22 files changed, 382 insertions(+), 290 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/mcdi_port.h

