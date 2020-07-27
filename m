Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76D622EB80
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgG0LyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:54:06 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:53862 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726873AbgG0LyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:54:05 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2ABF26007E;
        Mon, 27 Jul 2020 11:54:05 +0000 (UTC)
Received: from us4-mdac16-6.ut7.mdlocal (unknown [10.7.65.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 26A848009B;
        Mon, 27 Jul 2020 11:54:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.197])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9B991280059;
        Mon, 27 Jul 2020 11:54:04 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 22B5AA40050;
        Mon, 27 Jul 2020 11:54:04 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 12:53:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 00/16] sfc: driver for EF100 family NICs, part 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Date:   Mon, 27 Jul 2020 12:53:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-2.122900-8.000000-10
X-TMASE-MatchedRID: D8ASTT+8l8V09yt1Yp3gn7bQFsbjObJeLozI+rhNYbklbkXtj2kSO1uE
        36pB6+0bofKl0HWAHQPX53LJkoR7zjTuXZRUSTQGuZBZOg7RfX9MtkHpT9ho+lrJqhTz0WH26aX
        8TYIrj1uyniowqjihGB8Pq6yM7fNIyw0dUT70SVFTLFbi+a8u3bzETYfYS4xZi3i2HAbFd/fqYf
        M0tIgPqcUGtPIFi9Wb/V+Z6GKjSReKmX0SaEcqmwGdJZ3Knh6hgdkHykGcMpkQHQ+7AkbTsciTW
        ug2C4DN8EV3BVKCM+me/wOfHDr5v+VCna7Y4RCFR/j040fRFpKA6f0PMYIXs1SOymiJfTYXZJ23
        hwfoyRseTiJdGSPPWvzyKzp+Nm/2/bhNbKI2qQZ2GcWKGZufBb7qbXmmwd31LH4QxHuctx5bJf2
        jYnISczM2G9lx61E5gOUWFN6QOF/s4ROsHbHiao6cpbnLdja92LlbtF/6zpCRoQLwUmtov5TGvU
        NFceb0y3fAqATgSPaJJBgjyokhM/HAGelQoI3yCesU3iPiNCwtxMagbN9/PN9zZd3pUn7KqYTqy
        KRFO19ORf8J7jzSmTUjxWEQ/fv7/FxfOVRC3SjwqDryy7bDIe6jyigxCo6yBph69XjMbdlfrxBS
        jmWYkOLzNWBegCW2RYvisGWbbS+No+PRbWqfRMZW5ai5WKlyM/LR3Qai57N5pdnytD3zw13PSE4
        6ScCgbg4GI0W4lpUZlZG1hrVQRSBKUFc3OY7L8ICwy8C5GYAC5nH7lJpiVz41XdIZJXS7kERyuR
        HFgnhSMqc7UpUorBKRsPC6bTvOqrQxXydIwG8AF83WedHbhQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.122900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595850845-yxdporLgmokJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 is a new NIC architecture under development at Xilinx, based
 partly on existing Solarflare technology.  As many of the hardware
 interfaces resemble EF10, support is implemented within the 'sfc'
 driver, which previous patch series "commonised" for this purpose.

In order to maintain bisectability while splitting into patches of a
 reasonable size, I had to do a certain amount of back-and-forth with
 stubs for things that the common code may try to call, mainly because
 we can't do them until we've set up MCDI, but we can't set up MCDI
 without probing the event queues, at which point a lot of the common
 machinery becomes reachable from event handlers.
Consequently, this first series doesn't get as far as actually sending
 and receiving packets.  I have a second series ready to follow it
 which implements the datapath (and a few other things like ethtool).

Changes from v4:
 * Fix build on CONFIG_RETPOLINE=n by using plain prototypes instead
   of INDIRECT_CALLABLE_DECLARE.

Changes from v3:
 * combine both drivers (sfc_ef100 and sfc) into a single module, to
   make non-modular builds work.  Patch #4 now adds a few indirections
   to support this; the ones in the RX and TX path use indirect-call-
   wrappers to minimise the performance impact.

