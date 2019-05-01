Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E53810E24
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEAUiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:38:15 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:2020
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbfEAUiP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8mOqfbONlBtaRUGOG0XrzN1+dh5elZ/h950rU1w2bQ=;
 b=hgMZ+NANBnoncXE/ZeNe3X1om/Vc+w0pVxHNThaGw4j4BfBTsiTtc52d6BHpxfqjzEKwG78aXwJ+C/aYyceu4B8kQQW/mGlxvjW7jPqspGNt8JkFYF3TEWWhK3EgzyHyOjbZgm4ZB5tmuYXO3CIpUWvo+ekB7Cv0WchPUciXc6Q=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6074.eurprd05.prod.outlook.com (20.179.8.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Wed, 1 May 2019 20:38:09 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 20:38:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "cai@lca.pw" <cai@lca.pw>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>
CC:     Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>
Subject: Re: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
Thread-Topic: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
Thread-Index: AQHU/7x3anEbYe1OEkSKNFSZpIM6U6ZVlKQAgAAHLwCAALfngIAAaF2A
Date:   Wed, 1 May 2019 20:38:09 +0000
Message-ID: <ff52b0ea5ff69eda631f2fea932bb1f37cbbc732.camel@mellanox.com>
References: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw>
         <CALzJLG-TgHP8tgv_1eqYmWjpO4nRD3=7QRdyGXGp1x_qQdKErg@mail.gmail.com>
         <CALzJLG-5ZXeOrOa3rsVEF0nHrfkxJ=65nEH2H7Sfa9pYyDpmRg@mail.gmail.com>
         <1556720675.6132.15.camel@lca.pw>
In-Reply-To: <1556720675.6132.15.camel@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b8edeaf-d796-4598-1b3c-08d6ce74ec34
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6074;
x-ms-traffictypediagnostic: DB8PR05MB6074:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <DB8PR05MB6074088BB7D3BAB217C4FEAABE3B0@DB8PR05MB6074.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(51914003)(2501003)(110136005)(8676002)(6436002)(66066001)(6486002)(58126008)(316002)(54906003)(53546011)(4744005)(4326008)(966005)(6306002)(186003)(478600001)(36756003)(2906002)(71200400001)(71190400001)(25786009)(6246003)(229853002)(66446008)(256004)(26005)(6512007)(305945005)(68736007)(14454004)(8936002)(6506007)(6116002)(11346002)(107886003)(86362001)(3846002)(446003)(64756008)(5660300002)(66476007)(76116006)(118296001)(2616005)(66556008)(81166006)(76176011)(53936002)(91956017)(102836004)(81156014)(66946007)(476003)(73956011)(99286004)(7736002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6074;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W8W3Pg3/CxHmjdZb6z6RaGKWdVt+ym49S5KSCFMm/CnjRogOd/I02LO25VdER3tlnbj8xuROda1iX1nouMvfDWBWkOtb+HLeiI7Gm9h9P0iki6FDwLFeYnYfht0Rov3mnIS4piCkNct+wpvKYbYsA2/c7O79Dgzp4ffuaoTc7J6LU5UI7a4EQOd/F2eWr/ro43PMin8FgMI1AzgTlIL13/9us7tgd1zmddTbsyzmOgdYcQ5eJI6ieUG2JBKrmakDbo6RGuVYM9fYXeD7DUDMG/zLhcVeKx8TOx0Omu/7C4CipaFvQQmV/Hi9UglbOWQaN2FSBat9+JXyCh1pS1NDD+djQ2BVO6InUzg7/F7IGc7E82Tci0QsQWD37R2nvr2yCcP6GcO2n5GPguJzVKmH7MXBbgcpXDggrVodcXSRfo8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D29E9F7CA9F1C445821B0DF2E6C0338D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8edeaf-d796-4598-1b3c-08d6ce74ec34
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 20:38:09.2719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTAxIGF0IDEwOjI0IC0wNDAwLCBRaWFuIENhaSB3cm90ZToNCj4gT24g
VHVlLCAyMDE5LTA0LTMwIGF0IDIwOjI2IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4g
PiBPbiBUdWUsIEFwciAzMCwgMjAxOSBhdCA4OjAwIFBNIFNhZWVkIE1haGFtZWVkDQo+ID4gPHNh
ZWVkbUBkZXYubWVsbGFub3guY28uaWw+IHdyb3RlOg0KPiA+ID4gT24gVHVlLCBBcHIgMzAsIDIw
MTkgYXQgNjoyMyBQTSBRaWFuIENhaSA8Y2FpQGxjYS5wdz4gd3JvdGU6DQo+ID4gPiA+IFJldmVy
dGVkIHRoZSBjb21taXQgYjE2OWU2NGEyNDQ0ICgibmV0L21seDU6IEdlbmV2ZSwgQWRkIGZsb3cN
Cj4gPiA+ID4gdGFibGUNCj4gPiA+ID4gY2FwYWJpbGl0aWVzDQo+ID4gPiA+IGZvciBHZW5ldmUg
ZGVjYXAgd2l0aCBUTFYgb3B0aW9ucyIpIGZpeGVkIHRoZSBwcm9ibGVtIGJlbG93DQo+ID4gPiA+
IGR1cmluZyBib290DQo+ID4gPiA+IGVuZHMgdXANCj4gPiA+ID4gd2l0aG91dCBuZXR3b3JraW5n
Lg0KPiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gSGkgUWlhbiwgdGhhbmtzIGZvciB0aGUgcmVwb3J0
LCBpIGNsZWFybHkgc2VlIHdoZXJlIHRoZSBpc3N1ZSBpcywNCj4gPiA+IG1seDVfaWZjX2NtZF9o
Y2FfY2FwX2JpdHMgb2Zmc2V0cyBhcmUgYWxsIG9mZiAhIGR1ZSB0byBjaXRlZA0KPiA+ID4gcGF0
Y2gsDQo+ID4gPiB3aWxsIGZpeCBBU0FQLg0KPiA+ID4gDQo+ID4gDQo+ID4gSGkgUWlhbiwgY2Fu
IHlvdSBwbGVhc2UgdHJ5IHRoZSBmb2xsb3dpbmcgY29tbWl0IDoNCj4gPiANCj4gPiBbbWx4NS1u
ZXh0XSBuZXQvbWx4NTogRml4IGJyb2tlbiBoY2EgY2FwDQo+ID4gb2Zmc2V0MTA5MzU1MWRpZmZt
Ym94c2VyaWVzDQo+ID4gaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wYXRjaC8xMDkzNTUx
Lw0KPiA+IA0KPiA+ICQgY3VybCAtcyBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNo
LzEwOTM1NTEvL21ib3gvIHwgZ2l0DQo+ID4gYW0NCj4gDQo+IFllcywgaXQgd29ya3MgZ3JlYXQh
DQoNCkdyZWF0ICEgdGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLg0K
