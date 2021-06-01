Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FA13975BB
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhFAOsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:48:08 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:30290 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233797AbhFAOsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:48:07 -0400
X-Greylist: delayed 25283 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2021 10:48:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622558783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMFvSAk0zuEs+7BsueSQ+g685bKfoBI20W1XYRYl9YY=;
        b=tvx5pvu9QeBAkaoPaBp9ztUA2+H+2f8LKcS/0YpOl0XqrUUNMuQ/Tc7JYHT6T4pwzOW8wS
        IkGJIz+FGNX/iOVl0u82AYUzS/CvcpiLJqZbOdTNywzg4hr3FUFaSmenF8R7vntd9Px0BX
        3C5vyIejcHLSa5GMG1d2udoDH1ck20I=
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-6_a4SyTRP9WBlN-8oHkcXw-1; Tue, 01 Jun 2021 10:46:21 -0400
X-MC-Unique: 6_a4SyTRP9WBlN-8oHkcXw-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MWHPR19MB1232.namprd19.prod.outlook.com (2603:10b6:320:2d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Tue, 1 Jun
 2021 14:46:19 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::2d80:e649:6607:602]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::2d80:e649:6607:602%7]) with mapi id 15.20.4150.032; Tue, 1 Jun 2021
 14:46:19 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXVroHEbMjrtQ6106BPmeNcMQqZar/CI6AgAAzv4A=
Date:   Tue, 1 Jun 2021 14:46:19 +0000
Message-ID: <56251b2c-5a81-e739-fa78-5ddce46f9371@maxlinear.com>
References: <20210601074427.40990-1-lxu@maxlinear.com>
 <20210601114105.GA26705@linux.intel.com>
