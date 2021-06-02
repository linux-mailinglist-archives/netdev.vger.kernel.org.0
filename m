Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BC7397E25
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFBBj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:29 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6125 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhFBBj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 21:39:27 -0400
Received: from dggeme709-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fvs5t6dKwzYn13;
        Wed,  2 Jun 2021 09:34:58 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme709-chm.china.huawei.com (10.1.199.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 09:37:42 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Wed, 2 Jun 2021 09:37:42 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "sbranden@broadcom.com" <sbranden@broadcom.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "opendmb@gmail.com" <opendmb@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jbrunet@baylibre.com" <jbrunet@baylibre.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIG5ldC1uZXh0XSBuZXQ6IG1kaW86IEZpeCBzcGVsbGlu?=
 =?gb2312?Q?g_mistakes?=
Thread-Topic: [PATCH net-next] net: mdio: Fix spelling mistakes
Thread-Index: AQHXVu8poZJ1gXDCckK65ke/PM4ReKr+rcUAgAFD+mA=
Date:   Wed, 2 Jun 2021 01:37:42 +0000
Message-ID: <083325fb1314426fb6d4437304a9ed9c@huawei.com>
References: <20210601141859.4131776-1-zhengyongjun3@huawei.com>
 <20210601141738.GA30436@shell.armlinux.org.uk>
In-Reply-To: <20210601141738.GA30436@shell.armlinux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBoYXZlIGRvIHRoaXMgYXMgeW91ciBhZHZpY2UgYW5kIHNlbmQgcGF0Y2ggdjIgOikNCg0KLS0t
LS3Tyrz+1K28/i0tLS0tDQq3orz+yMs6IFJ1c3NlbGwgS2luZyBbbWFpbHRvOmxpbnV4QGFybWxp
bnV4Lm9yZy51a10gDQq3osvNyrG85DogMjAyMcTqNtTCMcjVIDIyOjE4DQrK1bz+yMs6IHpoZW5n
eW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0Ks63LzTogYW5kcmV3QGx1bm4uY2g7
IGhrYWxsd2VpdDFAZ21haWwuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5v
cmc7IHJqdWlAYnJvYWRjb20uY29tOyBzYnJhbmRlbkBicm9hZGNvbS5jb207IGJjbS1rZXJuZWwt
ZmVlZGJhY2stbGlzdEBicm9hZGNvbS5jb207IG5hcm1zdHJvbmdAYmF5bGlicmUuY29tOyBraGls
bWFuQGJheWxpYnJlLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtYW1sb2dpY0BsaXN0cy5pbmZyYWRlYWQub3JnOyBvcGVuZG1i
QGdtYWlsLmNvbTsgZi5mYWluZWxsaUBnbWFpbC5jb207IGpicnVuZXRAYmF5bGlicmUuY29tOyBt
YXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tDQrW98ziOiBSZTogW1BBVENIIG5ldC1u
ZXh0XSBuZXQ6IG1kaW86IEZpeCBzcGVsbGluZyBtaXN0YWtlcw0KDQpPbiBUdWUsIEp1biAwMSwg
MjAyMSBhdCAxMDoxODo1OVBNICswODAwLCBaaGVuZyBZb25nanVuIHdyb3RlOg0KPiBpbmZvcm1h
dGlvbnMgID09PiBpbmZvcm1hdGlvbg0KPiB0eXBpY2FseSAgPT0+IHR5cGljYWxseQ0KPiBkZXJy
aXZlICA9PT4gZGVyaXZlDQo+IGV2ZW50aG91Z2ggID09PiBldmVuIHRob3VnaA0KDQpJZiB5b3Un
cmUgZG9pbmcgdGhpcywgdGhlbiBwbGVhc2UgYWxzbyBjaGFuZ2UgImh6IiB0byAiSHoiLiBUaGUg
dW5pdCBvZiBmcmVxdWVuY3kgaXMgdGhlIGxhdHRlciwgbm90IHRoZSBmb3JtZXIuIFRoYW5rcy4N
Cg0KLS0NClJNSydzIFBhdGNoIHN5c3RlbTogaHR0cHM6Ly93d3cuYXJtbGludXgub3JnLnVrL2Rl
dmVsb3Blci9wYXRjaGVzLw0KRlRUUCBpcyBoZXJlISA0ME1icHMgZG93biAxME1icHMgdXAuIERl
Y2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg==
