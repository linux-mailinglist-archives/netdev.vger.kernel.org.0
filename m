Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D1B17763A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgCCMmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:42:14 -0500
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:35203
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727826AbgCCMmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 07:42:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmCOOnDlMLRxdFOgiby21tMyUlUt0YhluW2ZjoI9RIXB2M7VTeS4tkPbqYhRIQ+JH80nbkt7gVJnIiGgjtmZ2IbBiFhJCjWjOEXfevGMz78ZQKjKM0z01CS0HXDm6GwMnO+bTpm6dvpEu8eAPphsxaUXOPkJh7JvqvWxaW6ZGItS7/722KRP6qAJV5ckTskpSFBQ5HhxgU6KuE861loQm1LsHcxXRskb68m+wqUipYvYCw9IK9Mc9Be1320HrTUpIXkaD7iWnaxKsZmSJd5i6L/UYHrflhWbsY62CXBPbraZ2OfYOBOZdYMw/wNgsFjbKlYC/rmakBilpgn/47oe6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bk9MfbDo3TNh+lza+ASVDdD8ZjXNSbDlD0QBAwzWWk=;
 b=nVMmryey8nFlLwrxN7lsIRuJ4OnqdqoBAfiDoWent5ZzadCVes5WHePVRajnO7gmksEXSxAZL/jdyoCdiLAMbHId7KhDE+qOobDZZqQjvwAMFhGX7c3/Hk573NwpZ+k1mb7nSxuH5focUbGOqV329QiiAwwZFF1kCSXO79kVjz4wBAbfCODOPQOgL/bAZa7lYgukggJbr0RO190xT6q5pQ2mlxk2SA+mBqK4zAMGLsYpc/x8MdOA6ji+5Shg1VwsrUaZ/2yVaF026vzS+i0OfQMAqEo74woutydIF6V01O1JW1kSbcANxlve8p9gJivpYDQ/HcM+0r69bboCenUuew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bk9MfbDo3TNh+lza+ASVDdD8ZjXNSbDlD0QBAwzWWk=;
 b=FoVRuRFZdhmidqpC6t9NwcUF0vPby6xzSs82Gdb5ZOP3ri7L/NbxqlpgFExrbDYLfCXbpX8s8VqmWSerhWH6NFly9W1vdtcnfVpCtgL7iIT2EkVqI+m1UTYc0/m6cPXEJcYAXomTvmTAhAYi1mhufYkcCmTJJknV00DVLG44nSk=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (10.186.130.77) by
 AM0PR04MB6643.eurprd04.prod.outlook.com (20.179.252.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Tue, 3 Mar 2020 12:42:06 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::59c3:fa42:854b:aeb3]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::59c3:fa42:854b:aeb3%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 12:42:06 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
