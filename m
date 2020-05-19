Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943211DA327
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 22:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgESU6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 16:58:55 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:15475
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725998AbgESU6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 16:58:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R94Jj2mNSDEDENXvNSCXnjexr1HtM0ATBEBgOlBk6bEFNmZRz11JSPzUpKYG9fdQYVWnrJ7kI0lkqcaLscodkm5oFJ8veRoUNkRKGDabmnbDkJb2oBtPwO+FtkPAztZ+BUMdp9ZzLDGTTbEtS9cRGvt9lCA+Ywp4wYjuYiNjQz4E+hakjZNs1ZBkgqdZzwxPMU8cdmxlJ2qGsyK8MstbMjFn7ZdcceRNebqPYuGK31D/xDBwO4OIbDTj2VYiMKWS2k4/LR82zxK6TYHUmXi0WRApYNoz4Js5oI+DXPDw6NqOQydC4pelB+Q9Zl8cmGZNK55rDgk/jLCOQ8HGCcYYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPydZzjkD2OPaTVCVGLwKuEoqNf5ILHeT5vWGPlUOjk=;
 b=KL+JhcAUQZyUkQd4cM5Of7aSMYF79G1ZqAD/YP4HesfhvJg+vEwB7yDisxacFypvzrLkemT8g0GYlDSRP6I0RqJTdvrR0zEVyiqXT/IX6MfpxVQMVa2Q1cneqRIDMj+qlPygxfjIjlJ/u0kAOFZCUGGy6TkuR1yjXeQWs64pNoS3iqo89Vb1qcL6uxS35OhzUX2M/p9O29eiEx2f7cAPLZMnfYSRmi6dF37TCwnmL2Sk4UF/yGcLaEZW7cgp+s2r4cdAWNVZJmL3wA0KSDxXrAgrgK+sxGlvutY+ow6PQhFfCi0mB0ss3f0/KI8TDVkSrboOYZr4hS12cKQ2sMfwjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPydZzjkD2OPaTVCVGLwKuEoqNf5ILHeT5vWGPlUOjk=;
 b=jdIwLgxGMDxDqmxLtGkb9d1/ZO4tDBpNlIiTnylbtGA82ebUpX7s/yMkuSp0mgiaSMGKnLj3lA7Quah1w6m34x708JvUp4gV9JMnL5bulpjw9mc1AzYRA36rpu81/JU06uzOopXESCaaIpW/mMT6EzO1RZ1RZL/ftRGC8cHKoXA=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3901.eurprd04.prod.outlook.com
 (2603:10a6:803:18::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Tue, 19 May
 2020 20:58:51 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.033; Tue, 19 May 2020
 20:58:51 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYIAD5lUAgADH7GCAALvkAIAAGOkQ
Date:   Tue, 19 May 2020 20:58:50 +0000
Message-ID: <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2d9d2722-e75a-4f4d-5e34-08d7fc376ef7
x-ms-traffictypediagnostic: VI1PR0402MB3901:
x-microsoft-antispam-prvs: <VI1PR0402MB3901D7B001340326DA463D28E0B90@VI1PR0402MB3901.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: on/m2kA2KoH7PP7G+lKSqqmgcNzEtwHqjDx5U1jcPdF8AJWeUYPa1bThkko5rRfm7Sxx/Hu4Kit/e0kKMj+wupl3s3zMpZY3YQ6aQBuxwdh0ZySmP0UbCoiM71suz5flkp2gYJMmrt4yxdhA1WyruHXsEMkiRDKw8RCZLvZdHUpIGTe77P+t6UTZpfBswcXBgDKH3AO9BL1p7QjbbrvlUQIJEoUelOhU5KPgLXyjp1oqrKdp2dh4XmpH9PNTyfHLpu7FuRrDoyYin2TmsIEXlvEvGvxKjKYFCfsXoK8hrf4JJ9+pW7e4kXxNxxHa4DfNFQbY9Xlsp0XgQZN1n0RW6ZD5jWeNX/D2hDF0DIsB6JnbnTgKsobE0utHy2EwyiYaU0dS2n93++1g8hWcyZwdOJKWItWDb+8Odk5GR7GEot3wUy8aKwJcVUf2TpXPR8kE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(55016002)(9686003)(2906002)(5660300002)(33656002)(26005)(186003)(76116006)(4326008)(66946007)(66476007)(54906003)(6506007)(66556008)(64756008)(66446008)(86362001)(7696005)(478600001)(6916009)(44832011)(316002)(71200400001)(8936002)(8676002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XXQSdjNHEVix85gSmRN9B5T4hdJpZY7CLX0SmcK9p2tKyz1AsYFAR0VtyOiZBqu9txNg/YDNJ814iyEWPQFjbYIzA35fcpvG+p4QpO1/8VFTPDCszkJ2W3RXbQOcOQuoiDwmLQYu2Wg//vG6bvRkOpRPuVMFAMbzem5FY/nmENoDZIq35coEFb65ImEFlZWwVk3bSoEb3W6W5b3m2/UThR7h7tPFMooUth3m6h8K/OrHcHo3Dqrz0foqg+dgiOn8CryhTjtQFg17RsSqx5GsboZY9VMqiA9gKQpEBN1T0plDcl4268JxkSwucna1Zw1wXvFfIKOzekl9TsRduPGvnkCRJlMidGxzg68Z9Rg4gZgDJKmCrK5nrT73v03pb8Tp7wlLplIUyGbmHTCeg6Mu+vWG8G412pLuykE5xn41PBFRbyugYzcj4z8HZhosbv1RUNSALkX+2nq+smCaMu1qA+woNSsDl/iinY6L1Y/HZs9MSGY3+VXUag9l6Q8ulL9K
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9d2722-e75a-4f4d-5e34-08d7fc376ef7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 20:58:51.0221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6s7zOHebdJDdWbwP6hJnKUC/kZEizgO392nLDM4tcUHV/8ZED4VUIx7Nm44dpLW1p503DTzXiTbCnEkEBWK+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3901
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Tue, 19 May 2020 07:38:57 +0000 Ioana Ciornei wrote:
> > > Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx
> > > traffic classes
> > >
> > > On Sat, 16 May 2020 08:16:47 +0000 Ioana Ciornei wrote:
> > > > > With the Rx QoS features users won't even be able to tell via
> > > > > standard Linux interfaces what the config was.
> > > >
> > > > Ok, that is true. So how should this information be exported to the=
 user?
> > >
> > > I believe no such interface currently exists.
> >
> > I am having a bit of trouble understanding what should be the route
> > for this feature to get accepted.
>=20
> What's the feature you're trying to get accepted? Driver's datapath to be=
have
> correctly when some proprietary out-of-tree API is used to do the actual
> configuration? Unexciting.
>=20

I don't think this comment is very productive. The out-of-tree API has noth=
ing
to do with this. The NIC parameters like number of traffic classes and numb=
er of
queues per traffic class are fixed as far as the Linux driver is concerned.=
=20

What this patch set does is make use of the queues corresponding to traffic=
 classes
different than 0, if those exist.

> > Is the problem having the classification to a TC based on the VLAN PCP
> > or is there anything else?
>=20
> What you have is basically RX version of mqprio, right? Multiple rings pe=
r
> "channel" each gets frames with specific priorities?=20

You can think of it like that (maybe, understanding that mqprio cannot be a=
ttached
to the ingress qdisc, indeed).
DPAA2 has many peculiarities but I don't think this is one of them. There a=
re some
RX queues, some of which can be given a hardware priority at dequeue time a=
nd they
form a traffic class together. The assumption being that you don't want low=
-priority
traffic to cause congestion for high-priority traffic, to have lower latenc=
y for
high-priority traffic, etc.
Some 802.1Q standards like PFC actually depend on having multiple traffic c=
lasses too,
based on VLAN PCP.

> This needs to be well
> integrated with the rest of the stack, but I don't think TC qdisc offload=
 is a fit.
> Given we don't have qdiscs on ingress. As I said a new API for this would=
 most
> likely have to be created.

For just assigning a traffic class based on packet headers a tc filter with=
 the
skbedit priority action on ingress is enough (maybe even too much since the=
re are
other drivers that have the same default prioritization based on VLAN PCP).

But you are correct that this would not be enough to cover all possible use=
 cases except
for the most simple ones. There are per-traffic class ingress policers, and=
 those become
tricky to support since there's nothing that denotes the traffic class to m=
atch on,
currently. I see 2 possible approaches, each with its own drawbacks:
- Allow clsact to be classful, similar to mqprio, and attach filters to its=
 classes (each
  class would correspond to an ingress traffic class). But this would make =
the skbedit
  action redundant, since QoS classification with a classful clsact should =
be done
  completely differently now. Also, the classful clsact would have to deny =
qdiscs attached
  to it that don't make sense, because all of those were written with egres=
s in mind.
- Try to linearize the ingress filter rules under the classless clsact, bot=
h the ones that
  have a skbedit action, and the ones that match on a skb priority in order=
 to perform
  ingress policing. But this would be very brittle because the matching ord=
er would depend
  on the order in which the rules were introduced:
  rule 1: flower skb-priority 5 action police rate 34Mbps # note: matching =
on skb-priority doesn't exist (yet?)
  rule 2: flower vlan_prio 5 action skbedit priority 5
  In this case, traffic with VLAN priority 5 would not get rate-limited to =
34Mbps.

So this is one of the reasons why I preferred to defer the hard questions a=
nd start with
something simple (which for some reason still gets pushback).

Ioana

