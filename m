Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7211D357E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgENPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:47:20 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:18497
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgENPrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 11:47:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eiZFUDzSlP03cr9jDhoN+eonsTX5LsQk4q8nQveIeN+Rj7JPnnO2NvVZgTIvnT+CeWoXhvV4oE70AjKS913hNAZALLiFg3CSF5xYC4scCGlkuMBA3g1iDA5vgnLmPhDYcCKnDFs0a7KDSoiGXqADnkoFPc8GqN9T1EpOmcR6lPipND1SakgiPd7/q4YsJiry6ZjQONur0HJzE+wqT4+TVyEBxPtUO4sl9k3eNBbhX7mrQfaqdK6MWKJlCDEYeRgtyyF7250pfk01DbljqlwjxOA7OFSDgbSRtPIdcYetIOBIj8C5zPhE1lZZYFtQTh30ExuaZh7tjNo7eEJd15zPNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blj7HusYKjnxJ+nHwmQ1Hu1li3cGXcsQvgPaRYcohoI=;
 b=Jij88atslg8G57iYNv6sOkoPO1KZb2El0zT9mp0sqKldJgZ/J1rDopkxxhcc8bFInguS08GhKmA8/umagjxqmQx1kMLDVtj5P74y+IR66cZngkXoXUidBLu/4PbcV5ig61VDnltPPsvARbTsa5LPdYmvbLTmJBrAxoZnFNBbciGAhRHJY1cjG2CZdpcOX1eWjdeJzFexcwv6tv/EQxn5OtvsWHpSTlwoypQ9AdBYGRfR1pLvZWiqD2Nl3f/iQ6Ff8WugBj0DyuwxNF0cZ/pzPIVX9KAP9gOqWdpRnJRZOxXDCSNix8w8XmOALpTaLcfLWdSjm38Gc9gKfNuU/3/mAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blj7HusYKjnxJ+nHwmQ1Hu1li3cGXcsQvgPaRYcohoI=;
 b=IEKo0HbMKOayJzLkxsoiQMHykjbJACDMUS6c4nJGXOTWUQHMqaElazVXmEIowi4TV+Jp8q04QdG3V2p8fZythfW4rSZK07GLFdQHf65pIf3XVBzWuoZoD2c6Y8rWabcSYoTWTSY/816GUYwnjvdFpD8Z3HF10/5MKFhIivpzPcM=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB6036.eurprd04.prod.outlook.com (2603:10a6:208:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Thu, 14 May
 2020 15:47:17 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00%9]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 15:47:17 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Mark Rutland <mark.rutland@arm.com>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [EXT] Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test
 support
Thread-Topic: [EXT] Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test
 support
Thread-Index: AQHWKSv6TM4lhcjgTkGu0RMmbRa8+qimSMKAgAAGAACAATATgIAAGLOAgAAiuCA=
Date:   Thu, 14 May 2020 15:47:16 +0000
Message-ID: <AM0PR04MB704193C938ECC28DE9A1B28E86BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
 <20200513180140.GK499265@lunn.ch>
 <20200514120959.b24cszsmkjvfzss6@pengutronix.de>
 <20200514133823.GO527401@lunn.ch>
In-Reply-To: <20200514133823.GO527401@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [88.130.52.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48379456-cf7a-41ce-d83c-08d7f81e1467
x-ms-traffictypediagnostic: AM0PR04MB6036:
x-microsoft-antispam-prvs: <AM0PR04MB6036329F597B9F4549ED0E8486BC0@AM0PR04MB6036.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g3e/UiDrmEPGy03CIL1pnArMr32LNuqK2BMJfBbKmgFL01vhhiNKsXmi7AGOi0oO0ddp8NHFrWBHu1x3sqzsuv7ICKU/lQ3AL63E6qWYNkIN73yO1mF4lA0hY38J1VhBRvbpNIpZyiRHtr1H1Hl4f0/lED9RGHc5qixR/ZXn+Dw/owgnQeRLipUzgarK5/VlQ6n5nsQW7tTKWnSY4Iu6jrNp2KnVl1sBMQQitQBOrZ6yMiE9wwmvOm1gWjbE1P62pG9UlVKxpOeyLHzrXh9u1o2xadURyxEdVoGmX3ZOs+L8Cp/E9pPSoTY7xod2h2EmcMKEGdLQCd4DIZ5U4HoJRXi0sC78gDW00bgrcVcZXa5i00jtDcAHPGSI/pldrs5cGlRjt7HkK8FC5jroYP9xJipwA/1KBer9nfK8psRZ/1AJ51cIzGyZyowniPkUubaP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(52536014)(66446008)(64756008)(86362001)(5660300002)(66556008)(66946007)(66476007)(76116006)(2906002)(4326008)(71200400001)(8676002)(8936002)(55016002)(6506007)(4744005)(478600001)(26005)(44832011)(9686003)(316002)(7416002)(110136005)(7696005)(54906003)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 56Ow/SNMS2QW2YUXj7IjJxCvZGRiWH2HWr6ecYL/FC1dvK1noXk1V8EY8bji5/xRE7pDvNmhnz3qpTg8PihLo6899/zC43tTPZr5OW84V5VvVpqoPNIr6yKplAQrvKTPSDO6rCxaHs4dtQQ/iWzR3YPJj5tVrkhe9qxdOX1vfMHXlS8drB59MXCr1PHpOj28PmGQuk58f0LnKYGfJxllmZGKxClJ6Qmkatmpbi5iqBED6eKotZ9GjjEpg7xpJPZAIGlsJ1TF42J+bo0PJK8FEJT/oqZRuz85oV9CPrMtShRCff1XuIDUoXO5zbrjFkUwF5vidEUAh+pxvLHNtCv7NMIiik/l4bvU3u01f5laHfRh7hrDFNpqDqRG/GHLkehIEPvm668SHeqXELu+PMh6UVVGUzFPt/nj7wq3XtqqDVD/9Wd9NOBeHZMw5yZ1fKQxDB1V9ikImnYUWN+xr8XM76oAKk1tI1uO8+HbQO7e6Go=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48379456-cf7a-41ce-d83c-08d7f81e1467
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 15:47:16.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGoYxAOCz4mdmL8svaUeb5ToM/6WfUMjOnRQBnI36b5yCkaAAMjAR+7P16fLIA9Yen2AQCy5nqF7EpAJ1zUB12ta7ao/Iabwo79Y41JVByA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6036
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> On Wed, May 13, 2020 at 03:39:00PM +0200, Andrew Lunn wrote:
>> On Thu, May 14, 2020 at 02:09:59PM +0200, Oleksij Rempel wrote:
>>  ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER - the link partner is active=
.
>>
>>      The TJA1102 is able to detect it if partner link is master.
>>
> master is not a cable diagnostics issue. This is a configuration
> issue.

Master is very relevant for cable diagnostics, as a cable measurement shoul=
d not be done with an active link partner on the other end (i.e. a PHY in m=
aster mode trying to train the link).

So if the measurement detects an active link partner disturbing the measure=
ment, it is important to report this to the user.

Christian
