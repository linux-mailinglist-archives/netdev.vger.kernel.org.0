Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FDA60245
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfGEIhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:37:36 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:61270
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGEIhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPcaAGJ4X+iPLVy927B87qubdMGEjpxSmplLmUS0M3E=;
 b=f7bfVwQN++Ul+7vq8CjjBx1lWhQ8nSLRa3+X4uc/HFL9AgwVM+4m2yoNLd0wozujo97ecYnMkMWLMYoPCjCEUddAPr2opmMWGtEN9/K2RGQuNscwoVRjKGCspZHRkORROhRmOgA/FkpC02vKR2FhoWXi64/6wVYGPIYFEqsn1XM=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.50.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Fri, 5 Jul 2019 08:37:30 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::58be:69bd:e0e1:342e]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::58be:69bd:e0e1:342e%7]) with mapi id 15.20.2052.010; Fri, 5 Jul 2019
 08:37:30 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Thread-Topic: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Thread-Index: AQHVKEeAhac7DL/j0Uy9JhFYnIZAmKamUhMAgARcasCAAAiGAIAAKgmAgAAQBICAABD7gIAAIgIAgBAMyYCAAFi8gIAAL0vQ
Date:   Fri, 5 Jul 2019 08:37:30 +0000
Message-ID: <VI1PR04MB4880DEA9D7836A68E0EE141396F50@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net> <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch> <20190624182614.GC5690@piout.net>
 <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com>
 <20190705044945.GA30115@lunn.ch>
In-Reply-To: <20190705044945.GA30115@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3090afa-38ec-4c09-865a-08d7012404bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5134;
x-ms-traffictypediagnostic: VI1PR04MB5134:
x-microsoft-antispam-prvs: <VI1PR04MB5134184E946FAAD920F9174196F50@VI1PR04MB5134.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(13464003)(189003)(199004)(478600001)(2906002)(99286004)(8936002)(53936002)(305945005)(6116002)(76176011)(3846002)(7696005)(5660300002)(52536014)(14454004)(66066001)(71190400001)(71200400001)(86362001)(66556008)(66446008)(73956011)(66476007)(66946007)(64756008)(229853002)(76116006)(14444005)(256004)(26005)(476003)(446003)(11346002)(6436002)(55016002)(25786009)(9686003)(186003)(33656002)(316002)(102836004)(7416002)(6506007)(110136005)(54906003)(68736007)(74316002)(8676002)(7736002)(6246003)(486006)(44832011)(4326008)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5134;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 28rB8POKL+SeXzddyc3bc7hV9QwkAKE9Rh5ieS40jugR3Ju3MNqjTSxaLW75ZDDLmOhue8/0e/gQ8aJF46d6cboHD0IzG7K63YWexYWMoTvn1pdSFQBxeQb5Md0mzfRzYGmjZfCijRmHv79NskTG4U6UqKeB2EygS0NJbB7bMoblEx2jtJ2fof8tjSAiKPCzkDom8Lr5Cn2qkM2gOp4Ar2vylSrmHycFg+3aczW6xyOHHbk+7GtmMZJ3Rr3Y/MIAzEhQUceOdK1n91D4kS7uITKunUCXsREUq1KSCkhaNm53s/32v0hESmaiYX8RVoIws9vBht8apca//AFIi4mgL85Vbf8OhZHY4g4rMp0VCAP1oKIrM2Sfy1uLqpvYhVJFJAOXA7d2R5CmayZdP03cl+FkEGybEgY+OJW6ij6+yzI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3090afa-38ec-4c09-865a-08d7012404bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 08:37:30.4944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Friday, July 5, 2019 7:50 AM
>To: Vladimir Oltean <olteanv@gmail.com>
>Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>; Allan W. Nielsen
><allan.nielsen@microchip.com>; Claudiu Manoil <claudiu.manoil@nxp.com>;
>David S . Miller <davem@davemloft.net>; devicetree@vger.kernel.org;
>netdev@vger.kernel.org; Alexandru Marginean
><alexandru.marginean@nxp.com>; linux-kernel@vger.kernel.org;
>UNGLinuxDriver@microchip.com; Allan Nielsen
><Allan.Nielsen@microsemi.com>; Rob Herring <robh+dt@kernel.org>; linux-
>arm-kernel@lists.infradead.org
>Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix swit=
ch port
>DT node
>
>Hi Vladimir
>
>> - DSA is typically used for discrete switches, switchdev is typically
>> used for embedded ones.
>
>Typically DSA is for discrete switches, but not exclusively. The
>b53/SF2 is embedded in a number of Broadcom SoCs. So this is no
>different to Ocelot, except ARM vs MIPS. Also, i would disagree that
>switchdev is used for embedded ones. Mellonex devices are discrete, on
>a PCIe bus. I believe Netronome devices are also discrete PCIe
>devices. In fact, i think ocelot is the only embedded switchdev
>switch.
>
>So embedded vs discrete plays no role here at all.
>
>> - The D in DSA is for cascaded switches. Apart from the absence of
>> such a "Ocelot SoC" driver (which maybe can be written, I don't know),
>> I think the switching core itself has some fundamental limitations
>> that make a DSA implementation questionable:
>
>There is no requirement to implement D in DSA. In fact, only Marvell
>does. None of the other switches do. And you will also find that most
>boards with a Marvell switch use a single device. D in DSA is totally
>optional. In fact, DSA is built from the ground up that nearly
>everything is optional. Take a look at mv88e6060, as an example. It
>implements nearly nothing. It cannot even offload a bridge to the
>switch.
>

Nice discussion, again, but there's a missing point that has not been
brought up yet.  We actually intend to support the following hardware
configuration: a single PCI device consisting of the Microsemi's switch cor=
e
and our DMA rings.
The hardware supports this configuration into a single PCI function (PF),=20
with a unique PCI function id (0xe111), so that the same driver has access =
to=20
both switch registers and DMA rings connected to the CPU port.  This device
would qualify  as a  switchdev device, and we can simply reuse the existing
ocelot code for the switch core part.  The initial patch set was the first =
step in
supporting the switch core on our platform, we just need to add the support
for the DMA rings part, to make it a complete switchdev solution.

Thanks,
Claudiu

