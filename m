Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33F91D3F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 08:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfHSGk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 02:40:57 -0400
Received: from mail-eopbgr40075.outbound.protection.outlook.com ([40.107.4.75]:20868
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfHSGk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 02:40:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDfduFZ6tq3+EWixRFph4OU/532pq2x60r9UrbOiJdlwO6JwlJo1KsgFzc1t0ymN0wSvEPIuVOVWXjPx1FBezHf0KwDdQkj1jDlymziYiysrMYaHTerFBP2AehMN8wR7jRY6PXOQ2o+AjBKlHAi7YZTvW8aCa4PT+j6e1d9Kx3bLBx2pcbMNlc66ZBk22J0u4iaG8aUMlV0lD+pjcuLxTENRVAvbu5JlLVy++LO0PBXOoqsjzWixhfC5br59sL78DfcslsePfMJ63FvtWmvwhfLlBDbA39UxoBJjlqVyJzN4yiO/Jmi+9+ClAL/y6V2DZTopD6jJdkDuaz5Nfte8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx36FLu6s0xboBWyYJhxYG/2HMMBnRqy2h2wC3RSXFI=;
 b=QlWXcw7vnqcm5gnfyPsvNJVhDvNyjA/tzVV5bPTQTroPjNBUB4NUEtrIn4rGNCVlTvloQUWySDo0Il/E/QilQTHptG8oeuRWz4mxIdz7m7ndoLxcagPlDyItsP6iHCBcFyPSL3cqeZ1p35r7wr3yGmkryQbi+czLOuqGyz0bxV3mcIKqIMq/ZYn+Fwn+miiZzAHWaaI/2VFpiJsChxop7kElBfvoQgaaSI/QKFPNgDhzNmzU0wo15slzLAygVVMaKaVXNGQu8kevs/OqcQFFlYd9IRLs0r6bRJcruhDqPt2x39N7vQ9VaDTIYZmCPg+ef482O4XcXvGIdvqOMlIKmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx36FLu6s0xboBWyYJhxYG/2HMMBnRqy2h2wC3RSXFI=;
 b=EgMccm2+Etn2kZ0Y2utxkFUUfL+jHOjkrwpfnjFMrZL7v1AgQQBBvpTHNhPgkNI9vvR55/ZU7wYVENFF/juGHA1sHwvuWNSsm1E7segiluejYZ9lsjM59Ni05FwluE/sUh2a5eq0+FdeqcXEVltK7EG7j02ogoA0xmmq3aN9OXA=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3717.eurprd04.prod.outlook.com (52.133.28.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 06:40:45 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 06:40:45 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re:  Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Topic: Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Index: AQHVVlkHNDA432cTUUiHtzX0ZOZySg==
Date:   Mon, 19 Aug 2019 06:40:45 +0000
Message-ID: <AM6PR0402MB3798B7FC9B1800C0E28211FB86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <20190815153209.21529-2-christian.herber@nxp.com>
 <95eda63a-8202-3f49-c86a-e418162b2811@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d37d2fc-dfb3-4bd0-9077-08d724702a2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3717;
x-ms-traffictypediagnostic: AM6PR0402MB3717:
x-microsoft-antispam-prvs: <AM6PR0402MB37173A14E20CAAB1C9D5E27886A80@AM6PR0402MB3717.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(199004)(189003)(7736002)(54906003)(186003)(33656002)(76116006)(91956017)(110136005)(71190400001)(81166006)(5660300002)(74316002)(8676002)(66946007)(53946003)(6116002)(66446008)(256004)(25786009)(53546011)(6506007)(476003)(81156014)(305945005)(52536014)(64756008)(66476007)(66556008)(19627235002)(6246003)(55016002)(446003)(44832011)(102836004)(9686003)(26005)(486006)(53936002)(66066001)(2906002)(4326008)(478600001)(86362001)(55236004)(14444005)(71200400001)(7696005)(316002)(99286004)(2501003)(229853002)(6436002)(30864003)(8936002)(14454004)(3846002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3717;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m8Dm/cePzn9Ofq34EW6qvJ4jyUd5HStLussZu/x7VduxsC4kcxx00+hzj4fD3gsyKJx5WEr2Tm6mkiSXib0vDW0qwbmeKVfmF3q5vp/5PhDZx2Tdo8VDhDaZqznWpp/0Leb3DFpqzeB6dPuigGSUK6vfOT2ZFTs/vmHRh+qo8ShVh4iINlbdAmZ+nsphdZ2IkC7dNnIs90g000Wdd6l0zJxF8AH6DnTxwp0AKx685FxI3w3BEPd1a5DIS3Smn9BcgMF0sj19ZIzl2E3lnq1M3WFjVwsbzOhboaFAwFcIzirMM7BGeaVPzEuQvwQReX+nzzYYSve9VU97DgR12g1fxOMbAu2TsGHZiuIMt3glwGXslxyum49xCMCeQ+TXCYxSFL2yFZhLbd6uzULPWCbNWPzDMJSdB2gaN4am1vS008s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d37d2fc-dfb3-4bd0-9077-08d724702a2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 06:40:45.8014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWrAwmWqj7RCdliAD+MfOH1KfpkUNu/2UbqDr4v3/h5qIxD+CzXwpNby2SZYP4s3kdS24ZY9KebfmkBBorg4WkUv93SfnP3IDA4JZIgS4WM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3717
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2019 23:13, Heiner Kallweit wrote:=0A=
> =0A=
> On 15.08.2019 17:32, Christian Herber wrote:=0A=
>> BASE-T1 is a category of Ethernet PHYs.=0A=
>> They use a single copper pair for transmission.=0A=
>> This patch add basic support for this category of PHYs.=0A=
>> It coveres the discovery of abilities and basic configuration.=0A=
>> It includes setting fixed speed and enabling auto-negotiation.=0A=
>> BASE-T1 devices should always Clause-45 managed.=0A=
>> Therefore, this patch extends phy-c45.c.=0A=
>> While for some functions like auto-neogtiation different registers are=
=0A=
>> used, the layout of these registers is the same for the used fields.=0A=
>> Thus, much of the logic of basic Clause-45 devices can be reused.=0A=
>>=0A=
>> Signed-off-by: Christian Herber <christian.herber@nxp.com>=0A=
>> ---=0A=
>>   drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----=
=0A=
>>   drivers/net/phy/phy-core.c   |   4 +-=0A=
>>   include/uapi/linux/ethtool.h |   2 +=0A=
>>   include/uapi/linux/mdio.h    |  21 +++++++=0A=
>>   4 files changed, 129 insertions(+), 11 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c=0A=
>> index b9d4145781ca..9ff0b8c785de 100644=0A=
>> --- a/drivers/net/phy/phy-c45.c=0A=
>> +++ b/drivers/net/phy/phy-c45.c=0A=
>> @@ -8,13 +8,23 @@=0A=
>>   #include <linux/mii.h>=0A=
>>   #include <linux/phy.h>=0A=
>>=0A=
>> +#define IS_100BASET1(phy) (linkmode_test_bit( \=0A=
>> +                        ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \=0A=
>> +                        (phy)->supported))=0A=
>> +#define IS_1000BASET1(phy) (linkmode_test_bit( \=0A=
>> +                         ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \=0A=
>> +                         (phy)->supported))=0A=
>> +=0A=
> Why is there no such macro for 10BaseT1?=0A=
> =0A=
>> +static u32 get_aneg_ctrl(struct phy_device *phydev);=0A=
>> +static u32 get_aneg_stat(struct phy_device *phydev);=0A=
>> +=0A=
>>   /**=0A=
>>    * genphy_c45_setup_forced - configures a forced speed=0A=
>>    * @phydev: target phy_device struct=0A=
>>    */=0A=
>>   int genphy_c45_pma_setup_forced(struct phy_device *phydev)=0A=
>>   {=0A=
>> -     int ctrl1, ctrl2, ret;=0A=
>> +     int ctrl1, ctrl2, base_t1_ctrl =3D 0, ret;=0A=
>>=0A=
>>        /* Half duplex is not supported */=0A=
>>        if (phydev->duplex !=3D DUPLEX_FULL)=0A=
>> @@ -28,6 +38,16 @@ int genphy_c45_pma_setup_forced(struct phy_device *ph=
ydev)=0A=
>>        if (ctrl2 < 0)=0A=
>>                return ctrl2;=0A=
>>=0A=
>> +     if (IS_100BASET1(phydev) || IS_1000BASET1(phydev)) {=0A=
> =0A=
> 10BaseT1 doesn't need to be considered here?=0A=
> And maybe it would be better to have a flag for BaseT1 at phy_device leve=
l=0A=
> (based on bit MDIO_PMA_EXTABLE_BASET1?) instead of checking whether certa=
in=0A=
> T1 modes are supported. Then we would be more future-proof in case of new=
=0A=
> T1 modes.=0A=
> =0A=
>> +             base_t1_ctrl =3D phy_read_mmd(phydev,=0A=
>> +                                         MDIO_MMD_PMAPMD,=0A=
>> +                                         MDIO_PMA_BASET1CTRL);=0A=
>> +             if (base_t1_ctrl < 0)=0A=
>> +                     return base_t1_ctrl;=0A=
>> +=0A=
>> +             base_t1_ctrl &=3D ~(MDIO_PMA_BASET1CTRL_TYPE);=0A=
>> +     }=0A=
>> +=0A=
>>        ctrl1 &=3D ~MDIO_CTRL1_SPEEDSEL;=0A=
>>        /*=0A=
>>         * PMA/PMD type selection is 1.7.5:0 not 1.7.3:0.  See 45.2.1.6.1=
=0A=
>> @@ -41,12 +61,21 @@ int genphy_c45_pma_setup_forced(struct phy_device *p=
hydev)=0A=
>>                break;=0A=
>>        case SPEED_100:=0A=
>>                ctrl1 |=3D MDIO_PMA_CTRL1_SPEED100;=0A=
>> -             ctrl2 |=3D MDIO_PMA_CTRL2_100BTX;=0A=
>> +             if (IS_100BASET1(phydev)) {=0A=
>> +                     ctrl2 |=3D MDIO_PMA_CTRL2_BT1;=0A=
>> +                     base_t1_ctrl |=3D MDIO_PMA_BASET1CTRL_TYPE_100BT1;=
=0A=
>> +             } else {=0A=
>> +                     ctrl2 |=3D MDIO_PMA_CTRL2_100BTX;=0A=
>> +             }=0A=
>>                break;=0A=
>>        case SPEED_1000:=0A=
>>                ctrl1 |=3D MDIO_PMA_CTRL1_SPEED1000;=0A=
>> -             /* Assume 1000base-T */=0A=
>> -             ctrl2 |=3D MDIO_PMA_CTRL2_1000BT;=0A=
>> +             if (IS_1000BASET1(phydev)) {=0A=
>> +                     ctrl2 |=3D MDIO_PMA_CTRL2_BT1;=0A=
>> +                     base_t1_ctrl |=3D MDIO_PMA_BASET1CTRL_TYPE_1000BT1=
;=0A=
>> +             } else {=0A=
>> +                     ctrl2 |=3D MDIO_PMA_CTRL2_1000BT;=0A=
>> +             }=0A=
>>                break;=0A=
>>        case SPEED_2500:=0A=
>>                ctrl1 |=3D MDIO_CTRL1_SPEED2_5G;=0A=
>> @@ -75,6 +104,14 @@ int genphy_c45_pma_setup_forced(struct phy_device *p=
hydev)=0A=
>>        if (ret < 0)=0A=
>>                return ret;=0A=
>>=0A=
>> +     if (IS_100BASET1(phydev) || IS_1000BASET1(phydev)) {=0A=
>> +             ret =3D phy_write_mmd(phydev,=0A=
>> +                                 MDIO_MMD_PMAPMD,=0A=
>> +                                 MDIO_PMA_BASET1CTRL,=0A=
>> +                                 base_t1_ctrl);=0A=
>> +             if (ret < 0)=0A=
>> +                     return ret;=0A=
>> +     }=0A=
>>        return genphy_c45_an_disable_aneg(phydev);=0A=
>>   }=0A=
>>   EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_forced);=0A=
>> @@ -135,8 +172,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);=0A=
>>    */=0A=
>>   int genphy_c45_an_disable_aneg(struct phy_device *phydev)=0A=
>>   {=0A=
>> -=0A=
>> -     return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,=0A=
>> +     return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phyde=
v),=0A=
>>                                  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RE=
START);=0A=
>>   }=0A=
>>   EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);=0A=
>> @@ -151,7 +187,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);=0A=
>>    */=0A=
>>   int genphy_c45_restart_aneg(struct phy_device *phydev)=0A=
>>   {=0A=
>> -     return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,=0A=
>> +     return phy_set_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev)=
,=0A=
>>                                MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_REST=
ART);=0A=
>>   }=0A=
>>   EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);=0A=
>> @@ -171,7 +207,7 @@ int genphy_c45_check_and_restart_aneg(struct phy_dev=
ice *phydev, bool restart)=0A=
>>=0A=
>>        if (!restart) {=0A=
>>                /* Configure and restart aneg if it wasn't set before */=
=0A=
>> -             ret =3D phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);=0A=
>> +             ret =3D phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(ph=
ydev));=0A=
>>                if (ret < 0)=0A=
>>                        return ret;=0A=
>>=0A=
>> @@ -199,7 +235,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg)=
;=0A=
>>    */=0A=
>>   int genphy_c45_aneg_done(struct phy_device *phydev)=0A=
>>   {=0A=
>> -     int val =3D phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);=0A=
>> +     int val =3D phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_stat(phydev=
));=0A=
>>=0A=
>>        return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;=0A=
>>   }=0A=
>> @@ -385,7 +421,9 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);=0A=
>>    * PMA Extended Abilities (1.11) register, indicating 1000BASET an 10G=
 related=0A=
