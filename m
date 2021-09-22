Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD8D413F5B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 04:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhIVCW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 22:22:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:16370 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIVCWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 22:22:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HDhkx3RsyzRQYl;
        Wed, 22 Sep 2021 10:17:13 +0800 (CST)
Received: from dggema724-chm.china.huawei.com (10.3.20.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 10:21:22 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema724-chm.china.huawei.com (10.3.20.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 22 Sep 2021 10:21:22 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.008;
 Wed, 22 Sep 2021 10:21:22 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: RE: [PATCH v2] skmsg: lose offset info in sk_psock_skb_ingress
Thread-Topic: [PATCH v2] skmsg: lose offset info in sk_psock_skb_ingress
Thread-Index: AQHXq2PFQrRB7jzQNEa7mJCtoY3loqurnLeAgAO5YEA=
Date:   Wed, 22 Sep 2021 02:21:21 +0000
Message-ID: <d3d74db4464340968ad74e3b9d32c997@huawei.com>
References: <20210917013222.74225-1-liujian56@huawei.com>
 <CAM_iQpUpUdd-SnrLOffVoGnW3ocKxDtefUAjktEs1KxE2-Gmvw@mail.gmail.com>
In-Reply-To: <CAM_iQpUpUdd-SnrLOffVoGnW3ocKxDtefUAjktEs1KxE2-Gmvw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29uZyBXYW5nIFttYWls
dG86eGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tXQ0KPiBTZW50OiBNb25kYXksIFNlcHRlbWJlciAy
MCwgMjAyMSA5OjE0IEFNDQo+IFRvOiBsaXVqaWFuIChDRSkgPGxpdWppYW41NkBodWF3ZWkuY29t
Pg0KPiBDYzogSm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT47IERhbmll
bCBCb3JrbWFubg0KPiA8ZGFuaWVsQGlvZ2VhcmJveC5uZXQ+OyBKYWt1YiBTaXRuaWNraSA8amFr
dWJAY2xvdWRmbGFyZS5jb20+OyBMb3JlbnoNCj4gQmF1ZXIgPGxtYkBjbG91ZGZsYXJlLmNvbT47
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBMaW51eCBLZXJuZWwgTmV0d29yayBEZXZlbG9wZXJzDQo+IDxuZXRk
ZXZAdmdlci5rZXJuZWwub3JnPjsgYnBmIDxicGZAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYyXSBza21zZzogbG9zZSBvZmZzZXQgaW5mbyBpbiBza19wc29ja19za2Jf
aW5ncmVzcw0KPiANCj4gT24gRnJpLCBTZXAgMTcsIDIwMjEgYXQgMzowNSBBTSBMaXUgSmlhbiA8
bGl1amlhbjU2QGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+IEBAIC02MjQsNiArNjM1LDEzIEBAIHN0
YXRpYyB2b2lkIHNrX3Bzb2NrX2JhY2tsb2coc3RydWN0IHdvcmtfc3RydWN0DQo+ICp3b3JrKQ0K
PiA+ICAgICAgICAgd2hpbGUgKChza2IgPSBza2JfZGVxdWV1ZSgmcHNvY2stPmluZ3Jlc3Nfc2ti
KSkpIHsNCj4gPiAgICAgICAgICAgICAgICAgbGVuID0gc2tiLT5sZW47DQo+ID4gICAgICAgICAg
ICAgICAgIG9mZiA9IDA7DQo+ID4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19CUEZfU1RSRUFNX1BB
UlNFUikNCj4gPiArICAgICAgICAgICAgICAgaWYgKHBzb2NrLT5zay0+c2tfZGF0YV9yZWFkeSA9
PSBza19wc29ja19zdHJwX2RhdGFfcmVhZHkpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICBzdG0gPSBzdHJwX21zZyhza2IpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG9mZiA9
IHN0bS0+b2Zmc2V0Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGxlbiA9IHN0bS0+ZnVs
bF9sZW47DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArI2VuZGlmDQo+IA0KPiBIb3cgZG9l
cyB0aGlzIHdvcms/IFlvdSBhcmUgdGVzdGluZyBwc29jay0+c2stPnNrX2RhdGFfcmVhZHkgaGVy
ZSBidXQgaXQgaXMNCj4gYWxyZWFkeSB0aGUgZGVzdCBzb2NrIGhlcmUsIHNvLCBpZiB3ZSByZWRp
cmVjdCBhIHN0cnBfbXNnKCkgZnJvbSBzdHJwIHNvY2tldCB0bw0KPiBub24tc3RycCBzb2NrZXQs
IHRoaXMgZG9lcyBub3Qgd29yayBhdCBhbGw/DQo+IA0KWWVzLCBpdCBpcyBub3Qgd29yayBpbiB0
aGlzIGNhc2UsIEkgZGlkIG5vdCBjb25zaWRlciB0aGlzIGNhc2UuDQoNCj4gQW5kIHRoaXMgY29k
ZSBsb29rcyB1Z2x5IGl0c2VsZi4gSWYgeW91IHdhbnQgdG8gZGlzdGluZ3Vpc2ggdGhpcyB0eXBl
IG9mIHBhY2tldA0KPiBmcm9tIG90aGVycywgeW91IGNhbiBhZGQgYSBiaXQgaW4sIGZvciBleGFt
cGxlIHNrYi0+X3NrX3JlZGlyLg0KSXQgbG9va3MgYmV0dGVyIHRoaXMgd2F5LiANCkkgd2lsbCBz
ZW5kIHYzIGxhdGVyLiBUaGFuayB5b3V+DQo+IA0KPiBUaGFua3MuDQo=