In-Reply-To: <20210601114105.GA26705@linux.intel.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
x-originating-ip: [138.75.151.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f72ac3a-f9d1-4bba-1af5-08d9250c0453
x-ms-traffictypediagnostic: MWHPR19MB1232:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR19MB12322E6940103BD59F25FF63BD3E9@MWHPR19MB1232.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: HZ6PUt2pGNP0K9ORFhFz+lQy76MrC6J7QD2jNAOJ5fWqK1ve0ti0QU3rlDLLzcbXpEdHnLJFV6oR9H+W2dW4LQMf/lD+Bx87QxBMwsZAmkr2i+hjj0bu6/f5SU7cE+9iiTytSvaFs65YG9bC6CvKV2XdJTCfSTEz7bksGC1TS1n5nLe8TCqjhNT4wKtdZ0qsV7BhdAEHpJLQAJufnjwvSNhTtjFk/oHjkDY9zLcm3Nu4eW6k9mKyFb139EDm80lSG0akcj9aHPZV5TLNd4/jeJljQHdzpQO4+7SrnsD31Lc7KnE53vHFr+jQgjEMACoo/j+B4NNlQF0u+QvwnDVamGiN5e++SwFYPTedey51wSLdWZOPf69h1SBd7CrAMDEo0JOlpYX/OI7omFOhb7fChg0H/AQjB37Ac9a+IdhIbONUcAjxbUB16c7uFH8GG+WN9cEg6lH0R3q7ZWMY4nhYuMLsI0/0QDydI4X0agRKxYW5r5dybUpL45tDi78+glEuat3TvHER01lfCiK9dLas5i6yVTNQlwzdvwCFHAHD742yO+L9z7hPl4jEM2ckaHeQYAxfy5lndKD8Th/5yp/M7F+HIWv24v2siqg01y7rjgOuTgnGXo33N8F7+QfHGv2yzczdpx2wzTRv57SP/FAvuaa2eMDxkZL7GR8vy/FMbJNYVFUKcobPduHuBpycJkZf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39840400004)(376002)(346002)(6512007)(53546011)(5660300002)(4326008)(38100700002)(66476007)(6916009)(186003)(6506007)(316002)(31696002)(36756003)(30864003)(54906003)(107886003)(2906002)(91956017)(83380400001)(31686004)(478600001)(6486002)(66946007)(66446008)(64756008)(8936002)(76116006)(66556008)(86362001)(122000001)(26005)(8676002)(71200400001)(2616005)(45980500001)(43740500002)(579004);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?HZiSUz3bGJL9hsr/Dc/PIT8RG8N3LXZ+NdMmGwd1kKCVYRqjja3ZYm5K?=
 =?Windows-1252?Q?GTHbF/IyfpjlMC/z79+yzbilXD62ECDKKIkSM892juke3RNREgkzHtEr?=
 =?Windows-1252?Q?TM0tUzVsZIgYrYgmBmMUtpimgI5mOPUb3ZUZmTAzdJceDLoFs2hGW3DP?=
 =?Windows-1252?Q?PuHSb7wz1S8S/nIe5nrckCtsmJyDmb4z76biiZVGEABNc3fnfEj/CmwC?=
 =?Windows-1252?Q?WwVLBqLx4FUgl1/seD085WKFooSXE4yikOyl/10TEvCKsa2WUKVKIC3R?=
 =?Windows-1252?Q?qfYkcpLnj8dvr8ZAici8YE0fL1EB0kDwKVhdIITPl1s4wE5fQb5LHNj3?=
 =?Windows-1252?Q?mJ0QcKUBFffafLV+JbKQvV0KStSN9pgJuliaCbVb5ie6S430waSoKFvp?=
 =?Windows-1252?Q?uZdhZCE9KBR3lRzn5/+EUkC5j51Ed8khaqUuf6PfoDseL5AUSNy4SE3p?=
 =?Windows-1252?Q?KYmdImsISd+pOuyTQ+gj6IB7XQLLbhTzvz27auuW0XmiIVlpgvqiWjDD?=
 =?Windows-1252?Q?HX5DdtY2pMToq/lHQzRoK4yKj2BLZ66tJuk8JMcvd1m3H4PFKbvO+HnV?=
 =?Windows-1252?Q?La6unJZvWbJ/OEv+QRiZ2Gf2O/92yo/j/UDQx8eVjru9HKB+Bc/7t6Yc?=
 =?Windows-1252?Q?DarxHHK62FiyD+6tU7/NWQt3VB0jvcTSxRi1W+KChnIAPRDkIN1LJzuX?=
 =?Windows-1252?Q?uDDJlPeryiTWeRW/x8DnwZ+yymWn0bNM2M3RBxg1eqnd9bFey1iG4u/w?=
 =?Windows-1252?Q?hL6j0vg/sWtWaWYaEm/Gr6JPtkR67CKf+x/H/BOpHdOSwfR6trXdNCQ+?=
 =?Windows-1252?Q?kE4c8c/v3PAAKtbjR3bPoV2TJUi7k31Tfk2MzuPHZNE6CpPMRz7v3cGa?=
 =?Windows-1252?Q?Wxp0IvAhZN71q4nVtTpsj5YmXMzVJ9OPtdyk7p4CEfDQnN4hAO0JjSyC?=
 =?Windows-1252?Q?nhWxzlI/9RUA1DPki59lu94s7rMk5ehGxXPZbKSQvFNWqJEjeJXgLmOr?=
 =?Windows-1252?Q?53Q7XdfBu4VPXx/WZyLvErPDeyAoH8L3U+5A7ekkJr2WjVhRmYvAkC5B?=
 =?Windows-1252?Q?ar0F/SNKLKO2cF0x/FsWb98nNUJUj+sT92lw1uxcHIIOB2hAXtGdbXWu?=
 =?Windows-1252?Q?In7LLgWIsKAr27TlxiGeHwypuphFDZx1hFtSDoT6+b3QcVkaAB2q47gF?=
 =?Windows-1252?Q?zaBtBcdvyXLavZ2J61qpZV6+LLZxF57iWonswxgm0c7yU+5bJ33DnrLP?=
 =?Windows-1252?Q?TdOtuN+i7I3iLe8TNEqpICAjnKkkxNIi8ln9H/5XIQaJN0O7lyQe0shq?=
 =?Windows-1252?Q?NlK+uLIlw9VcdXGD6rA0t1xiKAegEP+iW6W3vQ9tTgjyJc0z31af7wP4?=
 =?Windows-1252?Q?EP2UOyoukk5Mb5fBMTVRXUm1hqrRrGzQEpM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f72ac3a-f9d1-4bba-1af5-08d9250c0453
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 14:46:19.0227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFmw/9vqsWIsO5GZn92U9EMUudgSv3MEK/uQ6YS+OZQFZjTMKjSsJJGnmIzDAtDUfk6sreIMfMiPwbrrurbVrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR19MB1232
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-ID: <3CA459DEEC8B4C4895332285A02EB762@namprd19.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2021 7:41 pm, Wong Vee Khee wrote:
> This email was sent from outside of MaxLinear.
>
>
> On Tue, Jun 01, 2021 at 03:44:27PM +0800, Xu Liang wrote:
>> ---
>>   drivers/net/phy/Kconfig   |   5 +
>>   drivers/net/phy/Makefile  |   1 +
>>   drivers/net/phy/mxl-gpy.c | 537 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 543 insertions(+)
>>   create mode 100644 drivers/net/phy/mxl-gpy.c
>>
>> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
>> index 288bf405ebdb..7f1a0d62d83a 100644
>> --- a/drivers/net/phy/Kconfig
>> +++ b/drivers/net/phy/Kconfig
>> @@ -186,6 +186,11 @@ config INTEL_XWAY_PHY
>>          PEF 7061, PEF 7071 and PEF 7072 or integrated into the Intel
>>          SoCs xRX200, xRX300, xRX330, xRX350 and xRX550.
>>
>> +config MXL_GPHY
>> +     tristate "Maxlinear 2.5G PHYs"
>> +     help
>> +       Support for the Maxlinear 2.5G PHYs.
>> +
> I think its better to explicitly spell out the supported models.
> i.e. GPY115/21x/24x PHYs.
I will fix in v2 patch.
>>   config LSI_ET1011C_PHY
>>        tristate "LSI ET1011C PHY"
>>        help
>> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
>> index bcda7ed2455d..28aa2a198d00 100644
>> --- a/drivers/net/phy/Makefile
>> +++ b/drivers/net/phy/Makefile
>> @@ -59,6 +59,7 @@ obj-$(CONFIG_DP83TC811_PHY) +=3D dp83tc811.o
>>   obj-$(CONFIG_FIXED_PHY)              +=3D fixed_phy.o
>>   obj-$(CONFIG_ICPLUS_PHY)     +=3D icplus.o
>>   obj-$(CONFIG_INTEL_XWAY_PHY) +=3D intel-xway.o
>> +obj-$(CONFIG_MXL_GPHY)          +=3D mxl-gpy.o
>>   obj-$(CONFIG_LSI_ET1011C_PHY)        +=3D et1011c.o
>>   obj-$(CONFIG_LXT_PHY)                +=3D lxt.o
>>   obj-$(CONFIG_MARVELL_10G_PHY)        +=3D marvell10g.o
>> diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
>> new file mode 100644
>> index 000000000000..757e65e48567
>> --- /dev/null
>> +++ b/drivers/net/phy/mxl-gpy.c
>> @@ -0,0 +1,537 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/* Copyright (C) 2021 Maxlinear Corporation
>> + * Copyright (C) 2020 Intel Corporation
>> + *
>> + * Maxlinear Ethernet GPY
> Drivers for Maxlinear Ethernet GPY
I will fix in v2 patch.
>> + *
>> + */
>> +
>> +#include <linux/version.h>
>> +#include <linux/module.h>
>> +#include <linux/bitfield.h>
>> +#include <linux/phy.h>
>> +#include <linux/netdevice.h>
>> +
>> +/* PHY ID */
>> +#define PHY_ID_GPY           0x67C9DC00
>> +#define PHY_ID_MASK          GENMASK(31, 10)
>> +
>> +#define PHY_MIISTAT          0x18    /* MII state */
>> +#define PHY_IMASK            0x19    /* interrupt mask */
>> +#define PHY_ISTAT            0x1A    /* interrupt status */
>> +#define PHY_FWV                      0x1E    /* firmware version */
>> +
>> +#define PHY_MIISTAT_SPD_MASK GENMASK(2, 0)
>> +#define PHY_MIISTAT_DPX              BIT(3)
>> +#define PHY_MIISTAT_LS               BIT(10)
>> +
>> +#define PHY_MIISTAT_SPD_10   0
>> +#define PHY_MIISTAT_SPD_100  1
>> +#define PHY_MIISTAT_SPD_1000 2
>> +#define PHY_MIISTAT_SPD_2500 4
>> +
>> +#define PHY_IMASK_WOL                BIT(15) /* Wake-on-LAN */
>> +#define PHY_IMASK_ANC                BIT(10) /* Auto-Neg complete */
>> +#define PHY_IMASK_ADSC               BIT(5)  /* Link auto-downspeed det=
ect */
>> +#define PHY_IMASK_DXMC               BIT(2)  /* Duplex mode change */
>> +#define PHY_IMASK_LSPC               BIT(1)  /* Link speed change */
>> +#define PHY_IMASK_LSTC               BIT(0)  /* Link state change */
>> +#define PHY_IMASK_MASK               (PHY_IMASK_LSTC | \
>> +                              PHY_IMASK_LSPC | \
>> +                              PHY_IMASK_DXMC | \
>> +                              PHY_IMASK_ADSC | \
>> +                              PHY_IMASK_ANC)
>> +
>> +#define PHY_FWV_TYPE_MASK    GENMASK(11, 8)
>> +#define PHY_FWV_MINOR_MASK   GENMASK(7, 0)
>> +
>> +/* ANEG dev */
>> +#define ANEG_MGBT_AN_CTRL    0x20
>> +#define ANEG_MGBT_AN_STAT    0x21
>> +#define CTRL_AB_2G5BT_BIT    BIT(7)
>> +#define CTRL_AB_FR_2G5BT     BIT(5)
>> +#define STAT_AB_2G5BT_BIT    BIT(5)
>> +#define STAT_AB_FR_2G5BT     BIT(3)
>> +
>> +/* SGMII */
>> +#define VSPEC1_SGMII_CTRL    0x08
>> +#define VSPEC1_SGMII_CTRL_ANEN       BIT(12)         /* Aneg enable */
>> +#define VSPEC1_SGMII_CTRL_ANRS       BIT(9)          /* Restart Aneg */
>> +#define VSPEC1_SGMII_ANEN_ANRS       (VSPEC1_SGMII_CTRL_ANEN | \
>> +                              VSPEC1_SGMII_CTRL_ANRS)
>> +
>> +/* WoL */
>> +#define VPSPEC2_WOL_CTL              0x0E06
>> +#define VPSPEC2_WOL_AD01     0x0E08
>> +#define VPSPEC2_WOL_AD23     0x0E09
>> +#define VPSPEC2_WOL_AD45     0x0E0A
>> +#define WOL_EN                       BIT(0)
>> +
>> +static int gpy_read_abilities(struct phy_device *phydev)
>> +{
>> +     int ret;
>> +
>> +     ret =3D genphy_read_abilities(phydev);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     /* Detect 2.5G/5G support. */
>> +     ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT2);
>> +     if (ret < 0)
>> +             return ret;
>> +     if (!(ret & MDIO_PMA_STAT2_EXTABLE))
>> +             return 0;
>> +
>> +     ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
>> +     if (ret < 0)
>> +             return ret;
>> +     if (!(ret & MDIO_PMA_EXTABLE_NBT))
>> +             return 0;
>> +
>> +     ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE)=
;
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
>> +                      phydev->supported,
>> +                      ret & MDIO_PMA_NG_EXTABLE_2_5GBT);
>> +
>> +     linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
>> +                      phydev->supported,
>> +                      ret & MDIO_PMA_NG_EXTABLE_5GBT);
>> +
>> +     return 0;
>> +}
>> +
>> +static int gpy_config_init(struct phy_device *phydev)
>> +{
>> +     int ret, fw_ver;
>> +
>> +     /* Show GPY PHY FW version in dmesg */
>> +     fw_ver =3D phy_read(phydev, PHY_FWV);
>> +     if (fw_ver < 0)
>> +             return fw_ver;
>> +
>> +     phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_ver,
>> +                 (fw_ver & BIT(15)) ? "release" : "test");
>> +
>> +     /* Mask all interrupts */
>> +     ret =3D phy_write(phydev, PHY_IMASK, 0);
>> +     if (ret)
>> +             return ret;
>> +
>> +     /* Clear all pending interrupts */
>> +     return phy_read(phydev, PHY_ISTAT);
>> +}
>> +
>> +static bool gpy_sgmii_need_reaneg(struct phy_device *phydev)
>> +{
>> +     struct {
>> +             int type;
>> +             int minor;
>> +     } table[] =3D {
>> +             {7, 0x6D},
>> +             {8, 0x6D},
>> +             {9, 0x73},
>> +     };
>> +
>> +     int fw_ver, fw_type, fw_minor;
>> +     size_t i;
>> +
>> +     fw_ver =3D phy_read(phydev, PHY_FWV);
>> +     if (fw_ver < 0)
>> +             return true;
>> +
>> +     fw_type =3D FIELD_GET(PHY_FWV_TYPE_MASK, fw_ver);
>> +     fw_minor =3D FIELD_GET(PHY_FWV_MINOR_MASK, fw_ver);
>> +
>> +     for (i =3D 0; i < ARRAY_SIZE(table); i++) {
>> +             if (fw_type !=3D table[i].type)
>> +                     continue;
>> +             if (fw_minor < table[i].minor)
>> +                     return true;
>> +             break;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>> +static bool gpy_sgmii_2p5g_chk(struct phy_device *phydev)
>> +{
>> +     int ret;
>> +
>> +     ret =3D phy_read(phydev, PHY_MIISTAT);
>> +     if (ret < 0) {
>> +             phydev_err(phydev, "Error: MDIO register access failed: %d=
\n",
>> +                        ret);
>> +             return false;
>> +     }
>> +
>> +     if (!(ret & PHY_MIISTAT_LS)
>> +         || FIELD_GET(PHY_MIISTAT_SPD_MASK, ret) !=3D PHY_MIISTAT_SPD_2=
500)
>> +             return false;
>> +
>> +     phydev->speed =3D SPEED_2500;
>> +     phydev->interface =3D PHY_INTERFACE_MODE_2500BASEX;
>> +     phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
>> +                            VSPEC1_SGMII_CTRL,
>> +                            VSPEC1_SGMII_CTRL_ANEN, 0);
>> +     return true;
>> +}
>> +
>> +static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
>> +{
>> +     int ret;
>> +
>> +     ret =3D phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL);
>> +     if (ret < 0) {
>> +             phydev_err(phydev, "Error: MMD register access failed: %d\=
n",
>> +                        ret);
>> +             return true;
> Don't we need some error handling here, instead of return true?

By right, MDIO access failure should not happen.

Even it happens, it does not break function here.

With return value "true", gpy_config_aneg will continue on next step.

>> +     }
>> +
>> +     return (ret & VSPEC1_SGMII_CTRL_ANEN) ? true : false;
>> +}
>> +
>> +static int gpy_config_aneg(struct phy_device *phydev)
>> +{
>> +     bool changed =3D false;
>> +     u32 adv;
>> +     int ret;
>> +
>> +     if (phydev->autoneg =3D=3D AUTONEG_DISABLE) {
>> +             return phydev->duplex !=3D DUPLEX_FULL
>> +                     ? genphy_setup_forced(phydev)
>> +                     : genphy_c45_pma_setup_forced(phydev);
>> +     }
>> +
>> +     ret =3D genphy_c45_an_config_aneg(phydev);
>> +     if (ret < 0)
>> +             return ret;
>> +     if (ret)
>> +             changed =3D true;
>> +
>> +     adv =3D linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
>> +     ret =3D phy_modify_changed(phydev, MII_CTRL1000,
>> +                              ADVERTISE_1000FULL | ADVERTISE_1000HALF,
>> +                              adv);
>> +     if (ret < 0)
>> +             return ret;
>> +     if (ret > 0)
>> +             changed =3D true;
>> +
>> +     ret =3D genphy_c45_check_and_restart_aneg(phydev, changed);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     if (phydev->interface =3D=3D PHY_INTERFACE_MODE_USXGMII
>> +         || phydev->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL)
>> +             return 0;
>> +
>> +     /* No need to trigger re-ANEG if SGMII link speed is 2.5G
>> +      * or SGMII ANEG is disabled.
>> +      */
>> +     if (!gpy_sgmii_need_reaneg(phydev) || gpy_sgmii_2p5g_chk(phydev)
>> +         || !gpy_sgmii_aneg_en(phydev))
>> +             return 0;
>> +
>> +     /* There is a design constraint in GPY2xx device where SGMII AN is
>> +      * only triggered when there is change of speed. If, PHY link
>> +      * partner`s speed is still same even after PHY TPI is down and up
>> +      * again, SGMII AN is not triggered and hence no new in-band messa=
ge
>> +      * from GPY to MAC side SGMII.
>> +      * This could cause an issue during power up, when PHY is up prior=
 to
>> +      * MAC. At this condition, once MAC side SGMII is up, MAC side SGM=
II
>> +      * wouldn`t receive new in-band message from GPY with correct link
>> +      * status, speed and duplex info.
>> +      *
>> +      * 1) If PHY is already up and TPI link status is still down (such=
 as
>> +      *    hard reboot), TPI link status is polled for 4 seconds before
>> +      *    retriggerring SGMII AN.
>> +      * 2) If PHY is already up and TPI link status is also up (such as=
 soft
>> +      *    reboot), polling of TPI link status is not needed and SGMII =
AN is
>> +      *    immediately retriggered.
>> +      * 3) Other conditions such as PHY is down, speed change etc, skip
>> +      *    retriggering SGMII AN. Note: in case of speed change, GPY FW=
 will
>> +      *    initiate SGMII AN.
>> +      */
>> +
>> +     if (phydev->state !=3D PHY_UP)
>> +             return 0;
>> +
>> +     ret =3D phy_read_poll_timeout(phydev, MII_BMSR, ret, ret & BMSR_LS=
TATUS,
>> +                                 20000, 4000000, false);
>> +     if (ret =3D=3D -ETIMEDOUT)
>> +             return 0;
>> +     else if (ret < 0)
>> +             return ret;
>> +
>> +     /* Trigger SGMII AN. */
>> +     return phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII=
_CTRL,
>> +                                   VSPEC1_SGMII_CTRL_ANRS,
>> +                                   VSPEC1_SGMII_CTRL_ANRS);
>> +}
>> +
>> +static void gpy_update_interface(struct phy_device *phydev)
>> +{
>> +     int ret;
>> +
>> +     /* Interface mode is fixed for USXGMII and integrated PHY */
>> +     if (phydev->interface =3D=3D PHY_INTERFACE_MODE_USXGMII
>> +         || phydev->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL)
>> +             return;
>> +
>> +     /* Automatically switch SERDES interface between SGMII and 2500-Ba=
seX
>> +      * according to speed. Disable ANEG in 2500-BaseX mode.
>> +      */
>> +     switch (phydev->speed) {
>> +     case SPEED_2500:
>> +             phydev->interface =3D PHY_INTERFACE_MODE_2500BASEX;
>> +             ret =3D phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
>> +                                          VSPEC1_SGMII_CTRL,
>> +                                          VSPEC1_SGMII_CTRL_ANEN, 0);
>> +             if (ret < 0)
>> +                     phydev_err(phydev,
>> +                                "Error: Disable of SGMII ANEG failed: %=
d\n",
>> +                                ret);
>> +             break;
>> +     case SPEED_1000:
>> +     case SPEED_100:
>> +     case SPEED_10:
>> +             phydev->interface =3D PHY_INTERFACE_MODE_SGMII;
>> +             if (gpy_sgmii_aneg_en(phydev))
>> +                     break;
>> +             /* Enable and restart SGMII ANEG for 10/100/1000Mbps link =
speed
>> +              * if ANEG is disabled (in 2500-BaseX mode).
>> +              */
>> +             ret =3D phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
>> +                                          VSPEC1_SGMII_CTRL,
>> +                                          VSPEC1_SGMII_ANEN_ANRS,
>> +                                          VSPEC1_SGMII_ANEN_ANRS);
>> +             if (ret < 0)
>> +                     phydev_err(phydev,
>> +                                "Error: Enable of SGMII ANEG failed: %d=
\n",
>> +                                ret);
>> +             break;
>> +     }
>> +}
>> +
>> +static int gpy_read_status(struct phy_device *phydev)
>> +{
>> +     int ret;
>> +
>> +     ret =3D genphy_update_link(phydev);
>> +     if (ret)
>> +             return ret;
>> +
>> +     phydev->speed =3D SPEED_UNKNOWN;
>> +     phydev->duplex =3D DUPLEX_UNKNOWN;
>> +     phydev->pause =3D 0;
>> +     phydev->asym_pause =3D 0;
>> +
>> +     if (phydev->autoneg =3D=3D AUTONEG_ENABLE && phydev->autoneg_compl=
ete) {
>> +             ret =3D genphy_c45_read_lpa(phydev);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             /* Read the link partner's 1G advertisement */
>> +             ret =3D phy_read(phydev, MII_STAT1000);
>> +             if (ret < 0)
>> +                     return ret;
>> +             mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, re=
t);
>> +     } else if (phydev->autoneg =3D=3D AUTONEG_DISABLE) {
>> +             linkmode_zero(phydev->lp_advertising);
>> +     }
>> +
>> +     ret =3D phy_read(phydev, PHY_MIISTAT);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     phydev->link =3D (ret & PHY_MIISTAT_LS) ? 1 : 0;
>> +     phydev->duplex =3D (ret & PHY_MIISTAT_DPX) ? DUPLEX_FULL : DUPLEX_=
HALF;
>> +     switch (FIELD_GET(PHY_MIISTAT_SPD_MASK, ret)) {
>> +     case PHY_MIISTAT_SPD_10:
>> +             phydev->speed =3D SPEED_10;
>> +             break;
>> +     case PHY_MIISTAT_SPD_100:
>> +             phydev->speed =3D SPEED_100;
>> +             break;
>> +     case PHY_MIISTAT_SPD_1000:
>> +             phydev->speed =3D SPEED_1000;
>> +             break;
>> +     case PHY_MIISTAT_SPD_2500:
>> +             phydev->speed =3D SPEED_2500;
>> +             break;
>> +     }
>> +
>> +     if (phydev->link)
>> +             gpy_update_interface(phydev);
>> +
>> +     return 0;
>> +}
>> +
>> +static int gpy_config_intr(struct phy_device *phydev)
>> +{
>> +     u16 mask =3D 0;
>> +
>> +     if (phydev->interrupts =3D=3D PHY_INTERRUPT_ENABLED)
>> +             mask =3D PHY_IMASK_MASK;
>> +
>> +     return phy_write(phydev, PHY_IMASK, mask);
>> +}
>> +
>> +static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
>> +{
>> +     int reg;
>> +
>> +     reg =3D phy_read(phydev, PHY_ISTAT);
>> +     if (reg < 0) {
>> +             phy_error(phydev);
>> +             return IRQ_NONE;
>> +     }
>> +
>> +     if (!(reg & PHY_IMASK_MASK))
>> +             return IRQ_NONE;
>> +
>> +     phy_trigger_machine(phydev);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int gpy_set_wol(struct phy_device *phydev,
>> +                    struct ethtool_wolinfo *wol)
>> +{
>> +     struct net_device *attach_dev =3D phydev->attached_dev;
>> +     int ret;
>> +
>> +     if (wol->wolopts & WAKE_MAGIC) {
>> +             /* MAC address - Byte0:Byte1:Byte2:Byte3:Byte4:Byte5
>> +              * VPSPEC2_WOL_AD45 =3D Byte0:Byte1
>> +              * VPSPEC2_WOL_AD23 =3D Byte2:Byte3
>> +              * VPSPEC2_WOL_AD01 =3D Byte4:Byte5
>> +              */
>> +             ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
>> +                                    VPSPEC2_WOL_AD45,
>> +                                    ((attach_dev->dev_addr[0] << 8) |
>> +                                    attach_dev->dev_addr[1]));
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
>> +                                    VPSPEC2_WOL_AD23,
>> +                                    ((attach_dev->dev_addr[2] << 8) |
>> +                                    attach_dev->dev_addr[3]));
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
>> +                                    VPSPEC2_WOL_AD01,
>> +                                    ((attach_dev->dev_addr[4] << 8) |
>> +                                    attach_dev->dev_addr[5]));
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             /* Enable the WOL interrupt */
>> +             ret =3D phy_write(phydev, PHY_IMASK, PHY_IMASK_WOL);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             /* Enable magic packet matching */
>> +             ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
>> +                                    VPSPEC2_WOL_CTL,
>> +                                    WOL_EN);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             /* Clear the interrupt status register */
>> +             ret =3D phy_read(phydev, PHY_ISTAT);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +     } else {
>> +             /* Disable magic packet matching */
>> +             ret =3D phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
>> +                                      VPSPEC2_WOL_CTL,
>> +                                      WOL_EN);
>> +             if (ret < 0)
>> +                     return ret;
>> +     }
>> +
>> +     if (wol->wolopts & WAKE_PHY) {
>> +             /* Enable the link state change interrupt */
>> +             ret =3D phy_set_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             /* Clear the interrupt status register */
>> +             ret =3D phy_read(phydev, PHY_ISTAT);
>> +     } else {
>> +             /* Disable the link state change interrupt */
>> +             ret =3D phy_clear_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static void gpy_get_wol(struct phy_device *phydev,
>> +                     struct ethtool_wolinfo *wol)
>> +{
>> +     int ret;
>> +
>> +     wol->supported =3D WAKE_MAGIC | WAKE_PHY;
>> +     wol->wolopts =3D 0;
>> +
>> +     ret =3D phy_read_mmd(phydev, MDIO_MMD_VEND2, VPSPEC2_WOL_CTL);
>> +     if (ret & WOL_EN)
>> +             wol->wolopts |=3D WAKE_MAGIC;
>> +
>> +     ret =3D phy_read(phydev, PHY_IMASK);
>> +     if (ret & PHY_IMASK_LSTC)
>> +             wol->wolopts |=3D WAKE_PHY;
>> +}
>> +
>> +static int gpy_loopback(struct phy_device *phydev, bool enable)
>> +{
>> +     int ret;
>> +
>> +     ret =3D genphy_loopback(phydev, enable);
> genphy_c45_loopback()

The verification is based on genphy_loopback.

I think this should be OK as CL22 is used in the actual system.

>
>> +     if (!ret) {
>> +             /* It takes some time for PHY deviceto switch
> device to
Will fix in v2 patch.
>> +              * into/out-of loopback mode.
>> +              */
>> +             usleep_range(100, 200);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static struct phy_driver gpy_drivers[] =3D {
>> +     {
>> +             .phy_id         =3D PHY_ID_GPY,
>> +             .phy_id_mask    =3D PHY_ID_MASK,
>> +             .name           =3D "Maxlinear Ethernet GPY",
>> +             .get_features   =3D gpy_read_abilities,
>> +             .config_init    =3D gpy_config_init,
>> +             .suspend        =3D genphy_suspend,
>> +             .resume         =3D genphy_resume,
> There is the new genphy_c45_pma_{suspend|resume} that you can use here.
I think this should be OK as CL22 is used in the actual system.
>> +             .config_aneg    =3D gpy_config_aneg,
>> +             .aneg_done      =3D genphy_c45_aneg_done,
>> +             .read_status    =3D gpy_read_status,
>> +             .config_intr    =3D gpy_config_intr,
>> +             .handle_interrupt =3D gpy_handle_interrupt,
>> +             .set_wol        =3D gpy_set_wol,
>> +             .get_wol        =3D gpy_get_wol,
>> +             .set_loopback   =3D gpy_loopback,
>> +     },
>> +};
>> +module_phy_driver(gpy_drivers);
>> +
>> +static struct mdio_device_id __maybe_unused gpy_tbl[] =3D {
>> +     {PHY_ID_GPY, PHY_ID_MASK},
>> +     { }
>> +};
>> +MODULE_DEVICE_TABLE(mdio, gpy_tbl);
>> +
>> +MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
>> +MODULE_AUTHOR("Maxlinear Corporation");
>> +MODULE_LICENSE("GPL");


