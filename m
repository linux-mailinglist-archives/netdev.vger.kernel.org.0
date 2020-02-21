Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D8168924
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgBUVS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:18:29 -0500
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:59150
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbgBUVS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:18:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/WfD9KCu3S0eAmBeCO02p+jYuwatUZ1D+DFjQy+C+STZDhx7XKh7G3bdSdd+dmFIDp7rccqAeZL6SN7zf3196P1WW9WTtSMroi8B8YBV16VcVm7km9hTnKCImpP7zxo+553R46bfKO5pvBYIQvx/KmnSaC3+MpFiHMyt6Qbi2s4YYR2/5Ycyhcw9ISUF0HKX6vrVPleWG0Bwmw9vR8WyZCmGN98FFSmzSEIgd6QweM6uw2NNuE23AVDGWvDHr995vnpHQG1o4so7BFDXE4Cer89uE9LoAzsYp0sVE7eHkjyD0EtjE1EuPaCnZ/mIfsqLsqL+1feWnYgQQZYHX8D+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jf1OszH/L9JDdqSNoKjgBJePe3OmBcV6mqd9eEA4aUo=;
 b=jYjrksOA7jU5fSVuUAjpGA0OE1DypUW7tbl2/JafSvWxokBf/0xqreNtn92HOkDwspYlmxxbnpnFkTi+JbNGz9JKoWRkANZs5aHa0THLtU8Paq/rgSKFe+xnoWOeY5jZFPG64I6RYGcgR+qSQDliFKuiRh0E0R/vZRfcB6eX/QmqqMM3CHrVraY9dIQCMP0FtDYzO7IFCdS3kfQkzBETGje49cxap3KxXkiP4MEROgyr6oUcuUW0oZd2QFRCbrgjrvutt7PrFEX0eRw0FdLKYw0W/MIaeOjqMyT6Ym20wNoCliGvnvkXgMWQWkZ5GbKMiMXwsw06FRHCky8HiMt8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jf1OszH/L9JDdqSNoKjgBJePe3OmBcV6mqd9eEA4aUo=;
 b=axb0wjsLJ7w/8QaUCFmPUSVKrJHIfAt4LuJnE3wmioHfo+iUNXelwsEKo6KgUwha8SEZsOuVlBiu5DtFleTsM9D1ATyU15WbmzGgpvhipOhuAnGbWib/pYArLgPR6mFEbxMmEcx93H5KM3buIAWUGO8tphT0O/OVSrsS/j6v7S4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6079.eurprd05.prod.outlook.com (20.178.204.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Fri, 21 Feb 2020 21:18:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:18:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/7] net/mlxfw: Improve FSM err message reporting
 and return codes
Thread-Topic: [PATCH net-next 2/7] net/mlxfw: Improve FSM err message
 reporting and return codes
Thread-Index: AQHV55UMvLBd8iCINkaFAwYKMRa0IKgjnRiAgAKMkwA=
Date:   Fri, 21 Feb 2020 21:18:25 +0000
Message-ID: <160ce91ed9ac31d638019686c70fe95b4b30c2bb.camel@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
         <20200220022502.38262-3-saeedm@mellanox.com>
         <20200219222231.46425175@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200219222231.46425175@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ca79749a-5f6e-4269-a677-08d7b71396d2
