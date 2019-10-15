Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4D4D6FA3
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 08:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfJOGij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 02:38:39 -0400
Received: from mail-eopbgr60094.outbound.protection.outlook.com ([40.107.6.94]:2442
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726052AbfJOGii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 02:38:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9etieyO0l6I63uncCJpvIfh/4dCjj2lBXh8hAZYZMx/i/SXfC0d/rfOjE6r1QGHe+SF/DX4TFHWphtRv01/9NiAbGk1geJ++OOodKemj5V/DjXU3Vq0yRxP7RzR7OZrW0E3sgDaTVeseKQHeuwpOztA+vIVk3TfVNQ1gIDy7gb2Z/scv0FWamDcBpGpnRBy6uXyUdlMOkD2TQIQv4Ui3TgzqTmt6n/oTxjWex2mnYDOxWY4Ss2A+Zw07Pnycbc3rzeHV6SxMFymS6goIZUxSfk5O32eH+Y5hbCjF7iBlLfEKKBK6N6bYQAjz89tkzUQw/bwg1BEg36rSLaTTkg9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duOP1waQLNCVJ4EvnBkR9yNdgkam/2+iHL8xDVISOzg=;
 b=hlDCE9HcUoqwNqIRsxlBeSVTGtwjh/7U4rNswakYEoZfzHKLjD1CqrcJ1ahDud12ypcsvg7iiDroWnxwtJjI52sSrY4zg3UqAITwdWudqbn2to4Zh0Gpm5eJaR+9ies52uTF3s2ucU1DSj2+vdgrOcffUaY22riBl/2+jjfSCT8wNm482IqKDRcXb+jx2irOp7fAMTAp8mHgvbFhs50aTbzYb0B/6MOa03bxLZzhy4Ct2nExPfEI81UJkwfoTKJwSbA1a+3Az/owdC1wEGxrZ7lNRLTPTb1j5o00Fqq76L5FydRjSCevyuJOlxTVt7cH+A8S8IqBFJ8z+8E3PsD1lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duOP1waQLNCVJ4EvnBkR9yNdgkam/2+iHL8xDVISOzg=;
 b=zR5J9mYHy9XKV1+kbFPp0eTqY63irL+sCArD47cVEoj2TyGTTEskZZwT8ZI0ORdHQm/XRCvR1dDdnXpoTbEA8is9ru0NnYnM1LYf3DaEdkYaTa4yn5f6vYZCx/tEuQvK41CcjKPXMFTxjnU0sTLY5bQwRNLCusWKtPyQQLaDEok=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2141.eurprd07.prod.outlook.com (10.169.137.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.10; Tue, 15 Oct 2019 06:37:54 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::49b7:a244:d3e4:396c%9]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 06:37:54 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Simon Horman <simon.horman@netronome.com>,
        kbuild test robot <lkp@intel.com>
CC:     Pankaj Sharma <pankj.sharma@samsung.com>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "rcsekar@samsung.com" <rcsekar@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
Subject: Re: [PATCH] can: m_can: fix boolreturn.cocci warnings
Thread-Topic: [PATCH] can: m_can: fix boolreturn.cocci warnings
Thread-Index: AQHVgqC6kxp5Y3lYAEWW8xE0x20ntadbNZEAgAALUAA=
Date:   Tue, 15 Oct 2019 06:37:54 +0000
Message-ID: <9ad7810b-2205-3227-7ef9-0272f3714839@victronenergy.com>
References: <1571052844-22633-1-git-send-email-pankj.sharma@samsung.com>
 <20191014150428.xhhc43ovkxm6oxf2@332d0cec05f4>
 <20191015055718.mypn63s2ovgwipk3@netronome.com>
In-Reply-To: <20191015055718.mypn63s2ovgwipk3@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-originating-ip: [2001:1c01:3bc5:4e00:5d25:5e63:2275:b34e]
x-clientproxiedby: AM0PR02CA0002.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::15) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bd366d7-e97c-45a9-6cea-08d7513a3538
x-ms-traffictypediagnostic: VI1PR0701MB2141:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0701MB21416A61F332F34FD6D73363C0930@VI1PR0701MB2141.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(366004)(346002)(136003)(39850400004)(189003)(199004)(25786009)(31686004)(102836004)(2906002)(71190400001)(6116002)(186003)(478600001)(76176011)(7416002)(966005)(71200400001)(4326008)(386003)(6506007)(53546011)(14454004)(305945005)(7736002)(66946007)(66476007)(66556008)(66446008)(64756008)(6436002)(446003)(11346002)(65806001)(65956001)(5660300002)(2616005)(31696002)(6486002)(6512007)(58126008)(8676002)(6246003)(81156014)(81166006)(486006)(36756003)(6306002)(8936002)(86362001)(46003)(476003)(54906003)(99286004)(110136005)(256004)(14444005)(52116002)(316002)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2141;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OV2BXaOzDfGygHHwxbq2wTIYt+pMDHp4GhZdBs8XBVUgOesNj9g6BL0EU0CmO2xf4qMxVFO/1OPl08mj+kUb8NtWKXgG6v8rMr1uLuKN+You6LEqrDYggdbRQmhpPAPvyhPz0yKDudlZaHsmz/wrLN7xe4+FYW+jdRnC1cW9xxUG/GMyer+bqErNmjtrihCMyCUuohS6LxDqPOZ2D6tjQEy5LAQJO/ioISxPxQQSFsMjeVA2fGXjsHBBxcODPWPO722xRcThkc4DLDDiSPT6gz1eMgaoca4TAX6ag4+HsLsqHIpiX1kPOaoqsxbfEbHtxlx9AEXcCFtfuvTbAeooFeKZnI3fj3/HHM7vcZBfBphhuTVrvqUe0gKFOA5e8dxAKZaKEMhsRXWuqCePMWxuK/Xd5fab5GZk6sU7L9b1aVELnSDRCPnb4kUD7erML71UTEU7gRu95qWhC8Tmks44VA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD62C6ECD996A94FA3C4F36AE0F4CF58@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd366d7-e97c-45a9-6cea-08d7513a3538
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 06:37:54.1846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqBk1Y/1PZzMHknYyYwkklz0HJrjdOT6Zwpfns38luMiHR5NiuYB08pykNEtSUkgD7deCHatkDHyOXOQauWlDl7R5ZM5JXHJV1MToJaZ668=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIDEwLzE1LzE5IDc6NTcgQU0sIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4gT24gTW9u
LCBPY3QgMTQsIDIwMTkgYXQgMTE6MDQ6MjhQTSArMDgwMCwga2J1aWxkIHRlc3Qgcm9ib3Qgd3Jv
dGU6DQo+PiBGcm9tOiBrYnVpbGQgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4+DQo+PiBk
cml2ZXJzL25ldC9jYW4vbV9jYW4vbV9jYW4uYzo3ODM6OS0xMDogV0FSTklORzogcmV0dXJuIG9m
IDAvMSBpbiBmdW5jdGlvbiAnaXNfcHJvdG9jb2xfZXJyJyB3aXRoIHJldHVybiB0eXBlIGJvb2wN
Cj4+DQo+PiAgIFJldHVybiBzdGF0ZW1lbnRzIGluIGZ1bmN0aW9ucyByZXR1cm5pbmcgYm9vbCBz
aG91bGQgdXNlDQo+PiAgIHRydWUvZmFsc2UgaW5zdGVhZCBvZiAxLzAuDQo+PiBHZW5lcmF0ZWQg
Ynk6IHNjcmlwdHMvY29jY2luZWxsZS9taXNjL2Jvb2xyZXR1cm4uY29jY2kNCj4+DQo+PiBGaXhl
czogNDY5NDYxNjNhYzYxICgiY2FuOiBtX2NhbjogYWRkIHN1cHBvcnQgZm9yIGhhbmRsaW5nIGFy
Yml0cmF0aW9uIGVycm9yIikNCj4+IENDOiBQYW5rYWogU2hhcm1hIDxwYW5rai5zaGFybWFAc2Ft
c3VuZy5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBrYnVpbGQgdGVzdCByb2JvdCA8bGtwQGludGVs
LmNvbT4NCj4+IC0tLQ0KPj4NCj4+IHVybDogICAgaHR0cHM6Ly9naXRodWIuY29tLzBkYXktY2kv
bGludXgvY29tbWl0cy9QYW5rYWotU2hhcm1hL2Nhbi1tX2Nhbi1hZGQtc3VwcG9ydC1mb3ItaGFu
ZGxpbmctYXJiaXRyYXRpb24tZXJyb3IvMjAxOTEwMTQtMTkzNTMyDQo+Pg0KPj4gICBtX2Nhbi5j
IHwgICAgNCArKy0tDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQo+Pg0KPj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL21fY2FuL21fY2FuLmMNCj4+
ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9tX2Nhbi9tX2Nhbi5jDQo+PiBAQCAtNzgwLDkgKzc4MCw5
IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpc19sZWNfZXJyKHUzMiBwc3IpDQo+PiAgIHN0YXRpYyBp
bmxpbmUgYm9vbCBpc19wcm90b2NvbF9lcnIodTMyIGlycXN0YXR1cykNCj4+ICAgew0KPj4gICAJ
aWYgKGlycXN0YXR1cyAmIElSX0VSUl9MRUNfMzFYKQ0KPj4gLQkJcmV0dXJuIDE7DQo+PiArCQly
ZXR1cm4gdHJ1ZTsNCj4+ICAgCWVsc2UNCj4+IC0JCXJldHVybiAwOw0KPj4gKwkJcmV0dXJuIGZh
bHNlOw0KPj4gICB9DQo+PiAgIA0KPj4gICBzdGF0aWMgaW50IG1fY2FuX2hhbmRsZV9wcm90b2Nv
bF9lcnJvcihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCB1MzIgaXJxc3RhdHVzKQ0KPj4NCj4gPDJj
Pg0KPiBQZXJoYXBzIHRoZSBmb2xsb3dpbmcgaXMgYSBuaWNlciB3YXkgdG8gZXhwcmVzcyB0aGlz
IChjb21wbGV0ZWx5IHVudGVzdGVkKToNCj4NCj4gCXJldHVybiAhIShpcnFzdGF0dXMgJiBJUl9F
UlJfTEVDXzMxWCk7DQo+IDwvMmM+DQoNCg0KUmVhbGx5Li4uLiwgISEgZm9yIGJvb2wgLyBfQm9v
bCB0eXBlcz8gd2h5IG5vdCBzaW1wbHk6DQoNCnN0YXRpYyBpbmxpbmUgYm9vbCBpc19wcm90b2Nv
bF9lcnIodTMyIGlycXN0YXR1cykNCglyZXR1cm4gaXJxc3RhdHVzICYgSVJfRVJSX0xFQ18zMVg7
DQp9DQoNClJlZ2FyZHMsDQpKZXJvZW4NCg0K
