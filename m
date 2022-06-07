Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DC753F583
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 07:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbiFGF2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 01:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiFGF2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 01:28:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F42A98A5;
        Mon,  6 Jun 2022 22:28:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 80EDA1F9F4;
        Tue,  7 Jun 2022 05:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654579719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=rg81TiujhMLmUuZodoAmrrDcPk8e0ct7YAcUKxC6kzc=;
        b=Z7rLus0YlSrBnGMwMQ0XumBby6FqnYi8nm9bhLlLXM4x3CvCuFFI2cj/u1I5dUQBoD23aG
        DVFBJjvnF84ECn8Oa9vDqqm59uUO4TQeaZhLvYedPjFwHaYfusHCadcSBi0/bHB+OiC8HM
        B+akrWVTi/SbbwMHrckYBZg1BV9Rj8A=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D8EA13A5F;
        Tue,  7 Jun 2022 05:28:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nZW5CQfinmJmVQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 07 Jun 2022 05:28:39 +0000
Message-ID: <6507870c-1c32-ebf6-f85f-4bf2ede41367@suse.com>
Date:   Tue, 7 Jun 2022 07:28:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   Juergen Gross <jgross@suse.com>
Subject: [PATCH Resend] xen/netback: do some code cleanup
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TQgRmYuvpfQLUkEYt03SVZJm"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TQgRmYuvpfQLUkEYt03SVZJm
Content-Type: multipart/mixed; boundary="------------WD09QCmLozusZfCQ3ECpvsB6";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
 Paul Durrant <paul@xen.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Message-ID: <6507870c-1c32-ebf6-f85f-4bf2ede41367@suse.com>
Subject: [PATCH Resend] xen/netback: do some code cleanup

--------------WD09QCmLozusZfCQ3ECpvsB6
Content-Type: multipart/mixed; boundary="------------u0JUY0dZL7ULrQJw0tfsC1fF"

