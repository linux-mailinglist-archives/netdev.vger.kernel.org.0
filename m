Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7509728F11
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 04:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfEXCUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 22:20:18 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:17421
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731722AbfEXCUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 22:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fx8velWyfeej5f/270jyntWlGJK+7WjPzSWgGLuBUl8=;
 b=EnzLLyj6rW4X56hEQJRwCvD0FhiKBNVcDPCN55jcCNpnIvBG54JY9d/niY3cZ64TMUOFe4VVAeUfVS8VZaVbomrd9D+rkvSYqt03/7J370SmUsf7yJDT8B4S0aDBPCh8oSty1dzvcURx1k/GcGhBYJeoMD/fx6qcVsCstbrTOC8=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2413.eurprd04.prod.outlook.com (10.169.134.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 02:20:13 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1922.016; Fri, 24 May 2019
 02:20:13 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2, 0/4] ENETC: support hardware timestamping
Thread-Topic: [PATCH net-next v2, 0/4] ENETC: support hardware timestamping
Thread-Index: AQHVEQ/lOru7YbqaqUKfl9qTVlpeDKZ4uksAgADRkBA=
Date:   Fri, 24 May 2019 02:20:13 +0000
Message-ID: <VI1PR0401MB2237EC43DA992198CE3BA768F8020@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190523023451.2933-1-yangbo.lu@nxp.com>
 <20190523134832.xzupnwvhhlljtoyh@localhost>
In-Reply-To: <20190523134832.xzupnwvhhlljtoyh@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92d54a33-d243-4487-6d81-08d6dfee5aba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2413;
x-ms-traffictypediagnostic: VI1PR0401MB2413:
x-microsoft-antispam-prvs: <VI1PR0401MB241393EFC9C3F6A7B552F04CF8020@VI1PR0401MB2413.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(396003)(366004)(13464003)(189003)(199004)(6436002)(478600001)(3846002)(6116002)(4744005)(55016002)(53546011)(6506007)(305945005)(7736002)(74316002)(2906002)(81166006)(99286004)(8676002)(81156014)(6916009)(53936002)(5660300002)(229853002)(7696005)(9686003)(76176011)(14454004)(68736007)(25786009)(486006)(8936002)(6246003)(256004)(1411001)(476003)(316002)(86362001)(26005)(66066001)(11346002)(54906003)(66446008)(64756008)(66946007)(102836004)(33656002)(186003)(66556008)(66476007)(71190400001)(446003)(52536014)(71200400001)(4326008)(73956011)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2413;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 958tLymnFyr8DC2LrntJmkdvAF4etRA03gvUiKtL0zn0sHlTAEuT2zIVfYbfibTQ5MSbHh4ondzjAfbCZ9xCMUR0zALxqMeW842CgVAmJd8wjIKG0Uo+WtVWxPz05CmhaPq9T7lWpJUIJLDnWnJ6qcNRfvNdgqGBqfAyq7tKFGYa+LTP9htsq02bZm2uur6trUAKCO9vHZuPQTQIrb3Q1AxrYQyt18JQrdUyLFjSfpUfKRcYTJydyxqVxjrA5NekXJQUSxPIuiB0doydODd/6aHJahCfC83HHMZKTq8Jt/Ru6TbgD10QRhoirK5HYCnojKqxp1ovEwyZMstNBzD7iUQQln0Iu4Xt9u+trPXv4gMdj9felPZDLExLCbuLv5d3iOetA3hUL/GE7Ncii/Un/mLp9Bb5HtY+VoTUIq2SZyo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d54a33-d243-4487-6d81-08d6dfee5aba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 02:20:13.5770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yangbo.lu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, May 23, 2019 9:49 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David Miller <davem@davemloft.net>; Claudiu
> Manoil <claudiu.manoil@nxp.com>; Shawn Guo <shawnguo@kernel.org>; Rob
> Herring <robh+dt@kernel.org>; Alexandru Marginean
> <alexandru.marginean@nxp.com>; devicetree@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v2, 0/4] ENETC: support hardware timestampin=
g
>=20
> On Thu, May 23, 2019 at 02:33:24AM +0000, Y.b. Lu wrote:
> > This patch-set is to support hardware timestamping for ENETC and also
> > to add ENETC 1588 timer device tree node for ls1028a.
>=20
> Please, in the future, summarize the changes from the last series in the =
cover
> letter.  It helps the reviewers to focus.

[Y.b. Lu] Sorry Richard. Will summarize all changes in cover letter in the =
future, besides change notes on each patch.
Thanks.

>=20
> Thanks,
> Richard
