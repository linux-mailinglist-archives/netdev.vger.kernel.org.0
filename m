Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306AB50B26E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445379AbiDVICP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349087AbiDVICK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:02:10 -0400
Received: from m1541.mail.126.com (m1541.mail.126.com [220.181.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84C62522DB;
        Fri, 22 Apr 2022 00:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=KOOwj
        Ngxtpj+BOV9RiocwkEJ5gaHVgyNXKB2q9i864s=; b=I2bcLGGMBZdE8yJCQe73E
        ublKXrfowHicATx4CEeGLTb6eCcoRMxL5WoQOTv2+7QZxwlqAzF4e/JPdbJi3Hv0
        A8AVgXuuhLURpEiqwFDsWBb4y1DE5YvfB6w7f1mKr1sC1ZbZ4TWP3y/hEY3dxCYf
        tslRTLpgh+V2PhvjmdSg5c=
Received: from zhaojunkui2008$126.com ( [58.213.83.157] ) by
 ajax-webmail-wmsvr41 (Coremail) ; Fri, 22 Apr 2022 15:58:26 +0800 (CST)
X-Originating-IP: [58.213.83.157]
Date:   Fri, 22 Apr 2022 15:58:26 +0800 (CST)
From:   z <zhaojunkui2008@126.com>
To:     "Kalle Valo" <kvalo@kernel.org>
Cc:     "Jakub Kicinski" <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re:Re: [PATCH] mediatek/mt7601u: add debugfs exit function
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210622(1d4788a8)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <87k0bhmuh6.fsf@kernel.org>
References: <20220422070325.465918-1-zhaojunkui2008@126.com>
 <87k0bhmuh6.fsf@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <6fd91edd.4c2b.1805047850c.Coremail.zhaojunkui2008@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: KcqowADn9t4jYGJiD_oRAA--.42888W
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiuQPqqlpD8lH33AAAsr
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgS2FsbGUgVmFsbzoKCkF0IDIwMjItMDQtMjIgMTU6NDU6NTcsICJLYWxsZSBWYWxvIiA8a3Zh
bG9Aa2VybmVsLm9yZz4gd3JvdGU6Cj5CZXJuYXJkIFpoYW8gPHpoYW9qdW5rdWkyMDA4QDEyNi5j
b20+IHdyaXRlczoKPgo+PiBXaGVuIG10NzYwMXUgbG9hZGVkLCB0aGVyZSBhcmUgdHdvIGNhc2Vz
Ogo+PiBGaXJzdCB3aGVuIG10NzYwMXUgaXMgbG9hZGVkLCBpbiBmdW5jdGlvbiBtdDc2MDF1X3By
b2JlLCBpZgo+PiBmdW5jdGlvbiBtdDc2MDF1X3Byb2JlIHJ1biBpbnRvIGVycm9yIGxhYmxlIGVy
cl9odywKPj4gbXQ3NjAxdV9jbGVhbnVwIGRpZG5gdCBjbGVhbnVwIHRoZSBkZWJ1Z2ZzIG5vZGUu
Cj4+IFNlY29uZCB3aGVuIHRoZSBtb2R1bGUgZGlzY29ubmVjdCwgaW4gZnVuY3Rpb24gbXQ3NjAx
dV9kaXNjb25uZWN0LAo+PiBtdDc2MDF1X2NsZWFudXAgZGlkbmB0IGNsZWFudXAgdGhlIGRlYnVn
ZnMgbm9kZS4KPj4gVGhpcyBwYXRjaCBhZGQgZGVidWdmcyBleGl0IGZ1bmN0aW9uIGFuZCB0cnkg
dG8gY2xlYW51cCBkZWJ1Z2ZzCj4+IG5vZGUgd2hlbiBtdDc2MDF1IGxvYWRlZCBmYWlsIG9yIHVu
bG9hZGVkLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBCZXJuYXJkIFpoYW8gPHpoYW9qdW5rdWkyMDA4
QDEyNi5jb20+Cj4+IC0tLQo+PiAgLi4uL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L2Rl
YnVnZnMuYyAgIHwgMjUgKysrKysrKysrKystLS0tLS0tLQo+PiAgZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWVkaWF0ZWsvbXQ3NjAxdS9pbml0LmMgIHwgIDUgKysrKwo+PiAgLi4uL25ldC93aXJlbGVz
cy9tZWRpYXRlay9tdDc2MDF1L210NzYwMXUuaCAgIHwgIDQgKysrCj4+ICAzIGZpbGVzIGNoYW5n
ZWQsIDI0IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9kZWJ1Z2ZzLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L2RlYnVnZnMuYwo+PiBpbmRleCAyMDY2OWVh
Y2I2NmUuLjFhZTNkNzVkM2M5YiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWVkaWF0ZWsvbXQ3NjAxdS9kZWJ1Z2ZzLmMKPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWVkaWF0ZWsvbXQ3NjAxdS9kZWJ1Z2ZzLmMKPj4gQEAgLTEyNCwxNyArMTI0LDIyIEBAIERFRklO
RV9TSE9XX0FUVFJJQlVURShtdDc2MDF1X2VlcHJvbV9wYXJhbSk7Cj4+ICAKPj4gIHZvaWQgbXQ3
NjAxdV9pbml0X2RlYnVnZnMoc3RydWN0IG10NzYwMXVfZGV2ICpkZXYpCj4+ICB7Cj4+IC0Jc3Ry
dWN0IGRlbnRyeSAqZGlyOwo+PiAtCj4+IC0JZGlyID0gZGVidWdmc19jcmVhdGVfZGlyKCJtdDc2
MDF1IiwgZGV2LT5ody0+d2lwaHktPmRlYnVnZnNkaXIpOwo+PiAtCWlmICghZGlyKQo+PiArCWRl
di0+cm9vdF9kaXIgPSBkZWJ1Z2ZzX2NyZWF0ZV9kaXIoIm10NzYwMXUiLCBkZXYtPmh3LT53aXBo
eS0+ZGVidWdmc2Rpcik7Cj4+ICsJaWYgKCFkZXYtPnJvb3RfZGlyKQo+PiAgCQlyZXR1cm47Cj4+
ICAKPj4gLQlkZWJ1Z2ZzX2NyZWF0ZV91OCgidGVtcGVyYXR1cmUiLCAwNDAwLCBkaXIsICZkZXYt
PnJhd190ZW1wKTsKPj4gLQlkZWJ1Z2ZzX2NyZWF0ZV91MzIoInRlbXBfbW9kZSIsIDA0MDAsIGRp
ciwgJmRldi0+dGVtcF9tb2RlKTsKPj4gKwlkZWJ1Z2ZzX2NyZWF0ZV91OCgidGVtcGVyYXR1cmUi
LCAwNDAwLCBkZXYtPnJvb3RfZGlyLCAmZGV2LT5yYXdfdGVtcCk7Cj4+ICsJZGVidWdmc19jcmVh
dGVfdTMyKCJ0ZW1wX21vZGUiLCAwNDAwLCBkZXYtPnJvb3RfZGlyLCAmZGV2LT50ZW1wX21vZGUp
Owo+PiArCj4+ICsJZGVidWdmc19jcmVhdGVfdTMyKCJyZWdpZHgiLCAwNjAwLCBkZXYtPnJvb3Rf
ZGlyLCAmZGV2LT5kZWJ1Z2ZzX3JlZyk7Cj4+ICsJZGVidWdmc19jcmVhdGVfZmlsZSgicmVndmFs
IiwgMDYwMCwgZGV2LT5yb290X2RpciwgZGV2LCAmZm9wc19yZWd2YWwpOwo+PiArCWRlYnVnZnNf
Y3JlYXRlX2ZpbGUoImFtcGR1X3N0YXQiLCAwNDAwLCBkZXYtPnJvb3RfZGlyLCBkZXYsICZtdDc2
MDF1X2FtcGR1X3N0YXRfZm9wcyk7Cj4+ICsJZGVidWdmc19jcmVhdGVfZmlsZSgiZWVwcm9tX3Bh
cmFtIiwgMDQwMCwgZGV2LT5yb290X2RpciwgZGV2LCAmbXQ3NjAxdV9lZXByb21fcGFyYW1fZm9w
cyk7Cj4+ICt9Cj4+ICAKPj4gLQlkZWJ1Z2ZzX2NyZWF0ZV91MzIoInJlZ2lkeCIsIDA2MDAsIGRp
ciwgJmRldi0+ZGVidWdmc19yZWcpOwo+PiAtCWRlYnVnZnNfY3JlYXRlX2ZpbGUoInJlZ3ZhbCIs
IDA2MDAsIGRpciwgZGV2LCAmZm9wc19yZWd2YWwpOwo+PiAtCWRlYnVnZnNfY3JlYXRlX2ZpbGUo
ImFtcGR1X3N0YXQiLCAwNDAwLCBkaXIsIGRldiwgJm10NzYwMXVfYW1wZHVfc3RhdF9mb3BzKTsK
Pj4gLQlkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJlZXByb21fcGFyYW0iLCAwNDAwLCBkaXIsIGRldiwg
Jm10NzYwMXVfZWVwcm9tX3BhcmFtX2ZvcHMpOwo+PiArdm9pZCBtdDc2MDF1X2V4aXRfZGVidWdm
cyhzdHJ1Y3QgbXQ3NjAxdV9kZXYgKmRldikKPj4gK3sKPj4gKwlpZiAoIWRldi0+cm9vdF9kaXIp
Cj4+ICsJCXJldHVybjsKPj4gKwlkZWJ1Z2ZzX3JlbW92ZShkZXYtPnJvb3RfZGlyKTsKPgo+ZGVi
dWdmc19yZW1vdmUoKSBoYXMgSVNfRVJSX09SX05VTEwoKSBjaGVjaywgc28gbm8gbmVlZCB0byBj
aGVjayBmb3IKPm51bGwgaGVyZS4KR290IGl0LCB0aGFua3MhCgo+PiAgfQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3NjAxdS9pbml0LmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2MDF1L2luaXQuYwo+PiBpbmRleCA1ZDllOTUyYjI5
NjYuLjFlOTA1ZWYyZWQxOSAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVk
aWF0ZWsvbXQ3NjAxdS9pbml0LmMKPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0
ZWsvbXQ3NjAxdS9pbml0LmMKPj4gQEAgLTQyNyw2ICs0MjcsOSBAQCB2b2lkIG10NzYwMXVfY2xl
YW51cChzdHJ1Y3QgbXQ3NjAxdV9kZXYgKmRldikKPj4gIAltdDc2MDF1X3N0b3BfaGFyZHdhcmUo
ZGV2KTsKPj4gIAltdDc2MDF1X2RtYV9jbGVhbnVwKGRldik7Cj4+ICAJbXQ3NjAxdV9tY3VfY21k
X2RlaW5pdChkZXYpOwo+PiArI2lmZGVmIENPTkZJR19ERUJVR19GUwo+PiArCW10NzYwMXVfZXhp
dF9kZWJ1Z2ZzKGRldik7Cj4+ICsjZW5kaWYKPj4gIH0KPj4gIAo+PiAgc3RydWN0IG10NzYwMXVf
ZGV2ICptdDc2MDF1X2FsbG9jX2RldmljZShzdHJ1Y3QgZGV2aWNlICpwZGV2KQo+PiBAQCAtNjI1
LDcgKzYyOCw5IEBAIGludCBtdDc2MDF1X3JlZ2lzdGVyX2RldmljZShzdHJ1Y3QgbXQ3NjAxdV9k
ZXYgKmRldikKPj4gIAlpZiAocmV0KQo+PiAgCQlyZXR1cm4gcmV0Owo+PiAgCj4+ICsjaWZkZWYg
Q09ORklHX0RFQlVHX0ZTCj4+ICAJbXQ3NjAxdV9pbml0X2RlYnVnZnMoZGV2KTsKPj4gKyNlbmRp
Zgo+Cj5BcmUgdGhlc2UgdHdvIGlmZGVmcyByZWFsbHkgbmVlZGVkPyBkZWJ1Z2ZzIGZ1bmN0aW9u
cyBhcmUgZW1wdHkKPmZ1bmN0aW9ucyB3aGVuIENPTkZJR19ERUJVR19GUyBpcyBkaXNhYmxlZC4K
SWZkZWYgZG9lc24ndCBzZWVtIHRvIG1ha2UgbXVjaCBzZW5zZSwgdGhhbmtzIGZvciB5b3VyIGFk
dmljZSEKCj4+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYwMXUvbXQ3
NjAxdS5oCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYwMXUvbXQ3
NjAxdS5oCj4+IEBAIC0yNDIsNiArMjQyLDkgQEAgc3RydWN0IG10NzYwMXVfZGV2IHsKPj4gIAl1
MzIgcmZfcGFfbW9kZVsyXTsKPj4gIAo+PiAgCXN0cnVjdCBtYWNfc3RhdHMgc3RhdHM7Cj4+ICsj
aWZkZWYgQ09ORklHX0RFQlVHX0ZTCj4+ICsJc3RydWN0IGRlbnRyeSAqcm9vdF9kaXI7Cj4+ICsj
ZW5kaWYKPgo+SSB3b3VsZCByZW1vdmUgdGhpcyBpZmRlZiwgaXQncyBqdXN0IHNhdmluZyBvbmUg
cG9pbnRlciBzaXplLiBMZXNzCj5pZmRlZnMgd2UgaGF2ZSB0aGUgYmV0dGVyLgpJIHdvdWxkIG1v
ZGlmeSB0aGUgY29kZSBhbmQgcmVzdWJtaXQgYSBwYXRjaCwgdGhhbmsgeW91IHZlcnkgbXVjaCEK
CkJSLy9CZXJuYXJkCj4tLSAKPmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9s
aW51eC13aXJlbGVzcy9saXN0Lwo+Cj5odHRwczovL3dpcmVsZXNzLndpa2kua2VybmVsLm9yZy9l
bi9kZXZlbG9wZXJzL2RvY3VtZW50YXRpb24vc3VibWl0dGluZ3BhdGNoZXMK
