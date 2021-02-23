Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F374F322615
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 07:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhBWGzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 01:55:53 -0500
Received: from mail-eopbgr10112.outbound.protection.outlook.com ([40.107.1.112]:56116
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230198AbhBWGzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 01:55:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CimJ9zrHZh1kNCGK07B1gGAgLJjy/ChKHtWNJxA06LWxZmDY8MropihasI3eZf4DhIdYHcG2/K+L50NS8zL/Je7bjA39EXFwtWHSpEkTKeOgEAbpkaM4asMoFIYpqXdYLb604YVbLgrDTiQi66u4j3sMK6PdEvxBZweQObHl/3BE6jg+wOzy+SjP46lnJctXvVFDzy6VZEjYko7+uBQrl+TvmyoaM6GmHXyBpL9e6wCT4EMdg8Xl7dOWwFoVuy0o8u1AsEvNwhkRMmG1W8UpWgGVZfZbzO8O5nVUvaMTB/znNk1ZQJ5moii6nsH2ffqxo7JgCT1fWHvx+NsERPW8gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJcrqkB6+TMss7RptIMOny/WtYUUo5EUn+Uqz36ql3s=;
 b=gKpzXGPU4tse1BhWSAQFvtXVq8enb8itXj77pDD5T8IeVRocBHLaM3PO9qCzL3jXCVWDOKk0KB1Tjf/hjQihN1an9Mjzn8J8YhDPBDuptGZ6MY6KHrAtoU75pJCatz3b6UAPaXd/HNs1C3hS/4u6sFw4gLBbWhTazf6Z9e3o4im0stfRdiFTiaHaHwpOgQAu7sG7SvVW1F6xWs9AWqfVxn/kIMGKMYpspPXq2AmOo5rjC299zafJj2Lrn4EnkkEN1fY+n0IwLnk3oYXnJ5PFTl/pgvNxAkJ9z/l+omzzq48Lgyyst4QhftGAySK0qiGBecsZPzlGvvksL9sl94WZqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJcrqkB6+TMss7RptIMOny/WtYUUo5EUn+Uqz36ql3s=;
 b=Dqb5Yhjjt5QBalPItXmpCu2Y2TiBCaq1QXwuF0n3gx3osib7PAeZabF2AKyKqm5XR1l+5kcIx5PI7ZgoVPCqBieRtmYjMo2g49NubLbZRv01hRXNjToSLAnq2BtHk+ounmvv3w3n3i5WPSY+VSWmAzkyo/LS8I5k1kdA/0Mxgec=
Received: from DB8P190MB0634.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12d::21)
 by DBAP190MB0902.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 06:54:57 +0000
