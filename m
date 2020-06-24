Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E43206A48
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbgFXCqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:46:55 -0400
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:4923
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387970AbgFXCqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:46:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ki+CHb/AeQ8cj6gX1RwStaMa+OqjvuTW5C5kd92tLzXTJG/akxKweCgNXyQOqkRVhcAv9bT+wkF5OmoOJE39D9Q2fr25e2vTFLD7a68ebhLKc4bQmi96PCTQ6YFQ/RZynbQb14yTW38/SEiEZM/xkp4c8ZFOpm+JyO+G4gd5tLVexa+djBKghlyGhxdNz8qQOuPsWESMggdH6hFzMIUPcx6484MpBRoJHIlcm2tKW/Pc3MsCKk6qW1/UDfFciCbm30A5rdjTjeybpmgoLznmB/6YTGv9rZ2B5mWp9RE1i//IwdUAcowM3EFQAFLVW/FEbmFt9xziR+vI0QctIc0+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=682vUF1dSWUgV3DI9VYlJu693iRQznmX7za23Q4izns=;
 b=bpjcc5GKgm1FjF+jhDbACI8eLzqvlWUpZGumtu7a3v3HR5Pd9WNgW0GWjNU6K+5cA7gW9sxGOzWHh/2S+9N0WNwMw1R8GsoskLcsFBX59ipXzvepDPpgZj5+mds1pa9V5k2ZKcITCaoTRUPilHwNODCv7ILQA5J33fdfBmte/1wTSI32GJ2f2jn1zbxnQsPOI8jUvyN0N5LCPEODOs8xqV9XxClW3xq/raHVWM5iYatL3YcypHCktLly74G2SzAXoVESftIzViKZSFp4f/fd7R+ol0cuz3rqvH7jeS2ASOfhWRNHjTB8s2NmEJR7W3874ePYiyBp4dWk8UzrOtnsbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=682vUF1dSWUgV3DI9VYlJu693iRQznmX7za23Q4izns=;
 b=FGlgtX85mLJjRLYM9/IYlgyj8HYLwaRUYwb4vWyVcCuwy7uvy8gEe2L290kuVQllDlax4C5+hDbLQZ5H9Qy/EGxUaj7wrgKvEB3VCPWDfBIgRm42BJT6+CuaiTzkO8YDatvYmeLImCYijc32WhVb80PJQD9g79CYeP0+M8txpaM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 24 Jun
 2020 02:46:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:46:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "xianfengting221@163.com" <xianfengting221@163.com>
Subject: Re: [net-next V2 03/10] net/mlx5: Add a missing macro undefinition
Thread-Topic: [net-next V2 03/10] net/mlx5: Add a missing macro undefinition
Thread-Index: AQHWSc4h17q4bl6C80CIzEmjguLFpKjnD8uA
Date:   Wed, 24 Jun 2020 02:46:50 +0000
Message-ID: <ff82fea55817b95e0995e3f2cb6dcce2e2fdbb01.camel@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
         <20200624021825.53707-4-saeedm@mellanox.com>
