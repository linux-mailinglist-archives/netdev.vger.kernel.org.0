Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F2535BED
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfFELqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:46:53 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:20866
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727460AbfFELqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 07:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGE09xvkeYWIcLaJ3x1xck+4Obbfj9Zs2o7nkZDv+fg=;
 b=k91pA8A84FsWBnJ4rGwh3i/Z6R/M0ZvWUMVbvK14CG46HsVIfK0xAZ/a9QahdP5e94tLVsPUv/VkOwVsgjsgtWG/O6W7M10Em84wiPr9G0buEr/VvDWv9DG1zE33whoZzjNktbWTHQuQ5AZzeJ+sjS6qkGNX/5y5bzCWWXPm3Ds=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6PR05MB5410.eurprd05.prod.outlook.com (20.177.118.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Wed, 5 Jun 2019 11:46:49 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Wed, 5 Jun 2019
 11:46:49 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 6/9] ptp: ptp_clock: Publish scaled_ppm_to_ppb
Thread-Topic: [PATCH net-next 6/9] ptp: ptp_clock: Publish scaled_ppm_to_ppb
Thread-Index: AQHVGgXS2qS4Q1z1XkuIjSt+eP87y6aLjXGAgAFnNwA=
Date:   Wed, 5 Jun 2019 11:46:48 +0000
Message-ID: <1ec59a66-2975-0372-6de1-3fca72baf43d@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-7-idosch@idosch.org>
 <20190604142105.5ckgkxshu4lcy6zc@localhost>
In-Reply-To: <20190604142105.5ckgkxshu4lcy6zc@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: AM6P194CA0056.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::33) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c75685c9-2b4b-4e43-947c-08d6e9ab7e5a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5410;
x-ms-traffictypediagnostic: AM6PR05MB5410:
x-microsoft-antispam-prvs: <AM6PR05MB5410E8585310EF2EFD632218C5160@AM6PR05MB5410.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(53936002)(6436002)(2616005)(58126008)(4744005)(6512007)(6486002)(71190400001)(65806001)(65956001)(256004)(54906003)(7736002)(316002)(110136005)(68736007)(14444005)(5660300002)(66446008)(64756008)(73956011)(66946007)(64126003)(486006)(66066001)(66556008)(476003)(66476007)(11346002)(446003)(186003)(26005)(6506007)(53546011)(36756003)(71200400001)(31686004)(6116002)(76176011)(52116002)(4326008)(107886003)(99286004)(3846002)(25786009)(6246003)(14454004)(8936002)(305945005)(2906002)(229853002)(508600001)(102836004)(65826007)(386003)(8676002)(31696002)(81166006)(81156014)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5410;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Lk7JkmxH9lkPuMUKU1TQ0TtIbmQdjYp7nLxyaZRCRo8Vp+/4oy6QQTSAE2056qql8Ayy0arOlNRxX8+d4rkrav0A/Mgcz01MMR8dLsuBjcauw3iWKcR8Fa1CFixLlfPjDaIPpLtreTwAYS8XPgY6ROENpUuch7wRJGWvjAaE1enwcCJGnP4Ajw79yvu57Lfxv9G4nEZuYdt4Nw3NjOf9JJcQ5Hf54nL5K/hd8z082pmzGwzQX47NfGvyAss9nPGVz5PNvxnfBJHs4jz/rPJtF5wIKcOw+kqXdhQIQqLt+WBWca5ViIpgNFefTc07eHxzAjxW51+MMESX60r3YCACqJ/87dVY7ip7y0GytuN3zfxJ/m8Zpt1AGn7B/aBWIyoItbZKxKjdJuOccS8Fba+h7zDeHFtk8Vlix1tg84ahSXI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA381155F732144DAE227B37EFF2BD12@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75685c9-2b4b-4e43-947c-08d6e9ab7e5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 11:46:49.0067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5410
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDYvMjAxOSAxNzoyMSwgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBPbiBNb24sIEp1
biAwMywgMjAxOSBhdCAwMzoxMjo0MVBNICswMzAwLCBJZG8gU2NoaW1tZWwgd3JvdGU6DQo+PiBG
cm9tOiBTaGFsb20gVG9sZWRvIDxzaGFsb210QG1lbGxhbm94LmNvbT4NCj4+DQo+PiBQdWJsaXNo
IHNjYWxlZF9wcG1fdG9fcHBiIHRvIGFsbG93IGRyaXZlcnMgdG8gdXNlIGl0Lg0KPiANCj4gQnV0
IHdoeT8NCg0KU2VlIG15IGNvbW1lbnQgaW4gcGF0Y2ggIzcNCg0KPiANCj4+IEBAIC02Myw3ICs2
Myw3IEBAIHN0YXRpYyB2b2lkIGVucXVldWVfZXh0ZXJuYWxfdGltZXN0YW1wKHN0cnVjdCB0aW1l
c3RhbXBfZXZlbnRfcXVldWUgKnF1ZXVlLA0KPj4gIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZx
dWV1ZS0+bG9jaywgZmxhZ3MpOw0KPj4gIH0NCj4+ICANCj4+IC1zdGF0aWMgczMyIHNjYWxlZF9w
cG1fdG9fcHBiKGxvbmcgcHBtKQ0KPj4gK3MzMiBwdHBfY2xvY2tfc2NhbGVkX3BwbV90b19wcGIo
bG9uZyBwcG0pDQo+IA0KPiBTaXggd29yZHMgaXMgYSBsaXR0bGUgYml0IG11Y2ggZm9yIHRoZSBu
YW1lIG9mIGEgZnVuY3Rpb24uDQoNCkkgY2FuIG1ha2UgaXQgc2NhbGVkX3BwbV90b19wcGIoKSBh
cyBiZWZvcmUuIElzIHRoYXQgb2s/IG9yIG1heWJlIHlvdSBoYXZlDQpzb21ldGhpbmcgZWxzZSBp
biB5b3VyIG1pbmQ/DQoNCj4gDQo+IFRoYW5rcywNCj4gUmljaGFyZA0KPiANCg0K
