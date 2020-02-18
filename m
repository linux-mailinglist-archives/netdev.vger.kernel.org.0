Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DD8162125
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 07:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgBRGvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 01:51:15 -0500
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:48867
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbgBRGvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 01:51:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk/utZWk+BcAgR3tHTlVcNHGc/AUZfafRZKienMp9zqEAl2xFlBv4+Q23PlcRwOpQSA0BtieT3/pHc13InhQzMCf2pTSf8cmClZLVCNH8oY297gkXt7czmKs11DqZHbTzH2PhbD7ziMhhoo02AhIO1pT4soWunrXj6UbGLVP0uoKSCjPZKjkt6MSVBqm8+++hYAQXfMez+7VNyK+JVNzlLp0g6MjqRbWUHE/9meffywHPB7a0vqVY6Z1gnGSImnMKvtCkHvLkYUUr+SxdQ3k70HUo62s23mvnCf1oA4PA7E9/vJJDT5xTHbeD6ZHpUgf8bjRCuBY9nV51/YeBP6jVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt7MsMz23uG4V/aaFpAdJzjJGbm+oP6vxZ9ibW/qrqE=;
 b=djib7rsm+jHZcfq3Mqv6CujGocagX3LBqQFu3eosYTatHQlRwFmW3KL+Mx9g/XNt/hkeClt6MhOjemW0vSA+4tw52WSOyyYeVtZQL5p6djXDhh6UzqZ1FZu4p+roSrdgSV8my/r6mhPwUff7qvS+WXumCeSz+MhPNo88A2O5FlPiGjSXhBxSUeTS/EuII6zf5yGesMciGtTrXCSgp/yy62wLwFFXLZJ4M1Yd1Ir0Qrb1KxvxWZOiZmoJbgZ1ip35FpoTzsqfi1WsS/T/sl7GZH0Grzm8TEvQcLom1SwhBw3zpHIrTVQFcayIafqvfZphUXDFLBlJdr/C0fWph1tdyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt7MsMz23uG4V/aaFpAdJzjJGbm+oP6vxZ9ibW/qrqE=;
 b=IWEr2dWq+8IQ4QN2GSj1HWeMoAgxinVb83DRcBR4h43FSp5QR2920eswa628A7Il8v/DrFwiDOz4g6jnMMNJ40mPFecb2GTuFenyNTWFZBWHoGaqEV0pan3AYIIg/7m9ng2vVH6AbfYk9nPAhXrBPuF1jrcQIk63jSqUfs6cLy4=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3407.eurprd04.prod.outlook.com (52.134.2.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 06:51:11 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 06:51:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "festevam@gmail.com" <festevam@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation
 scheme
Thread-Topic: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation
 scheme
Thread-Index: AQHV5h8UIR0p36NlJkiaMX6HnulgEKgggl2A
Date:   Tue, 18 Feb 2020 06:51:11 +0000
Message-ID: <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200217223651.22688-1-festevam@gmail.com>
 <20200217.214840.486235315714211732.davem@davemloft.net>
In-Reply-To: <20200217.214840.486235315714211732.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d880e717-5239-41e1-22aa-08d7b43ef0ec
x-ms-traffictypediagnostic: VI1PR0402MB3407:
x-microsoft-antispam-prvs: <VI1PR0402MB3407D355E0EFDBA85C275A6DFF110@VI1PR0402MB3407.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(189003)(199004)(9686003)(55016002)(7696005)(71200400001)(2906002)(478600001)(4744005)(86362001)(4326008)(110136005)(52536014)(54906003)(8936002)(8676002)(33656002)(66476007)(66946007)(76116006)(316002)(26005)(81156014)(81166006)(186003)(66556008)(66446008)(64756008)(5660300002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3407;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B0SDdzzjl1el+l5R6v+I8FkozTRjIAMg3dhQHNL3QoFlCYH+9FjmPVv7dIQeaO15ETTANgVQ2MVBEd+6d5b3kse5F5Fo91p1I1SoYq/ErX38UZJusfiOwGP75FO/txjPLt4qP58s+cpcssm76Xrs6EDsE036fgFyvY0Ol5Qyzux8KKcB0mhL6LXE3ZmsHFNnypFg9OiFEP+KloqQZBM3jAxoM+5KJHGFJGa9UsHKnpKR6+OxWQyTK1NQh4XW/Jut8DO3Kbm8kKqhyQ7VVkQbLxNRLA7NVf6GidFZswQ2YZuQ3v/i4I/sr3vZ/3B0HtJ9tCkl1QkXmpDozYurcL4kwLE1uvj/t7J1OpIQvMQhmyF3eMNWKOKXYD0PShRV3SUv4e3U80tnPF9rc/JLNdnvZQ4IMIobAGVfSOMS38J8MUEcczoV0SqoTvASudPyfrhb
x-ms-exchange-antispam-messagedata: TOEMKUUDhTNi+bmxsOw/Hat3DySfZWjc/l7v7KVMnp02h6pcM4VoKezSJPp38LGb8W1b1BnmtGzaOAjNpMr/Tm9WrmFi/Uqt+uJlUdkonufQWxtu0Oo0UUBrWFaABb9T27t+ruP1cA4r1RAQ/uhDYg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d880e717-5239-41e1-22aa-08d7b43ef0ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 06:51:11.8574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bLfkzjZ3lr00hY50uDijFnJx30/pJJISx4P6uuMf1ebDsqJjUV0Rrf2jAtZZpFJPjr4VHKfR5tgsOAX7m2Slzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Tuesday, February 18, 2020 1=
:49 PM
> From: Fabio Estevam <festevam@gmail.com>
> Date: Mon, 17 Feb 2020 19:36:51 -0300
>=20
> > Instead of using such poor mechanism for counting the network
> > interfaces IDs, use a proper allocation scheme, such as IDR.
> >
> > This fixes the network behavior after unbind/bind.
>=20
> What about:
>=20
> 1) unbind fec0
> 2) unbind fec1
> 3) bind fec0
>=20
> It doesn't work even with the IDR scheme.

Not only such case, instance#A (maybe fec0 or fec1) depends on instance#B (=
maybe fec1 or fec0),
Unbind instance#B firstly has problem.
Bind instance#A firstly also has problem.
