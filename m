Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 857CFEF2EA
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbfKEBky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:40:54 -0500
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:6288
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728602AbfKEBky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 20:40:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMqMfBmV3Up79AJMYwoVPkHsik+JJedCp9DFFAQys5d1hOOGbbqHX04Ebtq59AByY+pp6BXNfO9D+3V5S6MkTEp+q5q/sUt5B3QaeAwR+tMkQImvFX/xAoWwyNhIH6Ji4luK500kmqhUcRQKP1ZU2SFO35OlT8UwKLyQqCFFgw2/9947oMfEZXGZA+iZamvh+WFjmBUlYNF6i8Z2DDvKUPgIH1Ix+h0YaUZAXJXnAnNa2b4rXMf6BAbod5XmzDv4nef5UiyLhHa7MO1wheOOfRq3ggLYTnui1J0UtBTGpPQ85qV4zR6tDZA5+pp4Tz+X+fI/ClJn+K4ql5M3+m2UpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYrTLeQWd6CEQh1V720zCtNHcWVjKmnfPxEMIHn+I3o=;
 b=ZlBGIWrHz/+R7r/1ro+Vhitp+1CFqQl4Lfk6snfFyZnf05fJvA7SaSCgukrBVD7BXUnmis/uJ90yGJ1aHkHJs86Ux8J2p5DQfe1j3M+T5/rbmgSh3Cme3lLAV03hi1vLTuxfrqPPBlpO0EBWS1Cctw3TJ975b2pM1a8esXQuxNLVKm2hoK2W6JtpxvXqoNpE5MYs9tHHzGb9IWjg4EacKcZjENI1JjwLr9UN3j42gZWkqsB10E+X0xUn8kMucMk7TH4OdHgr2yUwWi+b4nHVo0Y46ecGOT8ipiqcWVkvlBP6O87aQXibp/1xBEiSBGfgVTckfaUd8JJAisW8ZAQf6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYrTLeQWd6CEQh1V720zCtNHcWVjKmnfPxEMIHn+I3o=;
 b=cfkzhM0pqTnv0w0B8JrMKtxX1zYmZYg623ryiSPLgXUm4ON3a7b7DEdVf6Og79vwvK+wNK4nn/Is1RX6880izg54gZ0/nQ+uq2cogfhApH3/ftLLxk1/b5CxSx3ukPTcLE8Bygm4XBx04Tv+hB280zvX6zPXc/rAVVacQ6Cdmw8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3664.eurprd04.prod.outlook.com (52.134.15.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:40:51 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:40:51 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "hslester96@gmail.com" <hslester96@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Topic: [EXT] Re: [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Index: AQHVk0caR3l97muk7USTxO6JUo1aF6d7yY3AgAABpwCAAAEUEA==
Date:   Tue, 5 Nov 2019 01:40:51 +0000
Message-ID: <VI1PR0402MB3600C0D0D04B7EC2692A3365FF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191104155000.8993-1-hslester96@gmail.com>
        <20191104.113601.407489006150341765.davem@davemloft.net>
        <VI1PR0402MB360095D673E33032706C5BEAFF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <20191104.173226.388214102826562799.davem@davemloft.net>
In-Reply-To: <20191104.173226.388214102826562799.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 085a7af3-095e-43ba-93f2-08d7619130f5
x-ms-traffictypediagnostic: VI1PR0402MB3664:
x-microsoft-antispam-prvs: <VI1PR0402MB366427763AFC19B4BD64FA3AFF7E0@VI1PR0402MB3664.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(199004)(189003)(186003)(6246003)(7696005)(256004)(26005)(8936002)(4326008)(81166006)(81156014)(6506007)(25786009)(54906003)(99286004)(6116002)(2906002)(3846002)(71200400001)(71190400001)(64756008)(76116006)(66946007)(66556008)(66446008)(52536014)(5660300002)(66476007)(102836004)(55016002)(33656002)(9686003)(86362001)(14454004)(4744005)(6916009)(76176011)(7736002)(305945005)(74316002)(229853002)(476003)(316002)(486006)(478600001)(8676002)(6436002)(446003)(11346002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3664;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F5JnpqS85hATwF3V05LLWtIbp63H/Od84Iz0pYeiuOR9/L5VbsaBbYMn3GqX1NSJhbZnXTLiEHVLh9lVSTU0HHQAQDQslTN6fY2qrHG5/ObkGpzhCV/oP54NzMD8ZVsqRusxfdeD+Po22cCPFKtPrnBY3HYdIf0690HG+AYFqsKmSWzIfg51frGIq8X5rp4rQhVeIr/6PsiWNe2niHeBpY1Xoof33ZJYg+ZySwUux5paH3kmVl6Mxcee6yTpK0So6v+SyUOmqdwX9HQRa3eNQJfNS/XU9xLdvdSnAXLru+Jh4CRAt/JlTdeSf5M1zybjmlZWsxqaJdLxVgHJRxv+UC40hTy412Mn1j6uCEPCB1tnSK11xdl9irFWJknIgDxuzp5/JdzUA4WeyB1Xv6WAm8EK55SFQCDNlaRiyYY0FYuC7V+5fP83nH7w1HpxR4nh
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085a7af3-095e-43ba-93f2-08d7619130f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:40:51.4368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VopSrSDyDHqSRNmglZoqlRwKXLr2nmWU/x2FbT9MQ2/0ZSKAMb/k97EJ8puO++301pE1QQpHCB9ihy4qz46URw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3664
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Tuesday, November 5, 2019 9:=
32 AM
> From: Andy Duan <fugang.duan@nxp.com>
> Date: Tue, 5 Nov 2019 01:27:10 +0000
>=20
> > From: David Miller <davem@davemloft.net> Sent: Tuesday, November 5,
> 2019 3:36 AM
> >> From: Chuhong Yuan <hslester96@gmail.com>
> >> Date: Mon,  4 Nov 2019 23:50:00 +0800
> >>
> >> > This driver forgets to disable and unprepare clks when remove.
> >> > Add calls to clk_disable_unprepare to fix it.
> >> >
> >> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> >>
> >> Applied.
> >
> > David, the patch introduces clock count mismatch issue, please drop it.
>=20
> Please send me a revert, I'm backlogged at the moment.
>=20
> Thanks.

I already give comment to Chuhong Yuan,  let's wait his response.
If he will send the fixes, let's wait his patch. If not, I will send the a
revert these two days.

Regards,
Andy =20
