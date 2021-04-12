Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F52E35C050
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbhDLJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:12:16 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:22240
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240768AbhDLJK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrN4RE33a1RflxZwv00ka9wrqrKQDFprVcaJ8Vpgzi2nsg0S72J04nmKOlFzrmKp4b++m9iikaYCRdhoBvArc52mSBc+pTtSUAoT/9cjH3UpnIGyJk7oS5Muc/xM+TuLntQvtfzwHTO1tKXRjcXYqfw0MUdsO7KscbzQjSx9pNP8LctU4CicrRA+DK+YATEx1CYiO2BFoaEe5X0wk0GbV6r+FkTDfN7knez1sBnppJCmMvVDPIGadJxoHmaKfMwSY9z/y8A2FrwzCrG4empVxtvAGna+Wj/qZAWgzKHPOue4Rszf2Z0gb+FcbIGJT3ispBeX+IpyeeIIsh4YDS91AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3A5Bs2MobUDyZvMoGPg7RO8bkeQTroVQhmSeqk0LJk=;
 b=Rcsc1rSbWOzeeTPC3Lyjv1fTAsdFegng6r52NEbyksZo+CUtWjscaOMr6pRaoCFfAV1LEkUxAQ+nzmELL0SVq7swvins+2gUM4F/Jq4ZmhzThB0v+AG8qiLaQT2/2U6PIwIYFnmVv3vgS0PPiHKarPjba2ZSLxPN1Rjv3qR/jsq9/g4+6GtIlLShS/NHoMm7SDOXR+3OZGgOka1xYRSesPHfKpGtDZv2eS7CphvL9MNoIplsPe83ODXkHH0EGHSrpvZ95wNT5N6P0phRCLxtGMC3uzYP4YVNzLaw2tfpR5i0bTk5UZE+6IDX+rjhyf2WbXxObVc6GriBrufy6sMa1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3A5Bs2MobUDyZvMoGPg7RO8bkeQTroVQhmSeqk0LJk=;
 b=YHGRzWTfr/iT2YP/583wgW/gt4wotFvCoQ6nfGvMVwfXB1c4NegaFDxph5yYdLPeqZKo17eAzi9iVtKj8j3gou6Nwj2Ufk/Fk4YX/Xif/gqlYWzL3XTeqQhhOOyDYTJ0j87MhPDpBK7R1uoMjHppoqaUM1A4Ws0t+97NAkf1JZ0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0401MB2589.eurprd04.prod.outlook.com (2603:10a6:800:4f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Mon, 12 Apr
 2021 09:10:35 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 09:10:35 +0000
Message-ID: <fb9ea1a13d2b88bada26cef4b75aa9401cb90dbe.camel@oss.nxp.com>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 12 Apr 2021 12:10:30 +0300
In-Reply-To: <bc84a0d0-a0c2-988d-3382-9ebd1a0a0233@gmail.com>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
         <bc84a0d0-a0c2-988d-3382-9ebd1a0a0233@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.141] (89.45.21.213) by AM8P189CA0020.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 09:10:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12875eeb-6108-4acb-5147-08d8fd92d4a9
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2589:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2589A36DBEF8596BE63ADB0C9F709@VI1PR0401MB2589.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l03d35dlzV8YTRtxgGSn5WX1Pf91VPPbPz6mFiwxI2miA2Kz2mVIbX7qGHegQnYVroDG7hNjXejisGizXg7djzucqY6qcGtCvBMU319ibZD0WCBdRLX4BqD3rP7PR4MHXc78jJsu5oP348vVsRT018oZ7mJIWzsXBm3LcrCYXuGLatEWr9NQnF/i96wnEecgckLET7RaPgZSsal50Y4uMEa2cuJ86GQdBv7cPCSDNbNX8K1Nm4OzfvvsWouOVsMxkcdI4JiBGvhQhByTZ4CBVaKGCpmew7av0nspbFB3C5Q/Clg1X7rVfjkRiggHsylQmqFooQ+zCOM+cnnFsfXSEE8Ot4O0syxjyzqxmQzTYqEAWkmG7jy2Ce5hBtWOTWsD6YJNskuGS+o/67h5A8lOcR1PMoKMQR0AEeTa4QWgoEcwQOQPzsewl6gvk7k9eWnThmgQ/csn05iOnXvfHexYOrKWZv67KlnSACB86FFdPEk7AiCU4WczCSP4TerDS5IpkFmHrOxsKUUXl2VaIIzi6hL57FDQcajcsX5pYQNamQhiCwbbhMETUEIgbAw5E+yzvXPTLJUmcOOX0EiSg+z7Ct4DsG4uzK28O8Ap3/+oL1TSkvb212bJnBaMLrQBQEKfv3CGTxw9910Sc6Tbh2I5QQjXxyXkghO5Fim58reuvmKR0q4r3OCh8NC2Ia6+xmPj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(66556008)(66946007)(30864003)(16526019)(186003)(5660300002)(66476007)(26005)(2906002)(16576012)(86362001)(956004)(83380400001)(53546011)(8936002)(316002)(478600001)(6486002)(8676002)(6666004)(4326008)(2616005)(38100700002)(52116002)(38350700002)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHhmaHZlS3ZmaTFjWHdOdUN5dnVQd2pGWGIveWRwUSsyL012a1p3b3NlbmxE?=
 =?utf-8?B?bFk1cGIxRDl3Tk9TY29JZ1kxV3JxR0xRR2pJVVVmWEdsTS9HYk5LMEFxMkI0?=
 =?utf-8?B?M1RmZGZxdW1OUi8zUXV3N2FBWSs1VW5rWjU3Z3YzeU5xaVdTRXU3SXRLU3Zw?=
 =?utf-8?B?R3N4R1JOWVB2S0RsMVE2ZlluU2h2TXladmNkbEx4TXVGdWFXM0RINy9TRTl3?=
 =?utf-8?B?NWZsZG0xWi8zdERCb0Jla2wrSkduWG9mZjg1eElCeXNka3d5bUNGNmNYN0pj?=
 =?utf-8?B?c1d3M2FVcE15S3pJUjAwazNPMzdSb1RKNFJmUzVIQTBNUXhKTlY3c0J5K29Z?=
 =?utf-8?B?N3N0dWRYbnVtUW5xdm4xcUdvV1pjaDJiSk1qenZ4YWJhK25QZ2xPRHRRdEc2?=
 =?utf-8?B?NmhBOTgyYWkxNXZ5MFVNU2cxMTBGNERlc1l5RTdhTUV4OWNVY2NRQ2lYMnJ5?=
 =?utf-8?B?V3dZS2lMQVZlbXBvTzA5YTJWRnhQYk1WMmtlRXhoT0crei9rL3BOM01SVUpT?=
 =?utf-8?B?UUlNOW8wbThhb0s4RkxIWWl1SFFnSDNpdkZVT0dYRkZZZ1lldFFCQXdKalNR?=
 =?utf-8?B?cmJPNzEzMGs4bEZMS3RRblZNbUFjYTlSZUNpNEJDclZtLzBWVzhjNGxOWFJq?=
 =?utf-8?B?dDZBMEJKa1JXTTFZbTd3NzNuRUptTTVKeElXdTZNbmRDTzhJQVFidzkzUFZz?=
 =?utf-8?B?Q2NjSG5UcU9ETEd0bE9JT01wNmVRV2FLVHBwZlhNTVRuMFdWbkY4WHhGcG9m?=
 =?utf-8?B?ODRkUDYwd3lYRmJMYTNYUldKbmhjcEwycnh5ODg1cVJIMC8vSjRvK1ZMQlBj?=
 =?utf-8?B?RmhZVU1SN2xJQy91Tnh2ZStYL3NqUkIvTC8xY28wOGFVeCtEeDJ3L1pNWnhx?=
 =?utf-8?B?NndvWFhkWC9EM0hXTElFZ2FSRzl5OG1nNFFOQnlGeXByNHR0OTR5WXZ1S1Zp?=
 =?utf-8?B?N0ZCdmZCR2ZpNGFLK0JHaHdWeHdZL3lPUzhTRFdmeGtsNWRTTUpnd2NyaDR4?=
 =?utf-8?B?cmwyVU0wTFlla0NWUkVOZkE5RHBXT2FpZDVRNENUZ2FobDhiK2ZickhzUUlr?=
 =?utf-8?B?MWhlRm4wNG9KYllFUGtKVHVGVWhQMHNoZ2RBMHhURnJPYXA0MEgvWDF4SERP?=
 =?utf-8?B?L2twdytwSWo3Q0EwNGVQbE5mbXJ1dnFraktjTWlvcTQvZi81VUcyODJtbGg1?=
 =?utf-8?B?NFJWajBQS3hnbWNLbnVkUGVPcHhJeHh4enJFRVFmMUhsMXVwVGRvSkFXTHF5?=
 =?utf-8?B?U3k0Sm9oQkEvbDd2Q0EreUZCZDAzWUNQYzRwbjZrT2FQaW5ML2pMUWcycStr?=
 =?utf-8?B?RDJDdVdQcWZFalVVaXRoV29zNXpYanROQU50MGhUS0FlR3V3ZFZtZC9NZmIr?=
 =?utf-8?B?eTZsZzU0Mlo1cEJaM3o1YTVPUEZDbTJhZi9rZ1lDalExdk0xbTdTMm41dnRU?=
 =?utf-8?B?bklOOEJ0Z0dsWWxmcTZOd2J6Z1BGd01FWmlmY3BHdHcyM21HY0Y1U1NRV2o4?=
 =?utf-8?B?VXNsNlhjcjgwRmlVSXIvZ2V0dlRkVGZtZDduT05JUTFsZFp0ODJOVy93cEpG?=
 =?utf-8?B?YnVvbzJOR2RxbzRsajdHck8wbnVGYnBob0pFY3NMOGloMjdvVnJCSUhUcG1i?=
 =?utf-8?B?enlNOTRzMjhMTzdNYVJZQWxyNmtqRCsyMnc3VDA4andEalh3bU9PeHBmSkVI?=
 =?utf-8?B?b01kK09WRkR1TUo3bTVwQzljYmJJeXZMMlgwQU1Rd3ZXSWVxS0FkT0tQUmti?=
 =?utf-8?Q?FcVbXqRpqG3Pws0J8p+RONdyGFa5H25QAsD18QQ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12875eeb-6108-4acb-5147-08d8fd92d4a9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 09:10:35.4470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQmnjAofMt3er99CpJ6zp4LQX9qFzwWsUP5AghKJB/Ch85AfMzfwL1GrfPeysIC50OdVTg1+6ij6yUd0A5q8bXNIKVYSLJtg7zeuKwlq72k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 21:18 +0200, Heiner Kallweit wrote:
