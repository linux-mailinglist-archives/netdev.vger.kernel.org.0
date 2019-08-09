Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115BD86F6D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405054AbfHIBmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:42:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHIBmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:42:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 139D11433DB63;
        Thu,  8 Aug 2019 18:42:38 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:42:37 -0700 (PDT)
Message-Id: <20190808.184237.1532563308186831482.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 00/17] Networking driver debugfs cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808.183756.2198405327467483431.davem@davemloft.net>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
        <20190808.183756.2198405327467483431.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:42:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAwOCBB
dWcgMjAxOSAxODozNzo1NiAtMDcwMCAoUERUKQ0KDQo+IEkgYXBwbGllZCB0aGlzIHdpdGhvdXQg
cGF0Y2ggIzE3IHdoaWNoIHlvdSBzYWlkIHlvdSB3b3VsZCByZXNwaW4gaW4gb3JkZXINCj4gdG8g
Z2V0IHJpZCBvZiB0aGUgbm93IHVudXNlZCBsb2NhbCB2YXJpYWJsZS4NCg0KQWN0dWFsbHksIHRo
ZXJlIGlzIGEgYnVuY2ggb2YgZmFsbG91dCBzdGlsbDoNCg0KZHJpdmVycy9uZXQvd2ltYXgvaTI0
MDBtL2RlYnVnZnMuYzogSW4gZnVuY3Rpb24goWkyNDAwbV9kZWJ1Z2ZzX2FkZKI6DQpkcml2ZXJz
L25ldC93aW1heC9pMjQwMG0vZGVidWdmcy5jOjE5MjoxNzogd2FybmluZzogdW51c2VkIHZhcmlh
YmxlIKFkZXaiIFstV3VudXNlZC12YXJpYWJsZV0NCiAgc3RydWN0IGRldmljZSAqZGV2ID0gaTI0
MDBtX2RldihpMjQwMG0pOw0KICAgICAgICAgICAgICAgICBefn4NCmRyaXZlcnMvbmV0L3dpbWF4
L2kyNDAwbS91c2IuYzogSW4gZnVuY3Rpb24goWkyNDAwbXVfZGVidWdmc19hZGSiOg0KZHJpdmVy
cy9uZXQvd2ltYXgvaTI0MDBtL3VzYi5jOjM3NToxNzogd2FybmluZzogdW51c2VkIHZhcmlhYmxl
IKFmZKIgWy1XdW51c2VkLXZhcmlhYmxlXQ0KICBzdHJ1Y3QgZGVudHJ5ICpmZDsNCiAgICAgICAg
ICAgICAgICAgXn4NCmRyaXZlcnMvbmV0L3dpbWF4L2kyNDAwbS91c2IuYzozNzM6MTc6IHdhcm5p
bmc6IHVudXNlZCB2YXJpYWJsZSChZGV2oiBbLVd1bnVzZWQtdmFyaWFibGVdDQogIHN0cnVjdCBk
ZXZpY2UgKmRldiA9ICZpMjQwMG11LT51c2JfaWZhY2UtPmRldjsNCiAgICAgICAgICAgICAgICAg
Xn5+DQpkcml2ZXJzL25ldC93aW1heC9pMjQwMG0vdXNiLmM6MzcyOjY6IHdhcm5pbmc6IHVudXNl
ZCB2YXJpYWJsZSChcmVzdWx0oiBbLVd1bnVzZWQtdmFyaWFibGVdDQogIGludCByZXN1bHQ7DQog
ICAgICBefn5+fn4NCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9kZWJ1Z2Zz
LmM6IEluIGZ1bmN0aW9uIKFpNDBlX2RiZ19wZl9pbml0ojoNCmRyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2k0MGUvaTQwZV9kZWJ1Z2ZzLmM6MTczNjoyMzogd2FybmluZzogdW51c2VkIHZhcmlh
YmxlIKFkZXaiIFstV3VudXNlZC12YXJpYWJsZV0NCiAgY29uc3Qgc3RydWN0IGRldmljZSAqZGV2
ID0gJnBmLT5wZGV2LT5kZXY7DQogICAgICAgICAgICAgICAgICAgICAgIF5+fg0KDQpUaGlzIGlz
IHdpdGg6DQoNCltkYXZlbUBsb2NhbGhvc3QgbmV0LW5leHRdJCBnY2MgLS12ZXJzaW9uDQpnY2Mg
KEdDQykgOC4zLjEgMjAxOTAyMjMgKFJlZCBIYXQgOC4zLjEtMikNCkNvcHlyaWdodCAoQykgMjAx
OCBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4NClRoaXMgaXMgZnJlZSBzb2Z0d2FyZTsg
c2VlIHRoZSBzb3VyY2UgZm9yIGNvcHlpbmcgY29uZGl0aW9ucy4gIFRoZXJlIGlzIE5PDQp3YXJy
YW50eTsgbm90IGV2ZW4gZm9yIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJ
Q1VMQVIgUFVSUE9TRS4NCg0KW2RhdmVtQGxvY2FsaG9zdCBuZXQtbmV4dF0kIA0KDQpTbyBJJ20g
cmV2ZXJ0aW5nLg0KDQpQbGVhc2UgcmVzcGluIHRoZSBzZXJpZXMgd2l0aCB0aGlzIHN0dWZmIGZp
eGVkLCB0aGFua3MgR3JlZy4NCg==
