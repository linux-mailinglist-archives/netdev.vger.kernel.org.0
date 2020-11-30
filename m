Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE12C8F30
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 21:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgK3U2Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 15:28:16 -0500
Received: from mga17.intel.com ([192.55.52.151]:4803 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbgK3U2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 15:28:15 -0500
IronPort-SDR: SX0DnR2Wepal64fVPrzudzpjNVWi/NdZNy4KdvVklK9Upk8nUEQUi+7jH8rMBEnDVJBLUXs1/C
 5byq0AfU++CA==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="152537546"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="152537546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 12:27:34 -0800
IronPort-SDR: MXk2zleIMBrA05txKxpc0ZwxWb9TI9YxsKsJ8xIgbmtH9XEzw3swRT889AbFihBH36rlgwMtpc
 oBnl2q/89XLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="315421150"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga007.fm.intel.com with ESMTP; 30 Nov 2020 12:27:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Nov 2020 12:27:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Nov 2020 12:27:32 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Mon, 30 Nov 2020 12:27:32 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v2] devlink: Add devlink port documentation
Thread-Index: AQHWx1OEigvRbYknHkqjqo9cKQ7vnqnhH6YQ
Date:   Mon, 30 Nov 2020 20:27:32 +0000
Message-ID: <70f6caab5bc947609e7534cd49af0424@intel.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <20201130200025.573239-1-parav@nvidia.com>
In-Reply-To: <20201130200025.573239-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Parav Pandit <parav@nvidia.com>
> Sent: Monday, November 30, 2020 12:00 PM
> To: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; Parav Pandit
> <parav@nvidia.com>; Jiri Pirko <jiri@nvidia.com>
> Subject: [PATCH net-next v2] devlink: Add devlink port documentation
> 
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
> Changelog:
> v1->v2:
>  - Removed duplicate table entries for DEVLINK_PORT_FLAVOUR_VIRTUAL.
>  - replaced 'consist of' to 'consisting'
>  - changed 'can be' to 'can be of'
> ---
>  .../networking/devlink/devlink-port.rst       | 100 ++++++++++++++++++
>  Documentation/networking/devlink/index.rst    |   1 +
>  2 files changed, 101 insertions(+)
>  create mode 100644 Documentation/networking/devlink/devlink-port.rst
> 
> diff --git a/Documentation/networking/devlink/devlink-port.rst
> b/Documentation/networking/devlink/devlink-port.rst
> new file mode 100644
> index 000000000000..f3ed65acbd52
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -0,0 +1,100 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +============
> +Devlink Port
> +============
> +
> +``devlink-port`` provides capability for a driver to expose various
> +flavours of ports which exist on device. A devlink port can be of an
> +embedded switch (eswitch) present on the device.
> +
> +A devlink port can be of 3 diffferent types.
> +
> +.. list-table:: List of devlink port types
> +   :widths: 23 90
> +
> +   * - Type
> +     - Description
> +   * - ``DEVLINK_PORT_TYPE_ETH``
> +     - This type is set for a devlink port when a physical link layer of the port
> +       is Ethernet.
> +   * - ``DEVLINK_PORT_TYPE_IB``
> +     - This type is set for a devlink port when a physical link layer of the port
> +       is InfiniBand.
> +   * - ``DEVLINK_PORT_TYPE_AUTO``
> +     - This type is indicated by the user when user prefers to set the port type
> +       to be automatically detected by the device driver.
> +
> +Devlink port can be of few different flavours described below.
> +
> +.. list-table:: List of devlink port flavours
> +   :widths: 33 90
> +
> +   * - Flavour
> +     - Description
> +   * - ``DEVLINK_PORT_FLAVOUR_PHYSICAL``
> +     - Any kind of port which is physically facing the user. This can be
> +       a eswitch physical port or any other physical port on the device.
> +   * - ``DEVLINK_PORT_FLAVOUR_CPU``
> +     - This indicates a CPU port.
> +   * - ``DEVLINK_PORT_FLAVOUR_DSA``
> +     - This indicates a interconnect port in a distributed switch architecture.
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_PF``
> +     - This indicates an eswitch port representing PCI physical function(PF).
> +   * - ``DEVLINK_PORT_FLAVOUR_PCI_VF``
> +     - This indicates an eswitch port representing PCI virtual function(VF).
> +   * - ``DEVLINK_PORT_FLAVOUR_VIRTUAL``
> +     - This indicates a virtual port facing the user.
> +
> +A devlink port may be for a controller consisting one or more PCI device(s).
> +A devlink instance holds ports of two types of controllers.
> +
> +(1) controller discovered on same system where eswitch resides
> +This is the case where PCI PF/VF of a controller and devlink eswitch
> +instance both are located on a single system.
> +
> +(2) controller located on external host system.
> +This is the case where a controller is located in one system and its
> +devlink eswitch ports are located in a different system.
> +
> +An example view of two controller systems::
> +
> +                 ---------------------------------------------------------
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +    | pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
> +    | connect |  | -------                       -------                 |
> +    -----------  |     | controller_num=1 (no eswitch)                   |
> +                 ------|--------------------------------------------------
> +                 (internal wire)
> +                       |
> +                 ---------------------------------------------------------
> +                 | devlink eswitch ports and reps                        |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
> +                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
> +                 | ----------------------------------------------------- |
> +                 |                                                       |
> +                 |                                                       |
> +                 |           --------- ---------         ------- ------- |
> +                 |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
> +                 | -------   ----/---- ---/----- ------- ---/--- ---/--- |
> +                 | | pf0 |______/________/       | pf1 |___/_______/     |
> +                 | -------                       -------                 |
> +                 |                                                       |
> +                 |  local controller_num=0 (eswitch)                     |
> +                 ---------------------------------------------------------
> +
> +Port function configuration
> +===========================
> +
> +When a port flavor is ``DEVLINK_PORT_FLAVOUR_PCI_PF`` or
> +``DEVLINK_PORT_FLAVOUR_PCI_VF``, it represents the port of a PCI function.
> +A user can configure the port function attributes before enumerating the
> +function. For example user may set the hardware address of the function
> +represented by the devlink port.
> diff --git a/Documentation/networking/devlink/index.rst
> b/Documentation/networking/devlink/index.rst
> index d82874760ae2..aab79667f97b 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -18,6 +18,7 @@ general.
>     devlink-info
>     devlink-flash
>     devlink-params
> +   devlink-port
>     devlink-region
>     devlink-resource
>     devlink-reload
> --
> 2.26.2

