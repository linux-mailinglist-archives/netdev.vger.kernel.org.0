Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D1DFDCA
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387703AbfJVGn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 02:43:28 -0400
Received: from mail-eopbgr60087.outbound.protection.outlook.com ([40.107.6.87]:2944
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387548AbfJVGn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 02:43:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVxeObJSIb/QKCUKyFXgqxEk8rRaeugQwJWIrtp/wBxOsEUJmu48MfSaMWm9YprL7RnvPSz78j/R4/ZvQHHVYQgoe7ot0735uNNEqq4spkaeRdE3Ca8AuB+yt45qAi1PAHK3mN86frTrP2ftU8AWpRHh8AlPz5IurvE/hF1jtB5qtngbidBUXUG1AwY/xicQS1QliBOqD9YUBuw56WzY5RFRNEH5SkWQj/YWX1B9AKT1qzWGbTaKfif2l2ZXO6ej6K7OWYG7tS0ll6rBHFWOIDxnvP9ey2iaXBZkr/bMH3vFHvCOYH31iuj9WOYE/7U7t93/lFpb4I2tWbyyDvko4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJtQnLeSZmyhuhu/3JvDMXZOUT4wmBmOwT8rhiCZM6Y=;
 b=TEo4bd/64Ju/YLEkF3ieynGwqMkSBv2+2kS21RTb5/cTzJTK0x2Qf2DDi4t8dxGbS/SgQ6j/qCfsqIj0Gn4kagaAlqUNU2W3czba5/74ty9Slxee1xNHG7nL/7PEcl2UpM0w5GdNDXhrlMkmhWT7I/XQMGaGUEhP3ODk6Mc8HTrfeGbI1EBOAnuLTpSMHvUl5HWtk5hBeCuc+wH4OFgrxIqqmbBy0o1NxVFHDBuN/FDecFc52hRYbrq+0UoFE6+D1upJQ/J3UsBzEyYyJqu1EfmZIbLoSpdhk1fgJ8t1866MvfJvjhBapHdayhLTmaQGdxutUsBP7qf7VsfMcy/l8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJtQnLeSZmyhuhu/3JvDMXZOUT4wmBmOwT8rhiCZM6Y=;
 b=IwdYg9HsbH4dUSO60wqDdSRy5x1UQF3yq9EwDON776NnbUMy0JVMhkEUBkb9lSbbbgCpadwiWYpQVASBJp1Woz9vbQyVQWiTB8+pC9t7XiATA+9QdDWFM1JG6p/MdgAmveHlvQg5tbNTeWkUUU/0XFWb7l/zsnUfUWRoM61j3yA=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB7037.eurprd04.prod.outlook.com (10.186.157.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 06:43:24 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 06:43:24 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: RE: [PATCH net-next 0/6] DPAA Ethernet changes
Thread-Topic: [PATCH net-next 0/6] DPAA Ethernet changes
Thread-Index: AQHViAr0ehww7MPYPUqedXDa00qudqdmEZwAgAAjuxA=
Date:   Tue, 22 Oct 2019 06:43:24 +0000
Message-ID: <VI1PR04MB5567B7B647E4FE60ECD88EDDEC680@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
 <20191021212618.32e31755@cakuba.netronome.com>
In-Reply-To: <20191021212618.32e31755@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1e2c945-a8c3-4af6-de82-08d756bb231e
x-ms-traffictypediagnostic: VI1PR04MB7037:|VI1PR04MB7037:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7037C31BEBFD64F68E30400DEC680@VI1PR04MB7037.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(189003)(13464003)(199004)(81156014)(2906002)(9686003)(8676002)(99286004)(8936002)(6436002)(55016002)(256004)(81166006)(66066001)(5660300002)(52536014)(478600001)(71200400001)(14454004)(71190400001)(19627235002)(26005)(229853002)(186003)(4326008)(476003)(66946007)(11346002)(446003)(33656002)(486006)(102836004)(76176011)(53546011)(6916009)(6506007)(7696005)(76116006)(316002)(25786009)(54906003)(7736002)(86362001)(6246003)(305945005)(6116002)(3846002)(66446008)(66476007)(66556008)(64756008)(74316002)(24704002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7037;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +VFhHDh1M1T9ZIzWfTBvPKU8NHeFxUXOWHY76FZf6nlSC38lVgv4FalJrgPSwbTjO0JZOPFYhneV350gqgmw9EdlBiOE7Y2EJGpXIm+q2PhN5epkoF6ayH6U36AEi3VZZ8hgxifre7Bs4fSn7Ept5ZQI6SYVXEQoduFjCS6E/U3m+tFQClb5BlfPDdcYd3mMZTDh/0rKU0nch29btcGJ37v1uIAOeUoiixfnQ4a+qbBhpfwlLtO+AhQZJ6RkxTLyZFDdqdBsgKQBrfmxOAUI5LscEWWeOnAj4WAksMtcltZ73nGm+3TfPJ5viOc1ohFInP7JFNoJdHV4v5RBFq0U/Ssk6bQt0lsGsGUGjOeKGsz3QUziBaQgLGMHHQ3h1hSMDn3x6IxhmplE1igaPieoa3DgBNkxXr7aYJbb9Qx9Ratifu1l07cSvqALVxwoX4qs
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e2c945-a8c3-4af6-de82-08d756bb231e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 06:43:24.3123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Caq5f4aT9742bcdKGRLT6Js6WC7cHUq5Y4zvhz838PlTSb5AMOMb7dOjle2B2o5gO2fG5Cf/BfpSlgopNPD9Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, October 22, 2019 7:26 AM
> To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Roy Pledge
> <roy.pledge@nxp.com>; Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Subject: Re: [PATCH net-next 0/6] DPAA Ethernet changes
>=20
> On Mon, 21 Oct 2019 12:27:51 +0000, Madalin-cristian Bucur wrote:
> > Here's a series of changes for the DPAA Ethernet, addressing minor
> > or unapparent issues in the codebase, adding probe ordering based on
> > a recently added DPAA QMan API, removing some redundant code.
>=20
> Hi Madalin!
>=20
> Patch 2 looks like it may be a bug fix but I gather it has a dependency
> in net-next so it can't go to net?

It's a fix for a theoretical issue that is not reproducing with the current
code base. Future changes related to the IOMMU support may make this issue
visible.

> More importantly - I think your From: line on this posting is
>=20
> Madalin-cristian Bucur <madalin.bucur@nxp.com>
>=20
> While the sign-off on the patches you wrote is:
>=20
> Madalin Bucur <madalin.bucur@nxp.com>
>=20
> I think these gotta be identical otherwise the bots which ensure the
> author added his sign-off may scream at us.

The formatted patches look like this:

From 55a524a41099fa9b2f5fbbb9f3a87108437942bb Mon Sep 17 00:00:00 2001
From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Mon, 21 Oct 2019 15:21:26 +0300
Subject: [PATCH net-next 0/6] DPAA Ethernet changes
Content-Type: text/plain; charset=3D"us-ascii"
Reply-to: madalin.bucur@nxp.com

but then there are some MS servers trying to be helpful and the message
ends up like this:

From: Madalin-cristian Bucur <madalin.bucur@nxp.com>
To: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: Roy Pledge <roy.pledge@nxp.com>, Laurentiu Tudor
	<laurentiu.tudor@nxp.com>, Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 0/6] DPAA Ethernet changes
Thread-Topic: [PATCH net-next 0/6] DPAA Ethernet changes
Thread-Index: AQHViAr0ehww7MPYPUqedXDa00qudg=3D=3D
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Mon, 21 Oct 2019 12:27:51 +0000
Message-ID: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
<snip>
Return-Path: madalin.bucur@nxp.com

It's probably a good time to think about pull requests...
