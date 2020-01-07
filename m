Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FDC13279B
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgAGNac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:30:32 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:24056 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727559AbgAGNac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:30:32 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007DRfU8012025;
        Tue, 7 Jan 2020 14:30:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=sh/Hcpph+fyyvxbpOaXrOQFv55vXYoYyE8APS/2sZ98=;
 b=GVil49yGoH38YfsdtnaXdGUVOgL/KG1fV1KDTXLOpJSUA8rdAGkMyTTffl7Gn90qeJ/p
 1Tk+FcstZedynXbKxcaTXhWNVjlTFVdP0DH1FZesoi1xoNzWiGHOc3cq7J+fkhp9s6Gc
 gLqYbKUBiUrDrMxlcEPfcrzgBnFvEjFVTHTLilz8YCftht+6bcykuE/w5zuvrUrdUAUv
 /pT6DELsyvnIASwb67EC0Dbxdxx8iDZFL4jGnNs+pk2+zLPFil9O2nAygXucU+t/ETAn
 /ywFQO/mIshDn97BO/e/FNhhGqB933jpUTgn5mWZFV1q9/MRfsANSfMiKC8lYMHdogZg 9Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2xakkaphbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 14:30:15 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 221B510002A;
        Tue,  7 Jan 2020 14:30:14 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag4node1.st.com [10.75.127.10])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C66C92B7721;
        Tue,  7 Jan 2020 14:30:14 +0100 (CET)
Received: from SFHDAG6NODE3.st.com (10.75.127.18) by SFHDAG4NODE1.st.com
 (10.75.127.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Jan
 2020 14:30:14 +0100
Received: from SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6]) by
 SFHDAG6NODE3.st.com ([fe80::d04:5337:ab17:b6f6%20]) with mapi id
 15.00.1473.003; Tue, 7 Jan 2020 14:30:14 +0100
From:   Patrice CHOTARD <patrice.chotard@st.com>
To:     Sriram Dash <sriram.dash@samsung.com>,
        'Jose Abreu' <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     'Joao Pinto' <Joao.Pinto@synopsys.com>,
        "'kernelci . org bot'" <bot@kernelci.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Florian Fainelli' <f.fainelli@gmail.com>,
        'Maxime Coquelin' <mcoquelin.stm32@gmail.com>,
        Peppe CAVALLARO <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        'Heiko Stuebner' <heiko@sntech.de>
Subject: Re: [Linux-stm32] [PATCH net] net: stmmac: Fixed link does not need
 MDIO Bus
Thread-Topic: [Linux-stm32] [PATCH net] net: stmmac: Fixed link does not need
 MDIO Bus
Thread-Index: AQHVxV6XXqj37Urfek+F1jboTMK33g==
Date:   Tue, 7 Jan 2020 13:30:14 +0000
Message-ID: <4330eb5a-1dfa-783c-69c9-35692db65341@st.com>
References: <CGME20200107123550epcas5p2d1914646e71e0ff0095b4a14eb5e1551@epcas5p2.samsung.com>
 <5764e60da6d3af7e76c30f63b07f1a12b4787918.1578400471.git.Jose.Abreu@synopsys.com>
 <014201d5c559$3e6204b0$bb260e10$@samsung.com>
