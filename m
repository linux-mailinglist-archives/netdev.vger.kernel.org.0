Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69D67238
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfGLPVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:21:31 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:34796
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbfGLPVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 11:21:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEabBf4H035JHhKDpoJYpX5e6srvq1jfEVeVISJrjRjzZtOmIQXw+SLBi8T3qa4pOO5dTsd/f8bZ9HxgUwLeTfcQ6dJT5VmYTFQhtuRohAOj5eSx59xIjMSKuioduuTXjLoUo29X9y2MCm3IXylsLMtu0iAQWEl0ehhkBLxFgaNGbpoc6y/qowzwH1Ll+oB/TfPNQMiVNJqU+QkQT2db3pSiMaHkeypGeQCFN64q+XS8b27NuhPMb7VYuREZ/NY8OWXUY4cuj2iB31qsUNZwIUaBxGyaq2gjyD5mPNvmVZUmJYN/idsE1+LQY9g80PZInGnvMbKvY8A9RD9ETQXOnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTietNN9LaTFr9qiU1R+UPOh0Qv1LHGuINqDWV6v9jI=;
 b=neDKNFQY0aQTgIM3FqaX2g9wmpTbKu3XQOBcMSTvjN4XrCv1k90di6nSyTUkRK5L9DE5rqurHO/z2RlIDWrGc2ApKSWc+WMMSMN6MhbK1YTd5sGcVqMMRvCqrbtX3eHyvZedUMfhbPJjJovA2jYCnGLANReTIIUekjuWfa7/B9KzMX4CHpl8agk604V8MbCLFiBb2ceTZcilvK6H12v6BT15RTpyDqyerMh4DVHOKAi33YUD6rvDNrfaVt3Ob1AbgkW2aW0yfJ7otcosp3ggciIeOyT9OAIGObPrJ6yjBiWwJ40tkGAKVhlzMas+8YZgVDJ/CubxBM8jj+BlK76c0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTietNN9LaTFr9qiU1R+UPOh0Qv1LHGuINqDWV6v9jI=;
 b=LogwxINckRhS++zzVs3TE85cif9dFUQ4ZnPXVY6akf4mbiRAW4GxmGwoLeUrr+Sul8VTwEZvRIqXMhAlQzcN0RWjz2VWLYStmIQpMJzpAAXyU5mNFP95iaZGI3d7vr3c1enV3Lef98gwN+jAw7M3kpLEm041IRpK07a5ba9XKsc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6478.eurprd05.prod.outlook.com (20.179.26.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.13; Fri, 12 Jul 2019 15:21:26 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Fri, 12 Jul 2019
 15:21:26 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Bernard Metzler <BMT@zurich.ibm.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVOFOSJVhx7iVyk02xIEJKwp4L1qbHGkUA
Date:   Fri, 12 Jul 2019 15:21:26 +0000
Message-ID: <20190712152122.GC27526@mellanox.com>
References: <20190711115235.GA25821@mellanox.com>
 <20190710175212.GM2887@mellanox.com>
 <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
 <OF9A485648.9C7A28A3-ON00258434.00449B07-00258434.00449B14@notes.na.collabserv.com>
 <20190711143302.GH25821@mellanox.com>
 <20190712114557.2b094876@canb.auug.org.au>
In-Reply-To: <20190712114557.2b094876@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:160::22) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07b3e408-990b-4d85-2002-08d706dc9b59
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6478;
x-ms-traffictypediagnostic: VI1PR05MB6478:
x-microsoft-antispam-prvs: <VI1PR05MB647882FE672798049DE8F6FFCFF20@VI1PR05MB6478.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00963989E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(199004)(189003)(6486002)(99286004)(86362001)(386003)(33656002)(36756003)(1076003)(8676002)(25786009)(6506007)(26005)(6116002)(52116002)(3846002)(7736002)(186003)(305945005)(476003)(6512007)(446003)(11346002)(102836004)(478600001)(6246003)(6916009)(2906002)(53936002)(2616005)(229853002)(71200400001)(71190400001)(6436002)(76176011)(4326008)(54906003)(256004)(4744005)(486006)(316002)(66476007)(66946007)(66556008)(64756008)(66446008)(5660300002)(14454004)(81156014)(81166006)(8936002)(68736007)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6478;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XSFI/5cPk0flaCaG1Lq6YCWJkz+AKaZje0XSIBHtUYVRglXeo/1nIKwcaJKaVDG+XlKTKTEhRkkTtA2uUBExyh//AOGIefxTiDtclVW5HByOWQVpKFuVqZ6bJ3rDnFwNvJi0dHl8y3vGOIo6U+gQZDmYEjAD54ZOrefgnBAS1gRZgB6YUy1R1TUtHSL0Iv7dI9OXWC5nuz4pYHIFg86R4hzr8annAjPAvbifRxl6L7SPO5EDPiW8j7VLWAxQ3z5mhmQvWev+yv3lhLLVzLqiV6HfeJ51Z45m/WYS0HT2BkpY7N6bQANWTAp5DI0cXER+mHqR0B0iHxB6eaPIAQUyiTdMMe3fOXlufDUmi7tAftscUqBb7jsTHQMDozHQs6CFxmiYwXZedA45CZOqpHsFpIln5Elr8MFSyjVe8E3zmpw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27192D1C05862148B4F3F9F635A79639@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b3e408-990b-4d85-2002-08d706dc9b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2019 15:21:26.7514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:45:57AM +1000, Stephen Rothwell wrote:
> Hi Jason,
>=20
> On Thu, 11 Jul 2019 14:33:07 +0000 Jason Gunthorpe <jgg@mellanox.com> wro=
te:
> >
> > I've added this patch to the rdma tree to fix the missing locking.
> >=20
> > The merge resolution will be simply swapping
> > for_ifa to in_dev_for_each_ifa_rtnl.
>=20
> OK, I added the below merge resolution patch to the merge of the rdma
> tree today (since Linus' has merged the net-next tree now).

Yes, this is what I'm planning on using

Thanks,
Jason
