Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00BC567BB0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiGFBwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiGFBwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:52:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4045B1838E;
        Tue,  5 Jul 2022 18:52:41 -0700 (PDT)
Received: from canpemm100008.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ld2Wz2DWGzTgDQ;
        Wed,  6 Jul 2022 09:49:03 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm100008.china.huawei.com (7.192.104.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 09:52:39 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Wed, 6 Jul 2022 09:52:38 +0800
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
Subject: =?gb2312?B?tPC4tDogW1BBVENIIG5ldC1uZXh0XSBuZXQvc2NoZWQ6IHJlbW92ZSByZXR1?=
 =?gb2312?B?cm4gdmFsdWUgb2YgdW5yZWdpc3Rlcl90Y2ZfcHJvdG9fb3Bz?=
Thread-Topic: [PATCH net-next] net/sched: remove return value of
 unregister_tcf_proto_ops
Thread-Index: AQHYj6L3NBuAhRfXIUOUGl4H1lu4uq1wDi8AgACHmPA=
Date:   Wed, 6 Jul 2022 01:52:38 +0000
Message-ID: <a92ed8b2b01e499b986ad7b9b0fe93a8@huawei.com>
References: <20220704124322.355211-1-shaozhengchao@huawei.com>
 <20220705184326.649a4e04@kernel.org>
In-Reply-To: <20220705184326.649a4e04@kernel.org>
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

DQotLS0tLdPKvP7Urbz+LS0tLS0NCreivP7IyzogSmFrdWIgS2ljaW5za2kgW21haWx0bzprdWJh
QGtlcm5lbC5vcmddIA0Kt6LLzcqxvOQ6IDIwMjLE6jfUwjbI1SA5OjQzDQrK1bz+yMs6IHNoYW96
aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4NCrOty806IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGpoc0Btb2phdGF0dS5jb207
IHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbTsgamlyaUByZXNudWxsaS51czsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207IHdlaXlvbmdq
dW4gKEEpIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPjsgeXVlaGFpYmluZyA8eXVlaGFpYmluZ0Bo
dWF3ZWkuY29tPg0K1vfM4jogUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0L3NjaGVkOiByZW1vdmUg
cmV0dXJuIHZhbHVlIG9mIHVucmVnaXN0ZXJfdGNmX3Byb3RvX29wcw0KDQpPbiBNb24sIDQgSnVs
IDIwMjIgMjA6NDM6MjIgKzA4MDAgWmhlbmdjaGFvIFNoYW8gd3JvdGU6DQo+IFJldHVybiB2YWx1
ZSBvZiB1bnJlZ2lzdGVyX3RjZl9wcm90b19vcHMgaXMgdXNlbGVzcywgcmVtb3ZlIGl0Lg0KDQpz
L3VzZWxlc3MvdW51c2VkLyA/DQoNClNob3VsZCB3ZSBhZGQgYSBXQVJOIGlmIHRoZSBvcHMgZ2V0
dGluZyByZW1vdmVkIGNhbid0IGJlIGZvdW5kIG9yIHRoZXJlIGFyZSBjYWxsZXJzIHdoaWNoIGRl
cGVuZCBvbiBoYW5kbGluZyB1bnJlZ2lzdGVyZWQgb3BzIHdpdGhvdXQgYSB3YXJuaW5nPw0KDQpI
aSBKYWt1YiBLaWNpbnNraToNCglUaGFuayB5b3UgZm9yIHlvdXIgYXBwbHkuIFRoaXMgcGF0Y2gg
ZG9lcyBqdXN0IHJlbW92ZSB0aGUgcmV0dXJuIHZhbHVlIGFuZCBjaGFuZ2UgdGhlIGZ1bmN0aW9u
IHR5cGUgZnJvbSBpbnQgdG8gdm9pZC4gSXQgZG9lc24ndCByZW1vdmUgdGhlIGZ1bmN0aW9uLg0K
DQpaaGVuZ2NoYW8gU2hhbw0K
