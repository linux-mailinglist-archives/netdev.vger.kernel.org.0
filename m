Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A324F545DA9
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 09:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244274AbiFJHhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 03:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiFJHhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 03:37:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F3512DBE0;
        Fri, 10 Jun 2022 00:37:39 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LKCSZ0KYhzjXVp;
        Fri, 10 Jun 2022 15:36:14 +0800 (CST)
Received: from dggpeml500011.china.huawei.com (7.185.36.84) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 15:37:37 +0800
Received: from dggpeml500011.china.huawei.com ([7.185.36.84]) by
 dggpeml500011.china.huawei.com ([7.185.36.84]) with mapi id 15.01.2375.024;
 Fri, 10 Jun 2022 15:37:36 +0800
From:   "zhudi (E)" <zhudi2@huawei.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>,
        "syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com" 
        <syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGZxX2NvZGVsOiBEaXNjYXJkIHByb2JsZW1hdGlj?=
 =?utf-8?Q?_packets_with_pkt=5Flen_0?=
Thread-Topic: [PATCH] fq_codel: Discard problematic packets with pkt_len 0
Thread-Index: AQHYfJjG9k49X3aJiUuEmDHyLJhsLa1HuSCAgAAAxQCAAIZ4UA==
Date:   Fri, 10 Jun 2022 07:37:36 +0000
Message-ID: <6adad85fe8ae4c04a24c3c7ce3bc0628@huawei.com>
References: <20220610070529.1623-1-zhudi2@huawei.com>
 <CANn89iKvXUbunP6UtNE1tNCH7FwCux22_rqwhGigvGn_64-6FA@mail.gmail.com>
 <CANn89i+PQ0Z5LHoTfBixJ9gzAcWD9_8dWccO80gSPx+uZ_wujA@mail.gmail.com>
