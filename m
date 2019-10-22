Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75BF9DFDCC
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387723AbfJVGrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 02:47:20 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:21234
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387714AbfJVGrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 02:47:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0gCiATycy07vNlLWGl/W5Gu/GXa/XxOG8oQ/liKFbs6J0mN0jv/maEXAyEL7jvlsTpHkOwg/7D8UDsLtDFRGblMvV7YzcUrz4bAhYz2dMtifO/Oqh2eF9WeXvlzYrQ6QLO7swrUL0rCjWMYu1zg8mUKqhMwjILLR2vgAgeKXBZehgNapZ8BynagBc1iFq5IIQ6LRfOcu8s+tDwleYv5VYfYCbzrGMHSf5zMeT5vsv/iYim95XT+poocXpT0ONb5r8JrNbji7RDRUSpoXXCZw77A9c/4hqrMvkE1f1ekgFzSUjKN810qAFXjEH7T/udccyV9/gEuQUO4OCPbi0AzjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1cru8S3cxJA3UfLrDcwyTcMZ7p6v8PRvy6Ozkc0xf4=;
 b=Py4Hlo7I0TqkRW2YfVvHnwlwBlTgnpZTWBhfs/yNFCu4kyKa3dwO4hsHw1D53jMrFfBYpnQaQqY3XXrwa4ppcXknMxHcIQTC5Mkgo3ea6xuFAOgWP2KQytEMmY4eKcpHN7uNdnrNK9Rkf7hwJuVBAXrZc+0eXwrbKi2esPNbfyUedg89mC0btAEfWmBG7bviWavlOlOjWqVGcjsUL4zxmIKeihqk8aw9pYhN/4BhzZbv1wtjpqaBfFrm1PjDoUqNOdeXfYxkYsp7GBL9PD1t5xSANE6ZvKOB7adBINdeNEXY1SkoOskLQE6NZBukk8x1BcONdalpaAsWzfkVohwU4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1cru8S3cxJA3UfLrDcwyTcMZ7p6v8PRvy6Ozkc0xf4=;
 b=a/qeazfKpdYzVSEviUUY/I8p89EGAi+TqN0Fb6rKm/uUw7c61UVVehge8ppCXMAj7m1hAy29sV+sjnQJIDKdng5il1nM0x/gwkfLVoLqmIXTNo8pDklp4dSaQ6uSebBE0Xrjzqngp9tXgx9236swfJQ2F6bInEyqD+52ZKwgyKk=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5696.eurprd04.prod.outlook.com (20.178.127.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 06:47:14 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 06:47:14 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: RE: [PATCH net-next 5/6] dpaa_eth: change DMA device
Thread-Topic: [PATCH net-next 5/6] dpaa_eth: change DMA device
Thread-Index: AQHViAr73nMz58c3IkSLdCljb94YjqdmEKIAgAAh3rA=
Date:   Tue, 22 Oct 2019 06:47:14 +0000
Message-ID: <VI1PR04MB55676CC59282130611BA3675EC680@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
        <1571660862-18313-6-git-send-email-madalin.bucur@nxp.com>
 <20191021212248.0f2d5f57@cakuba.netronome.com>
In-Reply-To: <20191021212248.0f2d5f57@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f959f54d-3c42-4d52-4373-08d756bbac1f
x-ms-traffictypediagnostic: VI1PR04MB5696:|VI1PR04MB5696:
x-ms-exchange-purlcount: 3
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5696B39538A57C57E8DCEB18EC680@VI1PR04MB5696.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(199004)(13464003)(189003)(53546011)(6916009)(7696005)(6506007)(102836004)(76176011)(25786009)(54906003)(76116006)(316002)(26005)(186003)(229853002)(486006)(33656002)(476003)(4326008)(11346002)(66946007)(446003)(64756008)(66556008)(66476007)(66446008)(74316002)(6116002)(3846002)(86362001)(7736002)(305945005)(6246003)(99286004)(55016002)(6436002)(8936002)(2906002)(81156014)(6306002)(9686003)(8676002)(966005)(5660300002)(52536014)(66066001)(71190400001)(71200400001)(478600001)(14454004)(256004)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5696;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iOX+TwNxQoQMPGAm757ToPvTuu4aplKl42kaarp5eb18L1fq5b1PTAbVBpFS8CWzpob3jA89eeaKmamms0oK8dIZEukW8qmjSbLOXikS9CPJoOuw6IZDgqQWPXzhUmhT2SMB0LycHzy0J947/tru1ODf78w0MoW9PFo2NrL3dBRLl9ywEcIpv6S9kms12f/1B7uVN4sZLkchM+XVsooPaR2ew+GBuLvnULz0dS8ESVqd6GW57p3+rLDlFMJ/BOiCOF1HDS0mb6cQshiMDXKhDSqar2KoE19Z23o6fBig+Np7oUd1Xn9OKyueNb+IudsfmTHHKC0H3criWC5vnBOqfri81wTHAfE2Nz6iwBCcxSvMDTCk1souy9RgIuLOR0NE9f+izlKiPszTzuuniUkxO3OsWIjMy7LTHe9tH3fIYQdPY2ZuWWqwFEiilv2HNcOeLH5XuiE2vU4PMSYfMQj7MG2ST9q3FDpDlw+au5LqPjs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f959f54d-3c42-4d52-4373-08d756bbac1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 06:47:14.1138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lc0jjABTqHOrApWuIMptydCveBL7nL5GEigMzIJyjKRFjYx0gIw+3MJnlgVEUPOGTNWFfXpr+UvBaMFdEF0CGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, October 22, 2019 7:23 AM
> To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Roy Pledge
> <roy.pledge@nxp.com>; Laurentiu Tudor <laurentiu.tudor@nxp.com>
> Subject: Re: [PATCH net-next 5/6] dpaa_eth: change DMA device
>=20
> On Mon, 21 Oct 2019 12:28:02 +0000, Madalin-cristian Bucur wrote:
> > The DPAA Ethernet driver is using the FMan MAC as the device for DMA
> > mapping. This is not actually correct, as the real DMA device is the
> > FMan port (the FMan Rx port for reception and the FMan Tx port for
> > transmission). Changing the device used for DMA mapping to the Fman
> > Rx and Tx port devices.
> >
> > Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> > Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
>=20
> Curious, we also have a patch for fixing this for IXP400.
> Is there something in recent kernels that uncovers this bug?

Hi Jakub, it's related to the IOMMU on ARM64, this change is just one
of the many required to get IOMMU working on DPAA 1 platforms. The
device used for DMA mapping was the MAC but in the DPAA it's another
HW block that is actually doing the DMA transfers, the port (be it Rx
or Tx). This fix just makes the code correct, to actually enable IOMMU
there are some more changes and some are under discussion on other
threads [1]. I'm pushing these changes so I can make other modifications
to the DPAA driver while the IOMMU related open items are solved.

Regards,
Madalin

1. Laurentiu's IOMMU related changes:
https://lkml.org/lkml/2019/4/22/357
https://lore.kernel.org/patchwork/cover/997994/
https://lore.kernel.org/patchwork/project/lkml/list/?series=3D396215



