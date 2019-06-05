Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 550DD35B47
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfFELaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:30:10 -0400
Received: from mail-eopbgr40068.outbound.protection.outlook.com ([40.107.4.68]:30628
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726280AbfFELaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 07:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlIySXDBFhpfIfIDPu4LFw+//wKFhpy8l8RHYan3p/g=;
 b=rbmaiiJYlY2XQBZ7my3D7dfIX5QrwnEnnwFH1iiAp0KvgYBkuaJnViyb15CHhZjI2CkPYsUEQlfpL4Nd0Cctshnem5fi+AinmTEROoUNckZXpjEQo/ZQ5hnt6ndeqDR9L9Q4sNI/GkCVckctoqGbcbgA7S2FQn/qyAzoYV4XesQ=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB5158.eurprd05.prod.outlook.com (20.177.196.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Wed, 5 Jun 2019 11:30:06 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 11:30:06 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Topic: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Index: AQHVGgXQARZCv5VopEC1fl5DvasR4KaLjGoAgAFjk4A=
Date:   Wed, 5 Jun 2019 11:30:06 +0000
Message-ID: <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
 <20190604141724.rwzthxdrcnvjboen@localhost>
In-Reply-To: <20190604141724.rwzthxdrcnvjboen@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: AM6PR10CA0033.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::46) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f56b6b7-121a-47c6-4630-08d6e9a928c7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5158;
x-ms-traffictypediagnostic: AM6PR05MB5158:
x-microsoft-antispam-prvs: <AM6PR05MB5158CDC557BD0091198A8DA8C5160@AM6PR05MB5158.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(366004)(39860400002)(376002)(136003)(199004)(189003)(305945005)(26005)(66446008)(86362001)(73956011)(66946007)(6486002)(4744005)(64126003)(102836004)(52116002)(54906003)(58126008)(31686004)(229853002)(99286004)(14454004)(446003)(486006)(65806001)(53546011)(11346002)(476003)(110136005)(186003)(66066001)(508600001)(2616005)(76176011)(65956001)(2906002)(386003)(25786009)(6512007)(316002)(31696002)(107886003)(7736002)(36756003)(81166006)(8676002)(81156014)(8936002)(65826007)(68736007)(3846002)(6116002)(66556008)(64756008)(6436002)(71200400001)(71190400001)(4326008)(6506007)(66476007)(5660300002)(256004)(6246003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5158;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nzeV+C004df0wNDQsR8yfwSktZjUyhHRTmAwh+9+RPCzfNP2Spyj8nK2mchu3WY2cuvjT5rHtTvea0u22smTD/qqvgPHr37dpfXGWvMNtWfyHkhCKQwuJihjSWDSa6hyagAfMa5dsRWYNg1U0stcGGq0tUl2LX7wV9dyCAtFA1wAl2EQWYxdWNeXcvMNxO0hONRPetlMRhK8Yt9HWN5c1M1+sJYGRQR6kE81VfUZuzLaz6JXfCq+SpylGXJq+RYi2XFo383KFOBW3QMlFrqqDgTqOMUFsnYLjeYsz4cI5l6kUwHJtErBUW5Q0sf/49guVwdM4nM+WWRl3sWwWhjVHd0qjgs26AzFHLWUxhiKrPgaYsfihkoSieDQw2IOxsTFHNl3BCsmGFumeLRKfYaAyRo2OILKZ/P5qzfiJCgUxQ0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD44746CFBFBE14A82F30C2414116BDD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f56b6b7-121a-47c6-4630-08d6e9a928c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 11:30:06.4855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDYvMjAxOSAxNzoxNywgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBPbiBNb24sIEp1
biAwMywgMjAxOSBhdCAwMzoxMjozOVBNICswMzAwLCBJZG8gU2NoaW1tZWwgd3JvdGU6DQo+PiBG
cm9tOiBTaGFsb20gVG9sZWRvIDxzaGFsb210QG1lbGxhbm94LmNvbT4NCj4+DQo+PiBUaGUgTVRV
VEMgcmVnaXN0ZXIgY29uZmlndXJlcyB0aGUgSFcgVVRDIGNvdW50ZXIuDQo+IA0KPiBXaHkgaXMg
dGhpcyBjYWxsZWQgdGhlICJVVEMiIGNvdW50ZXI/DQo+IA0KPiBUaGUgUFRQIHRpbWUgc2NhbGUg
aXMgVEFJLiAgSXMgdGhpcyBjb3VudGVyIGludGVuZGVkIHRvIHJlZmxlY3QgdGhlDQo+IExpbnV4
IENMT0NLX1JFQUxUSU1FIHN5c3RlbSB0aW1lPw0KDQpFeGFjdGx5LiBUaGUgaGFyZHdhcmUgZG9l
c24ndCBoYXZlIHRoZSBhYmlsaXR5IHRvIGNvbnZlcnQgdGhlIEZSQyB0byBVVEMsIHNvDQp3ZSwg
YXMgYSBkcml2ZXIsIG5lZWQgdG8gZG8gaXQgYW5kIGFsaWduIHRoZSBoYXJkd2FyZSB3aXRoIHRo
aXMgdmFsdWUuDQoNCj4gDQo+PiArLyogTVRVVEMgLSBNYW5hZ2VtZW50IFVUQyBSZWdpc3Rlcg0K
Pj4gKyAqIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+ICsgKiBDb25maWd1cmVz
IHRoZSBIVyBVVEMgY291bnRlci4NCj4+ICsgKi8NCj4+ICsjZGVmaW5lIE1MWFNXX1JFR19NVFVU
Q19JRCAweDkwNTUNCj4+ICsjZGVmaW5lIE1MWFNXX1JFR19NVFVUQ19MRU4gMHgxQw0KPiANCj4g
VGhhbmtzLA0KPiBSaWNoYXJkDQo+IA0KDQo=
