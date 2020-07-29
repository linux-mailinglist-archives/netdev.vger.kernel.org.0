Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98A232583
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 21:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgG2Tls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 15:41:48 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:16800
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgG2Tlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 15:41:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZ4U3hxmTVZV+Dm7I7FkX7+IY6ovqxL4RMCufVSpoLxuvNCh54gG+SToG1ks77OratbR405GMbMx6mFro8rs7fTMbOmK5FL+X/THj0cZLGkEVSTkhx5JY8GIxzcXIlIbZNbENU6FyDzTLEXuMsPGdZ0NhL8Nlfo7zAlj5xbkjatgKI4joVnOkonun+lCg9aPlEhf1ZElkZb75ToOo+xzUns+IRAO3UXRLQw50wy3pP4OG5jxs9zDZFGl2pFQrITTT/qegpEGTURrd/+PaxKgsPjI6Lz5uV9q49XfOhKI2VswIto5D1+Yi+Kq/iB1daoDFmy6txCk7H73qREK+CyCqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ynj2suIUK5JD856k+WU7NbI6oIzVajjayhzDyIBjFPU=;
 b=L5lBc++5w2BFROlAG27EY8LSy61emZLTYQ/2+9lTkY7D0EOY0sP3QymJatP+0gF4QLbWJKB6HagWp0QNUMOLIG4wKUpCHDStb3F2DsEPfZPwYfigARxg4hygUpN/65knaVSU/PbNPCpKpDcGKWxGmLqtKdK+UPjhM5GQ30CJ2dfz7zp5mCj4nGF5A96QrLbUkpr28LT4LLXTUkNEdaFU5ycutaId0/wCooc6zId2crn2D/NgwyF40Meir3atmUiEYreYj3IH6JYXVn5QG2woe6q2Cbgf5j+PdkcRFW8FMW62UFfxjqQBhvXtYdo56ijmeCfwYt9T+PSs88WlEoG5Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ynj2suIUK5JD856k+WU7NbI6oIzVajjayhzDyIBjFPU=;
 b=cbKKOLNkrWnlA6ij7ynm5MVkDq7ZZC2yCqCS+WDsBaCbm+/6n1kU7N21VIzOkZsL357eE2jLsqjJBjS+O74T++yzM83D8JBl5VBMxgQjzNTDCrUZB/LrIjM8u7wUTe6aHufmD5a/SBR4CKI/z8+6njNUvVG2H7LuymXcSep0uag=
