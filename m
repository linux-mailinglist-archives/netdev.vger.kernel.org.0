Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB97CA7444
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfICUI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:08:27 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:12007
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbfICUI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:08:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO5IJrNPi5g+dvKRv4qQJ9tls5Iv5GCZwhhDV2g/o8ZaO6wwu3oZ51u+lo5uW240hKBNdfB5SYm+2by1nEy74RcEaJFeisjfhyBzCJXr/UPO16AjFNKBjtNb20WvoaEd3tkPUAzQguiDINKosE+Sq5VvLG4GzPPcekeazVNNXRVCwXCfpGMp2APJZqSrQYLjtNEpYhV2jvOrrge5WG9I69szNn0yjv8OZ2YG6ce0o7aZSuXcrofN3jav5/6BuYkNG4VlLkdaz5ZGcRMHA+Ir2qZiY64Zs1KPnEuHJVj6I6sAOrLfI/t3/BCYaFFKsDcklW3+UjjHgtQot2n8cYwsWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZti72z3CsdmRRLIisv/ZsJzf5ZPry+WS0UFCC/ttEQ=;
 b=RBgeDSqIGSutVO9cGmoZxuFqIhPWNlgUe7LI6JDWGl6BrTq0Uyn2F09Dk4HU3QXuxVxUhDOMEBc2iPXXM083OlJi2MS3uF/8QD+/mrgDrYL8lJnXBU9uwEeFgqizm7LCs0fse/t18Dw3/XJlk4oPUwjl11Avw5obK2HWYPrFFkgd+7RBVZ1TFzfjOZwWDyHuGrDMIwJBvO6Wss8y/1iB/evm5RtYWgAUSk4bXGv6M16VQIJ8Hm7ntJ5Dr+NuPpHoDaJ1MMKUgSxk3CFG3lKp7N2wT3WuyTsGl7ErPEvLX+XrgbXXkZKecZNgSRVkBycBWR26CJYPCtnmTjnBTFiSCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZti72z3CsdmRRLIisv/ZsJzf5ZPry+WS0UFCC/ttEQ=;
 b=BJo+SvDbp0dNewInuKgcmGW+K6u6iKg3JFo35bGL/8TXOte9T95ZMEXsNEjjL1T4ec3dUc9ZIW1IWIo/EGuN17vbk08kaz68VTMKdoFXIXfr92n2xKIYOi3SCDBZtLIhMzBSBYas4U1d/AwtLJnE7JKIQ6NfiOjnDQQbsAAptAk=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2612.eurprd05.prod.outlook.com (10.172.221.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 3 Sep 2019 20:08:22 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:08:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [net-next 01/18] net/mlx5: Add flow steering actions to fs_cmd
 shim layer
Thread-Topic: [net-next 01/18] net/mlx5: Add flow steering actions to fs_cmd
 shim layer
Thread-Index: AQHVYV87T8tleZGT5UquhfNqVzZ076cYwVgAgAGikYA=
Date:   Tue, 3 Sep 2019 20:08:21 +0000
Message-ID: <8f98e4a3df82d90853ae776fba8e8ece3fdeea3c.camel@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
         <20190902072213.7683-2-saeedm@mellanox.com>
         <20190902.121012.1434735697208917415.davem@davemloft.net>
In-Reply-To: <20190902.121012.1434735697208917415.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cd78be5-78fa-4830-9efe-08d730aa7880
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2612;
x-ms-traffictypediagnostic: AM4PR0501MB2612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26123E1D5CB9DACDC10C142BBEB90@AM4PR0501MB2612.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(6916009)(8676002)(14454004)(6246003)(91956017)(76116006)(8936002)(6436002)(5640700003)(81166006)(1730700003)(81156014)(99286004)(66946007)(446003)(11346002)(186003)(2616005)(6512007)(6486002)(6116002)(76176011)(478600001)(86362001)(102836004)(486006)(3846002)(5660300002)(26005)(305945005)(53936002)(7736002)(316002)(107886003)(6506007)(476003)(229853002)(2501003)(71200400001)(36756003)(71190400001)(66066001)(2906002)(58126008)(25786009)(4326008)(54906003)(4744005)(66476007)(2351001)(118296001)(66556008)(66446008)(64756008)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2612;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t+GD0+4DFmFStsdRDx+KnivynWXdjtaqTvWcdqXmkL0vYaNhtyQrC5m+75u45eHXsbggevIHkg1xy/93lh/UuJaF7Zb2ifWqF9vUCUVfrWGEZk4JO7BCBpvMWuxHMx4E1f1pFZTUYvmFoaH2zJVg9BIuEVD1OOv7Y/NGlAKU64QCju606Wp6ajwOtgRRwbOnSmy3U8O4Gd3CKFZxvSCgFF+nBK6hXwTsDBUEe8S0NFxD2u6W88fk7RQzyIT27gVPGoqFKq+1pwdIbeEmwLq80/RbtAu2b4Y4j/3cS20S3o88B49bdasrvHeWHRfOvI1loEcD/yQ9ZIsASz+JzF+r8UeJEiwEcW9NobAF1q+C1HDmTMxuuluDYOA0s88wQA9Hb+wqw9S82YORSy6GO+SFHet4cD6Ree7SzAQgKx/S22c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <00744EC208655942A28370A3BDB9F48A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd78be5-78fa-4830-9efe-08d730aa7880
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:08:21.8474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OlqYrtm57WKkfDmYvrLyYndE8BdOTVvE7WET5X8jxYnbYCMM1BPq4WF2MkjRRASp0D/lo60QrfL7MbeCJcEYpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTAyIGF0IDEyOjEwIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBNb24s
IDIgU2VwIDIwMTkgMDc6MjI6NTIgKzAwMDANCj4gDQo+ID4gKyAgICAgbWFjdGlvbi0+Zmxvd19h
Y3Rpb25fcmF3LnBrdF9yZWZvcm1hdCA9DQo+ID4gKyAgICAgICAgICAgICBtbHg1X3BhY2tldF9y
ZWZvcm1hdF9hbGxvYyhkZXYtPm1kZXYsIHBybV9wcnQsIGxlbiwNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGluLCBuYW1lc3BhY2UpOw0KPiA+ICsgICAgIGlm
IChJU19FUlIobWFjdGlvbi0+Zmxvd19hY3Rpb25fcmF3LnBrdF9yZWZvcm1hdCkpDQo+ID4gICAg
ICAgICAgICAgICByZXR1cm4gcmV0Ow0KPiANCj4gRG9uJ3QgeW91IGhhdmUgdG8gaW5pdGlhbGl6
ZSAncmV0JyB0byB0aGUgcG9pbnRlciBlcnJvciBoZXJlPw0KPiANCj4gVGhpcyB0cmFuc2Zvcm1h
dGlvbiBkb2Vzbid0IGxvb2sgY29ycmVjdC4NCg0KUmlnaHQhIGZpeGVkIGluIFYyLg0KDQpUaGFu
a3MhDQo=
