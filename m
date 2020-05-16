Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5811D5F94
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgEPIQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:16:53 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:13839
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbgEPIQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 04:16:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TR6Em71W9m9n4sf6Nt1SN0pFL5xNyascAlC2ldogisLMxSC6ChQw/8hGrxQ7mxty5yX1eZrillHNRvAwx/5bTXsGSiVpQ1dJyiCgiLpyTCLe2Pn/dAQu8lgbyHHDYGvbKeQ9D76hjuCa6bXVOb+xwCrWfvVgkzuq588GY2XlrauIoM51VRx+CQnrzznaQHLtESbk2CQ46amxIFf2aEEhMDZpNQ+DwCRyCVMUTOC6nJU1VPxm2Je02J/SlCtFcRnqIC9Z5ZKlVpNuALRalHB1o6djgBHbIqUrM07HNOO/cFUuyEHIbIrcN7JXxJJGcn+ZgHPIiN+BuEYu482H8S1W6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M502HtpMPM5TexPEvvP7tuPbOc19caTbiOjCKGaDwwc=;
 b=QHCQpi6IhidOMPdOx+l+gbQxJ7cwctJWKRkXinFd+2Bpvz9LvRYQGEw3ZGA1sX2NJHq3ymwEH6YAgcNktpy3tz9W5TjNZH4qyd+bDGSDjI4bS1IL0bvZJO+PuEJNgWVgQMngHyvOO1RXk+UWlXbFTsUpGS+SN8G1/UjvdiBvOhR03jbhMjMBcn7+B0OaEE9wu72u/kHtdyIy9IHhjFp/n/QKGzjTPg9BkrqyaYMdt8hJjD/ySid9w9dCr/JU1ltSFjyjWmbgWcN1roq4A1Aso52TM1e2JN1oncQFtzV4vBAcjVqSArNkDDV9h+bsVR2M0vhY13AKfSDyc7TznKmb3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M502HtpMPM5TexPEvvP7tuPbOc19caTbiOjCKGaDwwc=;
 b=NM9qlgkr8DWzK+86aCsJWQQ70VZOWAWIMPiT1xplV7mLhQQSQAjDdAAtCHtOnmn6B/j3DhHmuOoZ3V3VE6G/Xo6cWFjJN/6GhxoMBGniNJ9UR6eRGrnqSlC/M2Qcz6WfuonFNJMFkWLG8m5munmDbDXB2M2cjHr4VKq5Et3dRo0=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3631.eurprd04.prod.outlook.com
 (2603:10a6:803:e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Sat, 16 May
 2020 08:16:47 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.022; Sat, 16 May 2020
 08:16:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYA==
Date:   Sat, 16 May 2020 08:16:47 +0000
Message-ID: <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.121.118.29]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77ba777f-48ca-4049-bea4-08d7f9717a3e
x-ms-traffictypediagnostic: VI1PR0402MB3631:
x-microsoft-antispam-prvs: <VI1PR0402MB3631394513EA9D84D982B08EE0BA0@VI1PR0402MB3631.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 040513D301
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OwvI69JaSvgHkZIrMf/MDn5LRysvAujSW0IIIPvbnQ4kp4NKjv+sySECI7Tn81OqRQB/a6H/amNbH+AaA9uSOGLWp4qxx042ugNxc1BCgZTDBDuV3Ow3UmMySaGsXWOonsn+heiXZkk39VczQ8Ew2pKLWapY1GzIT5Ont4HOeMkqqizubQEtZo4bWIqmIohshT91h37DZ4uSiFeni+0tgEhHXcXbQoYTWJLSFd0Ckbjpsp2GnA2SM7Rj1m3qrEy988Lo9lTckaF8VpFXfXrOtZAjGL05NdQTIdrMJb6EmTmyLJkGKiyUlB+j1xAJIDBTiWuvTKIGBVmqKLq7iAfgSVagecWKK72IsNlj5sfx9cLc7K0jQGiiGcbspyRTVua9A5crjc+HgxtZ1vM+6YRFxQX3qQaIHMFc3Q5oKFy0ErU/RH0e6IB/S14g5CJDoPHT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(316002)(186003)(7696005)(64756008)(66476007)(6916009)(55016002)(66446008)(9686003)(66556008)(26005)(86362001)(478600001)(71200400001)(6506007)(33656002)(52536014)(44832011)(4326008)(54906003)(8936002)(66946007)(8676002)(2906002)(76116006)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BRvMKHekc4ycvRmk6UCYcAayeSCfsjvLC+DqxpzMktjGopx1C7pfTYX2d5q5JKAW9yEw0Ys0/zCkhtUsex7kQRKYzp1gVLCZyoTe4wkMpVvkmxvMCB00fny83UK6wkJDzD9ue7hK+osCt8hnxS9Dbpksju8wWQmlqnsPgDH+QUtAKwM2yzB/3cZdPLnJKISgP6lFUl7tA/IfWU18DEoYUZuF8p2TMYLsws2Yzr2n0cUvQV8E9f4UYLbSFWOStvYA8sB85Xwfzv0DNpkn+JV/s8Nx3qvVCwtoV8OEt/gy9B1kZm3PFbA/jJuIiaykXCrEi3YOl0xvWHynyiTASeCF/XjZkXmvXUhb9/HxlMl7fGBBTrG20xgBMbE0spoyfrMdXpU6Kfz8JtRTBrm4UD8ihoDE6TUe9MMEshwZRwEJnGMSyNz2VjgW+ZHUAXciZRV6LoXgqYCPoe3YYd2c+UJk2BfA0VQkyNmWxpny5fWqHRM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ba777f-48ca-4049-bea4-08d7f9717a3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2020 08:16:47.2968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dfMwZzHB3NxwDWrHPN1XpWKj5PFD3YlB/yM7rFHewJZXGPIlco6OX0yGzsPyo6YUf29YdhFVnrVNEIoz1YprA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3631
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Fri, 15 May 2020 20:48:27 +0000 Ioana Ciornei wrote:
> > > > There is no input taken from the user at the moment. The traffic
> > > > class id is statically selected based on the VLAN PCP field. The
> > > > configuration for this is added in patch 3/7.
> > >
> > > Having some defaults for RX queue per TC is understandable. But
> > > patch 1 changes how many RX queues are used in the first place. Why
> > > if user does not need RX queues per TC?
> >
> > In DPAA2 we have a boot time configurable system in which the user can
> > select for each interface how many queues and how many traffic classes =
it
> needs.
>=20
> Looking at the UG online DPNI_CREATE has a NUM_RX_TCS param. You're not
> using that for the kernel driver?

