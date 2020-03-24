Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30111904A2
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCXEul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:50:41 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:10953
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbgCXEul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 00:50:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAoqatParUaIz4P6t2/tXMUgopOEB189a7RpKccDtjtvE6awyb9NCJrgqIr4vyI1EX2cX6smZus4cycCMlEb2T2eQxgm/vJjjWMZRkbYhbrmtrHL7xe+ZdCGqr3iOhoSus98+Pn8USE4EmwSgkpfyWLFBCR3CpN0Or4LTyqaFQpYjxsmqg6tJo2c0aTg34pIvl5VJTbfqTB0yyrUAOOXLICdmc20EsdO5vaeWQN6vJ5IRA9WOqC4NGh8aktYxuCLjkLvTJHvtxdlcfv1uWOT2RHUj3orpjN3NVf14Npp+oFU00UQ4ErgonTq+HXAb3WDYjGwB0dbSa2GbjiyZ6XiTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w22WBUYXIvhdSDlOHPAaapX4A3M9yjmzEqMoZFPvvxE=;
 b=mLtUpQDVWpy8ZXQYyfFvup7/3ha+Oj6Yz+T67Yz/mhUBMt0uCq75UrumWTamcBYU5MQjfrrH6pAbMc5vEbH5gBBtIxUVnEdiZExP58PVkqQ3Sek0lGasCN804T8NM2/KckZm9hFevOOeAsqWkFqpCepv9gTNasBGAh8p0uAWplUadOUm0kTr/KskZi4ZUiFwhsFcSAoD48xT/8o24hdjPLEnN/0SiJIxY5HJUSms8lH7EPib60v/mOZoph8HqWTKKBcEiJv3Ypvb3V2NW4JEldoYBMBmKbPtDX/Nk4Z1ANm9vyLscnUANTQBniI3Im7X564X34kDkMp1kyBzrFjmWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w22WBUYXIvhdSDlOHPAaapX4A3M9yjmzEqMoZFPvvxE=;
 b=YOv5FH4dKK0D447JJp+pr0YQ3W287zjObAzIUfQ+UD0c+y8N8D5SFQ2PPNbxiDP76NRU0VjYxz0HmVmZRxE6Ukch400I4Vms+fIQkwHUHNS8Lg63E68c5qi3O2i4ua+o+udKwQpLxs8gMwKKXII4Oz/2Gm4I0jWKyc2fnJmnQAU=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB6791.eurprd04.prod.outlook.com (10.141.171.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Tue, 24 Mar 2020 04:50:37 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 04:50:37 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 2/6] MAINTAINERS: add entry for Microsemi Ocelot PTP
 driver
Thread-Topic: [PATCH 2/6] MAINTAINERS: add entry for Microsemi Ocelot PTP
 driver
