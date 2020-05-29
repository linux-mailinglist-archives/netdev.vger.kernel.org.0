Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50021E88F8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgE2UeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:34:04 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:23839
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727964AbgE2UeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:34:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAOAFRqRMWa1d7aRDL6UiFFT7CL+CbDQgelVO1straxNtYLh7+vQYmNMRQPakuEVne/tBlNRF8AttrZDqurJFF3VAdI8Xhae77Bt1EQeQU8C9VqxuMRwqqJxDLFF3N7Kesy4eJLFpgF5gMaKQrj0X79Rgsr3UizDHTRlHm8d7SKJpTYHydE5cH0VRfULXYMUpW21396ySkETqjaJXsYHETANEyfMRMWiYIGAKtoRdKK5wLeZW67s6vCq6gVKUb6K3e2PeHHGzloBhykP8nKAUoNAK+/IAjZHmKuSOHVl3mEUpgPYafET0kGtoYJI8Rw92EiuKX9RJm+ysUkvJpe5Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3ksfSMSermAOaMkuSZMMGLaLBHb+yvkhllTNDDz0zw=;
 b=BXNQVpkucUhkJHy0zeLJCFRQV0orL4PK+5Uo20RJDxN2gAsNjuf2gRtD0ZFn9W2FEcjoqtJ7ANiw4H5aHJk+ofgvKdyz9bPCHt4gQZ1Rd63TxoV6tOBBzTNCLm66VNdGIB9VHcQ+KnEM5vgCxmv11RJ1C31r50Nh8fIrtVsh992f+uVRQTEhHpGDiIwrOcottVcxIjSQdiOq4kipGxe43TEqIxRMGmEiDCK7DODiwm2cM6xtAyiZGGKTzcNwL8e0Spb7qLJbnFMDZVEoVN/VbtnbjPXeEQ23p3/EIVcr66GT0BtUHDq87IgB5D2Jq8X4V5UZGJhug1LKoZSUZAdeVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3ksfSMSermAOaMkuSZMMGLaLBHb+yvkhllTNDDz0zw=;
 b=iZ6oy9DO90sxUeFn9axabVo1W5OKhueSZi3za9+1FQy3lGxeGf7jVhNz85RcSRa+BPv7Xhed4QetlQ2OxdfcjO9ElFD4c20ttwL4wezDqRVmtN3/zosV3UMhZ/c1xIeuLtynSLE9x/kGmncKvFLch+t3DCNQ3NrWuIwu6WGYH2Y=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4447.eurprd05.prod.outlook.com (2603:10a6:803:4d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 20:33:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:33:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 09/11] net/mlx5e: kTLS, Add kTLS RX stats
Thread-Topic: [net-next 09/11] net/mlx5e: kTLS, Add kTLS RX stats
Thread-Index: AQHWNfH4eZWmtINa2Uufjfpn2Xh10Ki/fiUAgAAG6IA=
Date:   Fri, 29 May 2020 20:33:57 +0000
Message-ID: <df2f8dfa2deaa3fea5436f3b39fc215666988c6b.camel@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
         <20200529194641.243989-10-saeedm@mellanox.com>
         <20200529130912.4da4f596@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529130912.4da4f596@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ba338761-f4bb-4497-f571-08d8040f9ce2
