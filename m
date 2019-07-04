Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A55585F7DB
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbfGDMSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:18:34 -0400
Received: from mail-eopbgr50052.outbound.protection.outlook.com ([40.107.5.52]:7126
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727690AbfGDMSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/Iu+IoK/xNj9hBW/b4B/HKwNKNy1oQe36Qw2/VqlE8=;
 b=r/J3ac3NZEySdeViFsvwfFn/tO8TSAIZra+kEaTlF+e8mv2+TVE5JHU2NYc5eOiVK0xVxnTSWoSBPMWhe+DrtDiKgcm8T9oTx2rhw8bdhF/w7zSy4rD8UpJ4iSphcebR3FqBsOXL7+XRpwQ3vvBsMmECfRzxn+Rp05JIwqRRjtg=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4237.eurprd05.prod.outlook.com (52.133.12.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 12:18:30 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 12:18:30 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>
Subject: Re: [rdma 1/1] RDMA/irdma: Add Kconfig and Makefile
Thread-Topic: [rdma 1/1] RDMA/irdma: Add Kconfig and Makefile
Thread-Index: AQHVMg3uzv9+6kVYH0utLhTDfE9uLaa6YQ0A
Date:   Thu, 4 Jul 2019 12:18:29 +0000
Message-ID: <20190704121826.GC3401@mellanox.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-2-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190704021259.15489-2-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR0102CA0048.prod.exchangelabs.com
 (2603:10b6:208:25::25) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2053e7f1-98be-4fe5-a4dc-08d70079b954
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4237;
x-ms-traffictypediagnostic: VI1PR05MB4237:
x-microsoft-antispam-prvs: <VI1PR05MB4237BDC292216CCC73341960CFFA0@VI1PR05MB4237.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(199004)(189003)(25786009)(76176011)(478600001)(54906003)(6512007)(99286004)(102836004)(52116002)(73956011)(66556008)(6436002)(229853002)(68736007)(386003)(66476007)(6506007)(6486002)(64756008)(5660300002)(7416002)(6916009)(316002)(6246003)(66946007)(26005)(66446008)(81156014)(53936002)(446003)(11346002)(2616005)(486006)(305945005)(2906002)(36756003)(66066001)(4326008)(33656002)(86362001)(3846002)(6116002)(186003)(81166006)(8936002)(476003)(4744005)(8676002)(7736002)(256004)(71200400001)(71190400001)(1076003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4237;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m0Y2leONHdio/Wv5AKMDP70OlmbrP2a3TSZ9IHRCSauyAEn6N7eynSQmmNzJP7XOSRaXpEz/VXd64u1LdlmdnqtqOpgyVKBTezPaeSnlD/AD69ZmW69vmI/8+CtB7eV67meNKKI7dMLRK197atMUA49VVcTr3QTBc6xULshsEyK09xLQyNseGyJPgOXUQnUTv1iR5S0PzltTnzog5x2Ruy9JaCOlJdhSszkY1S5ETwX6Pdub77tpZT8mLAuJOwagosMwqdrT0+Jm0J7mO2HA+ooN1SG9mLbrq7FxR+aXC+bPRkRgzuHON9rTQDXSG69fnwDtbYEERwGhJHUGVvNzGI3tfG3raT/SL0QgqgIM6TquPsg8PXjCwrlMZSDjCp6JDTZdKW8jnSCAxC8Y07H/T7cUelWAR5zpmRSH0EPYw1g=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0857AED569BE4A478B56770ED538CF26@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2053e7f1-98be-4fe5-a4dc-08d70079b954
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:18:29.9277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 07:12:43PM -0700, Jeff Kirsher wrote:
> From: Shiraz Saleem <shiraz.saleem@intel.com>
>=20
> Add Kconfig and Makefile to build irdma driver and mark i40iw
> deprecated/obsolete, since the irdma driver is replacing it and supports
> x722 devices.

Patch 1/1? Series looks mangled...

> diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/=
i40iw/Kconfig
> index d867ef1ac72a..7454b84b74be 100644
> +++ b/drivers/infiniband/hw/i40iw/Kconfig
> @@ -1,8 +1,10 @@
>  config INFINIBAND_I40IW
> -	tristate "Intel(R) Ethernet X722 iWARP Driver"
> +	tristate "Intel(R) Ethernet X722 iWARP Driver (DEPRECATED)"
>  	depends on INET && I40E
>  	depends on IPV6 || !IPV6
>  	depends on PCI
> +	depends on !(INFINBAND_IRDMA=3Dy || INFINIBAND_IRDMA=3Dm)

No.. all drivers must be able to build at once. At least add some
COMPILE_TEST in here to enable building.

Jason
