Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E790111
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfHPMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:05:38 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:11745
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727007AbfHPMFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 08:05:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kq/kR7hbCkpc9pfMb+ySPugIg6cLhn0hzHnQsDx8Xp5Z1C6AZpqY5aQWBdicTijRqKV+7S7QLP7hWLU2HXNOZOevsBUZxv9CnhhlsNvPZDP5vmtOsElkdhtla/CEJsMlS4HSO9m+t99aLOk6BaqhI9+8EWaImlqK0asv0MmIJs5l/pAtL9rtllBE2PBwvW2bLIBHcZzwMjdXi77MGSAk14ABBk3/WfUN/IGEPKYmvItQ6pw9dBK6VDTrg7G8E5MWISgkJlUv/Pwpq8P3K0JCSQ5bDa+YXzEHPXvKWUPQY1PBry6s6JztIL2Ew6WiJdxcm/zSsBUWm2t2yEyQ/MZ2FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH6AwZUMcpDhcTa1usIWVpiyeRnFMf0qj6GJ1FRrCHk=;
 b=J1b0tla9vLRr4Nv+/WMDJtpKX4i4kRGrEYAyRlWCTig3L/iXbbxaTBFhkWLQFSgZcI88tm9/F/MwyrFjSgvpX2d2cx6mmP627YpcK/pU/QiLWf7XWRhmwazk6iHfyhd6n9O75MmcrjgXxGBbR6Kw6JaUC5h5jmYj4mOaWNdvZMB0AEloJkt6c9H0lWq/5R65I+q1iu4XA12/6bHxdWsWe/+f9h2MXg+6h5UA3b0KBVDtXH8DFeBW5WdQiYK1VPmedEP4c6FCWH8eYaDcR30XxYasr8K7/R6Lo2VZ+E8wV2xQWYrYtlzlnvhX/3yoV+qPbvRUhl9XUhoyWKi4l0NjpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH6AwZUMcpDhcTa1usIWVpiyeRnFMf0qj6GJ1FRrCHk=;
 b=oqq3kYSqBSyXbm86vRJtX5tzXk8ieaO7eNnPcpNDbLY5zXBukCPQJJ5xX6n8+4s09H5gQIoJvixU4JkbnyOSYDMdPVJRV59nB6LLC0TLqP9d8XW9gWC/c7uS5fPoBVN2vxJ+xXvGx8MdrNzMPZYiQ9F55fT/cPFIywqUJb1v72A=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3608.eurprd04.prod.outlook.com (52.133.19.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Fri, 16 Aug 2019 12:05:33 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 12:05:33 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Topic: [EXT] Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Index: AQHVU36mdpwX4yyX/0O62UH8/z+9iA==
Date:   Fri, 16 Aug 2019 12:05:33 +0000
Message-ID: <AM6PR0402MB37985098164C94B361CCD62286AF0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <20190815153209.21529-2-christian.herber@nxp.com>
 <20190815155613.GE15291@lunn.ch>
 <2ca68436-8e49-b0b2-2460-4fcac3094b09@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d6b5547-8a53-46f1-2831-08d722420a58
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3608;
x-ms-traffictypediagnostic: AM6PR0402MB3608:
x-microsoft-antispam-prvs: <AM6PR0402MB3608AC5CDDE3E23DED95C8B586AF0@AM6PR0402MB3608.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(189003)(199004)(81156014)(110136005)(7736002)(74316002)(4326008)(33656002)(52536014)(305945005)(316002)(2906002)(54906003)(81166006)(446003)(25786009)(478600001)(8676002)(6246003)(476003)(3846002)(486006)(6116002)(53546011)(6506007)(44832011)(14454004)(76116006)(8936002)(66946007)(55236004)(76176011)(91956017)(7696005)(66066001)(6436002)(26005)(5660300002)(66556008)(64756008)(186003)(71200400001)(14444005)(86362001)(102836004)(66446008)(256004)(9686003)(99286004)(229853002)(66476007)(53936002)(71190400001)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3608;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +fyd0BSlOl8FFEcQ+9YrziAHstHVed85RfyxoyvbU/g+KuQtb4iEfGx4rrfmcX0h1qac1wr82wJs0ZAra4RmERRzpO7R+EKxRIcqj1T3C43jC5nvZtJEVKaZKzs8Lp56O7s/ahP1mCuwx0A7nAbXRUrlaXBRx9LZizf4+TF2Pf8D2eZOTSQG/x+ACA4YOjRsIHZRTLaYH2rKtqIaQuIyRRbYRJWZEQ97H52n5XTbJH/WBlawZP2ifeWoX3YlBlkH/PIoj8j7HvXHOxslT3diypPHoKpcJxirM5HRyXe14wZPTgG9cczR6JK9kQNJWXuNQQZmZyn2xp2k9Z0yfTN4w4JiY/YyQygT6Dv/WsvPBd2j3Zs5dLZwduOHoBl/gX2CFJOIneVWZ3hQMhMoqhUJb4UrRu4EzGjNO7Zb3TMJTlw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6b5547-8a53-46f1-2831-08d722420a58
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 12:05:33.1950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKAq0Whl/3QEDE4N4cjhOUuY0RPj5Q8pjqekX9SxqItJv2uQL7QiC/0dvpVrdlliTwbDOWt6kEHaH8L3FQxJvcLHCbicYmDWKuPvgJUhpwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 18:34, Heiner Kallweit wrote:=0A=
> Caution: EXT Email=0A=
> =0A=
> On 15.08.2019 17:56, Andrew Lunn wrote:=0A=
>> On Thu, Aug 15, 2019 at 03:32:29PM +0000, Christian Herber wrote:=0A=
>>> BASE-T1 is a category of Ethernet PHYs.=0A=
>>> They use a single copper pair for transmission.=0A=
>>> This patch add basic support for this category of PHYs.=0A=
>>> It coveres the discovery of abilities and basic configuration.=0A=
>>> It includes setting fixed speed and enabling auto-negotiation.=0A=
>>> BASE-T1 devices should always Clause-45 managed.=0A=
>>> Therefore, this patch extends phy-c45.c.=0A=
>>> While for some functions like auto-neogtiation different registers are=
=0A=
>>> used, the layout of these registers is the same for the used fields.=0A=
>>> Thus, much of the logic of basic Clause-45 devices can be reused.=0A=
>>>=0A=
>>> Signed-off-by: Christian Herber <christian.herber@nxp.com>=0A=
>>> ---=0A=
>>>   drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++---=
-=0A=
>>>   drivers/net/phy/phy-core.c   |   4 +-=0A=
>>>   include/uapi/linux/ethtool.h |   2 +=0A=
>>>   include/uapi/linux/mdio.h    |  21 +++++++=0A=
>>>   4 files changed, 129 insertions(+), 11 deletions(-)=0A=
>>>=0A=
>>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c=0A=
>>> index b9d4145781ca..9ff0b8c785de 100644=0A=
>>> --- a/drivers/net/phy/phy-c45.c=0A=
>>> +++ b/drivers/net/phy/phy-c45.c=0A=
>>> @@ -8,13 +8,23 @@=0A=
>>>   #include <linux/mii.h>=0A=
>>>   #include <linux/phy.h>=0A=
>>>=0A=
>>> +#define IS_100BASET1(phy) (linkmode_test_bit( \=0A=
>>> +                       ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \=0A=
>>> +                       (phy)->supported))=0A=
>>> +#define IS_1000BASET1(phy) (linkmode_test_bit( \=0A=
>>> +                        ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \=0A=
>>> +                        (phy)->supported))=0A=
>>=0A=
>> Hi Christian=0A=
>>=0A=
>> We already have the flag phydev->is_gigabit_capable. Maybe add a flag=0A=
>> phydev->is_t1_capable=0A=
>>=0A=
>>> +=0A=
>>> +static u32 get_aneg_ctrl(struct phy_device *phydev);=0A=
>>> +static u32 get_aneg_stat(struct phy_device *phydev);=0A=
>>=0A=
>> No forward declarations please. Put the code in the right order so=0A=
>> they are not needed.=0A=
>>=0A=
>> Thanks=0A=
>>=0A=
>>       Andrew=0A=
>>=0A=
> =0A=
> For whatever reason I don't have the original mail in my netdev inbox (ye=
t).=0A=
> =0A=
> +       if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))=0A=
> +               ctrl =3D MDIO_AN_BT1_CTRL;=0A=
> =0A=
> Code like this could be problematic once a PHY supports one of the T1 mod=
es=0A=
> AND normal modes. Then normal modes would be unusable.=0A=
> =0A=
> I think this scenario isn't completely hypothetical. See the Aquantia=0A=
> AQCS109 that supports normal modes and (proprietary) 1000Base-T2.=0A=
> =0A=
> Maybe we need separate versions of the generic functions for T1.=0A=
> Then it would be up to the PHY driver to decide when to use which=0A=
> version.=0A=
> =0A=
> Heiner=0A=
> =0A=
=0A=
Integrating this with the existing driver or creating a new on is an =0A=
interesting question. I came to the conclusion that it is most efficient =
=0A=
to integrate to avoid all to much copy paste code.=0A=
=0A=
So far, I am not aware of any device that supports T1 and something else =
=0A=
at the same time. From a HW perspective, I also consider this quite =0A=
unlikely. In the unlikely case that such a device comes up, support from =
=0A=
the genphy driver would be limited to the BASE-T1 modes. But i would =0A=
rather create the special case for the special device and cater the =0A=
current mainstream support to the mainstream devices.=0A=
=0A=
I think this boils down to a general strategy for the PHY framework, as =0A=
this can happen for other classes of devices also like NGBASE-T1, =0A=
MultiGBASE-T and future unknown devices. For now, I think the =0A=
architecture is sufficiently scalable with a single c45 genphy driver=0A=
=0A=
Christian=0A=
