Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BB074F51
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfGYN0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:26:40 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:44502 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726801AbfGYN0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:26:40 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2302EC0B70;
        Thu, 25 Jul 2019 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1564061199; bh=2v8UMjZNBjQwo1ohwCpbtpmw+7KSGJkDmzosqySdh28=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=NSAqiJFd/9sxdAAoDPjAeIQRN1U3lPsppORj4BJ5G3c2kYpzcitXgYsXDVTqC3jeA
         0xisl6Alz8rm4njIq/CFMNOeGMeBS0SKzV4yHtfo+SwK5cCrCT4jUDQ4ZKGZm39NKF
         chGIwMoLl8PoaH04LN8foWaALiBG4M0a1ctB1vWlC4g0RSrMn6lDjbloa9jJ7V03tY
         B0cfv8I53cPEUCD191MPv/uFFgtj2ek3Zg/B4JxHzBpsh30jKIgW5mvX7J4OqZbfiB
         8gcqQ7oA1LeFBFvOmms/Vn0LB9Phvykno+4tnFRn9sWNDMtsgHKWyZ5dNEltSOXALy
         ic1PAafG4tnsg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4887FA0067;
        Thu, 25 Jul 2019 13:26:36 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 25 Jul 2019 06:26:26 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 25 Jul 2019 06:26:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zj3Dl+cZyZRcONkGdfOXaHNDTKEiSmPfJx135vADhoJFJPS/9nL6ZIFvGK2IMw13mYGUGirGPrpj82Y5ZxIkbHsT51Jm4aVs549y8f9S2LymWp7EBNScRp4wrlyzJ6No/47gCmayQ5df0q9LG6O8NUE+iFqAokQQnPXHAgYZbkWtIdfSIDvrKxIwDm1oejTi1cc609wL//4qdr5N1wo0vNeu7vkGfu78+FHIk65U/mon1G1My07PX8sMZSGcLP5IsbdQ6Hkt7PGdeI6O2kE62Nva/rO1EnV1gycH9smIN1TiJboNdAbxNRde05pk9cebiuF4363o9aMHfmugMNcGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2v8UMjZNBjQwo1ohwCpbtpmw+7KSGJkDmzosqySdh28=;
 b=Uub0uPk5nEc7CxEcNallPonZGVrzm91gI4AxnjFpRPi9KhrVxkPUKGLuJs/tknNwtWchtpRJnz26Jw3r0tlPyUFnLhDL/YsEnN7WZloJFzK+SU6fq+DDZnr25iRblAQ1GKfcznVIlRRsml2KO2dIhncgjlejEbnEUS/7vQYEovEeo/sOZUN/XehtdAtqzJOkebjrhZWy/R2y4JG0vwt2dqEDlhQRdUJk/lvkgodfaK3RS2WS72aFeeJPgwNk5NZKFXY3XJB5/P78/textIMQEY2jBYBY9KgkC7+5k9usJ1o7XQqtS1hvxmBTWIH8ymNxPgFSrk9enl+rGP9NMgKf1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2v8UMjZNBjQwo1ohwCpbtpmw+7KSGJkDmzosqySdh28=;
 b=Ps3KPk4YbBeG1A+l2lDsFVahTvSRrroCbH+ATLvGIcKZkDqK9udzREynxXzbrYcIPbog1Bx/+imXHcKKRD0TAixd0UaJ6IjbnMu98/EeNV6D0hAUoxAG9RXjJVnuyjZnyLqQLWqN/yL6ksxk/w81bNkhkZhBE2p3SjXO3lLwUZY=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB2936.namprd12.prod.outlook.com (20.179.91.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 13:26:24 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 13:26:24 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "wens@csie.org" <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abbdEOAgAAAgcA=
Date:   Thu, 25 Jul 2019 13:26:24 +0000
Message-ID: <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
In-Reply-To: <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00140198-2dd0-4fa1-6f60-08d71103b0ec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB2936;
x-ms-traffictypediagnostic: BYAPR12MB2936:
x-microsoft-antispam-prvs: <BYAPR12MB29361ACF4C972D711333859DD3C10@BYAPR12MB2936.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(376002)(396003)(39860400002)(52314003)(189003)(199004)(5660300002)(53546011)(2201001)(7696005)(33656002)(66066001)(7416002)(81166006)(9686003)(99286004)(26005)(81156014)(6246003)(55016002)(6436002)(110136005)(14454004)(478600001)(486006)(53936002)(3846002)(68736007)(102836004)(11346002)(8936002)(476003)(74316002)(6506007)(8676002)(6116002)(76176011)(14444005)(66556008)(66446008)(186003)(66946007)(64756008)(71200400001)(52536014)(86362001)(71190400001)(229853002)(446003)(25786009)(2906002)(7736002)(4326008)(54906003)(316002)(2501003)(76116006)(305945005)(66476007)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB2936;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lmLf0UpJIKZ4l6CfCSehIoCkwwu4hkNT0PwTGnuK5/xDXIJipDYt+7xHRquZsLVbNS3ZQ3Go1Uz+ZIEDrb5Do88MQozcQwXK8R9M5la5n9+XkJHPVuR+9Xlrx4Es+99Z6jF+zFqS9jR8kDPCHZNNgG0POz+Lib2W6o3Pc6qehcW8fQOKiXCGouaZ4alRdlLxGuJmGzjZjai9vpzlwDLVk988h/fHT8p9sRazTr5Ez0cJZWY6BDtDXuqxWtwZ0rwmGiDeltW1ky4O7ZxIJMrjOqGhUDC7hehai6v1SjbfurFVeI4bowFuO9uzknNSYIEjQ6y7X5bQVltujaGySxUlF86wUA80HT3+pjnIYIqrsfM6luaIRCQIJl9iMw06+wCRCRHcMX5tA94e1WUn0fdcO2v218QnN5uoe2seiiQWAQs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00140198-2dd0-4fa1-6f60-08d71103b0ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 13:26:24.4974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2936
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uIEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQpEYXRlOiBKdWwvMjUvMjAx
OSwgMTQ6MjA6MDcgKFVUQyswMDowMCkNCg0KPiANCj4gT24gMDMvMDcvMjAxOSAxMTozNywgSm9z
ZSBBYnJldSB3cm90ZToNCj4gPiBNYXBwaW5nIGFuZCB1bm1hcHBpbmcgRE1BIHJlZ2lvbiBpcyBh
biBoaWdoIGJvdHRsZW5lY2sgaW4gc3RtbWFjIGRyaXZlciwNCj4gPiBzcGVjaWFsbHkgaW4gdGhl
IFJYIHBhdGguDQo+ID4gDQo+ID4gVGhpcyBjb21taXQgaW50cm9kdWNlcyBzdXBwb3J0IGZvciBQ
YWdlIFBvb2wgQVBJIGFuZCB1c2VzIGl0IGluIGFsbCBSWA0KPiA+IHF1ZXVlcy4gV2l0aCB0aGlz
IGNoYW5nZSwgd2UgZ2V0IG1vcmUgc3RhYmxlIHRyb3VnaHB1dCBhbmQgc29tZSBpbmNyZWFzZQ0K
PiA+IG9mIGJhbndpZHRoIHdpdGggaXBlcmY6DQo+ID4gCS0gTUFDMTAwMCAtIDk1MCBNYnBzDQo+
ID4gCS0gWEdNQUM6IDkuMjIgR2Jwcw0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvc2UgQWJy
ZXUgPGpvYWJyZXVAc3lub3BzeXMuY29tPg0KPiA+IENjOiBKb2FvIFBpbnRvIDxqcGludG9Ac3lu
b3BzeXMuY29tPg0KPiA+IENjOiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
DQo+ID4gQ2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT4NCj4g
PiBDYzogQWxleGFuZHJlIFRvcmd1ZSA8YWxleGFuZHJlLnRvcmd1ZUBzdC5jb20+DQo+ID4gQ2M6
IE1heGltZSBDb3F1ZWxpbiA8bWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbT4NCj4gPiBDYzogTWF4
aW1lIFJpcGFyZCA8bWF4aW1lLnJpcGFyZEBib290bGluLmNvbT4NCj4gPiBDYzogQ2hlbi1ZdSBU
c2FpIDx3ZW5zQGNzaWUub3JnPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9z
dG1pY3JvL3N0bW1hYy9LY29uZmlnICAgICAgIHwgICAxICsNCj4gPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjLmggICAgICB8ICAxMCArLQ0KPiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jIHwgMTk2ICsrKysrKy0t
LS0tLS0tLS0tLS0tLS0NCj4gPiAgMyBmaWxlcyBjaGFuZ2VkLCA2MyBpbnNlcnRpb25zKCspLCAx
NDQgZGVsZXRpb25zKC0pDQo+IA0KPiAuLi4NCj4gDQo+ID4gQEAgLTMzMDYsNDkgKzMyOTUsMjIg
QEAgc3RhdGljIGlubGluZSB2b2lkIHN0bW1hY19yeF9yZWZpbGwoc3RydWN0IHN0bW1hY19wcml2
ICpwcml2LCB1MzIgcXVldWUpDQo+ID4gIAkJZWxzZQ0KPiA+ICAJCQlwID0gcnhfcS0+ZG1hX3J4
ICsgZW50cnk7DQo+ID4gIA0KPiA+IC0JCWlmIChsaWtlbHkoIXJ4X3EtPnJ4X3NrYnVmZltlbnRy
eV0pKSB7DQo+ID4gLQkJCXN0cnVjdCBza19idWZmICpza2I7DQo+ID4gLQ0KPiA+IC0JCQlza2Ig
PSBuZXRkZXZfYWxsb2Nfc2tiX2lwX2FsaWduKHByaXYtPmRldiwgYmZzaXplKTsNCj4gPiAtCQkJ
aWYgKHVubGlrZWx5KCFza2IpKSB7DQo+ID4gLQkJCQkvKiBzbyBmb3IgYSB3aGlsZSBubyB6ZXJv
LWNvcHkhICovDQo+ID4gLQkJCQlyeF9xLT5yeF96ZXJvY190aHJlc2ggPSBTVE1NQUNfUlhfVEhS
RVNIOw0KPiA+IC0JCQkJaWYgKHVubGlrZWx5KG5ldF9yYXRlbGltaXQoKSkpDQo+ID4gLQkJCQkJ
ZGV2X2Vycihwcml2LT5kZXZpY2UsDQo+ID4gLQkJCQkJCSJmYWlsIHRvIGFsbG9jIHNrYiBlbnRy
eSAlZFxuIiwNCj4gPiAtCQkJCQkJZW50cnkpOw0KPiA+IC0JCQkJYnJlYWs7DQo+ID4gLQkJCX0N
Cj4gPiAtDQo+ID4gLQkJCXJ4X3EtPnJ4X3NrYnVmZltlbnRyeV0gPSBza2I7DQo+ID4gLQkJCXJ4
X3EtPnJ4X3NrYnVmZl9kbWFbZW50cnldID0NCj4gPiAtCQkJICAgIGRtYV9tYXBfc2luZ2xlKHBy
aXYtPmRldmljZSwgc2tiLT5kYXRhLCBiZnNpemUsDQo+ID4gLQkJCQkJICAgRE1BX0ZST01fREVW
SUNFKTsNCj4gPiAtCQkJaWYgKGRtYV9tYXBwaW5nX2Vycm9yKHByaXYtPmRldmljZSwNCj4gPiAt
CQkJCQkgICAgICByeF9xLT5yeF9za2J1ZmZfZG1hW2VudHJ5XSkpIHsNCj4gPiAtCQkJCW5ldGRl
dl9lcnIocHJpdi0+ZGV2LCAiUnggRE1BIG1hcCBmYWlsZWRcbiIpOw0KPiA+IC0JCQkJZGV2X2tm
cmVlX3NrYihza2IpOw0KPiA+ICsJCWlmICghYnVmLT5wYWdlKSB7DQo+ID4gKwkJCWJ1Zi0+cGFn
ZSA9IHBhZ2VfcG9vbF9kZXZfYWxsb2NfcGFnZXMocnhfcS0+cGFnZV9wb29sKTsNCj4gPiArCQkJ
aWYgKCFidWYtPnBhZ2UpDQo+ID4gIAkJCQlicmVhazsNCj4gPiAtCQkJfQ0KPiA+IC0NCj4gPiAt
CQkJc3RtbWFjX3NldF9kZXNjX2FkZHIocHJpdiwgcCwgcnhfcS0+cnhfc2tidWZmX2RtYVtlbnRy
eV0pOw0KPiA+IC0JCQlzdG1tYWNfcmVmaWxsX2Rlc2MzKHByaXYsIHJ4X3EsIHApOw0KPiA+IC0N
Cj4gPiAtCQkJaWYgKHJ4X3EtPnJ4X3plcm9jX3RocmVzaCA+IDApDQo+ID4gLQkJCQlyeF9xLT5y
eF96ZXJvY190aHJlc2gtLTsNCj4gPiAtDQo+ID4gLQkJCW5ldGlmX2RiZyhwcml2LCByeF9zdGF0
dXMsIHByaXYtPmRldiwNCj4gPiAtCQkJCSAgInJlZmlsbCBlbnRyeSAjJWRcbiIsIGVudHJ5KTsN
Cj4gPiAgCQl9DQo+ID4gLQkJZG1hX3dtYigpOw0KPiA+ICsNCj4gPiArCQlidWYtPmFkZHIgPSBi
dWYtPnBhZ2UtPmRtYV9hZGRyOw0KPiA+ICsJCXN0bW1hY19zZXRfZGVzY19hZGRyKHByaXYsIHAs
IGJ1Zi0+YWRkcik7DQo+ID4gKwkJc3RtbWFjX3JlZmlsbF9kZXNjMyhwcml2LCByeF9xLCBwKTsN
Cj4gPiAgDQo+ID4gIAkJcnhfcS0+cnhfY291bnRfZnJhbWVzKys7DQo+ID4gIAkJcnhfcS0+cnhf
Y291bnRfZnJhbWVzICU9IHByaXYtPnJ4X2NvYWxfZnJhbWVzOw0KPiA+ICAJCXVzZV9yeF93ZCA9
IHByaXYtPnVzZV9yaXd0ICYmIHJ4X3EtPnJ4X2NvdW50X2ZyYW1lczsNCj4gPiAgDQo+ID4gLQkJ
c3RtbWFjX3NldF9yeF9vd25lcihwcml2LCBwLCB1c2Vfcnhfd2QpOw0KPiA+IC0NCj4gPiAgCQlk
bWFfd21iKCk7DQo+ID4gKwkJc3RtbWFjX3NldF9yeF9vd25lcihwcml2LCBwLCB1c2Vfcnhfd2Qp
Ow0KPiA+ICANCj4gPiAgCQllbnRyeSA9IFNUTU1BQ19HRVRfRU5UUlkoZW50cnksIERNQV9SWF9T
SVpFKTsNCj4gPiAgCX0NCj4gDQo+IEkgd2FzIGxvb2tpbmcgYXQgdGhpcyBjaGFuZ2UgaW4gYSBi
aXQgY2xvc2VyIGRldGFpbCBhbmQgb25lIHRoaW5nIHRoYXQNCj4gc3R1Y2sgb3V0IHRvIG1lIHdh
cyB0aGUgYWJvdmUgd2hlcmUgdGhlIGJhcnJpZXIgaGFkIGJlZW4gbW92ZWQgZnJvbQ0KPiBhZnRl
ciB0aGUgc3RtbWFjX3NldF9yeF9vd25lcigpIGNhbGwgdG8gYmVmb3JlLiANCj4gDQo+IFNvIEkg
bW92ZWQgdGhpcyBiYWNrIGFuZCBJIG5vIGxvbmdlciBzYXcgdGhlIGNyYXNoLiBIb3dldmVyLCB0
aGVuIEkNCj4gcmVjYWxsZWQgSSBoYWQgdGhlIHBhdGNoIHRvIGVuYWJsZSB0aGUgZGVidWcgcHJp
bnRzIGZvciB0aGUgYnVmZmVyDQo+IGFkZHJlc3MgYXBwbGllZCBidXQgYWZ0ZXIgcmV2ZXJ0aW5n
IHRoYXQsIHRoZSBjcmFzaCBvY2N1cnJlZCBhZ2Fpbi4gDQo+IA0KPiBJbiBvdGhlciB3b3Jkcywg
d2hhdCB3b3JrcyBmb3IgbWUgaXMgbW92aW5nIHRoZSBhYm92ZSBiYXJyaWVyIGFuZCBhZGRpbmcN
Cj4gdGhlIGRlYnVnIHByaW50LCB3aGljaCBhcHBlYXJzIHRvIHN1Z2dlc3QgdGhhdCB0aGVyZSBp
cyBzb21lDQo+IHRpbWluZy9jb2hlcmVuY3kgaXNzdWUgaGVyZS4gQW55d2F5LCBtYXliZSB0aGlz
IGlzIGNsdWUgdG8gd2hhdCBpcyBnb2luZw0KPiBvbj8NCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiBpbmRleCBhNzQ4NmMy
ZjMyMjEuLjJmMDE2Mzk3MjMxYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
c3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+IEBAIC0zMzAzLDggKzMzMDMsOCBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgc3RtbWFjX3J4X3JlZmlsbChzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnBy
aXYsIHUzMiBxdWV1ZSkNCj4gICAgICAgICAgICAgICAgIHJ4X3EtPnJ4X2NvdW50X2ZyYW1lcyAl
PSBwcml2LT5yeF9jb2FsX2ZyYW1lczsNCj4gICAgICAgICAgICAgICAgIHVzZV9yeF93ZCA9IHBy
aXYtPnVzZV9yaXd0ICYmIHJ4X3EtPnJ4X2NvdW50X2ZyYW1lczsNCj4gIA0KPiAtICAgICAgICAg
ICAgICAgZG1hX3dtYigpOw0KPiAgICAgICAgICAgICAgICAgc3RtbWFjX3NldF9yeF9vd25lcihw
cml2LCBwLCB1c2Vfcnhfd2QpOw0KPiArICAgICAgICAgICAgICAgZG1hX3dtYigpOw0KPiAgDQo+
ICAgICAgICAgICAgICAgICBlbnRyeSA9IFNUTU1BQ19HRVRfRU5UUlkoZW50cnksIERNQV9SWF9T
SVpFKTsNCj4gICAgICAgICB9DQo+IEBAIC0zNDM4LDYgKzM0MzgsMTAgQEAgc3RhdGljIGludCBz
dG1tYWNfcngoc3RydWN0IHN0bW1hY19wcml2ICpwcml2LCBpbnQgbGltaXQsIHUzMiBxdWV1ZSkN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZpY2UocHJp
di0+ZGV2aWNlLCBidWYtPmFkZHIsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGZyYW1lX2xlbiwgRE1BX0ZST01fREVWSUNFKTsNCj4gIA0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICBwcl9pbmZvKCIlczogcGFkZHI9MHglbGx4LCB2YWRkcj0w
eCVsbHgsIGxlbj0lZCIsIF9fZnVuY19fLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgYnVmLT5hZGRyLCBwYWdlX2FkZHJlc3MoYnVmLT5wYWdlKSwNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZyYW1lX2xlbik7DQo+ICsNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKG5ldGlmX21zZ19wa3RkYXRhKHByaXYpKSB7DQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbmV0ZGV2X2RiZyhwcml2LT5kZXYsICJmcmFt
ZSByZWNlaXZlZCAoJWRieXRlcykiLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgZnJhbWVfbGVuKTsNCj4gDQo+IENoZWVycw0KPiBKb24NCj4gDQo+IC0tIA0K
PiBudnB1YmxpYw0KDQpXZWxsLCBJIHdhc24ndCBleHBlY3RpbmcgdGhhdCA6Lw0KDQpQZXIgZG9j
dW1lbnRhdGlvbiBvZiBiYXJyaWVycyBJIHRoaW5rIHdlIHNob3VsZCBzZXQgZGVzY3JpcHRvciBm
aWVsZHMgDQphbmQgdGhlbiBiYXJyaWVyIGFuZCBmaW5hbGx5IG93bmVyc2hpcCB0byBIVyBzbyB0
aGF0IHJlbWFpbmluZyBmaWVsZHMgDQphcmUgY29oZXJlbnQgYmVmb3JlIG93bmVyIGlzIHNldC4N
Cg0KQW55d2F5LCBjYW4geW91IGFsc28gYWRkIGEgZG1hX3JtYigpIGFmdGVyIHRoZSBjYWxsIHRv
IA0Kc3RtbWFjX3J4X3N0YXR1cygpID8NCg0KLS0tDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJl
dQ0K
