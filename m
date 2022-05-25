Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2645335CC
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 05:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbiEYD1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 23:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiEYD1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 23:27:37 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F152C77F28;
        Tue, 24 May 2022 20:27:35 -0700 (PDT)
Received: from canpemm100007.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L7Ggt3dF5zhXZW;
        Wed, 25 May 2022 11:26:34 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm100007.china.huawei.com (7.192.105.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 25 May 2022 11:27:33 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Wed, 25 May 2022 11:27:33 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjMsYnBmLW5leHRdIHNhbXBsZXMvYnBmOiBjaGVj?=
 =?utf-8?Q?k_detach_prog_exist_or_not_in_xdp=5Ffwd?=
Thread-Topic: [PATCH v3,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
Thread-Index: AQHYbMwX/T6Yw+1VQUW5SPSwZfp9Ia0u9MSQ
Date:   Wed, 25 May 2022 03:27:33 +0000
Message-ID: <eb8ee7fe2ffc477299eb2eceb622ca29@huawei.com>
References: <20220521043509.389007-1-shaozhengchao@huawei.com>
In-Reply-To: <20220521043509.389007-1-shaozhengchao@huawei.com>
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

LS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiBzaGFvemhlbmdjaGFvIA0K5Y+R6YCB
5pe26Ze0OiAyMDIy5bm0NeaciDIx5pelIDEyOjM1DQrmlLbku7bkuro6IGJwZkB2Z2VyLmtlcm5l
bC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGFzdEBrZXJuZWwub3JnOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBoYXdrQGtlcm5lbC5vcmc7IGpvaG4uZmFzdGFiZW5kQGdt
YWlsLmNvbTsgYW5kcmlpQGtlcm5lbC5vcmc7IGthZmFpQGZiLmNvbTsgc29uZ2xpdWJyYXZpbmdA
ZmIuY29tOyB5aHNAZmIuY29tOyBrcHNpbmdoQGtlcm5lbC5vcmcNCuaKhOmAgTogd2VpeW9uZ2p1
biAoQSkgPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+OyBzaGFvemhlbmdjaGFvIDxzaGFvemhlbmdj
aGFvQGh1YXdlaS5jb20+OyB5dWVoYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQrkuLvp
opg6IFtQQVRDSCB2MyxicGYtbmV4dF0gc2FtcGxlcy9icGY6IGNoZWNrIGRldGFjaCBwcm9nIGV4
aXN0IG9yIG5vdCBpbiB4ZHBfZndkDQoNCkJlZm9yZSBkZXRhY2ggdGhlIHByb2csIHdlIHNob3Vs
ZCBjaGVjayBkZXRhY2ggcHJvZyBleGlzdCBvciBub3QuDQoNClNpZ25lZC1vZmYtYnk6IFpoZW5n
Y2hhbyBTaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdlaS5jb20+DQotLS0NCiBzYW1wbGVzL2JwZi94
ZHBfZndkX3VzZXIuYyB8IDU5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
DQogMSBmaWxlIGNoYW5nZWQsIDUwIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9zYW1wbGVzL2JwZi94ZHBfZndkX3VzZXIuYyBiL3NhbXBsZXMvYnBmL3hkcF9m
d2RfdXNlci5jIGluZGV4IDE4Mjg0ODdiYWU5YS4uMDNhNTBmNjRlOTlhIDEwMDY0NA0KLS0tIGEv
c2FtcGxlcy9icGYveGRwX2Z3ZF91c2VyLmMNCisrKyBiL3NhbXBsZXMvYnBmL3hkcF9md2RfdXNl
ci5jDQpAQCAtNDcsMTcgKzQ3LDU4IEBAIHN0YXRpYyBpbnQgZG9fYXR0YWNoKGludCBpZHgsIGlu
dCBwcm9nX2ZkLCBpbnQgbWFwX2ZkLCBjb25zdCBjaGFyICpuYW1lKQ0KIAlyZXR1cm4gZXJyOw0K
IH0NCiANCi1zdGF0aWMgaW50IGRvX2RldGFjaChpbnQgaWR4LCBjb25zdCBjaGFyICpuYW1lKQ0K
K3N0YXRpYyBpbnQgZG9fZGV0YWNoKGludCBpZmluZGV4LCBjb25zdCBjaGFyICppZm5hbWUsIGNv
bnN0IGNoYXIgDQorKmFwcF9uYW1lKQ0KIHsNCi0JaW50IGVycjsNCisJTElCQlBGX09QVFMoYnBm
X3hkcF9hdHRhY2hfb3B0cywgb3B0cyk7DQorCXN0cnVjdCBicGZfcHJvZ19pbmZvIHByb2dfaW5m
byA9IHt9Ow0KKwljaGFyIHByb2dfbmFtZVtCUEZfT0JKX05BTUVfTEVOXTsNCisJX191MzIgaW5m
b19sZW4sIGN1cnJfcHJvZ19pZDsNCisJaW50IHByb2dfZmQ7DQorCWludCBlcnIgPSAxOw0KKw0K
KwlpZiAoYnBmX3hkcF9xdWVyeV9pZChpZmluZGV4LCB4ZHBfZmxhZ3MsICZjdXJyX3Byb2dfaWQp
KSB7DQorCQlwcmludGYoIkVSUk9SOiBicGZfeGRwX3F1ZXJ5X2lkIGZhaWxlZCAoJXMpXG4iLA0K
KwkJICAgICAgIHN0cmVycm9yKGVycm5vKSk7DQorCQlyZXR1cm4gZXJyOw0KKwl9DQorDQorCWlm
ICghY3Vycl9wcm9nX2lkKSB7DQorCQlwcmludGYoIkVSUk9SOiBmbGFncygweCV4KSB4ZHAgcHJv
ZyBpcyBub3QgYXR0YWNoZWQgdG8gJXNcbiIsDQorCQkgICAgICAgeGRwX2ZsYWdzLCBpZm5hbWUp
Ow0KKwkJcmV0dXJuIGVycjsNCisJfQ0KIA0KLQllcnIgPSBicGZfeGRwX2RldGFjaChpZHgsIHhk
cF9mbGFncywgTlVMTCk7DQotCWlmIChlcnIgPCAwKQ0KLQkJcHJpbnRmKCJFUlJPUjogZmFpbGVk
IHRvIGRldGFjaCBwcm9ncmFtIGZyb20gJXNcbiIsIG5hbWUpOw0KKwlpbmZvX2xlbiA9IHNpemVv
Zihwcm9nX2luZm8pOw0KKwlwcm9nX2ZkID0gYnBmX3Byb2dfZ2V0X2ZkX2J5X2lkKGN1cnJfcHJv
Z19pZCk7DQorCWlmIChwcm9nX2ZkIDwgMCkgew0KKwkJcHJpbnRmKCJFUlJPUjogYnBmX3Byb2df
Z2V0X2ZkX2J5X2lkIGZhaWxlZCAoJXMpXG4iLA0KKwkJICAgICAgIHN0cmVycm9yKGVycm5vKSk7
DQorCQlyZXR1cm4gZXJyOw0KKwl9DQorDQorCWVyciA9IGJwZl9vYmpfZ2V0X2luZm9fYnlfZmQo
cHJvZ19mZCwgJnByb2dfaW5mbywgJmluZm9fbGVuKTsNCisJaWYgKGVycikgew0KKwkJcHJpbnRm
KCJFUlJPUjogYnBmX29ial9nZXRfaW5mb19ieV9mZCBmYWlsZWQgKCVzKVxuIiwNCisJCSAgICAg
ICBzdHJlcnJvcihlcnJubykpOw0KKwkJcmV0dXJuIGVycjsNCisJfQ0KKwlzbnByaW50Zihwcm9n
X25hbWUsIHNpemVvZihwcm9nX25hbWUpLCAiJXNfcHJvZyIsIGFwcF9uYW1lKTsNCisJcHJvZ19u
YW1lW0JQRl9PQkpfTkFNRV9MRU4gLSAxXSA9ICdcMCc7DQorDQorCWlmIChzdHJjbXAocHJvZ19p
bmZvLm5hbWUsIHByb2dfbmFtZSkpIHsNCisJCXByaW50ZigiRVJST1I6ICVzIGlzbid0IGF0dGFj
aGVkIHRvICVzXG4iLCBhcHBfbmFtZSwgaWZuYW1lKTsNCisJCWVyciA9IDE7DQorCX0gZWxzZSB7
DQorCQlvcHRzLm9sZF9wcm9nX2ZkID0gcHJvZ19mZDsNCisJCWVyciA9IGJwZl94ZHBfZGV0YWNo
KGlmaW5kZXgsIHhkcF9mbGFncywgJm9wdHMpOw0KKwkJaWYgKGVyciA8IDApDQorCQkJcHJpbnRm
KCJFUlJPUjogZmFpbGVkIHRvIGRldGFjaCBwcm9ncmFtIGZyb20gJXMgKCVzKVxuIiwNCisJCQkg
ICAgICAgaWZuYW1lLCBzdHJlcnJvcihlcnJubykpOw0KKwkJLyogVE9ETzogUmVtZW1iZXIgdG8g
Y2xlYW51cCBtYXAsIHdoZW4gYWRkaW5nIHVzZSBvZiBzaGFyZWQgbWFwDQorCQkgKiAgYnBmX21h
cF9kZWxldGVfZWxlbSgobWFwX2ZkLCAmaWR4KTsNCisJCSAqLw0KKwl9DQogDQotCS8qIFRPRE86
IFJlbWVtYmVyIHRvIGNsZWFudXAgbWFwLCB3aGVuIGFkZGluZyB1c2Ugb2Ygc2hhcmVkIG1hcA0K
LQkgKiAgYnBmX21hcF9kZWxldGVfZWxlbSgobWFwX2ZkLCAmaWR4KTsNCi0JICovDQogCXJldHVy
biBlcnI7DQogfQ0KIA0KQEAgLTE2OSw3ICsyMTAsNyBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hh
ciAqKmFyZ3YpDQogCQkJcmV0dXJuIDE7DQogCQl9DQogCQlpZiAoIWF0dGFjaCkgew0KLQkJCWVy
ciA9IGRvX2RldGFjaChpZHgsIGFyZ3ZbaV0pOw0KKwkJCWVyciA9IGRvX2RldGFjaChpZHgsIGFy
Z3ZbaV0sIHByb2dfbmFtZSk7DQogCQkJaWYgKGVycikNCiAJCQkJcmV0ID0gZXJyOw0KIAkJfSBl
bHNlIHsNCi0tDQoyLjE3LjENCg0KDQpIaSBUb2tlLA0KRG8geW91IGhhdmUgYW55IG1vcmUgZmVl
ZGJhY2s/IERvZXMgaXQgbG9vayBiZXR0ZXIgdG8geW91IG5vdz8NCg==
