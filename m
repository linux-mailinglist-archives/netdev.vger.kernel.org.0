Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792BBF06B0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 21:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbfKEUKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 15:10:13 -0500
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:36230
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbfKEUKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 15:10:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5ZSZL0PEdKwh03Sww8sQ46LFsOW52uKpH7yCZgXuAj9leqUR4XHeQBKaxGobf9edShyowsVihCQOIDOtBczIeIYZp3GDywQ6Z3W9+vIUzfm1mJO/XJDpI0b7gtwgLBJdeJxXXaTb6PDnzeH5xm2ihTwqnqShtmDh2+Q5LSTobHeD213n+ijZwD6JiSlsWN4LlQQruSnFU+3VhnAzp0VIEl8RimD+/4H8yqBhDPXzNGSezbwLcmhJSq2wEKFPvocrSNMkIlUDJSe8OEY2POLlsll2DhFFXwdpr7GuftFe6qdGjLjtsfIq5UQw4DWyVeR7oLJg+xA0PVJZCif4D9WUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2eqR0BDaDeVL7FGY9kLqqIwrInUAMMfB02WApcfYjg=;
 b=YxH8ndiWXdt/OiN5fCITPX1ToM02G+2CCXSioyGLnMUi2e4a7ryZWDBfGToB3+z/YYLN6CGr/9835537mewg2d1FEcXkq6MHb2WiJru0CWqFudrlkC+JggLulgUtxn3T8oD5zzwDR3RnvBHfC+jvJDejv2Ez6bNpjzOAOlb8O5heWajPs9rpCS0bPScDiu7t4L9ssxgo9LNUA/oSudUuiKm24xKD4mpjTlx1Hux7Yc7mT1Wg4hf1SN7SkRxG2xgpOv5yNX2/FFJxE0d+MBKaEzQ54NYZ46zAlJNKXlkiqewMZsAUpureJ8WZhu73DVpgY/IpoZhK68oi8sBTAJrR2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2eqR0BDaDeVL7FGY9kLqqIwrInUAMMfB02WApcfYjg=;
 b=Bj2HXzqenz9jzCNNNnqTEk22qqH9iGo3Nu0tRnoqTHTR+yfBwgrOwPLuvMoPGTx4+yW+g+5i55btE9DB/tOfOB4/ECOT6mYsAuJndOl+lj12kwbBPOTHQySMMQ2DpqQIYnuBTv7B6pXlnLrqIevEoD8zG8db+ZLPCEoxmZae3ME=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5264.eurprd05.prod.outlook.com (20.178.10.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 20:10:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 20:10:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AIAAMEAAgATMggCAAAKoAIAADVYAgAEmsAA=
Date:   Tue, 5 Nov 2019 20:10:02 +0000
Message-ID: <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
         <20191031172330.58c8631a@cakuba.netronome.com>
         <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
         <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
         <20191101172102.2fc29010@cakuba.netronome.com>
         <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
         <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
         <20191104183516.64ba481b@cakuba.netronome.com>
In-Reply-To: <20191104183516.64ba481b@cakuba.netronome.com>
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
x-ms-office365-filtering-correlation-id: 4761edd4-5c66-4819-46e9-08d7622c24c3
x-ms-traffictypediagnostic: VI1PR05MB5264:|VI1PR05MB5264:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5264A903D67BC36D23B70D81BE7E0@VI1PR05MB5264.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(199004)(189003)(446003)(6116002)(6486002)(2616005)(3846002)(6246003)(54906003)(6512007)(11346002)(71190400001)(71200400001)(26005)(14444005)(305945005)(66066001)(186003)(7736002)(66946007)(256004)(6436002)(486006)(229853002)(476003)(8676002)(76116006)(91956017)(4326008)(107886003)(66476007)(102836004)(316002)(86362001)(118296001)(8936002)(81166006)(2501003)(6506007)(53546011)(36756003)(81156014)(58126008)(25786009)(2906002)(5660300002)(64756008)(478600001)(66446008)(14454004)(76176011)(110136005)(99286004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5264;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RePTMtjIApQMCY5hQV1DDzQfBnneffroIbjGJkrBDvkHo92duVS8T/3t9fN4SUgWX3Myo8qaiB46j8LTw+TL07VIDhpFGBha3TfvayWhD+sZf8DP/z2CRF9Jj/TPFAONHysuNWOsV2EQhlmQFJqIq2UCfpKMqgJaxuNN5Vc5HUyleVhN25RYVVyR+Fa6SlHlakbnz93pIfZ8CNFW7CGzMSS752zyVRoSlPIsuJLb0mmxbIb6oW7YHLPwW2laPuWwsg7KGEXp/AOA9FbaJp44eYjoepyjms8ESBwpYq/tUOznqrBco5wMcz9WbgzEKn6ktw/9g26r4/dX8qBhV2vfRPbY1ElpFteTsyYtu07YOJraFBnTDMlW+LBsrDinTZTRtPsvSWJI8jc75mjOkD1fHcM0uAan8mAh7g/hC+MFaNkEw8FyzXj/MAXXvNajrpBD
Content-Type: text/plain; charset="utf-8"
Content-ID: <83A56F6BF54DA448BE37488824775F28@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4761edd4-5c66-4819-46e9-08d7622c24c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 20:10:02.9036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zj6WQRzvUbBslu1eSWZ4vC3QNPjhtU8GlARfVTLOY7U89Pm8bQkc63C0PONo2hWj7XORL2EaLqplXZ6wB+k82A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5264
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTExLTA0IGF0IDE4OjM1IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCA0IE5vdiAyMDE5IDE4OjQ3OjMyIC0wNzAwLCBEYXZpZCBBaGVybiB3cm90ZToN
Cj4gPiBPbiAxMS80LzE5IDY6MzggUE0sIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiA+ID4gT24g
RnJpLCAyMDE5LTExLTAxIGF0IDE3OjIxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZTogIA0K
PiA+ID4gPiBPbiBGcmksIDEgTm92IDIwMTkgMjE6Mjg6MjIgKzAwMDAsIFNhZWVkIE1haGFtZWVk
IHdyb3RlOiAgDQo+ID4gPiA+ID4gQm90dG9tIGxpbmUsIHdlIHRyaWVkIHRvIHB1c2ggdGhpcyBm
ZWF0dXJlIGEgY291cGxlIG9mIHllYXJzDQo+ID4gPiA+ID4gYWdvLA0KPiA+ID4gPiA+IGFuZA0K
PiA+ID4gPiA+IGR1ZSB0byBzb21lIGludGVybmFsIGlzc3VlcyB0aGlzIHN1Ym1pc3Npb24gaWdu
b3JlZCBmb3IgYQ0KPiA+ID4gPiA+IHdoaWxlLA0KPiA+ID4gPiA+IG5vdyBhcw0KPiA+ID4gPiA+
IHRoZSBsZWdhY3kgc3Jpb3YgY3VzdG9tZXJzIGFyZSBtb3ZpbmcgdG93YXJkcyB1cHN0cmVhbSwg
d2hpY2gNCj4gPiA+ID4gPiBpcw0KPiA+ID4gPiA+IGZvciBtZQ0KPiA+ID4gPiA+IGEgZ3JlYXQg
cHJvZ3Jlc3MgSSB0aGluayB0aGlzIGZlYXR1cmUgd29ydGggdGhlIHNob3QsIGFsc28gYXMNCj4g
PiA+ID4gPiBBcmllbA0KPiA+ID4gPiA+IHBvaW50ZWQgb3V0LCBWRiB2bGFuIGZpbHRlciBpcyBy
ZWFsbHkgYSBnYXAgdGhhdCBzaG91bGQgYmUNCj4gPiA+ID4gPiBjbG9zZWQuDQo+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gRm9yIGFsbCBvdGhlciBmZWF0dXJlcyBpdCBpcyB0cnVlIHRoYXQgdGhlIHVz
ZXIgbXVzdCBjb25zaWRlcg0KPiA+ID4gPiA+IG1vdmluZyB0bw0KPiA+ID4gPiA+IHdpdGNoZGV2
IG1vZGUgb3IgZmluZCBhIGFub3RoZXIgY29tbXVuaXR5IGZvciBzdXBwb3J0Lg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IE91ciBwb2xpY3kgaXMgc3RpbGwgc3Ryb25nIHJlZ2FyZGluZyBvYnNvbGV0
aW5nIGxlZ2FjeSBtb2RlDQo+ID4gPiA+ID4gYW5kDQo+ID4gPiA+ID4gcHVzaGluZw0KPiA+ID4g
PiA+IGFsbCBuZXcgZmVhdHVyZSB0byBzd2l0Y2hkZXYgbW9kZSwgYnV0IGxvb2tpbmcgYXQgdGhl
IGZhY3RzDQo+ID4gPiA+ID4gaGVyZSAgSQ0KPiA+ID4gPiA+IGRvDQo+ID4gPiA+ID4gdGhpbmsg
dGhlcmUgaXMgYSBwb2ludCBoZXJlIGFuZCBST0kgdG8gY2xvc2UgdGhpcyBnYXAgaW4NCj4gPiA+
ID4gPiBsZWdhY3kNCj4gPiA+ID4gPiBtb2RlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgaG9w
ZSB0aGlzIGFsbCBtYWtlIHNlbnNlLiAgIA0KPiA+ID4gPiANCj4gPiA+ID4gSSB1bmRlcnN0YW5k
IGFuZCBzeW1wYXRoaXplLCB5b3Uga25vdyBmdWxsIHdlbGwgdGhlIGJlbmVmaXRzIG9mDQo+ID4g
PiA+IHdvcmtpbmcNCj4gPiA+ID4gdXBzdHJlYW0tZmlyc3QuLi4NCj4gPiA+ID4gDQo+ID4gPiA+
IEkgd29uJ3QgcmVpdGVyYXRlIHRoZSBlbnRpcmUgcmVzcG9uc2UgZnJvbSBteSBwcmV2aW91cyBl
bWFpbCwNCj4gPiA+ID4gYnV0IHRoZQ0KPiA+ID4gPiBib3R0b20gbGluZSBmb3IgbWUgaXMgdGhh
dCB3ZSBoYXZlbid0IGFkZGVkIGEgc2luZ2xlIGxlZ2FjeSBWRg0KPiA+ID4gPiBORE8NCj4gPiA+
ID4gc2luY2UgMjAxNiwgSSB3YXMgaG9waW5nIHdlIG5ldmVyIHdpbGwgYWRkIG1vcmUgYW5kIEkg
d2FzDQo+ID4gPiA+IHRyeWluZyB0bw0KPiA+ID4gPiBzdG9wIGFueW9uZSB3aG8gdHJpZWQuDQo+
ID4gPiA+ICANCj4gPiA+IA0KPiA+ID4gVGhlIE5ETyBpcyBub3QgdGhlIHByb2JsZW0gaGVyZSwg
d2UgY2FuIHBlcmZlY3RseSBleHRlbmQgdGhlDQo+ID4gPiBjdXJyZW50DQo+ID4gPiBzZXRfdmZf
dmxhbl9uZG8gdG8gYWNoaWV2ZSB0aGUgc2FtZSBnb2FsIHdpdGggbWluaW1hbCBvciBldmVuIE5P
DQo+ID4gPiBrZXJuZWwNCj4gPiA+IGNoYW5nZXMsIGJ1dCBmaXJzdCB5b3UgaGF2ZSB0byBsb29r
IGF0IHRoaXMgZnJvbSBteSBhbmdlbCwgaSBoYXZlDQo+ID4gPiBiZWVuDQo+ID4gPiBkb2luZyBs
b3RzIG9mIHJlc2VhcmNoIGFuZCB0aGVyZSBhcmUgbWFueSBwb2ludHMgZm9yIHdoeSB0aGlzDQo+
ID4gPiBzaG91bGQgYmUNCj4gPiA+IGFkZGVkIHRvIGxlZ2FjeSBtb2RlOg0KPiA+ID4gDQo+ID4g
PiAxKSBTd2l0Y2hkZXYgbW9kZSBjYW4ndCByZXBsYWNlIGxlZ2FjeSBtb2RlIHdpdGggYSBwcmVz
cyBvZiBhDQo+ID4gPiBidXR0b24sDQo+ID4gPiBtYW55IG1pc3NpbmcgcGllY2VzLg0KPiA+ID4g
DQo+ID4gPiAyKSBVcHN0cmVhbSBMZWdhY3kgU1JJT1YgaXMgaW5jb21wbGV0ZSBzaW5jZSBpdCBn
b2VzIHRvZ2V0aGVyDQo+ID4gPiB3aXRoDQo+ID4gPiBmbGV4aWJsZSB2ZiB2bGFuIGNvbmZpZ3Vy
YXRpb24sIG1vc3Qgb2YgbWx4NSBsZWdhY3kgc3Jpb3YgdXNlcnMNCj4gPiA+IGFyZQ0KPiA+ID4g
dXNpbmcgY3VzdG9taXplZCBrZXJuZWxzIGFuZCBleHRlcm5hbCBkcml2ZXJzLCBzaW5jZSB1cHN0
cmVhbSBpcw0KPiA+ID4gbGFja2luZyB0aGlzIG9uZSBiYXNpYyB2bGFuIGZpbHRlcmluZyBmZWF0
dXJlLCBhbmQgbWFueSB1c2Vycw0KPiA+ID4gZGVjbGluZQ0KPiA+ID4gc3dpdGNoaW5nIHRvIHVw
c3RyZWFtIGtlcm5lbCBkdWUgdG8gdGhpcyBtaXNzaW5nIGZlYXR1cmVzLg0KPiA+ID4gDQo+ID4g
PiAzKSBNYW55IG90aGVyIHZlbmRvcnMgaGF2ZSB0aGlzIGZlYXR1cmUgaW4gY3VzdG9taXplZA0K
PiA+ID4gZHJpdmVycy9rZXJuZWxzLA0KPiA+ID4gYW5kIG1hbnkgdmVuZG9ycy9kcml2ZXJzIGRv
bid0IGV2ZW4gc3VwcG9ydCBzd2l0Y2hkZXYgbW9kZSAobWx4NA0KPiA+ID4gZm9yDQo+ID4gPiBl
eGFtcGxlKSwgd2UgY2FuJ3QganVzdCB0ZWxsIHRoZSB1c2VycyBvZiBzdWNoIGRldmljZSB3ZSBh
cmUgbm90DQo+ID4gPiBzdXBwb3J0aW5nIGJhc2ljIHNyaW92IGxlZ2FjeSBtb2RlIGZlYXR1cmVz
IGluIHVwc3RyZWFtIGtlcm5lbC4NCj4gPiA+IA0KPiA+ID4gNCkgdGhlIG1vdGl2YXRpb24gZm9y
IHRoaXMgaXMgdG8gc2xvd2x5IG1vdmUgc3Jpb3YgdXNlcnMgdG8NCj4gPiA+IHVwc3RyZWFtDQo+
ID4gPiBhbmQgZXZlbnR1YWxseSB0byBzd2l0Y2hkZXYgbW9kZS4gIA0KPiA+IA0KPiA+IElmIHRo
ZSBsZWdhY3kgZnJlZXplIHN0YXJ0ZWQgaW4gMjAxNiBhbmQgd2UgYXJlIGF0IHRoZSBlbmQgb2Yg
MjAxOSwNCj4gPiB3aGF0DQo+ID4gaXMgdGhlIG1pZ3JhdGlvbiBwYXRoPw0KPiANCj4gVGhlIG1p
Z3JhdGlvbiBwYXRoIGlzIHRvIGltcGxlbWVudCBiYXNpYyBicmlkZ2Ugb2ZmbG9hZCB3aGljaCBj
YW4NCj4gdGFrZQ0KPiBjYXJlIG9mIHRoaXMgdHJpdmlhbGx5Lg0KPiANCg0KaXQgaXMgbm90IGFi
b3V0IGltcGxlbWVudGF0aW9uLCBpdCBpcyBhbHNvIHRoZSB1c2VyIGVjaG8gc3lzdGVtIHRoYXQN
Cm5lZWRzIHRvIGJlIG1pZ3JhdGVkLg0Kc28gdGhpcyBuZWVkcyB0byBoYXBwZW4gaW4gYmFieSBz
dGVwcywgeW91IGNhbid0IGp1c3QgYXNrIGFzayBzb21lb25lDQp0byBtb3ZlIHRvIHNvbWV0aGlu
ZyB0aGF0IGlzIG5vdCBldmVuIGNvb2tlZCB5ZXQsIGFuZCB3aWxsIHJlcXVpcmUNCm1vbnRocyBv
ciB5ZWFycyBvZiB2YWxpZGF0aW9uIGFuZCBkZXBsb3ltZW50Lg0KDQo+IFByb2JsZW0gaXMgcGVv
cGxlIGVxdWF0ZSBzd2l0Y2hkZXYgd2l0aCBPdlMgb2ZmbG9hZCB0b2RheSwgc28gYnJpZGdlDQo+
IG9mZmxvYWQgaXMgbm90IGFjdHVhbGx5IGltcGxlbWVudGVkLiBJdCdzIHJlYWxseSBoYXJkIHRv
IGNvbnZpbmNlDQo+IHByb2R1Y3QgbWFya2V0aW5nIHRoYXQgaXQncyB3b3JrIHdvcnRoIHRha2lu
ZyBvbi4NCj4gDQo+IEFkZGluZyBpbmNyZW1lbnRhbCBmZWF0dXJlcyB0byBsZWdhY3kgQVBJIGlz
IGFsd2F5cyBnb2luZyB0byBiZQ0KPiBjaGVhcGVyDQo+IHRoYW4gbWlncmF0aW5nIGNvbnRyb2xs
ZXJzIHRvIHN3aXRjaGRldi4NCj4gDQoNClllcyB0aGlzIGZlYXR1cmUgaXMgMTAwMCB0aW1lcyBj
aGVhcGVyIHRoYW4gaW1wbGVtZW50aW5nIHRoZSBmdWxsDQpvZmZsb2FkLCBhbmQgeWV0IHZlcnkg
dHJpdmlhbCBhbmQgbmVjZXNzYXJ5LCB0aGUgUk9JIGlzIHNvIGJpZyB0aGF0IGl0DQp3b3J0aCBk
b2luZyBpdCwgbW9yZSBleHBvc3VyZSB0byB1cHN0cmVhbS4NCg0KPiBJREsgaWYgeW91IHJlbWVt
YmVyIHRoZSBuZXRfZmFpbG92ZXIgYXJndW1lbnQgYWJvdXQgaW4ta2VybmVsIFZGIHRvDQo+IHZp
cnRpbyBib25kaW5nLiBUaGUgY29udHJvbGxlcnMgYXJlIGRvaW5nIHRoZSBiYXJlIG1pbmltdW0g
YW5kIGl0J3MgDQo+IGhhcmQgZm9yIEhXIHZlbmRvcnMgdG8ganVzdGlmeSB0aGUgZXhwZW5zZSBv
ZiBtb3ZpbmcgZm9yd2FyZCBhbGwNCj4gcGFydHMgDQo+IG9mIHRoZSBzdGFjay4NCj4gDQo+IFdo
aWNoIG1lYW5zIFNSLUlPViBpcyBlaXRoZXIgc3R1Y2sgaW4gcHVyZS1MMiBtaWRkbGUgYWdlcyBv
ciByZXF1aXJlcw0KPiBhbGwgdGhlIFNETiBjb21wbGV4aXR5IGFuZCBvdmVyaGVhZC4gU3dpdGNo
ZGV2IGJyaWRnZSBvZmZsb2FkIGNhbiBiZQ0KPiB0cml2aWFsbHkgZXh0ZW5kZWQgdG8gc3VwcG9y
dCBlVlBOIGFuZCBzaW1wbGlmeSBzbyBtYW55IGRlcGxveW1lbnRzLA0KPiBzaWdoLi4NCj4gDQo+
ID4gPiBOb3cgaWYgdGhlIG9ubHkgcmVtYWluaW5nIHByb2JsZW0gaXMgdGhlIHVBUEksIHdlIGNh
biBtaW5pbWl6ZQ0KPiA+ID4ga2VybmVsDQo+ID4gPiBpbXBhY3Qgb3IgZXZlbiBtYWtlIG5vIGtl
cm5lbCBjaGFuZ2VzIGF0IGFsbCwgb25seSBpcCByb3V0ZTIgYW5kDQo+ID4gPiBkcml2ZXJzLCBi
eSByZXVzaW5nIHRoZSBjdXJyZW50IHNldF92Zl92bGFuX25kby4gIA0KPiA+IA0KPiA+IEFuZCB0
aGlzIGNhdWdodCBteSBleWUgYXMgd2VsbCAtLSBpcHJvdXRlMiBkb2VzIG5vdCBuZWVkIHRoZQ0K
PiA+IGJhZ2dhZ2UgZWl0aGVyLg0KPiA+IA0KPiA+IElzIHRoZXJlIGFueSByZWFzb24gdGhpcyBj
b250aW51ZWQgc3VwcG9ydCBmb3IgbGVnYWN5IHNyaW92IGNhbiBub3QNCj4gPiBiZQ0KPiA+IGRv
bmUgb3V0IG9mIHRyZWU/DQo+IA0KPiBFeGFjdGx5LiBNb3ZpbmcgdG8gdXBzdHJlYW0gaXMgb25s
eSB2YWx1YWJsZSBpZiBpdCBkb2Vzbid0IHJlcXVpcmUNCj4gYnJpbmluZyBhbGwgdGhlIG91dC1v
Zi10cmVlIGJhZ2dhZ2UuDQoNCnRoaXMgYmFnZ2FnZSBpcyBhIHZlcnkgZXNzZW50aWFsIHBhcnQg
Zm9yIGV0aCBzcmlvdiwgaXQgaXMgYSBtaXNzaW5nDQpmZWF0dXJlIGluIGJvdGggc3dpdGNoZGV2
IG1vZGUgKGJyaWRnZSBvZmZsb2FkcykgYW5kIGxlZ2FjeS4NCg0KR3V5cywgSSBuZWVkIHRvIGtu
b3cgbXkgb3B0aW9ucyBoZXJlIGFuZCBtYWtlIHNvbWUgZWZmb3J0IGFzc2Vzc21lbnQuDQoNCjEp
IGltcGxlbWVudCBicmlkZ2Ugb2ZmbG9hZHM6IG1vbnRocyBvZiBkZXZlbG9wbWVudCwgeWVhcnMg
Zm9yDQpkZXBsb3ltZW50IGFuZCBtaWdyYXRpb24NCjIpIENsb3NlIHRoaXMgZ2FwIGluIGxlZ2Fj
eSBtb2RlOiBkYXlzLg0KDQpJIGFtIGFsbCBJTiBmb3IgYnJpZGdlIG9mZmxvYWRzLCBidXQgeW91
IGhhdmUgdG8gdW5kZXJzdGFuZCB3aHkgaSBwaWNrDQoyLCBub3QgYmVjYXVzZSBpdCBpcyBjaGVh
cGVyLCBidXQgYmVjYXVzZSBpdCBpcyBtb3JlIHJlYWxpc3RpYyBmb3IgbXkNCmN1cnJlbnQgdXNl
cnMuIFNheWluZyBubyB0byB0aGlzIGp1c3QgYmVjYXVzZSBzd2l0Y2hkZXYgbW9kZSBpcyB0aGUg
ZGUNCmZhY3RvIHN0YW5kYXJkIGlzbid0IGZhaXIgYW5kIHRoZXJlIHNob3VsZCBiZSBhbiBhY3Rp
dmUgY2xlYXINCnRyYW5zaXRpb24gcGxhbiwgd2l0aCBzb21ldGhpbmcgYXZhaWxhYmxlIHRvIHdv
cmsgd2l0aCAuLi4gbm90IGp1c3QNCmlkZWFzLg0KDQpZb3VyIGNsYWltcyBhcmUgdmFsaWQgb25s
eSB3aGVuIHdlIGFyZSB0cnVseSByZWFkeSBmb3IgbWlncmF0aW9uLiB3ZQ0KYXJlIHNpbXBseSBu
b3QgYW5kIG5vIG9uZSBoYXMgYSBjbGVhciBwbGFuIGluIHRoZSBob3Jpem9uLCBzbyBpIGRvbid0
DQpnZXQgdGhpcyB0b3RhbCBmcmVlemUgYXR0aXR1ZGUgb2YgbGVnYWN5IG1vZGUsIGl0IHNob3Vs
ZCBiZSBqdXN0IGxpa2UNCmV0aHRvb2wgd2Ugd2FudCB0byB0byByZXBsYWNlIGl0IGJ1dCB3ZSBr
bm93IHdlIGFyZSBub3QgdGhlcmUgeWV0LCBzbw0Kd2UgY2FyZWZ1bGx5IGFkZCBvbmx5IG5lY2Vz
c2FyeSB0aGluZ3Mgd2l0aCBsb3RzIG9mIGF1ZGl0aW5nLCBzYW1lDQpzaG91bGQgZ28gaGVyZS4N
Cg0KDQoNCg0KDQo=
