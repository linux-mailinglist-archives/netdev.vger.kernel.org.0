Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6138441DC72
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350815AbhI3Okn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:40:43 -0400
Received: from m1514.mail.126.com ([220.181.15.14]:18568 "EHLO
        m1514.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349727AbhI3Okm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:40:42 -0400
X-Greylist: delayed 1820 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2021 10:40:40 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=NG7/U
        AGLuSe/tXOsjmZbo9Y4ZM6Q1xhVVV+cAOM5S24=; b=C1vRtMBxFxl3XJU818qUm
        W1ummkGbk8Kd9fn8SrV5/6sp5Vofccrsklt2UTwDARqLPNrx2JIBqjojE8whCu6t
        BMVug2uFUUgdARfwJ552DAReQFrsNn3wPv+E9cAIS1PMwnwEvir9UQWadMrgZBhV
        NG68SsMMq46RFAIacDI6TY=
Received: from kernelpatch$126.com ( [113.200.148.30] ) by
 ajax-webmail-wmsvr14 (Coremail) ; Thu, 30 Sep 2021 22:07:56 +0800 (CST)
X-Originating-IP: [113.200.148.30]
Date:   Thu, 30 Sep 2021 22:07:56 +0800 (CST)
From:   "Tiezhu Yang" <kernelpatch@126.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        johan.almbladh@anyfinetworks.com, lixuefeng@loongson.cn,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2] test_bpf: add module parameter test_type
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2021 www.mailtech.cn 126com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <2af1fd4d.566a.17c3708821e.Coremail.kernelpatch@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: DsqowABX_ui9xFVh7Y6LAQ--.55499W
X-CM-SenderInfo: xnhu0vxosd3ubk6rjloofrz/1tbi6B0e9VpEFIIdpAAAsv
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGllemh1IFlhbmcgPHlhbmd0aWV6aHVAbG9vbmdzb24uY24+CgpBZnRlciBjb21taXQg
OTI5OGU2M2VhZmVhICgiYnBmL3Rlc3RzOiBBZGQgZXhoYXVzdGl2ZSB0ZXN0cyBvZiBBTFUKb3Bl
cmFuZCBtYWduaXR1ZGVzIiksIHdoZW4gbW9kcHJvYmUgdGVzdF9icGYua28gd2l0aCBqaXQgb24g
bWlwczY0LAp0aGVyZSBleGlzdHMgc2VnbWVudCBmYXVsdCBkdWUgdG8gdGhlIGZvbGxvd2luZyBy
ZWFzb246Cgp0ZXN0X2JwZjogIzYxNiBBTFU2NF9NT1ZfWDogYWxsIHJlZ2lzdGVyIHZhbHVlIG1h
Z25pdHVkZXMgaml0ZWQ6MQpCcmVhayBpbnN0cnVjdGlvbiBpbiBrZXJuZWwgY29kZVsjMV0KCkl0
IHNlZW1zIHRoYXQgdGhlIHJlbGF0ZWQgaml0IGltcGxlbWVudGF0aW9ucyBvZiBzb21lIHRlc3Qg
Y2FzZXMKaW4gdGVzdF9icGYoKSBoYXZlIHByb2JsZW1zLiBBdCB0aGlzIG1vbWVudCwgSSBkbyBu
b3QgY2FyZSBhYm91dAp0aGUgc2VnbWVudCBmYXVsdCB3aGlsZSBJIGp1c3Qgd2FudCB0byB2ZXJp
ZnkgdGhlIHRlc3QgY2FzZXMgb2YKdGFpbCBjYWxscy4KCkJhc2VkIG9uIHRoZSBhYm92ZSBiYWNr
Z3JvdW5kIGFuZCBtb3RpdmF0aW9uLCBhZGQgdGhlIGZvbGxvd2luZwptb2R1bGUgcGFyYW1ldGVy
IHRlc3RfdHlwZSB0byB0aGUgdGVzdF9icGYua286CnRlc3RfdHlwZT08c3RyaW5nPjogb25seSB0
aGUgc3BlY2lmaWVkIHR5cGUgd2lsbCBiZSBydW4sIHRoZSBzdHJpbmcKY2FuIGJlICJ0ZXN0X2Jw
ZiIsICJ0ZXN0X3RhaWxfY2FsbHMiIG9yICJ0ZXN0X3NrYl9zZWdtZW50Ii4KClRoaXMgaXMgdXNl
ZnVsIHRvIG9ubHkgdGVzdCB0aGUgY29ycmVzcG9uZGluZyB0ZXN0IHR5cGUgd2hlbiBzcGVjaWZ5
CnRoZSB2YWxpZCB0ZXN0X3R5cGUgc3RyaW5nLgoKQW55IGludmFsaWQgdGVzdCB0eXBlIHdpbGwg
cmVzdWx0IGluIC1FSU5WQUwgYmVpbmcgcmV0dXJuZWQgYW5kIG5vCnRlc3RzIGJlaW5nIHJ1bi4g
SWYgdGhlIHRlc3RfdHlwZSBpcyBub3Qgc3BlY2lmaWVkIG9yIHNwZWNpZmllZCBhcwplbXB0eSBz
dHJpbmcsIGl0IGRvZXMgbm90IGNoYW5nZSB0aGUgY3VycmVudCBsb2dpYywgYWxsIG9mIHRoZSB0
ZXN0CmNhc2VzIHdpbGwgYmUgcnVuLgoKU2lnbmVkLW9mZi1ieTogVGllemh1IFlhbmcgPHlhbmd0
aWV6aHVAbG9vbmdzb24uY24+Ci0tLQoKdjI6CiAgLS0gRml4IHR5cG8gaW4gdGhlIGNvbW1pdCBt
ZXNzYWdlCiAgLS0gVXNlIG15IHByaXZhdGUgZW1haWwgdG8gc2VuZAoKIGxpYi90ZXN0X2JwZi5j
IHwgNDggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvbGliL3Rlc3RfYnBmLmMgYi9saWIvdGVzdF9icGYuYwppbmRleCAyMWVhMWFiLi45NDI4
ZmVjIDEwMDY0NAotLS0gYS9saWIvdGVzdF9icGYuYworKysgYi9saWIvdGVzdF9icGYuYwpAQCAt
MTE4NjYsNiArMTE4NjYsOSBAQCBtb2R1bGVfcGFyYW0odGVzdF9pZCwgaW50LCAwKTsKIHN0YXRp
YyBpbnQgdGVzdF9yYW5nZVsyXSA9IHsgMCwgQVJSQVlfU0laRSh0ZXN0cykgLSAxIH07CiBtb2R1
bGVfcGFyYW1fYXJyYXkodGVzdF9yYW5nZSwgaW50LCBOVUxMLCAwKTsKIAorc3RhdGljIGNoYXIg
dGVzdF90eXBlWzMyXTsKK21vZHVsZV9wYXJhbV9zdHJpbmcodGVzdF90eXBlLCB0ZXN0X3R5cGUs
IHNpemVvZih0ZXN0X3R5cGUpLCAwKTsKKwogc3RhdGljIF9faW5pdCBpbnQgZmluZF90ZXN0X2lu
ZGV4KGNvbnN0IGNoYXIgKnRlc3RfbmFtZSkKIHsKIAlpbnQgaTsKQEAgLTEyNTE4LDI0ICsxMjUy
MSwzOSBAQCBzdGF0aWMgaW50IF9faW5pdCB0ZXN0X2JwZl9pbml0KHZvaWQpCiAJc3RydWN0IGJw
Zl9hcnJheSAqcHJvZ3MgPSBOVUxMOwogCWludCByZXQ7CiAKLQlyZXQgPSBwcmVwYXJlX2JwZl90
ZXN0cygpOwotCWlmIChyZXQgPCAwKQotCQlyZXR1cm4gcmV0OworCWlmIChzdHJsZW4odGVzdF90
eXBlKSAmJgorCSAgICBzdHJjbXAodGVzdF90eXBlLCAidGVzdF9icGYiKSAmJgorCSAgICBzdHJj
bXAodGVzdF90eXBlLCAidGVzdF90YWlsX2NhbGxzIikgJiYKKwkgICAgc3RyY21wKHRlc3RfdHlw
ZSwgInRlc3Rfc2tiX3NlZ21lbnQiKSkgeworCQlwcl9lcnIoInRlc3RfYnBmOiBpbnZhbGlkIHRl
c3RfdHlwZSAnJXMnIHNwZWNpZmllZC5cbiIsIHRlc3RfdHlwZSk7CisJCXJldHVybiAtRUlOVkFM
OworCX0KKworCWlmICghc3RybGVuKHRlc3RfdHlwZSkgfHwgIXN0cmNtcCh0ZXN0X3R5cGUsICJ0
ZXN0X2JwZiIpKSB7CisJCXJldCA9IHByZXBhcmVfYnBmX3Rlc3RzKCk7CisJCWlmIChyZXQgPCAw
KQorCQkJcmV0dXJuIHJldDsKKworCQlyZXQgPSB0ZXN0X2JwZigpOworCQlkZXN0cm95X2JwZl90
ZXN0cygpOworCQlpZiAocmV0KQorCQkJcmV0dXJuIHJldDsKKwl9CiAKLQlyZXQgPSB0ZXN0X2Jw
ZigpOwotCWRlc3Ryb3lfYnBmX3Rlc3RzKCk7Ci0JaWYgKHJldCkKLQkJcmV0dXJuIHJldDsKKwlp
ZiAoIXN0cmxlbih0ZXN0X3R5cGUpIHx8ICFzdHJjbXAodGVzdF90eXBlLCAidGVzdF90YWlsX2Nh
bGxzIikpIHsKKwkJcmV0ID0gcHJlcGFyZV90YWlsX2NhbGxfdGVzdHMoJnByb2dzKTsKKwkJaWYg
KHJldCkKKwkJCXJldHVybiByZXQ7CisJCXJldCA9IHRlc3RfdGFpbF9jYWxscyhwcm9ncyk7CisJ
CWRlc3Ryb3lfdGFpbF9jYWxsX3Rlc3RzKHByb2dzKTsKKwkJaWYgKHJldCkKKwkJCXJldHVybiBy
ZXQ7CisJfQogCi0JcmV0ID0gcHJlcGFyZV90YWlsX2NhbGxfdGVzdHMoJnByb2dzKTsKLQlpZiAo
cmV0KQotCQlyZXR1cm4gcmV0OwotCXJldCA9IHRlc3RfdGFpbF9jYWxscyhwcm9ncyk7Ci0JZGVz
dHJveV90YWlsX2NhbGxfdGVzdHMocHJvZ3MpOwotCWlmIChyZXQpCi0JCXJldHVybiByZXQ7CisJ
aWYgKCFzdHJsZW4odGVzdF90eXBlKSB8fCAhc3RyY21wKHRlc3RfdHlwZSwgInRlc3Rfc2tiX3Nl
Z21lbnQiKSkKKwkJcmV0dXJuIHRlc3Rfc2tiX3NlZ21lbnQoKTsKIAotCXJldHVybiB0ZXN0X3Nr
Yl9zZWdtZW50KCk7CisJcmV0dXJuIDA7CiB9CiAKIHN0YXRpYyB2b2lkIF9fZXhpdCB0ZXN0X2Jw
Zl9leGl0KHZvaWQpCi0tIAoyLjEuMA==
