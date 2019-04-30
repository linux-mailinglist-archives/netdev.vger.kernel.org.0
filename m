Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE78F40B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 12:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfD3KQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 06:16:15 -0400
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:63987
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726145AbfD3KQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 06:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVBYl4adfJw9avAY7gAeEW3zKUJvaL6L7QfhAggpSOY=;
 b=lKJI4XL0Vi8uSs+HXV6XTjqSqb5BQEAosh1M6a2ID1B+MI9lZ7DjN7g8PqLP7RHHJSStIQl01E6+1Mu5GMC8TXxhcTNdpTmuuBE63f3vM3Is6Pdn/4ea3X15tmrxVn/SvNgIwLdCuUwBvEZVGuVR0YWzA1u4Wzr/RqkhZzQ3Ims=
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) by
 AM0PR05MB5668.eurprd05.prod.outlook.com (20.178.116.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.13; Tue, 30 Apr 2019 10:16:10 +0000
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1]) by AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 10:16:10 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mlxsw: Remove obsolete dependency on THERMAL=m
Thread-Topic: [PATCH -next] mlxsw: Remove obsolete dependency on THERMAL=m
Thread-Index: AQHU/zcWbVmtSGdyfka9Vz2WRuHnz6ZUfQUA
Date:   Tue, 30 Apr 2019 10:16:10 +0000
Message-ID: <20190430101608.GB6343@splinter>
References: <20190430092832.7376-1-geert+renesas@glider.be>
In-Reply-To: <20190430092832.7376-1-geert+renesas@glider.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:205:1::39) To AM0PR05MB6497.eurprd05.prod.outlook.com
 (2603:10a6:208:13f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9633eb7e-cd1b-4f15-d57e-08d6cd54dde1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5668;
x-ms-traffictypediagnostic: AM0PR05MB5668:
x-microsoft-antispam-prvs: <AM0PR05MB5668EFFDF1B6CF8DCBAD0B42BF3A0@AM0PR05MB5668.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(189003)(6116002)(11346002)(66066001)(66446008)(6486002)(66946007)(102836004)(476003)(86362001)(3846002)(256004)(26005)(6506007)(186003)(71200400001)(73956011)(71190400001)(446003)(14444005)(64756008)(1076003)(386003)(33716001)(4744005)(486006)(66556008)(68736007)(66476007)(229853002)(5660300002)(8676002)(6436002)(305945005)(6246003)(33656002)(8936002)(6512007)(53936002)(81166006)(81156014)(76176011)(97736004)(25786009)(9686003)(7736002)(4326008)(478600001)(54906003)(52116002)(316002)(2906002)(14454004)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5668;H:AM0PR05MB6497.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Pu5JHGbshK5Ff5dvh79QdFNfjpqLiF3JH6cLxfr0Ss9FJ5yQqWNJEcgMxzfBdBLWL38HkFvq04Seg8K290ZS2N6gzjpbg7WcxMAn3rFIKjk0oqAhGlIwYH41CYLZvGdcCRLOyPT400Mhy6pSkLJpxNlBdlBKMEaRotp2/cEpkFCwLee2l+XFuyuL8cDlNtuNk3/oGfnIB6ps1gC/AxaWgu70rqmRh4iir1A90kJpho/ed7xk0R5EOBy6p2LkVo91Hh0/0hi+PN1M1Ix0piQbQC19KXAZO4Ri4wF2VtYbJG5+1jhuN9caqH7/I6/9EGe2ycyJ3sy3vYdX1oDLMxYmmsQAlDnoHoP0YhNcCjbt+faHhKrnb1vBTVoxmacd4mEqIier2X+aXKIoxRdKZ9GNW7IKWZnufZEHnZTFTGpsOxI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <323BFEDD0C772C4F9395BE241D4B9385@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9633eb7e-cd1b-4f15-d57e-08d6cd54dde1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 10:16:10.6353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5668
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 11:28:32AM +0200, Geert Uytterhoeven wrote:
> The THERMAL configuration option was changed from tristate to bool, but
> a dependency on THERMAL=3Dm was forgotten, leading to a warning when
> running "make savedefconfig":
>=20
>     boolean symbol THERMAL tested for 'm'? test forced to 'n'
>=20
> Fixes: be33e4fbbea581ea ("thermal/drivers/core: Remove the module Kconfig=
's option")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>

I assume this will be applied to the thermal tree?
