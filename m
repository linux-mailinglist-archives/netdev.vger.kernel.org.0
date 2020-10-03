Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF6028214A
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJCEfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:35:23 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:16129
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgJCEfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 00:35:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtjxUJg/CMcZ0hYsMsQF//hBu5xJznpBM//9jibuZWCmP8NP8aKzaijCvAIPLZtBJl6px1BSeetStbm1EdaIbOeXhQ7ACE+hnZz+/Z3YuQ17rOnbUaRwpPZx0hN1YExCbOXZ4SwTsI6PSPWPVbxxHPDMk7/O2q9M2odlqnbo1xemCkITHki8/1FbxfCMbLC3sJnHw4Zyn8r511s8af5ImST0yLC3a9Qa6SonYHtCfGiylk80MJC8ZgtGawFQE76Dc4ba3SwJXQ5NTnaxIAEUwnw/YfwZp+8ADwWYR96VIMkW17Pi1KtlYY/E6RneP7AD4QMmuCDWEGVyICxFmpqYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZnlYhcYGeqsOPD5Lv0ttxUzIm4/5nt192A+ee9SsMg=;
 b=h7fKy/mC59LdyDNHkRck38nv2RDxqzrHUZ6WaLhvozt4xCBqZkAHcgQWJHY6xkIIh8wyPJzUbeKO4ByXrjKOhdK6rVrI8mYXmdiPBHjLogoKsBsY9JfAcrVeQM5n9zf8YNbeFNJq+4QdnqzjSh8rUGukNwYqVINKYH014VnAn3MhN1osZim+jEWxwYGRajyQnDDCcgWeSEOPqVg3RANURtEGXSuWmNQ/MuYs8BpNuhlSSqiHRBy2gifeT2o/AA52RLLOEfzcM8frVx0/B73+s+2QRbI9IrjKRGHo/huff/sHzsPe7krXKk8jtvABEffUTPlo2camcTdMCZ23qFIdxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZnlYhcYGeqsOPD5Lv0ttxUzIm4/5nt192A+ee9SsMg=;
 b=VpIlc0wl1Zte9OKN/ZkaLydpV5gMZQTqovF0YiuYU/9/DGczT9M2MK1ozoqL/oQg8i8XyTxZJq1wY03vlzWNG/ZAuc52Pr2WJTDZIfGiUCPbx5HcVdT6R8K44Iiz3RNoP1jNYYKEt2qhnPhqTxENS1UI41gTvMZF74WY7J1iXNM=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3472.eurprd04.prod.outlook.com
 (2603:10a6:803:a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Sat, 3 Oct
 2020 04:35:18 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.032; Sat, 3 Oct 2020
 04:35:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 00/10] arm64: dts: layerscape: update MAC
 nodes with PHY information
Thread-Topic: [PATCH net-next v2 00/10] arm64: dts: layerscape: update MAC
 nodes with PHY information
Thread-Index: AQHWmQA1FY6FsAhTLEeg9ZVmf4ok6KmE8TkAgABZ9oA=
Date:   Sat, 3 Oct 2020 04:35:18 +0000
Message-ID: <20201003043517.fcqa23bxqcufgbkm@skbuf>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
 <20201002.161318.726844448692603677.davem@davemloft.net>
