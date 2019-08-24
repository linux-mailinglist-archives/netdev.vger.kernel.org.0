Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCBF9BBD5
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 06:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfHXEpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 00:45:44 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:6049
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfHXEpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 00:45:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=har4WHCvP4HtKSDD4IX7w5Y8fe3BZmimwoo1I45yOJQKnonJRbP78tSaTdml6gvIq53HpQBceap1AEcYjvkWiQy7Sob1dWO4PyK7LZqIwOyxEz9pQTUwbTrhO42lHsri/FCO0gxi4l+2kGeE/uH8oof7NkLcit+QHxOoit4jfFmdNaWXQ61jb8JqgVyRoUT5GmYmGe59dkH9L8N56zIyCoHoz8mUtXvWb5pZbQ7pmvx0bjpUi5ATWJz3dIStKbsc6f04Z0fozwu/MSUJe9uq+kf2cSyExeXfPsDPHxox6iP7rvcYAuYCgBD+5uZhoxDdGPssaI7F6PfiUmfAF6KFww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCUHwGbz/VVxA1+F92cZgCBF30GyVanu2e/qxAZ7ydM=;
 b=Ig/jzIMnqT55UfQr8fRkukjsPbYNSUOI6LF7NqLF1QzPgU6y8iKP+3YQcNVZRKFEltdTELrXT7/F/nW0OGrTs2CCo3uHdx3amj2AHWb+yYlrB5hq5ntFQ9gH/T2LLsRvfnANrFQPCUjj/PTbhPCeCZGamta4ipJup/3arC5sEvqePW94OsAp/BxDqbBEuFPAwb6hMhF6jqNHDt6BoVKMhhkPU66uPjsEp2fGWCB5cxuoFDPLqfvD7LLp49+pXjSMa4AIWyw9iuZC39uVABhy8BvlKOWfRY8Eygo4apgMLd6dzd3i6StHsccQ3n6WBHFl9XY1C/mKqtmmzg+eYoITsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCUHwGbz/VVxA1+F92cZgCBF30GyVanu2e/qxAZ7ydM=;
 b=Zin80qcMRB1FYzpsg3th/hw3eqelmQj3Ejqb/jEUrqt8TK/VOdyDduaP0+9NmiTV9v+rtYTohZt0k3GYHkoFraHTPZTn3edoQaUWaPYLrPD+wjtfFpwcGDM46+9mAdjY9MFAo9G5JKuovA4EtaeeepWW1dp682hrhNwt6KinsXE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6274.eurprd05.prod.outlook.com (20.179.32.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.20; Sat, 24 Aug 2019 04:45:25 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 04:45:25 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAAnVNggAAbk4CAAAOYgIAABpwAgAAAVrCAAAfEAIAADNCggAHJU4CAAAIMEIAABiaAgAAA2ACAACadAIAAFGdwgAE42YCAAABasIAAaLIAgAAC1QCAABSugIAAA+pAgAATnYCAAAO7UIAAJVKAgACGAeCAABAIQA==
Date:   Sat, 24 Aug 2019 04:45:25 +0000
Message-ID: <AM0PR05MB48666AE325759E51D0737F04D1A70@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822092903.GA2276@nanopsycho.orion>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823082820.605deb07@x1.home>
        <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823095229.210e1e84@x1.home>
        <AM0PR05MB4866E33AF7203DE47F713FAAD1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823111641.7f928917@x1.home>
        <AM0PR05MB486648FF7E6624F34842E425D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190823134337.37e4b215@x1.home>
 <AM0PR05MB4866008B0571B90DAFFADA97D1A70@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866008B0571B90DAFFADA97D1A70@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24082db6-526d-425d-8b6d-08d7284de147
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6274;
x-ms-traffictypediagnostic: AM0PR05MB6274:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB62741EBC426BC3297E6E18C3D1A70@AM0PR05MB6274.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(189003)(199004)(13464003)(5660300002)(9456002)(486006)(14454004)(4326008)(86362001)(8936002)(81156014)(81166006)(476003)(8676002)(66476007)(7696005)(186003)(66946007)(33656002)(6506007)(53546011)(26005)(102836004)(55236004)(53936002)(74316002)(54906003)(99286004)(6116002)(7736002)(110136005)(11346002)(478600001)(3846002)(6436002)(76176011)(66066001)(316002)(2906002)(256004)(71200400001)(71190400001)(14444005)(446003)(6246003)(52536014)(25786009)(2940100002)(305945005)(55016002)(9686003)(66446008)(66556008)(76116006)(64756008)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6274;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e7jtmWnB549hcmbRZTnKiMSAFv61tnU3SeERshJ6KPPWfxi9u//LwcHD6/SMVOzPKab/VzQMI6/29xQ5bJeE+P7Q7WvUwDMkSFd/vv518BnaKFv51vyjAYne6oAFEsR7THFk2prdX8/fXjgMMOmhDJOvuDD8wYFoR48EIzx5E4zTHnWKEF2sCX2dzyi3wv33NMG2mxmDEvea4vM6rGeIJoQ6Iolvb5rM9AppyGbOnjILeKiHQEtyOqfH66+gwAbpNmmssYkWzzG3bGXpIlmjU7pkafPe+VIChWKrcrAkH6e5N3ehA8sCGM8jH04QkcwR9/tB5JHGR1oQ6bXH/bhtFC5k1UH+u8Lvd/U81mBT6jC3+hVa0m8w4uxUJY8oJ98s2geCFRW7z+3IzaqCb6nQV/dckbwGMkgJQLm9pks5iIo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24082db6-526d-425d-8b6d-08d7284de147
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 04:45:25.2390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbQ8onFBG7Do4MipSeseDbga8qxCeuFZN9TUwgRREQhnscR80+bJL3Z5FAUkVegpKtuHmsuMuk7tm30ghWpCoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6274
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Parav Pandit
> Sent: Saturday, August 24, 2019 9:26 AM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David =
S .
> Miller <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>;
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > I don't understand this logic.  I'm simply asking that we have a way
> > to test the collision behavior without changing the binary.  The path
> > we're driving towards seems to be making this easier and easier.  If
> > the vendor can request an alias of a specific length, then a sample
> > driver with a module option to set the desired alias length to 1-char m=
akes
> it trivially easy to induce a collision.
> Sure it is easy to test collision, but my point is - mdev core is not sha=
1 test
> module.
> Hence adding functionality of variable alias length to test collision doe=
sn't
> make sense.
> When the actual user arrives who needs small alias, we will be able to ad=
d
> additional pieces very easily.

My initial thoughts to add parent_ops to have bool flag to generate alias o=
r not.
However, instead of bool, keeping it unsigned int to say, zero to skip alia=
s and non-zero length to convey generate alias.
This will serve both the purpose with trivial handling.


