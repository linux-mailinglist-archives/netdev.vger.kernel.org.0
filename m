Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67027572B0A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiGMBpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiGMBpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:45:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E34ED216E;
        Tue, 12 Jul 2022 18:45:23 -0700 (PDT)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LjL2C4wSKzVfds;
        Wed, 13 Jul 2022 09:41:39 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 09:45:21 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Wed, 13 Jul 2022 09:45:21 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIHYyLG5ldC1uZXh0XSBuZXQvc2NoZWQ6IHJlbW92ZSBy?=
 =?gb2312?B?ZXR1cm4gdmFsdWUgb2YgdW5yZWdpc3Rlcl90Y2ZfcHJvdG9fb3Bz?=
Thread-Topic: [PATCH v2,net-next] net/sched: remove return value of
 unregister_tcf_proto_ops
Thread-Index: AQHYlPzZC3TG6GoUpUWj56DI8e3zxq16+jUAgACP27A=
Date:   Wed, 13 Jul 2022 01:45:21 +0000
Message-ID: <21adc0dadeb84320aa360135a5b639c9@huawei.com>
References: <20220711080910.40270-1-shaozhengchao@huawei.com>
 <20220712180906.07bea7f8@kernel.org>
In-Reply-To: <20220712180906.07bea7f8@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.66]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0t08q8/tStvP4tLS0tLQ0Kt6K8/sjLOiBKYWt1YiBLaWNpbnNraSBbbWFpbHRvOmt1
YmFAa2VybmVsLm9yZ10gDQq3osvNyrG85DogMjAyMsTqN9TCMTPI1SA5OjA5DQrK1bz+yMs6IHNo
YW96aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4NCrOty806IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGpoc0Btb2phdGF0dS5j
b207IHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbTsgamlyaUByZXNudWxsaS51czsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207IHdlaXlv
bmdqdW4gKEEpIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPjsgeXVlaGFpYmluZyA8eXVlaGFpYmlu
Z0BodWF3ZWkuY29tPg0K1vfM4jogUmU6IFtQQVRDSCB2MixuZXQtbmV4dF0gbmV0L3NjaGVkOiBy
ZW1vdmUgcmV0dXJuIHZhbHVlIG9mIHVucmVnaXN0ZXJfdGNmX3Byb3RvX29wcw0KDQpPbiBNb24s
IDExIEp1bCAyMDIyIDE2OjA5OjEwICswODAwIFpoZW5nY2hhbyBTaGFvIHdyb3RlOg0KPiBSZXR1
cm4gdmFsdWUgb2YgdW5yZWdpc3Rlcl90Y2ZfcHJvdG9fb3BzIGlzIHVudXNlZCwgcmVtb3ZlIGl0
Lg0KDQo+IC1pbnQgdW5yZWdpc3Rlcl90Y2ZfcHJvdG9fb3BzKHN0cnVjdCB0Y2ZfcHJvdG9fb3Bz
ICpvcHMpDQo+ICt2b2lkIHVucmVnaXN0ZXJfdGNmX3Byb3RvX29wcyhzdHJ1Y3QgdGNmX3Byb3Rv
X29wcyAqb3BzKQ0KPiAgew0KPiAgCXN0cnVjdCB0Y2ZfcHJvdG9fb3BzICp0Ow0KPiAgCWludCBy
YyA9IC1FTk9FTlQ7DQo+IEBAIC0yMTQsNyArMjE0LDEwIEBAIGludCB1bnJlZ2lzdGVyX3RjZl9w
cm90b19vcHMoc3RydWN0IHRjZl9wcm90b19vcHMgKm9wcykNCj4gIAkJfQ0KPiAgCX0NCj4gIAl3
cml0ZV91bmxvY2soJmNsc19tb2RfbG9jayk7DQo+IC0JcmV0dXJuIHJjOw0KPiArDQoNCj4gKwlp
ZiAocmMpDQo+ICsJCXByX3dhcm4oInVucmVnaXN0ZXIgdGMgZmlsdGVyIGtpbmQoJXMpIGZhaWxl
ZFxuIiwgb3BzLT5raW5kKTsNCg0KSSB3YXMgc2F5aW5nIFdBUk4sIGJ5IHdoaWNoIEkgbWVhbnQ6
DQoNCldBUk4ocmMsICJ1bnJlZ2lzdGVyIHRjIGZpbHRlciBraW5kKCVzKSBmYWlsZWQgJWRcbiIs
IG9wcy0+a2luZCwgcmMpOw0KDQpIaSBKYWt1YjoNCglUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHku
IEkgd2lsbCBmaXggaXQuDQoNClpoYW5nY2hhbyBTaGFvDQoNCg==
