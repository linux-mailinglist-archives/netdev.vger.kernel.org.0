Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF2F2642AB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgIJJpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:45:12 -0400
Received: from smtp.h3c.com ([60.191.123.56]:46144 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgIJJpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 05:45:04 -0400
Received: from DAG2EX08-IDC.srv.huawei-3com.com ([10.8.0.71])
        by h3cspam01-ex.h3c.com with ESMTPS id 08A9irMK054157
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 17:44:53 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) by
 DAG2EX08-IDC.srv.huawei-3com.com (10.8.0.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Sep 2020 17:44:56 +0800
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074])
 by DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074%7]) with
 mapi id 15.01.1713.004; Thu, 10 Sep 2020 17:44:56 +0800
From:   Tianxianting <tian.xianting@h3c.com>
To:     Jens Axboe <axboe@kernel.dk>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] block: remove redundant empty check of mq_list
Thread-Topic: [PATCH] block: remove redundant empty check of mq_list
Thread-Index: AQHWhnZLNDw9Ap0NoUKJovJuaKCnsqlf1fuAgAHGWJA=
Date:   Thu, 10 Sep 2020 09:44:56 +0000
Message-ID: <d0b4d3e984d2499d9c2f28834a21e9ae@h3c.com>
References: <20200909064814.5704-1-tian.xianting@h3c.com>
 <466b8c40-9d53-8a40-6c5b-f76db2974c04@kernel.dk>
In-Reply-To: <466b8c40-9d53-8a40-6c5b-f76db2974c04@kernel.dk>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.141.128]
x-sender-location: DAG2
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 08A9irMK054157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmVucywNClRoYW5rcyBmb3IgeW91ciBmZWVkYmFjaywNClllcywgYmxrX2ZsdXNoX3BsdWdf
bGlzdCgpIGlzIG9ubHkgY2FsbGVyIG9mIGJsa19tcV9mbHVzaF9wbHVnX2xpc3QoKS4NClNvIEkg
Y2hlY2tlZCB0aGUgY2FsbGVycyBvZiBibGtfZmx1c2hfcGx1Z19saXN0KCksIGZvdW5kIGJlbG93
IGNvZGUgcGF0aCB3aWxsIGNhbGwgYmxrX2ZsdXNoX3BsdWdfbGlzdCgpOg0KCWlvX3NjaGVkdWxl
X3ByZXBhcmUvc2NoZWRfc3VibWl0X3dvcmstPmJsa19zY2hlZHVsZV9mbHVzaF9wbHVnDQoJd3Jp
dGViYWNrX3NiX2lub2Rlcy0+YmxrX2ZsdXNoX3BsdWcNCglibGtfZmluaXNoX3BsdWcNCglkbV9z
dWJtaXRfYmlvL19fc3VibWl0X2Jpb19ub2FjY3RfbXEvX19zdWJtaXRfYmlvLT5ibGtfbXFfc3Vi
bWl0X2Jpbw0KCWJsa19wb2xsDQoNClNvIEkgdGhpbmsgdGhlcmUgYXJlIHN0aWxsIG1hbnkgY2hh
bmNlcyB0byBkbyB0aGUgcmVkdW5kYW50IGp1ZGdlPw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KRnJvbTogSmVucyBBeGJvZSBbbWFpbHRvOmF4Ym9lQGtlcm5lbC5ka10gDQpTZW50OiBX
ZWRuZXNkYXksIFNlcHRlbWJlciAwOSwgMjAyMCAxMDoyMSBQTQ0KVG86IHRpYW54aWFudGluZyAo
UkQpIDx0aWFuLnhpYW50aW5nQGgzYy5jb20+OyBhc3RAa2VybmVsLm9yZzsgZGFuaWVsQGlvZ2Vh
cmJveC5uZXQ7IGthZmFpQGZiLmNvbTsgc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5aHNAZmIuY29t
OyBhbmRyaWluQGZiLmNvbTsgam9obi5mYXN0YWJlbmRAZ21haWwuY29tOyBrcHNpbmdoQGNocm9t
aXVtLm9yZw0KQ2M6IGxpbnV4LWJsb2NrQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9y
Zw0KU3ViamVjdDogUmU6IFtQQVRDSF0gYmxvY2s6IHJlbW92ZSByZWR1bmRhbnQgZW1wdHkgY2hl
Y2sgb2YgbXFfbGlzdA0KDQpPbiA5LzkvMjAgMTI6NDggQU0sIFhpYW50aW5nIFRpYW4gd3JvdGU6
DQo+IGJsa19tcV9mbHVzaF9wbHVnX2xpc3QoKSBpdHNlbGYgd2lsbCBkbyB0aGUgZW1wdHkgY2hl
Y2sgb2YgbXFfbGlzdCwgc28gDQo+IHJlbW92ZSBzdWNoIGNoZWNrIGluIGJsa19mbHVzaF9wbHVn
X2xpc3QoKS4NCj4gQWN0dWFsbHkgbm9ybWFsbHkgbXFfbGlzdCBpcyBub3QgZW1wdHkgd2hlbiBi
bGtfZmx1c2hfcGx1Z19saXN0IGlzIA0KPiBjYWxsZWQuDQoNCkl0J3MgY2hlYXBlciB0byBkbyBp
biB0aGUgY2FsbGVyLCBpbnN0ZWFkIG9mIGRvaW5nIHRoZSBmdW5jdGlvbiBjYWxsIGFuZCB0aGVu
IGFib3J0aW5nIGlmIGl0J3MgZW1wdHkuIFNvIEknZCBzdWdnZXN0IGp1c3QgbGVhdmluZyBpdCBh
bG9uZS4NClJpZ2h0IG5vdyB0aGlzIGlzIHRoZSBvbmx5IGNhbGxlciwgYnV0IGl0J3MgbmljZXIg
dG8gYXNzdW1lIHdlIGNhbiBiZSBjYWxsZWQgaW4gYW55IHN0YXRlIHZzIG5vdCBoYXZpbmcgdGhl
IGNoZWNrLg0KDQotLQ0KSmVucyBBeGJvZQ0KDQo=
