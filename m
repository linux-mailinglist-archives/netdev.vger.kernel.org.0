Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6513717787C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgCCOMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:12:07 -0500
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:40162
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727848AbgCCOMG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:12:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVSJMd4tmlR1DIHI5JeIHE8RTXjH7u80aRxb5rG0USCDApS07NnTHxg8Z6Bnc12uQ0f7bgBcdsA97kRdpoqVgAt3eS+VxSpNJOnxbDE78CesVYLoLRclQedBwOXrMjb6jew82zHd1r/uwEKXWUQV2/foIfKDugciWv+frM7KPq/rd1nhohPTvYvZ0P3jcwlQ+/Tjofp6x4Yn5q2JfK3XFuOyiM7avkUQ5hRiAhO6GHmts/UqXNg/tW+glP/koTkEt73F5FSZCjx6m2PCuKIzGwjKE+mg4BTq0QgRmbckSv+yVWosNAnu3OWhX3YPBi+c+CbHx85top6K+uOPlyaWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B10ZJVGa0Df0h39LzqpYgSHiaT69AMklFgDPCuFyL4I=;
 b=T/Dx1QoftAJkn9hgmSTpBkrmG/b+S2Gn0H1IbSUS8bU0V7BwShevwatAqYg+/MKTrMhnxkR/nErWMKsnN1Z2QEm0wipPZ2TaRwAsU191BOMoSRp8bSsiHcur2KFwwqKUPY5godUvX2F+EKwLz4UaSAjjWMA7KlHflQzFLlh+pKw9+oZtWP0omsewnC1inbLGHpPpHqrDUDIAJCCSSWTzt6gqEJPR1rDk22vS+WHkoo1zq/08sHJBw+CTznE8fSoVQASUQaCv546r8TRhIfcgdYE/TiTBCPPctY7D8Z6OvJPl86QyX6mjm4BOChiond+G4/fw40vNcyvyewNhtkHvJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B10ZJVGa0Df0h39LzqpYgSHiaT69AMklFgDPCuFyL4I=;
 b=kdCYutgaH7iKdJZOZbbg5H0Wc844GCzJVRDLeMiA/uCDU0JGmZnbiecVxe+V4N2USg9/HJWrcz/Nx89mNiu+IjVYeSRFymXn0r/2UlTQLQ2B6A39OkoqPoj32XnWXwmJqz/BhTOJkIMudELzeIzEusZ+fyNt5sTEpwmmJp+qXaM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Tue, 3 Mar 2020 14:12:02 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:12:02 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH] Revert "RDMA/cma: Simplify rdma_resolve_addr() error
 flow"
Thread-Topic: [PATCH] Revert "RDMA/cma: Simplify rdma_resolve_addr() error
 flow"
Thread-Index: AQHV8WVPU60gLmZ1b0e4fPt+YpA4y6g26JBA
Date:   Tue, 3 Mar 2020 14:12:02 +0000
Message-ID: <AM0PR05MB48668B3E447EEEF97708FB58D1E40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200303140834.7501-1-parav@mellanox.com>
 <20200303140834.7501-5-parav@mellanox.com>
In-Reply-To: <20200303140834.7501-5-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:5121:27a4:7e98:56ad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c204ffca-1d84-447c-46c9-08d7bf7cd895
x-ms-traffictypediagnostic: AM0PR05MB6497:|AM0PR05MB6497:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6497E2E0BB12F4D8DD31FB9ED1E40@AM0PR05MB6497.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:242;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(199004)(189003)(66446008)(6506007)(52536014)(64756008)(186003)(54906003)(71200400001)(8676002)(9686003)(66556008)(81166006)(66476007)(7696005)(76116006)(81156014)(66946007)(478600001)(110136005)(316002)(2906002)(5660300002)(33656002)(4744005)(86362001)(55016002)(4326008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6497;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OLXQmb106iKdVtwjoUXCD1cjjD8nEmRTiKvO+pLWL/im2Qj9G6Tj2jNbwlcMl+78G8c6gaZv4B281cUy1NMtrFy3fijWNZguJ9+2KiXpMnHBBqB3nKuwsiJf5JCkZdwv6xNw/v+0cfEYFuhHk+DogKLZxD0hfaWmj2ecZoQeY8gxPKFRYY+E5dDn2hXY2i8M5OrjfPRbJ2Akpy6KTj9LICtDcxo9oh5XHavmtjY1qvLbnVbr2KE95A1jNF7aDfHM6V0giDJVMlGAUoUSxHgxyVjzmJpQdE8XTfBtY585Biw2UmKJi3EDYWAyY/TiUd8LayfnIRDtnLZ7Uslh+xgfme9g9o9uDi9iQngh/nMnv9dTohuYTvFSg4ZMMxx7MDPcotETHGkRRb7Txn+71ULa/uB/Rji3dU4Gob4KJ14PoVzRc00Cl7h2+oBEtnZVq/5g
x-ms-exchange-antispam-messagedata: aBhiRR1f+M11zdfPnpF31FBiTHWiB/8u3ZEUtn+Y+Ab+rG4cX1RI3nuOHmEKe6VZWX0WUQBLHAlrQx1GyvONYNQkFu3fFyyMJhWoDs+mveOkgv0Uf4BVapHq8B0F4/pwO4pwBvBxxio4SbkxIcnbBf9KyrtjgnOkqbWYJ2huaeEEWrPzL/GZdeQcUxdr8uwmZgXjjhurEPGZcabJ39P+XQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c204ffca-1d84-447c-46c9-08d7bf7cd895
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 14:12:02.5296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Tn8Sb/v2sqLZ8U9J/5t9q5b8aaGD6I1DDNlkBZWfMTz6OSOSqJ5cUyr0tUtVnb1f7WL8jjIU0w7pQCgxRqnaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6497
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Sent: Tuesday, March 3, 2020 8:09 AM
> To: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> Moshe Shemesh <moshe@mellanox.com>; Vladyslav Tarasiuk
> <vladyslavt@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> leon@kernel.org
> Subject: [PATCH] Revert "RDMA/cma: Simplify rdma_resolve_addr() error
> flow"
>=20
> This reverts commit 219d2e9dfda9431b808c28d5efc74b404b95b638.

Please ignore the noise of this unrelated patch. Sent from wrong directory.
Sorry for the noise.
