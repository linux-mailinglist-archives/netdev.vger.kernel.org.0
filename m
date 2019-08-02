Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6778B80032
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406747AbfHBScg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:32:36 -0400
Received: from mail-eopbgr130080.outbound.protection.outlook.com ([40.107.13.80]:53476
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405915AbfHBScg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 14:32:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXyBvEsk1nANu5Ya7GO7N72lce+OIShWGOeIeI6C0hefu5rR1vXhs8sBQJ0Np8whuNnDYwkfzS+0SE/Ccy7mI7Cx3uHJezVuP/zpRRSHXR6Mr2k4E5rn7wgLHkJ9bCDldyFEtxI9ykyP1jZSj37kxftP1inuXtyQrpMQ8xDRRGSwk9i5ss15KKFYqaDg4NerNnSqrruZSIFWFP0JHWEijdQiOdw0SWZzbk+4Dg7RR1px/n9B8wrzgtd1ctB2kpE30Pzug9XLd1sErTr9H7QvC3DDTAsAmVEUtG7ALUQqEOi/R/G/i+FLP43nZv4EQBcWoBHLup4HaOqf8RuQBuDOJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1lzYTCNTXEfJ91tDkew9Xhde/LKTaf7gjymNC1RVTE=;
 b=lZJj8q9TqqsnwCgKH07F1RqDHVBq0cXYXpLOzLr+CL8GQsSDcC/DPtQmdXG5cYnARs5wlVDU5f5ngslqVH9AfBMXX4VTzrJdo4WlRrAdsPJsKKnYeoGIZh8x8/IYQpsCfpqw4TTHcoa1yM9Mhmj7FTwQopSwjUlslhCC/b2T78xwdhwFNbtLs+8dkJ0f+PTdxc8hS+GtTTnc3QwxLPJODTSOqRpQ9SDTr+TDlSwBUj4IfNLQuKg3GcyrHOOIR5gD16K9Cm0p8PFr3Nd7/2kVAPm4wl0B8+zr/hBvYa3YeRpuUkU9jsgiZKWEWKEtGAXTYuwCTckozi4Fxkvg49vW+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1lzYTCNTXEfJ91tDkew9Xhde/LKTaf7gjymNC1RVTE=;
 b=XrKrl75+dNLSdtMMgs47r+KRa+dN+H9PQY3iZTNADGe+FYSFkqau/62j+3H1ORs/w2SZkKkPYL+wKYwgbco7ALhcLQUqC2oxkvprUjNbPyIxeF0SXLJUKCOfMupLRik3qLEXVohjC/09BO1cjo5VQy+LTCcbBh7cDsTHiUlgLkY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2374.eurprd05.prod.outlook.com (10.168.72.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Fri, 2 Aug 2019 18:32:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 18:32:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "joe@perches.com" <joe@perches.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] mlx5: Fix formats with line continuation whitespace
Thread-Topic: [PATCH V2] mlx5: Fix formats with line continuation whitespace
Thread-Index: AQHUcbPlLa4BJcnpckKD7T5iNRtyeqU6hykAgAjGUACBpon4AIAABm8A
Date:   Fri, 2 Aug 2019 18:32:32 +0000
Message-ID: <910f77ed7f2923206adc8927204c6d759ec18d20.camel@mellanox.com>
References: <f14db3287b23ed8af9bdbf8001e2e2fe7ae9e43a.camel@perches.com>
         <20181101073412.GQ3974@mtr-leonro.mtl.com>
         <ac8361beee5dd80ad6546328dd7457bb6ee1ca5a.camel@redhat.com>
         <f2b2559865e8bd59202e14b837a522a801d498e2.camel@perches.com>
In-Reply-To: <f2b2559865e8bd59202e14b837a522a801d498e2.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60e55e9a-862f-4829-4064-08d71777c84d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2374;
x-ms-traffictypediagnostic: DB6PR0501MB2374:
x-microsoft-antispam-prvs: <DB6PR0501MB2374F5C22C84FB10F62C49D4BED90@DB6PR0501MB2374.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(199004)(189003)(102836004)(91956017)(6512007)(7736002)(256004)(110136005)(8936002)(76116006)(3846002)(53936002)(6436002)(26005)(2201001)(6116002)(66556008)(4326008)(66946007)(86362001)(66476007)(2501003)(446003)(14454004)(64756008)(186003)(76176011)(58126008)(229853002)(81166006)(6506007)(6246003)(99286004)(66446008)(478600001)(66066001)(8676002)(486006)(71200400001)(476003)(4744005)(68736007)(25786009)(5660300002)(305945005)(316002)(6486002)(36756003)(118296001)(81156014)(2616005)(54906003)(11346002)(71190400001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2374;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N1uUJ9hDHihp1bi3DSEEGDFNEMXNo8k0cDAFV7sfA1Z1xrpic+7SdbIreumpfDUAsUNRnJZFVBiNsP/PtzklYkqfxGLztTEm1VpH+oFjfr0ikUDF1KzLgyVvK1P2HdTjmTY8yBWd+vYpGIgATpGiO5QvEonJNAMsWtEemeNUw7R5BqGV9gFKkPTQJHpRIw3HWNjKLeLx3Fmi6kXA6bAIeV4jQt9xOKQa9NiOgj1Iwgyes357c3TzzNXpzTKCOnCVhDQASfYvBl5yPZZdYDHWD7bfX5AQvA+WwJux+mviy8Ryjd5Dz1xSc4/Hw83K+Z7Gl9xG9kr/JvOdJI9+e9QPfqG9/NfYogQkuTuVT34ofEfYMzi1qf7mAMDh8K1Mq1TdFO+JarKy10giPW3qxINb76Aeep/5coQ/VPTxp0zwtgI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17AECB3675509846A6F74881C3507CB5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e55e9a-862f-4829-4064-08d71777c84d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 18:32:32.3318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2374
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTAyIGF0IDExOjA5IC0wNzAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
T24gVHVlLCAyMDE4LTExLTA2IGF0IDE2OjM0IC0wNTAwLCBEb3VnIExlZGZvcmQgd3JvdGU6DQo+
ID4gT24gVGh1LCAyMDE4LTExLTAxIGF0IDA5OjM0ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3Jv
dGU6DQo+ID4gPiBPbiBUaHUsIE5vdiAwMSwgMjAxOCBhdCAxMjoyNDowOEFNIC0wNzAwLCBKb2Ug
UGVyY2hlcyB3cm90ZToNCj4gPiA+ID4gVGhlIGxpbmUgY29udGludWF0aW9ucyB1bmludGVudGlv
bmFsbHkgYWRkIHdoaXRlc3BhY2Ugc28NCj4gPiA+ID4gaW5zdGVhZCB1c2UgY29hbGVzY2VkIGZv
cm1hdHMgdG8gcmVtb3ZlIHRoZSB3aGl0ZXNwYWNlLg0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVk
LW9mZi1ieTogSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4g
PiA+IA0KPiA+ID4gPiB2MjogUmVtb3ZlIGV4Y2VzcyBzcGFjZSBhZnRlciAldQ0KPiA+ID4gPiAN
Cj4gPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9ybC5jIHwg
NiArKy0tLS0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDQgZGVs
ZXRpb25zKC0pDQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gPiBUaGFua3MsDQo+ID4gPiBSZXZpZXdl
ZC1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IEFw
cGxpZWQsIHRoYW5rcy4NCj4gDQo+IFN0aWxsIG5vdCB1cHN0cmVhbS4gIEhvdyBsb25nIGRvZXMg
aXQgdGFrZT8NCj4gDQoNCkRvdWcsIExlb24sIHRoaXMgcGF0Y2ggc3RpbGwgYXBwbHksIGxldCBt
ZSBrbm93IHdoYXQgaGFwcGVuZWQgaGVyZSA/DQphbmQgaWYgeW91IHdhbnQgbWUgdG8gYXBwbHkg
aXQgdG8gb25lIG9mIG15IGJyYW5jaGVzLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
