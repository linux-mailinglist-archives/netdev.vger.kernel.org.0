Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8CB123606
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfLQTyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:54:39 -0500
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:48717
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfLQTyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 14:54:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmQKudBW/smHu8Goki4L3BOIP+uMRyXnpR3hcKA/YLuOgBnQ/iDoV3AV34vEBcUh3ut11aABvJSpD2bRKNMD0ukRLc1jVUVcYJjnkD+IGZvpOtR0zKRct9kic6Q1mW81OJxd05dFbYxacH127ec9xDfchpXNCYaLOCMu+NnzGGCaxPSbVNaLkZk1AR40pL05v5G/h20Wpio/g2KrphHUw9VxUbF7W8064EoVnESunkwUITc2S4il5nducg/tdf6O31R9kKLgYGYzR6iokO9S1wZ54vi/iCzifRGctTTK+WhSK/BwdPZeftV1UIqOa5Isn/Y1AGFZxWOkXq+L6mkR5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ai8vP470zhjhbuk+3y7noudgknW76+XIV9TuLLwPdgs=;
 b=kN+WUb4DxtUCCfcYXwarThB3zkE1U9+Fs+CKzH15z9nhQRf7WPnq9aHfe+rgWJ7RaxguwUPNhlwh5ppFguh6YU7SyLVCRQhtR1622Gb9VFSiUD/O1xRCpq+5ajBYnaujfrQAAx0Df7oBPlEwA1e3VMCiGOPlXXc9IdqvLyigJdOnXbgL/rc8UHuR+Ha0GxKK83wg6WXSUl3HdHZVsaiCCXH6hxC5OKuLJLu0HiiKR7i8GIX4lrgErtdkPkWkdEP2jD0RccPumO4skqOdjW+BwCg4R6EEB6yG0dlgT2Umlv7pGITPpKdMoD+yOB5CiNpCNnulVGQw61ORgzh304XSMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ai8vP470zhjhbuk+3y7noudgknW76+XIV9TuLLwPdgs=;
 b=HSvwpes3dueByvDuhsNwSEepBEr7FgOsOXAHgAtrhTus1JhLeaet9D2WNFPULnfosFUbqrZoGwZPvWBXWlWJOAB5nbGf/Cyt5vGdupYtJnfmC8r9sVgud2Dr7bT2Hh83rH39Td2F2qkFW+OzDhtoNB9Ca9Qw8QOr97KkM8Q2vWo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6077.eurprd05.prod.outlook.com (20.178.126.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 19:54:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 19:54:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Paul Blakey <paulb@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Topic: [PATCH net-next 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb
 support
Thread-Index: AQHVr0HWrJ3tUt3ylke6yfGwXQxlbqezP/qAgAD6fYCACo6eAA==
Date:   Tue, 17 Dec 2019 19:54:34 +0000
Message-ID: <62c3d7ec655b0209d2f5d573070e484ac561033c.camel@mellanox.com>
References: <1575972525-20046-1-git-send-email-wenxu@ucloud.cn>
         <1575972525-20046-2-git-send-email-wenxu@ucloud.cn>
         <140d29e0-712a-31b0-e7b0-e4f8af29d4a8@mellanox.com>
         <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
In-Reply-To: <a96ffa33-e680-d92c-3c5c-f86b7b9e12bb@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d46a68ad-56be-4af1-a3fe-08d7832af0b8
x-ms-traffictypediagnostic: VI1PR05MB6077:|VI1PR05MB6077:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB607794C47027899512568011BE500@VI1PR05MB6077.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(189003)(199004)(36756003)(316002)(81156014)(110136005)(4744005)(66476007)(64756008)(71200400001)(8936002)(4001150100001)(8676002)(5660300002)(4326008)(86362001)(26005)(186003)(966005)(91956017)(2616005)(6486002)(66946007)(6512007)(2906002)(53546011)(6506007)(478600001)(81166006)(66556008)(76116006)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6077;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xc/Cq2+A5rqYhxg6lv6V0VQbgb6xX84FRovhx23mwp4k+UsaWjAqxn8DHpkwwG4NkyW/zq50p9YkW6knbx05yvYzg2iQHXyHzvQjZqr5k9LyN5KGONTAZGoX1JMFdis9BGek6XXI+cybih5kX/Ng1D0r7+QWybiwEnpO5LR/9Jk4STqDClJ0FWvjLp6BMTcXomr2NGZOri4tfw6WY+gaUkr9F3WxjGQ7vNXE96JhvOfeDuX54ZLi0405oAOykl6uy5qTKdRmI5gWVIla05++c5s5vVpJZSZdHgje3cRq8V+iHmSIyNDe+kEu24iZQtly34/S/4J0355eC2DqU3bqt7h0k3ajFB8VxZViKG0m8NmU5BDLqDo+u6bPh8GdRI9oas6MBji2Yx5LIZ/Bay9h0K8ezEp1PIdR6rz39YhevVzEL6JHCRaOyptAJLmny8mv5twGF9qrajywp56V4w8PM/2t+SGDppJsZxiUqybFfUE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CB01DF2514EE04CAD8FE8D88F5AA62E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d46a68ad-56be-4af1-a3fe-08d7832af0b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 19:54:34.5442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GB1pIZlp4zB03mvP+OBTXHpLJvSgT4PXcJs/a7pKTpmH98RQdWfodYo86YOAnSkItcocMWWiEPp2HLmMTTZ+7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEyLTExIGF0IDEwOjQxICswODAwLCB3ZW54dSB3cm90ZToNCj4gT24gMTIv
MTAvMjAxOSA3OjQ0IFBNLCBQYXVsIEJsYWtleSB3cm90ZToNCj4gPiBPbiAxMi8xMC8yMDE5IDEy
OjA4IFBNLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6DQo+ID4gPiBGcm9tOiB3ZW54dSA8d2VueHVA
dWNsb3VkLmNuPg0KPiA+ID4gDQo+ID4gPiBBZGQgbWx4NWVfcmVwX2luZHJfc2V0dXBfZnRfY2Ig
dG8gc3VwcG9ydCBpbmRyIGJsb2NrIHNldHVwDQo+ID4gPiBpbiBGVCBtb2RlLg0KPiA+ID4gDQo+
ID4gPiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiA+ID4gLS0tDQoN
ClsuLi5dDQoNCj4gPiArY2MgU2FlZWQNCj4gPiANCj4gPiANCj4gPiBUaGlzIGxvb2tzIGdvb2Qg
dG8gbWUsIGJ1dCBpdCBzaG91bGQgYmUgb24gdG9wIG9mIGEgcGF0Y2ggdGhhdA0KPiA+IHdpbGwg
DQo+ID4gYWN0dWFsIGFsbG93cyB0aGUgaW5kaXJlY3QgQklORCBpZiB0aGUgbmZ0DQo+ID4gDQo+
ID4gdGFibGUgZGV2aWNlIGlzIGEgdHVubmVsIGRldmljZS4gSXMgdGhhdCB1cHN0cmVhbT8gSWYg
c28gd2hpY2gNCj4gPiBwYXRjaD8NCj4gPiANCj4gPiANCj4gPiBDdXJyZW50bHkgKDUuNS4wLXJj
MSspLCBuZnRfcmVnaXN0ZXJfZmxvd3RhYmxlX25ldF9ob29rcyBjYWxscyANCj4gPiBuZl9mbG93
X3RhYmxlX29mZmxvYWRfc2V0dXAgd2hpY2ggd2lsbCBzZWUNCj4gPiANCj4gPiB0aGF0IHRoZSB0
dW5uZWwgZGV2aWNlIGRvZXNuJ3QgaGF2ZSBuZG9fc2V0dXBfdGMgYW5kIHJldHVybiANCj4gPiAt
RU9QTk9UU1VQUE9SVEVELg0KPiANCj4gVGhlIHJlbGF0ZWQgcGF0Y2ggIGh0dHA6Ly9wYXRjaHdv
cmsub3psYWJzLm9yZy9wYXRjaC8xMjA2OTM1Lw0KPiANCj4gaXMgd2FpdGluZyBmb3IgdXBzdHJl
YW0NCj4gDQoNClRoZSBuZXRmaWx0ZXIgcGF0Y2ggaXMgc3RpbGwgdW5kZXItcmV2aWV3LCBvbmNl
IGFjY2VwdGVkIGkgd2lsbCBhcHBseQ0KdGhpcyBzZXJpZXMuDQoNClRoYW5rcywNClNhZWVkLg0K
DQoNCg==
