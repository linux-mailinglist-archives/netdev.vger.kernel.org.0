Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E372145
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391977AbfGWVHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:07:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36794 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbfGWVHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:07:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C976153BF12E;
        Tue, 23 Jul 2019 14:07:40 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:07:39 -0700 (PDT)
Message-Id: <20190723.140739.379654507424022463.davem@davemloft.net>
To:     skunberg.kelsey@gmail.com
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@helgaas.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] drivers: net: xgene: Remove acpi_has_method() calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723.140646.505566792140054611.davem@davemloft.net>
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
        <20190723185811.8548-1-skunberg.kelsey@gmail.com>
        <20190723.140646.505566792140054611.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:07:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVHVlLCAyMyBK
dWwgMjAxOSAxNDowNjo0NiAtMDcwMCAoUERUKQ0KDQo+IEZyb206IEtlbHNleSBTa3VuYmVyZyA8
c2t1bmJlcmcua2Vsc2V5QGdtYWlsLmNvbT4NCj4gRGF0ZTogVHVlLCAyMyBKdWwgMjAxOSAxMjo1
ODoxMSAtMDYwMA0KPiANCj4+IGFjcGlfZXZhbHVhdGVfb2JqZWN0IHdpbGwgYWxyZWFkeSByZXR1
cm4gYW4gZXJyb3IgaWYgdGhlIG5lZWRlZCBtZXRob2QNCj4+IGRvZXMgbm90IGV4aXN0LiBSZW1v
dmUgdW5uZWNlc3NhcnkgYWNwaV9oYXNfbWV0aG9kKCkgY2FsbHMgYW5kIGNoZWNrIHRoZQ0KPj4g
cmV0dXJuZWQgYWNwaV9zdGF0dXMgZm9yIGZhaWx1cmUgaW5zdGVhZC4NCj4+IA0KPj4gU2lnbmVk
LW9mZi1ieTogS2Vsc2V5IFNrdW5iZXJnIDxza3VuYmVyZy5rZWxzZXlAZ21haWwuY29tPg0KPj4g
LS0tDQo+PiBDaGFuZ2VzIGluIHYyOg0KPj4gCS0gRml4ZWQgd2hpdGUgc3BhY2Ugd2FybmluZ3Mg
YW5kIGVycm9ycw0KPiANCj4gQXBwbGllZCB0byBuZXQtbmV4dC4NCg0KV293IGRpZCB5b3UgZXZl
biBidWlsZCB0ZXN0IHRoaXM/ICAgUmV2ZXJ0ZWQuLi4NCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
YXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzogSW4gZnVuY3Rpb24goXhnZW5lX2VuZXRfcmVz
ZXSiOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvYXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzo0
ODA6MTM6IGVycm9yOiBpbnZhbGlkIHN0b3JhZ2UgY2xhc3MgZm9yIGZ1bmN0aW9uIKF4Z2VuZV9l
bmV0X2NsZV9ieXBhc3OiDQogc3RhdGljIHZvaWQgeGdlbmVfZW5ldF9jbGVfYnlwYXNzKHN0cnVj
dCB4Z2VuZV9lbmV0X3BkYXRhICpwLA0KICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+
fg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvYXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzo0ODA6
MTogd2FybmluZzogSVNPIEM5MCBmb3JiaWRzIG1peGVkIGRlY2xhcmF0aW9ucyBhbmQgY29kZSBb
LVdkZWNsYXJhdGlvbi1hZnRlci1zdGF0ZW1lbnRdDQogc3RhdGljIHZvaWQgeGdlbmVfZW5ldF9j
bGVfYnlwYXNzKHN0cnVjdCB4Z2VuZV9lbmV0X3BkYXRhICpwLA0KIF5+fn5+fg0KZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzo1MDY6MTM6IGVycm9yOiBp
bnZhbGlkIHN0b3JhZ2UgY2xhc3MgZm9yIGZ1bmN0aW9uIKF4Z2VuZV9lbmV0X2NsZWFyog0KIHN0
YXRpYyB2b2lkIHhnZW5lX2VuZXRfY2xlYXIoc3RydWN0IHhnZW5lX2VuZXRfcGRhdGEgKnBkYXRh
LA0KICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn4NCmRyaXZlcnMvbmV0L2V0aGVybmV0L2Fw
bS94Z2VuZS94Z2VuZV9lbmV0X3NnbWFjLmM6NTIyOjEzOiBlcnJvcjogaW52YWxpZCBzdG9yYWdl
IGNsYXNzIGZvciBmdW5jdGlvbiCheGdlbmVfZW5ldF9zaHV0ZG93bqINCiBzdGF0aWMgdm9pZCB4
Z2VuZV9lbmV0X3NodXRkb3duKHN0cnVjdCB4Z2VuZV9lbmV0X3BkYXRhICpwKQ0KICAgICAgICAg
ICAgIF5+fn5+fn5+fn5+fn5+fn5+fn4NCmRyaXZlcnMvbmV0L2V0aGVybmV0L2FwbS94Z2VuZS94
Z2VuZV9lbmV0X3NnbWFjLmM6NTMyOjEzOiBlcnJvcjogaW52YWxpZCBzdG9yYWdlIGNsYXNzIGZv
ciBmdW5jdGlvbiCheGdlbmVfZW5ldF9saW5rX3N0YXRlog0KIHN0YXRpYyB2b2lkIHhnZW5lX2Vu
ZXRfbGlua19zdGF0ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQogICAgICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fn5+fn5+DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9hcG0veGdlbmUveGdlbmVf
ZW5ldF9zZ21hYy5jOjU2MzoxMzogZXJyb3I6IGludmFsaWQgc3RvcmFnZSBjbGFzcyBmb3IgZnVu
Y3Rpb24goXhnZW5lX3NnbWFjX2VuYWJsZV90eF9wYXVzZaINCiBzdGF0aWMgdm9pZCB4Z2VuZV9z
Z21hY19lbmFibGVfdHhfcGF1c2Uoc3RydWN0IHhnZW5lX2VuZXRfcGRhdGEgKnAsIGJvb2wgZW5h
YmxlKQ0KICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzo2MDQ6MTogZXJyb3I6IGV4
cGVjdGVkIGRlY2xhcmF0aW9uIG9yIHN0YXRlbWVudCBhdCBlbmQgb2YgaW5wdXQNCiB9Ow0KIF4N
CmRyaXZlcnMvbmV0L2V0aGVybmV0L2FwbS94Z2VuZS94Z2VuZV9lbmV0X3NnbWFjLmM6NTk5OjI5
OiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUgoXhnZW5lX3NncG9ydF9vcHOiIFstV3VudXNlZC12
YXJpYWJsZV0NCiBjb25zdCBzdHJ1Y3QgeGdlbmVfcG9ydF9vcHMgeGdlbmVfc2dwb3J0X29wcyA9
IHsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fg0KZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzo1ODI6Mjg6IHdhcm5p
bmc6IHVudXNlZCB2YXJpYWJsZSCheGdlbmVfc2dtYWNfb3BzoiBbLVd1bnVzZWQtdmFyaWFibGVd
DQogY29uc3Qgc3RydWN0IHhnZW5lX21hY19vcHMgeGdlbmVfc2dtYWNfb3BzID0gew0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fg0KQXQgdG9wIGxldmVsOg0KZHJp
dmVycy9uZXQvZXRoZXJuZXQvYXBtL3hnZW5lL3hnZW5lX2VuZXRfc2dtYWMuYzo0Mzc6MTI6IHdh
cm5pbmc6IKF4Z2VuZV9lbmV0X3Jlc2V0oiBkZWZpbmVkIGJ1dCBub3QgdXNlZCBbLVd1bnVzZWQt
ZnVuY3Rpb25dDQogc3RhdGljIGludCB4Z2VuZV9lbmV0X3Jlc2V0KHN0cnVjdCB4Z2VuZV9lbmV0
X3BkYXRhICpwKQ0KICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fg0K
