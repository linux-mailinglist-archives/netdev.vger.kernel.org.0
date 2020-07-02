Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18F21294C
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgGBQZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:25:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41104 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgGBQZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:25:27 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 196EC600D5;
        Thu,  2 Jul 2020 16:25:27 +0000 (UTC)
Received: from us4-mdac16-32.ut7.mdlocal (unknown [10.7.66.145])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 16619200AC;
        Thu,  2 Jul 2020 16:25:27 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 86E8122006D;
        Thu,  2 Jul 2020 16:25:26 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 26D3EB40072;
        Thu,  2 Jul 2020 16:25:26 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:25:20 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 00/16] sfc: prerequisites for EF100 driver, part 3
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Date:   Thu, 2 Jul 2020 17:25:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-3.709200-8.000000-10
X-TMASE-MatchedRID: QBPDgdBGZW7hp80oBol0K/3HILfxLV/9APiR4btCEeYMrRrnLCZEmngS
        ql3zhup/bYeFBJB9B7Sr/+Gm/JK2ukohWBZ4QV+620204SCJw/rKIqAq0jIHitKpFIAeH1NQ2jN
        t44OdemXrKSBTkozzvpNgfsIadgPVG5/z6rCPbAFPs79gcmEg0AEPJrYlsf/6mJBe2bRXwlMfzs
        75W7+/naTj0eKb2CFznd7tX1ZngZd6bMYbioM9qbsHVDDM5xAPp1Pjcaldww3i7ECA5q90uVGCr
        86m3bCT9RzkM0/MzhOq3CLfAyeEIxdf33vUT1aFhL9NX2TqmkBn+sA9+u1YLY4iwAQuovtY5iW+
        +W4offtJ3i5QgwGkJH98Sq1bwEZ2WELDcKwGO252GcWKGZufBeqhuTPUDQDtYy6fApvL8BdLeiW
        HDwLK1k0OUyMTH7WrhbopPwYOhRO+8LSisOUFN54CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR4
        +zsDTtQh+ArmEemWUahG1ZvLXGRjxo//ZOdUXHK7yYWUwyvGVkKWc3v50Y4Ft28IHFiOK92demI
        rkmwVUSk2X0CuYlVGpmSOgEjo6ILww58Y/C0+V85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwvJ
        jiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.709200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707127-xRvUjSwzy6U5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continuing on from [1] and [2], this series assembles the last pieces
 of the common codebase that will be used by the forthcoming EF100
 driver.
Patch #1 also adds a minor feature to EF10 (setting MTU on VFs) since
 EF10 supports the same MCDI extension which that feature will use on
 EF100.
Patches #5 & #7, while they should have no externally-visible effect
 on driver functionality, change how that functionality is implemented
 and how the driver represents TXQ configuration internally, so are
 not mere cleanup/refactoring like most of these prerequisites have
 (from the perspective of the existing sfc driver) been.

Changes in v2:
* Patch #1: use efx_mcdi_set_mtu() directly, instead of as a fallback,
  in the mtu_only case (Jakub)
* Patch #3: fix symbol collision in non-modular builds by renaming
  interrupt_mode to efx_interrupt_mode (kernel test robot)
* Patch #6: check for failure of netif_set_real_num_[tr]x_queues (Jakub)
* Patch #12: cleaner solution for ethtool drvinfo (Jakub, David)

[1]: https://lore.kernel.org/netdev/20200629.173812.1532344417590172093.davem@davemloft.net/T/
[2]: https://lore.kernel.org/netdev/20200630.130923.402514193016248355.davem@davemloft.net/T/

Edward Cree (16):
  sfc: support setting MTU even if not privileged to configure MAC fully
  sfc: remove max_interrupt_mode
  sfc: move modparam 'interrupt_mode' out of common channel code
  sfc: move modparam 'rss_cpus' out of common channel code
  sfc: make tx_queues_per_channel variable at runtime
  sfc: commonise netif_set_real_num[tr]x_queues calls
  sfc: assign TXQs without gaps
  sfc: don't call tx_limit_len if NIC type doesn't have one
  sfc: factor out efx_mcdi_filter_table_down() from _remove()
  sfc: commonise efx_fini_dmaq
  sfc: initialise RSS context ID to 'no RSS context' in
    efx_init_struct()
  sfc: get drvinfo driver name from outside the common code
  sfc_ef100: add EF100 to NIC-revision enumeration
  sfc_ef100: populate BUFFER_SIZE_BYTES in INIT_RXQ
  sfc_ef100: NVRAM selftest support code
  sfc_ef100: helper function to set default RSS table of given size

 drivers/net/ethernet/sfc/ef10.c           | 76 +++++------------------
 drivers/net/ethernet/sfc/efx.c            | 14 ++---
 drivers/net/ethernet/sfc/efx_channels.c   | 66 ++++++++++++--------
 drivers/net/ethernet/sfc/efx_channels.h   |  3 +
 drivers/net/ethernet/sfc/efx_common.c     | 14 +++--
 drivers/net/ethernet/sfc/efx_common.h     |  2 +-
 drivers/net/ethernet/sfc/ethtool.c        |  2 +
 drivers/net/ethernet/sfc/ethtool_common.c | 11 ++--
 drivers/net/ethernet/sfc/ethtool_common.h |  2 +
 drivers/net/ethernet/sfc/farch.c          |  6 +-
 drivers/net/ethernet/sfc/mcdi.c           | 62 ++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h           |  1 +
 drivers/net/ethernet/sfc/mcdi_filters.c   | 58 +++++++++++++----
 drivers/net/ethernet/sfc/mcdi_filters.h   |  3 +
 drivers/net/ethernet/sfc/mcdi_functions.c | 57 ++++++++++++++---
 drivers/net/ethernet/sfc/mcdi_functions.h |  1 +
 drivers/net/ethernet/sfc/net_driver.h     | 44 ++++++-------
 drivers/net/ethernet/sfc/nic_common.h     |  3 +-
 drivers/net/ethernet/sfc/selftest.c       | 18 +++---
 drivers/net/ethernet/sfc/siena.c          |  4 +-
 drivers/net/ethernet/sfc/tx.c             | 50 +++------------
 drivers/net/ethernet/sfc/tx_common.c      |  6 +-
 22 files changed, 292 insertions(+), 211 deletions(-)

