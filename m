Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D926C2C0E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjCUIMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCUIM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:12:29 -0400
Received: from mail-m312.qiye.163.com (mail-m312.qiye.163.com [103.74.31.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A77B447;
        Tue, 21 Mar 2023 01:12:17 -0700 (PDT)
Received: from ucloud.cn (unknown [127.0.0.1])
        by mail-m312.qiye.163.com (Hmail) with ESMTP id EF75180411;
        Tue, 21 Mar 2023 16:11:39 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AP2AlAA-I3id1jhRl3Q*8qr3.1.1679386299965.Hmail.mocan@ucloud.cn>
To:     faicker.mo@ucloud.cn
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSF0gbmV0L25ldF9mYWlsb3ZlcjogZml4IHF1ZXVlIGV4Y2VlZGluZyB3YXJuaW5n?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2015-163.com
X-Originating-IP: 106.75.220.2
MIME-Version: 1.0
Received: from mocan@ucloud.cn( [106.75.220.2) ] by ajax-webmail ( [127.0.0.1] ) ; Tue, 21 Mar 2023 16:11:39 +0800 (GMT+08:00)
From:   Faicker Mo <faicker.mo@ucloud.cn>
Date:   Tue, 21 Mar 2023 16:11:39 +0800 (GMT+08:00)
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMTnwvDqncMttaLoBi+EWdvVxqV7pHkTF0SPzZ8K4ssdJ85775Ka8PD56oQ1G/bqUvijlUj73D7BymlWQPFDLwFvrIsD09fhvVADqy0Ek9bxVVM3np1ZQCa0BHsaLw7LmODcpcOYxkK6s+HtA0lyXJ/8=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSh9KVk1CTk1NQ00dSk5CGlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUpLTVVMTlVJSUtVSVlXWRYaDxIVHRRZQVlPS0hVSkpLSEpDVUpLS1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQQ8JDh5XWRIfHhUPWUFZRzorSToXOjpWMkgSH0oREykXSCpR
        QwoJSFVKVUpNTEJIQ01IS0tIT0tVMxYaEhdVHRoSGBAeCVUWFDsOGBcUDh9VGBVFWVdZEgtZQVlK
        S01VTE5VSUlLVUlZV1kIAVlBT0NPTzcG
X-HM-Tid: 0a870337991100d2kurm186c12516a5
X-HM-MType: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiB0eCBmcm9tIHRoZSBuZXRfZmFpbG92ZXIgZGV2aWNlLCB0aGUgYWN0dWFsIHR4IHF1ZXVl
IG51bWJlciBpcyB0aGUgc2FsdmUgZGV2aWNlLgpUaGUgbmRvX3NlbGVjdF9xdWV1ZSBvZiBuZXRf
ZmFpbG92ZXIgZGV2aWNlIHJldHVybnMgdGhlIHR4cSB3aGljaCBpcyB0aGUgcHJpbWFyeSBkZXZp
Y2UgdHhxCmlmIHRoZSBwcmltYXJ5IGRldmljZSBpcyBPSy4KVGhpcyBudW1iZXIgbWF5IGJlIGJp
Z2dlciB0aGFuIHRoZSBkZWZhdWx0IDE2IG9mIHRoZSBuZXRfZmFpbG92ZXIgZGV2aWNlLgrCoEEg
d2FybmluZyB3aWxsIGJlIHJlcG9ydGVkIGluIG5ldGRldl9jYXBfdHhxdWV1ZSB3aGljaCBkZXZp
Y2UgaXMgdGhlIG5ldF9mYWlsb3Zlci4KCkZyb206IFBhdmFuIENoZWJiaSA8cGF2YW4uY2hlYmJp
QGJyb2FkY29tLmNvbT4KIERhdGU6IDIwMjMtMDMtMjEgMTM6MTE6NTIKVG86RmFpY2tlciBNbyA8
ZmFpY2tlci5tb0B1Y2xvdWQuY24+CiBjYzogU3JpZGhhciBTYW11ZHJhbGEgPHNyaWRoYXIuc2Ft
dWRyYWxhQGludGVsLmNvbT4sIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
LEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4sSmFrdWIgS2ljaW5za2kgPGt1YmFA
a2VybmVsLm9yZz4sUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPixuZXRkZXZAdmdlci5r
ZXJuZWwub3JnLGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKU3ViamVjdDogUmU6IFtQQVRD
SF0gbmV0L25ldF9mYWlsb3ZlcjogZml4IHF1ZXVlIGV4Y2VlZGluZyB3YXJuaW5nPk9uIFR1ZSwg
TWFyIDIxLCAyMDIzIGF0IDg6MTXigK9BTSBGYWlja2VyIE1vIDxmYWlja2VyLm1vQHVjbG91ZC5j
bj4gd3JvdGU6Cj4+Cj4+IElmIHRoZSBwcmltYXJ5IGRldmljZSBxdWV1ZSBudW1iZXIgaXMgYmln
Z2VyIHRoYW4gdGhlIGRlZmF1bHQgMTYsCj4+IHRoZXJlIGlzIGEgd2FybmluZyBhYm91dCB0aGUg
cXVldWUgZXhjZWVkaW5nIHdoZW4gdHggZnJvbSB0aGUKPj4gbmV0X2ZhaWxvdmVyIGRldmljZS4K
Pj4KPgo+Q2FuIHlvdSBkZXNjcmliZSB0aGUgaXNzdWUgbW9yZT8gSWYgdGhlIG5ldCBkZXZpY2Ug
aGFzIG5vdCBpbXBsZW1lbnRlZAo+aXRzIG93biBzZWxlY3Rpb24gdGhlbiBuZXRkZXZfcGlja190
eCBzaG91bGQgdGFrZSBjYXJlIG9mIHRoZQo+cmVhbF9udW1fdHhfcXVldWVzLgo+SXMgdGhhdCBu
b3QgaGFwcGVuaW5nPwo+Cj4+IFNpZ25lZC1vZmYtYnk6IEZhaWNrZXIgTW8gPGZhaWNrZXIubW9A
dWNsb3VkLmNuPgo+PiAtLS0KPj4gIGRyaXZlcnMvbmV0L25ldF9mYWlsb3Zlci5jIHwgOCArKy0t
LS0tLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkK
Pj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L25ldF9mYWlsb3Zlci5jIGIvZHJpdmVycy9u
ZXQvbmV0X2ZhaWxvdmVyLmMKPj4gaW5kZXggN2EyOGUwODI0MzZlLi5kMGM5MTZhNTNkN2MgMTAw
NjQ0Cj4+IC0tLSBhL2RyaXZlcnMvbmV0L25ldF9mYWlsb3Zlci5jCj4+ICsrKyBiL2RyaXZlcnMv
bmV0L25ldF9mYWlsb3Zlci5jCj4+IEBAIC0xMzAsMTQgKzEzMCwxMCBAQCBzdGF0aWMgdTE2IG5l
dF9mYWlsb3Zlcl9zZWxlY3RfcXVldWUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwKPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgdHhxID0gb3BzLT5uZG9fc2VsZWN0X3F1ZXVlKHByaW1hcnlfZGV2
LCBza2IsIHNiX2Rldik7Cj4+ICAgICAgICAgICAgICAgICBlbHNlCj4+ICAgICAgICAgICAgICAg
ICAgICAgICAgIHR4cSA9IG5ldGRldl9waWNrX3R4KHByaW1hcnlfZGV2LCBza2IsIE5VTEwpOwo+
PiAtCj4+IC0gICAgICAgICAgICAgICBxZGlzY19za2JfY2Ioc2tiKS0+c2xhdmVfZGV2X3F1ZXVl
X21hcHBpbmcgPSBza2ItPnF1ZXVlX21hcHBpbmc7Cj4+IC0KPj4gLSAgICAgICAgICAgICAgIHJl
dHVybiB0eHE7Cj4+ICsgICAgICAgfSBlbHNlIHsKPj4gKyAgICAgICAgICAgICAgIHR4cSA9IHNr
Yl9yeF9xdWV1ZV9yZWNvcmRlZChza2IpID8gc2tiX2dldF9yeF9xdWV1ZShza2IpIDogMDsKPj4g
ICAgICAgICB9Cj4+Cj4+IC0gICAgICAgdHhxID0gc2tiX3J4X3F1ZXVlX3JlY29yZGVkKHNrYikg
PyBza2JfZ2V0X3J4X3F1ZXVlKHNrYikgOiAwOwo+PiAtCj4+ICAgICAgICAgLyogU2F2ZSB0aGUg
b3JpZ2luYWwgdHhxIHRvIHJlc3RvcmUgYmVmb3JlIHBhc3NpbmcgdG8gdGhlIGRyaXZlciAqLwo+
PiAgICAgICAgIHFkaXNjX3NrYl9jYihza2IpLT5zbGF2ZV9kZXZfcXVldWVfbWFwcGluZyA9IHNr
Yi0+cXVldWVfbWFwcGluZzsKPj4KPj4gLS0KPj4gMi4zOS4xCj4+CgoKCg0KDQo=