Received: from DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
 ([fe80::64eb:97b0:de3c:4c5d]) by DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
 ([fe80::64eb:97b0:de3c:4c5d%6]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 06:54:57 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: usb: lan78xx: Problem with ERR_STS
Thread-Topic: usb: lan78xx: Problem with ERR_STS
Thread-Index: AdcJrhKONSKkWKe5RJ+Y9nQA4FSDGA==
Date:   Tue, 23 Feb 2021 06:54:57 +0000
Message-ID: <DB8P190MB0634AA6DFAEAD1D235F6AD7FD9809@DB8P190MB0634.EURP190.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=schleissheimer.de;
x-originating-ip: [62.153.209.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5212d38f-5bbf-413e-4687-08d8d7c7ee88
x-ms-traffictypediagnostic: DBAP190MB0902:
x-microsoft-antispam-prvs: <DBAP190MB09028D99F4ECCBAE60E37FAAD9809@DBAP190MB0902.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BZCt3Wh3TjX8LxeTtm427ATvEE7XQBCcLFuGgzOF0Y8LcpQritde7Esq8z8RYIaDpelo2vFYZChMLf64ma1ywQ1hbzEVusWOrGsYH+DYtQ/g+fSuxL0P9bSWek2JRdXPylRwcULtGvhfbd6kkxLXKM2+xnCbOhLYPSadmSbg8B/26Gp2C0gJ6C8mEhUG/ANgRohIKg4DwBtIfgDmBGdQUqnGSe6VIcWyUMwwPrVMrR/WHZQAXzTnfws/LEb/3LQ6cP433Pu9LBZyGgCsv1OFXvGE6CkiADRR3qOMZoeDpzzaH2YT3qGbkO5ablo7N6J7K4v1bV0sM8VAJdoah8zUEpMojkyvVaTSF8eT36EC5xSkQ8f/tBwIA6pHPlyACgrHXcguSXzwJzjT9dzRHZPlhzHb/MV5G1SDCfPiSnHzA0owCisjG3+FO4wzSaln+XTpaK7gzdWIn95crrMJ1dRi1YmhUWfUN35Ne07tnj4UU7FosD9uxjHxsbLjJcjecuv5rDnoynxRsZQTFrrDgTZrOAyIk+zV3XZef2QujM1rP6SeqE98WCLlUzC58MnCtU+s3mbzU57LUzW+CMTX+UzqIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8P190MB0634.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(39830400003)(376002)(366004)(26005)(66574015)(316002)(7696005)(33656002)(5660300002)(66946007)(186003)(66556008)(64756008)(66476007)(66446008)(9686003)(478600001)(86362001)(76116006)(55016002)(110136005)(8936002)(83380400001)(6506007)(8676002)(71200400001)(966005)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?+W1UJEcRIAG6PYjOd5yAS0S7INrZVm8ACajMKrGuA1B5oqR6uEEbGchwFT?=
 =?iso-8859-1?Q?sNZBqkmuKiGwJt28YZmkRwY5ZZTzUmI4Age3Hd54W3qyWBKc9s53SIQqfM?=
 =?iso-8859-1?Q?sBLLyX8Cby6HwLvuCx6Kh98I+UyXqPFZobqf4hoL/IcSBBuABeu+0dKssL?=
 =?iso-8859-1?Q?CePXfzJ4sJT7kEEqH3ePKGCi3TOQesahLBMs/KVhMigd1bAgj7x4P3rMzz?=
 =?iso-8859-1?Q?EaSZJBzA/qj0vhGUwh+V5S+GJewlBsU5eLWtrNJKLH4sg01owzBwWYQP4x?=
 =?iso-8859-1?Q?rFmY98bdF5x2VSAm+qVTOuchLorS/5G7/LR03Bo6COurNzaK0dTZK1sT7j?=
 =?iso-8859-1?Q?gs9mTd1iWW2kLr5mQv3GOumEPphZn+j1rvWRmcv7HVHEhIblPL3pi7nTYj?=
 =?iso-8859-1?Q?ai1Wpj2pujCaYV6S1FIMQY/qpGeANy2rL1FBbwedQtzHP4680BbQY7vgcg?=
 =?iso-8859-1?Q?2sPXXB+u9pTURb5lLJW6HZ0CTvvitKEK4TnxBCEgFfXiNbCcmbvFeZoNjY?=
 =?iso-8859-1?Q?xmxoqoq+O8JD9JKDMtIi/cZksohNLzdPWtw8ORUqi0mp9H4CQhp68Drgdu?=
 =?iso-8859-1?Q?Td/OtWuJadu7HrPO6IaoSxAjJdj7wBY0NbTMSA97PRwUWQolMwAeTv2AX0?=
 =?iso-8859-1?Q?NnoKugMDMid6ysKGYdS4ajgyGQ8vQJaxzuLS55jNrfWDCVbG+rAtausfL0?=
 =?iso-8859-1?Q?qkbCemNr0+fEmaAUo76BojHKvUoH/aJAAuOb2E5b2WMELXTwti8JzBUW8b?=
 =?iso-8859-1?Q?eedr0r9kUFLuKSyfhu495D/yEfNHR/4CRwTmpjfs7fL95HTl2H0Qgl5OGE?=
 =?iso-8859-1?Q?uH/naSb6v5FKjO7V+jLnXFBUmKvGG8aXFVL5FU75IKisDvf9qGLBZYOWJ3?=
 =?iso-8859-1?Q?4J+2qVzgjF1yTGI3WQKLqH7S+/ai9ESnN/iexn3yQSkhXoy7wDD9jBxGJf?=
 =?iso-8859-1?Q?cdObSEcIEDm4R9hxSVDEOVG6f/IlodbCGBAMmU7ime3YMQaW8M12KA7o+F?=
 =?iso-8859-1?Q?qUxXGfCGk1R1pkLEclCjRfMDdlWoPoWPmz2V2yOGk4OiBnC0nExbCB3+xY?=
 =?iso-8859-1?Q?311p4liSvBAPax9x/fRCF564tQMwPlG7NAgkc5G1GARgkLnDfStZZsptP3?=
 =?iso-8859-1?Q?5qZM0e7AZj2PRujO57PdyXIb5muohx/TcOW9VESTyfVhebyAhZEezXSTMO?=
 =?iso-8859-1?Q?EBYz9p8d4+uvJryTqLqC8Rtt7OEtVl+Kw1Rbm1DrebS41xSCIOWoImVlTU?=
 =?iso-8859-1?Q?8yFJZ/DQpMcd4nHIG32gumt4vPXhtSEMXmAghuoZPeVWS9bAG5nvsnUyyN?=
 =?iso-8859-1?Q?ME4ky8jEFLOWZS7h1UUyUXBpbpQfmQ9v11kZMr1EAfP5b0gxJjxSh54doy?=
 =?iso-8859-1?Q?agvtOWJjTq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5212d38f-5bbf-413e-4687-08d8d7c7ee88
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 06:54:57.2610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ku7sYeqypoBIsvginkThROdjzPYs6OD2QBsmtkwg0VclQLXW32MFg94adSj0+z6vtJAwf1xyTXNnVkbmgcfwp59hUfxRP8L6JOAxM2P/oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0902
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am currently working on a project where we use a LAN7801
together with a DP83TC811R phy. The Problem is that if we change
link state of the phy to down and up again the LAN7801 is
not receiving anything anymore, while sending still works.

I already discussed this on the TI Forums
https://e2e.ti.com/support/interface/f/138/t/977492
but I still have no solution.

I placed the following code into lan78xx_link_status_change():

	ret =3D lan78xx_read_reg(dev, INT_STS, &buf);
	if (unlikely(ret < 0))
		return;

	if (buf & INT_STS_MAC_ERR_) {
		ret =3D lan78xx_read_reg(dev, ERR_STS, &buf);
		if (unlikely(ret < 0))
			return;

                netdev_err(dev->net, "MAC Error Interrupt, ERR_STS: 0x%08x\=
n", buf);

                ret =3D lan78xx_write_reg(dev, ERR_STS, 0x3FC);
                if (unlikely(ret < 0))
                        return;

                ret =3D lan78xx_write_reg(dev, INT_STS, INT_STS_MAC_ERR_);
                if (unlikely(ret < 0))
                        return;
	}


If the Link of the phy is going down I see the following output:

[  151.374983] lan78xx 1-1.4:1.0 broadr0: MAC Error Interrupt, ERR_STS: 0x0=
0000308

So the lan7801 seems to detect an INT_STS_MAC_ERR error (where the contents=
 of=20
ERR_STS are not always the same). The Problem is now that the lan7801 does =
not=20
receive anything from the phy anymore, whereas the phy sends valid data on =
RGMII=20
if it goes up again. Strangely it is still possible to send data from lan78=
01,=20
e.g. echo requests are still on the line, but response is not received.
The only way I can recover this state is unload/load the lan78xx driver.

Does anyone know how to recover the lan7801 to receive data again?
Any ideas in which registers/functions to look why rx is not working anymor=
e?

Best Regards,


   Sven


Sven Schuchmann
Schlei=DFheimer Soft- und
Hardwareentwicklung GmbH
Am Kalkofen 10
61206 Nieder-W=F6llstadt
GERMANY
Phone: +49 6034 9148 711
Fax: +49 6034 9148 91
Email: schuchmann@schleissheimer.de

Court of Registration: Amtsgericht Friedberg
Registration Number: HRB 1581
Management Board:
Hans-Joachim Schlei=DFheimer
Christine Schlei=DFheimer

