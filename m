Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FE546505E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbhLAOwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:52:04 -0500
Received: from w4.tutanota.de ([81.3.6.165]:58692 "EHLO w4.tutanota.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhLAOwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 09:52:00 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2021 09:51:58 EST
Received: from w3.tutanota.de (unknown [192.168.1.164])
        by w4.tutanota.de (Postfix) with ESMTP id 0D0881060391;
        Wed,  1 Dec 2021 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1638369548;
        s=s1; d=tuta.io;
        h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
        bh=saLGlVSL4WbeU5QgS57F+QIGU1jTliY0Iykn4jzGXTQ=;
        b=J92rg+uQpiL9UpbVsGK8qAO8TxtkSPRcZ87A5MuCTnncOIGbySGVgSQsV85CBptB
        uCqS43FRehGluROI1iWBJP7gxn9WFu+t4UdMy7ED2R2c8w6mwrY2M8fMoL2dckPhZwQ
        4HGKF6XkxAUAPVu0xLSRvf+pPtYCzFtmWllPtevwMwSYZupIo3sOZ816KxVJsthL1c/
        rTImwtJwbXT3+9Wvxbv10jiqOtOHhFMiOfRUXF1Akpy189rofxZKFpa7eAFLO8S8XZP
        Ey5BSMZL3roHaxh73LzGK823J6+M/3GWWmxEIjoFHyqBZa3BEf9usGF2wX6yuh8QVsI
        KaltbEouww==
Date:   Wed, 1 Dec 2021 15:39:08 +0100 (CET)
From:   Adam Kandur <rndd@tuta.io>
To:     netdev@vger.kernel.org
Cc:     linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Message-ID: <MpqQpIa--F-2@tuta.io>
Subject: [PATCH] QLGE: qlge_main: Fix style
MIME-Version: 1.0
Content-Type: multipart/mixed; 
        boundary="----=_Part_341183_1571019938.1638369549034"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

------=_Part_341183_1571019938.1638369549034
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit




------=_Part_341183_1571019938.1638369549034
Content-Type: application/octet-stream; 
	name=0001-QLGE-qlge_main-Fix-style.patch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; 
	filename=0001-QLGE-qlge_main-Fix-style.patch

RnJvbSA0MTI2NmE3MmFlMmFkOGZiNDVlOTZlNDU1YzUxOTE3N2JmZDIzYmMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBZGFtIEthbmR1ciA8cm5kZEB0dXRhLmlvPgpEYXRlOiBXZWQs
IDEgRGVjIDIwMjEgMTc6MzI6MTEgKzAzMDAKU3ViamVjdDogW1BBVENIXSBRTEdFOiBxbGdlX21h
aW46IEZpeCBzdHlsZQoKLS0tCiBkcml2ZXJzL3N0YWdpbmcvcWxnZS9xbGdlX21haW4uYyB8IDI4
ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRp
b25zKCspLCAxNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvcWxn
ZS9xbGdlX21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy9xbGdlL3FsZ2VfbWFpbi5jCmluZGV4IDk4
NzNiYjJhOS4uYzg2ZTJhOTM2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvcWxnZS9xbGdl
X21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvcWxnZS9xbGdlX21haW4uYwpAQCAtMTIwMCwx
MSArMTIwMCwxMSBAQCBzdGF0aWMgdm9pZCBxbGdlX3VubWFwX3NlbmQoc3RydWN0IHFsZ2VfYWRh
cHRlciAqcWRldiwKIAkJCSAqIGVsZW1lbnQgYW5kIHRoZXJlIGlzIG1vcmUgdGhhbiA2IGZyYWdz
LAogCQkJICogdGhlbiBpdHMgYW4gT0FMLgogCQkJICovCi0JCQlpZiAoaSA9PSA3KSB7CisJCQlp
ZiAoaSA9PSA3KQogCQkJCW5ldGlmX3ByaW50ayhxZGV2LCB0eF9kb25lLCBLRVJOX0RFQlVHLAog
CQkJCQkgICAgIHFkZXYtPm5kZXYsCiAJCQkJCSAgICAgInVubWFwcGluZyBPQUwgYXJlYS5cbiIp
OwotCQkJfQorCiAJCQlkbWFfdW5tYXBfc2luZ2xlKCZxZGV2LT5wZGV2LT5kZXYsCiAJCQkJCSBk
bWFfdW5tYXBfYWRkcigmdHhfcmluZ19kZXNjLT5tYXBbaV0sCiAJCQkJCQkJbWFwYWRkciksCkBA
IC0xMjM2LDEwICsxMjM2LDEwIEBAIHN0YXRpYyBpbnQgcWxnZV9tYXBfc2VuZChzdHJ1Y3QgcWxn
ZV9hZGFwdGVyICpxZGV2LAogCXN0cnVjdCB0eF9idWZfZGVzYyAqdGJkID0gbWFjX2lvY2JfcHRy
LT50YmQ7CiAJaW50IGZyYWdfY250ID0gc2tiX3NoaW5mbyhza2IpLT5ucl9mcmFnczsKIAotCWlm
IChmcmFnX2NudCkgeworCWlmIChmcmFnX2NudCkKIAkJbmV0aWZfcHJpbnRrKHFkZXYsIHR4X3F1
ZXVlZCwgS0VSTl9ERUJVRywgcWRldi0+bmRldiwKIAkJCSAgICAgImZyYWdfY250ID0gJWQuXG4i
LCBmcmFnX2NudCk7Ci0JfQorCiAJLyoKIAkgKiBNYXAgdGhlIHNrYiBidWZmZXIgZmlyc3QuCiAJ
ICovCkBAIC0zMzUxLDEyICszMzUxLDExIEBAIHN0YXRpYyB2b2lkIHFsZ2VfZnJlZV9pcnEoc3Ry
dWN0IHFsZ2VfYWRhcHRlciAqcWRldikKIAogCWZvciAoaSA9IDA7IGkgPCBxZGV2LT5pbnRyX2Nv
dW50OyBpKyssIGludHJfY29udGV4dCsrKSB7CiAJCWlmIChpbnRyX2NvbnRleHQtPmhvb2tlZCkg
ewotCQkJaWYgKHRlc3RfYml0KFFMX01TSVhfRU5BQkxFRCwgJnFkZXYtPmZsYWdzKSkgeworCQkJ
aWYgKHRlc3RfYml0KFFMX01TSVhfRU5BQkxFRCwgJnFkZXYtPmZsYWdzKSkKIAkJCQlmcmVlX2ly
cShxZGV2LT5tc2lfeF9lbnRyeVtpXS52ZWN0b3IsCiAJCQkJCSAmcWRldi0+cnhfcmluZ1tpXSk7
Ci0JCQl9IGVsc2UgeworCQkJZWxzZQogCQkJCWZyZWVfaXJxKHFkZXYtPnBkZXYtPmlycSwgJnFk
ZXYtPnJ4X3JpbmdbMF0pOwotCQkJfQogCQl9CiAJfQogCXFsZ2VfZGlzYWJsZV9tc2l4KHFkZXYp
OwpAQCAtNDEyOCwyMiArNDEyNywyMSBAQCBzdGF0aWMgdm9pZCBxbGdlX3NldF9tdWx0aWNhc3Rf
bGlzdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikKIAlpZiAobmRldi0+ZmxhZ3MgJiBJRkZfUFJP
TUlTQykgewogCQlpZiAoIXRlc3RfYml0KFFMX1BST01JU0NVT1VTLCAmcWRldi0+ZmxhZ3MpKSB7
CiAJCQlpZiAocWxnZV9zZXRfcm91dGluZ19yZWcKLQkJCSAgICAocWRldiwgUlRfSURYX1BST01J
U0NVT1VTX1NMT1QsIFJUX0lEWF9WQUxJRCwgMSkpIHsKKwkJCSAgICAocWRldiwgUlRfSURYX1BS
T01JU0NVT1VTX1NMT1QsIFJUX0lEWF9WQUxJRCwgMSkpCiAJCQkJbmV0aWZfZXJyKHFkZXYsIGh3
LCBxZGV2LT5uZGV2LAogCQkJCQkgICJGYWlsZWQgdG8gc2V0IHByb21pc2N1b3VzIG1vZGUuXG4i
KTsKLQkJCX0gZWxzZSB7CisJCQllbHNlCiAJCQkJc2V0X2JpdChRTF9QUk9NSVNDVU9VUywgJnFk
ZXYtPmZsYWdzKTsKLQkJCX0KLQkJfQogCX0gZWxzZSB7CiAJCWlmICh0ZXN0X2JpdChRTF9QUk9N
SVNDVU9VUywgJnFkZXYtPmZsYWdzKSkgewotCQkJaWYgKHFsZ2Vfc2V0X3JvdXRpbmdfcmVnCi0J
CQkgICAgKHFkZXYsIFJUX0lEWF9QUk9NSVNDVU9VU19TTE9ULCBSVF9JRFhfVkFMSUQsIDApKSB7
CisJCQlpZiAocWxnZV9zZXRfcm91dGluZ19yZWcgKHFkZXYsCisJCQkJCQkgIFJUX0lEWF9QUk9N
SVNDVU9VU19TTE9ULAorCQkJCQkJICBSVF9JRFhfVkFMSUQsCisJCQkJCQkgIDApKQogCQkJCW5l
dGlmX2VycihxZGV2LCBodywgcWRldi0+bmRldiwKIAkJCQkJICAiRmFpbGVkIHRvIGNsZWFyIHBy
b21pc2N1b3VzIG1vZGUuXG4iKTsKLQkJCX0gZWxzZSB7CisJCQllbHNlCiAJCQkJY2xlYXJfYml0
KFFMX1BST01JU0NVT1VTLCAmcWRldi0+ZmxhZ3MpOwotCQkJfQogCQl9CiAJfQogCi0tIAoyLjM0
LjAKCg==
------=_Part_341183_1571019938.1638369549034--
