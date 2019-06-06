Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B123436F92
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfFFJLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:11:33 -0400
Received: from mail-eopbgr50072.outbound.protection.outlook.com ([40.107.5.72]:49509
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727450AbfFFJLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 05:11:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZfgt2fsNPO4/UwN/nqlk8TNxXWs2Wte1N+3oIlaSDc=;
 b=fDwgG3TkWFCr2L0k31Gf8ZlAo6SZga/Mpdxg6qYuoGuUSgkL2WfETgJZbfMz2LHdkqDWtzDOFPK+aHJTXo+G83NoaMRmt8/W/yGLm5FtsrbhUudNal/8nldYcx7LjhqijiIq03Al0ds1JZVShiwVQZdLLAa9SBXk13d2SHm4VPY=
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com (20.177.119.89) by
 AM6SPR01MB0043.eurprd05.prod.outlook.com (20.177.199.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 09:11:29 +0000
Received: from AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae]) by AM6PR05MB5524.eurprd05.prod.outlook.com
 ([fe80::7c3e:66d:ba41:e9ae%5]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 09:11:29 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Topic: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Index: AQHVGgXQARZCv5VopEC1fl5DvasR4KaLjGoAgAFjk4CAAGLdAIAAGYUAgACBN4CAAG4BAA==
Date:   Thu, 6 Jun 2019 09:11:29 +0000
Message-ID: <98e33c30-2f9c-277a-6a6a-6d9668a6c8ba@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
 <20190604141724.rwzthxdrcnvjboen@localhost>
 <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
 <20190605172354.gixuid7t72yoxjks@localhost>
 <78632a57-3dc7-f290-329b-b0ead767c750@mellanox.com>
 <20190606023743.s7im2d3zwgyd7xbp@localhost>
In-Reply-To: <20190606023743.s7im2d3zwgyd7xbp@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
x-clientproxiedby: AM6PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:20b:6e::15) To AM6PR05MB5524.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e::25)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c09a7bb4-f13b-43ad-73d1-08d6ea5ef5c9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6SPR01MB0043;
x-ms-traffictypediagnostic: AM6SPR01MB0043:
x-microsoft-antispam-prvs: <AM6SPR01MB004380BAACFA80EC1D28B245C5170@AM6SPR01MB0043.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(376002)(39860400002)(396003)(189003)(199004)(6246003)(6436002)(6486002)(31686004)(107886003)(3846002)(6116002)(64126003)(26005)(14454004)(486006)(71200400001)(11346002)(65826007)(68736007)(4326008)(1411001)(25786009)(229853002)(65956001)(66066001)(65806001)(2906002)(58126008)(66446008)(31696002)(446003)(6506007)(53546011)(102836004)(8676002)(386003)(476003)(2616005)(86362001)(53936002)(256004)(478600001)(99286004)(52116002)(71190400001)(305945005)(76176011)(54906003)(7736002)(6512007)(5660300002)(8936002)(6916009)(186003)(66946007)(64756008)(81156014)(66476007)(66556008)(81166006)(36756003)(316002)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6SPR01MB0043;H:AM6PR05MB5524.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sb7FwwGcVJcvLLQo0Sda88uBtiImp+HfBJgfG2lYhc+ACHO54Hu9IxA6Vq34W2itMWazIp4koVTDGm2NwL/0sDeK4v6oIUOodPQ7W8+95CB4VUkHIEOZVZzsrqesyW+6PmK8Eb27PegNX1M4uN6SRUcXkb644VuSSGE0bavw2VoYGXQHZKGmql21JDPJvXZg3M6Vl29zapo9T/YjhfAHo4GU3I7PQ75h/Y56ueO0QWuEZ5Y9kPabIehNCu+n3ba2tnO/ztpsrwPBgQpKtEJdtOeaq/e/2itV7VyA2mPEdjDoKTOBTjZvCY5Xl8lUYM0zYDAeXTz8ua2fjL2VKfKjRbp3PEnGYr7Ig7lIZej5HOe+I2gni9v0PoLJvztNmDBOO9qNCTcsbLAOLB4XxSkUPEvEiPeIZyOlrepxeKRgycc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA00351296171C4BB2C4AE82268F4840@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09a7bb4-f13b-43ad-73d1-08d6ea5ef5c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 09:11:29.3667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: shalomt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0043
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYvMDYvMjAxOSA1OjM3LCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6DQo+IE9uIFdlZCwgSnVu
IDA1LCAyMDE5IGF0IDA2OjU1OjE4UE0gKzAwMDAsIFNoYWxvbSBUb2xlZG8gd3JvdGU6DQo+PiBP
biAwNS8wNi8yMDE5IDIwOjIzLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6DQo+Pj4gT24gV2VkLCBK
dW4gMDUsIDIwMTkgYXQgMTE6MzA6MDZBTSArMDAwMCwgU2hhbG9tIFRvbGVkbyB3cm90ZToNCj4+
Pj4gT24gMDQvMDYvMjAxOSAxNzoxNywgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPj4+Pj4gT24g
TW9uLCBKdW4gMDMsIDIwMTkgYXQgMDM6MTI6MzlQTSArMDMwMCwgSWRvIFNjaGltbWVsIHdyb3Rl
Og0KPj4+Pj4+IEZyb206IFNoYWxvbSBUb2xlZG8gPHNoYWxvbXRAbWVsbGFub3guY29tPg0KPj4+
Pj4+DQo+Pj4+Pj4gVGhlIE1UVVRDIHJlZ2lzdGVyIGNvbmZpZ3VyZXMgdGhlIEhXIFVUQyBjb3Vu
dGVyLg0KPj4+Pj4NCj4+Pj4+IFdoeSBpcyB0aGlzIGNhbGxlZCB0aGUgIlVUQyIgY291bnRlcj8N
Cj4+Pj4+DQo+Pj4+PiBUaGUgUFRQIHRpbWUgc2NhbGUgaXMgVEFJLiAgSXMgdGhpcyBjb3VudGVy
IGludGVuZGVkIHRvIHJlZmxlY3QgdGhlDQo+Pj4+PiBMaW51eCBDTE9DS19SRUFMVElNRSBzeXN0
ZW0gdGltZT8NCj4+Pj4NCj4+Pj4gRXhhY3RseS4gVGhlIGhhcmR3YXJlIGRvZXNuJ3QgaGF2ZSB0
aGUgYWJpbGl0eSB0byBjb252ZXJ0IHRoZSBGUkMgdG8gVVRDLCBzbw0KPj4+PiB3ZSwgYXMgYSBk
cml2ZXIsIG5lZWQgdG8gZG8gaXQgYW5kIGFsaWduIHRoZSBoYXJkd2FyZSB3aXRoIHRoaXMgdmFs
dWUuDQo+Pj4NCj4+PiBXaGF0IGRvZXMgIkZSQyIgbWVhbj8NCj4+DQo+PiBGcmVlIFJ1bm5pbmcg
Q291bnRlcg0KPiANCj4gT2theSwgc28gdGhlbiB5b3Ugd2FudCB0byBjb252ZXJ0IGl0IGludG8g
VEFJIChmb3IgUFRQKSByYXRoZXIgdGhhbiBVVEMuDQoNCk5vLCB0aGUgSFcgaW50ZXJmYWNlIGlz
IGluIFVUQyBmb3JtYXQuIFRoaXMgaXMgcGFydCBvZiB0aGUgSFcgbWFjaGluZSB0aGF0DQpyZXNw
b25zaWJsZSBmb3IgYWRkaW5nIHRoZSBVVEMgdGltZSBzdGFtcGluZyBvbiBSLVNQQU4gbWlycm9y
IHBhY2tldHMuDQoNCj4gDQo+IFRoYW5rcywNCj4gUmljaGFyZA0KPiANCg0K
