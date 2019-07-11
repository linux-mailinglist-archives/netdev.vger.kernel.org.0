Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AF465917
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfGKOdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:33:12 -0400
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:52558
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728045AbfGKOdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 10:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm1xvGHGPQXf3bW42cYmdss81vA1tpBiHczDa8ON4z8=;
 b=bCJNb2zoJtoJtdq/baH3tbi8IOD1rlXpQMUsJetiHYUdGXD6HVCuOq230a5k8lmPnmbvkEaIVx7CbnsQ4LCbCuPgKLWBDrGEUNHkJMRLWLBqizccEAsrrIz+JqGGBgDMbu9a78vJ27DuF3smUi9mcgIbJt2nHKZpsKaPplCLSzI=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6253.eurprd05.prod.outlook.com (20.178.205.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 11 Jul 2019 14:33:07 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 14:33:07 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Bernard Metzler <BMT@zurich.ibm.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: linux-next: build failure after merge of the net-next
 tree
Thread-Topic: Re: Re: linux-next: build failure after merge of the net-next
 tree
Thread-Index: AQHVNgpSNqxsVllq5U23Am+RwOaE5KbB1zsAgAJNFwCAAO0agIAAQMGAgAAKRoCAACKOAA==
Date:   Thu, 11 Jul 2019 14:33:07 +0000
Message-ID: <20190711143302.GH25821@mellanox.com>
References: <20190711115235.GA25821@mellanox.com>
 <20190710175212.GM2887@mellanox.com>
 <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <OF360C0EBE.4A489B94-ON00258434.002B10B7-00258434.002C0536@notes.na.collabserv.com>
 <OF9A485648.9C7A28A3-ON00258434.00449B07-00258434.00449B14@notes.na.collabserv.com>
In-Reply-To: <OF9A485648.9C7A28A3-ON00258434.00449B07-00258434.00449B14@notes.na.collabserv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQBPR0101CA0014.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::27) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00d11ba8-26b1-4bb0-5991-08d7060cb114
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6253;
x-ms-traffictypediagnostic: VI1PR05MB6253:
x-microsoft-antispam-prvs: <VI1PR05MB62539C759DB76022927B5D93CFF30@VI1PR05MB6253.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(189003)(53936002)(54906003)(4326008)(6436002)(71190400001)(2906002)(6512007)(316002)(6246003)(1076003)(33656002)(71200400001)(5660300002)(305945005)(7736002)(66066001)(26005)(76176011)(11346002)(2616005)(14454004)(476003)(66446008)(66476007)(66556008)(102836004)(64756008)(486006)(66946007)(53546011)(6506007)(386003)(446003)(8676002)(186003)(81156014)(81166006)(229853002)(86362001)(6916009)(99286004)(6486002)(8936002)(68736007)(14444005)(52116002)(256004)(3846002)(6116002)(478600001)(36756003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6253;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5nM8VoiyWTk55I8j5yTFXp+xjbqAbHGoZ7e21JnM3rYv70vK5tJLDjmE83HZS/530x54JQRq+QeANr/80r1f9gUBRQZHCh3545VEZHkAzanFyR0CsR43FyvzCaP/TPzef9XBFQG2k69d4SAeFYGeudtmZlIPumZ/2kn7jiRkM0X6fSppgZ08vqcTE6fYRd69LJSLJyyhR51B4pz99/0bM6AMLOyyxyzSpqTC2AhfQPE2EdB+hJM8slmHfvO03r+MZcsSDJCmOov50+iF5em7ZGZZYomXbeRNhYurlYj1sLdYlFK8blvACYaAzCMjvEuqn8xXjwYewQm6k2lPed1Gk3kybNs3fjfEinfVnvOVrYjnC8/NmmiJBL2M1bpfTWjy2fYen1MM9kCLTyDXoIm10On5TI3akXiLwsBGpw8LJGE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2679AEEF5EBE8449A29BAF6FB02687C7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d11ba8-26b1-4bb0-5991-08d7060cb114
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 14:33:07.8068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6253
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 12:29:21PM +0000, Bernard Metzler wrote:
>=20
> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
> >From: "Jason Gunthorpe" <jgg@mellanox.com>
> >Date: 07/11/2019 01:53PM
> >Cc: "Leon Romanovsky" <leon@kernel.org>, "Stephen Rothwell"
> ><sfr@canb.auug.org.au>, "Doug Ledford" <dledford@redhat.com>, "David
> >Miller" <davem@davemloft.net>, "Networking" <netdev@vger.kernel.org>,
> >"Linux Next Mailing List" <linux-next@vger.kernel.org>, "Linux Kernel
> >Mailing List" <linux-kernel@vger.kernel.org>
> >Subject: [EXTERNAL] Re: Re: linux-next: build failure after merge of
> >the net-next tree
> >
> >On Thu, Jul 11, 2019 at 08:00:49AM +0000, Bernard Metzler wrote:
> >
> >> That listen will not sleep. The socket is just marked
> >> listening.=20
> >
> >Eh? siw_listen_address() calls siw_cep_alloc() which does:
> >
> >	struct siw_cep *cep =3D kzalloc(sizeof(*cep), GFP_KERNEL);
> >
> >Which is sleeping. Many other cases too.
> >
> >Jason
> >
> >
> Ah, true! I was after really deep sleeps like user level
> socket accept() calls ;) So you are correct of course.

I've added this patch to the rdma tree to fix the missing locking.

The merge resolution will be simply swapping
for_ifa to in_dev_for_each_ifa_rtnl.

Jason

From c421651fa2295d1219c36674c7eb8c574542ceea Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@mellanox.com>
Date: Thu, 11 Jul 2019 11:29:42 -0300
Subject: [PATCH] RDMA/siw: Add missing rtnl_lock around access to ifa

ifa is protected by rcu or rtnl, add the missing locking. In this case we
have to use rtnl since siw_listen_address() is sleeping.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw=
/siw_cm.c
index 8e618cb7261f62..c25be723c15b64 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1975,6 +1975,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
 			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
=20
+		rtnl_lock();
 		for_ifa(in_dev)
 		{
 			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
@@ -1989,6 +1990,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 			}
 		}
 		endfor_ifa(in_dev);
+		rtnl_unlock();
 		in_dev_put(in_dev);
 	} else if (id->local_addr.ss_family =3D=3D AF_INET6) {
 		struct inet6_dev *in6_dev =3D in6_dev_get(dev);
--=20
2.21.0