x-ms-traffictypediagnostic: VI1PR05MB6079:|VI1PR05MB6079:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB60797207FE786BF5A203421ABE120@VI1PR05MB6079.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(39850400004)(396003)(376002)(189003)(199004)(54906003)(2906002)(107886003)(6916009)(186003)(26005)(6506007)(316002)(66946007)(64756008)(478600001)(66556008)(66446008)(2616005)(66476007)(91956017)(76116006)(4744005)(8936002)(5660300002)(15650500001)(86362001)(36756003)(4326008)(6512007)(8676002)(81166006)(6486002)(81156014)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6079;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MStyrsKaNDZMsvJriYize/KYNs9ShAF2k6e64Js+MTO/D1LTGeUWP6NDGXYiIk2w7OddmTIRyjH5x1uA/xltqYRho5C9J3JNGyV2GafV0g+oYmz6iuTlBUVEyl2MtqNzoGUA2k54GY5R7Sg3+scx1jAm873PbE+12Kv/UgxsltQ8mfryI2OFm66wXJ6DE3eM4upARYwUBQxN4PAhGljmHGyjPiB208seePdsHbzcjYqMYKfLSghmwFoUdiI6pts3DkyEAu4m2K1vhNwN3u4UyijHVfMfgDiIxlqgkvXXZ0T5O0eFE+vFUAdcpCeySt1PlVeBeRZY2z1T4oXXmoATkA86k+F4pcDYGkhQMjTsCrIDbdsQZOcV0krkUcrppr2iW6KcwwfVtYPUIMVR5h8uQqtwgy+caLhsrqMFOWO8I16sCzCwfsProq4VCrdZ2ec
x-ms-exchange-antispam-messagedata: VKB70KRSgIOt+/u/Xg3+3lKbd0oLNZFxR4WHEXBj2q/aB36tvUOgG7llLR3y5xxKKFj5lU6XFKVdETqGZkRcmpL6XNZR7MUiTGftv6k5nCxbcM/JIFePhZQHGo3QXx5W9WZbR8XZTiYWlyPbD07qzw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <481B67F34FCAAB489F2A55397F19D567@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca79749a-5f6e-4269-a677-08d7b71396d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:18:25.8294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZOMPy9BXwOukw9ebl/1NMy8+RnmPOq+m8D++TyCcGKnnrQrI1viQCJSCh8BwXKG2pjNOEXe/KZaNODAv0ovXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6079
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAyLTE5IGF0IDIyOjIyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyMCBGZWIgMjAyMCAwMjoyNTo0MiArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBSZXBvcnQgdW5pcXVlIGFuZCBzdGFuZGFyZCBlcnJvciBjb2RlcyBjb3JyZXNwb25k
aW5nIHRvIHRoZQ0KPiA+IHNwZWNpZmljDQo+ID4gRlcgZmxhc2ggZXJyb3IuIEluIGFkZGl0aW9u
LCBhZGQgYSBtb3JlIGRldGFpbGVkIGVycm9yIG1lc3NhZ2VzIHRvDQo+ID4gbmV0bGluay4NCj4g
PiANCj4gPiBCZWZvcmU6DQo+ID4gJCBkZXZsaW5rIGRldiBmbGFzaCBwY2kvMDAwMDowNTowMC4w
IGZpbGUgLi4uDQo+ID4gRXJyb3I6IG1seGZ3OiBGaXJtd2FyZSBmbGFzaCBmYWlsZWQuDQo+ID4g
ZGV2bGluayBhbnN3ZXJzOiBJbnZhbGlkIGFyZ3VtZW50DQo+ID4gDQo+ID4gQWZ0ZXI6DQo+ID4g
JCBkZXZsaW5rIGRldiBmbGFzaCBwY2kvMDAwMDowNTowMC4wIGZpbGUgLi4uDQo+ID4gRXJyb3I6
IG1seGZ3OiBGaXJtd2FyZSBmbGFzaCBmYWlsZWQ6IHBlbmRpbmcgcmVzZXQuDQo+ID4gZGV2bGlu
ayBhbnN3ZXJzOiBPcGVyYXRpb24gYWxyZWFkeSBpbiBwcm9ncmVzcw0KPiANCj4gVGhhdCBzb3Vu
ZHMgaW5jb3JyZWN0LCBubz8gSXNuJ3QgRUJVU1kgbW9yZSBhcHByb3ByaWF0ZSBoZXJlPw0KPiBU
aGUgZmxhc2ggb3BlcmF0aW9uIGlzIG5vdCBhbHJlYWR5IGluIHByb2dyZXNzLi4NCj4gDQo+IEFs
c28gdGhlIEVSUl9FUlJPUiBjb3VsZCBwZXJoYXBzIGJlIHNpbXBseSAtRUlPPw0KDQpTb3VuZHMg
Z29vZCB3aWxsIGNoYW5nZSBib3RoLiANCg0KPiANCj4gT3RoZXIgdGhhbiB0aGUgZXJyb3IgY29k
ZSBzZWxlY3Rpb24gdGhlIHBhdGNoZXMgbG9vayBnb29kIHRvIG1lIQ0KPiANCj4gPiBTaWduZWQt
b2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gPiBSZXZpZXdl
ZC1ieTogSWRvIFNjaGltbWVsIDxpZG9zY2hAbWVsbGFub3guY29tPg0KPiA+IEFja2VkLWJ5OiBK
aXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCg==
