Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A85F0C36
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiI3NMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 09:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiI3NMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 09:12:18 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD411794B4;
        Fri, 30 Sep 2022 06:12:16 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mf9Yt6TRFzHqPg;
        Fri, 30 Sep 2022 21:09:54 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 21:12:14 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.031;
 Fri, 30 Sep 2022 21:12:13 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: RE: [PATCH net-next,v2] selftests/tc-testing: update qdisc/cls/action
 features in config
Thread-Topic: [PATCH net-next,v2] selftests/tc-testing: update
 qdisc/cls/action features in config
Thread-Index: AQHY07l7AnPOr2EpL0OOVCFz2fDzjK32l7+AgACodACAALJFUA==
Date:   Fri, 30 Sep 2022 13:12:13 +0000
Message-ID: <ed6cfa6055a94f0fa2bc98d728a9cd97@huawei.com>
References: <20220929041909.83913-1-shaozhengchao@huawei.com>
        <CA+NMeC8gFQ-M-nMzNA5H3UQKNtbekGvbKRxhyhg-b0QSNjY7MA@mail.gmail.com>
 <CAM0EoMnp6T6D3p=HjcH+SXha-vMphHRL9eTEKcRaseBDaODBXA@mail.gmail.com>
In-Reply-To: <CAM0EoMnp6T6D3p=HjcH+SXha-vMphHRL9eTEKcRaseBDaODBXA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.84.79.133]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWw6DQoJTXkgYXBvbG9naXNlLiBJIHdpbGwgYmUgbW9yZSBjYXJlZnVsIGJlZm9yZSBz
ZW5kaW5nIHBhdGNoLiANClRoYW5rcyB0byBWaWN0b3IgYW5kIHlvdSBmb3IgdGhlIHJldmlldy4N
Cg0KWmhlbmdjaGFvIFNoYW8NCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEph
bWFsIEhhZGkgU2FsaW0gW21haWx0bzpqaHNAbW9qYXRhdHUuY29tXSANClNlbnQ6IEZyaWRheSwg
U2VwdGVtYmVyIDMwLCAyMDIyIDY6MjUgUE0NClRvOiBWaWN0b3IgTm9ndWVpcmEgPHZpY3RvckBt
b2phdGF0dS5jb20+DQpDYzogc2hhb3poZW5nY2hhbyA8c2hhb3poZW5nY2hhb0BodWF3ZWkuY29t
PjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta3NlbGZ0ZXN0QHZnZXIua2VybmVsLm9y
ZzsgeGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tOyBqaXJpQHJlc251bGxpLnVzOyBzaHVhaEBrZXJu
ZWwub3JnOyB3ZWl5b25nanVuIChBKSA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT47IHl1ZWhhaWJp
bmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQs
djJdIHNlbGZ0ZXN0cy90Yy10ZXN0aW5nOiB1cGRhdGUgcWRpc2MvY2xzL2FjdGlvbiBmZWF0dXJl
cyBpbiBjb25maWcNCg0KUGxlYXNlIGRvdWJsZSBjaGVjayB5b3VyIHdvcmsgYnkgdGVzdGluZyBp
dCBiZWZvcmUgc3VibWl0dGluZyBzbyB3ZSBjYW4gc2F2ZSBzb21lIGN5Y2xlcyBpbiByZXZpZXdp
bmcuIFRob3NlIHR5cG9zIG1lYW5zIHlvdXIgbGFzdCBjb21taXQgd2FzIG5vdCB0ZXN0ZWQuDQoN
CkFja2VkLWJ5OiBKYW1hbCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPg0KDQpjaGVlcnMs
DQpqYW1hbA0KDQpPbiBUaHUsIFNlcCAyOSwgMjAyMiBhdCA4OjIyIFBNIFZpY3RvciBOb2d1ZWly
YSA8dmljdG9yQG1vamF0YXR1LmNvbT4gd3JvdGU6DQo+DQo+IE9uIFRodSwgU2VwIDI5LCAyMDIy
IGF0IDE6MTEgQU0gWmhlbmdjaGFvIFNoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPiBTaW5jZSB0aHJlZSBwYXRjaHNldHMgImFkZCB0Yy10ZXN0aW5nIHRlc3Qg
Y2FzZXMiLCAicmVmYWN0b3IgDQo+ID4gZHVwbGljYXRlIGNvZGVzIGluIHRoZSB0YyBjbHMgd2Fs
ayBmdW5jdGlvbiIsIGFuZCAicmVmYWN0b3IgDQo+ID4gZHVwbGljYXRlIGNvZGVzIGluIHRoZSBx
ZGlzYyBjbGFzcyB3YWxrIGZ1bmN0aW9uIiBhcmUgbWVyZ2VkIHRvIA0KPiA+IG5ldC1uZXh0IHRy
ZWUsIHRoZSBsaXN0IG9mIHN1cHBvcnRlZCBmZWF0dXJlcyBuZWVkcyB0byBiZSB1cGRhdGVkIGlu
IGNvbmZpZyBmaWxlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWmhlbmdjaGFvIFNoYW8gPHNo
YW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4NCj4NCj4gUmV2aWV3ZWQtYnk6IFZpY3RvciBOb2d1ZWly
YSA8dmljdG9yQG1vamF0YXR1LmNvbT4NCg0K
