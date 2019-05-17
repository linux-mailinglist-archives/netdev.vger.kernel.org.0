Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C6021C98
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbfEQRhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:37:08 -0400
Received: from mail-eopbgr50052.outbound.protection.outlook.com ([40.107.5.52]:47590
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728435AbfEQRhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 13:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syOdPAq77alf0HUSnVFK4c8S5hXkdncAXMeN3//5SJM=;
 b=KpjcdgRPyvqmJYVu+o1vk1CkvF653PcFWbKLU8oVTFIAv2NHwUAFiANN74zKGvuA0Tne1tzMCxzUx8cEFoNwKwFNWATZOzPx6pEJOchwHFlznmnmSXXOWvAX7TSNmb6mUHfoo/qIinUE/P7Y2ORGJ9yQ0dwW1nG+q+QMX06xYPM=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2863.eurprd04.prod.outlook.com (10.175.20.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Fri, 17 May 2019 17:37:00 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 17:37:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: dsa: using multi-gbps speeds on CPU port
Thread-Topic: dsa: using multi-gbps speeds on CPU port
Thread-Index: AQHVCxtHwkM2fCsHq0SrAIkT4cyjraZsLYqAgAAJ1wCAACOKAIADFDwAgAADH0A=
Date:   Fri, 17 May 2019 17:37:00 +0000
Message-ID: <VI1PR0402MB2800630F0E9CCBE6A3FBCFBEE00B0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20190515143936.524acd4e@bootlin.com>
        <20190515132701.GD23276@lunn.ch>
        <20190515160214.1aa5c7d9@bootlin.com>
        <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
 <20190517171038.36d921a5@bootlin.com>
In-Reply-To: <20190517171038.36d921a5@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43c3c4d6-a216-462f-f241-08d6daee444c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2863;
x-ms-traffictypediagnostic: VI1PR0402MB2863:
x-microsoft-antispam-prvs: <VI1PR0402MB286363BC4F80C165BA2DBB54E00B0@VI1PR0402MB2863.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(376002)(346002)(366004)(53754006)(51914003)(199004)(189003)(110136005)(478600001)(71190400001)(71200400001)(26005)(8676002)(6246003)(44832011)(81156014)(81166006)(53936002)(7696005)(256004)(68736007)(186003)(305945005)(486006)(6506007)(7736002)(76116006)(33656002)(102836004)(54906003)(14444005)(11346002)(446003)(476003)(99286004)(76176011)(5660300002)(2906002)(8936002)(64756008)(52536014)(74316002)(25786009)(6116002)(6436002)(66066001)(3846002)(86362001)(66476007)(66446008)(4326008)(14454004)(55016002)(66556008)(7416002)(229853002)(316002)(66946007)(73956011)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2863;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mVfMiq3GbpdsQeDgTpU09+vVp4JZZDK1izgooj1OZz6U9+Kggzetd71cjMEbvACy0Q9WWZ8eu1Ja26ahAFHAeFTiPU6guSyy63gvDypLa8ZA4SfVeVeikMyKFYLKjTyWj66N5a3PKIG/Woo7cVNSryE0Iot4N69Ebz5FjeauTVRjwfPk+vMEHTDKHB4irkMn83XUPMFLFP0xe5o0Cd0L4D3lq2w4s1/zdWZ9/ojvnJOClr3j5TDocijoTRJaz8AQTYqhbZTRVAfTNRors7pIBJIKaGjXTmET3Am+LSObmGehroySmDqjsexIalCTl0Ep2CRC5GIMQXW5SjsJgg20LNrbYzKkywdnQfF2Mfb8PNCT8NeNM/jAbyRvZAiST68SXzrAkzubuxWwmFlH/jATNC7LN4/nnseXHLASdXXf9og=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c3c4d6-a216-462f-f241-08d6daee444c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 17:37:00.1858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: dsa: using multi-gbps speeds on CPU port
>=20
> Hi everyone,
>=20
> On Wed, 15 May 2019 09:09:26 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
>=20
> >On 5/15/19 7:02 AM, Maxime Chevallier wrote:
> >> Hi Andrew,
> >>
> >> On Wed, 15 May 2019 15:27:01 +0200
> >> Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >>> I think you are getting your terminology wrong. 'master' is eth0 in
> >>> the example you gave above. CPU and DSA ports don't have netdev
> >>> structures, and so any PHY used with them is not corrected to a
> >>> netdev.
> >>
> >> Ah yes sorry, I'm still in the process of getting familiar with the
> >> internals of DSA :/
> >>
> >>>> I'll be happy to help on that, but before prototyping anything, I wa=
nted
> >>>> to have your thougts on this, and see if you had any plans.
> >>>
> >>> There are two different issues here.
> >>>
> >>> 1) Is using a fixed-link on a CPU or DSA port the right way to do thi=
s?
> >>> 2) Making fixed-link support > 1G.
> >>>
> >>> The reason i decided to use fixed-link on CPU and DSA ports is that
> >>> we already have all the code needed to configure a port, and an API
> >>> to do it, the adjust_link() callback. Things have moved on since
> >>> then, and we now have an additional API, .phylink_mac_config(). It
> >>> might be better to directly use that. If there is a max-speed
> >>> property, create a phylink_link_state structure, which has no
> >>> reference to a netdev, and pass it to .phylink_mac_config().
> >>>
> >>> It is just an idea, but maybe you could investigate if that would
> >>> work.
>=20
> I've quickly prototyped and tested this solution, and besides a few tweak=
s that
> are needed on the mv88e6xxx driver side, it works fine.
>=20
> I'll post an RFC with this shortly, so that you can see what it looks lik=
e.
>=20
> As Russell said, there wasn't anything needed on the master interface sid=
e.
>=20
> >
> >Vladimir mentioned a few weeks ago that he is considering adding
> >support for PHYLIB and PHYLINK to run without a net_device instance,
> >you two should probably coordinate with each other and make sure both
> >of your requirements (which are likely the same) get addressed.
>=20
> That would help a lot solving this issue indeed, I'll be happy to help on=
 that,
