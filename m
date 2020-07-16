Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB80F22232D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgGPM57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 08:57:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:46426 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728439AbgGPM56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 08:57:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F3E1520064;
        Thu, 16 Jul 2020 12:57:56 +0000 (UTC)
Received: from us4-mdac16-3.at1.mdlocal (unknown [10.110.49.149])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AFA4B800BF;
        Thu, 16 Jul 2020 12:57:55 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.234])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F1AD7100078;
        Thu, 16 Jul 2020 12:57:54 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8E43778006E;
        Thu, 16 Jul 2020 12:57:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 13:57:49 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 00/16] sfc_ef100: driver for EF100 family NICs,
 part 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Date:   Thu, 16 Jul 2020 13:57:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25544.003
X-TM-AS-Result: No-4.853300-8.000000-10
X-TMASE-MatchedRID: DiHRf6dPkZR09yt1Yp3gn7bQFsbjObJeLozI+rhNYbklbkXtj2kSO1uE
        36pB6+0bYaPW10smdgxbySY0nZFbI6goXj9BWHh3fid4LSHtIANF/jSlPtma/lcn81OBopCmafh
        2zcspPYf4Joz2NytzcuVuCjs/RbkA+QvYK6q8ktQ+NrfDUTEXxACm784gsJu4FujNgNeS9UCzSv
        2lTjNjblk3JPfs2OJdnVTw5qrBKfd2UQRibUa5VElABXpquwdlMVx/3ZYby784WKr1PmPdtWSdt
        4cH6MkbHk4iXRkjz1r88is6fjZv9v24TWyiNqkGdhnFihmbnwW+6m15psHd9Sx+EMR7nLceWyX9
        o2JyEnMzNhvZcetROYDlFhTekDhf7OETrB2x4moBnSWdyp4eoS9wqaqMRxjezVgwP7ZMYf+Pvz7
        W6xxPku28kzgoqBIIuhsUugxdrYlyygkjCrPFdyT9vTe4FHdQlHLUcNM85drg9GtYPBPdS1B1eq
        TYlYh0O8cuRdzSJk+1+hkpRLKlA4zQp7mciZRIimHWEC28pk16i696PjRPiB3RY4pGTCyHsSAf9
        uUaPflKNUgU7kTjgNNQkwj8EMZJGAdnzrnkM485f9Xw/xqKXXJnzNw42kCxxEHRux+uk8hxKpvE
        GAbTDrjYPuwCW3Yar53hpev3bmKrvCg51T0eBI+FO1xHEP7gn6Ifh93DzLRSRKuWisRbzWmDcrp
        ewkhjGV3IyUotQcjvrr3GWueC8xoQVhcDKUH1JRIzmbBpwaQgJCm6ypGLZ4kFmqDGAwWm
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.853300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904275-CcSW0nGtXP9E
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 is a new NIC architecture under development at Xilinx, based
 partly on existing Solarflare technology.  As many of the hardware
 interfaces resemble EF10, the driver is implemented largely through
 libraries of code from the 'sfc' driver, which previous patch series
 "commonised" for this purpose.
The new driver is called 'sfc_ef100'.

In order to maintain bisectability while splitting into patches of a
 reasonable size, I had to do a certain amount of back-and-forth with
 stubs for things that the common code may try to call, mainly because
 we can't do them until we've set up MCDI, but we can't set up MCDI
 without probing the event queues, at which point a lot of the common
 machinery becomes reachable from event handlers.
Consequently, this first series doesn't get as far as actually sending
 and receiving packets.  I have a second series ready to follow it
 which implements the datapath (and a few other things like ethtool).

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
  sfc_ef100: skeleton EF100 PF driver
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

 drivers/net/ethernet/sfc/Kconfig          |  10 +
 drivers/net/ethernet/sfc/Makefile         |   8 +
 drivers/net/ethernet/sfc/ef10.c           |   1 +
 drivers/net/ethernet/sfc/ef100.c          | 577 ++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_ethtool.c  |  26 +
 drivers/net/ethernet/sfc/ef100_ethtool.h  |  12 +
 drivers/net/ethernet/sfc/ef100_netdev.c   | 280 +++++++++
 drivers/net/ethernet/sfc/ef100_netdev.h   |  17 +
 drivers/net/ethernet/sfc/ef100_nic.c      | 620 +++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h      |  32 +
 drivers/net/ethernet/sfc/ef100_regs.h     | 693 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rx.c       |  31 +
 drivers/net/ethernet/sfc/ef100_rx.h       |  19 +
 drivers/net/ethernet/sfc/ef100_tx.c       |  63 ++
 drivers/net/ethernet/sfc/ef100_tx.h       |  22 +
 drivers/net/ethernet/sfc/efx.h            |   1 -
 drivers/net/ethernet/sfc/efx_common.c     |  11 +-
 drivers/net/ethernet/sfc/ethtool.c        |   1 -
 drivers/net/ethernet/sfc/ethtool_common.c |   8 -
 drivers/net/ethernet/sfc/ethtool_common.h |   1 -
 drivers/net/ethernet/sfc/io.h             |  16 +-
 drivers/net/ethernet/sfc/mcdi.h           |   4 +-
 drivers/net/ethernet/sfc/net_driver.h     |  14 +-
 drivers/net/ethernet/sfc/tx_common.h      |   2 +
 24 files changed, 2449 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100.c
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

