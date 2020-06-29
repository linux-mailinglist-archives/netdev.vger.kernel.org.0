Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF520D816
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgF2Tfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:35:39 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56160 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730920AbgF2Tfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:35:37 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D97782019FA
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:30:42 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C81FB200D8;
        Mon, 29 Jun 2020 13:30:42 +0000 (UTC)
Received: from us4-mdac16-4.at1.mdlocal (unknown [10.110.49.155])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C6BA6800A9;
        Mon, 29 Jun 2020 13:30:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 296D040070;
        Mon, 29 Jun 2020 13:30:42 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E07DC340092;
        Mon, 29 Jun 2020 13:30:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:30:35 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 00/15] sfc: prerequisites for EF100 driver, part 1
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Date:   Mon, 29 Jun 2020 14:30:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-0.840600-8.000000-10
X-TMASE-MatchedRID: mIkcD3kVh3CfJebeMR+nc7mQWToO0X1/Ww/S0HB7eoMda1Vk3RqxOD3+
        knT9EPAGiSkku02xGQknXlmC+rVSfEEckgEbMMejAZ0lncqeHqGW31x27U9QYvn6214PlHOFF1x
        VxK5znzXACBMXA+s9riLRsbC2GtIXTweK12oEGfsuOya45qyEYlIOc8QjxyVt85duZavstuF0t9
        tHJjfNd57+4Fgc4YB4Ms9De6umJgmp+3FLcueO9Si9uJ8hAvsalS5IbQ8u3Tolfe31Kb3l/8iTW
        ug2C4DNl1M7KT9/aqDnj5EHWBrMptF/tAhYTSzXB8Lglj0iCAA/pOSL72dTf5r53KOa+Gtzo8WM
        kQWv6iUD0yuKrQIMCD3Al4zalJpFWBd6ltyXuvv705Vgr8azeOIdpM+Ln9uKLuMc3R2N7/eyFrq
        zGXh3l7SeB5R3WPnvUxNcgJ5sXjQs3AqVx77XTeZwTvEDYwdf4t1OknR4Eb4xwqle67/WNUAzBb
        itj/RY7aFmrxFux0RN2fIyiQnUdOJqixYeb35sftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.840600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437442-85Ren5xRLcVg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This continues the work started by Alex Maftei <amaftei@solarflare.com>
 in the series "sfc: code refactoring", "sfc: more code refactoring",
 "sfc: even more code refactoring" and "sfc: refactor mcdi filtering
 code", to prepare for a new driver which will share much of the code
 to support the new EF100 family of Solarflare/Xilinx NICs.
After this series, there will be approximately two more of these
 'prerequisites' series, followed by the sfc_ef100 driver itself.

v2: fix reverse xmas tree in patch 5.  (Left the cases in patches 7,
 9 and 14 alone as those are all in pure movement of existing code.)

Edward Cree (15):
  sfc: update MCDI protocol headers
  sfc: determine flag word automatically in efx_has_cap()
  sfc: extend bitfield macros up to POPULATE_DWORD_13
  sfc: don't try to create more channels than we can have VIs
  sfc: refactor EF10 stats handling
  sfc: split up nic.h
  sfc: commonise ethtool link handling functions
  sfc: commonise ethtool NFC and RXFH/RSS functions
  sfc: commonise other ethtool bits
  sfc: commonise FC advertising
  sfc: track which BAR is mapped
  sfc: commonise PCI error handlers
  sfc: commonise drain event handling
  sfc: commonise ARFS handling
  sfc: extend common GRO interface to support CHECKSUM_COMPLETE

 drivers/net/ethernet/sfc/bitfield.h       |   34 +-
 drivers/net/ethernet/sfc/ef10.c           |  100 +-
 drivers/net/ethernet/sfc/efx.c            |  119 +-
 drivers/net/ethernet/sfc/efx.h            |    8 -
 drivers/net/ethernet/sfc/efx_channels.c   |    7 +
 drivers/net/ethernet/sfc/efx_common.c     |  134 +-
 drivers/net/ethernet/sfc/efx_common.h     |    6 +-
 drivers/net/ethernet/sfc/ethtool.c        |  913 ---
 drivers/net/ethernet/sfc/ethtool_common.c |  911 +++
 drivers/net/ethernet/sfc/ethtool_common.h |   36 +-
 drivers/net/ethernet/sfc/mcdi.c           |   10 +-
 drivers/net/ethernet/sfc/mcdi.h           |    5 +-
 drivers/net/ethernet/sfc/mcdi_filters.c   |    8 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h      | 6933 ++++++++++++++++++++-
 drivers/net/ethernet/sfc/net_driver.h     |    4 +
 drivers/net/ethernet/sfc/nic.c            |   45 +
 drivers/net/ethernet/sfc/nic.h            |  298 +-
 drivers/net/ethernet/sfc/nic_common.h     |  273 +
 drivers/net/ethernet/sfc/ptp.c            |    5 +-
 drivers/net/ethernet/sfc/ptp.h            |   45 +
 drivers/net/ethernet/sfc/rx.c             |  236 +-
 drivers/net/ethernet/sfc/rx_common.c      |  245 +-
 drivers/net/ethernet/sfc/rx_common.h      |    6 +-
 drivers/net/ethernet/sfc/siena.c          |    1 +
 24 files changed, 8671 insertions(+), 1711 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/nic_common.h
 create mode 100644 drivers/net/ethernet/sfc/ptp.h

