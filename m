Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE3A65295
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfGKHlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:41:13 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:36356
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfGKHlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 03:41:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKTN5QqK6Ptu652+dkTwULHPyRwAGHLTh+fWJ73xXbtJdMN/3hzUqGzyizNWSHXl0nA9gEMw3sRmgqfc2ADiW6dw017CUmYAlm3wSLqApLuGt1oX6TPnmQAN7yvvK6qDxysTSdw3TY1Xz4FCK87UiT1dYPgTqd3Bd0Y2y16mdOhpuH/3QzaUiC2vYG8GBq33791hlao38lrZrzbQ97ZomwXdvTScMwbJBslH/WZMUQHYGfhwL9zJJdtLEFxgOAEutVjl6hBHvlpQGEWhd3wv90tHrYt++cSixMDWDJvfWCYUVDUdGuDE8cZWxmy63/EW+BORuDMOgUVl1fQLDVMo8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Es41s8R+SjyAhecJ/GNuar2jf3F3c3Pr1wW7UVQQMBI=;
 b=KEZilOfRXVE32xpAkpFd1soEnqoEtxgXaOIyKBSHI28kLI1oshpz31LocnLg4Sqg0O43w/BNtSJlGrrzazFnis5MG5/ZrhXJYkkJ/aB2gpOpUV/dMPpaio1WmhesPgqW+KIuHfHFK83WSG5ReJSeV/MqkcEvvsifkdQSU74Nym0czex8jMU3zBZq5CaOF/9eSbgRIyIFyOrw2xB/XdOxwl4I4wyxrKkoRDpMVjNUba0JI0zp0PwCfehgKmXCrQ9nDjVUv+f5tEnwogPeWyGmDKVpFLH53WB+iD8bC9OfQmUMCoywkAgMadFk/nN6AvbqQGPyn3gdfCWNfwp4PqKqKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=ericsson.com;dmarc=pass action=none
 header.from=ericsson.com;dkim=pass header.d=ericsson.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Es41s8R+SjyAhecJ/GNuar2jf3F3c3Pr1wW7UVQQMBI=;
 b=GHucMIislVhfatbiMjEsavplma2zfSFVvISgLzhBGnA0qEkjCwxvvpgCtXetuJ6rW42GnyJL/LAQBceKmngCVYZ+HCAFmrhIc35CcIr3qWNRTLA1p2QDQRgjHQ1BW9fQY/bomjQRYlAml81auQepPrGTztyCUvr9+tjnGF88cA8=
