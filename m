Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA3F5D51D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfGBRS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:18:56 -0400
Received: from mail-eopbgr20083.outbound.protection.outlook.com ([40.107.2.83]:58821
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725996AbfGBRSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 13:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=s+pOJgs6FfteJSXNLVpxGw6W3pFNV3DvqF7s6bDo6VUwsNn/3YG+8wmDgKrgRAAodVquC92QMoYMwdCIvFejZyyJNfCaC3mURXM5CXRnLZO/T/3RIG8F1k9vc8wt7NxB6249hC2w8GuFeMKWbIYjt7qb2aWGie6VXv4ObxZt95Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmIlm6xEIMmFbkM1A7wBkIz/Akj5xm6bc7tNPaQwXTM=;
 b=yRd39sk3CAyosX0Ch+NsWUgHBZKFpg7Oh5J0XcH3ERH9U7CH1lBFHOp0EwWcCskvJJGVGGfJSe6yNvt9seRkbpKG0yQD2paLNN/V64TZLZrsW4Fi4uSwBuh+uoI4NUmnQcPxxykVMGFWMfp9ZUbYWVvH6DTQJPxntVpZcTxM3Eo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmIlm6xEIMmFbkM1A7wBkIz/Akj5xm6bc7tNPaQwXTM=;
 b=LCfhl9N2Jxz1bTAcUf3lA2/jTew+SvVPNUhkNAVlQBWe+fEBT2KMlSemGW7BtiRdnecUS+yw+4H5niVH/VPjzWrVL8OcGsDIwT7JfFIeoeyatXC+rDizeqmymu1+h/txkDYuiWFvT4F8lhBzHDd5TCbdlLD6FFyOBiBm0Yto+GU=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5714.eurprd05.prod.outlook.com (20.178.113.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.18; Tue, 2 Jul 2019 17:18:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 17:18:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Thread-Topic: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Thread-Index: AQHVMOnVNNDimR9Hpkq8DMdGSDDj46a3f82AgAAAQcCAAAojAIAABvVQ
Date:   Tue, 2 Jul 2019 17:18:52 +0000
Message-ID: <AM0PR05MB4866CBFB93C42453068376DED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190702152056.31728-1-skalluru@marvell.com>
 <20190702161133.GP30468@lunn.ch>
 <AM0PR05MB4866D7B26F48AF0BED9055EED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164844.GA28471@lunn.ch>
In-Reply-To: <20190702164844.GA28471@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8554a12-4a65-4f2d-d652-08d6ff115b0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5714;
x-ms-traffictypediagnostic: AM0PR05MB5714:
x-microsoft-antispam-prvs: <AM0PR05MB571400CAE759CC22B113F184D1F80@AM0PR05MB5714.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(13464003)(199004)(189003)(305945005)(7736002)(4744005)(446003)(52536014)(486006)(11346002)(476003)(7696005)(14454004)(478600001)(6246003)(186003)(76176011)(53936002)(26005)(229853002)(5660300002)(33656002)(66066001)(102836004)(6436002)(6916009)(74316002)(55236004)(9686003)(55016002)(53546011)(4326008)(6506007)(8936002)(8676002)(71190400001)(71200400001)(316002)(256004)(99286004)(68736007)(2906002)(73956011)(76116006)(66556008)(64756008)(66446008)(66946007)(9456002)(78486014)(6116002)(3846002)(81156014)(66476007)(81166006)(54906003)(25786009)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5714;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o/sOEpCI1cFZTZfkBTBxC9XLD2/OyIuIu/J3ztkgDKuLcXoPtsGoeyvCzCQ0YmQAm5UdU6riAlXXKk//CdoWoSs4+GZtboW17F+xeGcZal99fteCD6Q6UmHFDShW+m9g4RDrhteIqwnGm8K0dn14sYlwcg6GZli5BkfuzrTz6M+2z7WcmeDQeVrIEuQpSzVtd4JrRn/VMU0YeikaY1A0y3MYae9GTXWTd8iJYdEAEqFUAn9bXNreOAJG4DfYqJX+WrHlnVzp/5paauNSK8TRSk92oNft9xHs1EQru/oOH7a9qWqkR+9+XddrH1VwFFbcZl1IcZ+EhTSgZ0cCNt1gHq1fUVdJIpOqEZ9ybn1/w9QWmY/YqvdOEgEBIB6NqAMLwto2fCunAyKFzao7TMjn6wQuvjvA/KeHDdv0x1AxgW0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8554a12-4a65-4f2d-d652-08d6ff115b0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 17:18:52.5835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5714
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, July 2, 2019 10:19 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>; davem@davemloft.net;
> netdev@vger.kernel.org; mkalderon@marvell.com; aelior@marvell.com;
> jiri@resnulli.us
> Subject: Re: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish =
the
> port parameters.
>=20
> > A vendor driver calling these APIs is needed at minimum.
>=20
> Not a vendor driver, but a mainline driver.
>=20
My apologies for terminology.
I meant to say that a NIC/hw driver from the kernel tree that created the d=
evlink port should call this API (as user) in the patch.
You said it rightly below. Thanks.

> But yes, a new API should not be added without at least one user.
>=20
>     Andrew
