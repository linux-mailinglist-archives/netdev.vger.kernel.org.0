Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1EF180CAA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgCJX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:57:35 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:6224
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727397AbgCJX5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 19:57:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOMWuUVfO4sNUHXixsWJOB42/6Y3BsN/4AMcA5MBffvLMCpwhkXMecbPcSfZdRphwmsYexA0O2rLg45fGKAqD7JdS9FEXLT+bk9XoT4/7TDqlP9vFVZPAg4h0RnY3MbNFlkas7dRD2tIwmrXBtZinF1WK//j1unGGM2QzGbgysPT6g5rVuM+1a2LW0l8gdZbRXo/4SrnT8IKAp8GvTZvxz8gXT9cBo1BvULEndvh76JFl3Vw3MQ6OxfcGbSpi8tYKyCtv2Xg3qvMFSM5AFz1D8zs3Sk0mdcllwI+/tshcpqSbTJMXpI1zXqdCmk0kjusdko3dXcqv7ydKfv3hq/SXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSjS/LRJmYsShCpQXnRE9fVsZ8od6xXIoPPJxUr7ZFU=;
 b=aLST8uoDlKYghb7hYSWNt39T0ifoWBb39DN13Ma46NaiTM0WEUxT/i4dnqwzs94bZ5qjm6td/14vUdQ67CCjoCJ95HU28gWK3e0Nj6z8M04U+h9t/G+fhi16Tqk1VFZ7pMtSb6LDMSNpVlw8/y32HdR3q2aVGrcmH0SCeWCw2qlenL2t2Gh+lTLUwjzFdxWjXRxnT5vkI8DISVN79NVEBZXmYcmQVMWpCne3JcYMhbjH+/6+MAzf2ZOHvPyvMDFcyOSHQYWi+hwKufesOFhUOyiQRM8YuDmBYFOWTGOEV+ol21jri3ZW7zLRv5UBg+H/YVkEYTaZK7kdL8TX3D6ixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSjS/LRJmYsShCpQXnRE9fVsZ8od6xXIoPPJxUr7ZFU=;
 b=n6t+vBz4Crem18jf5xM5Knx3G0u0AiU6IAHLEDhujiO2qDyTw3YGdb9PdLyda525Wttjq7IJNYey4qBBksR3h2li0rqEaOyFB8JfWGRzcYR9W0Wuhw0VQqNaKWYBes03V50+eMFlVCI01MaG42jGVRPjsik/jCch96OsOCsbHzs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3504.eurprd05.prod.outlook.com (10.175.242.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Tue, 10 Mar 2020 23:57:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 23:57:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commits in the net-next
 tree
Thread-Topic: linux-next: Signed-off-by missing for commits in the net-next
 tree
Thread-Index: AQHV9sLlUkLYzArmsEq8vpUsvhtdFahCgcgA
Date:   Tue, 10 Mar 2020 23:57:31 +0000
Message-ID: <ace96f9842592c35458e970af900ec7a43029ae5.camel@mellanox.com>
References: <20200310210130.04bd5e2f@canb.auug.org.au>
In-Reply-To: <20200310210130.04bd5e2f@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 65bb8c2e-07c3-4450-724f-08d7c54ecbd5
x-ms-traffictypediagnostic: VI1PR05MB3504:
x-microsoft-antispam-prvs: <VI1PR05MB35047E1FA8729B6C0B7A8E5EBEFF0@VI1PR05MB3504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(189003)(199004)(478600001)(81166006)(6506007)(2616005)(36756003)(76116006)(6512007)(66946007)(64756008)(66446008)(186003)(26005)(4326008)(66556008)(91956017)(66476007)(2906002)(8676002)(6486002)(8936002)(5660300002)(4744005)(316002)(71200400001)(86362001)(81156014)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3504;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rY03BPYLhze87war+TiXIjHnOKisu0DaTNn+ZKyR+hUjO0AZZgOyCSwtPdcJmRdau25G31u5ex1FQuC9KJGJkn+fxSrJSGXsHJIdGmvaenAClujfHxCy0AnVxNu6aDLylMCLJMp5Z7udHN5CS1dojeGoPVGq/yhG1ZEnD6tTcREu7huG/zO/ucdhSoLz/HOFLuPSd+6XBpgTWzeaiyrp010gg02GoEste2VJPPl0kQcWKF0HSEL6SU3DFWUbPbPTpY2/O3LMyPpVrmHIeCpJ7Rh5qX7eMQw1l6nk+s8m59ggrBXncLk89SD5WJRdsuPWdC0BUKoZvwyNHpS76yEc/0WxnL8R/lHmzXJpB+8THuNOUySUOyvQUcyj7sr3c4ezH3rgcffQxiuQKQ2hkt1WPYM8sQy0edarG34sZf9UWjznBWz8mLdY2qrDSQJq3L+f
x-ms-exchange-antispam-messagedata: s5AhGX6b+7vf1//qerMeejUZ3oPmC6zM95C+sWoFp6oOK6771ycjDmTXQ3nRMSr3YnTZ9WJVWyXmIhkO4tQdt8fdpI5skx/K7nHeasf4n9v1aiYBRCQvL3lgqoeU3z8T10/W3O1QR4FrKMc/xwTaww==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <57A42E158A2A414E8DFF4B7212C6F3D2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bb8c2e-07c3-4450-724f-08d7c54ecbd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 23:57:31.3229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwqkfaMd0GNaKD2m56tbuoKoS9YJrY36FPKiOYu920pldW5mZ72wxsYng5UoG9lorognrKHUWr78GiyGlFCadA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAzLTEwIGF0IDIxOjAxICsxMTAwLCBTdGVwaGVuIFJvdGh3ZWxsIHdyb3Rl
Og0KPiBIaSBhbGwsDQo+IA0KPiBDb21taXRzDQo+IA0KPiAgIGI2MzI5M2U3NTlhMSAoIm5ldC9t
bHg1ZTogU2hvdy9zZXQgUnggbmV0d29yayBmbG93IGNsYXNzaWZpY2F0aW9uDQo+IHJ1bGVzIG9u
IHVsIHJlcCIpDQo+ICAgNjc4M2U4YjI5ZjYzICgibmV0L21seDVlOiBJbml0IGV0aHRvb2wgc3Rl
ZXJpbmcgZm9yIHJlcHJlc2VudG9ycyIpDQo+ICAgMDEwMTNhZDM1NWQ2ICgibmV0L21seDVlOiBT
aG93L3NldCBSeCBmbG93IGluZGlyIHRhYmxlIGFuZCBSU1MgaGFzaA0KPiBrZXkgb24gdWwgcmVw
IikNCj4gDQoNCkhpIFN0ZXBoZW4sIA0KDQpjaGVja3BhdGNoIGRvZXNuJ3Qgc2VlbSB0byBjYXRj
aCBzdWNoIHByb2JsZW1zLi4gDQoNCkkgY291bnQgb24gb3VyIENJIHRvIGRvIHN1Y2ggY2hlY2tz
IGZvciBtZSwgc28gaW5zdGVhZCBvZiBtZSB3cml0aW5nIGEgDQpuZXcgc2NyaXB0IGV2ZXJ5IHRp
bWUgd2UgaGl0IGEgbmV3IHVuZm9yZXNlZW4gaXNzdWUsIGkgd2FzIHdvbmRlcmluZw0Kd2hlcmUg
Y2FuIGkgZmluZCB0aGUgc2V0IG9mIHRlc3Qvc2NyaXB0cyB5b3UgYXJlIHJ1bm5pbmcgPyANCg0K
PiBhcmUgbWlzc2luZyBhIFNpZ25lZC1vZmYtYnkgZnJvbSB0aGVpciBjb21taXR0ZXIuDQo+IA0K
