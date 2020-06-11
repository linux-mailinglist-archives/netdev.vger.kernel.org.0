Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEEE1F6FA2
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgFKVzz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Jun 2020 17:55:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:33217 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgFKVzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 17:55:53 -0400
IronPort-SDR: AvyWbGIqM1ByjehAtoJ24+JaBcpydIJSsHTW/isI5XHzme8DBqYKhkNLoDxgHhJvvnH/wD1THy
 13Ml4bSFE85w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 14:17:51 -0700
IronPort-SDR: 2Zj8osnWKGwK0X/Pc7WNdoOEGZxMr420/hBk8cD7obeSCBriTTZ5WdmQMoHiLLW+QgbOOSdIwW
 6A/9sScSdVhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="473963294"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jun 2020 14:17:50 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX104.amr.corp.intel.com ([169.254.4.173]) with mapi id 14.03.0439.000;
 Thu, 11 Jun 2020 14:17:50 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "klassert@kernel.org" <klassert@kernel.org>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "luobin9@huawei.com" <luobin9@huawei.com>,
        "csully@google.com" <csully@google.com>,
        "kou.ishizaki@toshiba.co.jp" <kou.ishizaki@toshiba.co.jp>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "chessman@tux.org" <chessman@tux.org>
Subject: RE: [RFC 1/8] docs: networking: reorganize driver documentation
 again
Thread-Topic: [RFC 1/8] docs: networking: reorganize driver documentation
 again
Thread-Index: AQHWQBYlZ9b3fqzvSU6P5iNzbYtTL6jT6nZg
Date:   Thu, 11 Jun 2020 21:17:49 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986F4FAE@ORSMSX112.amr.corp.intel.com>
References: <20200611173010.474475-1-kuba@kernel.org>
 <20200611173010.474475-2-kuba@kernel.org>
