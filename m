Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA74D06F1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 07:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfJIFyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 01:54:02 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:30981
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfJIFyC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 01:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4LN2crb2UC7Hq9XR+Z5cmj/n9SRJSvPc9P/tS94OYWw1+awIx9Ohh5w2OIHdEXfdpitfcJnDd7H43EaIFyxOw7lEZDJAKASgljW2V4MwdTGCs4m2sj8EkSS6fnSHZXx1RdNpd1XDXfGHa9p5KAuHJ7lb41IkrftsXo12I1mk42Dl2Q8OuUdVsoz+3U/8VLyi3dxlHlMynyBM0iY1JSuyPq5qoEGqy33CNc8Vi8uS/DQ2hgCfMQIbKJZCEf7h/PW/2bk+wTa2Iq0HhGKknI24YkRNg7ZXfVVc2sq4KODf63M69ReUfAAVIkptm3/mp99WI3wOVoJVbfrLswX3kClWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msvjmm9JcBv8TdCrPI0qh65SJ6xeOjBDBXapyqu9sRY=;
 b=KG25yXNkwIxctsQVi3P485xysIHvcOV9R/qijmxaGGJScBEGC9w7bBmPVcW2jrJH5Lwe2T1mJOPzibSiZ3XkQa+C4TWddFTygIx7zwhwkicowrvIhMPgDeqrekkhNPvqmDiuGNrgbec/21N+c+8hD7GoNqPJklk6LBJwces+HMmFEVG9f/5taUF/+Nf3jdidCBrRrCB/gbbbVOmmrIu7cdpI3xKw8Ho3bqouXKvaf6EZGUqsMRoCuFbZ2hngbMXio+85GrkrgQykh4fVjBi8b3r2ufyfb6EJwDgNsWFEHqE0GHxvhqXAnZcXsGPvrszqsMxMG+Hd7//1vGVHkrAgXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msvjmm9JcBv8TdCrPI0qh65SJ6xeOjBDBXapyqu9sRY=;
 b=Yf0agaYfWSocQ+QUwLtUZwNrRdJh3ftQXmGAsxes9XheH7UfE3GUmWE/L46Z6qtCR3vPtyewJoNBMUPdTYxJKBg44e1Am3h8BUQhPyjIjXDsqu31givg4dF7YEerIsMPG6xUdO98aMaUWG/3JLI7hM4W+xqpCTaEjStRSCP+nXU=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB7007.eurprd04.prod.outlook.com (10.255.196.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.23; Wed, 9 Oct 2019 05:53:58 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 05:53:58 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/20] DPAA fixes
Thread-Topic: [PATCH 00/20] DPAA fixes
Thread-Index: AQHVfdFsrXGFADxnTUm9AbE+9WeE5adRsNMAgAAbzgA=
Date:   Wed, 9 Oct 2019 05:53:58 +0000
Message-ID: <VI1PR04MB5567905315BD6CE8F88EAFEEEC950@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
 <20191008210130.23f8a123@cakuba.netronome.com>
In-Reply-To: <20191008210130.23f8a123@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a7d04fe-4f01-4146-db17-08d74c7d13f2
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB7007:|VI1PR04MB7007:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7007E579C382F77DBB61294FEC950@VI1PR04MB7007.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(13464003)(199004)(189003)(8936002)(6116002)(25786009)(3846002)(33656002)(76116006)(2906002)(4326008)(7736002)(71190400001)(66946007)(81156014)(8676002)(54906003)(86362001)(81166006)(71200400001)(305945005)(66476007)(64756008)(66556008)(316002)(66446008)(486006)(6916009)(5660300002)(966005)(7696005)(6436002)(76176011)(6306002)(26005)(52536014)(102836004)(446003)(74316002)(11346002)(14454004)(478600001)(229853002)(9686003)(55016002)(53546011)(6246003)(476003)(66066001)(256004)(99286004)(186003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7007;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+oCZA2yP/eoWjINmeK3D5q6XSGINok9LgvFPJ9zil25yGX+Jycl0akb3clDxCQdTFMpSgM2nJPECDxjmsDeKNgHr5pvmTYxMmeHQwloLk3BKbYBYLo414A8AkYls9YigdXMxnNIAiwaBmBXvFBgGyBxEQCVJtkcIadF/v/wxGkjuWEW+kNN6DpcRH5hmTfjK/jvMKwTYMSP6MS8pnHL8zXq9quF26sctSmTJiOvNXOkT7aUZLl9p3hNqJ55i+LlMSOJkp4o0slcvjgpVYsgmCL4oTGVDdTnwMjoIUi+CRBf4wWXMylbPOP81Bk9h/kwn1nYF+cla24CmJ5l2T1nhXut6j3IKSJ6AJkr8p5wVbmPXZtXgukuUt0BSbIBGZE2UdmwbYtt5E29bSELy0PeuEATrTplwiI8SeOG/9NOIHnuE/o5oyJ+kl3og9qHP38OHJKxq8TTJUyUC+ZdOnHWDQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7d04fe-4f01-4146-db17-08d74c7d13f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 05:53:58.4920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NKAWOdRxZ78HV6rbRk/IfXAOu4gISoIMI8SsddeMxz7ZHfIwYrntMEeuoReMk4aBczuDIS5c+BnUlBuzvgBvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7007
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, October 9, 2019 7:02 AM
> Subject: Re: [PATCH 00/20] DPAA fixes
>=20
> On Tue,  8 Oct 2019 15:10:21 +0300, Madalin Bucur wrote:
> > Here's a series of fixes and changes for the DPAA 1.x drivers.
> > Fixing some boot time dependency issues, removing some dead code,
> > changing the buffers used for reception, fixing the DMA devices,
> > some cleanups.
>=20
> Hi Madalin!
>=20
> The title of this series says "DPAA fixes", are these bug fixes?
> If so they should target the net tree ([PATCH net]) and contain
> appropriate Fixes tags.
>=20
> Cleanups should go into the net-next tree ([PATCH net-next]).
>=20
> Please try to not post more than 15 patches in one series, it clogs
> up the review flow.
>=20
> For some of those and other best practices please see:
>=20
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
>=20
> :)
>=20
> IMHO there is also no need at all to CC linux-kernel on networking
> patches..

Hi Jakub,

I should have added the net-next target in the subject.
I can split the (minor) fixes from the other changes.
I've added "Fixes" tags to the fix patches already.
In regards to the patch count, I can send two patch
sets but it won't reduce the total...

Regards,
Madalin