>>    * modes. If bit 1.11.14 is set, then the list is also extended with t=
he modes=0A=
>>    * in the 2.5G/5G PMA Extended register (1.21), indicating if 2.5GBASE=
T and=0A=
>> - * 5GBASET are supported.=0A=
>> + * 5GBASET are supported. If bit 1.11.11 is set, then the list is also =
extended=0A=
>> + * with the modes in the BASE-T1 PMA Extended register (1.18), indicati=
ng if=0A=
>> + * 10/100/1000BASET-1 are supported.=0A=
>>    */=0A=
>>   int genphy_c45_pma_read_abilities(struct phy_device *phydev)=0A=
>>   {=0A=
>> @@ -470,6 +508,29 @@ int genphy_c45_pma_read_abilities(struct phy_device=
 *phydev)=0A=
>>                                         phydev->supported,=0A=
>>                                         val & MDIO_PMA_NG_EXTABLE_5GBT);=
=0A=
>>                }=0A=
>> +=0A=
>> +             if (val & MDIO_PMA_EXTABLE_BASET1) {=0A=
>> +                     val =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD,=0A=
>> +                                        MDIO_PMA_BASET1_EXTABLE);=0A=
>> +                     if (val < 0)=0A=
>> +                             return val;=0A=
>> +=0A=
>> +                     linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT1_Full_=
BIT,=0A=
>> +                                      phydev->supported,=0A=
>> +                                      val & MDIO_PMA_BASET1_EXTABLE_100=
BT1);=0A=
>> +=0A=
>> +                     linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT1_Full=
_BIT,=0A=
>> +                                      phydev->supported,=0A=
>> +                                      val & MDIO_PMA_BASET1_EXTABLE_100=
0BT1);=0A=
>> +=0A=
>> +                     linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_=
BIT,=0A=
>> +                                      phydev->supported,=0A=
>> +                                      val & MDIO_PMA_BASET1_EXTABLE_10B=
T1L);=0A=
>> +=0A=
>> +                     linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1S_Full_=
BIT,=0A=
>> +                                      phydev->supported,=0A=
>> +                                      val & MDIO_PMA_BASET1_EXTABLE_10B=
T1S);=0A=
>> +             }=0A=
>>        }=0A=
>>=0A=
>>        return 0;=0A=
>> @@ -509,6 +570,38 @@ int genphy_c45_read_status(struct phy_device *phyde=
v)=0A=
>>   }=0A=
>>   EXPORT_SYMBOL_GPL(genphy_c45_read_status);=0A=
>>=0A=
>> +/**=0A=
>> + * get_aneg_ctrl - Get the register address for auto-=0A=
>> + * negotiation control register=0A=
>> + * @phydev: target phy_device struct=0A=
>> + *=0A=
>> + */=0A=
>> +static u32 get_aneg_ctrl(struct phy_device *phydev)=0A=
>> +{=0A=
>> +     u32 ctrl =3D MDIO_CTRL1;=0A=
>> +=0A=
>> +     if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))=0A=
>> +             ctrl =3D MDIO_AN_BT1_CTRL;=0A=
>> +=0A=
> AFAICS 10BaseT1 has separate aneg registers (526/527).=0A=
> To be considered here?=0A=
> =0A=
>> +     return ctrl;=0A=
>> +}=0A=
>> +=0A=
>> +/**=0A=
>> + * get_aneg_ctrl - Get the register address for auto-=0A=
>> + * negotiation status register=0A=
>> + * @phydev: target phy_device struct=0A=
>> + *=0A=
>> + */=0A=
>> +static u32 get_aneg_stat(struct phy_device *phydev)=0A=
>> +{=0A=
>> +     u32 stat =3D MDIO_STAT1;=0A=
>> +=0A=
>> +     if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))=0A=
>> +             stat =3D MDIO_AN_BT1_STAT;=0A=
>> +=0A=
>> +     return stat;=0A=
>> +}=0A=
>> +=0A=
>>   /* The gen10g_* functions are the old Clause 45 stub */=0A=
>>=0A=
>>   int gen10g_config_aneg(struct phy_device *phydev)=0A=
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c=0A=
>> index 369903d9b6ec..b50576f7709a 100644=0A=
>> --- a/drivers/net/phy/phy-core.c=0A=
>> +++ b/drivers/net/phy/phy-core.c=0A=
>> @@ -8,7 +8,7 @@=0A=
>>=0A=
>>   const char *phy_speed_to_str(int speed)=0A=
>>   {=0A=
>> -     BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 69,=0A=
>> +     BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 71,=0A=
>>                "Enum ethtool_link_mode_bit_indices and phylib are out of=
 sync. "=0A=
>>                "If a speed or mode has been added please update phy_spee=
d_to_str "=0A=
>>                "and the PHY settings array.\n");=0A=
>> @@ -140,6 +140,8 @@ static const struct phy_setting settings[] =3D {=0A=
>>        /* 10M */=0A=
>>        PHY_SETTING(     10, FULL,     10baseT_Full             ),=0A=
>>        PHY_SETTING(     10, HALF,     10baseT_Half             ),=0A=
>> +     PHY_SETTING(     10, FULL,     10baseT1L_Full           ),=0A=
>> +     PHY_SETTING(     10, FULL,     10baseT1S_Full           ),=0A=
>>   };=0A=
>>   #undef PHY_SETTING=0A=
>>=0A=
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h=
=0A=
>> index dd06302aa93e..e429cc8da31a 100644=0A=
>> --- a/include/uapi/linux/ethtool.h=0A=
>> +++ b/include/uapi/linux/ethtool.h=0A=
>> @@ -1485,6 +1485,8 @@ enum ethtool_link_mode_bit_indices {=0A=
>>        ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT         =3D 66,=0A=
>>        ETHTOOL_LINK_MODE_100baseT1_Full_BIT             =3D 67,=0A=
>>        ETHTOOL_LINK_MODE_1000baseT1_Full_BIT            =3D 68,=0A=
>> +     ETHTOOL_LINK_MODE_10baseT1L_Full_BIT             =3D 69,=0A=
>> +     ETHTOOL_LINK_MODE_10baseT1S_Full_BIT             =3D 70,=0A=
>>=0A=
>>        /* must be last entry */=0A=
>>        __ETHTOOL_LINK_MODE_MASK_NBITS=0A=
>> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h=0A=
>> index 0a552061ff1c..6fd5ff632b8e 100644=0A=
>> --- a/include/uapi/linux/mdio.h=0A=
>> +++ b/include/uapi/linux/mdio.h=0A=
>> @@ -43,6 +43,7 @@=0A=
>>   #define MDIO_PKGID1          14      /* Package identifier */=0A=
>>   #define MDIO_PKGID2          15=0A=
>>   #define MDIO_AN_ADVERTISE    16      /* AN advertising (base page) */=
=0A=
>> +#define MDIO_PMA_BASET1_EXTABLE      18      /* BASE-T1 PMA/PMD extende=
d ability */=0A=
>>   #define MDIO_AN_LPA          19      /* AN LP abilities (base page) */=
=0A=
>>   #define MDIO_PCS_EEE_ABLE    20      /* EEE Capability register */=0A=
>>   #define MDIO_PMA_NG_EXTABLE  21      /* 2.5G/5G PMA/PMD extended abili=
ty */=0A=
>> @@ -57,11 +58,16 @@=0A=
>>   #define MDIO_PMA_10GBT_SNR   133     /* 10GBASE-T SNR margin, lane A.=
=0A=
>>                                         * Lanes B-D are numbered 134-136=
. */=0A=
>>   #define MDIO_PMA_10GBR_FECABLE       170     /* 10GBASE-R FEC ability =
*/=0A=
>> +#define MDIO_PMA_BASET1CTRL     2100 /* BASE-T1 PMA/PMD control */=0A=
>>   #define MDIO_PCS_10GBX_STAT1 24      /* 10GBASE-X PCS status 1 */=0A=
>>   #define MDIO_PCS_10GBRT_STAT1        32      /* 10GBASE-R/-T PCS statu=
s 1 */=0A=
>>   #define MDIO_PCS_10GBRT_STAT2        33      /* 10GBASE-R/-T PCS statu=
s 2 */=0A=
>>   #define MDIO_AN_10GBT_CTRL   32      /* 10GBASE-T auto-negotiation con=
trol */=0A=
>>   #define MDIO_AN_10GBT_STAT   33      /* 10GBASE-T auto-negotiation sta=
tus */=0A=
>> +#define MDIO_AN_BT1_CTRL     512     /* BASE-T1 auto-negotiation contro=
l */=0A=
>> +#define MDIO_AN_BT1_STAT     513     /* BASE-T1 auto-negotiation status=
 */=0A=
>> +#define MDIO_AN_10BT1_CTRL   526     /* 10BASE-T1 auto-negotiation cont=
rol */=0A=
>> +#define MDIO_AN_10BT1_STAT   527     /* 10BASE-T1 auto-negotiation stat=
us */=0A=
>>=0A=
>>   /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA=
. */=0A=
>>   #define MDIO_PMA_LASI_RXCTRL 0x9000  /* RX_ALARM control */=0A=
>> @@ -151,6 +157,7 @@=0A=
>>   #define MDIO_PMA_CTRL2_100BTX                0x000e  /* 100BASE-TX typ=
e */=0A=
>>   #define MDIO_PMA_CTRL2_10BT          0x000f  /* 10BASE-T type */=0A=
>>   #define MDIO_PMA_CTRL2_2_5GBT                0x0030  /* 2.5GBaseT type=
 */=0A=
>> +#define MDIO_PMA_CTRL2_BT1           0x003D  /* BASE-T1 type */=0A=
>>   #define MDIO_PMA_CTRL2_5GBT          0x0031  /* 5GBaseT type */=0A=
>>   #define MDIO_PCS_CTRL2_TYPE          0x0003  /* PCS type selection */=
=0A=
>>   #define MDIO_PCS_CTRL2_10GBR         0x0000  /* 10GBASE-R type */=0A=
>> @@ -205,8 +212,16 @@=0A=
>>   #define MDIO_PMA_EXTABLE_1000BKX     0x0040  /* 1000BASE-KX ability */=
=0A=
>>   #define MDIO_PMA_EXTABLE_100BTX              0x0080  /* 100BASE-TX abi=
lity */=0A=
>>   #define MDIO_PMA_EXTABLE_10BT                0x0100  /* 10BASE-T abili=
ty */=0A=
>> +#define MDIO_PMA_EXTABLE_BASET1              0x0800  /* BASE-T1 ability=
 */=0A=
>>   #define MDIO_PMA_EXTABLE_NBT         0x4000  /* 2.5/5GBASE-T ability *=
/=0A=
>>=0A=
>> +/* PMA BASE-T1 control register. */=0A=
>> +#define MDIO_PMA_BASET1CTRL_TYPE         0x000f /* PMA/PMD BASE-T1 type=
 sel. */=0A=
>> +#define MDIO_PMA_BASET1CTRL_TYPE_100BT1  0x0000 /* 100BASE-T1 */=0A=
>> +#define MDIO_PMA_BASET1CTRL_TYPE_1000BT1 0x0001 /* 1000BASE-T1 */=0A=
>> +#define MDIO_PMA_BASET1CTRL_TYPE_10BT1L  0x0002 /* 10BASE-T1L */=0A=
>> +#define MDIO_PMA_BASET1CTRL_TYPE_10BT1S  0x0003 /* 10BASE-T1S */=0A=
>> +=0A=
>>   /* PHY XGXS lane state register. */=0A=
>>   #define MDIO_PHYXS_LNSTAT_SYNC0              0x0001=0A=
>>   #define MDIO_PHYXS_LNSTAT_SYNC1              0x0002=0A=
>> @@ -281,6 +296,12 @@=0A=
>>   #define MDIO_PMA_NG_EXTABLE_2_5GBT   0x0001  /* 2.5GBASET ability */=
=0A=
>>   #define MDIO_PMA_NG_EXTABLE_5GBT     0x0002  /* 5GBASET ability */=0A=
>>=0A=
>> +/* BASE-T1 Extended abilities register. */=0A=
>> +#define MDIO_PMA_BASET1_EXTABLE_100BT1   0x0001  /* 100BASE-T1 ability =
*/=0A=
>> +#define MDIO_PMA_BASET1_EXTABLE_1000BT1  0x0002  /* 1000BASE-T1 ability=
 */=0A=
>> +#define MDIO_PMA_BASET1_EXTABLE_10BT1L   0x0004  /* 10BASE-T1L ability =
*/=0A=
>> +#define MDIO_PMA_BASET1_EXTABLE_10BT1S   0x0008  /* 10BASE-T1S ability =
*/=0A=
>> +=0A=
>>   /* LASI RX_ALARM control/status registers. */=0A=
>>   #define MDIO_PMA_LASI_RX_PHYXSLFLT   0x0001  /* PHY XS RX local fault =
*/=0A=
>>   #define MDIO_PMA_LASI_RX_PCSLFLT     0x0008  /* PCS RX local fault */=
=0A=
>>=0A=
> =0A=
> =0A=
I have already prepared my next patch with a global is_baset1_capable =0A=
property in the phy device. It is intentional that I did not introduce =0A=
IS_10BASET1 macro. I should have probably explained in the cover letter. =
=0A=
Will do for v2.=0A=
=0A=
100 and 1000BASE-T1 are already more mature than 10BASE-T1. For =0A=
10BASE-T1, the only support added right now is the detection of the =0A=
capability, i.e. reporting to ethtool. I would suggest enabling more =0A=
support for 10BASE-T1 once there is silicon available on a larger scale =0A=
and usage is more clear.=0A=
