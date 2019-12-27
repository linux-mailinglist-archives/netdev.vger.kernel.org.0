Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0F912B0DF
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 04:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfL0DvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 22:51:13 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:2449
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726804AbfL0DvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 22:51:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLIFvYfoqOnwMiQFiFdgGx2IAqiXUmu5a7wmRzuuQTDYPdHioEYsdDVhOXNSta6R/bPj0ItOJryobtUdCmAWPwl914a9Vzr/fXN31PnWw64P1pwatGNB77uwPsGnizLDMnaUo+0SEla2W/NIBrWkllpw9PHMxFXdyJ7t1xjx4jHecjA3KtTFKziYQ5dt4ty1GfjFCR3GsKwZHkJq8qldV+5nhk9vYxE6c5c644Cv4f+DmveTy4GFMMgVxQerllSnf50uYEZeKpEgG+Uwyya2aLU4pUILIMuXZgCLh47AZCzeSQfNOSv1SkFR9vzLnSsVep3ueDlwG9xitAE42F3g3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av9jRY5qFwxX90ftjtOhbhCIgb3mf0J85qkOQst6/Jg=;
 b=KRLpZqPr5TMPbOC/laBU9AjgQWO9Iqq2OnOFgsxIzZ2To+Z3INvZBNT96SNVZh4ScTWNLpZJggAcpt9XgmPUC/o7j2iurasv+JJVVrlIRixvTS5uS9w3ca5QRduRYe5oZd+YW9GNQqfI9+udk06nPvrgOtECg/PQmzWcopHQL+Rqyh0KHIrNqVD4B73dZZpr5raCuSyi02IeTJ1IHMq04GQi/UodSdBm2s47aGKCpLxFDjKqeReQ5cCDsKmvkOg9SIKK0G+k1Sy+Ezgv+5Ka9EabXCweYyxEE7IFPhsHb253x6Aqp7wu5N/LseP7phln6gLp8UR/YmWgjxh6qgX1uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av9jRY5qFwxX90ftjtOhbhCIgb3mf0J85qkOQst6/Jg=;
 b=EEwjba7h4ENivbWJbF8wvd/P/mnlwuWdqiMXQZOjuCO/2LKX/HUolyQX+rAtMXe6iNVVC+QAwMlnAu8SRKhFcIv888KIy7gDI16kz7tiSa0gwwhHJbV00zG6ohyBDXfoF4uS2PLMa+Kd1Qm5ZsPMeprZQMh7uQGkY2vrg0Yyj3E=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7112.eurprd04.prod.outlook.com (52.135.56.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Fri, 27 Dec 2019 03:51:09 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f07f:2e7c:2cda:f041]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f07f:2e7c:2cda:f041%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 03:51:08 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH] net: mscc: ocelot: support PPS signal generation
Thread-Topic: [PATCH] net: mscc: ocelot: support PPS signal generation
Thread-Index: AQHVu9M/WSOP+wb7uEmsr7BfCHTyEqfMPJMAgAAB50CAAP7kAIAAFlaw
Date:   Fri, 27 Dec 2019 03:51:08 +0000
Message-ID: <AM7PR04MB68858E4814EB85A8860FA48FF82A0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20191226095851.24325-1-yangbo.lu@nxp.com>
 <CA+h21hojJ=UU2i1kucYoD4G9VQgpz1XytSOp_MT9pjRYFnkc4A@mail.gmail.com>
 <AM7PR04MB68858970C5BA46FE33C01F48F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20191227020820.GA6970@localhost>