Received: from DB7PR05MB4458.eurprd05.prod.outlook.com (2603:10a6:5:1a::14) by
 DB8PR05MB6666.eurprd05.prod.outlook.com (2603:10a6:10:141::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.17; Wed, 29 Jul 2020 19:41:30 +0000
Received: from DB7PR05MB4458.eurprd05.prod.outlook.com
 ([fe80::2816:e191:39f3:ef53]) by DB7PR05MB4458.eurprd05.prod.outlook.com
 ([fe80::2816:e191:39f3:ef53%5]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 19:41:30 +0000
From:   David Thompson <dthompson@mellanox.com>
To:     David Thompson <dthompson@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Asmaa Mnebhi <Asmaa@mellanox.com>
Subject: RE: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Topic: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Thread-Index: AQHWZdYzOT9DYX1Ig0WLIL8pdxMsRKke8w2w
Date:   Wed, 29 Jul 2020 19:41:30 +0000
Message-ID: <DB7PR05MB4458D41E4B967BFEA30F6AC6DD700@DB7PR05MB4458.eurprd05.prod.outlook.com>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
In-Reply-To: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [24.62.225.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0923a3d-efa7-4720-3ca7-08d833f7647e
x-ms-traffictypediagnostic: DB8PR05MB6666:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR05MB6666BDFBF9B5A22C7CF49F16DD700@DB8PR05MB6666.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QoaLzCj9p6+aHaTwDAjrsLGsUK/wbehMuFnM4ppSV7UmGSV4r/DlAdg8lV5+/fwzfQxSm6JV1w8UbNNyQ0VCCzPpWuRpEFMVD/g6Z9031gqgd8Mn3t/t8pnwkc5+Egh6RowzpwJE2388s1AD7sQynE3dCJYRDt+qqFb8z67i5WGtQL3TJwdyZJ4hJd1WPRWjs35jzLg+nPCX9C1Xxc3gQv4oXA0aeprrjG6WB5G38/NVUxVmSoM7XPZq3CtuuYopDlnGYv4S+yvVMEcEgBIOJuSkokZa+P1HIRJWMzkM2uk2ldy0nTJHcgjNqDbsBYcXYmDy6HjupN/CNuqeTDeh4baYxkRYTDloMXoghERMnUAaDGsxPkpENf099CaTvQn0TvspTzo6+UsSrSq/14XLXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4458.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(478600001)(33656002)(107886003)(83380400001)(9686003)(55016002)(4326008)(2906002)(8936002)(8676002)(71200400001)(5660300002)(6506007)(52536014)(316002)(7696005)(66446008)(64756008)(66556008)(66476007)(76116006)(54906003)(110136005)(66946007)(26005)(186003)(86362001)(53546011)(30864003)(559001)(579004)(473944003)(414714003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Qn55xKN8MAe3p1spQpbPyCGe+h2bNO60WZuCEOe2C/el3oGa4PtW86sikdPp0JnEcmSoSlKj+e2NghzJyXihXUJVGRwB7LUCPVKDkQD4Bs37PnP/3TNyK/UPEs4YSl31eqTKuivES48g8qtq0pMiVWzH8xW0nnDTlPFyVM8dFMzCnmny/KkCubB28/aMGNlaANU8f9R4f1ZbMj4/EQEwxu3fHnyRutRXuFRYZyEal1JEZHS1s6HCtwaeosTfwR1iC+zafg13IyBzLVnKDnqAOecpcpxgPpGDU6jItFUfOLLlsD1c/5EJhppPbDuHwIJGvSBeqJLhnbnWSxgqpgx6pmYFSjF4lAPdcsFjuBUFbLehc76jBaLWj9nalD26I7xmLZduBuLw1NHzeHHpj2fv2iWaC4TZzOOo23t1FcOE8anTAm3LjJKAEgKTYJtyc4n+FC4mVbt3o/1ZkphXLOphqiuGsWiOx6rRvuVVfLdcETkLSOyVIMsIEhumrHpqDPy5R7NGVTCvtnDkXL5r4xxm8shwxtWkRevE9HwfAGTj5g//laTYsiUMwcUN8mXk6riYKa+0DwpAv5aa8SNrMVH2ifeFP3i8tX+N9hKyZ+NAD0ikt/LRppfCoM/ql2mQIIjCF8O1nuSfDHdSMPo4Edw5Ig==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4458.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0923a3d-efa7-4720-3ca7-08d833f7647e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 19:41:30.7299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SfkJBcAMGzll/zfztYANGcv1De2926rgeBbn7XOY5Q9F/3B8CFs3o77h+0Ravm0AryH4nSdk4BVXEVcDrTgDmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Thompson <dthompson@mellanox.com>
> Sent: Wednesday, July 29, 2020 2:29 PM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; Jiri Pirko <jiri@mellanox.com>;
> David Thompson <dthompson@mellanox.com>; Asmaa Mnebhi
> <Asmaa@mellanox.com>
> Subject: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
>=20
> This patch adds build and driver logic for the "mlxbf_gige"
> Ethernet driver from Mellanox Technologies. The second
> generation BlueField SoC from Mellanox supports an
> out-of-band GigaBit Ethernet management port to the Arm
> subsystem.  This driver supports TCP/IP network connectivity
> for that port, and provides back-end routines to handle
> basic ethtool requests.
>=20
> The logic in "mlxbf_gige_main.c" is the driver performing
> packet processing and handling ethtool management requests.
> The driver interfaces to the Gigabit Ethernet block of
> BlueField SoC via MMIO accesses to registers, which contain
> control information or pointers describing transmit and
> receive resources.  There is a single transmit queue, and
> the port supports transmit ring sizes of 4 to 256 entries.
> There is a single receive queue, and the port supports
> receive ring sizes of 32 to 32K entries. The transmit and
> receive rings are allocated from DMA coherent memory. There
> is a 16-bit producer and consumer index per ring to denote
> software ownership and hardware ownership, respetcively.
> The main driver supports the handling of some basic ethtool
> requests: get driver info, get/set ring parameters, get
> registers, and get statistics.
>=20
> The logic in "mlxbf_gige_mdio.c" is the driver controlling
> the Mellanox BlueField hardware that interacts with a PHY
> device via MDIO/MDC pins.  This driver does the following:
>   - At driver probe time, it configures several BlueField MDIO
>     parameters such as sample rate, full drive, voltage and MDC
>     based on values read from ACPI table.
>   - It defines functions to read and write MDIO registers and
>     registers the MDIO bus.
>   - It defines the phy interrupt handler reporting a
>     link up/down status change
>   - This driver's probe is invoked from the main driver logic
>     while the phy interrupt handler is registered in ndo_open.
>=20
> Driver limitations
>   - Only supports 1Gbps speed
>   - Only supports GMII protocol
>   - Supports maximum packet size of 2KB
>   - Does not support scatter-gather buffering
>=20
> Testing
>   - Successful build of kernel for ARM64, ARM32, X86_64
>   - Tested ARM64 build on FastModels & Palladium
>=20

It's been pointed out to me that this section is incomplete, and I apologiz=
e.

The "Testing" section should include the following information:
- Tested ARM64 build on several Mellanox boards that are built with
   the BlueField-2 SoC.  The testing includes coverage in the areas of
   networking (e.g. ping, iperf, ifconfig, route), file transfers (e.g. SCP=
),
   and various ethtool options relevant to this driver.

> Signed-off-by: David Thompson <dthompson@mellanox.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/Kconfig              |    1 +
>  drivers/net/ethernet/mellanox/Makefile             |    1 +
>  drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig   |   13 +
>  drivers/net/ethernet/mellanox/mlxbf_gige/Makefile  |    5 +
>  .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |  156 +++
>  .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 1277
> ++++++++++++++++++++
>  .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  423 +++++++
>  .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   73 ++
>  8 files changed, 1949 insertions(+)
>  create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
>  create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
>  create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
>  create mode 100644
> drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
>  create mode 100644
> drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
>  create mode 100644
> drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
>=20
> diff --git a/drivers/net/ethernet/mellanox/Kconfig
> b/drivers/net/ethernet/mellanox/Kconfig
> index ff6613a..b4f66eb 100644
> --- a/drivers/net/ethernet/mellanox/Kconfig
> +++ b/drivers/net/ethernet/mellanox/Kconfig
> @@ -22,5 +22,6 @@ source "drivers/net/ethernet/mellanox/mlx4/Kconfig"
>  source "drivers/net/ethernet/mellanox/mlx5/core/Kconfig"
>  source "drivers/net/ethernet/mellanox/mlxsw/Kconfig"
>  source "drivers/net/ethernet/mellanox/mlxfw/Kconfig"
> +source "drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig"
>=20
>  endif # NET_VENDOR_MELLANOX
> diff --git a/drivers/net/ethernet/mellanox/Makefile
> b/drivers/net/ethernet/mellanox/Makefile
> index 79773ac..d4b5f54 100644
> --- a/drivers/net/ethernet/mellanox/Makefile
> +++ b/drivers/net/ethernet/mellanox/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_MLX4_CORE) +=3D mlx4/
>  obj-$(CONFIG_MLX5_CORE) +=3D mlx5/core/
>  obj-$(CONFIG_MLXSW_CORE) +=3D mlxsw/
>  obj-$(CONFIG_MLXFW) +=3D mlxfw/
> +obj-$(CONFIG_MLXBF_GIGE) +=3D mlxbf_gige/
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
> b/drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
> new file mode 100644
> index 0000000..73c5d74
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB
> +#
> +# Mellanox GigE driver configuration
> +#
> +
> +config MLXBF_GIGE
> +	tristate "Mellanox Technologies BlueField Gigabit Ethernet support"
> +	depends on (ARM64 || COMPILE_TEST) && ACPI && INET
> +	select PHYLIB
> +	help
> +	  The second generation BlueField SoC from Mellanox Technologies
> +	  supports an out-of-band Gigabit Ethernet management port to the
> +	  Arm subsystem.
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
> b/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
> new file mode 100644
> index 0000000..f6be6c6
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB
> +
> +obj-$(CONFIG_MLXBF_GIGE) +=3D mlxbf_gige.o
> +
> +mlxbf_gige-y :=3D mlxbf_gige_main.o mlxbf_gige_mdio.o
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
> b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
> new file mode 100644
> index 0000000..f89199d
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
> @@ -0,0 +1,156 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB */
> +
> +/* Header file for Gigabit Ethernet driver for Mellanox BlueField SoC
> + * - this file contains software data structures and any chip-specific
> + *   data structures (e.g. TX WQE format) that are memory resident.
> + *
> + * Copyright (c) 2020 Mellanox Technologies Ltd.
> + */
> +
> +#ifndef __MLXBF_GIGE_H__
> +#define __MLXBF_GIGE_H__
> +
> +#include <linux/irqreturn.h>
> +#include <linux/netdevice.h>
> +
> +/* The silicon design supports a maximum RX ring size of
> + * 32K entries. Based on current testing this maximum size
> + * is not required to be supported.  Instead the RX ring
> + * will be capped at a realistic value of 1024 entries.
> + */
> +#define MLXBF_GIGE_MIN_RXQ_SZ     32
> +#define MLXBF_GIGE_MAX_RXQ_SZ     1024
> +#define MLXBF_GIGE_DEFAULT_RXQ_SZ 128
> +
> +#define MLXBF_GIGE_MIN_TXQ_SZ     4
> +#define MLXBF_GIGE_MAX_TXQ_SZ     256
> +#define MLXBF_GIGE_DEFAULT_TXQ_SZ 128
> +
> +#define MLXBF_GIGE_DEFAULT_BUF_SZ 2048
> +
> +/* There are four individual MAC RX filters. Currently
> + * two of them are being used: one for the broadcast MAC
> + * (index 0) and one for local MAC (index 1)
> + */
> +#define MLXBF_GIGE_BCAST_MAC_FILTER_IDX 0
> +#define MLXBF_GIGE_LOCAL_MAC_FILTER_IDX 1
> +
> +/* Define for broadcast MAC literal */
> +#define BCAST_MAC_ADDR 0xFFFFFFFFFFFF
> +
> +/* There are three individual interrupts:
> + *   1) Errors, "OOB" interrupt line
> + *   2) Receive Packet, "OOB_LLU" interrupt line
> + *   3) LLU and PLU Events, "OOB_PLU" interrupt line
> + */
> +#define MLXBF_GIGE_ERROR_INTR_IDX       0
> +#define MLXBF_GIGE_RECEIVE_PKT_INTR_IDX 1
> +#define MLXBF_GIGE_LLU_PLU_INTR_IDX     2
> +#define MLXBF_GIGE_PHY_INT_N            3
> +
> +#define MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR 0x3
> +
> +struct mlxbf_gige_stats {
> +	u64 hw_access_errors;
> +	u64 tx_invalid_checksums;
> +	u64 tx_small_frames;
> +	u64 tx_index_errors;
> +	u64 sw_config_errors;
> +	u64 sw_access_errors;
> +	u64 rx_truncate_errors;
> +	u64 rx_mac_errors;
> +	u64 rx_din_dropped_pkts;
> +	u64 tx_fifo_full;
> +	u64 rx_filter_passed_pkts;
> +	u64 rx_filter_discard_pkts;
> +};
> +
> +struct mlxbf_gige {
> +	void __iomem *base;
> +	void __iomem *llu_base;
> +	void __iomem *plu_base;
> +	struct device *dev;
> +	struct net_device *netdev;
> +	struct platform_device *pdev;
> +	void __iomem *mdio_io;
> +	struct mii_bus *mdiobus;
> +	void __iomem *gpio_io;
> +	void __iomem *cause_rsh_coalesce0_io;
> +	void __iomem *cause_gpio_arm_coalesce0_io;
> +	u32 phy_int_gpio_mask;
> +	spinlock_t lock;
> +	spinlock_t gpio_lock;
> +	u16 rx_q_entries;
> +	u16 tx_q_entries;
> +	u64 *tx_wqe_base;
> +	dma_addr_t tx_wqe_base_dma;
> +	u64 *tx_wqe_next;
> +	u64 *tx_cc;
> +	dma_addr_t tx_cc_dma;
> +	dma_addr_t *rx_wqe_base;
> +	dma_addr_t rx_wqe_base_dma;
> +	u64 *rx_cqe_base;
> +	dma_addr_t rx_cqe_base_dma;
> +	u16 tx_pi;
> +	u16 prev_tx_ci;
> +	u64 error_intr_count;
> +	u64 rx_intr_count;
> +	u64 llu_plu_intr_count;
> +	u8 *rx_buf[MLXBF_GIGE_MAX_RXQ_SZ];
> +	u8 *tx_buf[MLXBF_GIGE_MAX_TXQ_SZ];
> +	int error_irq;
> +	int rx_irq;
> +	int llu_plu_irq;
> +	bool promisc_enabled;
> +	struct napi_struct napi;
> +	struct mlxbf_gige_stats stats;
> +};
> +
> +/* Rx Work Queue Element definitions */
> +#define MLXBF_GIGE_RX_WQE_SZ                   8
> +
> +/* Rx Completion Queue Element definitions */
> +#define MLXBF_GIGE_RX_CQE_SZ                   8
> +#define MLXBF_GIGE_RX_CQE_PKT_LEN_MASK         GENMASK(10, 0)
> +#define MLXBF_GIGE_RX_CQE_VALID_MASK           GENMASK(11, 11)
> +#define MLXBF_GIGE_RX_CQE_PKT_STATUS_MASK      GENMASK(15, 12)
> +#define MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR   GENMASK(12, 12)
> +#define MLXBF_GIGE_RX_CQE_PKT_STATUS_TRUNCATED GENMASK(13, 13)
> +#define MLXBF_GIGE_RX_CQE_CHKSUM_MASK          GENMASK(31, 16)
> +
> +/* Tx Work Queue Element definitions */
> +#define MLXBF_GIGE_TX_WQE_SZ_QWORDS            2
> +#define MLXBF_GIGE_TX_WQE_SZ                   16
> +#define MLXBF_GIGE_TX_WQE_PKT_LEN_MASK         GENMASK(10, 0)
> +#define MLXBF_GIGE_TX_WQE_UPDATE_MASK          GENMASK(31, 31)
> +#define MLXBF_GIGE_TX_WQE_CHKSUM_LEN_MASK      GENMASK(42, 32)
> +#define MLXBF_GIGE_TX_WQE_CHKSUM_START_MASK    GENMASK(55, 48)
> +#define MLXBF_GIGE_TX_WQE_CHKSUM_OFFSET_MASK   GENMASK(63, 56)
> +
> +/* Macro to return packet length of specified TX WQE */
> +#define MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr) \
> +	(*(tx_wqe_addr + 1) & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK)
> +
> +/* Tx Completion Count */
> +#define MLXBF_GIGE_TX_CC_SZ                    8
> +
> +/* List of resources in ACPI table */
> +enum mlxbf_gige_res {
> +	MLXBF_GIGE_RES_MAC,
> +	MLXBF_GIGE_RES_MDIO9,
> +	MLXBF_GIGE_RES_GPIO0,
> +	MLXBF_GIGE_RES_CAUSE_RSH_COALESCE0,
> +	MLXBF_GIGE_RES_CAUSE_GPIO_ARM_COALESCE0,
> +	MLXBF_GIGE_RES_LLU,
> +	MLXBF_GIGE_RES_PLU
> +};
> +
> +/* Version of register data returned by mlxbf_gige_get_regs() */
> +#define MLXBF_GIGE_REGS_VERSION 1
> +
> +int mlxbf_gige_mdio_probe(struct platform_device *pdev,
> +			  struct mlxbf_gige *priv);
> +void mlxbf_gige_mdio_remove(struct mlxbf_gige *priv);
> +irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(struct mlxbf_gige *priv=
);
> +
> +#endif /* !defined(__MLXBF_GIGE_H__) */
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> new file mode 100644
> index 0000000..a02e7a4
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> @@ -0,0 +1,1277 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB
> +
> +/* Gigabit Ethernet driver for Mellanox BlueField SoC
> + *
> + * Copyright (c) 2020 Mellanox Technologies Ltd.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/device.h>
> +#include <linux/etherdevice.h>
> +#include <linux/interrupt.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +#include <linux/module.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#include "mlxbf_gige.h"
> +#include "mlxbf_gige_regs.h"
> +
> +#define DRV_NAME    "mlxbf_gige"
> +
> +static void mlxbf_gige_set_mac_rx_filter(struct mlxbf_gige *priv,
> +					 unsigned int index, u64 dmac)
> +{
> +	void __iomem *base =3D priv->base;
> +	u64 control;
> +
> +	/* Write destination MAC to specified MAC RX filter */
> +	writeq(dmac, base + MLXBF_GIGE_RX_MAC_FILTER +
> +	       (index * MLXBF_GIGE_RX_MAC_FILTER_STRIDE));
> +
> +	/* Enable MAC receive filter mask for specified index */
> +	control =3D readq(base + MLXBF_GIGE_CONTROL);
> +	control |=3D (MLXBF_GIGE_CONTROL_EN_SPECIFIC_MAC << index);
> +	writeq(control, base + MLXBF_GIGE_CONTROL);
> +}
> +
> +static int mlxbf_gige_get_mac_rx_filter(struct mlxbf_gige *priv,
> +					unsigned int index, u64 *dmac)
> +{
> +	void __iomem *base =3D priv->base;
> +
> +	/* Read destination MAC from specified MAC RX filter */
> +	*dmac =3D readq(base + MLXBF_GIGE_RX_MAC_FILTER +
> +		      (index * MLXBF_GIGE_RX_MAC_FILTER_STRIDE));
> +
> +	return 0;
> +}
> +
> +static void mlxbf_gige_enable_promisc(struct mlxbf_gige *priv)
> +{
> +	void __iomem *base =3D priv->base;
> +	u64 control;
> +
> +	/* Enable MAC_ID_RANGE match functionality */
> +	control =3D readq(base + MLXBF_GIGE_CONTROL);
> +	control |=3D MLXBF_GIGE_CONTROL_MAC_ID_RANGE_EN;
> +	writeq(control, base + MLXBF_GIGE_CONTROL);
> +
> +	/* Set start of destination MAC range check to 0 */
> +	writeq(0, base + MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_START);
> +
> +	/* Set end of destination MAC range check to all FFs */
> +	writeq(0xFFFFFFFFFFFF, base +
> MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_END);
> +}
> +
> +static void mlxbf_gige_disable_promisc(struct mlxbf_gige *priv)
> +{
> +	void __iomem *base =3D priv->base;
> +	u64 control;
> +
> +	/* Disable MAC_ID_RANGE match functionality */
> +	control =3D readq(base + MLXBF_GIGE_CONTROL);
> +	control &=3D ~MLXBF_GIGE_CONTROL_MAC_ID_RANGE_EN;
> +	writeq(control, base + MLXBF_GIGE_CONTROL);
> +
> +	/* NOTE: no need to change DMAC_RANGE_START or END;
> +	 * those values are ignored since MAC_ID_RANGE_EN=3D0
> +	 */
> +}
> +
> +/* Receive Initialization
> + * 1) Configures RX MAC filters via MMIO registers
> + * 2) Allocates RX WQE array using coherent DMA mapping
> + * 3) Initializes each element of RX WQE array with a receive
> + *    buffer pointer (also using coherent DMA mapping)
> + * 4) Allocates RX CQE array using coherent DMA mapping
> + * 5) Completes other misc receive initialization
> + */
> +static int mlxbf_gige_rx_init(struct mlxbf_gige *priv)
> +{
> +	size_t wq_size, cq_size;
> +	dma_addr_t *rx_wqe_ptr;
> +	dma_addr_t rx_buf_dma;
> +	u64 data;
> +	int i, j;
> +
> +	/* Configure MAC RX filter #0 to allow RX of broadcast pkts */
> +	mlxbf_gige_set_mac_rx_filter(priv,
> MLXBF_GIGE_BCAST_MAC_FILTER_IDX,
> +				     BCAST_MAC_ADDR);
> +
> +	wq_size =3D MLXBF_GIGE_RX_WQE_SZ * priv->rx_q_entries;
> +	priv->rx_wqe_base =3D dma_alloc_coherent(priv->dev, wq_size,
> +					       &priv->rx_wqe_base_dma,
> +					       GFP_KERNEL);
> +	if (!priv->rx_wqe_base)
> +		return -ENOMEM;
> +
> +	/* Initialize 'rx_wqe_ptr' to point to first RX WQE in array
> +	 * Each RX WQE is simply a receive buffer pointer, so walk
> +	 * the entire array, allocating a 2KB buffer for each element
> +	 */
> +	rx_wqe_ptr =3D priv->rx_wqe_base;
> +
> +	for (i =3D 0; i < priv->rx_q_entries; i++) {
> +		/* Allocate a receive buffer for this RX WQE. The DMA
> +		 * form (dma_addr_t) of the receive buffer address is
> +		 * stored in the RX WQE array (via 'rx_wqe_ptr') where
> +		 * it is accessible by the GigE device. The VA form of
> +		 * the receive buffer is stored in 'rx_buf[]' array in
> +		 * the driver private storage for housekeeping.
> +		 */
> +		priv->rx_buf[i] =3D dma_alloc_coherent(priv->dev,
> +
> MLXBF_GIGE_DEFAULT_BUF_SZ,
> +						     &rx_buf_dma,
> +						     GFP_KERNEL);
> +		if (!priv->rx_buf[i])
> +			goto free_wqe_and_buf;
> +
> +		*rx_wqe_ptr++ =3D rx_buf_dma;
> +	}
> +
> +	/* Write RX WQE base address into MMIO reg */
> +	writeq(priv->rx_wqe_base_dma, priv->base +
> MLXBF_GIGE_RX_WQ_BASE);
> +
> +	cq_size =3D MLXBF_GIGE_RX_CQE_SZ * priv->rx_q_entries;
> +	priv->rx_cqe_base =3D dma_alloc_coherent(priv->dev, cq_size,
> +					       &priv->rx_cqe_base_dma,
> +					       GFP_KERNEL);
> +	if (!priv->rx_cqe_base)
> +		goto free_wqe_and_buf;
> +
> +	/* Write RX CQE base address into MMIO reg */
> +	writeq(priv->rx_cqe_base_dma, priv->base +
> MLXBF_GIGE_RX_CQ_BASE);
> +
> +	/* Write RX_WQE_PI with current number of replenished buffers */
> +	writeq(priv->rx_q_entries, priv->base + MLXBF_GIGE_RX_WQE_PI);
> +
> +	/* Enable RX DMA to write new packets to memory */
> +	writeq(MLXBF_GIGE_RX_DMA_EN, priv->base +
> MLXBF_GIGE_RX_DMA);
> +
> +	/* Enable removal of CRC during RX */
> +	data =3D readq(priv->base + MLXBF_GIGE_RX);
> +	data |=3D MLXBF_GIGE_RX_STRIP_CRC_EN;
> +	writeq(data, priv->base + MLXBF_GIGE_RX);
> +
> +	/* Enable RX MAC filter pass and discard counters */
> +	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC_EN,
> +	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC);
> +	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS_EN,
> +	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS);
> +
> +	/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
> +	 * indicate readiness to receive pkts
> +	 */
> +	data =3D readq(priv->base + MLXBF_GIGE_INT_MASK);
> +	data &=3D ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
> +	writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
> +
> +	writeq(ilog2(priv->rx_q_entries),
> +	       priv->base + MLXBF_GIGE_RX_WQE_SIZE_LOG2);
> +
> +	return 0;
> +
> +free_wqe_and_buf:
> +	rx_wqe_ptr =3D priv->rx_wqe_base;
> +	for (j =3D 0; j < i; j++) {
> +		dma_free_coherent(priv->dev, MLXBF_GIGE_DEFAULT_BUF_SZ,
> +				  priv->rx_buf[j], *rx_wqe_ptr);
> +		rx_wqe_ptr++;
> +	}
> +	dma_free_coherent(priv->dev, wq_size,
> +			  priv->rx_wqe_base, priv->rx_wqe_base_dma);
> +	return -ENOMEM;
> +}
> +
> +/* Transmit Initialization
> + * 1) Allocates TX WQE array using coherent DMA mapping
> + * 2) Allocates TX completion counter using coherent DMA mapping
> + */
> +static int mlxbf_gige_tx_init(struct mlxbf_gige *priv)
> +{
> +	size_t size;
> +
> +	size =3D MLXBF_GIGE_TX_WQE_SZ * priv->tx_q_entries;
> +	priv->tx_wqe_base =3D dma_alloc_coherent(priv->dev, size,
> +					       &priv->tx_wqe_base_dma,
> +					       GFP_KERNEL);
> +	if (!priv->tx_wqe_base)
> +		return -ENOMEM;
> +
> +	priv->tx_wqe_next =3D priv->tx_wqe_base;
> +
> +	/* Write TX WQE base address into MMIO reg */
> +	writeq(priv->tx_wqe_base_dma, priv->base +
> MLXBF_GIGE_TX_WQ_BASE);
> +
> +	/* Allocate address for TX completion count */
> +	priv->tx_cc =3D dma_alloc_coherent(priv->dev, MLXBF_GIGE_TX_CC_SZ,
> +					 &priv->tx_cc_dma, GFP_KERNEL);
> +
> +	if (!priv->tx_cc) {
> +		dma_free_coherent(priv->dev, size,
> +				  priv->tx_wqe_base, priv->tx_wqe_base_dma);
> +		return -ENOMEM;
> +	}
> +
> +	/* Write TX CC base address into MMIO reg */
> +	writeq(priv->tx_cc_dma, priv->base +
> MLXBF_GIGE_TX_CI_UPDATE_ADDRESS);
> +
> +	writeq(ilog2(priv->tx_q_entries),
> +	       priv->base + MLXBF_GIGE_TX_WQ_SIZE_LOG2);
> +
> +	priv->prev_tx_ci =3D 0;
> +	priv->tx_pi =3D 0;
> +
> +	return 0;
> +}
> +
> +/* Receive Deinitialization
> + * This routine will free allocations done by mlxbf_gige_rx_init(),
> + * namely the RX WQE and RX CQE arrays, as well as all RX buffers
> + */
> +static void mlxbf_gige_rx_deinit(struct mlxbf_gige *priv)
> +{
> +	dma_addr_t *rx_wqe_ptr;
> +	size_t size;
> +	int i;
> +
> +	rx_wqe_ptr =3D priv->rx_wqe_base;
> +
> +	for (i =3D 0; i < priv->rx_q_entries; i++) {
> +		dma_free_coherent(priv->dev, MLXBF_GIGE_DEFAULT_BUF_SZ,
> +				  priv->rx_buf[i], *rx_wqe_ptr);
> +		priv->rx_buf[i] =3D NULL;
> +		rx_wqe_ptr++;
> +	}
> +
> +	size =3D MLXBF_GIGE_RX_WQE_SZ * priv->rx_q_entries;
> +	dma_free_coherent(priv->dev, size,
> +			  priv->rx_wqe_base, priv->rx_wqe_base_dma);
> +
> +	size =3D MLXBF_GIGE_RX_CQE_SZ * priv->rx_q_entries;
> +	dma_free_coherent(priv->dev, size,
> +			  priv->rx_cqe_base, priv->rx_cqe_base_dma);
> +
> +	priv->rx_wqe_base =3D 0;
> +	priv->rx_wqe_base_dma =3D 0;
> +	priv->rx_cqe_base =3D 0;
> +	priv->rx_cqe_base_dma =3D 0;
> +	writeq(0, priv->base + MLXBF_GIGE_RX_WQ_BASE);
> +	writeq(0, priv->base + MLXBF_GIGE_RX_CQ_BASE);
> +}
> +
> +/* Transmit Deinitialization
> + * This routine will free allocations done by mlxbf_gige_tx_init(),
> + * namely the TX WQE array and the TX completion counter
> + */
> +static void mlxbf_gige_tx_deinit(struct mlxbf_gige *priv)
> +{
> +	u64 *tx_wqe_ptr;
> +	size_t size;
> +	int i;
> +
> +	tx_wqe_ptr =3D priv->tx_wqe_base;
> +
> +	for (i =3D 0; i < priv->tx_q_entries; i++) {
> +		if (priv->tx_buf[i]) {
> +			dma_free_coherent(priv->dev,
> MLXBF_GIGE_DEFAULT_BUF_SZ,
> +					  priv->tx_buf[i], *tx_wqe_ptr);
> +			priv->tx_buf[i] =3D NULL;
> +		}
> +		tx_wqe_ptr +=3D 2;
> +	}
> +
> +	size =3D MLXBF_GIGE_TX_WQE_SZ * priv->tx_q_entries;
> +	dma_free_coherent(priv->dev, size,
> +			  priv->tx_wqe_base, priv->tx_wqe_base_dma);
> +
> +	dma_free_coherent(priv->dev, MLXBF_GIGE_TX_CC_SZ,
> +			  priv->tx_cc, priv->tx_cc_dma);
> +
> +	priv->tx_wqe_base =3D 0;
> +	priv->tx_wqe_base_dma =3D 0;
> +	priv->tx_cc =3D 0;
> +	priv->tx_cc_dma =3D 0;
> +	priv->tx_wqe_next =3D 0;
> +	writeq(0, priv->base + MLXBF_GIGE_TX_WQ_BASE);
> +	writeq(0, priv->base + MLXBF_GIGE_TX_CI_UPDATE_ADDRESS);
> +}
> +
> +/* Start of struct ethtool_ops functions */
> +static int mlxbf_gige_get_regs_len(struct net_device *netdev)
> +{
> +	/* Return size of MMIO register space (in bytes).
> +	 *
> +	 * NOTE: MLXBF_GIGE_MAC_CFG is the last defined register offset,
> +	 * so use that plus size of single register to derive total size
> +	 */
> +	return MLXBF_GIGE_MAC_CFG + 8;
> +}
> +
> +static void mlxbf_gige_get_regs(struct net_device *netdev,
> +				struct ethtool_regs *regs, void *p)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	u64 *buff =3D p;
> +	int reg;
> +
> +	regs->version =3D MLXBF_GIGE_REGS_VERSION;
> +
> +	/* Read entire MMIO register space and store results
> +	 * into the provided buffer. Each 64-bit word is converted
> +	 * to big-endian to make the output more readable.
> +	 *
> +	 * NOTE: by design, a read to an offset without an existing
> +	 *       register will be acknowledged and return zero.
> +	 */
> +	for (reg =3D 0; reg <=3D MLXBF_GIGE_MAC_CFG; reg +=3D 8)
> +		*buff++ =3D cpu_to_be64(readq(priv->base + reg));
> +}
> +
> +static void mlxbf_gige_get_ringparam(struct net_device *netdev,
> +				     struct ethtool_ringparam *ering)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +
> +	memset(ering, 0, sizeof(*ering));
> +	ering->rx_max_pending =3D MLXBF_GIGE_MAX_RXQ_SZ;
> +	ering->tx_max_pending =3D MLXBF_GIGE_MAX_TXQ_SZ;
> +	ering->rx_pending =3D priv->rx_q_entries;
> +	ering->tx_pending =3D priv->tx_q_entries;
> +}
> +
> +static int mlxbf_gige_set_ringparam(struct net_device *netdev,
> +				    struct ethtool_ringparam *ering)
> +{
> +	const struct net_device_ops *ops =3D netdev->netdev_ops;
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	int new_rx_q_entries, new_tx_q_entries;
> +
> +	/* Device does not have separate queues for small/large frames */
> +	if (ering->rx_mini_pending || ering->rx_jumbo_pending)
> +		return -EINVAL;
> +
> +	/* Round up to supported values */
> +	new_rx_q_entries =3D roundup_pow_of_two(ering->rx_pending);
> +	new_tx_q_entries =3D roundup_pow_of_two(ering->tx_pending);
> +
> +	/* Range check the new values */
> +	if (new_tx_q_entries < MLXBF_GIGE_MIN_TXQ_SZ ||
> +	    new_tx_q_entries > MLXBF_GIGE_MAX_TXQ_SZ ||
> +	    new_rx_q_entries < MLXBF_GIGE_MIN_RXQ_SZ ||
> +	    new_rx_q_entries > MLXBF_GIGE_MAX_RXQ_SZ)
> +		return -EINVAL;
> +
> +	/* If queue sizes did not change, exit now */
> +	if (new_rx_q_entries =3D=3D priv->rx_q_entries &&
> +	    new_tx_q_entries =3D=3D priv->tx_q_entries)
> +		return 0;
> +
> +	if (netif_running(netdev))
> +		ops->ndo_stop(netdev);
> +
> +	priv->rx_q_entries =3D new_rx_q_entries;
> +	priv->tx_q_entries =3D new_tx_q_entries;
> +
> +	if (netif_running(netdev))
> +		ops->ndo_open(netdev);
> +
> +	return 0;
> +}
> +
> +static void mlxbf_gige_get_drvinfo(struct net_device *netdev,
> +				   struct ethtool_drvinfo *info)
> +{
> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info-
> >bus_info));
> +}
> +
> +static const struct {
> +	const char string[ETH_GSTRING_LEN];
> +} mlxbf_gige_ethtool_stats_keys[] =3D {
> +	{ "rx_bytes" },
> +	{ "rx_packets" },
> +	{ "tx_bytes" },
> +	{ "tx_packets" },
> +	{ "hw_access_errors" },
> +	{ "tx_invalid_checksums" },
> +	{ "tx_small_frames" },
> +	{ "tx_index_errors" },
> +	{ "sw_config_errors" },
> +	{ "sw_access_errors" },
> +	{ "rx_truncate_errors" },
> +	{ "rx_mac_errors" },
> +	{ "rx_din_dropped_pkts" },
> +	{ "tx_fifo_full" },
> +	{ "rx_filter_passed_pkts" },
> +	{ "rx_filter_discard_pkts" },
> +};
> +
> +static int mlxbf_gige_get_sset_count(struct net_device *netdev, int stri=
ngset)
> +{
> +	if (stringset !=3D ETH_SS_STATS)
> +		return -EOPNOTSUPP;
> +	return ARRAY_SIZE(mlxbf_gige_ethtool_stats_keys);
> +}
> +
> +static void mlxbf_gige_get_strings(struct net_device *netdev, u32 string=
set,
> +				   u8 *buf)
> +{
> +	if (stringset !=3D ETH_SS_STATS)
> +		return;
> +	memcpy(buf, &mlxbf_gige_ethtool_stats_keys,
> +	       sizeof(mlxbf_gige_ethtool_stats_keys));
> +}
> +
> +static void mlxbf_gige_get_ethtool_stats(struct net_device *netdev,
> +					 struct ethtool_stats *estats,
> +					 u64 *data)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	/* Fill data array with interface statistics
> +	 *
> +	 * NOTE: the data writes must be in
> +	 *       sync with the strings shown in
> +	 *       the mlxbf_gige_ethtool_stats_keys[] array
> +	 *
> +	 * NOTE2: certain statistics below are zeroed upon
> +	 *        port disable, so the calculation below
> +	 *        must include the "cached" value of the stat
> +	 *        plus the value read directly from hardware.
> +	 *        Cached statistics are currently:
> +	 *          rx_din_dropped_pkts
> +	 *          rx_filter_passed_pkts
> +	 *          rx_filter_discard_pkts
> +	 */
> +	*data++ =3D netdev->stats.rx_bytes;
> +	*data++ =3D netdev->stats.rx_packets;
> +	*data++ =3D netdev->stats.tx_bytes;
> +	*data++ =3D netdev->stats.tx_packets;
> +	*data++ =3D priv->stats.hw_access_errors;
> +	*data++ =3D priv->stats.tx_invalid_checksums;
> +	*data++ =3D priv->stats.tx_small_frames;
> +	*data++ =3D priv->stats.tx_index_errors;
> +	*data++ =3D priv->stats.sw_config_errors;
> +	*data++ =3D priv->stats.sw_access_errors;
> +	*data++ =3D priv->stats.rx_truncate_errors;
> +	*data++ =3D priv->stats.rx_mac_errors;
> +	*data++ =3D (priv->stats.rx_din_dropped_pkts +
> +		   readq(priv->base + MLXBF_GIGE_RX_DIN_DROP_COUNTER));
> +	*data++ =3D priv->stats.tx_fifo_full;
> +	*data++ =3D (priv->stats.rx_filter_passed_pkts +
> +		   readq(priv->base + MLXBF_GIGE_RX_PASS_COUNTER_ALL));
> +	*data++ =3D (priv->stats.rx_filter_discard_pkts +
> +		   readq(priv->base + MLXBF_GIGE_RX_DISC_COUNTER_ALL));
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
> +				      struct ethtool_pauseparam *pause)
> +{
> +	pause->autoneg =3D AUTONEG_ENABLE;
> +	pause->rx_pause =3D 1;
> +	pause->tx_pause =3D 1;
> +}
> +
> +static int mlxbf_gige_get_link_ksettings(struct net_device *netdev,
> +					 struct ethtool_link_ksettings
> *link_ksettings)
> +{
> +	struct phy_device *phydev =3D netdev->phydev;
> +	u32 supported, advertising;
> +	u32 lp_advertising =3D 0;
> +	int status;
> +
> +	supported =3D SUPPORTED_TP | SUPPORTED_1000baseT_Full |
> +		    SUPPORTED_Autoneg | SUPPORTED_Pause;
> +
> +	advertising =3D ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg |
> +		      ADVERTISED_Pause;
> +
> +	status =3D phy_read(phydev, MII_LPA);
> +	if (status >=3D 0)
> +		lp_advertising =3D mii_lpa_to_ethtool_lpa_t(status & 0xffff);
> +
> +	status =3D phy_read(phydev, MII_STAT1000);
> +	if (status >=3D 0)
> +		lp_advertising |=3D mii_stat1000_to_ethtool_lpa_t(status &
> 0xffff);
> +
> +	ethtool_convert_legacy_u32_to_link_mode(link_ksettings-
> >link_modes.supported,
> +						supported);
> +	ethtool_convert_legacy_u32_to_link_mode(link_ksettings-
> >link_modes.advertising,
> +						advertising);
> +	ethtool_convert_legacy_u32_to_link_mode(link_ksettings-
> >link_modes.lp_advertising,
> +						lp_advertising);
> +
> +	link_ksettings->base.autoneg =3D AUTONEG_ENABLE;
> +	link_ksettings->base.speed =3D SPEED_1000;
> +	link_ksettings->base.duplex =3D DUPLEX_FULL;
> +	link_ksettings->base.port =3D PORT_TP;
> +	link_ksettings->base.phy_address =3D
> MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR;
> +	link_ksettings->base.transceiver =3D XCVR_INTERNAL;
> +	link_ksettings->base.mdio_support =3D ETH_MDIO_SUPPORTS_C22;
> +	link_ksettings->base.eth_tp_mdix =3D ETH_TP_MDI_INVALID;
> +	link_ksettings->base.eth_tp_mdix_ctrl =3D ETH_TP_MDI_INVALID;
> +
> +	return 0;
> +}
> +
> +static const struct ethtool_ops mlxbf_gige_ethtool_ops =3D {
> +	.get_drvinfo		=3D mlxbf_gige_get_drvinfo,
> +	.get_link		=3D ethtool_op_get_link,
> +	.get_ringparam		=3D mlxbf_gige_get_ringparam,
> +	.set_ringparam		=3D mlxbf_gige_set_ringparam,
> +	.get_regs_len           =3D mlxbf_gige_get_regs_len,
> +	.get_regs               =3D mlxbf_gige_get_regs,
> +	.get_strings            =3D mlxbf_gige_get_strings,
> +	.get_sset_count         =3D mlxbf_gige_get_sset_count,
> +	.get_ethtool_stats      =3D mlxbf_gige_get_ethtool_stats,
> +	.nway_reset		=3D phy_ethtool_nway_reset,
> +	.get_pauseparam		=3D mlxbf_gige_get_pauseparam,
> +	.get_link_ksettings	=3D mlxbf_gige_get_link_ksettings,
> +};
> +
> +static void mlxbf_gige_handle_link_change(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	struct phy_device *phydev =3D netdev->phydev;
> +	irqreturn_t ret;
> +
> +	ret =3D mlxbf_gige_mdio_handle_phy_interrupt(priv);
> +	if (ret !=3D IRQ_HANDLED)
> +		return;
> +
> +	/* print new link status only if the interrupt came from the PHY */
> +	phy_print_status(phydev);
> +}
> +
> +/* Start of struct net_device_ops functions */
> +static irqreturn_t mlxbf_gige_error_intr(int irq, void *dev_id)
> +{
> +	struct mlxbf_gige *priv;
> +	u64 int_status;
> +
> +	priv =3D dev_id;
> +
> +	priv->error_intr_count++;
> +
> +	int_status =3D readq(priv->base + MLXBF_GIGE_INT_STATUS);
> +
> +	if (int_status & MLXBF_GIGE_INT_STATUS_HW_ACCESS_ERROR)
> +		priv->stats.hw_access_errors++;
> +
> +	if (int_status & MLXBF_GIGE_INT_STATUS_TX_CHECKSUM_INPUTS) {
> +		priv->stats.tx_invalid_checksums++;
> +		/* This error condition is latched into MLXBF_GIGE_INT_STATUS
> +		 * when the GigE silicon operates on the offending
> +		 * TX WQE. The write to MLXBF_GIGE_INT_STATUS at the
> bottom
> +		 * of this routine clears this error condition.
> +		 */
> +	}
> +
> +	if (int_status & MLXBF_GIGE_INT_STATUS_TX_SMALL_FRAME_SIZE) {
> +		priv->stats.tx_small_frames++;
> +		/* This condition happens when the networking stack invokes
> +		 * this driver's "start_xmit()" method with a packet whose
> +		 * size < 60 bytes.  The GigE silicon will automatically pad
> +		 * this small frame up to a minimum-sized frame before it is
> +		 * sent. The "tx_small_frame" condition is latched into the
> +		 * MLXBF_GIGE_INT_STATUS register when the GigE silicon
> +		 * operates on the offending TX WQE. The write to
> +		 * MLXBF_GIGE_INT_STATUS at the bottom of this routine
> +		 * clears this condition.
> +		 */
> +	}
> +
> +	if (int_status & MLXBF_GIGE_INT_STATUS_TX_PI_CI_EXCEED_WQ_SIZE)
> +		priv->stats.tx_index_errors++;
> +
> +	if (int_status & MLXBF_GIGE_INT_STATUS_SW_CONFIG_ERROR)
> +		priv->stats.sw_config_errors++;
> +
> +	if (int_status & MLXBF_GIGE_INT_STATUS_SW_ACCESS_ERROR)
> +		priv->stats.sw_access_errors++;
> +
> +	/* Clear all error interrupts by writing '1' back to
> +	 * all the asserted bits in INT_STATUS.  Do not write
> +	 * '1' back to 'receive packet' bit, since that is
> +	 * managed separately.
> +	 */
> +
> +	int_status &=3D ~MLXBF_GIGE_INT_STATUS_RX_RECEIVE_PACKET;
> +
> +	writeq(int_status, priv->base + MLXBF_GIGE_INT_STATUS);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t mlxbf_gige_rx_intr(int irq, void *dev_id)
> +{
> +	struct mlxbf_gige *priv;
> +
> +	priv =3D dev_id;
> +
> +	priv->rx_intr_count++;
> +
> +	/* Driver has been interrupted because a new packet is available,
> +	 * but do not process packets at this time.  Instead, disable any
> +	 * further "packet rx" interrupts and tell the networking subsystem
> +	 * to poll the driver to pick up all available packets.
> +	 *
> +	 * NOTE: GigE silicon automatically disables "packet rx" interrupt by
> +	 *       setting MLXBF_GIGE_INT_MASK bit0 upon triggering the interrupt
> +	 *       to the ARM cores.  Software needs to re-enable "packet rx"
> +	 *       interrupts by clearing MLXBF_GIGE_INT_MASK bit0.
> +	 */
> +
> +	/* Tell networking subsystem to poll GigE driver */
> +	napi_schedule(&priv->napi);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t mlxbf_gige_llu_plu_intr(int irq, void *dev_id)
> +{
> +	struct mlxbf_gige *priv;
> +
> +	priv =3D dev_id;
> +	priv->llu_plu_intr_count++;
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/* Function that returns status of TX ring:
> + *          0: TX ring is full, i.e. there are no
> + *             available un-used entries in TX ring.
> + *   non-null: TX ring is not full, i.e. there are
> + *             some available entries in TX ring.
> + *             The non-null value is a measure of
> + *             how many TX entries are available, but
> + *             it is not the exact number of available
> + *             entries (see below).
> + *
> + * The algorithm makes the assumption that if
> + * (prev_tx_ci =3D=3D tx_pi) then the TX ring is empty.
> + * An empty ring actually has (tx_q_entries-1)
> + * entries, which allows the algorithm to differentiate
> + * the case of an empty ring vs. a full ring.
> + */
> +static u16 mlxbf_gige_tx_buffs_avail(struct mlxbf_gige *priv)
> +{
> +	unsigned long flags;
> +	u16 avail;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	if (priv->prev_tx_ci =3D=3D priv->tx_pi)
> +		avail =3D priv->tx_q_entries - 1;
> +	else
> +		avail =3D ((priv->tx_q_entries + priv->prev_tx_ci - priv->tx_pi)
> +			  % priv->tx_q_entries) - 1;
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return avail;
> +}
> +
> +static bool mlxbf_gige_handle_tx_complete(struct mlxbf_gige *priv)
> +{
> +	struct net_device_stats *stats;
> +	u16 tx_wqe_index;
> +	u64 *tx_wqe_addr;
> +	u64 tx_status;
> +	u16 tx_ci;
> +
> +	tx_status =3D readq(priv->base + MLXBF_GIGE_TX_STATUS);
> +	if (tx_status & MLXBF_GIGE_TX_STATUS_DATA_FIFO_FULL)
> +		priv->stats.tx_fifo_full++;
> +	tx_ci =3D readq(priv->base + MLXBF_GIGE_TX_CONSUMER_INDEX);
> +	stats =3D &priv->netdev->stats;
> +
> +	/* Transmit completion logic needs to loop until the completion
> +	 * index (in SW) equals TX consumer index (from HW).  These
> +	 * parameters are unsigned 16-bit values and the wrap case needs
> +	 * to be supported, that is TX consumer index wrapped from 0xFFFF
> +	 * to 0 while TX completion index is still < 0xFFFF.
> +	 */
> +	for (; priv->prev_tx_ci !=3D tx_ci; priv->prev_tx_ci++) {
> +		tx_wqe_index =3D priv->prev_tx_ci % priv->tx_q_entries;
> +		/* Each TX WQE is 16 bytes. The 8 MSB store the 2KB TX
> +		 * buffer address and the 8 LSB contain information
> +		 * about the TX WQE.
> +		 */
> +		tx_wqe_addr =3D priv->tx_wqe_base +
> +			       (tx_wqe_index *
> MLXBF_GIGE_TX_WQE_SZ_QWORDS);
> +
> +		stats->tx_packets++;
> +		stats->tx_bytes +=3D
> MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr);
> +		dma_free_coherent(priv->dev, MLXBF_GIGE_DEFAULT_BUF_SZ,
> +				  priv->tx_buf[tx_wqe_index], *tx_wqe_addr);
> +		priv->tx_buf[tx_wqe_index] =3D NULL;
> +	}
> +
> +	/* Since the TX ring was likely just drained, check if TX queue
> +	 * had previously been stopped and now that there are TX buffers
> +	 * available the TX queue can be awakened.
> +	 */
> +	if (netif_queue_stopped(priv->netdev) &&
> +	    mlxbf_gige_tx_buffs_avail(priv)) {
> +		netif_wake_queue(priv->netdev);
> +	}
> +
> +	return true;
> +}
> +
> +static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
> +{
> +	struct net_device *netdev =3D priv->netdev;
> +	u16 rx_pi_rem, rx_ci_rem;
> +	struct sk_buff *skb;
> +	u64 *rx_cqe_addr;
> +	u64 datalen;
> +	u64 rx_cqe;
> +	u16 rx_ci;
> +	u16 rx_pi;
> +	u8 *pktp;
> +
> +	/* Index into RX buffer array is rx_pi w/wrap based on RX_CQE_SIZE */
> +	rx_pi =3D readq(priv->base + MLXBF_GIGE_RX_WQE_PI);
> +	rx_pi_rem =3D rx_pi % priv->rx_q_entries;
> +	pktp =3D priv->rx_buf[rx_pi_rem];
> +	rx_cqe_addr =3D priv->rx_cqe_base + rx_pi_rem;
> +	rx_cqe =3D *rx_cqe_addr;
> +	datalen =3D rx_cqe & MLXBF_GIGE_RX_CQE_PKT_LEN_MASK;
> +
> +	if ((rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MASK) =3D=3D 0) {
> +		/* Packet is OK, increment stats */
> +		netdev->stats.rx_packets++;
> +		netdev->stats.rx_bytes +=3D datalen;
> +
> +		skb =3D dev_alloc_skb(datalen);
> +		if (!skb) {
> +			netdev->stats.rx_dropped++;
> +			return false;
> +		}
> +
> +		memcpy(skb_put(skb, datalen), pktp, datalen);
> +
> +		skb->dev =3D netdev;
> +		skb->protocol =3D eth_type_trans(skb, netdev);
> +		skb->ip_summed =3D CHECKSUM_NONE; /* device did not
> checksum packet */
> +
> +		netif_receive_skb(skb);
> +	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR) {
> +		priv->stats.rx_mac_errors++;
> +	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_TRUNCATED) {
> +		priv->stats.rx_truncate_errors++;
> +	}
> +
> +	/* Let hardware know we've replenished one buffer */
> +	writeq(rx_pi + 1, priv->base + MLXBF_GIGE_RX_WQE_PI);
> +
> +	(*rx_pkts)++;
> +	rx_pi =3D readq(priv->base + MLXBF_GIGE_RX_WQE_PI);
> +	rx_pi_rem =3D rx_pi % priv->rx_q_entries;
> +	rx_ci =3D readq(priv->base + MLXBF_GIGE_RX_CQE_PACKET_CI);
> +	rx_ci_rem =3D rx_ci % priv->rx_q_entries;
> +
> +	return rx_pi_rem !=3D rx_ci_rem;
> +}
> +
> +/* Driver poll() function called by NAPI infrastructure */
> +static int mlxbf_gige_poll(struct napi_struct *napi, int budget)
> +{
> +	struct mlxbf_gige *priv;
> +	bool remaining_pkts;
> +	int work_done =3D 0;
> +	u64 data;
> +
> +	priv =3D container_of(napi, struct mlxbf_gige, napi);
> +
> +	mlxbf_gige_handle_tx_complete(priv);
> +
> +	do {
> +		remaining_pkts =3D mlxbf_gige_rx_packet(priv, &work_done);
> +	} while (remaining_pkts && work_done < budget);
> +
> +	/* If amount of work done < budget, turn off NAPI polling
> +	 * via napi_complete_done(napi, work_done) and then
> +	 * re-enable interrupts.
> +	 */
> +	if (work_done < budget && napi_complete_done(napi, work_done)) {
> +		/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
> +		 * indicate receive readiness
> +		 */
> +		data =3D readq(priv->base + MLXBF_GIGE_INT_MASK);
> +		data &=3D ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
> +		writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
> +	}
> +
> +	return work_done;
> +}
> +
> +static int mlxbf_gige_request_irqs(struct mlxbf_gige *priv)
> +{
> +	int err;
> +
> +	err =3D devm_request_irq(priv->dev, priv->error_irq,
> +			       mlxbf_gige_error_intr, 0, "mlxbf_gige_error",
> +			       priv);
> +	if (err) {
> +		dev_err(priv->dev, "Request error_irq failure\n");
> +		return err;
> +	}
> +
> +	err =3D devm_request_irq(priv->dev, priv->rx_irq,
> +			       mlxbf_gige_rx_intr, 0, "mlxbf_gige_rx",
> +			       priv);
> +	if (err) {
> +		dev_err(priv->dev, "Request rx_irq failure\n");
> +		return err;
> +	}
> +
> +	err =3D devm_request_irq(priv->dev, priv->llu_plu_irq,
> +			       mlxbf_gige_llu_plu_intr, 0, "mlxbf_gige_llu_plu",
> +			       priv);
> +	if (err) {
> +		dev_err(priv->dev, "Request llu_plu_irq failure\n");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mlxbf_gige_free_irqs(struct mlxbf_gige *priv)
> +{
> +	devm_free_irq(priv->dev, priv->error_irq, priv);
> +	devm_free_irq(priv->dev, priv->rx_irq, priv);
> +	devm_free_irq(priv->dev, priv->llu_plu_irq, priv);
> +}
> +
> +static void mlxbf_gige_cache_stats(struct mlxbf_gige *priv)
> +{
> +	struct mlxbf_gige_stats *p;
> +
> +	/* Cache stats that will be cleared by clean port operation */
> +	p =3D &priv->stats;
> +	p->rx_din_dropped_pkts +=3D readq(priv->base +
> +
> 	MLXBF_GIGE_RX_DIN_DROP_COUNTER);
> +	p->rx_filter_passed_pkts +=3D readq(priv->base +
> +
> MLXBF_GIGE_RX_PASS_COUNTER_ALL);
> +	p->rx_filter_discard_pkts +=3D readq(priv->base +
> +
> MLXBF_GIGE_RX_DISC_COUNTER_ALL);
> +}
> +
> +static void mlxbf_gige_clean_port(struct mlxbf_gige *priv)
> +{
> +	u64 control, status;
> +	int cnt;
> +
> +	/* Set the CLEAN_PORT_EN bit to trigger SW reset */
> +	control =3D readq(priv->base + MLXBF_GIGE_CONTROL);
> +	control |=3D MLXBF_GIGE_CONTROL_CLEAN_PORT_EN;
> +	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
> +
> +	/* Loop waiting for status ready bit to assert */
> +	cnt =3D 1000;
> +	do {
> +		status =3D readq(priv->base + MLXBF_GIGE_STATUS);
> +		if (status & MLXBF_GIGE_STATUS_READY)
> +			break;
> +		usleep_range(50, 100);
> +	} while (--cnt > 0);
> +
> +	/* Clear the CLEAN_PORT_EN bit at end of this loop */
> +	control =3D readq(priv->base + MLXBF_GIGE_CONTROL);
> +	control &=3D ~MLXBF_GIGE_CONTROL_CLEAN_PORT_EN;
> +	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
> +}
> +
> +static int mlxbf_gige_open(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	struct phy_device *phydev =3D netdev->phydev;
> +	u64 int_en;
> +	int err;
> +
> +	mlxbf_gige_cache_stats(priv);
> +	mlxbf_gige_clean_port(priv);
> +	mlxbf_gige_rx_init(priv);
> +	mlxbf_gige_tx_init(priv);
> +	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll,
> NAPI_POLL_WEIGHT);
> +	napi_enable(&priv->napi);
> +	netif_start_queue(netdev);
> +
> +	err =3D mlxbf_gige_request_irqs(priv);
> +	if (err)
> +		return err;
> +
> +	phy_start(phydev);
> +
> +	/* Set bits in INT_EN that we care about */
> +	int_en =3D MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR |
> +		 MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS |
> +		 MLXBF_GIGE_INT_EN_TX_SMALL_FRAME_SIZE |
> +		 MLXBF_GIGE_INT_EN_TX_PI_CI_EXCEED_WQ_SIZE |
> +		 MLXBF_GIGE_INT_EN_SW_CONFIG_ERROR |
> +		 MLXBF_GIGE_INT_EN_SW_ACCESS_ERROR |
> +		 MLXBF_GIGE_INT_EN_RX_RECEIVE_PACKET;
> +	writeq(int_en, priv->base + MLXBF_GIGE_INT_EN);
> +
> +	return 0;
> +}
> +
> +static int mlxbf_gige_stop(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +
> +	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> +	netif_stop_queue(netdev);
> +	napi_disable(&priv->napi);
> +	netif_napi_del(&priv->napi);
> +	mlxbf_gige_free_irqs(priv);
> +
> +	if (netdev->phydev)
> +		phy_stop(netdev->phydev);
> +
> +	mlxbf_gige_rx_deinit(priv);
> +	mlxbf_gige_tx_deinit(priv);
> +	mlxbf_gige_cache_stats(priv);
> +	mlxbf_gige_clean_port(priv);
> +
> +	return 0;
> +}
> +
> +/* Function to advance the tx_wqe_next pointer to next TX WQE */
> +static void mlxbf_gige_update_tx_wqe_next(struct mlxbf_gige *priv)
> +{
> +	/* Advance tx_wqe_next pointer */
> +	priv->tx_wqe_next +=3D MLXBF_GIGE_TX_WQE_SZ_QWORDS;
> +
> +	/* Check if 'next' pointer is beyond end of TX ring */
> +	/* If so, set 'next' back to 'base' pointer of ring */
> +	if (priv->tx_wqe_next =3D=3D (priv->tx_wqe_base +
> +				  (priv->tx_q_entries *
> MLXBF_GIGE_TX_WQE_SZ_QWORDS)))
> +		priv->tx_wqe_next =3D priv->tx_wqe_base;
> +}
> +
> +static netdev_tx_t mlxbf_gige_start_xmit(struct sk_buff *skb,
> +					 struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	dma_addr_t tx_buf_dma;
> +	u8 *tx_buf =3D NULL;
> +	u64 *tx_wqe_addr;
> +	u64 word2;
> +
> +	/* Check that there is room left in TX ring */
> +	if (!mlxbf_gige_tx_buffs_avail(priv)) {
> +		/* TX ring is full, inform stack but do not free SKB */
> +		netif_stop_queue(netdev);
> +		netdev->stats.tx_dropped++;
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	/* Allocate ptr for buffer */
> +	if (skb->len < MLXBF_GIGE_DEFAULT_BUF_SZ)
> +		tx_buf =3D dma_alloc_coherent(priv->dev,
> MLXBF_GIGE_DEFAULT_BUF_SZ,
> +					    &tx_buf_dma, GFP_KERNEL);
> +
> +	if (!tx_buf) {
> +		/* Free incoming skb, could not alloc TX buffer */
> +		dev_kfree_skb(skb);
> +		netdev->stats.tx_dropped++;
> +		return NET_XMIT_DROP;
> +	}
> +
> +	priv->tx_buf[priv->tx_pi % priv->tx_q_entries] =3D tx_buf;
> +
> +	/* Copy data from skb to allocated TX buffer
> +	 *
> +	 * NOTE: GigE silicon will automatically pad up to
> +	 *       minimum packet length if needed.
> +	 */
> +	skb_copy_bits(skb, 0, tx_buf, skb->len);
> +
> +	/* Get address of TX WQE */
> +	tx_wqe_addr =3D priv->tx_wqe_next;
> +
> +	mlxbf_gige_update_tx_wqe_next(priv);
> +
> +	/* Put PA of buffer address into first 64-bit word of TX WQE */
> +	*tx_wqe_addr =3D tx_buf_dma;
> +
> +	/* Set TX WQE pkt_len appropriately */
> +	word2 =3D skb->len & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK;
> +
> +	/* Write entire 2nd word of TX WQE */
> +	*(tx_wqe_addr + 1) =3D word2;
> +
> +	priv->tx_pi++;
> +
> +	/* Create memory barrier before write to TX PI */
> +	wmb();
> +
> +	writeq(priv->tx_pi, priv->base + MLXBF_GIGE_TX_PRODUCER_INDEX);
> +
> +	/* Free incoming skb, contents already copied to HW */
> +	dev_kfree_skb(skb);
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static int mlxbf_gige_do_ioctl(struct net_device *netdev,
> +			       struct ifreq *ifr, int cmd)
> +{
> +	if (!(netif_running(netdev)))
> +		return -EINVAL;
> +
> +	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
> +}
> +
> +static void mlxbf_gige_set_rx_mode(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv =3D netdev_priv(netdev);
> +	bool new_promisc_enabled;
> +
> +	new_promisc_enabled =3D netdev->flags & IFF_PROMISC;
> +
> +	/* Only write to the hardware registers if the new setting
> +	 * of promiscuous mode is different from the current one.
> +	 */
> +	if (new_promisc_enabled !=3D priv->promisc_enabled) {
> +		priv->promisc_enabled =3D new_promisc_enabled;
> +
> +		if (new_promisc_enabled)
> +			mlxbf_gige_enable_promisc(priv);
> +		else
> +			mlxbf_gige_disable_promisc(priv);
> +		}
> +	}
> +
> +static const struct net_device_ops mlxbf_gige_netdev_ops =3D {
> +	.ndo_open		=3D mlxbf_gige_open,
> +	.ndo_stop		=3D mlxbf_gige_stop,
> +	.ndo_start_xmit		=3D mlxbf_gige_start_xmit,
> +	.ndo_set_mac_address	=3D eth_mac_addr,
> +	.ndo_validate_addr	=3D eth_validate_addr,
> +	.ndo_do_ioctl		=3D mlxbf_gige_do_ioctl,
> +	.ndo_set_rx_mode        =3D mlxbf_gige_set_rx_mode,
> +};
> +
> +static u64 mlxbf_gige_mac_to_u64(u8 *addr)
> +{
> +	u64 mac =3D 0;
> +	int i;
> +
> +	for (i =3D 0; i < ETH_ALEN; i++) {
> +		mac <<=3D 8;
> +		mac |=3D addr[i];
> +	}
> +	return mac;
> +}
> +
> +static void mlxbf_gige_u64_to_mac(u8 *addr, u64 mac)
> +{
> +	int i;
> +
> +	for (i =3D ETH_ALEN; i > 0; i--) {
> +		addr[i - 1] =3D mac & 0xFF;
> +		mac >>=3D 8;
> +	}
> +}
> +
> +static void mlxbf_gige_initial_mac(struct mlxbf_gige *priv)
> +{
> +	u8 mac[ETH_ALEN];
> +	u64 local_mac;
> +	int status;
> +
> +	status =3D mlxbf_gige_get_mac_rx_filter(priv,
> MLXBF_GIGE_LOCAL_MAC_FILTER_IDX,
> +					      &local_mac);
> +	mlxbf_gige_u64_to_mac(mac, local_mac);
> +
> +	if (is_valid_ether_addr(mac)) {
> +		ether_addr_copy(priv->netdev->dev_addr, mac);
> +	} else {
> +		/* Provide a random MAC if for some reason the device has
> +		 * not been configured with a valid MAC address already.
> +		 */
> +		eth_hw_addr_random(priv->netdev);
> +	}
> +
> +	local_mac =3D mlxbf_gige_mac_to_u64(priv->netdev->dev_addr);
> +	mlxbf_gige_set_mac_rx_filter(priv,
> MLXBF_GIGE_LOCAL_MAC_FILTER_IDX,
> +				     local_mac);
> +}
> +
> +static int mlxbf_gige_probe(struct platform_device *pdev)
> +{
> +	struct phy_device *phydev;
> +	struct net_device *netdev;
> +	struct resource *mac_res;
> +	struct resource *llu_res;
> +	struct resource *plu_res;
> +	struct mlxbf_gige *priv;
> +	void __iomem *llu_base;
> +	void __iomem *plu_base;
> +	void __iomem *base;
> +	u64 control;
> +	int err =3D 0;
> +
> +	mac_res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> MLXBF_GIGE_RES_MAC);
> +	if (!mac_res)
> +		return -ENXIO;
> +
> +	base =3D devm_ioremap_resource(&pdev->dev, mac_res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	llu_res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> MLXBF_GIGE_RES_LLU);
> +	if (!llu_res)
> +		return -ENXIO;
> +
> +	llu_base =3D devm_ioremap_resource(&pdev->dev, llu_res);
> +	if (IS_ERR(llu_base))
> +		return PTR_ERR(llu_base);
> +
> +	plu_res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> MLXBF_GIGE_RES_PLU);
> +	if (!plu_res)
> +		return -ENXIO;
> +
> +	plu_base =3D devm_ioremap_resource(&pdev->dev, plu_res);
> +	if (IS_ERR(plu_base))
> +		return PTR_ERR(plu_base);
> +
> +	/* Perform general init of GigE block */
> +	control =3D readq(base + MLXBF_GIGE_CONTROL);
> +	control |=3D MLXBF_GIGE_CONTROL_PORT_EN;
> +	writeq(control, base + MLXBF_GIGE_CONTROL);
> +
> +	netdev =3D devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	netdev->netdev_ops =3D &mlxbf_gige_netdev_ops;
> +	netdev->ethtool_ops =3D &mlxbf_gige_ethtool_ops;
> +	priv =3D netdev_priv(netdev);
> +	priv->netdev =3D netdev;
> +
> +	platform_set_drvdata(pdev, priv);
> +	priv->dev =3D &pdev->dev;
> +	priv->pdev =3D pdev;
> +
> +	spin_lock_init(&priv->lock);
> +	spin_lock_init(&priv->gpio_lock);
> +
> +	/* Attach MDIO device */
> +	err =3D mlxbf_gige_mdio_probe(pdev, priv);
> +	if (err)
> +		return err;
> +
> +	priv->base =3D base;
> +	priv->llu_base =3D llu_base;
> +	priv->plu_base =3D plu_base;
> +
> +	priv->rx_q_entries =3D MLXBF_GIGE_DEFAULT_RXQ_SZ;
> +	priv->tx_q_entries =3D MLXBF_GIGE_DEFAULT_TXQ_SZ;
> +
> +	/* Write initial MAC address to hardware */
> +	mlxbf_gige_initial_mac(priv);
> +
> +	err =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (err) {
> +		dev_err(&pdev->dev, "DMA configuration failed: 0x%x\n", err);
> +		return err;
> +	}
> +
> +	priv->error_irq =3D platform_get_irq(pdev,
> MLXBF_GIGE_ERROR_INTR_IDX);
> +	priv->rx_irq =3D platform_get_irq(pdev,
> MLXBF_GIGE_RECEIVE_PKT_INTR_IDX);
> +	priv->llu_plu_irq =3D platform_get_irq(pdev,
> MLXBF_GIGE_LLU_PLU_INTR_IDX);
> +
> +	phydev =3D phy_find_first(priv->mdiobus);
> +	if (!phydev)
> +		return -EIO;
> +
> +	/* Sets netdev->phydev to phydev; which will eventually
> +	 * be used in ioctl calls.
> +	 */
> +	err =3D phy_connect_direct(netdev, phydev,
> +				 mlxbf_gige_handle_link_change,
> +				 PHY_INTERFACE_MODE_GMII);
> +	if (err) {
> +		dev_err(&pdev->dev, "Could not attach to PHY\n");
> +		return err;
> +	}
> +
> +	/* MAC only supports 1000T full duplex mode */
> +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_100baseT_Full_BIT);
> +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> +	phy_remove_link_mode(phydev,
> ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +
> +	/* MAC supports symmetric flow control */
> +	phy_support_sym_pause(phydev);
> +
> +	/* Display information about attached PHY device */
> +	phy_attached_info(phydev);
> +
> +	err =3D register_netdev(netdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to register netdev\n");
> +		phy_disconnect(phydev);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mlxbf_gige_remove(struct platform_device *pdev)
> +{
> +	struct mlxbf_gige *priv =3D platform_get_drvdata(pdev);
> +
> +	unregister_netdev(priv->netdev);
> +	phy_disconnect(priv->netdev->phydev);
> +	mlxbf_gige_mdio_remove(priv);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +static void mlxbf_gige_shutdown(struct platform_device *pdev)
> +{
> +	struct mlxbf_gige *priv =3D platform_get_drvdata(pdev);
> +
> +	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> +	mlxbf_gige_clean_port(priv);
> +}
> +
> +static const struct acpi_device_id mlxbf_gige_acpi_match[] =3D {
> +	{ "MLNXBF17", 0 },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(acpi, mlxbf_gige_acpi_match);
> +
> +static struct platform_driver mlxbf_gige_driver =3D {
> +	.probe =3D mlxbf_gige_probe,
> +	.remove =3D mlxbf_gige_remove,
> +	.shutdown =3D mlxbf_gige_shutdown,
> +	.driver =3D {
> +		.name =3D DRV_NAME,
> +		.acpi_match_table =3D ACPI_PTR(mlxbf_gige_acpi_match),
> +	},
> +};
> +
> +module_platform_driver(mlxbf_gige_driver);
> +
> +MODULE_DESCRIPTION("Mellanox BlueField SoC Gigabit Ethernet Driver");
> +MODULE_AUTHOR("David Thompson <dthompson@mellanox.com>");
> +MODULE_AUTHOR("Asmaa Mnebhi <asmaa@mellanox.com>");
> +MODULE_LICENSE("Dual BSD/GPL");
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
> b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
> new file mode 100644
> index 0000000..bb848b4
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
> @@ -0,0 +1,423 @@
> +// SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB
> +/*  MDIO support for Mellanox GigE driver
> + *
> + *  Copyright (c) 2020 Mellanox Technologies Ltd.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/irqreturn.h>
> +#include <linux/jiffies.h>
> +#include <linux/module.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/property.h>
> +
> +#include "mlxbf_gige.h"
> +
> +#define MLXBF_GIGE_MDIO_POLL_BUSY_TIMEOUT	100 /* ms */
> +#define MLXBF_GIGE_MDIO_POLL_DELAY_USEC		100 /* us */
> +
> +#define MLXBF_GIGE_MDIO_GW_OFFSET	0x0
> +#define MLXBF_GIGE_MDIO_CFG_OFFSET	0x4
> +
> +/* Support clause 22 */
> +#define MLXBF_GIGE_MDIO_CL22_ST1	0x1
> +#define MLXBF_GIGE_MDIO_CL22_WRITE	0x1
> +#define MLXBF_GIGE_MDIO_CL22_READ	0x2
> +
> +/* Busy bit is set by software and cleared by hardware */
> +#define MLXBF_GIGE_MDIO_SET_BUSY	0x1
> +/* Lock bit should be set/cleared by software */
> +#define MLXBF_GIGE_MDIO_SET_LOCK	0x1
> +
> +/* MDIO GW register bits */
> +#define MLXBF_GIGE_MDIO_GW_AD_MASK	GENMASK(15, 0)
> +#define MLXBF_GIGE_MDIO_GW_DEVAD_MASK	GENMASK(20, 16)
> +#define MLXBF_GIGE_MDIO_GW_PARTAD_MASK	GENMASK(25, 21)
> +#define MLXBF_GIGE_MDIO_GW_OPCODE_MASK	GENMASK(27, 26)
> +#define MLXBF_GIGE_MDIO_GW_ST1_MASK	GENMASK(28, 28)
> +#define MLXBF_GIGE_MDIO_GW_BUSY_MASK	GENMASK(30, 30)
> +#define MLXBF_GIGE_MDIO_GW_LOCK_MASK	GENMASK(31, 31)
> +
> +/* MDIO config register bits */
> +#define MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK		GENMASK(1,
> 0)
> +#define MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK		GENMASK(2,
> 2)
> +#define MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK	GENMASK(4,
> 4)
> +#define MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK		GENMASK(15,
> 8)
> +#define MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK
> 	GENMASK(23, 16)
> +#define MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK
> 	GENMASK(31, 24)
> +
> +/* Formula for encoding the MDIO period. The encoded value is
> + * passed to the MDIO config register.
> + *
> + * mdc_clk =3D 2*(val + 1)*i1clk
> + *
> + * 400 ns =3D 2*(val + 1)*(((1/430)*1000) ns)
> + *
> + * val =3D (((400 * 430 / 1000) / 2) - 1)
> + */
> +#define MLXBF_GIGE_I1CLK_MHZ		430
> +#define MLXBF_GIGE_MDC_CLK_NS		400
> +
> +#define MLXBF_GIGE_MDIO_PERIOD	(((MLXBF_GIGE_MDC_CLK_NS *
> MLXBF_GIGE_I1CLK_MHZ / 1000) / 2) - 1)
> +
> +/* PHY should operate in master mode only */
> +#define MLXBF_GIGE_MDIO_MODE_MASTER	1
> +
> +/* PHY input voltage has to be 3.3V */
> +#define MLXBF_GIGE_MDIO3_3		1
> +
> +/* Operate in full drive mode */
> +#define MLXBF_GIGE_MDIO_FULL_DRIVE	1
> +
> +/* 6 cycles before the i1clk (core clock) rising edge that triggers the =
mdc */
> +#define MLXBF_GIGE_MDIO_IN_SAMP		6
> +
> +/* 13 cycles after the i1clk (core clock) rising edge that triggers the =
mdc */
> +#define MLXBF_GIGE_MDIO_OUT_SAMP	13
> +
> +/* The PHY interrupt line is shared with other interrupt lines such
> + * as GPIO and SMBus. So use YU registers to determine whether the
> + * interrupt comes from the PHY.
> + */
> +#define MLXBF_GIGE_CAUSE_RSH_COALESCE0_GPIO_CAUSE_MASK	0x10
> +#define MLXBF_GIGE_GPIO_CAUSE_IRQ_IS_SET(val) \
> +	((val) & MLXBF_GIGE_CAUSE_RSH_COALESCE0_GPIO_CAUSE_MASK)
> +
> +#define MLXBF_GIGE_GPIO_BLOCK0_MASK	BIT(0)
> +
> +#define MLXBF_GIGE_GPIO_CAUSE_FALL_EN		0x48
> +#define MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0	0x80
> +#define MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0		0x94
> +#define MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE	0x98
> +
> +#define MLXBF_GIGE_GPIO12_BIT			12
> +
> +static u32 mlxbf_gige_mdio_create_cmd(u16 data, int phy_add,
> +				      int phy_reg, u32 opcode)
> +{
> +	u32 gw_reg =3D 0;
> +
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_AD_MASK, data);
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_DEVAD_MASK,
> phy_reg);
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_PARTAD_MASK,
> phy_add);
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_OPCODE_MASK,
> opcode);
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_ST1_MASK,
> +			     MLXBF_GIGE_MDIO_CL22_ST1);
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_BUSY_MASK,
> +			     MLXBF_GIGE_MDIO_SET_BUSY);
> +
> +	/* Hold the lock until the read/write is completed so that no other
> +	 * program accesses the mdio bus.
> +	 */
> +	gw_reg |=3D FIELD_PREP(MLXBF_GIGE_MDIO_GW_LOCK_MASK,
> +			     MLXBF_GIGE_MDIO_SET_LOCK);
> +
> +	return gw_reg;
> +}
> +
> +static int mlxbf_gige_mdio_poll_bit(struct mlxbf_gige *priv, u32 bit_mas=
k)
> +{
> +	unsigned long timeout;
> +	u32 val;
> +
> +	timeout =3D jiffies +
> msecs_to_jiffies(MLXBF_GIGE_MDIO_POLL_BUSY_TIMEOUT);
> +	do {
> +		val =3D readl(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +		if (!(val & bit_mask))
> +			return 0;
> +		udelay(MLXBF_GIGE_MDIO_POLL_DELAY_USEC);
> +	} while (time_before(jiffies, timeout));
> +
> +	return -ETIME;
> +}
> +
> +static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int ph=
y_reg)
> +{
> +	struct mlxbf_gige *priv =3D bus->priv;
> +	u32 cmd;
> +	u32 ret;
> +
> +	/* If the lock is held by something else, drop the request.
> +	 * If the lock is cleared, that means the busy bit was cleared.
> +	 */
> +	ret =3D mlxbf_gige_mdio_poll_bit(priv,
> MLXBF_GIGE_MDIO_GW_LOCK_MASK);
> +	if (ret)
> +		return -EBUSY;
> +
> +	/* Send mdio read request */
> +	cmd =3D mlxbf_gige_mdio_create_cmd(0, phy_add, phy_reg,
> MLXBF_GIGE_MDIO_CL22_READ);
> +
> +	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +
> +	ret =3D mlxbf_gige_mdio_poll_bit(priv,
> MLXBF_GIGE_MDIO_GW_BUSY_MASK);
> +	if (ret) {
> +		writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +		return -EBUSY;
> +	}
> +
> +	ret =3D readl(priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +	/* Only return ad bits of the gw register */
> +	ret &=3D MLXBF_GIGE_MDIO_GW_AD_MASK;
> +
> +	/* To release the YU MDIO lock, clear gw register,
> +	 * so that the YU does not confuse this write with a new
> +	 * MDIO read/write request.
> +	 */
> +	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +
> +	return ret;
> +}
> +
> +static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
> +				 int phy_reg, u16 val)
> +{
> +	struct mlxbf_gige *priv =3D bus->priv;
> +	u32 cmd;
> +	int ret;
> +
> +	/* If the lock is held by something else, drop the request.
> +	 * If the lock is cleared, that means the busy bit was cleared.
> +	 */
> +	ret =3D mlxbf_gige_mdio_poll_bit(priv,
> MLXBF_GIGE_MDIO_GW_LOCK_MASK);
> +	if (ret)
> +		return -EBUSY;
> +
> +	/* Send mdio write request */
> +	cmd =3D mlxbf_gige_mdio_create_cmd(val, phy_add, phy_reg,
> +					 MLXBF_GIGE_MDIO_CL22_WRITE);
> +	writel(cmd, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +
> +	/* If the poll timed out, drop the request */
> +	ret =3D mlxbf_gige_mdio_poll_bit(priv,
> MLXBF_GIGE_MDIO_GW_BUSY_MASK);
> +
> +	/* To release the YU MDIO lock, clear gw register,
> +	 * so that the YU does not confuse this write as a new
> +	 * MDIO read/write request.
> +	 */
> +	writel(0, priv->mdio_io + MLXBF_GIGE_MDIO_GW_OFFSET);
> +
> +	return ret;
> +}
> +
> +static void mlxbf_gige_mdio_disable_phy_int(struct mlxbf_gige *priv)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&priv->gpio_lock, flags);
> +	val =3D readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	val &=3D ~priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	spin_unlock_irqrestore(&priv->gpio_lock, flags);
> +}
> +
> +static void mlxbf_gige_mdio_enable_phy_int(struct mlxbf_gige *priv)
> +{
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&priv->gpio_lock, flags);
> +	/* The INT_N interrupt level is active low.
> +	 * So enable cause fall bit to detect when GPIO
> +	 * state goes low.
> +	 */
> +	val =3D readl(priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
> +	val |=3D priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io + MLXBF_GIGE_GPIO_CAUSE_FALL_EN);
> +
> +	/* Enable PHY interrupt by setting the priority level */
> +	val =3D readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	val |=3D priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_EVTEN0);
> +	spin_unlock_irqrestore(&priv->gpio_lock, flags);
> +}
> +
> +/* Interrupt handler is called from mlxbf_gige_main.c
> + * driver whenever a phy interrupt is received.
> + */
> +irqreturn_t mlxbf_gige_mdio_handle_phy_interrupt(struct mlxbf_gige *priv=
)
> +{
> +	u32 val;
> +
> +	/* The YU interrupt is shared between SMBus and GPIOs.
> +	 * So first, determine whether this is a GPIO interrupt.
> +	 */
> +	val =3D readl(priv->cause_rsh_coalesce0_io);
> +	if (!MLXBF_GIGE_GPIO_CAUSE_IRQ_IS_SET(val)) {
> +		/* Nothing to do here, not a GPIO interrupt */
> +		return IRQ_NONE;
> +	}
> +	/* Then determine which gpio register this interrupt is for.
> +	 * Return if the interrupt is not for gpio block 0.
> +	 */
> +	val =3D readl(priv->cause_gpio_arm_coalesce0_io);
> +	if (!(val & MLXBF_GIGE_GPIO_BLOCK0_MASK))
> +		return IRQ_NONE;
> +
> +	/* Finally check if this interrupt is from PHY device.
> +	 * Return if it is not.
> +	 */
> +	val =3D readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CAUSE_EVTEN0);
> +	if (!(val & priv->phy_int_gpio_mask))
> +		return IRQ_NONE;
> +
> +	/* Clear interrupt when done, otherwise, no further interrupt
> +	 * will be triggered.
> +	 * Writing 0x1 to the clear cause register also clears the
> +	 * following registers:
> +	 * cause_gpio_arm_coalesce0
> +	 * cause_rsh_coalesce0
> +	 */
> +	val =3D readl(priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> +	val |=3D priv->phy_int_gpio_mask;
> +	writel(val, priv->gpio_io +
> +			MLXBF_GIGE_GPIO_CAUSE_OR_CLRCAUSE);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void mlxbf_gige_mdio_init_config(struct mlxbf_gige *priv)
> +{
> +	struct device *dev =3D priv->dev;
> +	u32 mdio_full_drive;
> +	u32 mdio_out_sample;
> +	u32 mdio_in_sample;
> +	u32 mdio_voltage;
> +	u32 mdc_period;
> +	u32 mdio_mode;
> +	u32 mdio_cfg;
> +	int ret;
> +
> +	ret =3D device_property_read_u32(dev, "mdio-mode", &mdio_mode);
> +	if (ret < 0)
> +		mdio_mode =3D MLXBF_GIGE_MDIO_MODE_MASTER;
> +
> +	ret =3D device_property_read_u32(dev, "mdio-voltage", &mdio_voltage);
> +	if (ret < 0)
> +		mdio_voltage =3D MLXBF_GIGE_MDIO3_3;
> +
> +	ret =3D device_property_read_u32(dev, "mdio-full-drive",
> &mdio_full_drive);
> +	if (ret < 0)
> +		mdio_full_drive =3D MLXBF_GIGE_MDIO_FULL_DRIVE;
> +
> +	ret =3D device_property_read_u32(dev, "mdc-period", &mdc_period);
> +	if (ret < 0)
> +		mdc_period =3D MLXBF_GIGE_MDIO_PERIOD;
> +
> +	ret =3D device_property_read_u32(dev, "mdio-in-sample",
> &mdio_in_sample);
> +	if (ret < 0)
> +		mdio_in_sample =3D MLXBF_GIGE_MDIO_IN_SAMP;
> +
> +	ret =3D device_property_read_u32(dev, "mdio-out-sample",
> &mdio_out_sample);
> +	if (ret < 0)
> +		mdio_out_sample =3D MLXBF_GIGE_MDIO_OUT_SAMP;
> +
> +	mdio_cfg =3D FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_MODE_MASK,
> mdio_mode) |
> +		   FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO3_3_MASK,
> mdio_voltage) |
> +
> FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_FULL_DRIVE_MASK,
> mdio_full_drive) |
> +		   FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDC_PERIOD_MASK,
> mdc_period) |
> +
> FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_IN_SAMP_MASK,
> mdio_in_sample) |
> +
> FIELD_PREP(MLXBF_GIGE_MDIO_CFG_MDIO_OUT_SAMP_MASK,
> mdio_out_sample);
> +
> +	writel(mdio_cfg, priv->mdio_io + MLXBF_GIGE_MDIO_CFG_OFFSET);
> +}
> +
> +int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gig=
e
> *priv)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *res;
> +	u32 phy_int_gpio;
> +	u32 phy_addr;
> +	int ret;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> MLXBF_GIGE_RES_MDIO9);
> +	if (!res)
> +		return -ENODEV;
> +
> +	priv->mdio_io =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(priv->mdio_io))
> +		return PTR_ERR(priv->mdio_io);
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> MLXBF_GIGE_RES_GPIO0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	priv->gpio_io =3D devm_ioremap(dev, res->start, resource_size(res));
> +	if (!priv->gpio_io)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> +				    MLXBF_GIGE_RES_CAUSE_RSH_COALESCE0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	priv->cause_rsh_coalesce0_io =3D
> +		devm_ioremap(dev, res->start, resource_size(res));
> +	if (!priv->cause_rsh_coalesce0_io)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM,
> +
> MLXBF_GIGE_RES_CAUSE_GPIO_ARM_COALESCE0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	priv->cause_gpio_arm_coalesce0_io =3D
> +		devm_ioremap(dev, res->start, resource_size(res));
> +	if (!priv->cause_gpio_arm_coalesce0_io)
> +		return -ENOMEM;
> +
> +	mlxbf_gige_mdio_init_config(priv);
> +
> +	ret =3D device_property_read_u32(dev, "phy-int-gpio", &phy_int_gpio);
> +	if (ret < 0)
> +		phy_int_gpio =3D MLXBF_GIGE_GPIO12_BIT;
> +	priv->phy_int_gpio_mask =3D BIT(phy_int_gpio);
> +
> +	mlxbf_gige_mdio_enable_phy_int(priv);
> +
> +	priv->mdiobus =3D devm_mdiobus_alloc(dev);
> +	if (!priv->mdiobus) {
> +		dev_err(dev, "Failed to alloc MDIO bus\n");
> +		return -ENOMEM;
> +	}
> +
> +	priv->mdiobus->name =3D "mlxbf-mdio";
> +	priv->mdiobus->read =3D mlxbf_gige_mdio_read;
> +	priv->mdiobus->write =3D mlxbf_gige_mdio_write;
> +	priv->mdiobus->parent =3D dev;
> +	priv->mdiobus->priv =3D priv;
> +	snprintf(priv->mdiobus->id, MII_BUS_ID_SIZE, "%s",
> +		 dev_name(dev));
> +
> +	ret =3D device_property_read_u32(dev, "phy-addr", &phy_addr);
> +	if (ret < 0)
> +		phy_addr =3D MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR;
> +
> +	priv->mdiobus->irq[phy_addr] =3D PHY_POLL;
> +
> +	/* Auto probe PHY at the corresponding address */
> +	priv->mdiobus->phy_mask =3D ~(1 << phy_addr);
> +	ret =3D mdiobus_register(priv->mdiobus);
> +	if (ret)
> +		dev_err(dev, "Failed to register MDIO bus\n");
> +
> +	return ret;
> +}
> +
> +void mlxbf_gige_mdio_remove(struct mlxbf_gige *priv)
> +{
> +	mlxbf_gige_mdio_disable_phy_int(priv);
> +	mdiobus_unregister(priv->mdiobus);
> +}
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
> b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
> new file mode 100644
> index 0000000..9c7af82
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR Linux-OpenIB */
> +
> +/* Header file for Mellanox BlueField GigE register defines
> + *
> + * Copyright (c) 2020 Mellanox Technologies Ltd.
> + */
> +
> +#ifndef __MLXBF_GIGE_REGS_H__
> +#define __MLXBF_GIGE_REGS_H__
> +
> +#define MLXBF_GIGE_STATUS                             0x0010
> +#define MLXBF_GIGE_STATUS_READY                       BIT(0)
> +#define MLXBF_GIGE_INT_STATUS                         0x0028
> +#define MLXBF_GIGE_INT_STATUS_RX_RECEIVE_PACKET       BIT(0)
> +#define MLXBF_GIGE_INT_STATUS_RX_MAC_ERROR            BIT(1)
> +#define MLXBF_GIGE_INT_STATUS_RX_TRN_ERROR            BIT(2)
> +#define MLXBF_GIGE_INT_STATUS_SW_ACCESS_ERROR         BIT(3)
> +#define MLXBF_GIGE_INT_STATUS_SW_CONFIG_ERROR         BIT(4)
> +#define MLXBF_GIGE_INT_STATUS_TX_PI_CI_EXCEED_WQ_SIZE BIT(5)
> +#define MLXBF_GIGE_INT_STATUS_TX_SMALL_FRAME_SIZE     BIT(6)
> +#define MLXBF_GIGE_INT_STATUS_TX_CHECKSUM_INPUTS      BIT(7)
> +#define MLXBF_GIGE_INT_STATUS_HW_ACCESS_ERROR         BIT(8)
> +#define MLXBF_GIGE_INT_EN                             0x0030
> +#define MLXBF_GIGE_INT_EN_RX_RECEIVE_PACKET           BIT(0)
> +#define MLXBF_GIGE_INT_EN_RX_MAC_ERROR                BIT(1)
> +#define MLXBF_GIGE_INT_EN_RX_TRN_ERROR                BIT(2)
> +#define MLXBF_GIGE_INT_EN_SW_ACCESS_ERROR             BIT(3)
> +#define MLXBF_GIGE_INT_EN_SW_CONFIG_ERROR             BIT(4)
> +#define MLXBF_GIGE_INT_EN_TX_PI_CI_EXCEED_WQ_SIZE     BIT(5)
> +#define MLXBF_GIGE_INT_EN_TX_SMALL_FRAME_SIZE         BIT(6)
> +#define MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS          BIT(7)
> +#define MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR             BIT(8)
> +#define MLXBF_GIGE_INT_MASK                           0x0038
> +#define MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET         BIT(0)
> +#define MLXBF_GIGE_CONTROL                            0x0040
> +#define MLXBF_GIGE_CONTROL_PORT_EN                    BIT(0)
> +#define MLXBF_GIGE_CONTROL_MAC_ID_RANGE_EN            BIT(1)
> +#define MLXBF_GIGE_CONTROL_EN_SPECIFIC_MAC            BIT(4)
> +#define MLXBF_GIGE_CONTROL_CLEAN_PORT_EN              BIT(31)
> +#define MLXBF_GIGE_RX_WQ_BASE                         0x0200
> +#define MLXBF_GIGE_RX_WQE_SIZE_LOG2                   0x0208
> +#define MLXBF_GIGE_RX_WQE_SIZE_LOG2_RESET_VAL         7
> +#define MLXBF_GIGE_RX_CQ_BASE                         0x0210
> +#define MLXBF_GIGE_TX_WQ_BASE                         0x0218
> +#define MLXBF_GIGE_TX_WQ_SIZE_LOG2                    0x0220
> +#define MLXBF_GIGE_TX_WQ_SIZE_LOG2_RESET_VAL          7
> +#define MLXBF_GIGE_TX_CI_UPDATE_ADDRESS               0x0228
> +#define MLXBF_GIGE_RX_WQE_PI                          0x0230
> +#define MLXBF_GIGE_TX_PRODUCER_INDEX                  0x0238
> +#define MLXBF_GIGE_RX_MAC_FILTER                      0x0240
> +#define MLXBF_GIGE_RX_MAC_FILTER_STRIDE               0x0008
> +#define MLXBF_GIGE_RX_DIN_DROP_COUNTER                0x0260
> +#define MLXBF_GIGE_TX_CONSUMER_INDEX                  0x0310
> +#define MLXBF_GIGE_TX_CONTROL                         0x0318
> +#define MLXBF_GIGE_TX_CONTROL_GRACEFUL_STOP           BIT(0)
> +#define MLXBF_GIGE_TX_STATUS                          0x0388
> +#define MLXBF_GIGE_TX_STATUS_DATA_FIFO_FULL           BIT(1)
> +#define MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_START     0x0520
> +#define MLXBF_GIGE_RX_MAC_FILTER_DMAC_RANGE_END       0x0528
> +#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC           0x0540
> +#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC_EN        BIT(0)
> +#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS           0x0548
> +#define MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS_EN        BIT(0)
> +#define MLXBF_GIGE_RX_PASS_COUNTER_ALL                0x0550
> +#define MLXBF_GIGE_RX_DISC_COUNTER_ALL                0x0560
> +#define MLXBF_GIGE_RX                                 0x0578
> +#define MLXBF_GIGE_RX_STRIP_CRC_EN                    BIT(1)
> +#define MLXBF_GIGE_RX_DMA                             0x0580
> +#define MLXBF_GIGE_RX_DMA_EN                          BIT(0)
> +#define MLXBF_GIGE_RX_CQE_PACKET_CI                   0x05b0
> +#define MLXBF_GIGE_MAC_CFG                            0x05e8
> +
> +#endif /* !defined(__MLXBF_GIGE_REGS_H__) */
> --
> 2.1.2