In-Reply-To: <CANn89i+PQ0Z5LHoTfBixJ9gzAcWD9_8dWccO80gSPx+uZ_wujA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEVyaWMsIEknbGwgdGFrZSBhIGxvb2suDQoNCg0KPiBPbiBGcmksIEp1biAxMCwgMjAy
MiBhdCAxMjozMiBBTSBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+IHdyb3RlOg0K
PiA+DQo+ID4gT24gRnJpLCBKdW4gMTAsIDIwMjIgYXQgMTI6MDcgQU0gRGkgWmh1IDx6aHVkaTJA
aHVhd2VpLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gU3l6Ym90IGZvdW5kIGFuIGlzc3VlIFsx
XTogZnFfY29kZWxfZHJvcCgpIHRyeSB0byBkcm9wIGEgZmxvdyB3aGl0b3V0IGFueQ0KPiA+ID4g
c2ticywgdGhhdCBpcywgdGhlIGZsb3ctPmhlYWQgaXMgbnVsbC4NCj4gPiA+IFRoZSByb290IGNh
dXNlIGlzIHRoYXQ6IHdoZW4gdGhlIGZpcnN0IHF1ZXVlZCBza2Igd2l0aCBwa3RfbGVuIDAsIGJh
Y2tsb2dzDQo+ID4gPiBvZiB0aGUgZmxvdyB0aGF0IHRoaXMgc2tiIGVucXVldWVkIGlzIHN0aWxs
IDAgYW5kIGlmIHNjaC0+bGltaXQgaXMgc2V0IHRvDQo+ID4gPiAwIHRoZW4gZnFfY29kZWxfZHJv
cCgpIHdpbGwgYmUgY2FsbGVkLiBBdCB0aGlzIHBvaW50LCB0aGUgYmFja2xvZ3Mgb2YgYWxsDQo+
ID4gPiBmbG93cyBhcmUgYWxsIDAsIHNvIGZsb3cgd2l0aCBpZHggMCBpcyBzZWxlY3RlZCB0byBk
cm9wLCBidXQgdGhpcyBmbG93IGhhdmUNCj4gPiA+IG5vdCBhbnkgc2ticy4NCj4gPiA+IHNrYiB3
aXRoIHBrdF9sZW4gMCBjYW4gYnJlYWsgZXhpc3RpbmcgcHJvY2Vzc2luZyBsb2dpYywgc28ganVz
dCBkaXNjYXJkDQo+ID4gPiB0aGVzZSBpbnZhbGlkIHNrYnMuDQo+ID4gPg0KPiA+ID4gTElOSzog
WzFdDQo+IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL2J1Zz9pZD0wYjg0ZGE4MGMyOTE3
NzU3OTE1YWZhODlmNzczOGE5ZDE2ZQ0KPiBjOTZjNQ0KPiA+ID4NCj4gPiA+IFJlcG9ydGVkLWJ5
OiBzeXpib3QrN2ExMjkwOTQ4NWI5NDQyNmFjZWJAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogRGkgWmh1IDx6aHVkaTJAaHVhd2VpLmNvbT4NCj4gPiA+IC0t
LQ0KPiA+ID4gIG5ldC9zY2hlZC9zY2hfZnFfY29kZWwuYyB8IDMgKysrDQo+ID4gPiAgMSBmaWxl
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQv
c2NoZWQvc2NoX2ZxX2NvZGVsLmMgYi9uZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLmMNCj4gPiA+IGlu
ZGV4IDgzOWUxMjM1ZGIwNS4uYzBmODJiNzM1OGUxIDEwMDY0NA0KPiA+ID4gLS0tIGEvbmV0L3Nj
aGVkL3NjaF9mcV9jb2RlbC5jDQo+ID4gPiArKysgYi9uZXQvc2NoZWQvc2NoX2ZxX2NvZGVsLmMN
Cj4gPiA+IEBAIC0xOTEsNiArMTkxLDkgQEAgc3RhdGljIGludCBmcV9jb2RlbF9lbnF1ZXVlKHN0
cnVjdCBza19idWZmICpza2IsDQo+IHN0cnVjdCBRZGlzYyAqc2NoLA0KPiA+ID4gICAgICAgICB1
bnNpZ25lZCBpbnQgcGt0X2xlbjsNCj4gPiA+ICAgICAgICAgYm9vbCBtZW1vcnlfbGltaXRlZDsN
Cj4gPiA+DQo+ID4gPiArICAgICAgIGlmICh1bmxpa2VseSghcWRpc2NfcGt0X2xlbihza2IpKSkN
Cj4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gcWRpc2NfZHJvcChza2IsIHNjaCwgdG9fZnJl
ZSk7DQo+ID4gPiArDQo+ID4NCj4gPg0KPiA+IFRoaXMgaGFzIGJlZW4gZGlzY3Vzc2VkIGluIHRo
ZSBwYXN0Lg0KPiA+DQo+IA0KPiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9uZXRkZXYv
bXNnNzc3NTAzLmh0bWwNCj4gDQo+ID4gRmVlZGluZyBuZG9fc3RhcnRfeG1pdCgpIGluIGh1bmRy
ZWRzIG9mIGRyaXZlcnMgd2l0aCB6ZXJvLWxlbmd0aA0KPiA+IHBhY2tldHMgd2lsbCBjcmFzaCBh
bnl3YXkuDQo+ID4NCj4gPiBXZSBhcmUgbm90IGdvaW5nIHRvIGFkZCBzdWNoIHNpbGx5IHRlc3Rz
IGluIGFsbCBxZGlzY3MsIGFuZCB0aGVuIGFsbA0KPiA+IG5kb19zdGFydF94bWl0KCksIHNpbmNl
IHFkaXNjcyBhcmUgbm90IG1hbmRhdG9yeS4NCj4gPg0KPiA+IFBsZWFzZSBpbnN0ZWFkIGZpeCBC
UEYgbGF5ZXIsIGluc3RlYWQgb2YgaHVuZHJlZHMgb2YgZHJpdmVycy9xZGlzY3MuDQo=
