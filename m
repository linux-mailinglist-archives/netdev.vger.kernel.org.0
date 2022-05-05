Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B714151BA34
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347057AbiEEI01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349549AbiEEI0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:26:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830424553A;
        Thu,  5 May 2022 01:21:18 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Kv67v667Pz1JBrY;
        Thu,  5 May 2022 16:20:11 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 16:21:15 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Thu, 5 May 2022 16:21:15 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "memxor@gmail.com" <memxor@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggYnBmLW5leHRdIGJwZi94ZHA6IENhbid0IGRldGFj?=
 =?utf-8?Q?h_BPF_XDP_prog_if_not_exist?=
Thread-Topic: [PATCH bpf-next] bpf/xdp: Can't detach BPF XDP prog if not exist
Thread-Index: AQHYX2op2bNaMdSDska3w9BA56i4160ODMuAgAHk8MA=
Date:   Thu, 5 May 2022 08:21:15 +0000
Message-ID: <594b5198d54c4c729728c20d167d9c2d@huawei.com>
References: <20220504035207.98221-1-shaozhengchao@huawei.com>
 <875ymlwnmy.fsf@toke.dk>
In-Reply-To: <875ymlwnmy.fsf@toke.dk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.66]
Content-Type: text/plain; charset="utf-8"
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

DQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IFRva2UgSMO4aWxhbmQtSsO4cmdl
bnNlbiBbbWFpbHRvOnRva2VAcmVkaGF0LmNvbV0gDQrlj5HpgIHml7bpl7Q6IDIwMjLlubQ15pyI
NOaXpSAxOToyMA0K5pS25Lu25Lq6OiBzaGFvemhlbmdjaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdl
aS5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBicGZAdmdlci5rZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBn
b29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tDQrmioTpgIE6IGFz
dEBrZXJuZWwub3JnOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgaGF3a0BrZXJuZWwub3JnOyBqb2hu
LmZhc3RhYmVuZEBnbWFpbC5jb207IGFuZHJpaUBrZXJuZWwub3JnOyBrYWZhaUBmYi5jb207IHNv
bmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsga3BzaW5naEBrZXJuZWwub3JnOyBiaWdl
YXN5QGxpbnV0cm9uaXguZGU7IGltYWdlZG9uZ0B0ZW5jZW50LmNvbTsgcGV0cm1AbnZpZGlhLmNv
bTsgbWVteG9yQGdtYWlsLmNvbTsgYXJuZEBhcm5kYi5kZTsgd2VpeW9uZ2p1biAoQSkgPHdlaXlv
bmdqdW4xQGh1YXdlaS5jb20+OyBzaGFvemhlbmdjaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdlaS5j
b20+OyB5dWVoYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQrkuLvpopg6IFJlOiBbUEFU
Q0ggYnBmLW5leHRdIGJwZi94ZHA6IENhbid0IGRldGFjaCBCUEYgWERQIHByb2cgaWYgbm90IGV4
aXN0DQoNClpoZW5nY2hhbyBTaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdlaS5jb20+IHdyaXRlczoN
Cg0KPiBpZiB1c2VyIHNldHMgbm9uZXhpc3RlbnQgeGRwX2ZsYWdzIHRvIGRldGFjaCB4ZHAgcHJv
Zywga2VybmVsIHNob3VsZCANCj4gcmV0dXJuIGVyciBhbmQgdGVsbCB1c2VyIHRoYXQgZGV0YWNo
IGZhaWxlZCB3aXRoIGRldGFpbCBpbmZvLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBaaGVuZ2NoYW8g
U2hhbyA8c2hhb3poZW5nY2hhb0BodWF3ZWkuY29tPg0KDQpJIGtpbmRhIHNlZSB5b3VyIHBvaW50
LCBidXQgdGhpcyB3aWxsIGNoYW5nZSB1c2VyLXZpc2libGUgYmVoYXZpb3VyIHRoYXQgYXBwbGlj
YXRpb25zIG1pZ2h0IGJlIHJlbHlpbmcgb24sIHNvIEkgZG9uJ3QgdGhpbmsgd2UgY2FuIG1ha2Ug
dGhpcyBjaGFuZ2UgYXQgdGhpcyBzdGFnZS4gV2h5IGNhbid0IHlvdXIgYXBwbGljYXRpb24ganVz
dCBxdWVyeSB0aGUgbGluayBmb3Igd2hldGhlciBhIHByb2dyYW0gaXMgYXR0YWNoZWQ/DQoNCi1U
b2tlDQoNCg0KVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5LiBJIHdpaWwgY2hhbmdlIHNhbXBsZSBh
cHBsaWNhdGlvbiBmaXJzdGx5LiBCdXQgaWYga2VybmVsIGRvZXMgbm90aGluZyBhbmQgcmV0dXJu
IDAsIG1heWJlIHVzZXIgd2lsbCB0aGluayBzZXR1cCBpcyBPSywgYWN0dWFsbHkgSXQgZmFpbGVk
LiBJcyB0aGlzIGFjY2VwdGFibGU/DQo=
