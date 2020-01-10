Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F39D136F28
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgAJOTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:19:44 -0500
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:6211
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727539AbgAJOTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 09:19:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+dnL+eHD6PloUj+niX9Trih9pHOQbLD7vvXzS3Nmp/W7GLsm/AMGLRU550mO2sz7RQFAkzkm71nIEmUMvnee7npyqwoe5p3qER4Yfj9FGKuaLFzT4nRqzDOYnJMIegSTPZos9RNOrugXIUnzKWGOYZ9EQ7AYRvEJ/YKWS/I+GFvlRA6YDUoieqkK3caYU3ReF4ZFMfCQeGiZr315OmiI2JI3SHk1QVmAzvlb0cW7I7vfkCxLbdkEZLBbLcVyJzNq72PPkDxsGOe8VrWboAgRSXnZt2xOttKKBHDNx7XsPaubz0JqVTexsDZbSo31t/zw/LPHEXoCW65cYECc52A6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdjE+hFPeL5EYERiPTUVQUx7B5eGkBAGpy3gawOvgg0=;
 b=H7NAGVY/S3MRYywVJH03NcAK5UG7Ux6ZSl4+dSBX6rouZyBFthDDtGfBID/gguA0ZC4+She41m2+17AkvMqraBc2i/dFQiQ/Iiqi2KEP6XKr8itM3jr4qkfCir9DRsbe4HvGovEmmxxewG+5LGu7oLLOzu6GNQTs43P973oe/yBAyTllIe+7WLIgraRpbmL3t3PBMFIqAbK9fudX+/og6+XgmPQTvvHWq3hJip7Is62sF6EdEdvZnabYQHTbOaB0U+tprhi8gbRE4S2M0LCzAXrpqwUhONJBPzUe4puJOatkuUTykbSINp2Ycai05a34xiCEQ49Hr34nXK75cTlqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdjE+hFPeL5EYERiPTUVQUx7B5eGkBAGpy3gawOvgg0=;
 b=S0+Ick5zLU97/5rKDjvVDmH7yxCLCjv+pgGHWIusG+iNvsdmVtFBfHet94X7V9lrSLeqN5D757kpNI3hJDd83nsGjpg3h8Nq/oudLH9Hyqz/Ito/JTxWfvuzt8u9eQXZoOjFEqMadgJpnM/z+r7I77c64OsDOniQTwLImOiqwRY=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6677.namprd02.prod.outlook.com (20.180.16.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 10 Jan 2020 14:19:34 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 14:19:34 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 01/14] net: xilinx: temac: Relax Kconfig dependencies
Thread-Topic: [PATCH 01/14] net: xilinx: temac: Relax Kconfig dependencies
Thread-Index: AQHVx6y1SoyxZ4Q7ME6tl1/NIG0R96fj8kow
Date:   Fri, 10 Jan 2020 14:19:34 +0000
Message-ID: <CH2PR02MB70008C3BB2B2F97F92573F11C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-2-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-2-andre.przywara@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 803b16b7-a392-4441-03dd-08d795d81e28
x-ms-traffictypediagnostic: CH2PR02MB6677:|CH2PR02MB6677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6677BD7AB3B7234153CE504DC7380@CH2PR02MB6677.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39850400004)(396003)(13464003)(199004)(189003)(53546011)(6506007)(26005)(52536014)(186003)(7696005)(316002)(478600001)(76116006)(66556008)(64756008)(8936002)(66946007)(66446008)(66476007)(2906002)(4326008)(81166006)(81156014)(8676002)(5660300002)(54906003)(86362001)(71200400001)(33656002)(110136005)(55016002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6677;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Pq2iq8XDQcBQuPe8VQYwbS+cnZDGLhZz4AKrQpvIVERqqbHYMXFAhBOQADKwFqbLsWrBCNgW4zvC804F3ieNzSyBJi2Tk3gBmV2odWsgq+t2qYhltdB4wMjxeSA6ZSXbpkq7nut3p1X8tklV7cIKJGPiig3TR7SQBMF1nBQNmeEb1iUw9P1deiLwYR0Y4KqT9tGenZVwDM3nQfvFUI4Zh7mbXKtgVsZ/mWHeTRfTbkiTA4+ioUOvBufIDkFnM/qbWJuSb5tyu6C1AILYTFGDlha6QgLzUKkQ2ARavMEOEah5ZJmJ7U4Vm5Mlu9eAIZBkgwg930h2aH/HtXHRnFeDJyqr37ffe5kpLq1z+OXvca7WD0RkgebclZdoGHxXixzkSt5Ljj6dq2LZSJ8FywR2LYTNKSDYAUspP4GQ/sPWDr1m0HTQlaFSF1F1a1NzB/uNd9XH+ZXnWiilqgpVzx/uUGHrJOWF5BlpuansDpzQNk19I5COWfYcW4fqDcgu3Ax
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803b16b7-a392-4441-03dd-08d795d81e28
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 14:19:34.5995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2E0IonE601k6AXjiST5bHw0WYR3eUrmD0yOGyyx3ReZtIHSZ4sR+ZfFR24tWDrV6mdYZE9ovUo/SAtTVDocxJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Friday, January 10, 2020 5:24 PM
> To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 01/14] net: xilinx: temac: Relax Kconfig dependencies
>=20
> Similar to axienet, the temac driver is now architecture agnostic, and
> can be at least compiled for several architectures.
> Especially the fact that this is a soft IP for implementing in FPGAs
> makes the current restriction rather pointless, as it could literally
> appear on any architecture, as long as an FPGA is connected to the bus.
>=20
> The driver hasn't been actually tried on any hardware, it is just a
> drive-by patch when doing the same for axienet (a similar patch for
> axienet is already merged).
>=20
> This (temac and axienet) have been compile-tested for:
> alpha hppa64 microblaze mips64 powerpc powerpc64 riscv64 s390 sparc64
> (using kernel.org cross compilers).
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Thanks!
> ---
>  drivers/net/ethernet/xilinx/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/Kconfig
> b/drivers/net/ethernet/xilinx/Kconfig
> index 6304ebd8b5c6..0810af8193cb 100644
> --- a/drivers/net/ethernet/xilinx/Kconfig
> +++ b/drivers/net/ethernet/xilinx/Kconfig
> @@ -32,7 +32,6 @@ config XILINX_AXI_EMAC
>=20
>  config XILINX_LL_TEMAC
>  	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
> -	depends on PPC || MICROBLAZE || X86 || COMPILE_TEST
>  	select PHYLIB
>  	---help---
>  	  This driver supports the Xilinx 10/100/1000 LocalLink TEMAC
> --
> 2.17.1

