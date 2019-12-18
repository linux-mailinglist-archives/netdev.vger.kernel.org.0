Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B132912435A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfLRJgO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Dec 2019 04:36:14 -0500
Received: from mail-oln040092255068.outbound.protection.outlook.com ([40.92.255.68]:26688
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726090AbfLRJgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 04:36:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilpfBghk9650ROWbO8D48D+Bzr7D0Q22+NVMTJ9mRpTrx4hIcLBop/Qbfm+4sKEHstO/z90F0qFqW7oCaxF81E1G1jDfWG6OTCTe/Bh342vewTDyer7vmvTp3yd2zOMhFeNZ98BdM81BuoSvdggl6U/AdpeVNpm+K38E3YdoAAedIe7IdncLyU0v8/wBRz3GipplTs4HwD+KdNJVYj5191jZR0E0Du5ubk5vUaN6Py1TysJJk9b4wqDtTrF5SX8pBh/eHxWbYu2mfbv74DqPA/70fqY0vmRqOEgrfBgYd0KgBvW7ERkmPSJLh/fC4X2u2wPmY3TezInYg8PGf9FD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGedn1v8RCKgHsEg/9B69Hll19Wpn8TOtlrsaYnFUxQ=;
 b=MPQymLuhKULR69KlhAOg5UeMwG79kNQcdT+m3RLxdmz4yaadqWcWsp9fB7essnfMO/FWSHkWQajBWe4BR7Ifbse9OswdxhG8an194iiv0o1LGOk2cl9LM+SBhkD8XjZlnK8lwoVR9NsVPpB2DBs3aE9i35PuBJZuF5+KR6K5Ps2xjqaA+PyjLIDC3hYa0a9aYdvv8sy/GXxnMcEyc06OmWWOuajaQnOLyjEdjzsbLiQNH2ujTt6WwRHwwPLbZ2pEBpUBS5WiEh8hQr0xuK544Y6AT5zIS627II5k3pDmIYBzGCwBBCR1sMVbBig5hGp/Yw5quW0cvQ/LobWbzc9cPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SG2APC01FT010.eop-APC01.prod.protection.outlook.com
 (10.152.250.51) by SG2APC01HT214.eop-APC01.prod.protection.outlook.com
 (10.152.251.11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.15; Wed, 18 Dec
 2019 09:36:05 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM (10.152.250.52) by
 SG2APC01FT010.mail.protection.outlook.com (10.152.250.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14 via Frontend Transport; Wed, 18 Dec 2019 09:36:04 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::20ad:6646:5bcd:63c9]) by PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::20ad:6646:5bcd:63c9%11]) with mapi id 15.20.2559.012; Wed, 18 Dec
 2019 09:36:04 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Mario.Limonciello@dell.com" <Mario.Limonciello@dell.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] thunderbolt: Update Kconfig entries to USB4
Thread-Topic: [PATCH v2 5/9] thunderbolt: Update Kconfig entries to USB4
Thread-Index: AQHVtNZA7k3sXAlOX0WwGXJsNFERRKe/o2qA
Date:   Wed, 18 Dec 2019 09:36:04 +0000
Message-ID: <PSXP216MB0438CF99CF5C87385663A25B80530@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
 <20191217123345.31850-6-mika.westerberg@linux.intel.com>
In-Reply-To: <20191217123345.31850-6-mika.westerberg@linux.intel.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SYBPR01CA0128.ausprd01.prod.outlook.com
 (2603:10c6:10:5::20) To PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:d::20)
