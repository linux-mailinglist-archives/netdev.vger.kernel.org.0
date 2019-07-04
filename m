Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89385FC53
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfGDRQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:16:07 -0400
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:47568
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727374AbfGDRQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 13:16:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zMOJjsBWtcI1lRTCC0AQ/aq67/+xOkKaODW/sIl/uk=;
 b=KSuOhijjRHAgQRxdM/uU3yfgjPvfwifuyN9It/V0Q7HLlShTNYAALvqcy5Assx/Y4l91SD4e++0E70LZ8Jcac9G2ol2XWz/A0OjLuR3HN/7AxAffVTesfSWwWvF0nEIyqvxLM26wm6P8UInLe6WkZPs7idbii1UquQROB2RRoc4=
Received: from VI1PR05MB3152.eurprd05.prod.outlook.com (10.170.237.145) by
 VI1PR05MB4368.eurprd05.prod.outlook.com (52.133.13.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 17:16:02 +0000
Received: from VI1PR05MB3152.eurprd05.prod.outlook.com
 ([fe80::1044:d313:989:d54d]) by VI1PR05MB3152.eurprd05.prod.outlook.com
 ([fe80::1044:d313:989:d54d%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 17:16:02 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates 2019-07-02
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 low level updates
 2019-07-02
Thread-Index: AQHVMXJveOPdXjGEB0qnqkH/hqttvKa6s9IAgAABkIA=
Date:   Thu, 4 Jul 2019 17:16:02 +0000
Message-ID: <20190704171555.GF7212@mtr-leonro.mtl.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
 <5c85e7cd688cc8727f421e4592304e66ccd018c7.camel@mellanox.com>
In-Reply-To: <5c85e7cd688cc8727f421e4592304e66ccd018c7.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM7PR02CA0005.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::15) To VI1PR05MB3152.eurprd05.prod.outlook.com
 (2603:10a6:802:1b::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.3.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e9e228a-58bc-4cb7-efa4-08d700a34a57
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4368;
x-ms-traffictypediagnostic: VI1PR05MB4368:
x-microsoft-antispam-prvs: <VI1PR05MB4368D5F7DDD9922A3D97571DB0FA0@VI1PR05MB4368.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(53754006)(189003)(199004)(386003)(14454004)(6506007)(25786009)(3846002)(86362001)(6486002)(6116002)(6246003)(68736007)(2906002)(6862004)(4744005)(1076003)(66066001)(186003)(305945005)(229853002)(7736002)(102836004)(446003)(478600001)(486006)(6636002)(66446008)(64756008)(81156014)(66946007)(15650500001)(81166006)(8676002)(5660300002)(33656002)(73956011)(8936002)(6436002)(54906003)(71200400001)(71190400001)(66556008)(52116002)(53936002)(316002)(99286004)(26005)(76176011)(66476007)(450100002)(4326008)(11346002)(476003)(256004)(14444005)(9686003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4368;H:VI1PR05MB3152.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R/hQ5jPA3Dqr0uvjgMJ1uA5l0y58ufTYMzj5IqPU35xYyZGVNNz/295RgRJugWpcyeNh+c2sFdC9s2M8S5cdL84QvEW/EgRcTBHFHiyGvir9UFsYi3kP6CAjQS8D3zUzcY+j6Gzsl+lUVn6+FAsnHN35apWp+to8U+t+tE6+Ah+/k12YDzHyZc6gjxg9ZRM5L2ii1UxNhn4Z7/rvZO1f0fqQ6cqyabj+2JoL13u6/gihcWYZ5ijmaJOfgED8UtCoZngzvjPT8eSFRbdITEFtv5NYqv6umEYZCYLnwTN+bHJUhoiLwFGFqJUIyvmv+3PI5IaQQ4SQWmPKXJSjN+4IZLLYx/c7zoWAZT9uYoXM4hsLd45Engn9hvEVKDwhDIcI9ibXJCvF2XyLpUp3HtnsHVOwrS4+QnoDCO3aoR/jWw8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F308DEEEFBE6C84EAC465AD858160053@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9e228a-58bc-4cb7-efa4-08d700a34a57
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 17:16:02.6149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 05:10:25PM +0000, Saeed Mahameed wrote:
> On Wed, 2019-07-03 at 07:39 +0000, Saeed Mahameed wrote:
> > Hi All,
> >
> > This series includes some low level updates to mlx5 driver, required
> > for
> > shared mlx5-next branch.
> >
> > Tariq extends the WQE control fields names.
> > Eran adds the required HW definitions and structures for upcoming TLS
> > support.
> > Parav improves and refactors the E-Switch "function changed" handler.
> >
> > In case of no objections these patches will be applied to mlx5-next
> > and
> > will be sent later as pull request to both rdma-next and net-next
> > trees.
> >
> > Thanks,
> > Saeed.
>
> Applied to mlx5-next.

Saeed,

Please fix IFC, before you are pushing it out.

Thanks

>