Received: from AM6PR07MB5639.eurprd07.prod.outlook.com (20.178.91.76) by
 AM6PR07MB4851.eurprd07.prod.outlook.com (20.177.117.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.6; Thu, 11 Jul 2019 07:41:09 +0000
Received: from AM6PR07MB5639.eurprd07.prod.outlook.com
 ([fe80::a530:36cf:3e2a:a12f]) by AM6PR07MB5639.eurprd07.prod.outlook.com
 ([fe80::a530:36cf:3e2a:a12f%6]) with mapi id 15.20.2073.008; Thu, 11 Jul 2019
 07:41:09 +0000
From:   Jan Szewczyk <jan.szewczyk@ericsson.com>
To:     David Ahern <dsahern@gmail.com>,
        Stefano Brivio <sbrivio@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: Question about linux kernel commit: "net/ipv6: move metrics from
 dst to rt6_info"
Thread-Topic: Question about linux kernel commit: "net/ipv6: move metrics from
 dst to rt6_info"
Thread-Index: AdU2+HKrTE257Ye/RNyCdrk4RqkOOgAImVWAAADYahAADTUtAAAAHCmAABoWOfA=
Date:   Thu, 11 Jul 2019 07:41:08 +0000
Message-ID: <AM6PR07MB563909C11D02C26F0D6665B6F2F30@AM6PR07MB5639.eurprd07.prod.outlook.com>
References: <AM6PR07MB56397A8BC53D9A525BC9C489F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
 <cb0674df-8593-f14b-f680-ce278042c88c@gmail.com>
 <AM6PR07MB5639E2AEF438DD017246DF13F2F00@AM6PR07MB5639.eurprd07.prod.outlook.com>
 <20190710210954.530d72a5@elisabeth>
 <5981b8d0-cfdf-d230-fa22-cfcfaa5ee4b9@gmail.com>
In-Reply-To: <5981b8d0-cfdf-d230-fa22-cfcfaa5ee4b9@gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jan.szewczyk@ericsson.com; 
x-originating-ip: [193.105.24.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 018f8086-efa5-4f94-3270-08d705d323b9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR07MB4851;
x-ms-traffictypediagnostic: AM6PR07MB4851:
x-microsoft-antispam-prvs: <AM6PR07MB4851C8A4D004A1886E257A2AF2F30@AM6PR07MB4851.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(189003)(199004)(13464003)(6506007)(53936002)(229853002)(53546011)(102836004)(33656002)(2906002)(68736007)(7696005)(76176011)(71200400001)(71190400001)(478600001)(4326008)(476003)(55016002)(9686003)(66066001)(26005)(186003)(316002)(446003)(11346002)(14454004)(14444005)(7736002)(52536014)(74316002)(256004)(54906003)(110136005)(3846002)(6116002)(8936002)(81166006)(81156014)(76116006)(66476007)(486006)(66556008)(44832011)(66446008)(64756008)(99286004)(25786009)(66946007)(6246003)(305945005)(8676002)(86362001)(5660300002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR07MB4851;H:AM6PR07MB5639.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6tmzHmKIraWDX9tlAX1+amhQqsSXkT2pSlPRRupAMRHwYgpCEi69+b7epgmJOgGAK11r8k7D+bbQSrwD/WfU5w8J0xjDowEklsfJMYjaoPOoc2JVEMKmuZaCDWrksHT8zB0mBtr/ITTut8bJbR9BHOwz9KLHi4gOazD3GdPnNvgS1lcZOIHP0JZbgqeqO5uKmVSo3dkP7RGs6vg8YrvnR015Pd2+Xj+XVgAnzn3lXLAaGbOEbuqRtjMCuH94OwjcrEdkJ1QMlbKlacAU2jf5Bk39Jq2uFC8kzHQPLgpVwde/GG6Qhz8pfaBYRpkinObXTeCUBKQItQRpfQ/wcwerndX6nKi77Enh3niAAyFEgm898+C53D4v+kQwogfu98H4WW7PxwKJPfPccVkG1jFHwxY9I8tU/9+krH4sHw1BWTU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 018f8086-efa5-4f94-3270-08d705d323b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 07:41:09.0273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jan.szewczyk@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR07MB4851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgZ3V5cyENCg0KWWVzLCB0aGF0J3MgZXhhY3RseSBpdCEgVGhhbmsgeW91IHZlcnkgbXVjaCwg
c28gbm93IEkga25vdyB3aGF0IGlzIGhhcHBlbmluZyDwn5iKLg0KDQpUaGFua3MgYWdhaW4gZm9y
IHlvdXIgaGVscCENCg0KQlIsDQpKYW4gU3pld2N6eWsNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCkZyb206IERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4gDQpTZW50OiBXZWRu
ZXNkYXksIEp1bHkgMTAsIDIwMTkgMjE6MTMNClRvOiBTdGVmYW5vIEJyaXZpbyA8c2JyaXZpb0By
ZWRoYXQuY29tPjsgSmFuIFN6ZXdjenlrIDxqYW4uc3pld2N6eWtAZXJpY3Nzb24uY29tPg0KQ2M6
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFdlaSBXYW5nIDx3
ZWl3YW5AZ29vZ2xlLmNvbT47IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT47IEVyaWMg
RHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NClN1YmplY3Q6IFJlOiBRdWVzdGlvbiBhYm91
dCBsaW51eCBrZXJuZWwgY29tbWl0OiAibmV0L2lwdjY6IG1vdmUgbWV0cmljcyBmcm9tIGRzdCB0
byBydDZfaW5mbyINCg0KT24gNy8xMC8xOSAxOjA5IFBNLCBTdGVmYW5vIEJyaXZpbyB3cm90ZToN
Cj4gSmFuLA0KPiANCj4gT24gV2VkLCAxMCBKdWwgMjAxOSAxMjo1OTo0MSArMDAwMA0KPiBKYW4g
U3pld2N6eWsgPGphbi5zemV3Y3p5a0Blcmljc3Nvbi5jb20+IHdyb3RlOg0KPiANCj4+IEhpIQ0K
Pj4gSSBkaWdnZWQgdXAgYSBsaXR0bGUgZnVydGhlciBhbmQgbWF5YmUgaXQncyBub3QgYSBwcm9i
bGVtIHdpdGggTVRVIA0KPj4gaXRzZWxmLiBJIGNoZWNrZWQgZXZlcnkgZW50cnkgSSBnZXQgZnJv
bSBSVE1fR0VUUk9VVEUgbmV0bGluayBtZXNzYWdlIA0KPj4gYW5kIGFmdGVyIHRyaWdnZXJpbmcg
InRvbyBiaWcgcGFja2V0IiBieSBwaW5naW5nIGlwdjZhZGRyZXNzIEkgZ2V0IA0KPj4gZXhhY3Rs
eSB0aGUgc2FtZSBtZXNzYWdlcyBvbiA0LjEyIGFuZCA0LjE4LCBleGNlcHQgdGhhdCB0aGUgb25l
IHdpdGggDQo+PiB0aGF0IHBpbmdlZCBpcHY2YWRkcmVzcyBpcyBtaXNzaW5nIG9uIDQuMTggYXQg
YWxsLiBXaGF0IGlzIHdlaXJkIC0gDQo+PiBpdCdzIHZpc2libGUgd2hlbiBydW5uaW5nICJpcCBy
b3V0ZSBnZXQgdG8gaXB2NmFkZHJlc3MiLiBEbyB5b3Uga25vdyANCj4+IHdoeSB0aGVyZSBpcyBh
IG1pc21hdGNoIHRoZXJlPw0KPiANCj4gSWYgSSB1bmRlcnN0YW5kIHlvdSBjb3JyZWN0bHksIGFu
IGltcGxlbWVudGF0aW9uIGVxdWl2YWxlbnQgdG8gJ2lwIC02IA0KPiByb3V0ZSBsaXN0IHNob3cn
ICh1c2luZyB0aGUgTkxNX0ZfRFVNUCBmbGFnKSB3b24ndCBzaG93IHRoZSBzby1jYWxsZWQgDQo+
IHJvdXRlIGV4Y2VwdGlvbiwgd2hpbGUgJ2lwIC02IHJvdXRlIGdldCcgc2hvd3MgaXQuDQo+IA0K
PiBJZiB0aGF0J3MgdGhlIGNhc2U6IHRoYXQgd2FzIGJyb2tlbiBieSBjb21taXQgMmI3NjBmY2Y1
Y2ZiICgiaXB2NjogDQo+IGhvb2sgdXAgZXhjZXB0aW9uIHRhYmxlIHRvIHN0b3JlIGRzdCBjYWNo
ZSIpIHRoYXQgbGFuZGVkIGluIDQuMTUsIGFuZCANCj4gZml4ZWQgYnkgbmV0LW5leHQgY29tbWl0
IDFlNDdiNDgzN2YzYiAoImlwdjY6IER1bXAgcm91dGUgZXhjZXB0aW9ucyBpZiANCj4gcmVxdWVz
dGVkIikuIEZvciBtb3JlIGRldGFpbHMsIHNlZSB0aGUgbG9nIG9mIHRoaXMgY29tbWl0IGl0c2Vs
Zi4NCj4gDQoNCmFoLCBnb29kIHBvaW50LiBNeSBtaW5kIGxvY2tlZCBvbiBSVE1fR0VUUk9VVEUg
YXMgYSBzcGVjaWZpYyByb3V0ZSByZXF1ZXN0IG5vdCBhIGR1bXAuDQo=