Subject: RE: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
Thread-Topic: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
Thread-Index: AdXxWSNaD5VJgo+AS3aQClSReU4fbQ==
Date:   Tue, 3 Mar 2020 12:42:06 +0000
Message-ID: <AM0PR04MB70412893CFD2F553107148FC86E40@AM0PR04MB7041.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02d0c6f6-5076-4027-3792-08d7bf704825
x-ms-traffictypediagnostic: AM0PR04MB6643:
x-microsoft-antispam-prvs: <AM0PR04MB6643E72EC4B20EB260E5256086E40@AM0PR04MB6643.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(9686003)(66946007)(7416002)(81166006)(52536014)(8676002)(2906002)(55016002)(66556008)(4326008)(66446008)(86362001)(81156014)(76116006)(66476007)(54906003)(7696005)(6506007)(53546011)(64756008)(478600001)(110136005)(8936002)(5660300002)(966005)(316002)(26005)(71200400001)(33656002)(186003)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6643;H:AM0PR04MB7041.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EzhVW5LnsrQwB75T7luQT4JSaX3QXRRMNc21q34bQn3CUFm4Nc5FQhEvZuFdtgYS85fz4Fjw9Balty5B6rZKfN7FFje3aIze3tlVBTfCeEEpTjAKCRdCzvroViYaj40+WJ1zJLPmfsAfq8TUEo9GHj+1kazKQ4A56tG8jABvkb2VpVlE+q4MCzVr+5PVObx+P/Ui14okf3d15LY7joIXQZfKIRw3fsk0d8D7RKpD0lVFhUwCY7uIVqkqzuvKge/K4fmeqHOBtiKmX3V2eLp9F13vgKy/jH4+71gbuOazKZAss4PpE/llWrFnSm4rtijLsMlnKdtM8dzAOyisOYjebRLJ9o0Pi+c+XsVRQmIt2bwtkfjlE2CWYOazZzNS617O0hH3+UgQj7M0IBaguVjttwe9bnit3MwF5a8TtHDvrD2CR5kRr0x8f9hwmL3YUAnETEwXjvS2Dy1ohFCraJbObhh0BDZiUq185bReeyFZs2eSWvHDY/YJmZfuOHWhwO4rsx9LFZCXFmxY8l5p7IgARA==
x-ms-exchange-antispam-messagedata: /BaMf0xVSwsAsHw6TwU9O9sE9R4VHRNHt2oyOS9H1iYxlFjpP7uUQbqbiBayq3L0kUY0PhPZzqXc77YEedUyEKC5EK7vUis60iYRzCmhZWmceoJb2sBnPznnsYsqw6QdUeorHHjgSmtrXKvdlfGCgA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d0c6f6-5076-4027-3792-08d7bf704825
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 12:42:06.2979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W0j7t2ROP0pdwfvCeIBs5lHdvkigVFqEvmyw9lkSQh/QaO0OwhylUuxyG5KxoP4BRFUa7U13dge9pdqR+rPcj3fIw8OMpk6CJHpd7Jhi/cY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6643
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 03.03.2020 08:37, Oleksij Rempel wrote:
>> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
>> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
>> configured in device tree by setting compatible =3D
>> "ethernet-phy-id0180.dc81".
>>
>> PHY 1 has less suported registers and functionality. For current driver
>> it will affect only the HWMON support.
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> ---
>> drivers/net/phy/nxp-tja11xx.c | 43 +++++++++++++++++++++++++++++++++++
>> 1 file changed, 43 insertions(+)
>>
>> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx=
.c
>> index b705d0bd798b..52090cfaa54e 100644
>> --- a/drivers/net/phy/nxp-tja11xx.c
>> +++ b/drivers/net/phy/nxp-tja11xx.c
>> @@ -15,6 +15,7 @@
>> #define PHY_ID_MASK                  0xfffffff0
>> #define PHY_ID_TJA1100                       0x0180dc40
>> #define PHY_ID_TJA1101                       0x0180dd00
>> +#define PHY_ID_TJA1102                       0x0180dc80
>>
>> #define MII_ECTRL                    17
>> #define MII_ECTRL_LINK_CONTROL               BIT(15)
>> @@ -190,6 +191,7 @@ static int tja11xx_config_init(struct phy_device *ph=
ydev)
>>              return ret;
>>      break;
>> case PHY_ID_TJA1101:
>> +     case PHY_ID_TJA1102:
>>      ret =3D phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
>>      if (ret)
>>              return ret;
>> @@ -337,6 +339,31 @@ static int tja11xx_probe(struct phy_device *phydev)
>> if (!priv)
>>      return -ENOMEM;
>>
>> +     /* Use the phyid to distinguish between port 0 and port 1 of the
>> +      * TJA1102. Port 0 has a proper phyid, while port 1 reads 0.
>> +      */
>> +     if ((phydev->phy_id & PHY_ID_MASK) =3D=3D PHY_ID_TJA1102) {
>> +             int ret;
>> +             u32 id;
>> +
>> +             ret =3D phy_read(phydev, MII_PHYSID1);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             id =3D ret;
>> +             ret =3D phy_read(phydev, MII_PHYSID2);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             id |=3D ret << 16;
>> +
>> +             /* TJA1102 Port 1 has phyid 0 and doesn't support temperat=
ure
>> +              * and undervoltage alarms.
>> +              */
>> +             if (id =3D=3D 0)
>> +                     return 0;
>
> I'm not sure I understand what you're doing here. The two ports of the ch=
ip
> are separate PHY's on individual MDIO bus addresses?
> Reading the PHY ID registers here seems to repeat what phylib did already
> to populate phydev->phy_id. If port 1 has PHD ID 0 then the driver wouldn=
't
> bind and tja11xx_probe() would never be called (see phy_bus_match)
>
>> +     }
>> +
>> priv->hwmon_name =3D devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
>> if (!priv->hwmon_name)
>>      return -ENOMEM;
>> @@ -385,6 +412,21 @@ static struct phy_driver tja11xx_driver[] =3D {
>>      .get_sset_count =3D tja11xx_get_sset_count,
>>      .get_strings    =3D tja11xx_get_strings,
>>      .get_stats      =3D tja11xx_get_stats,
>> +     }, {
>> +             PHY_ID_MATCH_MODEL(PHY_ID_TJA1102),
>> +             .name           =3D "NXP TJA1102",
>> +             .features       =3D PHY_BASIC_T1_FEATURES,
>> +             .probe          =3D tja11xx_probe,
>> +             .soft_reset     =3D tja11xx_soft_reset,
>> +             .config_init    =3D tja11xx_config_init,
>> +             .read_status    =3D tja11xx_read_status,
>> +             .suspend        =3D genphy_suspend,
>> +             .resume         =3D genphy_resume,
>> +             .set_loopback   =3D genphy_loopback,
>> +             /* Statistics */
>> +             .get_sset_count =3D tja11xx_get_sset_count,
>> +             .get_strings    =3D tja11xx_get_strings,
>> +             .get_stats      =3D tja11xx_get_stats,
>> }
>> };
>>
>> @@ -393,6 +435,7 @@ module_phy_driver(tja11xx_driver);
>> static struct mdio_device_id __maybe_unused tja11xx_tbl[] =3D {
>> { PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
>> { PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
>> +     { PHY_ID_MATCH_MODEL(PHY_ID_TJA1102) },
>> { }
>> };

Hi Oleksij, Heiner, Marc,=20

You could also refer the solution implemented here as part of a TJA110x dri=
ver:
https://source.codeaurora.org/external/autoivnsw/tja110x_linux_phydev/about=
/

Regards, Christian