--------------u0JUY0dZL7ULrQJw0tfsC1fF
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UmVtb3ZlIHNvbWUgdW51c2VkIG1hY3JvcyBhbmQgZnVuY3Rpb25zLCBtYWtlIGxvY2FsIGZ1
bmN0aW9ucyBzdGF0aWMuDQoNClNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9z
c0BzdXNlLmNvbT4NCkFja2VkLWJ5OiBXZWkgTGl1IDx3ZWkubGl1QGtlcm5lbC5vcmc+DQot
LS0NCiAgZHJpdmVycy9uZXQveGVuLW5ldGJhY2svY29tbW9uLmggICAgfCAxMiAtLS0tLS0t
LS0tLS0NCiAgZHJpdmVycy9uZXQveGVuLW5ldGJhY2svaW50ZXJmYWNlLmMgfCAxNiArLS0t
LS0tLS0tLS0tLS0tDQogIGRyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYyAgIHwg
IDQgKysrLQ0KICBkcml2ZXJzL25ldC94ZW4tbmV0YmFjay9yeC5jICAgICAgICB8ICAyICst
DQogIDQgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAyOSBkZWxldGlvbnMoLSkN
Cg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5oIGIvZHJp
dmVycy9uZXQveGVuLW5ldGJhY2svY29tbW9uLmgNCmluZGV4IGQ5ZGVhNDgyOWM4Ni4uODE3
NGQ3YjI5NjZjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svY29tbW9u
LmgNCisrKyBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2NvbW1vbi5oDQpAQCAtNDgsNyAr
NDgsNiBAQA0KICAjaW5jbHVkZSA8bGludXgvZGVidWdmcy5oPg0KICAgdHlwZWRlZiB1bnNp
Z25lZCBpbnQgcGVuZGluZ19yaW5nX2lkeF90Ow0KLSNkZWZpbmUgSU5WQUxJRF9QRU5ESU5H
X1JJTkdfSURYICh+MFUpDQogICBzdHJ1Y3QgcGVuZGluZ190eF9pbmZvIHsNCiAgCXN0cnVj
dCB4ZW5fbmV0aWZfdHhfcmVxdWVzdCByZXE7IC8qIHR4IHJlcXVlc3QgKi8NCkBAIC04Miw4
ICs4MSw2IEBAIHN0cnVjdCB4ZW52aWZfcnhfbWV0YSB7DQogIC8qIERpc2NyaW1pbmF0ZSBm
cm9tIGFueSB2YWxpZCBwZW5kaW5nX2lkeCB2YWx1ZS4gKi8NCiAgI2RlZmluZSBJTlZBTElE
X1BFTkRJTkdfSURYIDB4RkZGRg0KICAtI2RlZmluZSBNQVhfQlVGRkVSX09GRlNFVCBYRU5f
UEFHRV9TSVpFDQotDQogICNkZWZpbmUgTUFYX1BFTkRJTkdfUkVRUyBYRU5fTkVUSUZfVFhf
UklOR19TSVpFDQogICAvKiBUaGUgbWF4aW11bSBudW1iZXIgb2YgZnJhZ3MgaXMgZGVyaXZl
ZCBmcm9tIHRoZSBzaXplIG9mIGEgZ3JhbnQgKHNhbWUNCkBAIC0zNjcsMTEgKzM2NCw2IEBA
IHZvaWQgeGVudmlmX2ZyZWUoc3RydWN0IHhlbnZpZiAqdmlmKTsNCiAgaW50IHhlbnZpZl94
ZW5idXNfaW5pdCh2b2lkKTsNCiAgdm9pZCB4ZW52aWZfeGVuYnVzX2Zpbmkodm9pZCk7DQog
IC1pbnQgeGVudmlmX3NjaGVkdWxhYmxlKHN0cnVjdCB4ZW52aWYgKnZpZik7DQotDQotaW50
IHhlbnZpZl9xdWV1ZV9zdG9wcGVkKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKTsNCi12
b2lkIHhlbnZpZl93YWtlX3F1ZXVlKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKTsNCi0N
CiAgLyogKFVuKU1hcCBjb21tdW5pY2F0aW9uIHJpbmdzLiAqLw0KICB2b2lkIHhlbnZpZl91
bm1hcF9mcm9udGVuZF9kYXRhX3JpbmdzKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKTsN
CiAgaW50IHhlbnZpZl9tYXBfZnJvbnRlbmRfZGF0YV9yaW5ncyhzdHJ1Y3QgeGVudmlmX3F1
ZXVlICpxdWV1ZSwNCkBAIC0zOTQsNyArMzg2LDYgQEAgaW50IHhlbnZpZl9kZWFsbG9jX2t0
aHJlYWQodm9pZCAqZGF0YSk7DQogIGlycXJldHVybl90IHhlbnZpZl9jdHJsX2lycV9mbihp
bnQgaXJxLCB2b2lkICpkYXRhKTsNCiAgIGJvb2wgeGVudmlmX2hhdmVfcnhfd29yayhzdHJ1
Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSwgYm9vbCB0ZXN0X2t0aHJlYWQpOw0KLXZvaWQgeGVu
dmlmX3J4X2FjdGlvbihzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSk7DQogIHZvaWQgeGVu
dmlmX3J4X3F1ZXVlX3RhaWwoc3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUsIHN0cnVjdCBz
a19idWZmICpza2IpOw0KICAgdm9pZCB4ZW52aWZfY2Fycmllcl9vbihzdHJ1Y3QgeGVudmlm
ICp2aWYpOw0KQEAgLTQwMyw5ICszOTQsNiBAQCB2b2lkIHhlbnZpZl9jYXJyaWVyX29uKHN0
cnVjdCB4ZW52aWYgKnZpZik7DQogIHZvaWQgeGVudmlmX3plcm9jb3B5X2NhbGxiYWNrKHN0
cnVjdCBza19idWZmICpza2IsIHN0cnVjdCB1YnVmX2luZm8gKnVidWYsDQogIAkJCSAgICAg
IGJvb2wgemVyb2NvcHlfc3VjY2Vzcyk7DQogIC0vKiBVbm1hcCBhIHBlbmRpbmcgcGFnZSBh
bmQgcmVsZWFzZSBpdCBiYWNrIHRvIHRoZSBndWVzdCAqLw0KLXZvaWQgeGVudmlmX2lkeF91
bm1hcChzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSwgdTE2IHBlbmRpbmdfaWR4KTsNCi0N
CiAgc3RhdGljIGlubGluZSBwZW5kaW5nX3JpbmdfaWR4X3QgbnJfcGVuZGluZ19yZXFzKHN0
cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKQ0KICB7DQogIAlyZXR1cm4gTUFYX1BFTkRJTkdf
UkVRUyAtDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svaW50ZXJmYWNl
LmMgDQpiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNrL2ludGVyZmFjZS5jDQppbmRleCA4ZTAz
NTM3NGEzNzAuLmZiMzJhZTgyZDliMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3hlbi1u
ZXRiYWNrL2ludGVyZmFjZS5jDQorKysgYi9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9pbnRl
cmZhY2UuYw0KQEAgLTY5LDcgKzY5LDcgQEAgdm9pZCB4ZW52aWZfc2tiX3plcm9jb3B5X2Nv
bXBsZXRlKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKQ0KICAJd2FrZV91cCgmcXVldWUt
PmRlYWxsb2Nfd3EpOw0KICB9DQogIC1pbnQgeGVudmlmX3NjaGVkdWxhYmxlKHN0cnVjdCB4
ZW52aWYgKnZpZikNCitzdGF0aWMgaW50IHhlbnZpZl9zY2hlZHVsYWJsZShzdHJ1Y3QgeGVu
dmlmICp2aWYpDQogIHsNCiAgCXJldHVybiBuZXRpZl9ydW5uaW5nKHZpZi0+ZGV2KSAmJg0K
ICAJCXRlc3RfYml0KFZJRl9TVEFUVVNfQ09OTkVDVEVELCAmdmlmLT5zdGF0dXMpICYmDQpA
QCAtMTc3LDIwICsxNzcsNiBAQCBpcnFyZXR1cm5fdCB4ZW52aWZfaW50ZXJydXB0KGludCBp
cnEsIHZvaWQgKmRldl9pZCkNCiAgCXJldHVybiBJUlFfSEFORExFRDsNCiAgfQ0KICAtaW50
IHhlbnZpZl9xdWV1ZV9zdG9wcGVkKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKQ0KLXsN
Ci0Jc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHF1ZXVlLT52aWYtPmRldjsNCi0JdW5zaWdu
ZWQgaW50IGlkID0gcXVldWUtPmlkOw0KLQlyZXR1cm4gbmV0aWZfdHhfcXVldWVfc3RvcHBl
ZChuZXRkZXZfZ2V0X3R4X3F1ZXVlKGRldiwgaWQpKTsNCi19DQotDQotdm9pZCB4ZW52aWZf
d2FrZV9xdWV1ZShzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSkNCi17DQotCXN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYgPSBxdWV1ZS0+dmlmLT5kZXY7DQotCXVuc2lnbmVkIGludCBpZCA9
IHF1ZXVlLT5pZDsNCi0JbmV0aWZfdHhfd2FrZV9xdWV1ZShuZXRkZXZfZ2V0X3R4X3F1ZXVl
KGRldiwgaWQpKTsNCi19DQotDQogIHN0YXRpYyB1MTYgeGVudmlmX3NlbGVjdF9xdWV1ZShz
dHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KICAJCQkgICAg
ICAgc3RydWN0IG5ldF9kZXZpY2UgKnNiX2RldikNCiAgew0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYyBiL2RyaXZlcnMvbmV0L3hlbi1uZXRiYWNr
L25ldGJhY2suYw0KaW5kZXggZDkzODE0YzE0YTIzLi5mYzYxYTQ0MTg3MzcgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL25ldC94ZW4tbmV0YmFjay9uZXRiYWNrLmMNCisrKyBiL2RyaXZlcnMv
bmV0L3hlbi1uZXRiYWNrL25ldGJhY2suYw0KQEAgLTExMiw2ICsxMTIsOCBAQCBzdGF0aWMg
dm9pZCBtYWtlX3R4X3Jlc3BvbnNlKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlLA0KICAJ
CQkgICAgIHM4ICAgICAgIHN0KTsNCiAgc3RhdGljIHZvaWQgcHVzaF90eF9yZXNwb25zZXMo
c3RydWN0IHhlbnZpZl9xdWV1ZSAqcXVldWUpOw0KICArc3RhdGljIHZvaWQgeGVudmlmX2lk
eF91bm1hcChzdHJ1Y3QgeGVudmlmX3F1ZXVlICpxdWV1ZSwgdTE2IHBlbmRpbmdfaWR4KTsN
CisNCiAgc3RhdGljIGlubGluZSBpbnQgdHhfd29ya190b2RvKHN0cnVjdCB4ZW52aWZfcXVl
dWUgKnF1ZXVlKTsNCiAgIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBpZHhfdG9fcGZu
KHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlLA0KQEAgLTE0MTgsNyArMTQyMCw3IEBAIHN0
YXRpYyB2b2lkIHB1c2hfdHhfcmVzcG9uc2VzKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVl
KQ0KICAJCW5vdGlmeV9yZW1vdGVfdmlhX2lycShxdWV1ZS0+dHhfaXJxKTsNCiAgfQ0KICAt
dm9pZCB4ZW52aWZfaWR4X3VubWFwKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlLCB1MTYg
cGVuZGluZ19pZHgpDQorc3RhdGljIHZvaWQgeGVudmlmX2lkeF91bm1hcChzdHJ1Y3QgeGVu
dmlmX3F1ZXVlICpxdWV1ZSwgdTE2IHBlbmRpbmdfaWR4KQ0KICB7DQogIAlpbnQgcmV0Ow0K
ICAJc3RydWN0IGdudHRhYl91bm1hcF9ncmFudF9yZWYgdHhfdW5tYXBfb3A7DQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svcnguYyBiL2RyaXZlcnMvbmV0L3hlbi1u
ZXRiYWNrL3J4LmMNCmluZGV4IGRiYWM0YzAzZDIxYS4uOGRmMmM3MzZmZDIzIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQveGVuLW5ldGJhY2svcnguYw0KKysrIGIvZHJpdmVycy9uZXQv
eGVuLW5ldGJhY2svcnguYw0KQEAgLTQ4Niw3ICs0ODYsNyBAQCBzdGF0aWMgdm9pZCB4ZW52
aWZfcnhfc2tiKHN0cnVjdCB4ZW52aWZfcXVldWUgKnF1ZXVlKQ0KICAgI2RlZmluZSBSWF9C
QVRDSF9TSVpFIDY0DQogIC12b2lkIHhlbnZpZl9yeF9hY3Rpb24oc3RydWN0IHhlbnZpZl9x
dWV1ZSAqcXVldWUpDQorc3RhdGljIHZvaWQgeGVudmlmX3J4X2FjdGlvbihzdHJ1Y3QgeGVu
dmlmX3F1ZXVlICpxdWV1ZSkNCiAgew0KICAJc3RydWN0IHNrX2J1ZmZfaGVhZCBjb21wbGV0
ZWRfc2ticzsNCiAgCXVuc2lnbmVkIGludCB3b3JrX2RvbmUgPSAwOw0KLS0gDQoyLjM1LjMN
Cg0K
--------------u0JUY0dZL7ULrQJw0tfsC1fF
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------u0JUY0dZL7ULrQJw0tfsC1fF--

--------------WD09QCmLozusZfCQ3ECpvsB6--

--------------TQgRmYuvpfQLUkEYt03SVZJm
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmKe4gYFAwAAAAAACgkQsN6d1ii/Ey+3
mQgAic6FDHDgalJuzvf5gui7i7fCdePLfBzZJH6JE8qIckVEUk0q3d0ws4RJPkXpW7uI+ZSQWvYQ
11o7nd1TlU0vfBl8zw2eokh2OrosVEl+jpJ9XmCNFo0wrTPYZRHVvEKybR4gNsFhax0xpd70AcdG
RBKdbe1GpDv5FGNa503zSIvx98QdojIFmhQfWiXLPwzim2PeoG/5u27vrnIZ3RbPQP9lVKIkaCa6
dbg0Wwq/rx+MTOhsujOqbsK67idQC2/e9Xenic6OdoI4/FrN9oSmLFyqXZy8yTK4d+N25tfkPFzJ
+ZIVPUehziEq6suIoxLgMdbIiAPdQsBdFatm2XscFQ==
=emxx
-----END PGP SIGNATURE-----

--------------TQgRmYuvpfQLUkEYt03SVZJm--
