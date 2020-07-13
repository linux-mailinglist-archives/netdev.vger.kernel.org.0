Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B3121D4EA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgGML1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:27:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:48614 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729545AbgGML1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:27:12 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A258560058;
        Mon, 13 Jul 2020 11:27:11 +0000 (UTC)
Received: from us4-mdac16-27.ut7.mdlocal (unknown [10.7.66.59])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A118C8009B;
        Mon, 13 Jul 2020 11:27:11 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.174])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 24745280050;
        Mon, 13 Jul 2020 11:27:11 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BDFA51C0065;
        Mon, 13 Jul 2020 11:27:10 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 12:27:06 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 00/16] sfc_ef100: driver for EF100 family NICs,
 part 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Date:   Mon, 13 Jul 2020 12:27:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25538.003
X-TM-AS-Result: No-5.274200-8.000000-10
X-TMASE-MatchedRID: ef3Wktg+Qml09yt1Yp3gn7bQFsbjObJeLozI+rhNYbklbkXtj2kSO1uE
        36pB6+0bYaPW10smdgxbySY0nZFbI6goXj9BWHh3fid4LSHtIANF/jSlPtma/lcn81OBopCmafh
        2zcspPYf4Joz2NytzcuVuCjs/RbkA+QvYK6q8ktQ+NrfDUTEXxACm784gsJu4FujNgNeS9UCzSv
        2lTjNjblk3JPfs2OJdnVTw5qrBKfd2UQRibUa5VElABXpquwdlAQ8mtiWx//qYkF7ZtFfCU6FMV
        JYjcI+fCxoXp2vdPsYihriy/MePs5XOyk7EwLgluBPKuumTwxxxWv4UB7dQNYqFeIXGsrr92VC1
        QWKKKPpfGmnSZmHtlAzZ1XkfOHs13hf6USLa/FkJaVZHbbd1ri0rLNhFaIy7ACF5TKaad197TC5
        6+ziBs5SrOKfZPI2js+evOVNl7REGcw5drLTCrge06kQGFaIWL1eX+z9B1QxjLp8Cm8vwFwoeRR
        hCZWIBAziHyFDXH4HJFlXh4IcOcPI1YbpS1+avngIgpj8eDcC063Wh9WVqgtZE3xJMmmXc+gtHj
        7OwNO14uFxKD13nMY3ttSeW6U4IyO5rydC1PdU/+HBONkmFwtFpF6mU+fX+
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.274200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25538.003
X-MDID: 1594639631-LC2eFhiLN0tq
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
 drivers/net/ethernet/sfc/ef100.c          | 583 ++++++++++++++++++
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
 24 files changed, 2455 insertions(+), 20 deletions(-)
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