x-ms-traffictypediagnostic: VI1PR05MB4447:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB44477BFAC88F2920DF2654B0BE8F0@VI1PR05MB4447.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rPzOKr9O/j64g2i0Vt7oou1DgilT6EJIB+EN2yr5q4iERT7ezoe68QpkgsdFelj2w4+dO8dmlV2uFqQ5OPDlyqVlw2rBoRdDoaullkdAWFrC7isfM66g46XKWqV4jMHA+smRu+MNH6Z8wI8crx1mP9hs4tf+a9JomLztPAC5PwVFlBnRTz0bTIBqlNrs6zwNG98UFjU4joJu13nO+LNN4iVAjZDaOvEFuxxXk8QHf7tJPjd+3Bs7LtmX9OHRKFaUNsoV3yDeIyKRrp0sKErqyHoJyNuysSIY8usbSMTZd9OqvhrHAKE0UyJWq6AqhEYtMwyGcLnzAcxtuYnqGvSY1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(66946007)(66476007)(186003)(86362001)(5660300002)(71200400001)(478600001)(2906002)(6486002)(26005)(36756003)(66446008)(6506007)(8936002)(54906003)(66556008)(91956017)(4326008)(76116006)(316002)(8676002)(107886003)(64756008)(6916009)(2616005)(83380400001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ODQ/wsBka+IZFzLyxNm9YmD9gbgeGZFtQ+l2RqMgUx47W9olPYXe3SUaA4UFgA3I7xtCjLcchjyc5EBnKjPis0NDklzvynBxTBCiNnu9BQjQi31kMHJZ+51wTV43ljVjMDdzXbj8Ym3OIgkKK3YLsUsPnq9aYDk7JGjD2rIYnV27mQUY1ewFAJEJTuM6zo9FgPkZd7SstXas2jKWOsAFwF0Ap356m7f9QRihPof75gqwgrti4EikZiuhiNIqLNIKWUe3z9I/brmGimU1m/KqoYdmKyhvSsR9Lv59uZD5lsBQ3vFDQGdfbUlBGycpTavfmGYOhlt2irdSI/LmMDpindF0HRQ8tWj9lHrbU94o7wizHqkwNsDT825Gh9oJnteT5HgAr60Xx5FA7l8tfoUtTyAt/ZhCVKcmvffZZzgmrc1qcBn1lbDpQ39wNnQXtH+sK8XfWHlo5Ff+zMmqIIpSjtqZhiuol9OD67mqyR+WKts=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11F682B7D4DF5F49B58DCE41DE34C258@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba338761-f4bb-4497-f571-08d8040f9ce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 20:33:57.4126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xtBB75vNgjIKC2yYVaDdlHLtLIZ3s2YPh2Vylvmx7a1y6wuI7pJea8WmCzvlW6LSCBpbrZ5sYVwNFdXfIioL5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4447
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTI5IGF0IDEzOjA5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyOSBNYXkgMjAyMCAxMjo0NjozOSAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2Fk
LnJzdA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2FkLnJzdA0KPiA+
IGluZGV4IGY5MTRlODFmZDNhNjQuLjQ0YzRiMTk2NDc3NDYgMTAwNjQ0DQo+ID4gLS0tIGEvRG9j
dW1lbnRhdGlvbi9uZXR3b3JraW5nL3Rscy1vZmZsb2FkLnJzdA0KPiA+ICsrKyBiL0RvY3VtZW50
YXRpb24vbmV0d29ya2luZy90bHMtb2ZmbG9hZC5yc3QNCj4gPiBAQCAtNDI4LDYgKzQyOCwxNCBA
QCBieSB0aGUgZHJpdmVyOg0KPiA+ICAgICB3aGljaCB3ZXJlIHBhcnQgb2YgYSBUTFMgc3RyZWFt
Lg0KPiA+ICAgKiBgYHJ4X3Rsc19kZWNyeXB0ZWRfYnl0ZXNgYCAtIG51bWJlciBvZiBUTFMgcGF5
bG9hZCBieXRlcyBpbiBSWA0KPiA+IHBhY2tldHMNCj4gPiAgICAgd2hpY2ggd2VyZSBzdWNjZXNz
ZnVsbHkgZGVjcnlwdGVkLg0KPiA+ICsgKiBgYHJ4X3Rsc19jdHhgYCAtIG51bWJlciBvZiBUTFMg
UlggSFcgb2ZmbG9hZCBjb250ZXh0cyBhZGRlZCB0bw0KPiA+IGRldmljZSBmb3INCj4gPiArICAg
ZGVjcnlwdGlvbi4NCj4gPiArICogYGByeF90bHNfb29vYGAgLSBudW1iZXIgb2YgUlggcGFja2V0
cyB3aGljaCB3ZXJlIHBhcnQgb2YgYSBUTFMNCj4gPiBzdHJlYW0NCj4gPiArICAgYnV0IGRpZCBu
b3QgYXJyaXZlIGluIHRoZSBleHBlY3RlZCBvcmRlciBhbmQgdHJpZ2dlcmVkIHRoZQ0KPiA+IHJl
c3luYyBwcm9jZWR1cmUuDQo+ID4gKyAqIGBgcnhfdGxzX2RlbGBgIC0gbnVtYmVyIG9mIFRMUyBS
WCBIVyBvZmZsb2FkIGNvbnRleHRzIGRlbGV0ZWQNCj4gPiBmcm9tIGRldmljZQ0KPiA+ICsgICAo
Y29ubmVjdGlvbiBoYXMgZmluaXNoZWQpLg0KPiA+ICsgKiBgYHJ4X3Rsc19lcnJgYCAtIG51bWJl
ciBvZiBSWCBwYWNrZXRzIHdoaWNoIHdlcmUgcGFydCBvZiBhIFRMUw0KPiA+IHN0cmVhbQ0KPiA+
ICsgICBidXQgd2VyZSBub3QgZGVjcnlwdGVkIGR1ZSB0byB1bmV4cGVjdGVkIGVycm9yIGluIHRo
ZSBzdGF0ZQ0KPiA+IG1hY2hpbmUuDQo+ID4gICAqIGBgdHhfdGxzX2VuY3J5cHRlZF9wYWNrZXRz
YGAgLSBudW1iZXIgb2YgVFggcGFja2V0cyBwYXNzZWQgdG8NCj4gPiB0aGUgZGV2aWNlDQo+ID4g
ICAgIGZvciBlbmNyeXB0aW9uIG9mIHRoZWlyIFRMUyBwYXlsb2FkLg0KPiA+ICAgKiBgYHR4X3Rs
c19lbmNyeXB0ZWRfYnl0ZXNgYCAtIG51bWJlciBvZiBUTFMgcGF5bG9hZCBieXRlcyBpbiBUWA0K
PiA+IHBhY2tldHMNCj4gDQo+IFN0YWNrIGFscmVhZHkgaGFzIHN0YXRzIGZvciBzb21lIG9mIHRo
ZXNlIGluIC9wcm9jL25ldC90bHNfc3RhdC4gDQo+IERvZXMgdGhpcyByZWFsbHkgbmVlZCB0byBi
ZSBwZXIgZGV2aWNlPw0KDQp0aGVzZSBhcmUgZ3JlYXQgZm9yIGRlYnVnLi4gSU1ITyBzdGF0cyBm
b3Igb2ZmbG9hZGVkIGZsb3dzIHBlciBkZXZpY2UNCmFyZSBuaWNlIHRoaW5nIHRvIGhhdmUgLi4g
IA0K