I have to give a bit of context here. If we look at what the hardware suppo=
rts,
DPAA2 is reconfigurable and what I mean by that is that we can create new
interfaces (DPNIs) or destroy them at runtime using the DPNI_CREATE command
that you found in the UG.
This runtime reconfiguration is not supported in upstream. What we rely on =
in
upstream is on a static configuration of all the resources (how many interf=
aces
are needed and how should these interfaces be provisioned) which is applied
and configured at boot time even before Linux boots and gets to probe those
interfaces.

In the kernel driver we just get the num_tcs and num_queues parameters
(which are set in stone by now) and configure everything based on them.
This is why the kernel driver is not using at all the DPNI_CREATE command.
=20
>=20
> > The driver picks these up from firmware and configures the traffic
> > class distribution only if there is more than one requested.
> > With one TC the behavior of the driver is exactly as before.
>=20
> This configuring things statically via some direct FW interface when syst=
em
> boots really sounds like a typical "using Linux to boot a proprietary net=
working
> stack" scenario.

I may have explained it poorly before, but the kernel is not in control of =
how
many TCs or queues are there it merely just configures the distribution
depending on what the hardware was setup for.

>=20
> With the Rx QoS features users won't even be able to tell via standard Li=
nux
> interfaces what the config was.

Ok, that is true. So how should this information be exported to the user?

Ioana

