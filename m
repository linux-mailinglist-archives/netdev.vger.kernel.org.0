Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9D12B9A59
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 19:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgKSSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 13:06:11 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59132 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbgKSSGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 13:06:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605809169; x=1637345169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZYRjEX5ceKReJNSd205TfM/k5AhVa12mGWHWlhfYvVY=;
  b=pPMDm1hqeYxcv6j43prUVL6Qh6TjLyvici2P49QuvSFXhnj6QXzJVzhs
   x8f2DPXv+C4n9OlDGLfZhjMv4iA142OlXnRiu1G86NztON+Y5fVOIhqZm
   1HuCqZiFHM9LbSTYMNpWFG42JPVKkem3Cf/joR9N2f5m6xUQL56+K/1CR
   YleL5EZxaXC+BonAQZUxMPf0e1msxUsBQ+TyulNXb1EDUTC3558tOxH0I
   SbvEaopOiLuk8lJSU6pOwy64k1et4+wTTH0HsveKXZkbCKImTmSy0Uqza
   jPIbJgAMXtqKPBon3zjlcwNgz3vXOq5ZyE0n8qyIeOTde4yKje2eeTzOM
   A==;
IronPort-SDR: NOBrLTnNDRhJsNrDgMrum+bzurPefeoufmN6+Y6kXvCwpchXlBZ4HDNc13XO99g5OSCC+amHnq
 C2NCq++oUpmnIpdAMtP8pwUvV42LS7Ga7tDkPxmQWziJLu7KAg9PW3MgBVFRm7xyRiC+aJxUBs
 8mY/gS0Y8mq8BYAS048HO39tCMpJLy+E6U5nhXSIy3FOKhX5IOk0Emntih1WayS6KLhvpTIG6C
 4hgSwS2XAqwKXAhlAfvZSlHNAT7LP1YzrhMCdMJmypt5+/G9+tF2KfvY3+GRx1w93Vva9bq5BT
 v/Q=
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="104285820"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Nov 2020 11:06:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 11:06:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 19 Nov 2020 11:06:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS3dBbBLtCJViD2JkBFWkc8XlLvchB/Kf4QfJtFOtt3J8r/ta0MuV4N8QC1fjjGcgREeVCVMe/CRRNT70rs8s8LMx5pJYn18pAAs+ppOYQskxzM+mvEpOBF7wVJGbJtc2QU251viNh8HudKdH+PsqCg6lzM9+HnwUoWpYdZV9H4RUy5KY4yQlg6/w67oy2Uxt/+1SOI42sNjmnF2Uont8pVbL4GWpPLUIRYVpVSNmunRKEkP3WyukUYCGWRK98qljKdhQS3bhOYPM12v4hTv67rOF/2y2MkzMX+w66nqcE9Lygu1QLNARp7ArJE4RWxwH3in1fX+GW9PrBKxx9HCyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELia+U9BLFKjcFCdbHgo1E6skRxHHUP4aAF0IQ3KLoQ=;
 b=mA3dKPkqARO+5n9V0L3/fls/7hIB03pwRIWq898XVPFLRWBAOxZSnNyb9f6hJG2lVXTxlM6j3wZo2kUWDG85P5B0hqNFP1EeIW1JDRKKeYXj+JBlQ4zX6JbuhuHL6g9beNAPFUS4RgChptoVe8gbeTgOMESRqfAvTvIDBNKPTQqUUKBQzJdXAgBsC/1+4lQT2Hgvs771mtoM0y9BuUAiBSioPrjJbZCLyibKLMTZwwFyWqUpxy+WCP1vckjBPB7BWSL+txnYhY0K+bWLYgf/2+sBlc39yBGXWUzor5FjOXMgDdE1unPSLVkP80BlNwbJeGPi8hS31++GKts5M5WDBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELia+U9BLFKjcFCdbHgo1E6skRxHHUP4aAF0IQ3KLoQ=;
 b=G2TIANMpA1YnRgZPa3rRzmoE8QJKuxq8X9njwvInFu645b+ppMB+Rw18QhbvosR5OMFeHqyf0rcxRoyfqxRv3EeDvcWeT2YtPpQgCkAIH0O1cMMocDhDKM8rDnTYkaLOtPFzcu+zXck/okqW2RTU+upOihzLyTIYEM3l2n257iY=
Received: from BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11)
 by BYAPR11MB3349.namprd11.prod.outlook.com (2603:10b6:a03:1c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Thu, 19 Nov
 2020 18:06:03 +0000
Received: from BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::d420:c3da:146c:977e]) by BYAPR11MB3558.namprd11.prod.outlook.com
 ([fe80::d420:c3da:146c:977e%7]) with mapi id 15.20.3564.031; Thu, 19 Nov 2020
 18:06:03 +0000
From:   <Tristram.Ha@microchip.com>
To:     <andrew@lunn.ch>, <m.grzeschik@pengutronix.de>
CC:     <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <kernel@pengutronix.de>,
        <matthias.schiffer@ew.tq-group.com>, <Woojung.Huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 08/11] net: dsa: microchip: ksz8795: align port_cnt usage
 with other microchip drivers
Thread-Topic: [PATCH 08/11] net: dsa: microchip: ksz8795: align port_cnt usage
 with other microchip drivers
Thread-Index: AQHWvfbKugSZWRDqdUaYtWAY3mK3xKnOm/UAgAEeKHA=
Date:   Thu, 19 Nov 2020 18:06:03 +0000
Message-ID: <BYAPR11MB35589C5922F285095F7768B4ECE00@BYAPR11MB3558.namprd11.prod.outlook.com>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-9-m.grzeschik@pengutronix.de>
 <20201119003556.GL1804098@lunn.ch>