x-incomingtopheadermarker: OriginalChecksum:188C4DDE8B2B99DCE55ECA2471A8F5A8213B4451E1E8800F7A2AE1E71DCE4E30;UpperCasedChecksum:65FC7CB551DB0D82338878CCB0EA1894D144D958189CB9A1BAA908469D40025C;SizeAsReceived:8161;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [JmZp1DqWmqDuI2Y3FxIZLM6mlHsujUfRYrUJ5uEHUmPNCfBjmiEgbNgoeUIXDNqy+1UvN3MFYpU=]
x-microsoft-original-message-id: <20191218093555.GB3499@nicholas-dell-linux>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 28032fbc-4c3d-477b-98d8-08d7839db3ae
x-ms-traffictypediagnostic: SG2APC01HT214:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 133/wZWwLDobAkphglu3CvkU+nUHEIS8LmxQDqR6QFSqWqt5SuElHyaBLinpGXjiPZRVAkwb3PmZ2Fh6p/RS8ieZZJ4//fexFOqqRpnZy/uxK1IH3L+tMAGDPCrbEdDP/lpgbCNadHq8ny88bf77UOhWgrchHWkJTcolrdErJsZV3cMBJngv/M08C/OnHbd1
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0924D40A96BFDA49ACC80FF01ED844E6@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 28032fbc-4c3d-477b-98d8-08d7839db3ae
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 09:36:04.8030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2APC01HT214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 03:33:41PM +0300, Mika Westerberg wrote:
> Since the driver now supports USB4 which is the standard going forward,
> update the Kconfig entry to mention this and rename the entry from
> CONFIG_THUNDERBOLT to CONFIG_USB4 instead to help people to find the
> correct option if they want to enable USB4.
> 
> Also do the same for Thunderbolt network driver.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>  drivers/Makefile             |  2 +-
>  drivers/net/Kconfig          | 10 +++++-----
>  drivers/net/Makefile         |  2 +-
>  drivers/thunderbolt/Kconfig  | 11 ++++++-----
>  drivers/thunderbolt/Makefile |  2 +-
>  5 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index aaef17cc6512..31cf17dee252 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -171,7 +171,7 @@ obj-$(CONFIG_POWERCAP)		+= powercap/
>  obj-$(CONFIG_MCB)		+= mcb/
>  obj-$(CONFIG_PERF_EVENTS)	+= perf/
>  obj-$(CONFIG_RAS)		+= ras/
> -obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
> +obj-$(CONFIG_USB4)		+= thunderbolt/
>  obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
>  obj-y				+= hwtracing/intel_th/
>  obj-$(CONFIG_STM)		+= hwtracing/stm/
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index d02f12a5254e..d1c84d47779d 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -489,12 +489,12 @@ config FUJITSU_ES
>  	  This driver provides support for Extended Socket network device
>  	  on Extended Partitioning of FUJITSU PRIMEQUEST 2000 E2 series.
>  
> -config THUNDERBOLT_NET
> -	tristate "Networking over Thunderbolt cable"
> -	depends on THUNDERBOLT && INET
> +config USB4_NET
> +	tristate "Networking over USB4 and Thunderbolt cables"
> +	depends on USB4 && INET
>  	help
> -	  Select this if you want to create network between two
> -	  computers over a Thunderbolt cable. The driver supports Apple
> +	  Select this if you want to create network between two computers
> +	  over a USB4 and Thunderbolt cables. The driver supports Apple
Nitpick: Perhaps should be "over USB4 and Thunderbolt cables".

>  	  ThunderboltIP protocol and allows communication with any host
>  	  supporting the same protocol including Windows and macOS.
>  
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index 0d3ba056cda3..29e83e9f545e 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -76,6 +76,6 @@ obj-$(CONFIG_NTB_NETDEV) += ntb_netdev.o
>  obj-$(CONFIG_FUJITSU_ES) += fjes/
>  
>  thunderbolt-net-y += thunderbolt.o
> -obj-$(CONFIG_THUNDERBOLT_NET) += thunderbolt-net.o
> +obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
>  obj-$(CONFIG_NETDEVSIM) += netdevsim/
>  obj-$(CONFIG_NET_FAILOVER) += net_failover.o
> diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
> index fd9adca898ff..1eb757e8df3b 100644
> --- a/drivers/thunderbolt/Kconfig
> +++ b/drivers/thunderbolt/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -menuconfig THUNDERBOLT
> -	tristate "Thunderbolt support"
> +menuconfig USB4
> +	tristate "Unified support for USB4 and Thunderbolt"
>  	depends on PCI
>  	depends on X86 || COMPILE_TEST
>  	select APPLE_PROPERTIES if EFI_STUB && X86
> @@ -9,9 +9,10 @@ menuconfig THUNDERBOLT
>  	select CRYPTO_HASH
>  	select NVMEM
>  	help
> -	  Thunderbolt Controller driver. This driver is required if you
> -	  want to hotplug Thunderbolt devices on Apple hardware or on PCs
> -	  with Intel Falcon Ridge or newer.
> +	  USB4 and Thunderbolt driver. USB4 is the public speficiation
> +	  based on Thunderbolt 3 protocol. This driver is required if
> +	  you want to hotplug Thunderbolt and USB4 compliant devices on
> +	  Apple hardware or on PCs with Intel Falcon Ridge or newer.
>  
>  	  To compile this driver a module, choose M here. The module will be
>  	  called thunderbolt.
> diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
> index c0b2fd73dfbd..102e9529ee66 100644
> --- a/drivers/thunderbolt/Makefile
> +++ b/drivers/thunderbolt/Makefile
> @@ -1,4 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
> +obj-${CONFIG_USB4} := thunderbolt.o
>  thunderbolt-objs := nhi.o nhi_ops.o ctl.o tb.o switch.o cap.o path.o tunnel.o eeprom.o
>  thunderbolt-objs += domain.o dma_port.o icm.o property.o xdomain.o lc.o usb4.o
> -- 
> 2.24.0
> 

Kind regards,
Nicholas
