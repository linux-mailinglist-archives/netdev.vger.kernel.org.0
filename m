Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C781F3DF312
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhHCQnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:43:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:58212 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhHCQnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:43:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="193325463"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="193325463"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:42:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521318629"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 03 Aug 2021 09:42:48 -0700
Received: from alobakin-mobl.ger.corp.intel.com (lkalica-MOBL.ger.corp.intel.com [10.213.13.182])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173Ggihn032389;
        Tue, 3 Aug 2021 17:42:44 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 21/21] Documentation, ethtool-netlink: update standard statistics documentation
Date:   Tue,  3 Aug 2021 18:42:43 +0200
Message-Id: <20210803164243.4469-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reflect the addition of the new standard XDP stats as well as of
a new NL attribute.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 Documentation/networking/ethtool-netlink.rst | 45 +++++++++++++-------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c86628e6a235..d304a5361569 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1415,21 +1415,26 @@ Request contents:
 
 Kernel response contents:
 
- +-----------------------------------+--------+--------------------------------+
- | ``ETHTOOL_A_STATS_HEADER``        | nested | reply header                   |
- +-----------------------------------+--------+--------------------------------+
- | ``ETHTOOL_A_STATS_GRP``           | nested | one or more group of stats     |
- +-+---------------------------------+--------+--------------------------------+
- | | ``ETHTOOL_A_STATS_GRP_ID``      | u32    | group ID - ``ETHTOOL_STATS_*`` |
- +-+---------------------------------+--------+--------------------------------+
- | | ``ETHTOOL_A_STATS_GRP_SS_ID``   | u32    | string set ID for names        |
- +-+---------------------------------+--------+--------------------------------+
- | | ``ETHTOOL_A_STATS_GRP_STAT``    | nested | nest containing a statistic    |
- +-+---------------------------------+--------+--------------------------------+
- | | ``ETHTOOL_A_STATS_GRP_HIST_RX`` | nested | histogram statistic (Rx)       |
- +-+---------------------------------+--------+--------------------------------+
- | | ``ETHTOOL_A_STATS_GRP_HIST_TX`` | nested | histogram statistic (Tx)       |
- +-+---------------------------------+--------+--------------------------------+
+ +--------------------------------------+--------+-----------------------------+
+ | ``ETHTOOL_A_STATS_HEADER``           | nested | reply header                |
+ +--------------------------------------+--------+-----------------------------+
+ | ``ETHTOOL_A_STATS_GRP``              | nested | one or more group of stats  |
+ +-+------------------------------------+--------+-----------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_ID``         | u32    | group ID -                  |
+ | |                                    |        | ``ETHTOOL_STATS_*``         |
+ +-+------------------------------------+--------+-----------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_SS_ID``      | u32    | string set ID for names     |
+ +-+------------------------------------+--------+-----------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_STAT``       | nested | nest containing a statistic |
+ +-+------------------------------------+--------+-----------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_STAT_BLOCK`` | nested | block of stats per channel  |
+ +-+-+----------------------------------+--------+-----------------------------+
+ | | | ``ETHTOOL_A_STATS_GRP_STAT``     | nested | nest containing a statistic |
+ +-+-+----------------------------------+--------+-----------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_HIST_RX``    | nested | histogram statistic (Rx)    |
+ +-+------------------------------------+--------+-----------------------------+
+ | | ``ETHTOOL_A_STATS_GRP_HIST_TX``    | nested | histogram statistic (Tx)    |
+ +-+------------------------------------+--------+-----------------------------+
 
 Users specify which groups of statistics they are requesting via
 the ``ETHTOOL_A_STATS_GROUPS`` bitset. Currently defined values are:
@@ -1439,6 +1444,7 @@ the ``ETHTOOL_A_STATS_GROUPS`` bitset. Currently defined values are:
  ETHTOOL_STATS_ETH_PHY  eth-phy  Basic IEEE 802.3 PHY statistics (30.3.2.1.*)
  ETHTOOL_STATS_ETH_CTRL eth-ctrl Basic IEEE 802.3 MAC Ctrl statistics (30.3.3.*)
  ETHTOOL_STATS_RMON     rmon     RMON (RFC 2819) statistics
+ ETHTOOL_STATS_XDP      xdp      XDP statistics
  ====================== ======== ===============================================
 
 Each group should have a corresponding ``ETHTOOL_A_STATS_GRP`` in the reply.
@@ -1451,6 +1457,10 @@ Statistics are added to the ``ETHTOOL_A_STATS_GRP`` nest under
 single 8 byte (u64) attribute inside - the type of that attribute is
 the statistic ID and the value is the value of the statistic.
 Each group has its own interpretation of statistic IDs.
+Statistics can be folded into a consistent (non-broken with any other attr)
+sequence of blocks ``ETHTOOL_A_STATS_GRP_STAT_BLOCK``. This way they are
+treated by Ethtool as per-channel statistics, and are printed with the
+"channel%d-" prefix.
 Attribute IDs correspond to strings from the string set identified
 by ``ETHTOOL_A_STATS_GRP_SS_ID``. Complex statistics (such as RMON histogram
 entries) are also listed inside ``ETHTOOL_A_STATS_GRP`` and do not have
@@ -1479,6 +1489,11 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
+Drivers which want to export global (per-device) XDP statistics should
+only implement ``get_xdp_stats`` callback. An additional one
+``get_std_stats_channels`` is needed if the driver exposes per-channel
+statistics.
+
 PHC_VCLOCKS_GET
 ===============
 
-- 
2.31.1

