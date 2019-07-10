Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EBD64BB3
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfGJRwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:52:22 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:24238
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727408AbfGJRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 13:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc7Jp0Wlbf6OzPHbtl28tNHq8sRgqzMBeSHd9wn7pVY=;
 b=WhjhX2wK5XkML+iWCREX2dtjsTBlXd+aOkYDLwdlz1o9V++RxuBKa2bn+EeWmRmmwLP8pff06WzIyzq2k43JSByCMD5ojZHaCB5s9pOfVoJguDlggLfvTgvnJHegDQ+QA3XamIQuCwo8rwpeYr55hh01+2EIBWCGHu/ZiHB3oFQ=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5903.eurprd05.prod.outlook.com (20.178.125.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Wed, 10 Jul 2019 17:52:17 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 17:52:17 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
CC:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVNgpSNqxsVllq5U23Am+RwOaE5KbB1zsAgAJNFwA=
Date:   Wed, 10 Jul 2019 17:52:17 +0000
Message-ID: <20190710175212.GM2887@mellanox.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
In-Reply-To: <20190709064346.GF7034@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: QB1PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:2d::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5bcd310-b785-497e-8ba3-08d7055f5968
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5903;
x-ms-traffictypediagnostic: VI1PR05MB5903:
x-microsoft-antispam-prvs: <VI1PR05MB590395EE512D3F73A096D59CCFF00@VI1PR05MB5903.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(53754006)(199004)(189003)(1076003)(5660300002)(14454004)(66446008)(6116002)(76176011)(54906003)(110136005)(26005)(386003)(6506007)(53546011)(3846002)(99286004)(66476007)(52116002)(66556008)(64756008)(86362001)(66946007)(102836004)(478600001)(316002)(6246003)(2906002)(53936002)(486006)(476003)(2616005)(4326008)(68736007)(66066001)(229853002)(186003)(81166006)(81156014)(8936002)(8676002)(7736002)(71190400001)(256004)(6512007)(6486002)(36756003)(14444005)(11346002)(446003)(25786009)(33656002)(71200400001)(6436002)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5903;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6tB3yH4JflnOpESEmCKv2qAt1HyWxX+XuWUPuw2xg2aCOyJ6qE0RliW1cZCwPhR+i/Uij0zGtXuVGGsa9ou17jNrccDAva3C3lW/RrysAERXYHOVI++MWEETghi+qPC0JG7NZmSeWYHz08gWRCA6jSk+VgNLvWga4Jyj/RVcfuHn+ATzm5LxVqAZgIYOMjYcy+ldtcaJteg/y2DuQlQyKGzkFhXocnsMNQXmfgMClk/Lkk8Wv+TdKR7E7yMk3Ih+3/Gzi+VR5GiQsfmJUx4Hyg0GsizCzNL4UBcnMDY5plAY/Zyct1FxrKeHCRu3nEOH2hqGH4xM8x481kipz9tCZI7iN7+zs0CaBhRLNL8fRZ3NsGXNAdYxVxc+4bJsZXESUdSvjLcq/OVmGpvb8Jb/1HRq064+EK22m4oTiYnzV4U=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A009C5F7EF45F44B725B00AE5D926EA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bcd310-b785-497e-8ba3-08d7055f5968
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 17:52:17.8438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5903
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 09:43:46AM +0300, Leon Romanovsky wrote:
> On Tue, Jul 09, 2019 at 01:56:36PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the net-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > drivers/infiniband/sw/siw/siw_cm.c: In function 'siw_create_listen':
> > drivers/infiniband/sw/siw/siw_cm.c:1978:3: error: implicit declaration =
of function 'for_ifa'; did you mean 'fork_idle'? [-Werror=3Dimplicit-functi=
on-declaration]
> >    for_ifa(in_dev)
> >    ^~~~~~~
> >    fork_idle
> > drivers/infiniband/sw/siw/siw_cm.c:1978:18: error: expected ';' before =
'{' token
> >    for_ifa(in_dev)
> >                   ^
> >                   ;
> >    {
> >    ~
> >
> > Caused by commit
> >
> >   6c52fdc244b5 ("rdma/siw: connection management")
> >
> > from the rdma tree.  I don't know why this didn't fail after I mereged
> > that tree.
>=20
> I had the same question, because I have this fix for a couple of days alr=
eady.
>=20
> From 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00 2001
> From: Leon Romanovsky <leonro@mellanox.com>
> Date: Sun, 7 Jul 2019 10:43:42 +0300
> Subject: [PATCH] Fixup to build SIW issue
>=20
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index 8e618cb7261f..c883bf514341 100644
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1954,6 +1954,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
>  int siw_create_listen(struct iw_cm_id *id, int backlog)
>  {
>  	struct net_device *dev =3D to_siw_dev(id->device)->netdev;
> +	const struct in_ifaddr *ifa;
>  	int rv =3D 0, listeners =3D 0;
>=20
>  	siw_dbg(id->device, "id 0x%p: backlog %d\n", id, backlog);
> @@ -1975,8 +1976,7 @@ int siw_create_listen(struct iw_cm_id *id, int back=
log)
>  			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
>  			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
>=20
> -		for_ifa(in_dev)
> -		{
> +		in_dev_for_each_ifa_rcu(ifa, in_dev) {
>  			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||

Hum. There is no rcu lock held here and we can't use RCU anyhow as
siw_listen_address will sleep.

I think this needs to use rtnl, as below. Bernard, please urgently
confirm. Thanks

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw=
/siw_cm.c
index 8e618cb7261f62..ee98e96a5bfaba 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1965,6 +1965,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 	 */
 	if (id->local_addr.ss_family =3D=3D AF_INET) {
 		struct in_device *in_dev =3D in_dev_get(dev);
+		const struct in_ifaddr *ifa;
 		struct sockaddr_in s_laddr, *s_raddr;
=20
 		memcpy(&s_laddr, &id->local_addr, sizeof(s_laddr));
@@ -1975,8 +1976,8 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
 			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
=20
-		for_ifa(in_dev)
-		{
+		rtnl_lock();
+		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
 			    s_laddr.sin_addr.s_addr =3D=3D ifa->ifa_address) {
 				s_laddr.sin_addr.s_addr =3D ifa->ifa_address;
@@ -1988,7 +1989,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 					listeners++;
 			}
 		}
-		endfor_ifa(in_dev);
+		rtnl_unlock();
 		in_dev_put(in_dev);
 	} else if (id->local_addr.ss_family =3D=3D AF_INET6) {
 		struct inet6_dev *in6_dev =3D in6_dev_get(dev);