Changes from v2:
 * remove MODULE_VERSION.
 * call efx_destroy_reset_workqueue() from ef100_exit_module().
 * correct uint32_ts to u32s.  While I was at it, I fixed a bunch of
   other style issues in the function-control-window code.
All in patch #4.

Changes from v1:
 * kernel test robot spotted a link error when sfc_ef100 was built
   without mdio.  It turns out the thing we were trying to link to
   was a bogus thing to do on anything but Falcon, so new patch #1
   removes it from this driver.
 * fix undeclared symbols in patch #4 by shuffling around prototypes
   and #includes and adding 'static' where appropriate.
 * fix uninitialised variable 'rc2' in patch #7.

Edward Cree (16):
  sfc: remove efx_ethtool_nway_reset()
  sfc_ef100: add EF100 register definitions
  sfc_ef100: register accesses on EF100
  sfc: skeleton EF100 PF driver
  sfc_ef100: reset-handling stub
  sfc_ef100: PHY probe stub
  sfc_ef100: don't call efx_reset_down()/up() on EF100
  sfc_ef100: implement MCDI transport
  sfc_ef100: implement ndo_open/close and EVQ probing
  sfc_ef100: process events for MCDI completions
  sfc_ef100: read datapath caps, implement check_caps
  sfc_ef100: extend ef100_check_caps to cover datapath_caps3
  sfc_ef100: actually perform resets
  sfc_ef100: probe the PHY and configure the MAC
  sfc_ef100: read device MAC address at probe time
  sfc_ef100: implement ndo_get_phys_port_{id,name}

 drivers/net/ethernet/sfc/Kconfig          |   5 +-
 drivers/net/ethernet/sfc/Makefile         |   4 +-
 drivers/net/ethernet/sfc/ef10.c           |   7 +
 drivers/net/ethernet/sfc/ef100.c          | 541 +++++++++++++++++
 drivers/net/ethernet/sfc/ef100.h          |  12 +
 drivers/net/ethernet/sfc/ef100_ethtool.c  |  24 +
 drivers/net/ethernet/sfc/ef100_ethtool.h  |  12 +
 drivers/net/ethernet/sfc/ef100_netdev.c   | 274 +++++++++
 drivers/net/ethernet/sfc/ef100_netdev.h   |  17 +
 drivers/net/ethernet/sfc/ef100_nic.c      | 619 +++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h      |  32 +
 drivers/net/ethernet/sfc/ef100_regs.h     | 693 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rx.c       |  31 +
 drivers/net/ethernet/sfc/ef100_rx.h       |  20 +
 drivers/net/ethernet/sfc/ef100_tx.c       |  51 ++
 drivers/net/ethernet/sfc/ef100_tx.h       |  22 +
 drivers/net/ethernet/sfc/efx.c            |   8 +
 drivers/net/ethernet/sfc/efx.h            |  16 +-
 drivers/net/ethernet/sfc/efx_common.c     |  11 +-
 drivers/net/ethernet/sfc/ethtool.c        |   3 -
 drivers/net/ethernet/sfc/ethtool_common.c |  10 +-
 drivers/net/ethernet/sfc/ethtool_common.h |   3 -
 drivers/net/ethernet/sfc/io.h             |  16 +-
 drivers/net/ethernet/sfc/mcdi.c           |   2 +-
 drivers/net/ethernet/sfc/mcdi.h           |   4 +-
 drivers/net/ethernet/sfc/net_driver.h     |  18 +
 drivers/net/ethernet/sfc/nic_common.h     |   6 +
 drivers/net/ethernet/sfc/siena.c          |   3 +
 drivers/net/ethernet/sfc/tx.c             |   4 +-
 drivers/net/ethernet/sfc/tx_common.h      |   2 +
 30 files changed, 2439 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100.c
 create mode 100644 drivers/net/ethernet/sfc/ef100.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_ethtool.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_ethtool.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_netdev.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_netdev.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_nic.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_nic.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_regs.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_rx.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rx.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_tx.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_tx.h

