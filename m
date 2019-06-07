Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D355339410
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbfFGSOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:14:18 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:40129
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730946AbfFGSOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 14:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4Cv0jc5a0nuwTfhb3hFMPGQ6x/nAXM/QAYlxFLPeoY=;
 b=ZsSQaky8svPoRzYzOaJsqRHExAwxkA9CBCqvysVFQ7cyU1Lg6qEZv8/j6zcLGPl1p9smVtVzyx+CljAtBj9SJrc4w3X7696/ukGnzMAC0Z3pL7jE6QY1+ZrlE4q2e47sF7thrGhKJA6ylUkY7t2zKGTIFhDrcetg/DCYfirHXsY=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5963.eurprd05.prod.outlook.com (20.179.10.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Fri, 7 Jun 2019 18:14:11 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 18:14:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Thread-Topic: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Thread-Index: AQHVG/XTn2LcR9xgMkG6p2oMks5Qt6aONwiAgAABdoCAAGEZgIAB6BeA
Date:   Fri, 7 Jun 2019 18:14:11 +0000
Message-ID: <9faeadac971aaf481b1066b1dde0fc9e77e893a5.camel@mellanox.com>
References: <20190605232348.6452-1-saeedm@mellanox.com>
         <20190606071427.GU5261@mtr-leonro.mtl.com>
         <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
         <20190606130713.GC17392@mellanox.com>
In-Reply-To: <20190606130713.GC17392@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90939510-d7c5-40e5-2aa5-08d6eb73f0e5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5963;
x-ms-traffictypediagnostic: DB8PR05MB5963:
x-microsoft-antispam-prvs: <DB8PR05MB596384422B604EF40322E62ABE100@DB8PR05MB5963.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(39860400002)(376002)(136003)(396003)(199004)(189003)(25786009)(8676002)(256004)(6116002)(14444005)(81156014)(478600001)(85306007)(4326008)(6486002)(6246003)(110136005)(54906003)(14454004)(53936002)(58126008)(66476007)(305945005)(66066001)(8936002)(118296001)(7736002)(316002)(71190400001)(76116006)(91956017)(68736007)(81166006)(86362001)(66946007)(73956011)(76176011)(99286004)(2616005)(476003)(102836004)(6506007)(66446008)(66556008)(71200400001)(3846002)(64756008)(229853002)(186003)(36756003)(446003)(6512007)(6436002)(11346002)(6636002)(5660300002)(26005)(486006)(2906002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5963;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oTaY8tNCwb6ikWQhlfUV9Ha451lSouJx7BBIvCwO/Ew0q/U3jxEtXc30t+v+/7e2RIznsHHBSNOXFeLplzCEweck8yIfLq7yopIbJSkrcZEVu6KWq6+EveAYTiksldxyBT0Z8HQzcsK3isAYZqzVbQ0iYe1b+TWL2Ta4eiY34P8xb67YELEHV+qBd9mHTozua8VaeFZwKyveVjEP1pT6V/4Uc10JHZ7u7LRcjQtD0hGEs3BBYoi3sbi+4/DwhXDdhU0xiSce4okcnkRETsBkaOffGfiYAr8RpLa6gwKV0LNMF2nZ3BKrXwonPSLSJLVakmrzQ3CqwrOLUMugBrBAjMK7O4UFoJlmx8Ahaqil3N+0l746ai5DUurUBxPq6NR/IdFMXaRg9I6oz34AUlZZTWSnSCdeb6dOW2Wjohzjty4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A0DC2BB92C7FF45BDE44F866FEB6869@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90939510-d7c5-40e5-2aa5-08d6eb73f0e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 18:14:11.3491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5963
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA2LTA2IGF0IDEzOjA3ICswMDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFRodSwgSnVuIDA2LCAyMDE5IGF0IDEwOjE5OjQxQU0gKzAzMDAsIE1heCBHdXJ0b3Zv
eSB3cm90ZToNCj4gPiA+ID4gU29sdXRpb246DQo+ID4gPiA+IC0gQ29tbW9uIGxvZ2ljIGlzIGRl
Y2xhcmVkIGluIGluY2x1ZGUvbGludXgvZGltLmggYW5kDQo+ID4gPiA+IGltcGxlbWVudGVkIGlu
DQo+ID4gPiA+ICAgIGxpYi9kaW0vZGltLmMNCj4gPiA+ID4gLSBOZXQgRElNIChleGlzdGluZykg
bG9naWMgaXMgZGVjbGFyZWQgaW4NCj4gPiA+ID4gaW5jbHVkZS9saW51eC9uZXRfZGltLmggYW5k
DQo+ID4gPiA+ICAgIGltcGxlbWVudGVkIGluIGxpYi9kaW0vbmV0X2RpbS5jLCB3aGljaCB1c2Vz
IHRoZSBjb21tb24NCj4gPiA+ID4gbG9naWMgZnJvbSBkaW0uaA0KPiA+ID4gPiAtIEFueSBuZXcg
RElNIGxvZ2ljIHdpbGwgYmUgZGVjbGFyZWQgaW4NCj4gPiA+ID4gIi9pbmNsdWRlL2xpbnV4L25l
d19kaW0uaCIgYW5kDQo+ID4gPiA+ICAgICBpbXBsZW1lbnRlZCBpbiAibGliL2RpbS9uZXdfZGlt
LmMiLg0KPiA+ID4gPiAtIFRoaXMgbmV3IGltcGxlbWVudGF0aW9uIHdpbGwgZXhwb3NlIG1vZGlm
aWVkIHZlcnNpb25zIG9mDQo+ID4gPiA+IHByb2ZpbGVzLA0KPiA+ID4gPiAgICBkaW1fc3RlcCgp
IGFuZCBkaW1fZGVjaXNpb24oKS4NCj4gPiA+ID4gDQo+ID4gPiA+IFByb3MgZm9yIHRoaXMgc29s
dXRpb24gYXJlOg0KPiA+ID4gPiAtIFplcm8gaW1wYWN0IG9uIGV4aXN0aW5nIG5ldF9kaW0gaW1w
bGVtZW50YXRpb24gYW5kIHVzYWdlDQo+ID4gPiA+IC0gUmVsYXRpdmVseSBtb3JlIGNvZGUgcmV1
c2UgKGNvbXBhcmVkIHRvIHR3byBzZXBhcmF0ZQ0KPiA+ID4gPiBzb2x1dGlvbnMpDQo+ID4gPiA+
IC0gSW5jcmVhc2VkIGV4dGVuc2liaWxpdHkNCj4gPiA+ID4gDQo+ID4gPiA+IFRhbCBHaWxib2Eg
KDYpOg0KPiA+ID4gPiAgICAgICAgbGludXgvZGltOiBNb3ZlIGxvZ2ljIHRvIGRpbS5oDQo+ID4g
PiA+ICAgICAgICBsaW51eC9kaW06IFJlbW92ZSAibmV0IiBwcmVmaXggZnJvbSBpbnRlcm5hbCBE
SU0gbWVtYmVycw0KPiA+ID4gPiAgICAgICAgbGludXgvZGltOiBSZW5hbWUgZXh0ZXJuYWxseSBl
eHBvc2VkIG1hY3Jvcw0KPiA+ID4gPiAgICAgICAgbGludXgvZGltOiBSZW5hbWUgbmV0X2RpbV9z
YW1wbGUoKSB0bw0KPiA+ID4gPiBuZXRfZGltX3VwZGF0ZV9zYW1wbGUoKQ0KPiA+ID4gPiAgICAg
ICAgbGludXgvZGltOiBSZW5hbWUgZXh0ZXJuYWxseSB1c2VkIG5ldF9kaW0gbWVtYmVycw0KPiA+
ID4gPiAgICAgICAgbGludXgvZGltOiBNb3ZlIGltcGxlbWVudGF0aW9uIHRvIC5jIGZpbGVzDQo+
ID4gPiA+IA0KPiA+ID4gPiBZYW1pbiBGcmllZG1hbiAoMyk6DQo+ID4gPiA+ICAgICAgICBsaW51
eC9kaW06IEFkZCBjb21wbGV0aW9ucyBjb3VudCB0byBkaW1fc2FtcGxlDQo+ID4gPiA+ICAgICAg
ICBsaW51eC9kaW06IEltcGxlbWVudCByZG1hX2RpbQ0KPiA+ID4gPiAgICAgICAgUkRNQS9jb3Jl
OiBQcm92aWRlIFJETUEgRElNIHN1cHBvcnQgZm9yIFVMUHMNCj4gPiA+IFNhZWVkLA0KPiA+ID4g
DQo+ID4gPiBObywgZm9yIHRoZSBSRE1BIHBhdGNoZXMuDQo+ID4gPiBXZSBuZWVkIHRvIHNlZSB1
c2FnZSBvZiB0aG9zZSBBUElzIGJlZm9yZSBtZXJnaW5nLg0KPiA+IA0KPiA+IEkndmUgYXNrZWQg
WWFtaW4gdG8gcHJlcGFyZSBwYXRjaGVzIGZvciBOVk1lb0YgaW5pdGlhdG9yIGFuZCB0YXJnZXQN
Cj4gPiBmb3INCj4gPiByZXZpZXcsIHNvIEkgZ3Vlc3MgaGUgaGFzIGl0IG9uIGhpcyBwbGF0ZSAo
dGhpcyBpcyBob3cgaGUgdGVzdGVkDQo+ID4gaXQuLikuDQo+ID4gDQo+ID4gSXQgbWlnaHQgY2F1
c2UgY29uZmxpY3Qgd2l0aCBOVk1lL2JsayBicmFuY2ggbWFpbnRhaW5lZCBieSBTYWdpLA0KPiA+
IENocmlzdG9waA0KPiA+IGFuZCBKZW5zLg0KPiANCj4gSXQgbG9va3MgbGlrZSBudm1lIGNvdWxk
IHB1bGwgdGhpcyBzZXJpZXMgKyB0aGUgUkRNQSBwYXRjaGVzIGludG8gdGhlDQo+IG52bWUgdHJl
ZSB2aWEgUFI/IEknbSBub3QgZmFtaWxpYXIgd2l0aCBob3cgdGhhdCB0cmVlIHdvcmtzLg0KPiAN
Cj4gQnV0IHdlIG5lZWQgdG8gZ2V0IHRoZSBwYXRjaGVzIHBvc3RlZCByaWdodCBhd2F5Li4NCj4g
DQoNCldoYXQgZG8geW91IHN1Z2dlc3QgaGVyZSA/DQpJIHRoaW5rIHRoZSBuZXRkZXYgY29tbXVu
aXR5IGFsc28gZGVzZXJ2ZSB0byBzZWUgdGhlIHJkbWEgcGF0Y2hlcywgYXQNCmxlYXN0IHdpdGgg
YW4gZXh0ZXJuYWwgbGluaywgSSBjYW4gZHJvcCB0aGUgbGFzdCBwYXRjaCAob3IgdHdvICkgPyBi
dXQNCmkgbmVlZCBhbiBleHRlcm5hbCByZG1hIGxpbmsgZm9yIHBlb3BsZSB3aG8gYXJlIGdvaW5n
IHRvIHJldmlldyB0aGlzDQpzZXJpZXMuDQoNCj4gSmFzb24NCg==