In-Reply-To: <20201119003556.GL1804098@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [99.25.38.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d83cb9c1-9b1f-4c22-006e-08d88cb5c79f
x-ms-traffictypediagnostic: BYAPR11MB3349:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3349E3F1334A94EBD97387B0ECE00@BYAPR11MB3349.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N7cuyKi14uL+BKizu2x/fZl3o9P6ww8SnJRd52a+MxGbeRawnx5OPjaaT+xB5UbtL3xp6oj+XEk2ODKnE02sPgJBnXouPddCv5KqBoY4xvVS5A0nvci3nZY6SHE7tXNJYh4IwKNnFcXyAfILAfIVoOvGdOBe4fENlP3PWr26TN9HfHkTkFxZhLDPbX5M1N1uIQuviJad2rpfEEgfJ9lZPXzz6GMfU/v5o71kNvoOvYDIfVV5EYH5VBz1iwymSbNz6qdc9JS19feT58wuI6Sy5MRSgDD2P2ur7meyAaBo5C8NC2IfCV6ZEecDlBgfiSJWNf/Ns+cGMg3rFolAwNR32w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(366004)(136003)(396003)(83380400001)(7696005)(8676002)(110136005)(26005)(86362001)(6506007)(8936002)(55016002)(9686003)(478600001)(5660300002)(107886003)(316002)(54906003)(2906002)(66446008)(71200400001)(52536014)(66556008)(33656002)(76116006)(186003)(66476007)(66946007)(4326008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WGGv26h0g+vIdvNSReyLaIOafB0hTiEJcpF+n/+6lqBRG+wyWx8jpOEVKM6rY9r9kuAt0eJef+vC+MSWg0nrmDQb2KXyPClmeLBC6Rqu6UF0IgXSHK+ypOd5AYNd9K1DFUSb5hPZhgZXbbqvzl3Jodjb+pIVtUCArGNY5OYUIElX8oFnokjIgBF9c7hFFmBQ0zNXcbecMX/z1Xh9lfDcV9xjbjIvXF+2gRRUlbUMm4s9fKIVBZqoVaAl31thwqjYcQ/5raqmq9ugQb0JiSGcLg4BDiLhZjWbFSLQfCEslfsTCPP6TYs+FCpuaQ/wrZGEU0NMYNYtgxMy53RiseeEmVTGAA3e9iV3BNdONTn2cSauGZWyemYAJWFRUICBmeHxtWlNIuIJpGRDC4p/pLJmOySj5fzPEDTS7ncxARPSgdwG94+R5tQ5Uxpl1nUrmhV37hEMeMyHNX2I2DKWp7c1A7A9P5fK/UVKx95w8/1fbTFDC+Kwvl3BQiIgO0DFAYLefgMLjn0L205PxSbc1cpRMFNbCi1LhY5WhndO15F6dnA1swX5J8WL6Vx+PisoWUSDjsrOUNclpnWOVXvSW+mJXPtJWhQVR/9f9pVyhrhN6OpIodZKf946BxhqoKKtY44FAGlDafe6Ke5WtmJDgCONfQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d83cb9c1-9b1f-4c22-006e-08d88cb5c79f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 18:06:03.7641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/0JgvijKZ0A64C/2/YgWIyf30wampQiSsVvdxn6VRiiN/udk2yv6tNGFDWlsTgB+z/69j3h5omt6ckDcu+tlrARZ1xYTSazwFqC0RdT4Gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3349
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Nov 18, 2020 at 11:03:54PM +0100, Michael Grzeschik wrote:
> > The ksz8795 driver is using port_cnt differently to the other microchip
> > DSA drivers. It sets it to the external physical port count, than the
> > whole port count (including the cpu port). This patch is aligning the
> > variables purpose with the other microchip drivers.
> >
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8795.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/dsa/microchip/ksz8795.c
> b/drivers/net/dsa/microchip/ksz8795.c
> > index 17dc720df2340b0..10c9b301833dd59 100644
> > --- a/drivers/net/dsa/microchip/ksz8795.c
> > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > @@ -1183,7 +1183,7 @@ static const struct ksz_chip_data
> ksz8795_switch_chips[] =3D {
> >               .num_alus =3D 0,
> >               .num_statics =3D 8,
> >               .cpu_ports =3D 0x10,      /* can be configured as cpu por=
t */
> > -             .port_cnt =3D 4,          /* total physical port count */
> > +             .port_cnt =3D 5,
>=20
> Rather than remove the comment, please could you update the
> comment. port_cnt is too generic to know its exact meaning without a
> helpful comment. And this might be why this driver is different...

At one time there are 3 distinctions of the ports used in the drivers for K=
SZ switches.
Physical ports require valid link to operate.  They are the usual ports use=
rs interact with.
The total port count is usually physical port count + 1.  The last port is =
the host port.
They all have the usual port controls like receive, transmit, QoS, and othe=
r functions.
That last port may not have MIB counters.  That is why another variable is =
used to
manage handling of MIB counters in a loop.

The KSZ9477/KSZ9897 family of switches is a new design where any port can b=
e a host port.
It also has extra RGMII/SGMII port that makes the term "physical port" ambi=
guous.

KSZ8795 has 5 ports.  The last is always the host port.
KSZ8794 has 3 physical ports, but the last port is still 5.  Port 4 is disa=
bled.

There is another KSZ8895 switch which also has 5 ports.  It has a variation=
 KSZ8864 which
disables the first port.

Now the DSA layer treats each port individually and there is less use of a =
loop of ports
Inside the switch driver it is good to consolidate those port variables.