> On 09.04.2021 20:41, Radu Pirea (NXP OSS) wrote:
> > Add driver for tja1103 driver and for future NXP C45 PHYs.
> > 
> > Signed-off-by: Radu Pirea (NXP OSS)
> > <radu-nicolae.pirea@oss.nxp.com>
> > ---
> >  MAINTAINERS               |   6 +
> >  drivers/net/phy/Kconfig   |   6 +
> >  drivers/net/phy/Makefile  |   1 +
> >  drivers/net/phy/nxp-c45.c | 622
> > ++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 635 insertions(+)
> >  create mode 100644 drivers/net/phy/nxp-c45.c
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index a008b70f3c16..082a5eca8913 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -12518,6 +12518,12 @@ F:     drivers/nvmem/
> >  F:     include/linux/nvmem-consumer.h
> >  F:     include/linux/nvmem-provider.h
> >  
> > +NXP C45 PHY DRIVER
> > +M:     Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
> > +L:     netdev@vger.kernel.org
> > +S:     Maintained
> > +F:     drivers/net/phy/nxp-c45.c
> > +
> >  NXP FSPI DRIVER
> >  M:     Ashish Kumar <ashish.kumar@nxp.com>
> >  R:     Yogesh Gaur <yogeshgaur.83@gmail.com>
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 698bea312adc..fd2da80b5339 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -228,6 +228,12 @@ config NATIONAL_PHY
> >         help
> >           Currently supports the DP83865 PHY.
> >  
> > +config NXP_C45_PHY
> > +       tristate "NXP C45 PHYs"
> > +       help
> > +         Enable support for NXP C45 PHYs.
> > +         Currently supports only the TJA1103 PHY.
> > +
> >  config NXP_TJA11XX_PHY
> >         tristate "NXP TJA11xx PHYs support"
> >         depends on HWMON
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index a13e402074cf..a18f095748b5 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -70,6 +70,7 @@ obj-$(CONFIG_MICROCHIP_PHY)   += microchip.o
> >  obj-$(CONFIG_MICROCHIP_T1_PHY) += microchip_t1.o
> >  obj-$(CONFIG_MICROSEMI_PHY)    += mscc/
> >  obj-$(CONFIG_NATIONAL_PHY)     += national.o
> > +obj-$(CONFIG_NXP_C45_PHY)      += nxp-c45.o
> >  obj-$(CONFIG_NXP_TJA11XX_PHY)  += nxp-tja11xx.o
> >  obj-$(CONFIG_QSEMI_PHY)                += qsemi.o
> >  obj-$(CONFIG_REALTEK_PHY)      += realtek.o
> > diff --git a/drivers/net/phy/nxp-c45.c b/drivers/net/phy/nxp-c45.c
> > new file mode 100644
> > index 000000000000..2961799f7d05
> > --- /dev/null
> > +++ b/drivers/net/phy/nxp-c45.c
> > @@ -0,0 +1,622 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* NXP C45 PHY driver
> > + * Copyright (C) 2021 NXP
> > + * Copyright (C) 2021 Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/ethtool.h>
> > +#include <linux/ethtool_netlink.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mii.h>
> > +#include <linux/module.h>
> > +#include <linux/phy.h>
> > +#include <linux/processor.h>
> > +#include <linux/property.h>
> > +
> > +#define PHY_ID_BASE_T1                 0x001BB010
> > +
> > +#define B100T1_PMAPMD_CTL              0x0834
> > +#define B100T1_PMAPMD_CONFIG_EN                BIT(15)
> > +#define B100T1_PMAPMD_MASTER           BIT(14)
> > +#define MASTER_MODE                    (B100T1_PMAPMD_CONFIG_EN |
> > B100T1_PMAPMD_MASTER)
> > +#define SLAVE_MODE                     (B100T1_PMAPMD_CONFIG_EN)
> > +
> > +#define DEVICE_CONTROL                 0x0040
> > +#define DEVICE_CONTROL_RESET           BIT(15)
> > +#define DEVICE_CONTROL_CONFIG_GLOBAL_EN        BIT(14)
> > +#define DEVICE_CONTROL_CONFIG_ALL_EN   BIT(13)
> > +#define RESET_POLL_NS                  (250 * NSEC_PER_MSEC)
> > +
> > +#define PHY_CONTROL                    0x8100
> > +#define PHY_CONFIG_EN                  BIT(14)
> > +#define PHY_START_OP                   BIT(0)
> > +
> > +#define PHY_CONFIG                     0x8108
> > +#define PHY_CONFIG_AUTO                        BIT(0)
> > +
> > +#define SIGNAL_QUALITY                 0x8320
> > +#define SQI_VALID                      BIT(14)
> > +#define SQI_MASK                       GENMASK(2, 0)
> > +#define MAX_SQI                                SQI_MASK
> > +
> > +#define CABLE_TEST                     0x8330
> > +#define CABLE_TEST_ENABLE              BIT(15)
> > +#define CABLE_TEST_START               BIT(14)
> > +#define CABLE_TEST_VALID               BIT(13)
> > +#define CABLE_TEST_OK                  0x00
> > +#define CABLE_TEST_SHORTED             0x01
> > +#define CABLE_TEST_OPEN                        0x02
> > +#define CABLE_TEST_UNKNOWN             0x07
> > +
> > +#define PORT_CONTROL                   0x8040
> > +#define PORT_CONTROL_EN                        BIT(14)
> > +
> > +#define PORT_INFRA_CONTROL             0xAC00
> > +#define PORT_INFRA_CONTROL_EN          BIT(14)
> > +
> > +#define VND1_RXID                      0xAFCC
> > +#define VND1_TXID                      0xAFCD
> > +#define ID_ENABLE                      BIT(15)
> > +
> > +#define ABILITIES                      0xAFC4
> > +#define RGMII_ID_ABILITY               BIT(15)
> > +#define RGMII_ABILITY                  BIT(14)
> > +#define RMII_ABILITY                   BIT(10)
> > +#define REVMII_ABILITY                 BIT(9)
> > +#define MII_ABILITY                    BIT(8)
> > +#define SGMII_ABILITY                  BIT(0)
> > +
> > +#define MII_BASIC_CONFIG               0xAFC6
> > +#define MII_BASIC_CONFIG_REV           BIT(8)
> > +#define MII_BASIC_CONFIG_SGMII         0x9
> > +#define MII_BASIC_CONFIG_RGMII         0x7
> > +#define MII_BASIC_CONFIG_RMII          0x5
> > +#define MII_BASIC_CONFIG_MII           0x4
> > +
> > +#define SYMBOL_ERROR_COUNTER           0x8350
> > +#define LINK_DROP_COUNTER              0x8352
> > +#define LINK_LOSSES_AND_FAILURES       0x8353
> > +#define R_GOOD_FRAME_CNT               0xA950
> > +#define R_BAD_FRAME_CNT                        0xA952
> > +#define R_RXER_FRAME_CNT               0xA954
> > +#define RX_PREAMBLE_COUNT              0xAFCE
> > +#define TX_PREAMBLE_COUNT              0xAFCF
> > +#define RX_IPG_LENGTH                  0xAFD0
> > +#define TX_IPG_LENGTH                  0xAFD1
> > +#define COUNTERS_EN                    BIT(15)
> > +
> > +#define CLK_25MHZ_PS_PERIOD            40000UL
> > +#define PS_PER_DEGREE                  (CLK_25MHZ_PS_PERIOD / 360)
> > +#define MIN_ID_PS                      8222U
> > +#define MAX_ID_PS                      11300U
> > +
> > +struct nxp_c45_phy {
> > +       u32 tx_delay;
> > +       u32 rx_delay;
> > +};
> > +
> > +struct nxp_c45_phy_stats {
> > +       const char      *name;
> > +       u8              mmd;
> > +       u16             reg;
> > +       u8              off;
> > +       u16             mask;
> > +};
> > +
> > +static const struct nxp_c45_phy_stats nxp_c45_hw_stats[] = {
> > +       { "phy_symbol_error_cnt", MDIO_MMD_VEND1,
> > SYMBOL_ERROR_COUNTER, 0, GENMASK(15, 0) },
> > +       { "phy_link_status_drop_cnt", MDIO_MMD_VEND1,
> > LINK_DROP_COUNTER, 8, GENMASK(13, 8) },
> > +       { "phy_link_availability_drop_cnt", MDIO_MMD_VEND1,
> > LINK_DROP_COUNTER, 0, GENMASK(5, 0) },
> > +       { "phy_link_loss_cnt", MDIO_MMD_VEND1,
> > LINK_LOSSES_AND_FAILURES, 10, GENMASK(15, 10) },
> > +       { "phy_link_failure_cnt", MDIO_MMD_VEND1,
> > LINK_LOSSES_AND_FAILURES, 0, GENMASK(9, 0) },
> > +       { "r_good_frame_cnt", MDIO_MMD_VEND1, R_GOOD_FRAME_CNT, 0,
> > GENMASK(15, 0) },
> > +       { "r_bad_frame_cnt", MDIO_MMD_VEND1, R_BAD_FRAME_CNT, 0,
> > GENMASK(15, 0) },
> > +       { "r_rxer_frame_cnt", MDIO_MMD_VEND1, R_RXER_FRAME_CNT, 0,
> > GENMASK(15, 0) },
> > +       { "rx_preamble_count", MDIO_MMD_VEND1, RX_PREAMBLE_COUNT,
> > 0, GENMASK(5, 0) },
> > +       { "tx_preamble_count", MDIO_MMD_VEND1, TX_PREAMBLE_COUNT,
> > 0, GENMASK(5, 0) },
> > +       { "rx_ipg_length", MDIO_MMD_VEND1, RX_IPG_LENGTH, 0,
> > GENMASK(8, 0) },
> > +       { "tx_ipg_length", MDIO_MMD_VEND1, TX_IPG_LENGTH, 0,
> > GENMASK(8, 0) },
> > +};
> > +
> > +static int nxp_c45_get_sset_count(struct phy_device *phydev)
> > +{
> > +       return ARRAY_SIZE(nxp_c45_hw_stats);
> > +}
> > +
> > +static void nxp_c45_get_strings(struct phy_device *phydev, u8
> > *data)
> > +{
> > +       size_t i;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(nxp_c45_hw_stats); i++) {
> > +               strncpy(data + i * ETH_GSTRING_LEN,
> > +                       nxp_c45_hw_stats[i].name, ETH_GSTRING_LEN);
> > +       }
> > +}
> > +
> > +static void nxp_c45_get_stats(struct phy_device *phydev,
> > +                             struct ethtool_stats *stats, u64
> > *data)
> > +{
> > +       size_t i;
> > +       int ret;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(nxp_c45_hw_stats); i++) {
> > +               ret = phy_read_mmd(phydev, nxp_c45_hw_stats[i].mmd,
> > nxp_c45_hw_stats[i].reg);
> > +               if (ret < 0) {
> > +                       data[i] = U64_MAX;
> > +               } else {
> > +                       data[i] = ret & nxp_c45_hw_stats[i].mask;
> > +                       data[i] >>= nxp_c45_hw_stats[i].off;
> > +               }
> > +       }
> > +}
> > +
> > +static int nxp_c45_config_enable(struct phy_device *phydev)
> > +{
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL,
> > DEVICE_CONTROL_CONFIG_GLOBAL_EN |
> > +                     DEVICE_CONTROL_CONFIG_ALL_EN);
> > +       usleep_range(400, 450);
> > +
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, PORT_CONTROL,
> > PORT_CONTROL_EN);
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL,
> > PHY_CONFIG_EN);
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, PORT_INFRA_CONTROL,
> > PORT_INFRA_CONTROL_EN);
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_start_op(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL);
> > +       reg |= PHY_START_OP;
> > +
> > +       return phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONTROL,
> > reg);
> 
> You may want to use phy_set_bits_mmd() here. Similar comment
> applies to other places in the driver where phy_clear_bits_mmd()
> and phy_modify_mmd() could be used.
Thank you for suggestion. I will consider this. 
> 
> > +}
> > +
> > +static bool nxp_c45_can_sleep(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT1);
> > +       if (reg < 0)
> > +               return false;
> > +
> > +       return !!(reg & MDIO_STAT1_LPOWERABLE);
> > +}
> > +
> > +static int nxp_c45_resume(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       if (!nxp_c45_can_sleep(phydev))
> > +               return -EOPNOTSUPP;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> > +       reg &= ~MDIO_CTRL1_LPOWER;
> > +       phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_suspend(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       if (!nxp_c45_can_sleep(phydev))
> > +               return -EOPNOTSUPP;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
> > +       reg |= MDIO_CTRL1_LPOWER;
> > +       phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, reg);
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_reset_done(struct phy_device *phydev)
> > +{
> > +       return !(phy_read_mmd(phydev, MDIO_MMD_VEND1,
> > DEVICE_CONTROL) & DEVICE_CONTROL_RESET);
> > +}
> > +
> > +static int nxp_c45_reset_done_or_timeout(struct phy_device
> > *phydev,
> > +                                        ktime_t timeout)
> > +{
> > +       ktime_t cur = ktime_get();
> > +
> > +       return nxp_c45_reset_done(phydev) || ktime_after(cur,
> > timeout);
> > +}
> > +
> > +static int nxp_c45_soft_reset(struct phy_device *phydev)
> > +{
> > +       ktime_t timeout;
> > +       int ret;
> > +
> > +       ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, DEVICE_CONTROL,
> > DEVICE_CONTROL_RESET);
> > +       if (ret)
> > +               return ret;
> > +
> > +       timeout = ktime_add_ns(ktime_get(), RESET_POLL_NS);
> > +       spin_until_cond(nxp_c45_reset_done_or_timeout(phydev,
> > timeout));
> > +       if (!nxp_c45_reset_done(phydev)) {
> > +               phydev_err(phydev, "reset fail\n");
> > +               return -EIO;
> > +       }
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_cable_test_start(struct phy_device *phydev)
> > +{
> > +       return phy_write_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST,
> > +                            CABLE_TEST_ENABLE | CABLE_TEST_START);
> > +}
> > +
> > +static int nxp_c45_cable_test_get_status(struct phy_device
> > *phydev,
> > +                                        bool *finished)
> > +{
> > +       int ret;
> > +       u8 cable_test_result;
> > +
> > +       ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST);
> > +       if (!(ret & CABLE_TEST_VALID)) {
> > +               *finished = false;
> > +               return 0;
> > +       }
> > +
> > +       *finished = true;
> > +       cable_test_result = ret & GENMASK(2, 0);
> > +
> > +       switch (cable_test_result) {
> > +       case CABLE_TEST_OK:
> > +               ethnl_cable_test_result(phydev,
> > ETHTOOL_A_CABLE_PAIR_A,
> > +                                       ETHTOOL_A_CABLE_RESULT_CODE
> > _OK);
> > +               break;
> > +       case CABLE_TEST_SHORTED:
> > +               ethnl_cable_test_result(phydev,
> > ETHTOOL_A_CABLE_PAIR_A,
> > +                                       ETHTOOL_A_CABLE_RESULT_CODE
> > _SAME_SHORT);
> > +               break;
> > +       case CABLE_TEST_OPEN:
> > +               ethnl_cable_test_result(phydev,
> > ETHTOOL_A_CABLE_PAIR_A,
> > +                                       ETHTOOL_A_CABLE_RESULT_CODE
> > _OPEN);
> > +               break;
> > +       default:
> > +               ethnl_cable_test_result(phydev,
> > ETHTOOL_A_CABLE_PAIR_A,
> > +                                       ETHTOOL_A_CABLE_RESULT_CODE
> > _UNSPEC);
> > +       }
> > +
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, CABLE_TEST, 0);
> > +
> > +       return nxp_c45_start_op(phydev);
> > +}
> > +
> > +static int nxp_c45_setup_master_slave(struct phy_device *phydev)
> > +{
> > +       switch (phydev->master_slave_set) {
> > +       case MASTER_SLAVE_CFG_MASTER_FORCE:
> > +       case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> > +               phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
> > B100T1_PMAPMD_CTL, MASTER_MODE);
> > +               break;
> > +       case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> > +       case MASTER_SLAVE_CFG_SLAVE_FORCE:
> > +               phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
> > B100T1_PMAPMD_CTL, SLAVE_MODE);
> > +               break;
> > +       case MASTER_SLAVE_CFG_UNKNOWN:
> > +       case MASTER_SLAVE_CFG_UNSUPPORTED:
> > +               return 0;
> > +       default:
> > +               phydev_warn(phydev, "Unsupported Master/Slave
> > mode\n");
> > +               return -EOPNOTSUPP;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_read_master_slave(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
> > +       phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> > B100T1_PMAPMD_CTL);
> > +       if (reg < 0)
> > +               return reg;
> > +
> > +       if (reg & B100T1_PMAPMD_MASTER) {
> > +               phydev->master_slave_get =
> > MASTER_SLAVE_CFG_MASTER_FORCE;
> > +               phydev->master_slave_state =
> > MASTER_SLAVE_STATE_MASTER;
> > +       } else {
> > +               phydev->master_slave_get =
> > MASTER_SLAVE_CFG_SLAVE_FORCE;
> > +               phydev->master_slave_state =
> > MASTER_SLAVE_STATE_SLAVE;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_config_aneg(struct phy_device *phydev)
> > +{
> > +       return nxp_c45_setup_master_slave(phydev);
> > +}
> > +
> > +static int nxp_c45_read_status(struct phy_device *phydev)
> > +{
> > +       int ret;
> > +
> > +       ret = genphy_c45_read_status(phydev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret = nxp_c45_read_master_slave(phydev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_set_loopback(struct phy_device *phydev, bool
> > enable)
> > +{
> > +       int reg;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1);
> > +       if (reg < 0)
> > +               return reg;
> > +
> > +       if (enable)
> > +               reg |= MDIO_PCS_CTRL1_LOOPBACK;
> > +       else
> > +               reg &= ~MDIO_PCS_CTRL1_LOOPBACK;
> > +
> > +       phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1, reg);
> > +
> > +       phydev->loopback_enabled = enable;
> > +
> > +       phydev_dbg(phydev, "Loopback %s\n", enable ? "enabled" :
> > "disabled");
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_get_sqi(struct phy_device *phydev)
> > +{
> > +       int reg;
> > +
> > +       reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, SIGNAL_QUALITY);
> > +       if (!(reg & SQI_VALID))
> > +               return -EINVAL;
> > +
> > +       reg &= SQI_MASK;
> > +
> > +       return reg;
> > +}
> > +
> > +static int nxp_c45_get_sqi_max(struct phy_device *phydev)
> > +{
> > +       return MAX_SQI;
> > +}
> > +
> > +static int nxp_c45_check_delay(struct phy_device *phydev, u32
> > delay)
> > +{
> > +       if (delay < MIN_ID_PS) {
> > +               phydev_err(phydev, "delay value smaller than %u\n",
> > MIN_ID_PS);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (delay > MAX_ID_PS) {
> > +               phydev_err(phydev, "delay value higher than %u\n",
> > MAX_ID_PS);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static u64 nxp_c45_get_phase_shift(u64 phase_offset_raw)
> > +{
> > +       /* The delay in degree phase is 73.8 + phase_offset_raw *
> > 0.9.
> > +        * To avoid floating point operations we'll multiply by 10
> > +        * and get 1 decimal point precision.
> > +        */
> > +       phase_offset_raw *= 10;
> > +       return (phase_offset_raw - 738) / 9;
> > +}
> > +
> > +static void nxp_c45_set_delays(struct phy_device *phydev)
> > +{
> > +       struct nxp_c45_phy *priv = phydev->priv;
> > +       u64 tx_delay = priv->tx_delay;
> > +       u64 rx_delay = priv->rx_delay;
> > +       u64 degree;
> > +
> > +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> > +               degree = tx_delay / PS_PER_DEGREE;
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_TXID,
> > +                             ID_ENABLE |
> > nxp_c45_get_phase_shift(degree));
> > +       }
> > +
> > +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +           phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> > +               degree = rx_delay / PS_PER_DEGREE;
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_RXID,
> > +                             ID_ENABLE |
> > nxp_c45_get_phase_shift(degree));
> > +       }
> > +}
> > +
> > +static int nxp_c45_get_delays(struct phy_device *phydev)
> > +{
> > +       struct nxp_c45_phy *priv = phydev->priv;
> > +       int ret;
> > +
> > +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> > +               ret = device_property_read_u32(&phydev->mdio.dev,
> > "tx-internal-delay-ps",
> > +                                              &priv->tx_delay);
> > +               if (ret) {
> > +                       phydev_err(phydev, "tx-internal-delay-ps
> > property missing\n");
> > +                       return ret;
> > +               }
> > +               ret = nxp_c45_check_delay(phydev, priv->tx_delay);
> > +               if (ret) {
> > +                       phydev_err(phydev, "tx-internal-delay-ps
> > invalid value\n");
> > +                       return ret;
> > +               }
> > +       }
> > +
> > +       if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > +           phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> > +               ret = device_property_read_u32(&phydev->mdio.dev,
> > "rx-internal-delay-ps",
> > +                                              &priv->rx_delay);
> > +               if (ret) {
> > +                       phydev_err(phydev, "rx-internal-delay-ps
> > property missing\n");
> > +                       return ret;
> > +               }
> > +               ret = nxp_c45_check_delay(phydev, priv->rx_delay);
> > +               if (ret) {
> > +                       phydev_err(phydev, "rx-internal-delay-ps
> > invalid value\n");
> > +                       return ret;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_set_phy_mode(struct phy_device *phydev)
> > +{
> > +       int ret;
> > +
> > +       ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ABILITIES);
> > +       phydev_dbg(phydev, "Clause 45 managed PHY abilities
> > 0x%x\n", ret);
> > +
> > +       switch (phydev->interface) {
> > +       case PHY_INTERFACE_MODE_RGMII:
> > +               if (!(ret & RGMII_ABILITY)) {
> > +                       phydev_err(phydev, "rgmii mode not
> > supported\n");
> > +                       return -EINVAL;
> > +               }
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
> > +               break;
> > +       case PHY_INTERFACE_MODE_RGMII_ID:
> > +       case PHY_INTERFACE_MODE_RGMII_TXID:
> > +       case PHY_INTERFACE_MODE_RGMII_RXID:
> > +               if (!(ret & RGMII_ID_ABILITY)) {
> > +                       phydev_err(phydev, "rgmii-id, rgmii-txid,
> > rgmii-rxid modes are not supported\n");
> > +                       return -EINVAL;
> > +               }
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
> > +               ret = nxp_c45_get_delays(phydev);
> > +               if (ret)
> > +                       return ret;
> > +
> > +               nxp_c45_set_delays(phydev);
> > +               break;
> > +       case PHY_INTERFACE_MODE_MII:
> > +               if (!(ret & MII_ABILITY)) {
> > +                       phydev_err(phydev, "mii mode not
> > supported\n");
> > +                       return -EINVAL;
> > +               }
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > MII_BASIC_CONFIG, MII_BASIC_CONFIG_MII);
> > +               break;
> > +       case PHY_INTERFACE_MODE_REVMII:
> > +               if (!(ret & REVMII_ABILITY)) {
> > +                       phydev_err(phydev, "rev-mii mode not
> > supported\n");
> > +                       return -EINVAL;
> > +               }
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > MII_BASIC_CONFIG, MII_BASIC_CONFIG_MII |
> > +                             MII_BASIC_CONFIG_REV);
> > +               break;
> > +       case PHY_INTERFACE_MODE_RMII:
> > +               if (!(ret & RMII_ABILITY)) {
> > +                       phydev_err(phydev, "rmii mode not
> > supported\n");
> > +                       return -EINVAL;
> > +               }
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > MII_BASIC_CONFIG, MII_BASIC_CONFIG_RMII);
> > +               break;
> > +       case PHY_INTERFACE_MODE_SGMII:
> > +               if (!(ret & SGMII_ABILITY)) {
> > +                       phydev_err(phydev, "sgmii mode not
> > supported\n");
> > +                       return -EINVAL;
> > +               }
> > +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> > MII_BASIC_CONFIG, MII_BASIC_CONFIG_SGMII);
> > +               break;
> > +       case PHY_INTERFACE_MODE_INTERNAL:
> > +               break;
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int nxp_c45_config_init(struct phy_device *phydev)
> > +{
> > +       int ret;
> > +
> > +       ret = nxp_c45_config_enable(phydev);
> > +       if (ret) {
> > +               phydev_err(phydev, "Failed to enable config\n");
> > +               return ret;
> > +       }
> > +
> > +       ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, PHY_CONFIG);
> > +       ret &= ~PHY_CONFIG_AUTO;
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, PHY_CONFIG, ret);
> > +
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, LINK_DROP_COUNTER,
> > COUNTERS_EN);
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, RX_PREAMBLE_COUNT,
> > COUNTERS_EN);
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, TX_PREAMBLE_COUNT,
> > COUNTERS_EN);
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, RX_IPG_LENGTH,
> > COUNTERS_EN);
> > +       phy_write_mmd(phydev, MDIO_MMD_VEND1, TX_IPG_LENGTH,
> > COUNTERS_EN);
> > +
> > +       ret = nxp_c45_set_phy_mode(phydev);
> > +       if (ret)
> > +               return ret;
> > +
> > +       phydev->autoneg = AUTONEG_DISABLE;
> > +
> > +       return nxp_c45_start_op(phydev);
> > +}
> > +
> > +static int nxp_c45_probe(struct phy_device *phydev)
> > +{
> > +       struct nxp_c45_phy *priv;
> > +
> > +       priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv),
> > GFP_KERNEL);
> > +       if (!priv)
> > +               return -ENOMEM;
> > +
> > +       phydev->priv = priv;
> > +
> > +       return 0;
> > +}
> > +
> > +static struct phy_driver nxp_c45_driver[] = {
> > +       {
> > +               PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1),
> > +               .name                   = "NXP C45 BASE-T1",
> > +               .features               = PHY_BASIC_T1_FEATURES,
> > +               .probe                  = nxp_c45_probe,
> > +               .soft_reset             = nxp_c45_soft_reset,
> > +               .config_aneg            = nxp_c45_config_aneg,
> > +               .config_init            = nxp_c45_config_init,
> > +               .read_status            = nxp_c45_read_status,
> > +               .suspend                = nxp_c45_suspend,
> > +               .resume                 = nxp_c45_resume,
> > +               .get_sset_count         = nxp_c45_get_sset_count,
> > +               .get_strings            = nxp_c45_get_strings,
> > +               .get_stats              = nxp_c45_get_stats,
> > +               .cable_test_start       = nxp_c45_cable_test_start,
> > +               .cable_test_get_status  =
> > nxp_c45_cable_test_get_status,
> > +               .set_loopback           = nxp_c45_set_loopback,
> > +               .get_sqi                = nxp_c45_get_sqi,
> > +               .get_sqi_max            = nxp_c45_get_sqi_max,
> 
> How about interrupt support?
Unfortunately my setup is a bit limited and I can't test the
interrupts. However, I am planning to add interrupt support in a
further patch.
> 
> > +       },
> > +};
> > +
> > +module_phy_driver(nxp_c45_driver);
> > +
> > +static struct mdio_device_id __maybe_unused nxp_c45_tbl[] = {
> > +       { PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1) }
> > +};
> > +
> > +MODULE_DEVICE_TABLE(mdio, nxp_c45_tbl);
> > +
> > +MODULE_AUTHOR("Radu Pirea <radu-nicolae.pirea@oss.nxp.com>");
> > +MODULE_DESCRIPTION("NXP C45 PHY driver");
> > +MODULE_LICENSE("GPL v2");
> > 
> 


