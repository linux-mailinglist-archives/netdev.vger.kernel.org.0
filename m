Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421B422C987
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGXP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:56:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54548 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgGXP4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:56:20 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3E182200B2;
        Fri, 24 Jul 2020 15:56:19 +0000 (UTC)
Received: from us4-mdac16-51.at1.mdlocal (unknown [10.110.48.100])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3B955800A4;
        Fri, 24 Jul 2020 15:56:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.8])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B52CC4006F;
        Fri, 24 Jul 2020 15:56:18 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 631224C0062;
        Fri, 24 Jul 2020 15:56:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 16:56:13 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v4 net-next 00/16] sfc: driver for EF100 family NICs, part 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <d224dbb2-ef20-dca9-d50b-7f583b45d859@solarflare.com>
Date:   Fri, 24 Jul 2020 16:56:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25560.003
X-TM-AS-Result: No-2.752000-8.000000-10
X-TMASE-MatchedRID: X3MNZ1y6GUR09yt1Yp3gn7bQFsbjObJeLozI+rhNYbklbkXtj2kSO1uE
        36pB6+0bofKl0HWAHQPX53LJkoR7zjTuXZRUSTQGuZBZOg7RfX9MtkHpT9ho+lrJqhTz0WH26aX
        8TYIrj1uyniowqjihGB8Pq6yM7fNIyw0dUT70SVFTLFbi+a8u3bzETYfYS4xZi3i2HAbFd/fqYf
        M0tIgPqcUGtPIFi9Wb/V+Z6GKjSReKmX0SaEcqm6iUivh0j2PvRwDU669267w4XREg9Ki104Rsx
        t8GP3C3f5Zq/VZOXh7U887R5LNclzbcsMCH+ZLFiJwEp8weVXwwjY20D2quYgL+e4+Xk/QWvNj7
        Q/9J9nt9Ho28QgzyPjbtjVWZc8/OnM8FMFzcocI1VHP4fCovggAWEaci2Ej6BO++kW5c7hD1Zeb
        7KEkrKKXyclUbGCUE8KJ9+iKms0LXPfWTmsBa3Ro8wYJxWb0ONV9S7O+u3KYDAA5uRHailqXXyb
        C2uBgGmGtEmkq5VfImE42irklNT3fasbVZ1j1qLIrMljt3adsEa8g1x8eqF4pl689MOw1GbBUWr
        0rJkZZriWy7wPumNHAxcMmPggHaBRx9b+h52aoHwuCWPSIIAD+k5IvvZ1N/mvnco5r4a3OjxYyR
        Ba/qJQPTK4qtAgwIPcCXjNqUmkUnRE+fI6etkgfvT942bFntpzGN/HcuQqy2f3KM8m2jM5gCQvZ
        GO7VTz30b0BhnA1l7MLj/tLvj8zIb3/HveSXya8gTsrNbys2b1iG5HyYyVDHCqV7rv9Y1QDMFuK
        2P9FjtoWavEW7HRE3Z8jKJCdR0Rfwnj+uLV5w=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.752000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25560.003
X-MDID: 1595606179-pfOzjmoP2QZZ
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
 drivers/net/ethernet/sfc/ef100_rx.h       |  21 +
 drivers/net/ethernet/sfc/ef100_tx.c       |  51 ++
 drivers/net/ethernet/sfc/ef100_tx.h       |  24 +
 drivers/net/ethernet/sfc/efx.c            |   8 +
 drivers/net/ethernet/sfc/efx.h            |  19 +-
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
 30 files changed, 2444 insertions(+), 32 deletions(-)
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