In-Reply-To: <20200611173010.474475-2-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, June 11, 2020 10:30
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; linux-doc@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; klassert@kernel.org; akiyano@amazon.com;
> irusskikh@marvell.com; ioana.ciornei@nxp.com; kys@microsoft.com;
> saeedm@mellanox.com; jdmason@kudzu.us; snelson@pensando.io; GR-Linux-
> NIC-Dev@marvell.com; stuyoder@gmail.com; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; sgoutham@marvell.com; luobin9@huawei.com;
> csully@google.com; kou.ishizaki@toshiba.co.jp; peppe.cavallaro@st.com;
> chessman@tux.org
> Subject: [RFC 1/8] docs: networking: reorganize driver documentation again
> 
> Organize driver documentation by device type. Most documents
> have fairly verbose yet uninformative names, so let users
> first select a well defined device type, and then search for
> a particular driver.
> 
> While at it rename the section from Vendor drivers to
> Hardware drivers. This seems more accurate, besides people
> sometimes refer to out-of-tree drivers as vendor drivers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: klassert@kernel.org
> CC: akiyano@amazon.com
> CC: irusskikh@marvell.com
> CC: ioana.ciornei@nxp.com
> CC: kys@microsoft.com
> CC: saeedm@mellanox.com
> CC: jdmason@kudzu.us
> CC: snelson@pensando.io
> CC: GR-Linux-NIC-Dev@marvell.com
> CC: stuyoder@gmail.com
> CC: jeffrey.t.kirsher@intel.com
> CC: sgoutham@marvell.com
> CC: luobin9@huawei.com
> CC: csully@google.com
> CC: kou.ishizaki@toshiba.co.jp
> CC: peppe.cavallaro@st.com
> CC: chessman@tux.org
> ---
>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt |  2 +-
>  .../networking/device_drivers/cable/index.rst | 18 +++++
>  .../device_drivers/{ => cable}/sb1000.rst     |  0
>  .../device_drivers/cellular/index.rst         | 18 +++++
>  .../{ => cellular}/qualcomm/rmnet.rst         |  0
>  .../{ => ethernet}/3com/3c509.rst             |  0
>  .../{ => ethernet}/3com/vortex.rst            |  2 -
>  .../{ => ethernet}/amazon/ena.rst             |  0
>  .../{ => ethernet}/aquantia/atlantic.rst      |  0
>  .../{ => ethernet}/chelsio/cxgb.rst           |  0
>  .../{ => ethernet}/cirrus/cs89x0.rst          |  0
>  .../{ => ethernet}/davicom/dm9000.rst         |  0
>  .../{ => ethernet}/dec/de4x5.rst              |  0
>  .../{ => ethernet}/dec/dmfe.rst               |  0
>  .../{ => ethernet}/dlink/dl2k.rst             |  0
>  .../{ => ethernet}/freescale/dpaa.rst         |  0
>  .../freescale/dpaa2/dpio-driver.rst           |  6 +-
>  .../freescale/dpaa2/ethernet-driver.rst       |  3 +-
>  .../{ => ethernet}/freescale/dpaa2/index.rst  |  0
>  .../freescale/dpaa2/mac-phy-support.rst       |  0
>  .../freescale/dpaa2/overview.rst              |  0
>  .../{ => ethernet}/freescale/gianfar.rst      |  0
>  .../{ => ethernet}/google/gve.rst             |  0
>  .../device_drivers/ethernet/index.rst         | 58 ++++++++++++++++
>  .../{ => ethernet}/intel/e100.rst             |  0
>  .../{ => ethernet}/intel/e1000.rst            |  0
>  .../{ => ethernet}/intel/e1000e.rst           |  0
>  .../{ => ethernet}/intel/fm10k.rst            |  0
>  .../{ => ethernet}/intel/i40e.rst             |  0
>  .../{ => ethernet}/intel/iavf.rst             |  0
>  .../{ => ethernet}/intel/ice.rst              |  0
>  .../{ => ethernet}/intel/igb.rst              |  0
>  .../{ => ethernet}/intel/igbvf.rst            |  0
>  .../{ => ethernet}/intel/ixgb.rst             |  0
>  .../{ => ethernet}/intel/ixgbe.rst            |  0
>  .../{ => ethernet}/intel/ixgbevf.rst          |  0
>  .../{ => ethernet}/marvell/octeontx2.rst      |  0
>  .../{ => ethernet}/mellanox/mlx5.rst          |  0
>  .../{ => ethernet}/microsoft/netvsc.rst       |  0
>  .../{ => ethernet}/neterion/s2io.rst          |  0
>  .../{ => ethernet}/neterion/vxge.rst          |  0
>  .../{ => ethernet}/netronome/nfp.rst          |  0
>  .../{ => ethernet}/pensando/ionic.rst         |  0
>  .../{ => ethernet}/smsc/smc9.rst              |  0
>  .../{ => ethernet}/stmicro/stmmac.rst         |  0
>  .../device_drivers/{ => ethernet}/ti/cpsw.rst |  0
>  .../{ => ethernet}/ti/cpsw_switchdev.rst      |  0
>  .../device_drivers/{ => ethernet}/ti/tlan.rst |  0
>  .../{ => ethernet}/toshiba/spider_net.rst     |  0
>  .../networking/device_drivers/index.rst       | 51 ++------------
>  .../networking/device_drivers/wifi/index.rst  | 19 ++++++
>  .../{ => wifi}/intel/ipw2100.rst              |  0
>  .../{ => wifi}/intel/ipw2200.rst              |  0
>  MAINTAINERS                                   | 66 +++++++++----------
>  drivers/net/Kconfig                           |  2 +-
>  drivers/net/ethernet/3com/3c59x.c             |  4 +-
>  drivers/net/ethernet/3com/Kconfig             |  4 +-
>  drivers/net/ethernet/chelsio/Kconfig          |  2 +-
>  drivers/net/ethernet/cirrus/Kconfig           |  2 +-
>  drivers/net/ethernet/dec/tulip/Kconfig        |  4 +-
>  drivers/net/ethernet/dlink/dl2k.c             | 10 +--
>  drivers/net/ethernet/intel/Kconfig            | 24 +++----
>  drivers/net/ethernet/neterion/Kconfig         |  4 +-
>  drivers/net/ethernet/pensando/Kconfig         |  2 +-
>  drivers/net/ethernet/smsc/Kconfig             |  4 +-
>  drivers/net/ethernet/ti/Kconfig               |  2 +-
>  drivers/net/ethernet/ti/tlan.c                |  2 +-
>  drivers/net/wireless/intel/ipw2x00/Kconfig    |  4 +-
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  2 +-
>  69 files changed, 191 insertions(+), 124 deletions(-)
>  create mode 100644 Documentation/networking/device_drivers/cable/index.rst
>  rename Documentation/networking/device_drivers/{ => cable}/sb1000.rst
> (100%)
>  create mode 100644
> Documentation/networking/device_drivers/cellular/index.rst
>  rename Documentation/networking/device_drivers/{ =>
> cellular}/qualcomm/rmnet.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/3com/3c509.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/3com/vortex.rst (99%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/amazon/ena.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/aquantia/atlantic.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/chelsio/cxgb.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/cirrus/cs89x0.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/davicom/dm9000.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/dec/de4x5.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/dec/dmfe.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/dlink/dl2k.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/dpaa.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/dpaa2/dpio-driver.rst (97%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/dpaa2/ethernet-driver.rst (98%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/dpaa2/index.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/dpaa2/mac-phy-support.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/dpaa2/overview.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/freescale/gianfar.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/google/gve.rst (100%)
>  create mode 100644
> Documentation/networking/device_drivers/ethernet/index.rst
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/e100.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/e1000.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/e1000e.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/fm10k.rst (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/intel/i40e.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/intel/iavf.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/intel/ice.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/intel/igb.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/igbvf.rst (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/intel/ixgb.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/ixgbe.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/intel/ixgbevf.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/marvell/octeontx2.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/mellanox/mlx5.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/microsoft/netvsc.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/neterion/s2io.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/neterion/vxge.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/netronome/nfp.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/pensando/ionic.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/smsc/smc9.rst (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/stmicro/stmmac.rst (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/ti/cpsw.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/ti/cpsw_switchdev.rst (100%)
>  rename Documentation/networking/device_drivers/{ => ethernet}/ti/tlan.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ =>
> ethernet}/toshiba/spider_net.rst (100%)
>  create mode 100644 Documentation/networking/device_drivers/wifi/index.rst
>  rename Documentation/networking/device_drivers/{ => wifi}/intel/ipw2100.rst
> (100%)
>  rename Documentation/networking/device_drivers/{ => wifi}/intel/ipw2200.rst
> (100%)
> 
> diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> index 9134e9bcca56..b12f9be1251f 100644
> --- a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> +++ b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> @@ -10,7 +10,7 @@ such as network interfaces, crypto accelerator instances,
> L2 switches,
>  etc.
> 
>  For an overview of the DPAA2 architecture and fsl-mc bus see:
> -Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> +Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.
> rst
> 
>  As described in the above overview, all DPAA2 objects in a DPRC share the
>  same hardware "isolation context" and a 10-bit value called an ICID
> diff --git a/Documentation/networking/device_drivers/cable/index.rst
> b/Documentation/networking/device_drivers/cable/index.rst
> new file mode 100644
> index 000000000000..cce3c4392972
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/cable/index.rst
> @@ -0,0 +1,18 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +Cable Modem Device Drivers
> +==========================
> +
> +Contents:
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   sb1000
> +
> +.. only::  subproject and html
> +
> +   Indices
> +   =======
> +
> +   * :ref:`genindex`
> diff --git a/Documentation/networking/device_drivers/sb1000.rst
> b/Documentation/networking/device_drivers/cable/sb1000.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/sb1000.rst
> rename to Documentation/networking/device_drivers/cable/sb1000.rst
> diff --git a/Documentation/networking/device_drivers/cellular/index.rst
> b/Documentation/networking/device_drivers/cellular/index.rst
> new file mode 100644
> index 000000000000..fc1812d3fc70
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/cellular/index.rst
> @@ -0,0 +1,18 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +Cellular Modem Device Drivers
> +=============================
> +
> +Contents:
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   qualcomm/rmnet
> +
> +.. only::  subproject and html
> +
> +   Indices
> +   =======
> +
> +   * :ref:`genindex`
> diff --git a/Documentation/networking/device_drivers/qualcomm/rmnet.rst
> b/Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/qualcomm/rmnet.rst
> rename to
> Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
> diff --git a/Documentation/networking/device_drivers/3com/3c509.rst
> b/Documentation/networking/device_drivers/ethernet/3com/3c509.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/3com/3c509.rst
> rename to Documentation/networking/device_drivers/ethernet/3com/3c509.rst
> diff --git a/Documentation/networking/device_drivers/3com/vortex.rst
> b/Documentation/networking/device_drivers/ethernet/3com/vortex.rst
> similarity index 99%
> rename from Documentation/networking/device_drivers/3com/vortex.rst
> rename to Documentation/networking/device_drivers/ethernet/3com/vortex.rst
> index 800add5be338..eab10fc6da5c 100644
> --- a/Documentation/networking/device_drivers/3com/vortex.rst
> +++ b/Documentation/networking/device_drivers/ethernet/3com/vortex.rst
> @@ -4,8 +4,6 @@
>  3Com Vortex device driver
>  =========================
> 
> -Documentation/networking/device_drivers/3com/vortex.rst
> -
>  Andrew Morton
> 
>  30 April 2000
> diff --git a/Documentation/networking/device_drivers/amazon/ena.rst
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/amazon/ena.rst
> rename to Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> diff --git a/Documentation/networking/device_drivers/aquantia/atlantic.rst
> b/Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/aquantia/atlantic.rst
> rename to
> Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
> diff --git a/Documentation/networking/device_drivers/chelsio/cxgb.rst
> b/Documentation/networking/device_drivers/ethernet/chelsio/cxgb.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/chelsio/cxgb.rst
> rename to Documentation/networking/device_drivers/ethernet/chelsio/cxgb.rst
> diff --git a/Documentation/networking/device_drivers/cirrus/cs89x0.rst
> b/Documentation/networking/device_drivers/ethernet/cirrus/cs89x0.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/cirrus/cs89x0.rst
> rename to Documentation/networking/device_drivers/ethernet/cirrus/cs89x0.rst
> diff --git a/Documentation/networking/device_drivers/davicom/dm9000.rst
> b/Documentation/networking/device_drivers/ethernet/davicom/dm9000.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/davicom/dm9000.rst
> rename to
> Documentation/networking/device_drivers/ethernet/davicom/dm9000.rst
> diff --git a/Documentation/networking/device_drivers/dec/de4x5.rst
> b/Documentation/networking/device_drivers/ethernet/dec/de4x5.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/dec/de4x5.rst
> rename to Documentation/networking/device_drivers/ethernet/dec/de4x5.rst
> diff --git a/Documentation/networking/device_drivers/dec/dmfe.rst
> b/Documentation/networking/device_drivers/ethernet/dec/dmfe.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/dec/dmfe.rst
> rename to Documentation/networking/device_drivers/ethernet/dec/dmfe.rst
> diff --git a/Documentation/networking/device_drivers/dlink/dl2k.rst
> b/Documentation/networking/device_drivers/ethernet/dlink/dl2k.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/dlink/dl2k.rst
> rename to Documentation/networking/device_drivers/ethernet/dlink/dl2k.rst
> diff --git a/Documentation/networking/device_drivers/freescale/dpaa.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/freescale/dpaa.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/dpaa.rst
> diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/dpio-
> driver.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/dpio-
> driver.rst
> similarity index 97%
> rename from Documentation/networking/device_drivers/freescale/dpaa2/dpio-
> driver.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/dpaa2/dpio-
> driver.rst
> index 17dbee1ac53e..c50fd46631e0 100644
> --- a/Documentation/networking/device_drivers/freescale/dpaa2/dpio-driver.rst
> +++
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/dpio-
> driver.rst
> @@ -19,8 +19,10 @@ pool management for network interfaces.
>  This document provides an overview the Linux DPIO driver, its
>  subcomponents, and its APIs.
> 
> -See Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> for
> -a general overview of DPAA2 and the general DPAA2 driver architecture in
> Linux.
> +See
> +Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.
> rst
> +for a general overview of DPAA2 and the general DPAA2 driver architecture
> +in Linux.
> 
>  Driver Overview
>  ---------------
> diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/ethernet-
> driver.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ethernet-
> driver.rst
> similarity index 98%
> rename from
> Documentation/networking/device_drivers/freescale/dpaa2/ethernet-driver.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ethernet-
> driver.rst
> index cb4c9a0c5a17..682f3986c15b 100644
> --- a/Documentation/networking/device_drivers/freescale/dpaa2/ethernet-
> driver.rst
> +++
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ethernet-
> driver.rst
> @@ -33,7 +33,8 @@ hardware resources, like queues, do not have a
> corresponding MC object and
>  are treated as internal resources of other objects.
> 
>  For a more detailed description of the DPAA2 architecture and its object
> -abstractions see
> *Documentation/networking/device_drivers/freescale/dpaa2/overview.rst*.
> +abstractions see
> +*Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overvie
> w.rst*.
> 
>  Each Linux net device is built on top of a Datapath Network Interface (DPNI)
>  object and uses Buffer Pools (DPBPs), I/O Portals (DPIOs) and Concentrators
> diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/index.rst
> similarity index 100%
> rename from
> Documentation/networking/device_drivers/freescale/dpaa2/index.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/dpaa2/index.rst
> diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> support.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-
> support.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/freescale/dpaa2/mac-
> phy-support.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-
> support.rst
> diff --git
> a/Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview
> .rst
> similarity index 100%
> rename from
> Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rs
> t
> diff --git a/Documentation/networking/device_drivers/freescale/gianfar.rst
> b/Documentation/networking/device_drivers/ethernet/freescale/gianfar.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/freescale/gianfar.rst
> rename to
> Documentation/networking/device_drivers/ethernet/freescale/gianfar.rst
> diff --git a/Documentation/networking/device_drivers/google/gve.rst
> b/Documentation/networking/device_drivers/ethernet/google/gve.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/google/gve.rst
> rename to Documentation/networking/device_drivers/ethernet/google/gve.rst
> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst
> b/Documentation/networking/device_drivers/ethernet/index.rst
> new file mode 100644
> index 000000000000..fd3873024da8
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -0,0 +1,58 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +Ethernet Device Drivers
> +=======================
> +
> +Device drivers for Ethernet and Ethernet-based virtual function devices.
> +
> +Contents:
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   3com/3c509
> +   3com/vortex
> +   amazon/ena
> +   aquantia/atlantic
> +   chelsio/cxgb
> +   cirrus/cs89x0
> +   dlink/dl2k
> +   davicom/dm9000
> +   dec/de4x5
> +   dec/dmfe
> +   freescale/dpaa
> +   freescale/dpaa2/index
> +   freescale/gianfar
> +   google/gve
> +   intel/e100
> +   intel/e1000
> +   intel/e1000e
> +   intel/fm10k
> +   intel/igb
> +   intel/igbvf
> +   intel/ixgb
> +   intel/ixgbe
> +   intel/ixgbevf
> +   intel/i40e
> +   intel/iavf
> +   intel/ice
> +   marvell/octeontx2
> +   mellanox/mlx5
> +   microsoft/netvsc
> +   neterion/s2io
> +   neterion/vxge
> +   netronome/nfp
> +   pensando/ionic
> +   smsc/smc9
> +   stmicro/stmmac
> +   ti/cpsw
> +   ti/cpsw_switchdev
> +   ti/tlan
> +   toshiba/spider_net
> +
> +.. only::  subproject and html
> +
> +   Indices
> +   =======
> +
> +   * :ref:`genindex`
> diff --git a/Documentation/networking/device_drivers/intel/e100.rst
> b/Documentation/networking/device_drivers/ethernet/intel/e100.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/e100.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/e100.rst
> diff --git a/Documentation/networking/device_drivers/intel/e1000.rst
> b/Documentation/networking/device_drivers/ethernet/intel/e1000.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/e1000.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/e1000.rst
> diff --git a/Documentation/networking/device_drivers/intel/e1000e.rst
> b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/e1000e.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> diff --git a/Documentation/networking/device_drivers/intel/fm10k.rst
> b/Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/fm10k.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
> diff --git a/Documentation/networking/device_drivers/intel/i40e.rst
> b/Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/i40e.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> diff --git a/Documentation/networking/device_drivers/intel/iavf.rst
> b/Documentation/networking/device_drivers/ethernet/intel/iavf.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/iavf.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/iavf.rst
> diff --git a/Documentation/networking/device_drivers/intel/ice.rst
> b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/ice.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/ice.rst
> diff --git a/Documentation/networking/device_drivers/intel/igb.rst
> b/Documentation/networking/device_drivers/ethernet/intel/igb.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/igb.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/igb.rst
> diff --git a/Documentation/networking/device_drivers/intel/igbvf.rst
> b/Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/igbvf.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
> diff --git a/Documentation/networking/device_drivers/intel/ixgb.rst
> b/Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/ixgb.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> diff --git a/Documentation/networking/device_drivers/intel/ixgbe.rst
> b/Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/ixgbe.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
> diff --git a/Documentation/networking/device_drivers/intel/ixgbevf.rst
> b/Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/ixgbevf.rst
> rename to Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
> diff --git a/Documentation/networking/device_drivers/marvell/octeontx2.rst
> b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/marvell/octeontx2.rst
> rename to
> Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst
> b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/mellanox/mlx5.rst
> rename to
> Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
> diff --git a/Documentation/networking/device_drivers/microsoft/netvsc.rst
> b/Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/microsoft/netvsc.rst
> rename to
> Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst
> diff --git a/Documentation/networking/device_drivers/neterion/s2io.rst
> b/Documentation/networking/device_drivers/ethernet/neterion/s2io.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/neterion/s2io.rst
> rename to Documentation/networking/device_drivers/ethernet/neterion/s2io.rst
> diff --git a/Documentation/networking/device_drivers/neterion/vxge.rst
> b/Documentation/networking/device_drivers/ethernet/neterion/vxge.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/neterion/vxge.rst
> rename to Documentation/networking/device_drivers/ethernet/neterion/vxge.rst
> diff --git a/Documentation/networking/device_drivers/netronome/nfp.rst
> b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/netronome/nfp.rst
> rename to
> Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
> diff --git a/Documentation/networking/device_drivers/pensando/ionic.rst
> b/Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/pensando/ionic.rst
> rename to
> Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
> diff --git a/Documentation/networking/device_drivers/smsc/smc9.rst
> b/Documentation/networking/device_drivers/ethernet/smsc/smc9.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/smsc/smc9.rst
> rename to Documentation/networking/device_drivers/ethernet/smsc/smc9.rst
> diff --git a/Documentation/networking/device_drivers/stmicro/stmmac.rst
> b/Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/stmicro/stmmac.rst
> rename to
> Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst
> diff --git a/Documentation/networking/device_drivers/ti/cpsw.rst
> b/Documentation/networking/device_drivers/ethernet/ti/cpsw.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/ti/cpsw.rst
> rename to Documentation/networking/device_drivers/ethernet/ti/cpsw.rst
> diff --git a/Documentation/networking/device_drivers/ti/cpsw_switchdev.rst
> b/Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/ti/cpsw_switchdev.rst
> rename to
> Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst
> diff --git a/Documentation/networking/device_drivers/ti/tlan.rst
> b/Documentation/networking/device_drivers/ethernet/ti/tlan.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/ti/tlan.rst
> rename to Documentation/networking/device_drivers/ethernet/ti/tlan.rst
> diff --git a/Documentation/networking/device_drivers/toshiba/spider_net.rst
> b/Documentation/networking/device_drivers/ethernet/toshiba/spider_net.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/toshiba/spider_net.rst
> rename to
> Documentation/networking/device_drivers/ethernet/toshiba/spider_net.rst
> diff --git a/Documentation/networking/device_drivers/index.rst
> b/Documentation/networking/device_drivers/index.rst
> index e18dad11bc72..2d4817fc6a29 100644
> --- a/Documentation/networking/device_drivers/index.rst
> +++ b/Documentation/networking/device_drivers/index.rst
> @@ -1,56 +1,17 @@
>  .. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> 
> -Vendor Device Drivers
> -=====================
> +Hardware Device Drivers
> +=======================
> 
>  Contents:
> 
>  .. toctree::
>     :maxdepth: 2
> 
> -   freescale/dpaa2/index
> -   intel/e100
> -   intel/e1000
> -   intel/e1000e
> -   intel/fm10k
> -   intel/igb
> -   intel/igbvf
> -   intel/ixgb
> -   intel/ixgbe
> -   intel/ixgbevf
> -   intel/i40e
> -   intel/iavf
> -   intel/ice
> -   google/gve
> -   marvell/octeontx2
> -   mellanox/mlx5
> -   netronome/nfp
> -   pensando/ionic
> -   stmicro/stmmac
> -   3com/3c509
> -   3com/vortex
> -   amazon/ena
> -   aquantia/atlantic
> -   chelsio/cxgb
> -   cirrus/cs89x0
> -   davicom/dm9000
> -   dec/de4x5
> -   dec/dmfe
> -   dlink/dl2k
> -   freescale/dpaa
> -   freescale/gianfar
> -   intel/ipw2100
> -   intel/ipw2200
> -   microsoft/netvsc
> -   neterion/s2io
> -   neterion/vxge
> -   qualcomm/rmnet
> -   sb1000
> -   smsc/smc9
> -   ti/cpsw_switchdev
> -   ti/cpsw
> -   ti/tlan
> -   toshiba/spider_net
> +   cable/index
> +   cellular/index
> +   ethernet/index
> +   wifi/index
> 
>  .. only::  subproject and html
> 
> diff --git a/Documentation/networking/device_drivers/wifi/index.rst
> b/Documentation/networking/device_drivers/wifi/index.rst
> new file mode 100644
> index 000000000000..fb394f5de4a9
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/wifi/index.rst
> @@ -0,0 +1,19 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +Wi-Fi Device Drivers
> +====================
> +
> +Contents:
> +
> +.. toctree::
> +   :maxdepth: 2
> +
> +   intel/ipw2100
> +   intel/ipw2200
> +
> +.. only::  subproject and html
> +
> +   Indices
> +   =======
> +
> +   * :ref:`genindex`
> diff --git a/Documentation/networking/device_drivers/intel/ipw2100.rst
> b/Documentation/networking/device_drivers/wifi/intel/ipw2100.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/ipw2100.rst
> rename to Documentation/networking/device_drivers/wifi/intel/ipw2100.rst
> diff --git a/Documentation/networking/device_drivers/intel/ipw2200.rst
> b/Documentation/networking/device_drivers/wifi/intel/ipw2200.rst
> similarity index 100%
> rename from Documentation/networking/device_drivers/intel/ipw2200.rst
> rename to Documentation/networking/device_drivers/wifi/intel/ipw2200.rst
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f08f290df174..154a6d34257e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -147,7 +147,7 @@ Maintainers List
>  M:	Steffen Klassert <klassert@kernel.org>
>  L:	netdev@vger.kernel.org
>  S:	Odd Fixes
> -F:	Documentation/networking/device_drivers/3com/vortex.rst
> +F:	Documentation/networking/device_drivers/ethernet/3com/vortex.rst
>  F:	drivers/net/ethernet/3com/3c59x.c
> 
>  3CR990 NETWORK DRIVER
> @@ -816,7 +816,7 @@ R:	Saeed Bishara <saeedb@amazon.com>
>  R:	Zorik Machulsky <zorik@amazon.com>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/amazon/ena.rst
> +F:	Documentation/networking/device_drivers/ethernet/amazon/ena.rst
>  F:	drivers/net/ethernet/amazon/
> 
>  AMAZON RDMA EFA DRIVER
> @@ -1295,7 +1295,7 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  W:	https://www.marvell.com/
>  Q:	http://patchwork.ozlabs.org/project/netdev/list/
> -F:	Documentation/networking/device_drivers/aquantia/atlantic.rst
> +F:	Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
>  F:	drivers/net/ethernet/aquantia/atlantic/
> 
>  AQUANTIA ETHERNET DRIVER PTP SUBSYSTEM
> @@ -4733,7 +4733,7 @@ F:	net/ax25/sysctl_net_ax25.c
>  DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
>  L:	netdev@vger.kernel.org
>  S:	Orphan
> -F:	Documentation/networking/device_drivers/dec/dmfe.rst
> +F:	Documentation/networking/device_drivers/ethernet/dec/dmfe.rst
>  F:	drivers/net/ethernet/dec/tulip/dmfe.c
> 
>  DC390/AM53C974 SCSI driver
> @@ -5221,8 +5221,8 @@ M:	Ioana Ciornei <ioana.ciornei@nxp.com>
>  M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/networking/device_drivers/freescale/dpaa2/ethernet-
> driver.rst
> -F:	Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-
> support.rst
> +F:
> 	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ethe
> rnet-driver.rst
> +F:
> 	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac
> -phy-support.rst
>  F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
>  F:	drivers/net/ethernet/freescale/dpaa2/Makefile
>  F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-eth*
> @@ -7282,7 +7282,7 @@ R:	Sagi Shahar <sagis@google.com>
>  R:	Jon Olson <jonolson@google.com>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/google/gve.rst
> +F:	Documentation/networking/device_drivers/ethernet/google/gve.rst
>  F:	drivers/net/ethernet/google
> 
>  GPD POCKET FAN DRIVER
> @@ -7945,7 +7945,7 @@ S:	Supported
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git
>  F:	Documentation/ABI/stable/sysfs-bus-vmbus
>  F:	Documentation/ABI/testing/debugfs-hyperv
> -F:	Documentation/networking/device_drivers/microsoft/netvsc.rst
> +F:	Documentation/networking/device_drivers/ethernet/microsoft/netvsc.rst
>  F:	arch/x86/hyperv
>  F:	arch/x86/include/asm/hyperv-tlfs.h
>  F:	arch/x86/include/asm/mshyperv.h
> @@ -8626,18 +8626,18 @@ W:	http://e1000.sourceforge.net/
>  Q:	http://patchwork.ozlabs.org/project/intel-wired-lan/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue.git
> -F:	Documentation/networking/device_drivers/intel/e100.rst
> -F:	Documentation/networking/device_drivers/intel/e1000.rst
> -F:	Documentation/networking/device_drivers/intel/e1000e.rst
> -F:	Documentation/networking/device_drivers/intel/fm10k.rst
> -F:	Documentation/networking/device_drivers/intel/i40e.rst
> -F:	Documentation/networking/device_drivers/intel/iavf.rst
> -F:	Documentation/networking/device_drivers/intel/ice.rst
> -F:	Documentation/networking/device_drivers/intel/igb.rst
> -F:	Documentation/networking/device_drivers/intel/igbvf.rst
> -F:	Documentation/networking/device_drivers/intel/ixgb.rst
> -F:	Documentation/networking/device_drivers/intel/ixgbe.rst
> -F:	Documentation/networking/device_drivers/intel/ixgbevf.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/e100.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/e1000.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/fm10k.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/i40e.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/iavf.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/ice.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/igb.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/igbvf.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst
> +F:	Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst
[Kirsher, Jeffrey T] 

With this patch, the above MAINTAIERS entries can be reduced to a single line.  This can now become:

F: Documentation/networking/device_drivers/ethernet/intel/*

No need to list out all the documented files now that I support/maintain all documentation in the above folder.

>  F:	drivers/net/ethernet/intel/
>  F:	drivers/net/ethernet/intel/*/
>  F:	include/linux/avf/virtchnl.h
> @@ -8828,8 +8828,8 @@ INTEL PRO/WIRELESS 2100, 2200BG, 2915ABG
> NETWORK CONNECTION SUPPORT
>  M:	Stanislav Yakovlev <stas.yakovlev@gmail.com>
>  L:	linux-wireless@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/networking/device_drivers/intel/ipw2100.rst
> -F:	Documentation/networking/device_drivers/intel/ipw2200.rst
> +F:	Documentation/networking/device_drivers/wifi/intel/ipw2100.rst
> +F:	Documentation/networking/device_drivers/wifi/intel/ipw2200.rst
>  F:	drivers/net/wireless/intel/ipw2x00/
> 
>  INTEL PSTATE DRIVER
> @@ -10331,7 +10331,7 @@ M:	Geetha sowjanya <gakula@marvell.com>
>  M:	Jerin Jacob <jerinj@marvell.com>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/marvell/octeontx2.rst
> +F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
>  F:	drivers/net/ethernet/marvell/octeontx2/af/
> 
>  MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
> @@ -11001,7 +11001,7 @@ L:	linux-rdma@vger.kernel.org
>  S:	Supported
>  W:	http://www.mellanox.com
>  Q:	http://patchwork.ozlabs.org/project/netdev/list/
> -F:	Documentation/networking/device_drivers/mellanox/
> +F:	Documentation/networking/device_drivers/ethernet/mellanox/
>  F:	drivers/net/ethernet/mellanox/mlx5/core/
>  F:	include/linux/mlx5/
> 
> @@ -11784,8 +11784,8 @@ NETERION 10GbE DRIVERS (s2io/vxge)
>  M:	Jon Mason <jdmason@kudzu.us>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/neterion/s2io.rst
> -F:	Documentation/networking/device_drivers/neterion/vxge.rst
> +F:	Documentation/networking/device_drivers/ethernet/neterion/s2io.rst
> +F:	Documentation/networking/device_drivers/ethernet/neterion/vxge.rst
>  F:	drivers/net/ethernet/neterion/
> 
>  NETFILTER
> @@ -13336,7 +13336,7 @@ M:	Shannon Nelson <snelson@pensando.io>
>  M:	Pensando Drivers <drivers@pensando.io>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/pensando/ionic.rst
> +F:	Documentation/networking/device_drivers/ethernet/pensando/ionic.rst
>  F:	drivers/net/ethernet/pensando/
> 
>  PER-CPU MEMORY ALLOCATOR
> @@ -14018,7 +14018,7 @@ QLOGIC QLA3XXX NETWORK DRIVER
>  M:	GR-Linux-NIC-Dev@marvell.com
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/qlogic/LICENSE.qla3xxx
> +F:
> 	Documentation/networking/device_drivers/ethernet/qlogic/LICENSE.qla3x
> xx
>  F:	drivers/net/ethernet/qlogic/qla3xxx.*
> 
>  QLOGIC QLA4XXX iSCSI DRIVER
> @@ -14069,7 +14069,7 @@ M:	Laurentiu Tudor
> <laurentiu.tudor@nxp.com>
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> -F:	Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> +F:
> 	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/over
> view.rst
>  F:	drivers/bus/fsl-mc/
> 
>  QT1010 MEDIA DRIVER
> @@ -14173,7 +14173,7 @@ M:	Subash Abhinov Kasiviswanathan
> <subashab@codeaurora.org>
>  M:	Sean Tranchetti <stranche@codeaurora.org>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/networking/device_drivers/qualcomm/rmnet.rst
> +F:	Documentation/networking/device_drivers/cellular/qualcomm/rmnet.rst
>  F:	drivers/net/ethernet/qualcomm/rmnet/
>  F:	include/linux/if_rmnet.h
> 
> @@ -16043,7 +16043,7 @@ SPIDERNET NETWORK DRIVER for CELL
>  M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
>  L:	netdev@vger.kernel.org
>  S:	Supported
> -F:	Documentation/networking/device_drivers/toshiba/spider_net.rst
> +F:
> 	Documentation/networking/device_drivers/ethernet/toshiba/spider_net.rs
> t
>  F:	drivers/net/ethernet/toshiba/spider_net*
> 
>  SPMI SUBSYSTEM
> @@ -16270,7 +16270,7 @@ M:	Jose Abreu <joabreu@synopsys.com>
>  L:	netdev@vger.kernel.org
>  S:	Supported
>  W:	http://www.stlinux.com
> -F:	Documentation/networking/device_drivers/stmicro/
> +F:	Documentation/networking/device_drivers/ethernet/stmicro/
>  F:	drivers/net/ethernet/stmicro/stmmac/
> 
>  SUN3/3X
> @@ -17158,7 +17158,7 @@ M:	Samuel Chessman <chessman@tux.org>
>  L:	tlan-devel@lists.sourceforge.net (subscribers-only)
>  S:	Maintained
>  W:	http://sourceforge.net/projects/tlan/
> -F:	Documentation/networking/device_drivers/ti/tlan.rst
> +F:	Documentation/networking/device_drivers/ethernet/ti/tlan.rst
>  F:	drivers/net/ethernet/ti/tlan.*
> 
>  TM6000 VIDEO4LINUX DRIVER
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index c7d310ef1c83..962dcd044f1b 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -460,7 +460,7 @@ config NET_SB1000
> 
>  	  At present this driver only compiles as a module, so say M here if
>  	  you have this card. The module will be called sb1000. Then read
> -	  <file:Documentation/networking/device_drivers/sb1000.rst> for
> +	  <file:Documentation/networking/device_drivers/cable/sb1000.rst> for
>  	  information on how to use this module, as it needs special ppp
>  	  scripts for establishing a connection. Further documentation
>  	  and the necessary scripts can be found at:
> diff --git a/drivers/net/ethernet/3com/3c59x.c
> b/drivers/net/ethernet/3com/3c59x.c
> index 5984b7033999..741c67e546d4 100644
> --- a/drivers/net/ethernet/3com/3c59x.c
> +++ b/drivers/net/ethernet/3com/3c59x.c
> @@ -1149,7 +1149,7 @@ static int vortex_probe1(struct device *gendev, void
> __iomem *ioaddr, int irq,
> 
>  	print_info = (vortex_debug > 1);
>  	if (print_info)
> -		pr_info("See
> Documentation/networking/device_drivers/3com/vortex.rst\n");
> +		pr_info("See
> Documentation/networking/device_drivers/ethernet/3com/vortex.rst\n");
> 
>  	pr_info("%s: 3Com %s %s at %p.\n",
>  	       print_name,
> @@ -1954,7 +1954,7 @@ vortex_error(struct net_device *dev, int status)
>  				   dev->name, tx_status);
>  			if (tx_status == 0x82) {
>  				pr_err("Probably a duplex mismatch.  See "
> -
> 	"Documentation/networking/device_drivers/3com/vortex.rst\n");
> +
> 	"Documentation/networking/device_drivers/ethernet/3com/vortex.rst\n")
> ;
>  			}
>  			dump_tx_ring(dev);
>  		}
> diff --git a/drivers/net/ethernet/3com/Kconfig
> b/drivers/net/ethernet/3com/Kconfig
> index 7cc259893cb9..c5958c515d06 100644
> --- a/drivers/net/ethernet/3com/Kconfig
> +++ b/drivers/net/ethernet/3com/Kconfig
> @@ -76,8 +76,8 @@ config VORTEX
>  	  "Hurricane" (3c555/3cSOHO)                           PCI
> 
>  	  If you have such a card, say Y here.  More specific information is in
> -	  <file:Documentation/networking/device_drivers/3com/vortex.rst> and
> -	  in the comments at the beginning of
> +
> <file:Documentation/networking/device_drivers/ethernet/3com/vortex.rst>
> +	  and in the comments at the beginning of
>  	  <file:drivers/net/ethernet/3com/3c59x.c>.
> 
>  	  To compile this support as a module, choose M here.
> diff --git a/drivers/net/ethernet/chelsio/Kconfig
> b/drivers/net/ethernet/chelsio/Kconfig
> index 82cdfa51ce37..238246924e0d 100644
> --- a/drivers/net/ethernet/chelsio/Kconfig
> +++ b/drivers/net/ethernet/chelsio/Kconfig
> @@ -26,7 +26,7 @@ config CHELSIO_T1
>  	  This driver supports Chelsio gigabit and 10-gigabit
>  	  Ethernet cards. More information about adapter features and
>  	  performance tuning is in
> -	  <file:Documentation/networking/device_drivers/chelsio/cxgb.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/chelsio/cxgb.rst>.
> 
>  	  For general information about Chelsio and our products, visit
>  	  our website at <http://www.chelsio.com>.
> diff --git a/drivers/net/ethernet/cirrus/Kconfig
> b/drivers/net/ethernet/cirrus/Kconfig
> index 8d845f5ee0c5..a0280d26d4cd 100644
> --- a/drivers/net/ethernet/cirrus/Kconfig
> +++ b/drivers/net/ethernet/cirrus/Kconfig
> @@ -24,7 +24,7 @@ config CS89x0
>  	---help---
>  	  Support for CS89x0 chipset based Ethernet cards. If you have a
>  	  network (Ethernet) card of this type, say Y and read the file
> -	  <file:Documentation/networking/device_drivers/cirrus/cs89x0.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/cirrus/cs89x0.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called cs89x0.
> diff --git a/drivers/net/ethernet/dec/tulip/Kconfig
> b/drivers/net/ethernet/dec/tulip/Kconfig
> index 177f36f4b89d..5185cbe11b17 100644
> --- a/drivers/net/ethernet/dec/tulip/Kconfig
> +++ b/drivers/net/ethernet/dec/tulip/Kconfig
> @@ -114,7 +114,7 @@ config DE4X5
>  	  These include the DE425, DE434, DE435, DE450 and DE500 models.  If
>  	  you have a network card of this type, say Y.  More specific
>  	  information is contained in
> -	  <file:Documentation/networking/device_drivers/dec/de4x5.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/dec/de4x5.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module will
>  	  be called de4x5.
> @@ -138,7 +138,7 @@ config DM9102
>  	  This driver is for DM9102(A)/DM9132/DM9801 compatible PCI cards
> from
>  	  Davicom (<http://www.davicom.com.tw/>).  If you have such a
> network
>  	  (Ethernet) card, say Y.  Some information is contained in the file
> -	  <file:Documentation/networking/device_drivers/dec/dmfe.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/dec/dmfe.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module will
>  	  be called dmfe.
> diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
> index 5143722c4419..be6d8a9ada27 100644
> --- a/drivers/net/ethernet/dlink/dl2k.c
> +++ b/drivers/net/ethernet/dlink/dl2k.c
> @@ -1863,13 +1863,5 @@ static struct pci_driver rio_driver = {
>  };
> 
>  module_pci_driver(rio_driver);
> -/*
> -
> -Compile command:
> -
> -gcc -D__KERNEL__ -DMODULE -I/usr/src/linux/include -Wall -Wstrict-prototypes
> -O2 -c dl2k.c
> -
> -Read Documentation/networking/device_drivers/dlink/dl2k.rst for details.
> -
> -*/
> 
> +/* Read Documentation/networking/device_drivers/ethernet/dlink/dl2k.rst. */
> diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
> index ad34e4335df2..a6cdd652489d 100644
> --- a/drivers/net/ethernet/intel/Kconfig
> +++ b/drivers/net/ethernet/intel/Kconfig
> @@ -34,7 +34,7 @@ config E100
>  	  to identify the adapter.
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/e100.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/e100.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called e100.
> @@ -50,7 +50,7 @@ config E1000
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/e1000.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/e1000.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called e1000.
> @@ -70,7 +70,7 @@ config E1000E
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/e1000e.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/e1000e.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called e1000e.
> @@ -98,7 +98,7 @@ config IGB
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/igb.rst>.
> +	  <file:Documentation/networking/device_drivers/ethernet/intel/igb.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called igb.
> @@ -134,7 +134,7 @@ config IGBVF
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/igbvf.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/igbvf.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called igbvf.
> @@ -151,7 +151,7 @@ config IXGB
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/ixgb.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/ixgb.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called ixgb.
> @@ -170,7 +170,7 @@ config IXGBE
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/ixgbe.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/ixgbe.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called ixgbe.
> @@ -222,7 +222,7 @@ config IXGBEVF
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/ixgbevf.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/ixgbevf.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called ixgbevf.  MSI-X interrupt support is required
> @@ -249,7 +249,7 @@ config I40E
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/i40e.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/i40e.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called i40e.
> @@ -284,7 +284,7 @@ config I40EVF
>  	  This driver was formerly named i40evf.
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/iavf.rst>.
> +	  <file:Documentation/networking/device_drivers/ethernet/intel/iavf.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called iavf.  MSI-X interrupt support is required
> @@ -303,7 +303,7 @@ config ICE
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/ice.rst>.
> +	  <file:Documentation/networking/device_drivers/ethernet/intel/ice.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called ice.
> @@ -321,7 +321,7 @@ config FM10K
>  	  <http://support.intel.com>
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/intel/fm10k.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/intel/fm10k.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called fm10k.  MSI-X interrupt support is required
> diff --git a/drivers/net/ethernet/neterion/Kconfig
> b/drivers/net/ethernet/neterion/Kconfig
> index a82a37094579..d5760e7ba262 100644
> --- a/drivers/net/ethernet/neterion/Kconfig
> +++ b/drivers/net/ethernet/neterion/Kconfig
> @@ -27,7 +27,7 @@ config S2IO
>  	  on its age.
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/neterion/s2io.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/neterion/s2io.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called s2io.
> @@ -42,7 +42,7 @@ config VXGE
>  	  labeled as either one, depending on its age.
> 
>  	  More specific information on configuring the driver is in
> -	  <file:Documentation/networking/device_drivers/neterion/vxge.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/neterion/vxge.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called vxge.
> diff --git a/drivers/net/ethernet/pensando/Kconfig
> b/drivers/net/ethernet/pensando/Kconfig
> index d25b88f53de4..76f8cc502bf9 100644
> --- a/drivers/net/ethernet/pensando/Kconfig
> +++ b/drivers/net/ethernet/pensando/Kconfig
> @@ -25,7 +25,7 @@ config IONIC
>  	  This enables the support for the Pensando family of Ethernet
>  	  adapters.  More specific information on this driver can be
>  	  found in
> -	  <file:Documentation/networking/device_drivers/pensando/ionic.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/pensando/ionic.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called ionic.
> diff --git a/drivers/net/ethernet/smsc/Kconfig
> b/drivers/net/ethernet/smsc/Kconfig
> index 4d2d91ec8b41..599bc68f0290 100644
> --- a/drivers/net/ethernet/smsc/Kconfig
> +++ b/drivers/net/ethernet/smsc/Kconfig
> @@ -28,7 +28,7 @@ config SMC9194
>  	  option if you have a DELL laptop with the docking station, or
>  	  another SMC9192/9194 based chipset.  Say Y if you want it compiled
>  	  into the kernel, and read the file
> -	  <file:Documentation/networking/device_drivers/smsc/smc9.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/smsc/smc9.rst>.
> 
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called smc9194.
> @@ -44,7 +44,7 @@ config SMC91X
>  	  This is a driver for SMC's 91x series of Ethernet chipsets,
>  	  including the SMC91C94 and the SMC91C111. Say Y if you want it
>  	  compiled into the kernel, and read the file
> -	  <file:Documentation/networking/device_drivers/smsc/smc9.rst>.
> +
> <file:Documentation/networking/device_drivers/ethernet/smsc/smc9.rst>.
> 
>  	  This driver is also available as a module ( = code which can be
>  	  inserted in and removed from the running kernel whenever you want).
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 182d10f171f6..308fee33fe7f 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -156,7 +156,7 @@ config TLAN
> 
>  	  Devices currently supported by this driver are Compaq Netelligent,
>  	  Compaq NetFlex and Olicom cards.  Please read the file
> -	  <file:Documentation/networking/device_drivers/ti/tlan.rst>
> +	  <file:Documentation/networking/device_drivers/ethernet/ti/tlan.rst>
>  	  for more details.
> 
>  	  To compile this driver as a module, choose M here. The module
> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
> index 857709828058..583cd2ef7662 100644
> --- a/drivers/net/ethernet/ti/tlan.c
> +++ b/drivers/net/ethernet/ti/tlan.c
> @@ -70,7 +70,7 @@ MODULE_DESCRIPTION("Driver for TI ThunderLAN based
> ethernet PCI adapters");
>  MODULE_LICENSE("GPL");
> 
>  /* Turn on debugging.
> - * See Documentation/networking/device_drivers/ti/tlan.rst for details
> + * See Documentation/networking/device_drivers/ethernet/ti/tlan.rst for details
>   */
>  static  int		debug;
>  module_param(debug, int, 0);
> diff --git a/drivers/net/wireless/intel/ipw2x00/Kconfig
> b/drivers/net/wireless/intel/ipw2x00/Kconfig
> index f42b3cdce611..77603d585051 100644
> --- a/drivers/net/wireless/intel/ipw2x00/Kconfig
> +++ b/drivers/net/wireless/intel/ipw2x00/Kconfig
> @@ -16,7 +16,7 @@ config IPW2100
>  	  A driver for the Intel PRO/Wireless 2100 Network
>  	  Connection 802.11b wireless network adapter.
> 
> -	  See <file:Documentation/networking/device_drivers/intel/ipw2100.rst>
> +	  See
> <file:Documentation/networking/device_drivers/wifi/intel/ipw2100.rst>
>  	  for information on the capabilities currently enabled in this driver
>  	  and for tips for debugging issues and problems.
> 
> @@ -78,7 +78,7 @@ config IPW2200
>  	  A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
>  	  Connection adapters.
> 
> -	  See <file:Documentation/networking/device_drivers/intel/ipw2200.rst>
> +	  See
> <file:Documentation/networking/device_drivers/wifi/intel/ipw2200.rst>
>  	  for information on the capabilities currently enabled in this
>  	  driver and for tips for debugging issues and problems.
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> index 624fe721e2b5..753dada5a243 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> @@ -8352,7 +8352,7 @@ static int ipw2100_mod_firmware_load(struct
> ipw2100_fw *fw)
>  	if (IPW2100_FW_MAJOR(h->version) !=
> IPW2100_FW_MAJOR_VERSION) {
>  		printk(KERN_WARNING DRV_NAME ": Firmware image not
> compatible "
>  		       "(detected version id of %u). "
> -		       "See
> Documentation/networking/device_drivers/intel/ipw2100.rst\n",
> +		       "See
> Documentation/networking/device_drivers/wifi/intel/ipw2100.rst\n",
>  		       h->version);
>  		return 1;
>  	}
> --
> 2.26.2