In-Reply-To: <20191227020820.GA6970@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0fb1492-d0f7-40ed-5f1a-08d78a8001f4
x-ms-traffictypediagnostic: AM7PR04MB7112:|AM7PR04MB7112:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7112DE333E7BEB435E9F3743F82A0@AM7PR04MB7112.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(13464003)(5660300002)(52536014)(316002)(81156014)(55016002)(2906002)(8936002)(26005)(8676002)(186003)(81166006)(6916009)(9686003)(54906003)(64756008)(76116006)(66946007)(66476007)(66556008)(86362001)(7696005)(53546011)(6506007)(4326008)(478600001)(71200400001)(33656002)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7112;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pSXDiZKLgwFWXdO1jvmJnbZy/eDydxDQBT1aftjbAgNqIf9Ad9GGraWgaFj1wTd9PsoXW1KKMQExK2Yvy5i9DnZrDIs4jgqBD2xHgY+xjJkUILUgVpOk0kyFO/MPKM1GXpyHP5mLpMHwp0uhCLHWGCOtIksRXhketKoUnS8go0jZPzm794nf4OG6cZzhcZFqwqMq9FWzC94Bx2HwgQreV5LDTaRnwtQKjOCYYVZO8woiJLKTvd5azeOYy09+C1Ay3ZsylBGhyxjobj+KWyp0V2IIB4spbHcrzm4V0VswcP8IJM+NJv+rV9XzOgB3mLiyFQ5ZLnBHklIaxFnNYMDe3eatS3F2jWhVTBNZc2uCs+m+NpbbR6diWQYqXBD4amdmNWJsbEBNQrtCO30aObCMNrxhQUn/7yabd1Wav4hlYVSxP0IxvuwV3JJsKmJcNYwQFTQpB6pxP9I2+BvJU1eewnPpZRAs1sDnTTuDLepNxgWw4RnNcX5cl35i8INt1NaS
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fb1492-d0f7-40ed-5f1a-08d78a8001f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 03:51:08.8637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9hHZVLDsF0mnJjquIJz4dydAb9SkQFcecXBPN62BKZF6tusVN3D9U6Lo9stsXHOcvw/HswaCGRoWAAYh2Ui+lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Friday, December 27, 2019 10:08 AM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>; netdev <netdev@vger.kernel.org>;
> David S . Miller <davem@davemloft.net>; Claudiu Manoil
> <claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
> Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux Driver
> Support <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
>=20
> On Thu, Dec 26, 2019 at 11:17:26AM +0000, Y.b. Lu wrote:
> > > -----Original Message-----
> > > From: Vladimir Oltean <olteanv@gmail.com>
> > > Also, I think what you have implemented here is periodic output
> > > (PTP_CLK_REQ_PEROUT) not PPS [input] (PTP_CLK_REQ_PPS). I have found
> > > the PTP documentation to be rather confusing on what PTP_CLK_REQ_PPS
> > > means, so I'm adding Richard in the hope that he may clarify (also
> > > what's different between PTP_CLK_REQ_PPS and PTP_CLK_REQ_PPS).
>=20
> The PTP_CLK_REQ_PPS is for generating events for the kernel's PPS
> subsystem.  (See drivers/pps).  This has nothing to do with actual PPS
> signals.
>=20
> > My understand is PTP_CLK_REQ_PEROUT is for periodical output,
>=20
> Yes.
>=20
> > and PTP_CLK_REQ_PPS is for PPS event handling.
>=20
> No.
>=20
> Some cards generate an interrupt at the full second roll over.  The
> interrupt service routine can feed a system time stamp into the
> kernel's pps subsystem for use by NTP.
>=20
> If your device is generating an actual PPS output signal, then you
> should implement the PTP_CLK_REQ_PEROUT method.
>=20

I'm a little confused.
It seems PTP_CLK_REQ_PEROUT method needs req.perout.start and req.perout.pe=
riod to generate periodical *clock* signal, while PPS is *pulse* signal eve=
ry second.
For the two cases (1Hz clock signal and 1 pulse very second), how to config=
ure with PTP_CLK_REQ_PEROUT method?


> Bonus points for making the signal fully programmable!

For some hardware, each pin has fixed function. And some hardware, each pin=
 could be programable for function.
The Ocelot PTP pin is programable, but initially the software author may pl=
an to set fixed function for each pin.
Do you suggest we make all pins function programable?

In include/soc/mscc/ocelot.h,
enum ocelot_clk_pins {
        ALT_PPS_PIN     =3D 1,
        EXT_CLK_PIN,
        ALT_LDST_PIN,
        TOD_ACC_PIN
};

BTW, current ptp clock code is embedded in ocelot.c.
More and more functions will be added in the future, and the interrupt impl=
ementation in SoC is different between Ocelot and VSC9959.
Do you think it's proper to separate common code as a single PTP driver?
Thanks.

>=20
> Thanks,
> Richard