Thread-Index: AQHV/qQN6DAjXUk5yE2GP8p8zfxBX6hRvKqAgAV1YiA=
Date:   Tue, 24 Mar 2020 04:50:37 +0000
Message-ID: <AM7PR04MB688563BE075A253304C9D6A5F8F10@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-3-yangbo.lu@nxp.com> <20200320172831.GS5504@piout.net>
In-Reply-To: <20200320172831.GS5504@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0eb9b75f-8e1b-4153-80d4-08d7cfaee53b
x-ms-traffictypediagnostic: AM7PR04MB6791:|AM7PR04MB6791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB679149779A63F9939EB41507F8F10@AM7PR04MB6791.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(4326008)(2906002)(6916009)(71200400001)(55016002)(9686003)(54906003)(53546011)(316002)(6506007)(26005)(8936002)(33656002)(7696005)(186003)(86362001)(52536014)(66946007)(5660300002)(66446008)(45080400002)(966005)(81166006)(81156014)(66556008)(478600001)(8676002)(76116006)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB6791;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EeUGt3qGDamzzn7vXe4IsKRMoxuvzB8aKSaIRhoaYIjKzsv/LDWuzl2VG10QN7lTwPPftXL623e2saso62R6CHPkzNBRYM2vTLz8JP6B/5EKQOqhXm5fvEurlFA6qfUqq+jT9/Wamvw25Uky1iZSpTqDBhHk2pg70whcvh9BZhFQNS50s2pq2BAuIuG+DQzkvwTgF9GbTvH3/R2HH4rvS1Ku5gW1UNr6oTUuV9UGwMIhG9XkartGB0LwH/wcFHrae1rroDF97aIJQ3iispb9ftQo8dye2foL80PCOgCKSfrvs8kUT35Jddh5rlu4P6HnpcU1FBhwCW2SyS3AkPYsPlS2S32MRFfIaPuXKl8RvL/SY7y5CapZhv0LLVrsVO+pPaoJTbcwPeHsaSYoFhz7mbPhctUnRolC3RdgTVTm+S136r+7pRCNY9JFIWbhUgUN7G/rHJpH7Nnnwlsv/mWtziPSmpCODQOkjAa8DTRejdo=
x-ms-exchange-antispam-messagedata: hmBSPxCn1O7J/XsxluwFR69JD/CNAEBP41SfsX4XkjVhwQT4dcQUalHYmglnrs3gNj1zT49vgEWCqYwmK3Q6vxQHMOj7CdHVHZyVdvH/XRpkM5BOg7zku807oQ+mdbUQnihrfu4QzRiBgQTuIlTxYQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb9b75f-8e1b-4153-80d4-08d7cfaee53b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 04:50:37.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dE8Lxa1g7HuESe/2vYaUtM9355d/7go//mrxQIWBZcOJkKaJIti9Qbf4qN8JKXpgc1vZGwofiPkNIorrM6+4gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre,

> -----Original Message-----
> From: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Sent: Saturday, March 21, 2020 1:29 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; David S . Mille=
r
> <davem@davemloft.net>; Richard Cochran <richardcochran@gmail.com>;
> Vladimir Oltean <vladimir.oltean@nxp.com>; Claudiu Manoil
> <claudiu.manoil@nxp.com>; Andrew Lunn <andrew@lunn.ch>; Vivien Didelot
> <vivien.didelot@gmail.com>; Florian Fainelli <f.fainelli@gmail.com>;
> Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH 2/6] MAINTAINERS: add entry for Microsemi Ocelot PTP
> driver
>=20
> Hi,
>=20
> On 20/03/2020 18:37:22+0800, Yangbo Lu wrote:
> > Add entry for Microsemi Ocelot PTP driver.
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> >  MAINTAINERS | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5dbee41..8da6fc1 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -11115,6 +11115,15 @@ S:	Supported
> >  F:	drivers/net/ethernet/mscc/
> >  F:	include/soc/mscc/ocelot*
> >
> > +MICROSEMI OCELOT PTP CLOCK DRIVER
> > +M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
>=20
> I'm open to not be listed here as I'm not the main author of the code
> and I'm not actively working on ptp for ocelot...
>=20
> > +M:	Yangbo Lu <yangbo.lu@nxp.com>
> > +M:	Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
>=20
> ...as long as you keep that address.

Get it. And thanks a lot.

>=20
> > +L:	netdev@vger.kernel.org
> > +S:	Supported
> > +F:	drivers/ptp/ptp_ocelot.c
> > +F:	include/soc/mscc/ptp_ocelot.h
> > +
> >  MICROSOFT SURFACE PRO 3 BUTTON DRIVER
> >  M:	Chen Yu <yu.c.chen@intel.com>
> >  L:	platform-driver-x86@vger.kernel.org
> > --
> > 2.7.4
> >
>=20
> --
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fbootl=
in.
> com&amp;data=3D02%7C01%7Cyangbo.lu%40nxp.com%7Ca8238c4d91e74bb0
> 29b708d7ccf41ed6%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C
> 637203221179059159&amp;sdata=3DzEpGkU97BJryTf9NpcHj1%2BgHnxQhV%2
> BXoC9iewMmzjrw%3D&amp;reserved=3D0
