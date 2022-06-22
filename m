Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CBF5543CB
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 10:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352484AbiFVHOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 03:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352488AbiFVHOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 03:14:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B30369DE;
        Wed, 22 Jun 2022 00:14:20 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSZPF2MvCz67YZ9;
        Wed, 22 Jun 2022 15:13:53 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 09:14:18 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 22 Jun 2022 09:14:18 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>
CC:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 4/5] selftests/bpf: Add test for unreleased key
 references
Thread-Topic: [PATCH v5 4/5] selftests/bpf: Add test for unreleased key
 references
Thread-Index: AQHYhY1lWBqFnG8Z5ki4oxpvmYhP1q1aUdKAgACyOvA=
Date:   Wed, 22 Jun 2022 07:14:18 +0000
Message-ID: <b93622dffbfa41f99a18d8883a890879@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-5-roberto.sassu@huawei.com>
 <62b247b975506_162742082f@john.notmuch>
In-Reply-To: <62b247b975506_162742082f@john.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKb2huIEZhc3RhYmVuZCBbbWFpbHRvOmpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbV0N
Cj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDIyLCAyMDIyIDEyOjM2IEFNDQo+IFJvYmVydG8gU2Fz
c3Ugd3JvdGU6DQo+ID4gRW5zdXJlIHRoYXQgdGhlIHZlcmlmaWVyIGRldGVjdHMgdGhlIGF0dGVt
cHQgb2YgYWNxdWlyaW5nIGEgcmVmZXJlbmNlIG9mIGENCj4gPiBrZXkgdGhyb3VnaCB0aGUgaGVs
cGVyIGJwZl9sb29rdXBfdXNlcl9rZXkoKSwgd2l0aG91dCByZWxlYXNpbmcgdGhhdA0KPiA+IHJl
ZmVyZW5jZSB3aXRoIGJwZl9rZXlfcHV0KCksIGFuZCByZWZ1c2VzIHRvIGxvYWQgdGhlIHByb2dy
YW0uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1
QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+IA0KPiBBbnkgcmVhc29uIG5vdCB0byBhZGQgdGhlc2Ug
dG8gLi92ZXJpZmllci9yZWZfdHJhY2tpbmcuYyB0ZXN0cz8gU2VlbXMgaXQNCj4gbWlnaHQgYmUg
ZWFzaWVyIHRvIGZvbGxvdyB0aGVyZSBhbmQgdGVzdCBib3RoIGdvb2QvYmFkIGNhc2VzLg0KDQpP
aCwgSSBkaWRuJ3Qga25vdyBhYm91dCBpdC4gV2lsbCBtb3ZlIHRoZSB0ZXN0Lg0KDQpUaGFua3MN
Cg0KUm9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1
NjA2Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFlhbmcgWGksIExpIEhlDQo=
