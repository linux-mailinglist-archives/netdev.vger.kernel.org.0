Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC3C2064B4
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389734AbgFWV0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:26:10 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:3808
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389346AbgFWV0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gu6IA/+68vcLOG8Rbph78mrg3VPV1KyR4L/yIX40tBXdxVjbAVWZqj0pKUIV01CtaMdMvT5rPBWkpI/RTJlpG9Cn+aOz84eh/ThWVIONCbCJRZ+LO2sczNlHyED35i4bITRYGe5XQzBphhnXqeJNJRIB2NcTYJPwuAt2JVUwrUPUmq+CpKTdexsvtObIOsRYaAdJIdKSXE+NCGTvyE96qJutMrctVKBvZ4gTNqYPZyDsPpRyuhLVglS7Wq5HPUHD3kAs1bTr0z23wVJks5FsfKOpKIqYpzzO/lo+sWY//PVArX5u6Ep9dJF8bPTLotza4E+mseH2LBABcwQMJjVouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uwBguDcUNbKQe0Y6H/+Dk82dy6R1dkN7rrcmwvvCLo=;
 b=Dn5MCj8Twgd72V9UNFrZJdl24L8Q05UiicwpUYFiDOFIWsSZM+eDP9M7M8pOTtF2EBTA41aluuokhjPQb3Ha6IvDPW2B0xL2xaWgTtyiTOiTMZQ8yZelLYBOy9NuASU5+JbTXWv0cbLMFVoV4/grO+IyVRi5m03JtGF8gd3WjRzinQF481zdA88mT2SfxpitPgY+dun4BfjffVbp6Wzs7aEaun4PM8LLYYcuLS84wQrOeSsNKVnTRNzpNU9xhE5No6IsYxuiwqoT6T/EzLcmbqN7tP9ld/ZXPciflBtTIPSqEBmvfY2YxMZVsxYV60C0pZTD5Qeu661S5BUS7gGqtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uwBguDcUNbKQe0Y6H/+Dk82dy6R1dkN7rrcmwvvCLo=;
 b=NnD1dijIhIWy60SJE6xXK49Ug6RH8iS/cgUxmF7Z73YaimtEXkl67Wc9KwuPrDdg3zQHjV3wv1/ihC1rRKEOUafw9cA5tKWHP4q6/QtkokiPffahJT2cLQV9mqFjMuKX3Vlg0fbburnHCN2joeoSFAMLhqhKCzCuMBUsAN8MAes=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2910.eurprd05.prod.outlook.com (2603:10a6:800:ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 23 Jun
 2020 21:26:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Tue, 23 Jun 2020
 21:26:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Roi Dayan <roid@mellanox.com>, Maor Dickman <maord@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [net-next 07/10] net/mlx5e: Move TC-specific function definitions
 into MLX5_CLS_ACT
Thread-Topic: [net-next 07/10] net/mlx5e: Move TC-specific function
 definitions into MLX5_CLS_ACT
Thread-Index: AQHWSZfq37UdeWCSzEWJRQtkOpKR7KjmsG6AgAAGKIA=
Date:   Tue, 23 Jun 2020 21:26:02 +0000
Message-ID: <3e259566a57c6ce50843c1fadd80530e3307bc62.camel@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
         <20200623195229.26411-8-saeedm@mellanox.com>
         <20200623140357.6412f74f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623140357.6412f74f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e49562dc-eea3-450a-ef14-08d817bc07d8
x-ms-traffictypediagnostic: VI1PR0502MB2910:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0502MB291048A383E793101D89CAF3BE940@VI1PR0502MB2910.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8vExJv6k3NLWij8C3xMA74agdNORBcK6s6yQXQp6pshc9Rsj8Hy9HQ3RQVBL5UuhkmC0abp0nXI0sSubOcj30DZO+h/o7WG5nL6Pp5JFTg6H8P3G79YilZT+rwANyMv1wTfxWJEUKd7k0SBEASBT1+iv0tXJxqqpq8UwRxNukdYhdDCGaebjXqEuGidkbhI2U3njB2GvoJYTiFIbUWDjRAAXDGnUTG4JoQ8hYKQhqtP6Nq7WpMfnuP9uJzrBMQW/RV3qG4Ja5+QEInAtWDEpfo4Ab2m75Sua5fcgT7Xv34C8JviwDUTsllggEqJZWfqCCKhw8vX71glFZ1ZTp7WStg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39850400004)(4744005)(6506007)(5660300002)(71200400001)(36756003)(2616005)(86362001)(54906003)(316002)(6512007)(4326008)(8676002)(8936002)(76116006)(91956017)(107886003)(478600001)(66446008)(64756008)(66946007)(66556008)(66476007)(6916009)(83380400001)(26005)(186003)(2906002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fHXQ278Bc+BeuHYJUUZLmJlNFfZwQ6jKQtR8DkF3VZtzwpEKiTIVQMs9ITI27qAuunxww+q67AWYM51fwcgRMzeQOtaqf4291UQ+e+L1Q51cRji7TwbVI/fECudqDrA+yct09a1qWNp4KlRKdPRG/K4DGlLT0xXRbYX0MdPzx3dSODEXiXmHY82qP4BtfC4Wuo+wE76/y25ZeJjLxLVSaNHn4v7mtuTxeScZqvXiwx0DxIX07tqaaVfewZxs2UWIeC88PqqqR/aUSb3fNOkZOLCqXr5JNIaHw9Nanp5QHliWyzNfHuNR8PQuXUot5VxqiU0RDUaP+GSbr2ApjnP4kRUuXkmfwL9HvvKUcOQ9RdIBVWzLrDQ8CVcsOCa86uGhYsr+iDs+CbtjkZ9KzAnggjt1t2QWt5EVcUncpcF2cvBMpqMLmRC+4tfqn79+ZSa7EgNeR6vX0U0iYvhvfdhx4+F7XCbzI2ePZGCf3QA+MlruHigmJ/VxuH34SK+rvaNf
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AEEB7067CA13443835FC15771313E53@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49562dc-eea3-450a-ef14-08d817bc07d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 21:26:02.4463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lFd5PR5fAto9JIKfZJPodlCtXMBqT7ttJWtiwOw5aBPyqoES4HzmIIJ6q1HeO8QqwY3jQouKH5GNz19nPqXlGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2910
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTIzIGF0IDE0OjAzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyMyBKdW4gMjAyMCAxMjo1MjoyNiAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBWbGFkIEJ1c2xvdiA8dmxhZGJ1QG1lbGxhbm94LmNvbT4NCj4gPiANCj4g
PiBlbl90Yy5oIGhlYWRlciBmaWxlIGRlY2xhcmVzIHNldmVyYWwgVEMtc3BlY2lmaWMgZnVuY3Rp
b25zIGluDQo+ID4gQ09ORklHX01MWDVfRVNXSVRDSCBibG9jayBldmVuIHRob3VnaCB0aG9zZSBm
dW5jdGlvbnMgYXJlIG9ubHkNCj4gPiBjb21waWxlZA0KPiA+IHdoZW4gQ09ORklHX01MWDVfQ0xT
X0FDVCBpcyBzZXQsIHdoaWNoIGlzIGEgcmVjZW50IGNoYW5nZS4gTW92ZQ0KPiA+IHRoZW0gdG8N
Cj4gPiBwcm9wZXIgYmxvY2suDQo+ID4gDQo+ID4gRml4ZXM6IGQ5NTY4NzNmOTA4YyAoIm5ldC9t
bHg1ZTogSW50cm9kdWNlIGtjb25maWcgdmFyIGZvciBUQw0KPiA+IHN1cHBvcnQiKQ0KPiANCj4g
YW5kIGhlcmUuLi4gZG8gdGhvc2UgYnJlYWsgYnVpbGQgb3Igc29tZXRoaW5nPw0KDQpObywganVz
dCByZWR1bmRhbnQgZXhwb3N1cmUgYW5kIGxlZnRvdmVycy4NCkRvIHlvdSB3YW50IG1lIHRvIHJl
bW92ZSB0aGUgRml4ZXMgVGFncyA/DQpQZXJzb25hbGx5IEkgZG9uJ3QgbWluZCBmaXhlcyB0YWdz
IGZvciBzb21ldGhpbmcgdGhpcyBiYXNpYywNCmJ1dCB5b3VyIGNhbGwuLiANCg0KPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBWbGFkIEJ1c2xvdiA8dmxhZGJ1QG1lbGxhbm94LmNvbT4NCj4gPiBSZXZp
ZXdlZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT4NCj4gPiBSZXZpZXdlZC1ieTog
TWFvciBEaWNrbWFuIDxtYW9yZEBtZWxsYW5veC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2Fl
ZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo=