> thanks for the tip !
>=20
> Maxime
>=20

Hi Maxime,

I am currently maintaining some drivers for Freescale/NXP DPAA2 Ethernet. T=
his architecture has a management firmware that abstracts and simplifies th=
e hardware configuration into a so called object model. DPAA2 is a little t=
oo modular and you have the concept of a network interface object (DPNI) wh=
ich is completely self-contained and separate from the hardware port itself=
 (DPMAC). You can connect DPNIs to DPMACs but also DPNIs to one another. Th=
e dpaa2-eth driver conceptually handles a DPNI object. Among other things, =
the management firmware presents the link state information to the DPNI obj=
ect as abstract as possible (speed, duplex, up/down etc.). The firmware gat=
hers this information from whomever the DPNI is connected to. Since the fir=
mware can't reuse Linux PHY drivers due to incompatible licensing, we need =
another driver which acts as glue logic between the PHY drivers and the fir=
mware. This is the out-of-tree dpmac driver that notifies the firmware of a=
ny external PHY events. At the end of the day, the dpaa2-eth driver gets no=
tified of these external PHY events after the firmware itself is notified a=
nd raises an interrupt line.=20

To start the PHY state machine for a port, the dpmac driver must fabricate =
a netdevice which it does not register with the stack. One would, of course=
, suggest to move the PHY management directly into the dpaa2-eth driver. Bu=
t the firmware's ABI is already stable and besides, it is not desirable to =
grant MDIO access to users of the DPNI object.

Obviously, that fake netdevice has to go before the dpmac driver sees mainl=
ine. What you guys are proposing (the phylink/netdev decoupling) would also=
 benefit our scenario. I talked to Vladimir and we'll make sure that whatev=
er works for us is also benefiting the DSA cpu/cascade port. Hopefully we'l=
l have some patches early next week.

-Ioana
