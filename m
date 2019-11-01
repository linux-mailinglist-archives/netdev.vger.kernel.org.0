Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D3CECA5E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfKAVlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:41:40 -0400
Received: from mail-eopbgr00051.outbound.protection.outlook.com ([40.107.0.51]:42627
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725989AbfKAVlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:41:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cV2UVJ534Ba2eMhfD7VkTW4ji0z69Xj4UZugO0tOJLOhPqGfAhTO32MGJmXcMlS3hj4nER4wy7SH65LaoGRyBFXBPlVhK774bvS8xSNZ8+dWf55eRcl+CdjV8y5egbRqIxShFEONGvrCPCsjmeoqUdQ/8/w/7lpUq72R83G62/UdRdLruKJ2XQnY9IQn83JfzpelQTXn0OI0VdQ+xzYaCSxDTcl8pCk3/75qNr5Z/7RfbcJrtmLmiU8M39AnqWuvDK5kCf0jvXMxAs4+LlQ1gbsVFnPjMDRTUbVRViZHSBuilKJr8SerSt9NWFMFOxmTxn/lQwrPZR1ECcTPu4WeKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOtO7yZGUB4iTCoZpafb4pixOB/xjhovC4ltFYuFGHM=;
 b=MckzkqtxxeU9wXNMUrFVcTMy/zY76b6E42ZHm1YQUUk00tBLfNkd30HrXLAxq2/G9/n1UjzEorVOqYc+5+vauQwKNaPwe6Pz+2Icsb0GVH0eAJE0AJ/HRSMfRVmOnG42dXyuCtZsBMTOmPDh31Dvrlba0O/SkItWPdSK5wFv8fgt5ViWwcumw55JeNfKO2godsRD5BBZX5kF0zwCXaFRDEoU6HZ9X83g4N/0MUcxq/4/G79UPESSUXe0edLOPsLhf84TrqyaYKJ31o3kXd9vN4pg/5+tmJTyS4W4IC/Hf9e8bCimsq6klIQbdfROLn+GuvYVbKlKg/U0y+mkCBE+Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOtO7yZGUB4iTCoZpafb4pixOB/xjhovC4ltFYuFGHM=;
 b=fXinqjw20bX/ufEfaMYmdWYnZDWEVoU2lAHC7z7Sq5b/91+kqJyEPg5OpOC6SaBpyxg/Mh67uail/TD8eJxT8gAUDoZ7TRu+IPk6FQHPYaNbNwHN105t1BwfhriBjOVG8Pe7sMi9rPIs8Othxja8VpPeK/CixnctfHaewO1QqBU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5214.eurprd05.prod.outlook.com (20.178.12.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:41:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:41:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/18] Mellanox, mlx5-next updates 28-10-2019
Thread-Topic: [PATCH mlx5-next 00/18] Mellanox, mlx5-next updates 28-10-2019
Thread-Index: AQHVjehNWopMiBOYdUCwLPj6a+lSdqd23m8A
Date:   Fri, 1 Nov 2019 21:41:35 +0000
Message-ID: <eba57dd476d02fd0cab2678cc6ff2098b5a8a4b3.camel@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 096a4760-d16c-45d2-e519-08d75f1444da
x-ms-traffictypediagnostic: VI1PR05MB5214:|VI1PR05MB5214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5214193B0932C2EC5AE33F01BE620@VI1PR05MB5214.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(199004)(189003)(186003)(6636002)(6486002)(6436002)(3846002)(14454004)(66946007)(58126008)(6512007)(6116002)(446003)(11346002)(478600001)(8676002)(37006003)(2616005)(6246003)(6862004)(476003)(25786009)(6506007)(450100002)(486006)(4001150100001)(36756003)(8936002)(26005)(76176011)(71190400001)(54906003)(81166006)(5660300002)(229853002)(86362001)(99286004)(64756008)(14444005)(66556008)(66446008)(66066001)(256004)(305945005)(316002)(118296001)(81156014)(66476007)(91956017)(76116006)(2906002)(7736002)(4326008)(71200400001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5214;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VB/aJS98I31ingqefRcfzoIoNi/iV+1noQEU7yQau+/oLgsdrgwOdn/mlrgiMA0xLDmfWT6uWKa9qhwGMao35qMinSQ8FToXny+6lBXteobAPZOcudXXZ3zV8AMPxaA+4DEsDSJFjYaDI0ag8X2DjiXr5+He6E/m50vR0CHtMgtva/A0NLDI18JHUhCnN3LuxDeTWNvreqkykK1BeO0RaxMNbeHHBirsfSIGWN8e9EsDkR8ApXjqPekfbWNftJBtFeHu0WzoSsIVwpTuhyWEFfcy3+vXEygoZkPT1Zwlw4p8sIUbvTUO66XK4RcC2hOn6gtqJ32TJUqKzr00euCqo8IN85mPnHwVz94pcaFrnEGpqheGly80Xt2Uf1AiZkPh8daiKpaczkulZN6X26SFDtEbGnfZ+OHeofiKrD53Tpxk9mm4sAU7hz12yL4eZxGW
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CB3A45778EEAE419665CB9F59037778@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096a4760-d16c-45d2-e519-08d75f1444da
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:41:35.4036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pYmpAJpTYy3Fp+mT8Y0HLfQAxbTHGCZiBI2/yjSQnazo9qyC6zIHIZDRx+nO2Fbm8YbbW2qcyspoeoAcn8DvMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTEwLTI4IGF0IDIzOjM0ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGksIA0KPiANCj4gVGhpcyBzZXJpZXMgcmVmYWN0b3JzIGFuZCB0aWRlIHVwIGVzd2l0Y2gg
dnBvcnQgYW5kIEFDTCBjb2RlIHRvDQo+IHByb3ZpZGUNCj4gYmV0dGVyIHNlcGFyYXRpb24gYmV0
d2VlbiBlc3dpdGNoIGxlZ2FjeSBtb2RlIGFuZCBzd2l0Y2hkZXYgbW9kZSANCj4gaW1wbGVtZW50
YXRpb24gaW4gbWx4NSwgZm9yIGJldHRlciBmdXR1cmUgc2NhbGFiaWxpdHkgYW5kDQo+IGludHJv
ZHVjdGlvbiBvZg0KPiBuZXcgc3dpdGNoZGV2IG1vZGUgZnVuY3Rpb25hbGl0eSB3aGljaCBtaWdo
dCByZWx5IG9uIHNoYXJlZA0KPiBzdHJ1Y3R1cmVzDQo+IHdpdGggbGVnYWN5IG1vZGUsIHN1Y2gg
YXMgdnBvcnQgQUNMIHRhYmxlcy4NCj4gDQo+IFN1bW1hcnk6DQo+IA0KPiAxLiBEbyB2cG9ydCBB
Q0wgY29uZmlndXJhdGlvbiBvbiBwZXIgdnBvcnQgYmFzaXMgd2hlbg0KPiBlbmFibGluZy9kaXNh
YmxpbmcgYSB2cG9ydC4NCj4gVGhpcyBlbmFibGVzIHRvIGhhdmUgdnBvcnRzIGVuYWJsZWQvZGlz
YWJsZWQgb3V0c2lkZSBvZiBlc3dpdGNoDQo+IGNvbmZpZyBmb3IgZnV0dXJlLg0KPiANCj4gMi4g
U3BsaXQgdGhlIGNvZGUgZm9yIGxlZ2FjeSB2cyBvZmZsb2FkcyBtb2RlIGFuZCBtYWtlIGl0IGNs
ZWFyDQo+IA0KPiAzLiBUaWRlIHVwIHZwb3J0IGxvY2tpbmcgYW5kIHdvcmtxdWV1ZSB1c2FnZQ0K
PiANCj4gNC4gRml4IG1ldGFkYXRhIGVuYWJsZW1lbnQgZm9yIEVDUEYNCj4gDQo+IDUuIE1ha2Ug
ZXhwbGljaXQgdXNlIG9mIFZGIHByb3BlcnR5IHRvIHB1Ymxpc2gNCj4gSUJfREVWSUNFX1ZJUlRV
QUxfRlVOQ1RJT04NCj4gDQo+IEluIGNhc2Ugb2Ygbm8gb2JqZWN0aW9uIHRoaXMgc2VyaWVzIHdp
bGwgYmUgYXBwbGllZCB0byBtbHg1LW5leHQNCj4gYnJhbmNoDQo+IGFuZCBzZW50IGxhdGVyIGFz
IHB1bGwgcmVxdWVzdCB0byBib3RoIHJkbWEtbmV4dCBhbmQgbmV0LW5leHQNCj4gYnJhbmNoZXMu
DQo+IA0KDQoNClNlcmllcyBhcHBsaWVkIHRvIG1seDUtbmV4dCBicmFuY2guDQpUaGFua3MsDQpT
YWVlZC4NCg0K
