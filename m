Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61445F393B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfKGUKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:10:52 -0500
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:19170
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfKGUKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 15:10:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwU3r7ogLOMFmcuVGDsrvQeQVZBj5z2u4XvNIS+3894dSCH7ukjuFFpc0D0AloqxHZtCgjwfh1jW3bk20azARFkdQ8OUs5jb62yPJpUzPsQ0Xszc2lb+cS8LKfKIUEsZaUJ8KgPdbb+RWMar5X93hWzsoQismLJUP66313cz4EFs7J8kmRICS+Q8p8yx5oo4mLC58p8rju+JdKvvDI+vvSjegLAoWur4ETtHmsGgXbDAkFvA0lFLINxhx+Zm3lOJos3VbJJ/J3CB4GyAXLPjQ0TZXzoBRWUTyp3FD8qXPll2607vOjuM4OqmR1a9a8EbrJ6NSwA/8V1UH431falg4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+m/+uQQys3tzVTJUMV+0bku3PbZl9JbTni0PStXgu4=;
 b=nBjW8UIp/bUoOSRGIFD0yQcCy/MVUTRDpQDQbsDveOFakDOHD1+TUi255mpcOUAnDvehBCKiT619aggc8K7Le0rIl7x2/hcFH6g8zejtyJ5oesfwQMkV5vhxZFmNyv+Ja64dusYVnI4cMtAcMdTyuQ9BTuTwdqqkMDt5KcCAFwxO1hhLjhnsyUSpUyDUYr/d8BcrOzWUQRHNSFyDyAqwvkdtGQrJXKDaMDTIFK7SwwuCYmyeG3PQF/qYJWosgRQMhQ5sjITYkjFHB6BgYDtjMMrQpjlX0ACP+Bkql9iXmWyO8NnaEkWZNl5yiAphFldONJJK6JOsu1HfKS8RcK8OQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+m/+uQQys3tzVTJUMV+0bku3PbZl9JbTni0PStXgu4=;
 b=so49M7sK6otLNx3mFTUcek83iFD9OcI735pOsAa+qVGp8OM3agi6OV2oPrSu+lQJJ/S851jqqBTyVOhrEGBI/oVqnbO+2HM5NmfWMbgxxysH2HnPoexFIy7r3D+gnOgdGDmMZtiIS4tCougVTmBbmZAfpgILz6h0VDxgrZa9zp4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4532.eurprd05.prod.outlook.com (52.133.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 20:10:45 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 20:10:45 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scad/75GAgAAxHKA=
Date:   Thu, 7 Nov 2019 20:10:45 +0000
Message-ID: <AM0PR05MB4866BE0BA3BEA9523A034EDDD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107170341.GM6763@unreal>
In-Reply-To: <20191107170341.GM6763@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a50ad319-855e-4762-a490-08d763be92e4
x-ms-traffictypediagnostic: AM0PR05MB4532:|AM0PR05MB4532:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4532A73F922940083A7D86F1D1780@AM0PR05MB4532.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39850400004)(396003)(376002)(136003)(13464003)(199004)(189003)(316002)(66476007)(476003)(14454004)(478600001)(25786009)(7736002)(186003)(66446008)(66946007)(66556008)(64756008)(76116006)(102836004)(256004)(7696005)(6116002)(3846002)(11346002)(76176011)(26005)(81166006)(486006)(81156014)(446003)(6506007)(53546011)(99286004)(4326008)(305945005)(33656002)(5660300002)(2906002)(54906003)(6916009)(6246003)(71190400001)(71200400001)(6436002)(229853002)(8676002)(52536014)(86362001)(55016002)(9686003)(8936002)(74316002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4532;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dS73FkBFIRJ1fJcD/+gNPpHkaCIgwmS+m1hfrPMZ7WWp2noahXTlbCeqp1qlAMl8l5FdvDpSAPB3O+xz7T5m12ttLgMLpO7B3hCOJH7fO8sc4eSJ58d6Ai8QkM6vVN3qfbVsNC5qrPMrMUduSdUqfVzpDe5k9zGDruWZp96hqRNnLSLO9ZmluwqaP4xkkdblRDPRD1ywS92ikBAnxpZvBLwcwTJrzHyNlZCdlD+w4DZIrL1Le+SP/lnSm0ZjTR025bMun86nrSGhcQBY5rns/SKFCxhAm4LbtUch5u8MpiGd2iB2s5TiXUyLaLeWpY3ipT31TCDj36IDyXOI6KoeOVtGaB1ewAGfiLSWPt1QvEkkqVlSA2xHFvZYNLcgIc/eXK1gifj43cLMMXJfVUyoB29nV16fTWz1e5K4B6SER7mD8sHJeNjQF9lS5WB7id7r
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a50ad319-855e-4762-a490-08d763be92e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 20:10:45.4129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZLuPRRbpKk1WhJdFQATGueQRajjAhh9CTOOA6+B/q5ApzMNixLk7FoBkNItaqqvQnBU6mK9bVc5bVLcYkLykw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4532
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, November 7, 2019 11:04 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; cohuck@redhat.com; Jiri
> Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
>=20
> On Thu, Nov 07, 2019 at 10:04:48AM -0600, Parav Pandit wrote:
> > Hi Dave, Jiri, Alex,
> >
>=20
> <...>
>=20
> > - View netdevice and (optionally) RDMA device using iproute2 tools
> >     $ ip link show
> >     $ rdma dev show
>=20
> You perfectly explained how ETH devices will be named, but what about
> RDMA?
> How will be named? I feel that rdma-core needs to be extended to support =
such
> mediated devices.
>=20
rdma devices are named by default using mlx_X.
After your persistent naming patches, I thought we have GUID based naming s=
cheme which doesn't care about its underlying bus.
So mdevs will be able to use current GUID based naming scheme we already ha=
ve.

Additionally, if user prefers, mdev alias, we can extend systemd/udev to us=
e mdev alias based names (like PCI bdf).
Such as,
rocem<alias1>
ibm<alias2>
Format is:
<link_layer><m><alias>
m -> stands for mdev device (similar to 'p' for PCI)