In-Reply-To: <20201002.161318.726844448692603677.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8d297f92-631e-4465-33c8-08d86755bb69
x-ms-traffictypediagnostic: VI1PR0402MB3472:
x-microsoft-antispam-prvs: <VI1PR0402MB3472702A7A2746BA0EA25A56E00E0@VI1PR0402MB3472.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t3nAfLMj6+5L2qLEEjNIoy/GiUJ5xs0tr139nelVqrQn9zoqHnjyf0EHmnjbV8RMTPUV7YP2g1cc2rw4359DqJXISulhJMixDTPA7MhXXsAC1YIPZRL00LQR/dEaI3uIDBqH+epFYEnvvSvKKQszkZhvdytBVK0+oDSu7oLfwblvQP36Wp/KRe5OsMgslEOQVM3bKHs1T5B+7Oo+YN6CD4JzM9XDnyFTu9a9SYx7f8gLZuB2LiChXk3bTrqJjBs7KCV+Y7NPkVRa8UFT3txh5C06lqrEcJtkSsDsYwCJR050nzBW4DKzmoUjzq+WOouxEV6yXKxqgFyMvHpUCR/c9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(6486002)(26005)(6512007)(9686003)(6916009)(44832011)(86362001)(83380400001)(71200400001)(66946007)(33716001)(66556008)(5660300002)(76116006)(66446008)(66476007)(186003)(64756008)(91956017)(1076003)(6506007)(8936002)(8676002)(4326008)(2906002)(478600001)(316002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2o93fhRHY1a1Yzs/JWz3mZ1TFjxngZGlCFm1vFx2XvY27inuVuObALvQr6dgpPtIUdm2Tu3nW3BKRmg93xf+B3iP1KL8jSycXn3ilcFf3IKL7eaQHNhis124LQr/I/23P1NIuvtefLQH6bRvH/c8YDqb/Oo5spHPEkMQz36oHiX5iIQNyDevN0MWdzVIn41tW1GylkFH1ELE2JY7uVB9CBTCBZvMo+MzEuXIovozMqy+j5J7KsEtUTd17KT1kvNxllVutSnjnfOAerzXxVu4jMhb9kcZsIET1lYLDb1cAOxODjPZA4oHXnqgxxZEvGGhfuOSiZlTbA+l/ob//AsFIjgBWjmnCWkpzAfO3TQ1BAb5tgam4nUOr9aRuz6Ddo/0bWUUdOK3di0Bj/EZ4tfoc7So4zQMXoqG7HgqSNOA2KdqGax/4CFQMP+4/r0AjJ7SEIbLbI8WZuH2VJGdQvkPRmgf4lkZ+fOru57dzSW+Csn8cqnR602iebtYiWAK28bYSrZOVJ4T5j9p8KuLgl+tIH9PCj3Kgu0y02Mi6JqVB8EmqkMK/3/lgVTVmO4l6/4qcaolUfC5+q3bkYyS9aoFGCYaGwf0CflHaLJBzEpjS/0rnrPrtXJ1O63Mua3wGVbyyhxr7uZPxvpuUIzKk/9PeA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C0D0A72957AC542BBCCE3E437F7F1DB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d297f92-631e-4465-33c8-08d86755bb69
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2020 04:35:18.5141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KeAwvCXHwAIImIXmbOTk/cP9aC6N6ZxPok9SSUBGAMlc9lBobNbIxKG0vLya4fzj/AXRAWRr/ir8/z8koFIdjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3472
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 04:13:18PM -0700, David Miller wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Date: Sat,  3 Oct 2020 00:07:27 +0300
>=20
> > This patch set aims to add the necessary DTS nodes to complete the
> > MAC/PCS/PHY representation on DPAA2 devices. The external MDIO bus node=
s
> > and the PHYs found on them are added, along with the PCS MDIO internal
> > buses and their PCS PHYs. Also, links to these PHYs are added from the
> > DPMAC node.
> >=20
> > I am resending these via netdev because I am not really sure if Shawn i=
s
> > still able to take them in time for 5.10 since his last activity on the
> > tree has been some time ago.
> > I tested them on linux-next and there are no conflicts.
> >=20
> > Changes in v2:
> >  - documented the dpmac node into a new yaml entry
> >  - dropped the '0x' from some unit addresses
>=20
> I don't feel comfortable taking such a sizable set of DT changes into
> the networking tree rather than the devicetree or ARM tree(s).
>=20
> I know we're fast and more responsive than the other subsystems (by
> several orders of magnitude) but that isn't a reason to bypass the
> correct tree for these changes.
>=20
> Thank you.

No problem. At least I cleaned-up the patch set and now it's more or
less ready to go for next time.
Thanks for the feedback!

Ioana=
