Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B112312BF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbgG1Tdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:33:51 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:28405
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729646AbgG1Tdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 15:33:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUZtL2TFp25IYi1B4PSn5sVd9H/oZRPKUk0bBVHuHStBu9hMcBWNkngjnc3W+ZzQyGz0HH0BQ4u9b/kirgNipLar4u0QcStutrzbMUI1KtY/YGujwKB3HwaNNN6MkZaVOpYcVHaSPCb1ZbiEeqF1EF7tVWxPV93Tx8aYBVSsOAJ6zhHKSOdqOIWhWjvrNIQ+bzay5V3HiD8ngmPg+FKubtyIhW0YRihdJpo266d8KbUfUMJc1NF9pvldvHNzceBIPKuPqH9AbkRfoZpHSzk+UN+zXLmpVfa85CDHZlDAmnvUASs8aRXX+5O03WiSBK8kpT1rzfRo9HqeLmpVc1+7aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NY9j726F5z5uXyQOL745lRI0gTGCzGStWpaNiJx6me0=;
 b=H8Rq/ZpIoyyJO0l3JsDTUNHrvtM4E1+uKlE/rxzqCrBotb8rdbnRrfAUMdawLXkJxVqd1Z5Y9mgnrMWXugnBy7G8Pw8Bz1MaNYgrB18YQWsnteSX/txuNkipzenTQlAdc3TsOlYd3al6Rw47uuKckpVVhd8UXae9bTqRS199czbwQeOBHOXrRE9CBWh4Sz1MLJHYDRbzFyu/iZIQ2c0+mCK8wEY4+lCfMZAzCsL+tszvti3jmMNPaL9pNFcO4SOTcMjORkSkt4EgvB6KtikADQ/FSb0W9W5pSwiX53Qw/kkM23PZrz+QuLrEVledGfx+77Jo3jSH8RmxzjvJrLOOIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NY9j726F5z5uXyQOL745lRI0gTGCzGStWpaNiJx6me0=;
 b=oiyEwLbHQz+ULhZEu0s4+ib9mCHXdrDDN8YJ/ptt0MzKvuXzHWFt56E1ffP5IJcuET40nKqxz6l/QjplEF939qHs2oojImiWlCh+GvIWqL+aUXG4AeNbOYlw2HxiVaG7GnZG36NeRIIRJawk0F8IV2QLOn7Vmv3wkdE1LF2KoWg=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB4511.eurprd04.prod.outlook.com
 (2603:10a6:803:74::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 19:33:46 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 19:33:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
Thread-Topic: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugfs
 stats
Thread-Index: AQHWZMQ/vSHK8kqdXUWr2Ggsrx/beKkdWgwAgAAHajA=
Date:   Tue, 28 Jul 2020 19:33:46 +0000
Message-ID: <VI1PR0402MB3871C269BF4C0C3EA7CF3B22E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200728094812.29002-1-ioana.ciornei@nxp.com>
 <20200728120334.28577106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728120334.28577106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.95.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0b0af5fc-1966-4a23-80d2-08d8332d256f
x-ms-traffictypediagnostic: VI1PR04MB4511:
x-microsoft-antispam-prvs: <VI1PR04MB4511042DEB2B2EE8ABBE03D7E0730@VI1PR04MB4511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x/vD+NClWXXVJkvw6UoHAbmjnHmSuG1fb28oZSkZvoy78z0fJLukjbQoBXjK7Nl4Zd7XkwyyKDJGYIm2JTeWs3gFSLwSgOBQ4WJ9fGAiZ1mD1PKO0VwbTXkCMwx7erAsFrkmXa8aPxm1cUMyxJ5TiKqiw3UusiyNuG7apqjugnOOACvnnEC3EYzrDeDVJ6+2Lt8IuA1/Yv9gUWmRqBgZXoQZLqYfQCubB3nMtiiu32ZGHpnA5cWdOGDU2Vykf53Rn682kXgU0UA+Xty8RzH9YC4PMHBvj4miGJRqIpO7L2uM1qNHKXijaBN8BLOJWCVjG/8FDLC2HqdYt/dQoROzlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(6506007)(7696005)(55016002)(8676002)(498600001)(33656002)(8936002)(44832011)(52536014)(83380400001)(4744005)(2906002)(5660300002)(4326008)(76116006)(54906003)(26005)(71200400001)(186003)(66476007)(66946007)(6916009)(66556008)(9686003)(86362001)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BD/lh+l2E5xYTMsvkS89cee6oxQi4QkTdd84Vg2bWSQ4lFTnJ8hfSplIoFIYkEuBwRoKTbJrzJNVnQkpDGRjJpsSbuSAzvAbGPzS0Bvpru77r035d/qS8dwOVqemHFQw/vqBCg7pblGhvjfFl7Kh8dclC5s5pofOLrHyQa4h8VPToYEy573NPk4TIrfJXc8Ab5a5+/aRw0jVAnVZxoAhGFAtcdYEmkhbOxFY1cPQjvT20zBX/f8XzUq2XiEGeXUFMEUVJFgduKdh6uOeoxRfp5PaSHc79v9o5Yqp1AV9EJzOi0gzPIUWbZYbHvoZKme3n0k0xCs1V6ps9IL3vWuOmZW3T+v6O3xevCXY3eVq64KkEZ9U9+Zeyo6iCA3k6wyspW9G6JRAaAJNQflY+9voWasmMqzmYKD4ZVNqGzSDPNQf7ZBuMDXP1Ye+fblGTTnd7/F9eztP4Ok0IRip5T4vWsrPNDQ3MI285J0hmY+0g28=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0af5fc-1966-4a23-80d2-08d8332d256f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 19:33:46.6575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FRNdvSQlWgpgU3WtwSPEvCNco7GWUL/yXi+0iJLIhNv3V/c5uyKBzRs47eRZwW35LGzAzOhkZc2xUhCqGiTaiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4511
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 0/2] dpaa2-eth: add reset control for debugf=
s stats
>=20
> On Tue, 28 Jul 2020 12:48:10 +0300 Ioana Ciornei wrote:
> > This patch set adds debugfs controls for clearing the software and
> > hardware kept counters.  This is especially useful in the context of
> > debugging when there is a need for statistics per a run of the test.
>=20
> No, come on, you know what we're going to say to a debugfs patch like thi=
s...
>=20

Eh, I figured it was worth a try since I saw that i40e also supports cleari=
ng
the stats through debugfs.

> Is there anything dpaa2-specific here?  We should be able to add a common=
 API
> for this.

No, there is nothing dpaa2-specific. The common API would be in the
'ethtool --reset' area or do you have anything other in mind?

Ioana