In-Reply-To: <014201d5c559$3e6204b0$bb260e10$@samsung.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1785DA2E48A9B045A6DD91BAA51E0F40@st.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-07_03:2020-01-06,2020-01-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsDQoNCk9uIDEvNy8yMCAxOjUxIFBNLCBTcmlyYW0gRGFzaCB3cm90ZToNCj4+IEZyb206
IEpvc2UgQWJyZXUgPEpvc2UuQWJyZXVAc3lub3BzeXMuY29tPg0KPj4gU3ViamVjdDogW1BBVENI
IG5ldF0gbmV0OiBzdG1tYWM6IEZpeGVkIGxpbmsgZG9lcyBub3QgbmVlZCBNRElPIEJ1cw0KPj4N
Cj4+IFdoZW4gdXNpbmcgZml4ZWQgbGluayB3ZSBkb24ndCBuZWVkIHRoZSBNRElPIGJ1cyBzdXBw
b3J0Lg0KPj4NCj4+IFJlcG9ydGVkLWJ5OiBIZWlrbyBTdHVlYm5lciA8aGVpa29Ac250ZWNoLmRl
Pg0KPj4gUmVwb3J0ZWQtYnk6IGtlcm5lbGNpLm9yZyBib3QgPGJvdEBrZXJuZWxjaS5vcmc+DQo+
PiBGaXhlczogZDNlMDE0ZWM3ZDVlICgibmV0OiBzdG1tYWM6IHBsYXRmb3JtOiBGaXggTURJTyBp
bml0IGZvciBwbGF0Zm9ybXMNCj4+IHdpdGhvdXQgUEhZIikNCj4+IFNpZ25lZC1vZmYtYnk6IEpv
c2UgQWJyZXUgPEpvc2UuQWJyZXVAc3lub3BzeXMuY29tPg0KPiBBY2tlZC1ieTogU3JpcmFtIERh
c2ggPFNyaXJhbS5kYXNoQHNhbXN1bmcuY29tPg0KDQpUZXN0ZWQgb24gU1RpSDQxMC1CMjI2MCBi
b2FyZA0KDQpUZXN0ZWQtYnk6IFBhdHJpY2UgQ2hvdGFyZCA8cGF0cmljZS5jaG90YXJkQHN0LmNv
bT4NCg0KVGhhbmtzDQoNCj4+IC0tLQ0KPj4gQ2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUu
Y2F2YWxsYXJvQHN0LmNvbT4NCj4+IENjOiBBbGV4YW5kcmUgVG9yZ3VlIDxhbGV4YW5kcmUudG9y
Z3VlQHN0LmNvbT4NCj4+IENjOiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT4NCj4+
IENjOiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4+IENjOiBNYXhp
bWUgQ29xdWVsaW4gPG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb20+DQo+PiBDYzogbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZw0KPj4gQ2M6IGxpbnV4LXN0bTMyQHN0LW1kLW1haWxtYW4uc3Rvcm1yZXBs
eS5jb20NCj4+IENjOiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4+IENj
OiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+PiBDYzogSGVpa28gU3R1ZWJuZXIgPGhl
aWtvQHNudGVjaC5kZT4NCj4+IENjOiBrZXJuZWxjaS5vcmcgYm90IDxib3RAa2VybmVsY2kub3Jn
Pg0KPj4gQ2M6IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPj4gQ2M6
IFNyaXJhbSBEYXNoIDxzcmlyYW0uZGFzaEBzYW1zdW5nLmNvbT4NCj4+IC0tLQ0KPj4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19wbGF0Zm9ybS5jIHwgMiArLQ0K
Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNf
cGxhdGZvcm0uYw0KPj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1t
YWNfcGxhdGZvcm0uYw0KPj4gaW5kZXggY2M4ZDdlN2JmOWFjLi40Nzc1ZjQ5ZDdmM2IgMTAwNjQ0
DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfcGxh
dGZvcm0uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjX3BsYXRmb3JtLmMNCj4+IEBAIC0zMjAsNyArMzIwLDcgQEAgc3RhdGljIGludCBzdG1tYWNf
bXRsX3NldHVwKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4+ICpwZGV2LCAgc3RhdGljIGludCBz
dG1tYWNfZHRfcGh5KHN0cnVjdCBwbGF0X3N0bW1hY2VuZXRfZGF0YSAqcGxhdCwNCj4+ICAJCQkg
c3RydWN0IGRldmljZV9ub2RlICpucCwgc3RydWN0IGRldmljZSAqZGV2KSAgew0KPj4gLQlib29s
IG1kaW8gPSBmYWxzZTsNCj4+ICsJYm9vbCBtZGlvID0gIW9mX3BoeV9pc19maXhlZF9saW5rKG5w
KTsNCj4+ICAJc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgbmVlZF9tZGlvX2lkc1td
ID0gew0KPj4gIAkJeyAuY29tcGF0aWJsZSA9ICJzbnBzLGR3Yy1xb3MtZXRoZXJuZXQtNC4xMCIg
fSwNCj4+ICAJCXt9LA0KPj4gLS0NCj4+IDIuNy40DQo+DQo+IF9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IExpbnV4LXN0bTMyIG1haWxpbmcgbGlzdA0K
PiBMaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHkuY29tDQo+IGh0dHBzOi8vc3Qt
bWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LXN0bTMy
