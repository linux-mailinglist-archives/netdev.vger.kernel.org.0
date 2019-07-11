Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B965022
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 04:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfGKC0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 22:26:34 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:47683
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727463AbfGKC0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 22:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cHZ/Mps1zGGP9xyKCK8tVrmFAOOIRvyJHupP4h9TpA=;
 b=RjuMwksX9sQRs8XWAaMe8kemSsHFIUWUdruL8ZGwS1/Lunvv9N1TEUMrY/tfgcOhvXQep6B7vhPLCQ5r+xinq/0URMr2VBfDzbzW9yzWVfbMi5hFWQwgPZXWVrMLgaU+XhVs/iUDksrLW39QVkuNBxvEhZg8TTmAwdymN/G6NE4=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4143.eurprd05.prod.outlook.com (10.171.182.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 02:26:27 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 02:26:27 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Leon Romanovsky <leon@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVNgpSNqxsVllq5U23Am+RwOaE5KbB1zsAgAJNFwCAAIW/AIAAAj0A
Date:   Thu, 11 Jul 2019 02:26:27 +0000
Message-ID: <20190711015854.GC22409@mellanox.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
 <20190709064346.GF7034@mtr-leonro.mtl.com>
 <20190710175212.GM2887@mellanox.com>
 <20190711115054.7d7f468c@canb.auug.org.au>
In-Reply-To: <20190711115054.7d7f468c@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTBPR01CA0026.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0833b2fe-25a9-4878-caa2-08d705a72d5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4143;
x-ms-traffictypediagnostic: VI1PR05MB4143:
x-microsoft-antispam-prvs: <VI1PR05MB4143DC4685EE9625AD8C1890CFF30@VI1PR05MB4143.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(189003)(199004)(316002)(6246003)(99286004)(6916009)(386003)(7736002)(52116002)(305945005)(33656002)(26005)(66066001)(6512007)(8936002)(102836004)(6116002)(186003)(53936002)(6506007)(76176011)(8676002)(3846002)(486006)(36756003)(476003)(2616005)(25786009)(4326008)(5660300002)(68736007)(4744005)(11346002)(66946007)(54906003)(478600001)(81156014)(81166006)(66446008)(64756008)(66556008)(66476007)(71190400001)(71200400001)(2906002)(6436002)(229853002)(1076003)(446003)(86362001)(6486002)(14454004)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4143;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LsXKwomZ/109ut7p8RyH71RqfhZB8ZJ01V6oo8nQ4S7Emw1fiNyymzElHzJGMlphr5K7aIBxIdbHYaH3LMG1Gg/Ks1EoQR08X1vH8UhN113YXB/eV+J0ueE2Zw0WREZ+ZWD1LAGugCbWOkZrKxmp55fdEfJ132ApemNGjNah92Mvjax3v6bZTmc3J3yhI5JJWbE3P8Z8PYyB64zifYxSvdvMigv2XKhJj5Xjns2eweDrVjccpTYVK+zTODzYcGZQJxbVdPGgQLLuNPpY614M/eUNAsvQ+kDk0hPo8PVhtsrE3oQn3MCjDqKbUlTQvV4i91Q8B0wO1z1RB8jt7JVIwwKGoc9Dx+I9lyJfsQ+/CLCGP+IA8x0jZ1rdcV8EtWn56Zzvnf981bqb7JD1afwHtpsVr55WTpgYIJqwTL1BbLw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D8D34EB44B9AF4C89FE0F2F428FB111@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0833b2fe-25a9-4878-caa2-08d705a72d5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 02:26:27.7122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 11:50:54AM +1000, Stephen Rothwell wrote:

> So today this failed to build after I merged the rdma tree (previously
> it didn;t until after the net-next tree was merged (I assume a
> dependency changed).  It failed because in_dev_for_each_ifa_rcu (and
> in_dev_for_each_ifa_rtnl) is only defined in a commit in the net-next
> tree :-(

? I'm confused..=20

rdma.git builds fine stand alone (I hope!)

If you merge it with netdev then the above patch is needed afer the
merge as netdev changed to ifa_rcu

I just did this a few hours ago to make and test the patch I sent
above..

Jason
