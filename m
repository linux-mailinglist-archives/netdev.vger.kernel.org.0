Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20611BD1EB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgD2Bzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:55:39 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:42422
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgD2Bzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 21:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Os21KJ7MgWd+23BbWqK/ZHtkHq88pNS7pgghGdRvowZkCTGidsqXkWjDnRL0J6+E+gKxMWH+b5CLVnLZDonVdg1onV/d3bSFKrlOBtdWqG/FOThoK6RgV3UESCCnDRoCDJndL/PrKn1F7Me25Edx8IsyT74OUmMt1nowiIZlI9IrFpnQdK+Cnrl5KXKaIrtU0XgJg7WDCbxcvqEHj2ozOdAuJEQu0UnglkhJEPUsCP8F87TnVuSgJjK2AeW8yCpNVGYzwHcgIHW6oaubRZH1kHY0BRx4Y6UsGkpUCaA9McylXF/Gfk8nt3XYqQej/KRcfh9e+6Jss18jbATlIKXyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJQtiD0BUrqINZ57FTLz/Ye4O3cpGuMuV8vUwVJfges=;
 b=egtiWprfk/Xpi7wkhFO9O7mjDPJ5GuySYCuJzNWeSNPgpkN5B/U469d25gc/0LbT2xto3ocQhdC1l+dJHxIw2r4IheAjuClk6lAaQXpL9qYiGykjwKpENNBLWi6XT2A9CcXoPoCcq9xh+D45vc9UnzNVfa74Xc+uURXjWn88PRhkM7OSWHF/fLWaiZQRh5tLuOb9UoOMt9SxvBa72roqwqgDxKs71Yy5Z2NfWyLVSturF2rtlnu2igjzxNeWxI3lD4IOs4ttIGtIcpv5N+OBhvIWLValNygQ0DDamWa66yomvrZOBG+PToNIYGqiG3ANEYwo10ilN52Tb6Qj1kIt1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJQtiD0BUrqINZ57FTLz/Ye4O3cpGuMuV8vUwVJfges=;
 b=TqsBUEk1zy5latMAvdrG0btIQpY73TcFtwEhvPgluCjvZ9MgdUVn4hlbf8dRTRz73HwP3idpWVZOulz9tweO3BkkPobZ7tIS4rBZ39Fk0l+HZ7JIY7Uc1MwLgQ5BvWAnYkzcSy1cT+KXKv+xVH2SS2/iU3Wij27Yb/DVpvqhI8g=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB3355.eurprd04.prod.outlook.com (2603:10a6:7:81::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 01:55:35 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.023; Wed, 29 Apr
 2020 01:55:35 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Topic: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Index: AQHWHaSxKxjYdl/WNkuZX+80YiGqOKiPVsMg
Date:   Wed, 29 Apr 2020 01:55:35 +0000
Message-ID: <HE1PR0402MB2745408F4000C8B2C119B9EDFFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200428175833.30517-1-andrew@lunn.ch>
 <20200428.143339.1189475969435668035.davem@davemloft.net>
In-Reply-To: <20200428.143339.1189475969435668035.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd5dfb6d-b9ad-4c79-6e8b-08d7ebe068a6
x-ms-traffictypediagnostic: HE1PR0402MB3355:|HE1PR0402MB3355:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB3355B6E7AB36C7AD104492CAFFAD0@HE1PR0402MB3355.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(186003)(478600001)(9686003)(8676002)(110136005)(5660300002)(33656002)(71200400001)(6506007)(76116006)(54906003)(316002)(2906002)(66946007)(55016002)(66446008)(66476007)(64756008)(8936002)(66556008)(26005)(86362001)(52536014)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2iDD/ty1t1qoAtB1so7wNkSeM/BfuaGERjoK3LdgYkC5YBQ2xMiElPhbFpjmAIBS/IOTJ9tS3ydhd6TYwOiH2PCgHwU63zwtifEBujaxRsGYQuVXyU96HtftasL++xrxTmj2bbhRlUWtkQphhEro6OZaJANacXZitgz8U1TeRTiqnobznZ5nY1jM85+bTnv5k+8OkynwH/RkXaonSXsiJz+vbMiMEk5NMQ93yzOxF7wdvAXfNiCO0aUZCZh5xg9akf6V/C/7GjNZZsa0rBicVqdWKdnrYg+SFYpIZ9K1QmLN7xGqCG3cTvRHiSp+fV3y6W/+hBq99iBZG1NZYbARpo9+G5NPY8eOJp6atLxN7ogBjC+QU0QQJlT5h1UaanulEtgHEq5IsQ8LZ0RIJOZivFbiBprfoxpdelzpOWlqBdKkIVcGNkGs1/1JdRKpTY88
x-ms-exchange-antispam-messagedata: u1FTTrakSNgW/D8rTtCrQV5VUnh3i5Pl+EQiR1x8+OHeTjpu1w//2MHWBTYemRbyc0dhTTG4nh/69ws5e6+QUe4/iCi/G4zBd50y1Dqole0CtT9TobnbJhukrohubrH4FlXxwkE+Q8Rahxyho5SbEs38S4HLd0RhB4Rq0xUZZU9bA8f5r/SspC3aVpAX9C5107wWDtSODpJTReSOAMqX2fUJFRGJc0NXSHjc48/Z3y1/Rvli5upfNVH6SHvslQdHvii09p166/9ITohWV5uTsgEs1J7XVM5GZI3DfNG7IjuJ87V/oLumAJ8THodxnbBY0mi4HnohK/yDhq/Uw5pAUFuJ28D/hYw6r4SgAScJ3sI1uuaa17P0jDmPRbNvNMOHOPr16Zm+7ymSy8EaupH+8WdYY+50iZlpYsOG6+OEVB90ybgC4iNZ5sR9ia4x2YqoC++pACgMDcEv8x9s57FVHlGNvKLNG7wKOxcECn5bndOwGCFS583vfsKLbXlZmSnMB8DB861s2ZX7GS3nMMymLLQtl9hLvIY21mdnUppFKpkTGubtMo9G9v9Fysa0z7qbIQ6FPnEP8oyMrR3PJDGca9EeDEHZDswbU69oD8dWCWNgbotKSWwLZkCMoJo5tdOZKsxIabUgS8k6Ty8d5sUhXNHoB5gOMiK4UyruPcnrIVW+SYkGF5/8JofZLgEzstxvIB9y8PtbZT7hR8vlqfTW+9lYLCIq0aFG8msSSzgi/C8jo7XzH+df3Duqz+1NMHxKoo7c7JQK2AcBE/ZWwl30u+1/vFUG/JoGuksDcea67oE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5dfb6d-b9ad-4c79-6e8b-08d7ebe068a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 01:55:35.5774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXztiOec1OwjiGO06wLxhwqCK9Ytzae6hrjDl838/uAQ/o21A7b5aESq0/H4n7fcGBwWl/yjCSMuvK5BoNiIQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3355
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Wednesday, April 29, 2020 5:=
34 AM
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue, 28 Apr 2020 19:58:33 +0200
>=20
> > The change to polled IO for MDIO completion assumes that MII events
> > are only generated for MDIO transactions. However on some SoCs writing
> > to the MII_SPEED register can also trigger an MII event. As a result,
> > the next MDIO read has a pending MII event, and immediately reads the
> > data registers before it contains useful data. When the read does
> > complete, another MII event is posted, which results in the next read
> > also going wrong, and the cycle continues.
> >
> > By writing 0 to the MII_DATA register before writing to the speed
> > register, this MII event for the MII_SPEED is suppressed, and polled
> > IO works as expected.
> >
> > Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven
> > MDIO with polled IO")
> > Reported-by: Andy Duan <fugang.duan@nxp.com>
> > Suggested-by: Andy Duan <fugang.duan@nxp.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>=20
> Applied to net-next, thanks.

David, it is too early to apply the patch, it will introduce another
break issue as I explain in previous mail for the patch.
