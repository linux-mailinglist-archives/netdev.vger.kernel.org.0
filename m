Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A679F2709BC
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 03:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgISBqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 21:46:49 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3523 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISBqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 21:46:49 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 21:46:48 EDT
Received: from dggeme712-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 4F397C06F15746DB0017;
        Sat, 19 Sep 2020 09:31:39 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme712-chm.china.huawei.com (10.1.199.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 19 Sep 2020 09:31:38 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.1913.007;
 Sat, 19 Sep 2020 09:31:39 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     David Miller <davem@davemloft.net>
CC:     "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogZXRoZXJuZXQ6IFJlbW92?=
 =?utf-8?Q?e_set_but_not_used_variable?=
Thread-Topic: [PATCH net-next] net: ethernet: Remove set but not used variable
Thread-Index: AQHWjZdJd0i4p04kC0qP4eEiMpD3rqluZH6AgADJT/A=
Date:   Sat, 19 Sep 2020 01:31:38 +0000
Message-ID: <7adfc7d14e2a4284a0b99f428d2836b0@huawei.com>
References: <20200918083938.21046-1-zhengyongjun3@huawei.com>
 <20200918.143013.184259371965563025.davem@davemloft.net>
In-Reply-To: <20200918.143013.184259371965563025.davem@davemloft.net>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.94]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBoYXZlIGZpeCBpdCBhbmQgc2VuZCBiYWNrIHRoZSBwYXRjaCB0byB5b3UuIFRoYW5rIHlvdSB2
ZXJ5IG11Y2guDQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogRGF2aWQgTWls
bGVyIFttYWlsdG86ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldF0gDQrlj5HpgIHml7bpl7Q6IDIwMjDlubQ5
5pyIMTnml6UgNTozMA0K5pS25Lu25Lq6OiB6aGVuZ3lvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVh
d2VpLmNvbT4NCuaKhOmAgTogZm1hbmx1bmFzQG1hcnZlbGwuY29tOyBzYnVybGFAbWFydmVsbC5j
b207IGRjaGlja2xlc0BtYXJ2ZWxsLmNvbTsga3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrkuLvpopg6IFJlOiBbUEFU
Q0ggbmV0LW5leHRdIG5ldDogZXRoZXJuZXQ6IFJlbW92ZSBzZXQgYnV0IG5vdCB1c2VkIHZhcmlh
YmxlDQoNCkZyb206IFpoZW5nIFlvbmdqdW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT4NCkRh
dGU6IEZyaSwgMTggU2VwIDIwMjAgMTY6Mzk6MzggKzA4MDANCg0KPiBGaXhlcyBnY2MgJy1XdW51
c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYXZpdW0vbGlxdWlkaW8vb2N0ZW9uX2RldmljZS5jOiBJbiBmdW5jdGlvbiBsaW9fcGNpX3Jl
YWRxOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vbGlxdWlkaW8vb2N0ZW9uX2Rldmlj
ZS5jOjEzMjc6Njogd2FybmluZzogdmFyaWFibGUgyr12YWwzMsq8IHNldCBidXQgbm90IHVzZWQg
Wy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9j
YXZpdW0vbGlxdWlkaW8vb2N0ZW9uX2RldmljZS5jOiBJbiBmdW5jdGlvbiBsaW9fcGNpX3dyaXRl
cToNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvY2F2aXVtL2xpcXVpZGlvL29jdGVvbl9kZXZpY2Uu
YzoxMzU4OjY6IHdhcm5pbmc6IHZhcmlhYmxlIMq9dmFsMzLKvCBzZXQgYnV0IG5vdCB1c2VkIFst
V3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gdGhlc2UgdmFyaWFibGUgaXMgbmV2ZXIg
dXNlZCwgc28gcmVtb3ZlIGl0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8
emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KDQpUaGUgcHJvcGVyIHN1YnN5c3RlbSBwcmVmaXgg
Zm9yIHRoZXNlIGNoYW5nZXMgaXMganVzdCAibGlxdWlkaW86ICIuDQoNCkZvciBjaGFuZ2VzIHRv
IGEgc3BlY2lmaWMgZHJpdmVyIGl0IGlzIG5vdCBhcHByb3ByaWF0ZSB0byB1c2UNCiJuZXQ6IGV0
aGVybmV0OiAiIG9yIHNpbWlsYXIuDQoNClBsZWFzZSBmaXggdXAgeW91ciBTdWJqZWN0IGxpbmUg
YW5kIHJlc3VibWl0Lg0KDQpUaGFuayB5b3UuDQo=