In-Reply-To: <20200624021825.53707-4-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0509a343-f61a-4cd8-713c-08d817e8d86b
x-ms-traffictypediagnostic: VI1PR05MB7117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB711741842274463BD67B9A35BE950@VI1PR05MB7117.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VUZbP44w0MoF/UvGx1n6nVi7eZ7oc7r8LPWFwxRmAYMcgGew1T3b07jwq/ySti6grgKIj7xYNufQe/h68HteU06Awv4GTXtrBUaF/cN2Ad4s7RMIMhZ75SV8Tq5kt5my6QSmoox//F/P9z7a6gH2XoRaGc4561iOgw8Ylcuc5DCqwwcS2qNQu2eZk3N+rESoWDxschLUH1IIeUFTRMfBvvVieOqrrBbUFGX3Fo3HiaoOFDnNCzWTegzOSv3sUA0Sd6ljVweU7qepq77LtlQZWY/hyCwBhfiVpF1NbuwWz6hV+PKwEQfFmT7YwmV7bZle
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(39850400004)(396003)(316002)(110136005)(6512007)(54906003)(86362001)(36756003)(2906002)(6506007)(4326008)(2616005)(186003)(478600001)(26005)(71200400001)(64756008)(91956017)(76116006)(66946007)(66446008)(66556008)(5660300002)(6486002)(8676002)(8936002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rKID3TR7b/gmDGeggyTGxmIHUah+7KdutTcDWVGG4wWpTASo9UMk7Ua7aOjyJTUT3wT8lHenx6+uagoNvXnSFqsV7+pjwxAhtEHtV7wmbfMdfq5AL/HYwnBZ6XmaZeha4EwUpa1PKMFyfwQbPsXKkXieg0oOKNpSIuol2R+2bjYRSF9iMxil96CzWBJ/5I/+6UYJpy0FBhnAiJH13D7vUs55LPaRJCXc3zy8EI2mDZvujX3bjpCrxmewI3bVJOl0EIgYtefn+GeN5W2p3Gn82x2v0s7259NRC1R7rlijwXeCF9PxqRIF5TkqB28YngHTUuGgaGEsQvOQV3UCiC/rQRnFVdXHHUdwrpQeRWmoNyRffGfFG/0i5xD3p4cO1XJrT7jwxWt1c8hL9Jb1BH9EfirGCa1h8/ove0AeANdGnBxapDo3Bl/+GH6HkYn/D4G2PhrJ5BdYbGbs9kAC/Fq8KSErW+Ckh6MQ7C040mYYHAI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DDDED45DB73C046BB4CAEA5FD2A0184@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0509a343-f61a-4cd8-713c-08d817e8d86b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 02:46:50.2317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gJs0IwN4W2yrRfJcF9xL5KoGPTc7T/XvBLPijGtGDI1w744GzCgdhqZ6hVsXozZ13XYM7bVnNRT4jJ41ElacSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTIzIGF0IDE5OjE4IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gRnJvbTogSHUgSGFvd2VuIDx4aWFuZmVuZ3RpbmcyMjFAMTYzLmNvbT4NCj4gDQo+IFRoZSBt
YWNybyBPRFBfQ0FQX1NFVF9NQVggaXMgb25seSB1c2VkIGluIGZ1bmN0aW9uDQo+IGhhbmRsZV9o
Y2FfY2FwX29kcCgpDQo+IGluIGZpbGUgbWFpbi5jLCBzbyBpdCBzaG91bGQgYmUgdW5kZWZpbmVk
IHdoZW4gdGhlcmUgYXJlIG5vIG1vcmUgdXNlcw0KPiBvZiBpdC4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEh1IEhhb3dlbiA8eGlhbmZlbmd0aW5nMjIxQDE2My5jb20+DQo+IFJldmlld2VkLWJ5OiBM
ZW9uIFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiAtLS0NCg0KaG1tLCBJIGp1c3Qg
c2F3IHRoYXQgdGhlcmUgd2VyZSBzb21lIHN0cm9uZyBvcGluaW9ucyBhZ2FpbnN0IHRoaXMNCnBh
dGNoLCBhbmQgYWN0dWFsbHkgaSBhZ3JlZSB3aXRoIHRoZW0gOiksIHdpbGwgZHJvcCBpdCAuLiAN
Cg0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYyB8IDIg
KysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KPiBpbmRleCA4YjY1
ODkwOGYwNDQyLi5iZTAzOGVkMTY1OGI4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4gQEAgLTQ4OSw2ICs0ODksOCBAQCBzdGF0
aWMgaW50IGhhbmRsZV9oY2FfY2FwX29kcChzdHJ1Y3QNCj4gbWx4NV9jb3JlX2RldiAqZGV2LCB2
b2lkICpzZXRfY3R4KQ0KPiAgCU9EUF9DQVBfU0VUX01BWChkZXYsIGRjX29kcF9jYXBzLnJlYWQp
Ow0KPiAgCU9EUF9DQVBfU0VUX01BWChkZXYsIGRjX29kcF9jYXBzLmF0b21pYyk7DQo+ICANCj4g
KyN1bmRlZiBPRFBfQ0FQX1NFVF9NQVgNCj4gKw0KPiAgCWlmICghZG9fc2V0KQ0KPiAgCQlyZXR1
cm4gMDsNCj4gIA0K
